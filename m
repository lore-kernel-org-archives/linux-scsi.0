From: Joe Eykholt <fcoe@eykholt.com>
Subject: [OpenFCoE] [PATCH] Performance improvement, combine received data
 copy with CRC.
Date: Fri, 30 Nov 2007 10:42:24 -0800
Message-ID: <47505990.7010803@eykholt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:46226 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764097AbXK3SmP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Nov 2007 13:42:15 -0500
Received: from 67.91.200.194 ([67.91.200.194]) by eykholt.com for <linux-scsi@vger.kernel.org>; Fri, 30 Nov 2007 10:42:13 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Performance improvement, combine received data copy with CRC.

---
 drivers/scsi/ofc/openfc/openfc_scsi.c |  130 +++++++++++++++++++++++----------
 1 files changed, 90 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
index 5fa0ad6..51ca6ee 100644
--- a/drivers/scsi/ofc/openfc/openfc_scsi.c
+++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
@@ -62,7 +62,6 @@ static void openfc_tm_done(struct fc_seq *, struct fc_frame *, void *);
 static void openfc_scsi_error(enum fc_event, void *);
 static int openfc_abort_internal(struct fcdev *, struct fc_scsi_pkt *,
                                 struct fc_frame *);
-int openfc_cp_to_user(struct fc_scsi_pkt *, uint, void *, int);
 void openfc_scsi_cleanup(struct fc_scsi_pkt *);
 static void openfc_timeout_error(struct fc_scsi_pkt *);
 void openfc_scsi_rec_rcv(struct fc_seq *, struct fc_frame *, void *);
@@ -102,9 +101,13 @@ static void openfc_scsi_recv_data(struct fc_scsi_pkt *fsp, struct fc_frame *fp)
        struct fcoe_dev_stats *sp;
        struct fc_frame_header *fh;
        size_t offset;
+       u32 crc;
+       u32 copy_len = 0;
        size_t len;
        void *buf;

+       if (!sc->request_buffer)
+               return;                 /* XXX possible? */
        fh = fc_frame_header_get(fp);
        offset = net32_get(&fh->fh_parm_offset);
        len = fp->fr_len - sizeof(*fh);
