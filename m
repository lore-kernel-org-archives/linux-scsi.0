From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Tue, 18 Nov 2003 10:28:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031118092844.GA2995@tpkurt.garloff.de>
References: <20031117151431.76083f58.rddunlap@osdl.org> <Pine.LNX.4.44.0311180049250.2258-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:49619 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262327AbTKRJ7b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 04:59:31 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311180049250.2258-200000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, hch@infradead.org, linux-scsi@vger.kernel.org, gl@dsa-ac.de


--GID0FwUMdk1T2AWN
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Guennadi,

I have no clue what's going wrong yet with INQUIRY. I believe it has
to do with some pci mapping we get wrong.=20

I deferred the pci mapping to StartSCSI, so we don't create mappings
for queued SRBs. Some hardware may have IOMMUs and will have limited
sizes available.

It also allows to clean up some code as we can rely on a mapping being
created if needed upon StartSCSI. Likewise, I moved pci mapping cleanup
to SRBdone. Every command should go through here.
I still need to check the error handling paths, though.

Patch is on top of yours.

Likely, it won't help with the INQUIRY problem :(
I still have to get a machine with the DC390 up again.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="tmscsim-pcimap.diff"
Content-Transfer-Encoding: quoted-printable

--- drivers/scsi/tmscsim.c.guennadi	2003-11-18 10:15:30.000000000 +0100
+++ drivers/scsi/tmscsim.c	2003-11-18 10:24:08.232277272 +0100
@@ -970,6 +970,72 @@
     }
 }
