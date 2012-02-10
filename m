From: Cong Wang <amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 21/60] scsi: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:42 +0800
Message-ID: <1328852421-19678-22-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCPuPwefDHRC8n9b5BBoEeOKLxQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cong Wang <amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Bhanu Prakash Gollapudi <bprakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Achim Leubner <achim_leubner-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>, Adaptec OEM Raid Solutions <aacraid-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>, Dave Jeffery <ipslinux-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org>, Intel SCU Linux support <intel-linux-scu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ed Nadolski <edmund.nadolski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Neela Syam Kolli <megaraidlinux-M7mHMAq9Yzo@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Tomas henzl <thenzl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Nick Cheng <nick.cheng-ojgj0hWszvWnedCIQ9mT8A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Cong Wang <amwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c   |    8 ++++----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  |    5 ++---
 drivers/scsi/cxgbi/libcxgbi.c      |    5 ++---
 drivers/scsi/fcoe/fcoe.c           |    4 ++--
 drivers/scsi/fcoe/fcoe_transport.c |    5 ++---
 drivers/scsi/gdth.c                |    4 ++--
 drivers/scsi/ips.c                 |    6 +++---
 drivers/scsi/isci/request.c        |   16 ++++++++--------
 drivers/scsi/libfc/fc_fcp.c        |    8 ++++----
 drivers/scsi/libfc/fc_libfc.c      |    8 +++-----
 drivers/scsi/libfc/fc_libfc.h      |    2 +-
 drivers/scsi/libfc/fc_lport.c      |    2 +-
 drivers/scsi/libiscsi_tcp.c        |    4 ++--
 drivers/scsi/libsas/sas_host_smp.c |    8 ++++----
 drivers/scsi/megaraid.c            |    4 ++--
 drivers/scsi/mvsas/mv_sas.c        |    4 ++--
 drivers/scsi/scsi_debug.c          |   24 ++++++++++++------------
 drivers/scsi/scsi_lib.c            |    4 ++--
 drivers/scsi/sd_dif.c              |   12 ++++++------
 19 files changed, 64 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f980600..2fe9e90 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1736,7 +1736,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 						(uint32_t ) cmd->cmnd[8];
 						/* 4 bytes: Areca io control code */
 	sg = scsi_sglist(cmd);
-	buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+	buffer = kmap_atomic(sg_page(sg)) + sg->offset;
 	if (scsi_sg_count(cmd) > 1) {
 		retvalue = ARCMSR_MESSAGE_FAIL;
 		goto message_out;
@@ -1985,7 +1985,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 	}
 	message_out:
 	sg = scsi_sglist(cmd);
-	kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+	kunmap_atomic(buffer - sg->offset);
 	return retvalue;
 }
 
@@ -2035,11 +2035,11 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */
 
 		sg = scsi_sglist(cmd);
-		buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+		buffer = kmap_atomic(sg_page(sg)) + sg->offset;
 
 		memcpy(buffer, inqdata, sizeof(inqdata));
 		sg = scsi_sglist(cmd);
-		kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+		kunmap_atomic(buffer - sg->offset);
 
 		cmd->scsi_done(cmd);
 	}
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 8c6156a..a9af42e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -322,8 +322,7 @@ static int bnx2fc_xmit(struct fc_lport *lport, struct fc_frame *fp)
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
-		cp = kmap_atomic(skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ)
-				+ frag->page_offset;
+		cp = kmap_atomic(skb_frag_page(frag)) + frag->page_offset;
 	} else {
 		cp = (struct fcoe_crc_eof *)skb_put(skb, tlen);
 	}
