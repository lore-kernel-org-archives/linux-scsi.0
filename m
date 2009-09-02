From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 4/6] mptsas : Send DID_NO_CONNECT for pending IOs of removed device
Date: Wed, 2 Sep 2009 11:45:53 +0530
Message-ID: <20090902061543.GE20211@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:58544 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbZIBGiO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 02:38:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com



Driver is modified to return DID_NO_CONNECT for all pending I/O
requests for bus type SAS, if it founds the target is removed at
the firmware level.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0e402eb..c295786 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -628,6 +628,16 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 		return 1;
 	}
 
+	if (ioc->bus_type == SAS) {
+		VirtDevice *vdevice = sc->device->hostdata;
+
+		if (!vdevice || !vdevice->vtarget ||
+		    vdevice->vtarget->deleted) {
+			sc->result = DID_NO_CONNECT << 16;
+			goto out;
+		}
+	}
+
 	sc->host_scribble = NULL;
 	sc->result = DID_OK << 16;		/* Set default reply as OK */
 	pScsiReq = (SCSIIORequest_t *) mf;
@@ -892,7 +902,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 #endif
 
 	} /* end of address reply case */
-
+out:
 	/* Unmap the DMA buffers, if any. */
 	scsi_dma_unmap(sc);
 
