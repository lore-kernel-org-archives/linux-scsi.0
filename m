From: Adam Manzanares <adam.manzanares@hgst.com>
Subject: [PATCH v5 2/4] fusion: remove iopriority handling
Date: Thu, 13 Oct 2016 16:00:29 -0700
Message-ID: <1476399631-5799-3-git-send-email-adam.manzanares@hgst.com>
References: <1476399631-5799-1-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1476399631-5799-1-git-send-email-adam.manzanares@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, tj@kernel.org, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@hgst.com>, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-scsi@vger.kernel.org

The request priority is now by default coming from the ioc. It was not
clear what this code was trying to do based upon the iopriority class or
data. The driver should check that a device supports priorities and use
them according to the specificiations of ioprio.

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 drivers/message/fusion/mptscsih.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 6c9fc11..4740bb6 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1369,11 +1369,6 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt)
 	if ((vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
 	    && (SCpnt->device->tagged_supported)) {
 		scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
-		if (SCpnt->request && SCpnt->request->ioprio) {
-			if (((SCpnt->request->ioprio & 0x7) == 1) ||
-				!(SCpnt->request->ioprio & 0x7))
-				scsictl |= MPI_SCSIIO_CONTROL_HEADOFQ;
-		}
 	} else
 		scsictl = scsidir | MPI_SCSIIO_CONTROL_UNTAGGED;
 
-- 
2.1.4

