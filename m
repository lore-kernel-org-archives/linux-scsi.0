From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] qla1280: user pci_map_single
Date: Thu, 10 Feb 2005 17:00:26 +0100
Message-ID: <20050210160026.GB8743@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from verein.lst.de ([213.95.11.210]:4569 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262153AbVBJQAa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 11:00:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org


--- 1.72/drivers/scsi/qla1280.c	2004-10-22 06:20:31 +02:00
+++ edited/drivers/scsi/qla1280.c	2005-02-10 13:42:44 +01:00
@@ -1571,16 +1465,12 @@ qla1280_done(struct scsi_qla_host *ha)
 
 		/* Release memory used for this I/O */
 		if (cmd->use_sg) {
-			dprintk(3, "S/G unmap_sg cmd=%p\n", cmd);
-
 			pci_unmap_sg(ha->pdev, cmd->request_buffer,
-				     cmd->use_sg, cmd->sc_data_direction);
+					cmd->use_sg, cmd->sc_data_direction);
 		} else if (cmd->request_bufflen) {
-			/*dprintk(1, "No S/G unmap_single cmd=%x saved_dma_handle=%lx\n",
-			  cmd, sp->saved_dma_handle); */
-
-			pci_unmap_page(ha->pdev, sp->saved_dma_handle,
-				       cmd->request_bufflen, cmd->sc_data_direction);
+			pci_unmap_single(ha->pdev, sp->saved_dma_handle,
+					cmd->request_bufflen,
+					cmd->sc_data_direction);
 		}
 
 		/* Call the mid-level driver interrupt handler */
@@ -3354,14 +3244,11 @@ qla1280_64bit_start_scsi(struct scsi_qla
 						    REQUEST_ENTRY_SIZE);
 			}
 		} else {	/* No scatter gather data transfer */
-			struct page *page = virt_to_page(cmd->request_buffer);
-			unsigned long off = (unsigned long)cmd->request_buffer & ~PAGE_MASK;
-
-			dma_handle = pci_map_page(ha->pdev, page, off,
-						  cmd->request_bufflen,
-						  cmd->sc_data_direction);
+			dma_handle = pci_map_single(ha->pdev,
+					cmd->request_buffer,
+					cmd->request_bufflen,
+					cmd->sc_data_direction);
 
-			/* save dma_handle for pci_unmap_page */
 			sp->saved_dma_handle = dma_handle;
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 			if (ha->flags.use_pci_vchannel)
@@ -3636,11 +3523,10 @@ qla1280_32bit_start_scsi(struct scsi_qla
 						    REQUEST_ENTRY_SIZE);
 			}
 		} else {	/* No S/G data transfer */
-			struct page *page = virt_to_page(cmd->request_buffer);
-			unsigned long off = (unsigned long)cmd->request_buffer & ~PAGE_MASK;
-			dma_handle = pci_map_page(ha->pdev, page, off,
-						  cmd->request_bufflen,
-						  cmd->sc_data_direction);
+			dma_handle = pci_map_single(ha->pdev,
+					cmd->request_buffer,
+					cmd->request_bufflen,
+					cmd->sc_data_direction);
 			sp->saved_dma_handle = dma_handle;
 
 			*dword_ptr++ = cpu_to_le32(pci_dma_lo32(dma_handle));