@@ -332,7 +331,7 @@ static int bnx2fc_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	cp->fcoe_eof = eof;
 	cp->fcoe_crc32 = cpu_to_le32(~crc);
 	if (skb_is_nonlinear(skb)) {
-		kunmap_atomic(cp, KM_SKB_DATA_SOFTIRQ);
+		kunmap_atomic(cp);
 		cp = NULL;
 	}
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index d3ff9cd..89afd6d 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1956,12 +1956,11 @@ int cxgbi_conn_init_pdu(struct iscsi_task *task, unsigned int offset,
 
 			/* data fits in the skb's headroom */
 			for (i = 0; i < tdata->nr_frags; i++, frag++) {
-				char *src = kmap_atomic(frag->page,
-							KM_SOFTIRQ0);
+				char *src = kmap_atomic(frag->page);
 
 				memcpy(dst, src+frag->offset, frag->size);
 				dst += frag->size;
-				kunmap_atomic(src, KM_SOFTIRQ0);
+				kunmap_atomic(src);
 			}
 			if (padlen) {
 				memset(dst, 0, padlen);
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index e959960..1094357 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1515,7 +1515,7 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 			return -ENOMEM;
 		}
 		frag = &skb_shinfo(skb)->frags[skb_shinfo(skb)->nr_frags - 1];
-		cp = kmap_atomic(skb_frag_page(frag), KM_SKB_DATA_SOFTIRQ)
+		cp = kmap_atomic(skb_frag_page(frag))
 			+ frag->page_offset;
 	} else {
 		cp = (struct fcoe_crc_eof *)skb_put(skb, tlen);
@@ -1526,7 +1526,7 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 	cp->fcoe_crc32 = cpu_to_le32(~crc);
 
 	if (skb_is_nonlinear(skb)) {
-		kunmap_atomic(cp, KM_SKB_DATA_SOFTIRQ);
+		kunmap_atomic(cp);
 		cp = NULL;
 	}
 
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index bd97b22..4d119a3 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -210,10 +210,9 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
 		while (len > 0) {
 			clen = min(len, PAGE_SIZE - (off & ~PAGE_MASK));
 			data = kmap_atomic(
-				skb_frag_page(frag) + (off >> PAGE_SHIFT),
-				KM_SKB_DATA_SOFTIRQ);
+				skb_frag_page(frag) + (off >> PAGE_SHIFT));
 			crc = crc32(crc, data + (off & ~PAGE_MASK), clen);
-			kunmap_atomic(data, KM_SKB_DATA_SOFTIRQ);
+			kunmap_atomic(data);
 			off += clen;
 			len -= clen;
 		}
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3242bca..d42ec92 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2310,10 +2310,10 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                 return;
             }
             local_irq_save(flags);
-            address = kmap_atomic(sg_page(sl), KM_BIO_SRC_IRQ) + sl->offset;
+            address = kmap_atomic(sg_page(sl)) + sl->offset;
             memcpy(address, buffer, cpnow);
             flush_dcache_page(sg_page(sl));
