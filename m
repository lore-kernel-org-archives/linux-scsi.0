From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH 1/3] storvsc: use tagged SRB requests if supported by the device
Date: Tue,  6 Sep 2016 14:25:41 -0700
Message-ID: <1473197143-16760-2-git-send-email-longli@exchange.microsoft.com>
References: <1473197143-16760-1-git-send-email-longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473197143-16760-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

Properly set SRB flags when hosting device supports tagged queuing. This patch improves the performance on Fiber Channel disks.

---
 drivers/scsi/storvsc_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8ccfc9e..a8f3e4c 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -136,6 +136,8 @@ struct hv_fc_wwn_packet {
 #define SRB_FLAGS_PORT_DRIVER_RESERVED		0x0F000000
 #define SRB_FLAGS_CLASS_DRIVER_RESERVED		0xF0000000
 
+#define SP_UNTAGGED			((unsigned char) ~0)
+#define SRB_SIMPLE_TAG_REQUEST		0x20
 
 /*
  * Platform neutral description of a scsi request -
@@ -1451,6 +1453,12 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	vm_srb->win8_extension.srb_flags |=
 		SRB_FLAGS_DISABLE_SYNCH_TRANSFER;
 
+	if(scmnd->device->tagged_supported) {
+		vm_srb->win8_extension.srb_flags |= (SRB_FLAGS_QUEUE_ACTION_ENABLE | SRB_FLAGS_NO_QUEUE_FREEZE);
+		vm_srb->win8_extension.queue_tag = SP_UNTAGGED;
+		vm_srb->win8_extension.queue_action = SRB_SIMPLE_TAG_REQUEST;
+	}
+
 	/* Build the SRB */
 	switch (scmnd->sc_data_direction) {
 	case DMA_TO_DEVICE:
-- 
1.8.5.6
