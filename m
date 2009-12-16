From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/5] mptfusion: Added MPI_SCSIIO_CONTROL_HEADOFQ priority
Date: Wed, 16 Dec 2009 19:01:13 +0530
Message-ID: <20091216133105.GN31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:32797 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933059AbZLPN6f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:58:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

There is a 'ioprio' field in the BIO and the Request structure.
check this priority field and set MPI_SCSIIO_CONTROL_HEADOFQ
to pass down I/O priority.
An enhancement to the LSI Disk Array Controller firmware is being
developed to look at the Head Of Queue bit to allow I/Os with the HOQ bit
set to be processed before I/Os which do not have the HOQ bit set.
In order to set the HOQ bit, the mpt fusion driver  needs to look at the
'ioprio' field in the request structure associated with the scsi command.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---

---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 5775275..8128d30 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1438,9 +1438,14 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	    && (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
 	    && (SCpnt->device->tagged_supported)) {
 		scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
-	} else {
+		if (SCpnt->request && SCpnt->request->ioprio) {
+			if (((SCpnt->request->ioprio & 0x7) == 1) ||
+				!(SCpnt->request->ioprio & 0x7))
+				scsictl |= MPI_SCSIIO_CONTROL_HEADOFQ;
+		}
+	} else
 		scsictl = scsidir | MPI_SCSIIO_CONTROL_UNTAGGED;
-	}
+
 
 	/* Use the above information to set up the message frame
 	 */
