From: Doug Ledford <dledford@redhat.com>
Subject: [Patch] QLogic qla2x00 driver fixes
Date: Thu, 24 Feb 2005 23:21:33 -0500
Message-ID: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-rFDkXEU95ZVMxZjXGhKj"
Received: from mx1.redhat.com ([66.187.233.31]:60811 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261869AbVBYEVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 23:21:35 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id j1P4LYKJ028888
	for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2005 23:21:34 -0500
Received: from compaq.xsintricity.com (dledford.cipe.redhat.com [10.0.0.84])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id j1P4LYK14892
	for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2005 23:21:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi mailing list <linux-scsi@vger.kernel.org>


--=-rFDkXEU95ZVMxZjXGhKj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Don't use cmd->request->nr_hw_segments as it may not be initialized
(SG_IO in particular bypasses anything that initializes this and just
uses scsi_do_req to insert a scsi_request directly on the head of the
queue) and a bogus value here can trip up the checks to make sure that
the number of segments will fit in the queue ring buffer, resulting in
commands that are never completed.

Fix up several issues with PCI DMA mapping and failure to check return
values on the mappings.

Make the check for space in the ring buffer happen after the DMA mapping
is done since any checks done before the mapping has taken place are
bogus.

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford

--=-rFDkXEU95ZVMxZjXGhKj
Content-Disposition: attachment; filename=qla.patch
Content-Type: text/x-patch; name=qla.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

===== qla_iocb.c 1.15 vs edited =====
--- 1.15/drivers/scsi/qla2xxx/qla_iocb.c	2004-12-09 01:12:03 -05:00
+++ edited/qla_iocb.c	2005-02-24 16:25:55 -05:00
@@ -216,18 +216,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *
 			cur_seg++;
 		}
 	} else {
-		dma_addr_t	req_dma;
-		struct page	*page;
-		unsigned long	offset;
-
-		page = virt_to_page(cmd->request_buffer);
-		offset = ((unsigned long)cmd->request_buffer & ~PAGE_MASK);
-		req_dma = pci_map_page(ha->pdev, page, offset,
-		    cmd->request_bufflen, cmd->sc_data_direction);
-
-		sp->dma_handle = req_dma;
-
-		*cur_dsd++ = cpu_to_le32(req_dma);
+		*cur_dsd++ = cpu_to_le32(sp->dma_handle);
 		*cur_dsd++ = cpu_to_le32(cmd->request_bufflen);
 	}
 }
@@ -299,19 +288,8 @@ void qla2x00_build_scsi_iocbs_64(srb_t *
 			cur_seg++;
 		}
 	} else {
-		dma_addr_t	req_dma;
-		struct page	*page;
-		unsigned long	offset;
-
-		page = virt_to_page(cmd->request_buffer);
-		offset = ((unsigned long)cmd->request_buffer & ~PAGE_MASK);
-		req_dma = pci_map_page(ha->pdev, page, offset,
-		    cmd->request_bufflen, cmd->sc_data_direction);
-
-		sp->dma_handle = req_dma;
-
-		*cur_dsd++ = cpu_to_le32(LSD(req_dma));
-		*cur_dsd++ = cpu_to_le32(MSD(req_dma));
+		*cur_dsd++ = cpu_to_le32(LSD(sp->dma_handle));
+		*cur_dsd++ = cpu_to_le32(MSD(sp->dma_handle));
 		*cur_dsd++ = cpu_to_le32(cmd->request_bufflen);
 	}
 }
@@ -344,6 +322,8 @@ qla2x00_start_scsi(srb_t *sp)
 
 	/* Setup device pointers. */
 	ret = 0;
+	/* So we know we haven't pci_map'ed anything yet */
+	tot_dsds = 0;
 	fclun = sp->lun_queue->fclun;
 	ha = fclun->fcport->ha;
 	reg = ha->iobase;
@@ -372,8 +352,32 @@ qla2x00_start_scsi(srb_t *sp)
 	if (index == MAX_OUTSTANDING_COMMANDS)
 		goto queuing_error;
 
+	/* Map the sg table so we have an accurate count of sg entries needed */
+	if (cmd->use_sg) {
+		sg = (struct scatterlist *) cmd->request_buffer;
+		tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
+		    cmd->sc_data_direction);
+		if (tot_dsds == 0)
+			goto queuing_error;
+	} else if (cmd->request_bufflen) {
+		dma_addr_t	req_dma;
+		struct page	*page;
+		unsigned long	offset;
+
+		page = virt_to_page(cmd->request_buffer);
+		offset = ((unsigned long)cmd->request_buffer & ~PAGE_MASK);
+		req_dma = pci_map_page(ha->pdev, page, offset,
+		    cmd->request_bufflen, cmd->sc_data_direction);
+
+		if (dma_mapping_error(req_dma))
+			goto queuing_error;
+
+		sp->dma_handle = req_dma;
+		tot_dsds = 1;
+	}
+
 	/* Calculate the number of request entries needed. */
-	req_cnt = (ha->calc_request_entries)(cmd->request->nr_hw_segments);
+	req_cnt = (ha->calc_request_entries)(tot_dsds);
 	if (ha->req_q_cnt < (req_cnt + 2)) {
 		cnt = RD_REG_WORD_RELAXED(ISP_REQ_Q_OUT(ha, reg));
 		if (ha->req_ring_index < cnt)
@@ -385,19 +389,6 @@ qla2x00_start_scsi(srb_t *sp)
 	if (ha->req_q_cnt < (req_cnt + 2))
 		goto queuing_error;
 
-	/* Finally, we have enough space, now perform mappings. */
-	tot_dsds = 0;
-	if (cmd->use_sg) {
-		sg = (struct scatterlist *) cmd->request_buffer;
-		tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
-		    cmd->sc_data_direction);
-		if (tot_dsds == 0)
-			goto queuing_error;
-	} else if (cmd->request_bufflen) {
-	    tot_dsds++;
-	}
-	req_cnt = (ha->calc_request_entries)(tot_dsds);
-
 	/* Build command packet */
 	ha->current_outstanding_cmd = handle;
 	ha->outstanding_cmds[handle] = sp;
@@ -479,6 +470,14 @@ qla2x00_start_scsi(srb_t *sp)
 	return (QLA_SUCCESS);
 
 queuing_error:
+	if (cmd->use_sg && tot_dsds) {
+		sg = (struct scatterlist *) cmd->request_buffer;
+		pci_unmap_sg(ha->pdev, sg, cmd->use_sg,
+		    cmd->sc_data_direction);
+	} else if (tot_dsds) {
+		pci_unmap_page(ha->pdev, sp->dma_handle, cmd->request_bufflen,
+			       cmd->sc_data_direction);
+	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return (QLA_FUNCTION_FAILED);

--=-rFDkXEU95ZVMxZjXGhKj--

