From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [PATCH v4 2/4] fusion: remove iopriority handling
Date: Thu, 13 Oct 2016 15:05:49 -0600
Message-ID: <8338586db99fd444337d27f9abc3a777@mail.gmail.com>
References: <1476388433-2539-1-git-send-email-adam.manzanares@hgst.com> <1476388433-2539-3-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476388433-2539-3-git-send-email-adam.manzanares@hgst.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adam Manzanares <adam.manzanares@hgst.com>, axboe@kernel.dk, tj@kernel.org, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>
List-Id: linux-scsi@vger.kernel.org

By removing the code below, we put all the commands for all the types of
devices (SAS/SATA) as simple-Q (requeue as the device require) and I am
not sure whether it is the intention of this change.

-----Original Message-----
From: Adam Manzanares [mailto:adam.manzanares@hgst.com]
Sent: Thursday, October 13, 2016 1:54 PM
To: axboe@kernel.dk; tj@kernel.org; dan.j.williams@intel.com;
hare@suse.de; martin.petersen@oracle.com; mchristi@redhat.com;
toshi.kani@hpe.com; ming.lei@canonical.com; sathya.prakash@broadcom.com;
chaitra.basappa@broadcom.com; suganath-prabu.subramani@broadcom.com
Cc: linux-block@vger.kernel.org; linux-ide@vger.kernel.org;
linux-kernel@vger.kernel.org; MPT-FusionLinux.pdl@broadcom.com;
linux-scsi@vger.kernel.org; Adam Manzanares; Adam Manzanares
Subject: [PATCH v4 2/4] fusion: remove iopriority handling

The request priority is now by default coming from the ioc. It was not
clear what this code was trying to do based upon the iopriority class or
data. The driver should check that a device supports priorities and use
them according to the specificiations of ioprio.

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 drivers/message/fusion/mptscsih.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c
b/drivers/message/fusion/mptscsih.c
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

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality
Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or
legally privileged information of WDC and/or its affiliates, and are
intended solely for the use of the individual or entity to which they are
addressed. If you are not the intended recipient, any disclosure, copying,
distribution or any action taken or omitted to be taken in reliance on it,
is prohibited. If you have received this e-mail in error, please notify
the sender immediately and delete the e-mail in its entirety from your
system.
