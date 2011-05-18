From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [RFC v2 PATCH 1/2] bsg: Add infrastructure to send in kernel bsg
 commands.
Date: Wed, 18 May 2011 14:47:13 -0400
Message-ID: <alpine.LFD.2.02.1105181445490.7238@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:43198
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933460Ab1ERSrT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 14:47:19 -0400
Received: from mail173-ch1 (localhost.localdomain [127.0.0.1])	by
 mail173-ch1-R.bigfish.com (Postfix) with ESMTP id 6C3C5151045E	for
 <linux-scsi@vger.kernel.org>; Wed, 18 May 2011 18:47:18 +0000 (UTC)
Received: from CH1EHSMHS006.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.246])	by mail173-ch1.bigfish.com (Postfix) with ESMTP id
 C6B44FC0052	for <linux-scsi@vger.kernel.org>; Wed, 18 May 2011 18:47:17 +0000
 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

This patch adds a new exported function, bsg_private_command(), and a few
supporting functions that allow a device driver or other kernel code to be
able to send bsg commands from within the kernel using sg_io_v4.  The private
command infrastructure mimics the ioctl interface except that the bsg request
queue needs to be explicitly passed in.

The helper functions are similar to the bsg_map_hdr() function except that
no bsg_device is needed and kernel buffers are used instead of user buffers.
This was done so that the current semantics of user space bsg calls would
remain undisturbed, to avoid the complications of mixing user vs. kernel
buffers and not having to create a dummy bsg device for each command submitted.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
  block/bsg.c         |  207 +++++++++++++++++++++++++++++++++++++++++++++++++++
  include/linux/bsg.h |    1 +
  2 files changed, 208 insertions(+), 0 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 0c8b64a..3d8afc2 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -88,6 +88,13 @@ struct bsg_command {
        char sense[SCSI_SENSE_BUFFERSIZE];
  };

+static int blk_fill_sgv4_hdr_rq_priv(struct request_queue *, struct request *,
+       struct sg_io_v4 *, fmode_t);
+static struct request *bsg_map_hdr_priv(struct request_queue *,
+       struct sg_io_v4 *, fmode_t, u8 *);
+static int blk_complete_sgv4_hdr_rq_priv(struct request *, struct sg_io_v4 *,
+       struct bio *, struct bio *);
+
  static void bsg_free_command(struct bsg_command *bc)
  {
        struct bsg_device *bd = bc->bd;
@@ -965,6 +972,206 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
        }
  }