@@ -115,13 +118,8 @@ static void openfc_scsi_recv_data(struct fc_scsi_pkt *fsp, struct fc_frame *fp)
                 * this should never happen
                 */
                if ((fp->fr_flags & FCPHF_CRC_UNCHECKED) &&
-                   fc_frame_crc_check(fp)) {
-                       sp = openfcp->fd.dev_stats[smp_processor_id()];
-                       sp->ErrorFrames++;
-                       if (sp->InvalidCRCCount++ < 5)
-                               SA_LOG("CRC error on data frame");
-                       return; /* just ignore the frame */
-               }
+                   fc_frame_crc_check(fp))
+                       goto crc_err;
                if (openfc_debug) {
                        SA_LOG("data received past end.  "
                               "len %zx offset %zx "
@@ -130,42 +128,95 @@ static void openfc_scsi_recv_data(struct fc_scsi_pkt *fsp, struct fc_frame *fp)
                openfc_scsi_retry(fsp);
                return;
        }
-
-       /*
-        * Eventually, do scatter/gather buffer system to avoid
-        * this copy.  A NULL buffer means we discard the data.
-        */
+       crc = 0;
        if (sc->use_sg) {
-               len = openfc_cp_to_user(fsp, offset, buf, len);
-               ASSERT_NOTIMPL(len > 0);
-       } else if (sc->request_buffer != NULL) {
-               __memcpy((void *)sc->request_buffer + offset, buf, len);
-       }
+               struct scatterlist *sg;
+               struct scatterlist *sg_limit;
+               size_t remaining, sg_bytes;
+               size_t off;
+               void *page_addr;

-       /*
-        * If the lower layer didn't do the CRC check, do it here.
-        * This is the only type of frame the transport might not check.
-        * Eventually we could do the CRC calculation during the copy above.
-        */
-       if ((fp->fr_flags & FCPHF_CRC_UNCHECKED) && fc_frame_crc_check(fp)) {
-               sp = openfcp->fd.dev_stats[smp_processor_id()];
-               sp->ErrorFrames++;
-               if (sp->InvalidCRCCount++ < 5)
-                       SA_LOG("CRC error on data frame");
+               if (fp->fr_flags & FCPHF_CRC_UNCHECKED)
+                       crc = crc32_sb8_64_bit(~0, (u8 *) fh, sizeof(*fh));

-               /*
-                * Assume the frame is total garbage.
-                * We may have copied it over the good part of the buffer.
-                * If so, we need to retry the entire operation.
-                * Otherwise, ignore it.
-                */
-               if (offset < fsp->xfer_len)
-                       openfc_scsi_retry(fsp);
-               return;
-       }
+               sg = (struct scatterlist *)sc->request_buffer;
+               sg_limit = sg + sc->use_sg;
+               remaining = len;

-       fsp->xfer_len += len;
+               while (remaining > 0 && sg < sg_limit) {
+                       if (offset >= sg->length) {
+                               offset -= sg->length;
+                               sg++;
+                               continue;
+                       }
+                       sg_bytes = min(remaining, sg->length - offset);

+                       /*
+                        * The scatterlist item may be bigger than PAGE_SIZE,
+                        * but we are limited to mapping PAGE_SIZE at a time.
+                        */
+                       off = offset + sg->offset;
+                       sg_bytes = min(sg_bytes,
+                                      (PAGE_SIZE - (off & ~PAGE_MASK)));
+                       page_addr = kmap_atomic(sg_page(sg) +
+                                               (off >> PAGE_SHIFT),
+                                               KM_SOFTIRQ0);
+                       if (!page_addr)
+                               break;          /* XXX panic? */
+
+                       if (fsp->state != OPENFC_SRB_ABORT_PENDING) {
+                               if (fp->fr_flags & FCPHF_CRC_UNCHECKED) {
+                                       crc = crc32_copy(crc,
+                                                        (char *)page_addr +
+                                                        (off & ~PAGE_MASK),
+                                                        buf, sg_bytes);
+                               } else {
+                                       __memcpy((char *)page_addr +
+                                                (off & ~PAGE_MASK),
+                                                buf, sg_bytes);
+                               }
+                       }
+                       kunmap_atomic(page_addr, KM_SOFTIRQ0);
+                       buf += sg_bytes;
+                       offset += sg_bytes;
+                       remaining -= sg_bytes;
+                       copy_len += sg_bytes;
+               }
+               if (fp->fr_flags & FCPHF_CRC_UNCHECKED)
+                       goto crc_check;
+       } else if (fp->fr_flags & FCPHF_CRC_UNCHECKED) {
+               crc = crc32_sb8_64_bit(~0, (u8 *)fh, sizeof(*fh));
+               crc = crc32_copy(crc, (void *)sc->request_buffer + offset,
+                                buf, len);
+               copy_len = len;
+crc_check:
+               buf = fc_frame_payload_get(fp, 0);
+               if (len % 4) {
+                       crc = crc32_sb8_64_bit(crc, buf + len, 4 - (len % 4));
+                       len += 4 - (len % 4);
+               }
+               if (~crc != le32_to_cpu(* (__le32 *) (buf + len))) {
+crc_err:
+                       sp = openfcp->fd.dev_stats[smp_processor_id()];
+                       sp->ErrorFrames++;
+                       if (sp->InvalidCRCCount++ < 5)
+                               SA_LOG("CRC error on data frame");
+                       /*
+                        * Assume the frame is total garbage.
+                        * We may have copied it over the good part
+                        * of the buffer.
+                        * If so, we need to retry the entire operation.
+                        * Otherwise, ignore it.
+                        */
+                       if (offset < fsp->xfer_len)
+                               openfc_scsi_retry(fsp);
+                       return;
+               }
+       } else {
+               __memcpy((void *)sc->request_buffer + offset, buf, len);
+               copy_len = len;
+       }
+       fsp->xfer_len += copy_len;
        if (fsp->xfer_len == fsp->data_len)
                fsp->state = OPENFC_SRB_WAIT_FOR_STATUS;
 }
@@ -317,7 +368,6 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,

        if (fsp->xfer_len == fsp->data_len)
                fsp->state = OPENFC_SRB_WAIT_FOR_STATUS;
-       return;
 }

 /*
--
1.5.3.6