-            kunmap_atomic(address, KM_BIO_SRC_IRQ);
+            kunmap_atomic(address);
             local_irq_restore(flags);
             if (cpsum == cpcount)
                 break;
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index d77891e..b6d7a5c 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1511,14 +1511,14 @@ static int ips_is_passthru(struct scsi_cmnd *SC)
                 /* kmap_atomic() ensures addressability of the user buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+                buffer = kmap_atomic(sg_page(sg)) + sg->offset;
                 if (buffer && buffer[0] == 'C' && buffer[1] == 'O' &&
                     buffer[2] == 'P' && buffer[3] == 'P') {
-                        kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+                        kunmap_atomic(buffer - sg->offset);
                         local_irq_restore(flags);
                         return 1;
                 }
-                kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+                kunmap_atomic(buffer - sg->offset);
                 local_irq_restore(flags);
 	}
 	return 0;
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 192cb48..ee0dc05 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1304,9 +1304,9 @@ sci_stp_request_pio_data_in_copy_data_buffer(struct isci_stp_request *stp_req,
 			struct page *page = sg_page(sg);
 
 			copy_len = min_t(int, total_len, sg_dma_len(sg));
-			kaddr = kmap_atomic(page, KM_IRQ0);
+			kaddr = kmap_atomic(page);
 			memcpy(kaddr + sg->offset, src_addr, copy_len);
-			kunmap_atomic(kaddr, KM_IRQ0);
+			kunmap_atomic(kaddr);
 			total_len -= copy_len;
 			src_addr += copy_len;
 			sg = sg_next(sg);
@@ -1654,7 +1654,7 @@ sci_io_request_frame_handler(struct isci_request *ireq,
 		sci_unsolicited_frame_control_get_header(&ihost->uf_control,
 							 frame_index,
 							 &frame_header);
-		kaddr = kmap_atomic(sg_page(sg), KM_IRQ0);
+		kaddr = kmap_atomic(sg_page(sg));
 		rsp = kaddr + sg->offset;
 		sci_swab32_cpy(rsp, frame_header, 1);
 
@@ -1691,7 +1691,7 @@ sci_io_request_frame_handler(struct isci_request *ireq,
 			ireq->sci_status = SCI_FAILURE_CONTROLLER_SPECIFIC_IO_ERR;
 			sci_change_state(&ireq->sm, SCI_REQ_COMPLETED);
 		}
-		kunmap_atomic(kaddr, KM_IRQ0);
+		kunmap_atomic(kaddr);
 
 		sci_controller_release_frame(ihost, frame_index);
 
@@ -3023,10 +3023,10 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 		dma_unmap_sg(&ihost->pdev->dev, sg, 1, DMA_TO_DEVICE);
 
 		/* need to swab it back in case the command buffer is re-used */
-		kaddr = kmap_atomic(sg_page(sg), KM_IRQ0);
+		kaddr = kmap_atomic(sg_page(sg));
 		smp_req = kaddr + sg->offset;
 		sci_swab32_cpy(smp_req, smp_req, sg->length / sizeof(u32));
-		kunmap_atomic(kaddr, KM_IRQ0);
+		kunmap_atomic(kaddr);
 		break;
 	}
 	default:
@@ -3311,7 +3311,7 @@ sci_io_request_construct_smp(struct device *dev,
 	u8 req_len;
 	u32 cmd;
 
-	kaddr = kmap_atomic(sg_page(sg), KM_IRQ0);
+	kaddr = kmap_atomic(sg_page(sg));
 	smp_req = kaddr + sg->offset;
 	/*
 	 * Look at the SMP requests' header fields; for certain SAS 1.x SMP
@@ -3337,7 +3337,7 @@ sci_io_request_construct_smp(struct device *dev,
 	req_len = smp_req->req_len;
 	sci_swab32_cpy(smp_req, smp_req, sg->length / sizeof(u32));
 	cmd = *(u32 *) smp_req;
-	kunmap_atomic(kaddr, KM_IRQ0);
+	kunmap_atomic(kaddr);
 
 	if (!dma_map_sg(dev, sg, 1, DMA_TO_DEVICE))
 		return SCI_FAILURE;
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f607314..b577c90 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -485,11 +485,11 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 
 	if (!(fr_flags(fp) & FCPHF_CRC_UNCHECKED)) {
 		copy_len = fc_copy_buffer_to_sglist(buf, len, sg, &nents,
-						    &offset, KM_SOFTIRQ0, NULL);
+						    &offset, NULL);
 	} else {
 		crc = crc32(~0, (u8 *) fh, sizeof(*fh));
 		copy_len = fc_copy_buffer_to_sglist(buf, len, sg, &nents,
-						    &offset, KM_SOFTIRQ0, &crc);
+						    &offset, &crc);
 		buf = fc_frame_payload_get(fp, 0);
 		if (len % 4)
 			crc = crc32(crc, buf + len, 4 - (len % 4));
@@ -650,10 +650,10 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 			 * The scatterlist item may be bigger than PAGE_SIZE,
 			 * but we must not cross pages inside the kmap.
 			 */
-			page_addr = kmap_atomic(page, KM_SOFTIRQ0);
+			page_addr = kmap_atomic(page);
 			memcpy(data, (char *)page_addr + (off & ~PAGE_MASK),
 			       sg_bytes);
-			kunmap_atomic(page_addr, KM_SOFTIRQ0);
+			kunmap_atomic(page_addr);
 			data += sg_bytes;
 		}
 		offset += sg_bytes;
diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
index 1bf9841..8d65a51a 100644
--- a/drivers/scsi/libfc/fc_libfc.c
+++ b/drivers/scsi/libfc/fc_libfc.c
@@ -105,14 +105,13 @@ module_exit(libfc_exit);
  * @sg: pointer to the pointer of the SG list.
  * @nents: pointer to the remaining number of entries in the SG list.
  * @offset: pointer to the current offset in the SG list.
- * @km_type: dedicated page table slot type for kmap_atomic.
  * @crc: pointer to the 32-bit crc value.
  *	 If crc is NULL, CRC is not calculated.
  */
 u32 fc_copy_buffer_to_sglist(void *buf, size_t len,
 			     struct scatterlist *sg,
 			     u32 *nents, size_t *offset,
-			     enum km_type km_type, u32 *crc)
+			     u32 *crc)
 {
 	size_t remaining = len;
 	u32 copy_len = 0;
@@ -142,12 +141,11 @@ u32 fc_copy_buffer_to_sglist(void *buf, size_t len,
 		off = *offset + sg->offset;
 		sg_bytes = min(sg_bytes,
 			       (size_t)(PAGE_SIZE - (off & ~PAGE_MASK)));
-		page_addr = kmap_atomic(sg_page(sg) + (off >> PAGE_SHIFT),
-					km_type);
+		page_addr = kmap_atomic(sg_page(sg) + (off >> PAGE_SHIFT));
 		if (crc)
 			*crc = crc32(*crc, buf, sg_bytes);
 		memcpy((char *)page_addr + (off & ~PAGE_MASK), buf, sg_bytes);
-		kunmap_atomic(page_addr, km_type);
+		kunmap_atomic(page_addr);
 		buf += sg_bytes;
 		*offset += sg_bytes;
 		remaining -= sg_bytes;
diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index c7d0712..c2830cc 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -134,6 +134,6 @@ extern void fc_fc4_conf_lport_params(struct fc_lport *, enum fc_fh_type);
 u32 fc_copy_buffer_to_sglist(void *buf, size_t len,
 			     struct scatterlist *sg,
 			     u32 *nents, size_t *offset,
-			     enum km_type km_type, u32 *crc);
+			     u32 *crc);
 
 #endif /* _FC_LIBFC_H_ */
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 83750eb..c1a808c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1698,7 +1698,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	job->reply->reply_payload_rcv_len +=
 		fc_copy_buffer_to_sglist(buf, len, info->sg, &info->nents,
-					 &info->offset, KM_BIO_SRC_IRQ, NULL);
+					 &info->offset, NULL);
 
 	if (fr_eof(fp) == FC_EOF_T &&
 	    (ntoh24(fh->fh_f_ctl) & (FC_FC_LAST_SEQ | FC_FC_END_SEQ)) ==
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 5715a3d..7f0465b 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -135,7 +135,7 @@ static void iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
 
 	if (recv) {
 		segment->atomic_mapped = true;
-		segment->sg_mapped = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
+		segment->sg_mapped = kmap_atomic(sg_page(sg));
 	} else {
 		segment->atomic_mapped = false;
 		/* the xmit path can sleep with the page mapped so use kmap */
@@ -149,7 +149,7 @@ void iscsi_tcp_segment_unmap(struct iscsi_segment *segment)
 {
 	if (segment->sg_mapped) {
 		if (segment->atomic_mapped)
-			kunmap_atomic(segment->sg_mapped, KM_SOFTIRQ0);
+			kunmap_atomic(segment->sg_mapped);
 		else
 			kunmap(sg_page(segment->sg));
 		segment->sg_mapped = NULL;
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index bb8f492..3814d3e 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -246,9 +246,9 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 	}
 
 	local_irq_disable();
-	buf = kmap_atomic(bio_page(req->bio), KM_USER0) + bio_offset(req->bio);
+	buf = kmap_atomic(bio_page(req->bio));
 	memcpy(req_data, buf, blk_rq_bytes(req));
-	kunmap_atomic(buf - bio_offset(req->bio), KM_USER0);
+	kunmap_atomic(buf - bio_offset(req->bio));
 	local_irq_enable();
 
 	if (req_data[0] != SMP_REQUEST)
@@ -361,10 +361,10 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 	}
 
 	local_irq_disable();
-	buf = kmap_atomic(bio_page(rsp->bio), KM_USER0) + bio_offset(rsp->bio);
+	buf = kmap_atomic(bio_page(rsp->bio));
 	memcpy(buf, resp_data, blk_rq_bytes(rsp));
 	flush_kernel_dcache_page(bio_page(rsp->bio));
-	kunmap_atomic(buf - bio_offset(rsp->bio), KM_USER0);
+	kunmap_atomic(buf - bio_offset(rsp->bio));
 	local_irq_enable();
 
  out:
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 15eefa1..4d39a9f 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -670,10 +670,10 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 			struct scatterlist *sg;
 
 			sg = scsi_sglist(cmd);
-			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
+			buf = kmap_atomic(sg_page(sg)) + sg->offset;
 
 			memset(buf, 0, cmd->cmnd[4]);
-			kunmap_atomic(buf - sg->offset, KM_IRQ0);
+			kunmap_atomic(buf - sg->offset);
 
 			cmd->result = (DID_OK << 16);
 			cmd->scsi_done(cmd);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a4884a5..01ab9c4 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1885,11 +1885,11 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	case SAS_PROTOCOL_SMP: {
 			struct scatterlist *sg_resp = &task->smp_task.smp_resp;
 			tstat->stat = SAM_STAT_GOOD;
-			to = kmap_atomic(sg_page(sg_resp), KM_IRQ0);
+			to = kmap_atomic(sg_page(sg_resp));
 			memcpy(to + sg_resp->offset,
 				slot->response + sizeof(struct mvs_err_info),
 				sg_dma_len(sg_resp));
-			kunmap_atomic(to, KM_IRQ0);
+			kunmap_atomic(to);
 			break;
 		}
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6888b2c..68da6c0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1778,7 +1778,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	scsi_for_each_prot_sg(SCpnt, psgl, scsi_prot_sg_count(SCpnt), i) {
 		int len = min(psgl->length, resid);
 
-		paddr = kmap_atomic(sg_page(psgl), KM_IRQ0) + psgl->offset;
+		paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
 		memcpy(paddr, dif_storep + dif_offset(sector), len);
 
 		sector += len >> 3;
@@ -1788,7 +1788,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			sector = do_div(tmp_sec, sdebug_store_sectors);
 		}
 		resid -= len;
-		kunmap_atomic(paddr, KM_IRQ0);
+		kunmap_atomic(paddr);
 	}
 
 	dix_reads++;
@@ -1881,12 +1881,12 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	BUG_ON(scsi_sg_count(SCpnt) == 0);
 	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
 
-	paddr = kmap_atomic(sg_page(psgl), KM_IRQ1) + psgl->offset;
+	paddr = kmap_atomic(sg_page(psgl)) + psgl->offset;
 	ppage_offset = 0;
 
 	/* For each data page */
 	scsi_for_each_sg(SCpnt, dsgl, scsi_sg_count(SCpnt), i) {
-		daddr = kmap_atomic(sg_page(dsgl), KM_IRQ0) + dsgl->offset;
+		daddr = kmap_atomic(sg_page(dsgl)) + dsgl->offset;
 
 		/* For each sector-sized chunk in data page */
 		for (j = 0 ; j < dsgl->length ; j += scsi_debug_sector_size) {
@@ -1895,10 +1895,10 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			 * protection page advance to the next one
 			 */
 			if (ppage_offset >= psgl->length) {
-				kunmap_atomic(paddr, KM_IRQ1);
+				kunmap_atomic(paddr);
 				psgl = sg_next(psgl);
 				BUG_ON(psgl == NULL);
-				paddr = kmap_atomic(sg_page(psgl), KM_IRQ1)
+				paddr = kmap_atomic(sg_page(psgl))
 					+ psgl->offset;
 				ppage_offset = 0;
 			}
@@ -1971,10 +1971,10 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			ppage_offset += sizeof(struct sd_dif_tuple);
 		}
 
-		kunmap_atomic(daddr, KM_IRQ0);
+		kunmap_atomic(daddr);
 	}
 
-	kunmap_atomic(paddr, KM_IRQ1);
+	kunmap_atomic(paddr);
 
 	dix_writes++;
 
@@ -1982,8 +1982,8 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 out:
 	dif_errors++;
-	kunmap_atomic(daddr, KM_IRQ0);
-	kunmap_atomic(paddr, KM_IRQ1);
+	kunmap_atomic(daddr);
+	kunmap_atomic(paddr);
 	return ret;
 }
 