+/*
+ * Functions to send in-kernel bsg commands.
+ */
+static int blk_fill_sgv4_hdr_rq_priv(struct request_queue *q,
+                               struct request *rq, struct sg_io_v4 *hdr,
+                               fmode_t has_write_perm)
+{
+       if (hdr->request_len > BLK_MAX_CDB) {
+               rq->cmd = kzalloc(hdr->request_len, GFP_KERNEL);
+               if (!rq->cmd)
+                       return -ENOMEM;
+       }
+
+       memcpy(rq->cmd, (void *)(unsigned long)hdr->request, hdr->request_len);
+
+       if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
+               if (blk_verify_command(rq->cmd, has_write_perm))
+                       return -EPERM;
+       } else if (!capable(CAP_SYS_RAWIO))
+               return -EPERM;
+
+       /*
+        * fill in request structure
+        */
+       rq->cmd_len = hdr->request_len;
+       rq->cmd_type = REQ_TYPE_BLOCK_PC;
+
+       rq->timeout = msecs_to_jiffies(hdr->timeout);
+       if (!rq->timeout)
+               rq->timeout = q->sg_timeout;
+       if (!rq->timeout)
+               rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
+       if (rq->timeout < BLK_MIN_SG_TIMEOUT)
+               rq->timeout = BLK_MIN_SG_TIMEOUT;
+
+       return 0;
+}
+
+static struct request *
+bsg_map_hdr_priv(struct request_queue *q, struct sg_io_v4 *hdr,
+               fmode_t has_write_perm, u8 *sense)
+{
+       struct request *rq, *next_rq = NULL;
+       int ret, rw;
+       unsigned int dxfer_len;
+       void *dxferp = NULL;
+
+       dprintk("map hdr priv %llx/%u %llx/%u\n",
+           (unsigned long long) hdr->dout_xferp, hdr->dout_xfer_len,
+               (unsigned long long) hdr->din_xferp, hdr->din_xfer_len);
+
+       ret = bsg_validate_sgv4_hdr(q, hdr, &rw);
+       if (ret)
+               return ERR_PTR(ret);
+
+       /*
+        * map scatter-gather elements separately and string them to request
+        */
+       rq = blk_get_request(q, rw, GFP_KERNEL);
+       if (!rq)
+               return ERR_PTR(-ENOMEM);
+       ret = blk_fill_sgv4_hdr_rq_priv(q, rq, hdr, has_write_perm);
+       if (ret)
+               goto out;
+
+       if (rw == WRITE && hdr->din_xfer_len) {
+               if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
+                       ret = -EOPNOTSUPP;
+                       goto out;
+               }
+
+               next_rq = blk_get_request(q, READ, GFP_KERNEL);
+               if (!next_rq) {
+                       ret = -ENOMEM;
+                       goto out;
+               }
+               rq->next_rq = next_rq;
+               next_rq->cmd_type = rq->cmd_type;
+
+               dxferp = (void*)(unsigned long)hdr->din_xferp;
+               ret =  blk_rq_map_kern(q, next_rq, dxferp, hdr->din_xfer_len,
+                                      GFP_KERNEL);
+               if (ret)
+                       goto out;
+       }
+
+       if (hdr->dout_xfer_len) {
+               dxfer_len = hdr->dout_xfer_len;
+               dxferp = (void*)(unsigned long)hdr->dout_xferp;
+       } else if (hdr->din_xfer_len) {
+               dxfer_len = hdr->din_xfer_len;
+               dxferp = (void*)(unsigned long)hdr->din_xferp;
+       } else
+               dxfer_len = 0;
+
+       if (dxfer_len) {
+               ret = blk_rq_map_kern(q, rq, dxferp, dxfer_len, GFP_KERNEL);
+               if (ret)
+                       goto out;
+       }
+
+       rq->sense = sense;
+       rq->sense_len = 0;
+
+       return rq;
+out:
+       if (rq->cmd != rq->__cmd)
+               kfree(rq->cmd);
+       blk_put_request(rq);
+       if (next_rq) {
+               blk_put_request(next_rq);
+       }
+       return ERR_PTR(ret);
+}
+
+static int blk_complete_sgv4_hdr_rq_priv(struct request *rq,
+                                       struct sg_io_v4 *hdr, struct bio *bio,
+                                       struct bio *bidi_bio)
+{
+       int ret = 0;
+
+       dprintk("rq %p bio %p 0x%x\n", rq, bio, rq->errors);
+       /*
+        * fill in all the output members
+        */
+       hdr->device_status = rq->errors & 0xff;
+       hdr->transport_status = host_byte(rq->errors);
+       hdr->driver_status = driver_byte(rq->errors);
+       hdr->info = 0;
+       if (hdr->device_status || hdr->transport_status || hdr->driver_status)
+               hdr->info |= SG_INFO_CHECK;
+       hdr->response_len = 0;
+
+       if (rq->sense_len && hdr->response) {
+               int len = min_t(unsigned int, hdr->max_response_len,
+                   rq->sense_len);
+
+               memcpy((void*)(unsigned long)hdr->response, rq->sense, len);
+               hdr->response_len = len;
+       }
+
+       if (rq->next_rq) {
+               hdr->dout_resid = rq->resid_len;
+               hdr->din_resid = rq->next_rq->resid_len;
+               blk_put_request(rq->next_rq);
+       } else if (rq_data_dir(rq) == READ)
+               hdr->din_resid = rq->resid_len;
+       else
+               hdr->dout_resid = rq->resid_len;
+
+       /*
+        * If the request generated a negative error number, return it
+        * (providing we aren't already returning an error); if it's
+        * just a protocol response (i.e. non negative), that gets
+        * processed above.
+        */
+       if (!ret && rq->errors < 0)
+               ret = rq->errors;
+
+       if (rq->cmd != rq->__cmd)
+               kfree(rq->cmd);
+       blk_put_request(rq);
+
+       return ret;
+}
+
+int bsg_private_command (struct request_queue *q, struct sg_io_v4 *hdr)
+{
+       struct request *rq;
+       struct bio *bio, *bidi_bio = NULL;
+       int at_head;
+       u8 sense[SCSI_SENSE_BUFFERSIZE];
+       fmode_t has_write_perm = 0;
+       int ret;
+
+       if (!q)
+               return -ENXIO;
+
+       /* Fake that we have write permission */
+       has_write_perm |= FMODE_WRITE;
+
+       rq = bsg_map_hdr_priv(q, hdr, has_write_perm, sense);
+
+       if (IS_ERR(rq)) {
+               return PTR_ERR(rq);
+       }
+
+       bio = rq->bio;
+       if (rq->next_rq)
+               bidi_bio = rq->next_rq->bio;
+
+       at_head = (0 == (hdr->flags & BSG_FLAG_Q_AT_TAIL));
+
+       blk_execute_rq(q, NULL, rq, at_head);
+       ret = blk_complete_sgv4_hdr_rq_priv(rq, hdr, bio, bidi_bio);
+
+       return ret;
+}
+EXPORT_SYMBOL(bsg_private_command);
+
  static const struct file_operations bsg_fops = {
        .read           =       bsg_read,
        .write          =       bsg_write,
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index ecb4730..60adc01 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -77,6 +77,7 @@ extern int bsg_register_queue(struct request_queue *q,
                              struct device *parent, const char *name,
                              void (*release)(struct device *));
  extern void bsg_unregister_queue(struct request_queue *);
+extern int bsg_private_command (struct request_queue *, struct sg_io_v4 *);
  #else
  static inline int bsg_register_queue(struct request_queue *q,
                                     struct device *parent, const char *name,
--
1.7.0.31.g1df487


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

