From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: PATCH [4/5]  qla2xxx: cleanup DMA mappings...
Date: Fri, 15 Apr 2005 11:06:43 -0700
Message-ID: <20050415180643.GE5882@plap.qlogic.org>
References: <20050413191548.GI9703@plap.qlogic.org> <20050413191904.GM9703@plap.qlogic.org> <20050413213424.GA18061@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:9355 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261887AbVDOSGo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2005 14:06:44 -0400
Content-Disposition: inline
In-Reply-To: <20050413213424.GA18061@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Wed, 13 Apr 2005, Christoph Hellwig wrote:

> > +		struct page	*page;
> > +		unsigned long	offset;
> > +
> > +		page = virt_to_page(cmd->request_buffer);
> > +		offset = ((unsigned long)cmd->request_buffer & ~PAGE_MASK);
> > +		req_dma = pci_map_page(ha->pdev, page, offset,
> > +		    cmd->request_bufflen, cmd->sc_data_direction);
> 
> Why're you're redoing that code please switch to pci_map_single insted
> of these nasty operations to go to the page first, the code will become
> a lit simpler too, e.g. the above becomes just:
> 
> 	req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
> 			cmd->request_bufflen, cmd->sc_data_direction);
> 

Ok, how about this as an alternative.



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

  Doug Ledford <dledford@redhat.com>.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_iocb.c |   72 +++++++++++++++++++++++++++----------------------------------
 1 files changed, 33 insertions(+), 39 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_iocb.c	2005-04-13 08:45:53.000000000 -0700
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	2005-04-15 08:24:01.000000000 -0700
@@ -216,18 +216,7 @@
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
@@ -299,19 +288,8 @@
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
@@ -345,6 +323,8 @@
 	ha = sp->ha;
 	reg = ha->iobase;
 	cmd = sp->cmd;
+	/* So we know we haven't pci_map'ed anything yet */
+	tot_dsds = 0;
 
 	/* Send marker if required */
 	if (ha->marker_needed != 0) {
@@ -369,8 +349,27 @@
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
+
+		req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
+		    cmd->request_bufflen, cmd->sc_data_direction);
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
@@ -382,19 +381,6 @@
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
@@ -461,6 +447,14 @@
 	return (QLA_SUCCESS);
 
 queuing_error:
+	if (cmd->use_sg && tot_dsds) {
+		sg = (struct scatterlist *) cmd->request_buffer;
+		pci_unmap_sg(ha->pdev, sg, cmd->use_sg,
+		    cmd->sc_data_direction);
+	} else if (tot_dsds) {
+		pci_unmap_single(ha->pdev, sp->dma_handle,
+		    cmd->request_bufflen, cmd->sc_data_direction);
+	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return (QLA_FUNCTION_FAILED);