@@ -2303,7 +2303,7 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 
 	offset = 0;
 	for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
-		kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
+		kaddr = (unsigned char *)kmap_atomic(sg_page(sg));
 		if (!kaddr)
 			goto out;
 
@@ -2311,7 +2311,7 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 			*(kaddr + sg->offset + j) ^= *(buf + offset + j);
 
 		offset += sg->length;
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 	}
 	ret = 0;
 out:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b2c95db..a33b2b6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2567,7 +2567,7 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 	if (*len > sg_len)
 		*len = sg_len;
 
-	return kmap_atomic(page, KM_BIO_SRC_IRQ);
+	return kmap_atomic(page);
 }
 EXPORT_SYMBOL(scsi_kmap_atomic_sg);
 
@@ -2577,6 +2577,6 @@ EXPORT_SYMBOL(scsi_kmap_atomic_sg);
  */
 void scsi_kunmap_atomic_sg(void *virt)
 {
-	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
+	kunmap_atomic(virt);
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 0cb39ff..e981d97 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -392,7 +392,7 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 		virt = bio->bi_integrity->bip_sector & 0xffffffff;
 
 		bip_for_each_vec(iv, bio->bi_integrity, i) {
-			sdt = kmap_atomic(iv->bv_page, KM_USER0)
+			sdt = kmap_atomic(iv->bv_page)
 				+ iv->bv_offset;
 
 			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
@@ -405,7 +405,7 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 				phys++;
 			}
 
-			kunmap_atomic(sdt, KM_USER0);
+			kunmap_atomic(sdt);
 		}
 
 		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
@@ -414,7 +414,7 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 	return 0;
 
 error:
-	kunmap_atomic(sdt, KM_USER0);
+	kunmap_atomic(sdt);
 	sd_printk(KERN_ERR, sdkp, "%s: virt %u, phys %u, ref %u, app %4x\n",
 		  __func__, virt, phys, be32_to_cpu(sdt->ref_tag),
 		  be16_to_cpu(sdt->app_tag));
@@ -453,13 +453,13 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 		virt = bio->bi_integrity->bip_sector & 0xffffffff;
 
 		bip_for_each_vec(iv, bio->bi_integrity, i) {
-			sdt = kmap_atomic(iv->bv_page, KM_USER0)
+			sdt = kmap_atomic(iv->bv_page)
 				+ iv->bv_offset;
 
 			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
 
 				if (sectors == 0) {
-					kunmap_atomic(sdt, KM_USER0);
+					kunmap_atomic(sdt);
 					return;
 				}
 
@@ -474,7 +474,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 				sectors--;
 			}
 
-			kunmap_atomic(sdt, KM_USER0);
+			kunmap_atomic(sdt);
 		}
 	}
 }
-- 
1.7.7.6

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