=20
+
+/* Create pci mapping */
+static int dc390_pci_map (PSRB pSRB)
+{
+	int error =3D 0;
+	Scsi_Cmnd *pcmd =3D pSRB->pcmd;
+	struct pci_dev *pdev =3D pSRB->pSRBDCB->pDCBACB->pdev;
+	dc390_cmd_scp_t* cmdp =3D ((dc390_cmd_scp_t*)(&pcmd->SCp));
+	/* Map sense buffer */
+	if (pSRB->SRBFlag | AUTO_REQSENSE) {
+		cmdp->saved_dma_handle =3D pci_map_page(pdev,
+				virt_to_page(pcmd->sense_buffer),
+				(unsigned long)pcmd->sense_buffer & ~PAGE_MASK,
+				sizeof(pcmd->sense_buffer),
+				DMA_FROM_DEVICE);
+		pSRB->Segmentx.length =3D sizeof(pcmd->sense_buffer);
+		pSRB->SGcount =3D 1;
+		pSRB->pSegmentList =3D (PSGL) &pSRB->Segmentx;
+	/* Make SG list */=09
+	} else if (pcmd->use_sg) {
+		pSRB->pSegmentList =3D (PSGL) pcmd->request_buffer;
+		pSRB->SGcount =3D pci_map_sg(pdev, pSRB->pSegmentList,
+				pcmd->use_sg,=20
+				scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+		/* TODO: error handling */
+		if (!pSRB->SGcount)
+			error =3D 1;
+	/* Map single segment */=09
+	} else if (pcmd->request_buffer) {
+		struct page *page =3D virt_to_page(pcmd->request_buffer);
+		unsigned long off =3D (unsigned long)pcmd->request_buffer & ~PAGE_MASK;
+		cmdp->saved_dma_handle =3D pci_map_page(pdev,=20
+				page, off, pcmd->request_bufflen,
+				scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+		/* TODO: error handling */
+		pSRB->Segmentx.length =3D pcmd->request_bufflen;
+		pSRB->SGcount =3D 1;
+		pSRB->pSegmentList =3D (PSGL) &pSRB->Segmentx;
+	/* No mapping !? */=09
+    	} else
+		pSRB->SGcount =3D 0;
+	return error;
+}
+
+/* Remove pci mapping */
+static void dc390_pci_unmap (PSRB pSRB)
+{
+	Scsi_Cmnd* pcmd =3D pSRB->pcmd;
+	struct pci_dev *pdev =3D pSRB->pSRBDCB->pDCBACB->pdev;
+	dc390_cmd_scp_t* cmdp =3D ((dc390_cmd_scp_t*)(&pcmd->SCp));
+
+	if (pSRB->SRBFlag) {
+		pci_unmap_page(pdev, cmdp->saved_dma_handle,
+			       sizeof(pcmd->sense_buffer), DMA_FROM_DEVICE);
+	} else if (pcmd->use_sg) {
+		pci_unmap_sg(pdev, pcmd->request_buffer, pcmd->use_sg,
+			     scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+	} else if (pcmd->request_buffer) {
+		pci_unmap_page(pdev,
+			       cmdp->saved_dma_handle,
+			       pcmd->request_bufflen,
+			       scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+	}
+}
+
+
 /***********************************************************************
  * Function: static void dc390_BuildSRB (Scsi_Cmd *pcmd, PDCB pDCB,=20
  * 					 PSRB pSRB)
@@ -986,26 +1052,7 @@
     //pSRB->ScsiCmdLen =3D pcmd->cmd_len;
     //memcpy (pSRB->CmdBlock, pcmd->cmnd, pcmd->cmd_len);
    =20
-		printk("%s(): direction %d\n", __FUNCTION__, pcmd->sc_data_direction);
-    if( pcmd->use_sg )
-    {
-	pSRB->pSegmentList =3D (PSGL) pcmd->request_buffer;
-	pSRB->SGcount =3D pci_map_sg(pdev, pSRB->pSegmentList,
-				   pcmd->use_sg, scsi_to_pci_dma_dir(pcmd->sc_data_direction));
-    }
-    else if( pcmd->request_buffer )
-    {
-	struct page *page =3D virt_to_page(pcmd->request_buffer);
-	unsigned long off =3D (unsigned long)pcmd->request_buffer & ~PAGE_MASK;
-	((dc390_cmd_scp_t*)(&pcmd->SCp))->saved_dma_handle =3D pci_map_page(pdev,=
 page, off,
-									  pcmd->request_bufflen,
-									  scsi_to_pci_dma_dir(pcmd->sc_data_direction));
-	pSRB->Segmentx.length =3D pcmd->request_bufflen;
-	pSRB->SGcount =3D 1;
-	pSRB->pSegmentList =3D (PSGL) &pSRB->Segmentx;
-    }
-    else
-	pSRB->SGcount =3D 0;
+	printk("%s(): direction %d\n", __FUNCTION__, pcmd->sc_data_direction);
=20
     pSRB->SGIndex =3D 0;
     pSRB->AdaptStatus =3D 0;
@@ -1024,6 +1071,7 @@
     pSRB->ScsiPhase =3D 0;
     pSRB->EndMessage =3D 0;
     pSRB->TagNumber =3D 255;
+    /* KG: deferred PCI mapping to dc390_StartSCSI */
 }
=20
 /* Put cmnd from Query to Waiting list and send next Waiting cmnd */
--- drivers/scsi/scsiiom.c.guennadi	2003-11-18 10:15:30.000000000 +0100
+++ drivers/scsi/scsiiom.c	2003-11-18 10:20:55.350599744 +0100
@@ -36,6 +36,9 @@
 	DEBUG0(printk ("DC390: We were just reset and don't accept commands yet!\=
n"));
 	return 1;
     }
+    /* KG: Moved pci mapping here */
+    dc390_pci_map(pSRB);
+    /* TODO: error handling */
     DC390_write8 (Scsi_Dest_ID, pDCB->TargetID);
     DC390_write8 (Sync_Period, pDCB->SyncPeriod);
     DC390_write8 (Sync_Offset, pDCB->SyncOffset);
@@ -189,19 +192,7 @@
 	    if (!ctr) printk (KERN_CRIT "DC390: dma_intr: DMA aborted unfinished:=
 %06x bytes remain!!\n", DC390_read32 (DMA_Wk_ByteCntr));
 	    else /*if (!residual)*/
 	    {
-		Scsi_Cmnd* pcmd =3D pSRB->pcmd;
-		if (pcmd->use_sg)
-		{
-			pci_unmap_sg(pACB->pdev, pcmd->request_buffer, pcmd->use_sg,
-				     scsi_to_pci_dma_dir(pcmd->sc_data_direction));
-		}
-		else if (pcmd->request_buffer)
-		{
-			pci_unmap_page(pACB->pdev,
-				       ((dc390_cmd_scp_t*)(&pcmd->SCp))->saved_dma_handle,
-				       pcmd->request_bufflen,
-				       scsi_to_pci_dma_dir(pcmd->sc_data_direction));
-		}
+		    /* Done: Moved pci unmap to dc390_SRBdone */
 	    }
 	    /* residual =3D  ... */
 	  }
@@ -747,14 +738,17 @@
     struct pci_dev *pdev =3D pACB->pdev;
     pSRB->TotalXferredLen =3D 0;
     pSRB->SGIndex =3D 0;
-    if( pcmd->use_sg )
-    {
+    if (pcmd->use_sg) {
 	pSRB->pSegmentList =3D (PSGL) pcmd->request_buffer;
 	psgl =3D pSRB->pSegmentList;
+	/*
 	pci_unmap_sg(pdev, psgl, pcmd->use_sg,
 		     scsi_to_pci_dma_dir(pcmd->sc_data_direction));
 	pSRB->SGcount =3D pci_map_sg(pdev, psgl,
 				   pcmd->use_sg, scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+	 */
+	//dc390_pci_sync(pSRB);
+
 	while (pSRB->TotalXferredLen + (ULONG) psgl->length < pSRB->Saved_Ptr)
 	{
 	    pSRB->TotalXferredLen +=3D (ULONG) psgl->length;
@@ -773,11 +767,12 @@
 	pSRB->SGBusAddr +=3D (pSRB->Saved_Ptr - pSRB->TotalXferredLen);
 	printk (KERN_INFO "DC390: Pointer restored. Segment %i, Total %li, Bus %0=
8lx\n",
 		pSRB->SGIndex, pSRB->Saved_Ptr, pSRB->SGBusAddr);
-    }
-    else if( pcmd->request_buffer )
-    {
+
+    } else if( pcmd->request_buffer ) {
+  =20
 	struct page *page =3D virt_to_page(pcmd->request_buffer + pSRB->Saved_Ptr=
);
 	unsigned long off =3D (unsigned long)(pcmd->request_buffer + pSRB->Saved_=
Ptr) & ~PAGE_MASK;
+	/*
 	dc390_cmd_scp_t* cmdp =3D ((dc390_cmd_scp_t*)(&pcmd->SCp));
=20
 	if (cmdp->saved_dma_handle)
@@ -787,23 +782,23 @@
 	cmdp->saved_dma_handle =3D pci_map_page(pdev, page, off,
 					      pcmd->request_bufflen - pSRB->Saved_Ptr,
 					      scsi_to_pci_dma_dir(pcmd->sc_data_direction));
+	 */
+	//dc390_pci_sync(pSRB);
=20
 	pSRB->Segmentx.length =3D pcmd->request_bufflen - pSRB->Saved_Ptr;
 	pSRB->SGcount =3D 1;
 	pSRB->pSegmentList =3D (PSGL) &pSRB->Segmentx;
-    }
-     else
-       {
+    } else {
 	 pSRB->SGcount =3D 0;
 	 printk (KERN_INFO "DC390: RESTORE_PTR message for Transfer without Scatt=
er-Gather ??\n");
-       };
+    };
=20
   pSRB->TotalXferredLen =3D pSRB->Saved_Ptr;
 };
=20
=20
 /* According to the docs, the AM53C974 reads the message and=20
- * generates a Succesful Operation IRQ before asserting ACK for
+ * generates a Successful Operation IRQ before asserting ACK for
  * the last byte (how does it know whether it's the last ?) */
 /* The old code handled it in another way, indicating, that on
  * every message byte an IRQ is generated and every byte has to
@@ -1395,6 +1390,9 @@
     PSGL   ptr2;
     ULONG  swlval;
=20
+    /* KG: Moved pci_unmap here */
+    dc390_pci_unmap(pSRB);
+
     pcmd =3D pSRB->pcmd; DCB_removed =3D 0;
     status =3D pSRB->TargetStatus;
     ptr =3D (PSCSI_INQDATA) (pcmd->request_buffer);
@@ -1468,6 +1466,7 @@
 	    pSRB->SGIndex =3D 0;
 	    pSRB->TotalXferredLen =3D 0;
 	    pSRB->SGToBeXferLen =3D 0;
+	    /*
 	    if( pcmd->use_sg ) {
 		pSRB->pSegmentList =3D (PSGL) pcmd->request_buffer;
 		pSRB->SGcount =3D pci_map_sg(pACB->pdev, pSRB->pSegmentList,
@@ -1484,6 +1483,8 @@
 										  scsi_to_pci_dma_dir(pcmd->sc_data_direction));
 		pSRB->Segmentx.length =3D pcmd->request_bufflen;
 	    }
+	    */
+
 	    if( dc390_StartSCSI( pACB, pDCB, pSRB ) ) {
 		dc390_Going_to_Waiting ( pDCB, pSRB );
 		dc390_waiting_timer (pACB, HZ/5);
@@ -1551,6 +1552,7 @@
 		pSRB->SGIndex =3D 0;
 		pSRB->TotalXferredLen =3D 0;
 		pSRB->SGToBeXferLen =3D 0;
+		/*
 		if( pcmd->use_sg )
 		{
 		    pSRB->pSegmentList =3D (PSGL) pcmd->request_buffer;
@@ -1567,6 +1569,7 @@
 										      scsi_to_pci_dma_dir(pcmd->sc_data_direction));
 		    pSRB->Segmentx.length =3D pcmd->request_bufflen;
 		}
+		*/
 		if( dc390_StartSCSI( pACB, pDCB, pSRB ) ) {
 		    dc390_Going_to_Waiting ( pDCB, pSRB );
 		    dc390_waiting_timer (pACB, HZ/5);
@@ -1805,6 +1808,9 @@
=20
     pcmd =3D pSRB->pcmd;
=20
+    /* We are called from SRBdone, original PCI mapping has been removed
+     * already, new one is set up from StartSCSI */
+    /*
     ((dc390_cmd_scp_t*)(&pcmd->SCp))->saved_dma_handle =3D pci_map_page(pA=
CB->pdev,
 								      virt_to_page(pcmd->sense_buffer),
 								      (unsigned long)pcmd->sense_buffer & ~PAGE_MASK,
@@ -1813,6 +1819,7 @@
     pSRB->Segmentx.length =3D sizeof(pcmd->sense_buffer);
     pSRB->pSegmentList =3D &pSRB->Segmentx;
     pSRB->SGcount =3D 1;
+    */
     pSRB->SGIndex =3D 0;
=20
     //pSRB->CmdBlock[0] =3D REQUEST_SENSE;

--xHFwDpU9dbj6ez1V--

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/ueZLxmLh6hyYd04RAvuAAJ93TxgZ8aZH/125FAG06GPbTFCvKQCfSid7
W7KwzXO3uvJi8rRiuppwneY=
=+LJF
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
