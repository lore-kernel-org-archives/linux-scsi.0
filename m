From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: Tue, 22 Jun 2004 12:46:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622114649.GA1507@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E5704925095@exa-atlanta> <20040622101105.GA32761@infradead.org> <20040622101450.GA610@infradead.org> <20040622103409.GA782@infradead.org> <20040622113916.GA1436@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:18052 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262605AbUFVLq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 07:46:58 -0400
Content-Disposition: inline
In-Reply-To: <20040622113916.GA1436@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: arjanv@redhat.com, fukuchi.masao@jp.fujitsu.com, linux-scsi@vger.kernel.org

Here's another important that should go in ASAP:  Currently fusion casts
the dma handle for non-sg requests to a void *, making it horribly fail
on systems with dma addresses bigger than the pointer size (e.g. x86 with
PAE).  The fix also cleans up the driver nicely..


--- linux-2.5/drivers/message/fusion.old/mptbase.h	2004-06-22 12:30:15.602578000 +0200
+++ linux-2.5/drivers/message/fusion/mptbase.h	2004-06-22 13:43:01.813813752 +0200
@@ -996,19 +996,6 @@
 	ushort			  sel_timeout[MPT_MAX_FC_DEVICES];
 } MPT_SCSI_HOST;
 
-/*
- *	Structure for overlaying onto scsi_cmnd->SCp area
- *	NOTE: SCp area is 36 bytes min, 44 bytes max?
- */
-typedef struct _scPrivate {
-	struct scsi_cmnd	*forw;
-	struct scsi_cmnd	*back;
-	void			*p1;
-	void			*p2;
-	u8			 io_path_id;	/* DMP */
-	u8			 pad[7];
-} scPrivate;
-
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	More Dynamic Multi-Pathing stuff...
--- linux-2.5/drivers/message/fusion.old/mptscsih.c	2004-06-22 13:22:08.735310000 +0200
+++ linux-2.5/drivers/message/fusion/mptscsih.c	2004-06-22 13:42:49.337710408 +0200
@@ -413,24 +413,15 @@
 		if (sges_left == 0)
 			return FAILED;
 	} else if (SCpnt->request_bufflen) {
-		dma_addr_t	 buf_dma_addr;
-		scPrivate	*my_priv;
-
-		buf_dma_addr = pci_map_single(hd->ioc->pcidev,
+		SCpnt->SCp.dma_handle = pci_map_single(hd->ioc->pcidev,
 				      SCpnt->request_buffer,
 				      SCpnt->request_bufflen,
 				      SCpnt->sc_data_direction);
-
-		/* We hide it here for later unmap. */
-		my_priv = (scPrivate *) &SCpnt->SCp;
-		my_priv->p1 = (void *)(ulong) buf_dma_addr;
-
 		dsgprintk((MYIOC_s_INFO_FMT "SG: non-SG for %p, len=%d\n",
 				hd->ioc->name, SCpnt, SCpnt->request_bufflen));
-
 		mptscsih_add_sge((char *) &pReq->SGL,
 			0xD1000000|MPT_SGE_FLAGS_ADDRESSING|sgdir|SCpnt->request_bufflen,
-			buf_dma_addr);
+			SCpnt->SCp.dma_handle);
 
 		return SUCCESS;
 	}
@@ -868,12 +859,8 @@
 		pci_unmap_sg(ioc->pcidev, (struct scatterlist *) sc->request_buffer,
 			    sc->use_sg, sc->sc_data_direction);
 	} else if (sc->request_bufflen) {
-		scPrivate	*my_priv;
-
-		my_priv = (scPrivate *) &sc->SCp;
-		pci_unmap_single(ioc->pcidev, (dma_addr_t)(ulong)my_priv->p1,
-			   sc->request_bufflen,
-			   sc->sc_data_direction);
+		pci_unmap_single(ioc->pcidev, sc->SCp.dma_handle,
+				sc->request_bufflen, sc->sc_data_direction);
 	}
 
 	hd->ScsiLookup[req_idx] = NULL;
@@ -1015,11 +1002,8 @@
 						SCpnt->use_sg,
 						SCpnt->sc_data_direction);
 				} else if (SCpnt->request_bufflen) {
-					scPrivate	*my_priv;
-
-					my_priv = (scPrivate *) &SCpnt->SCp;
 					pci_unmap_single(hd->ioc->pcidev,
-						(dma_addr_t)(ulong)my_priv->p1,
+						SCpnt->SCp.dma_handle,
 						SCpnt->request_bufflen,
 						SCpnt->sc_data_direction);
 				}
