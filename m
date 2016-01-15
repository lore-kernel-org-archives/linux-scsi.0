From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] megaraid_sas: boot hangs while LD is offline
Date: Fri, 15 Jan 2016 14:43:16 +0100
Message-ID: <1452865396-9887-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbcAONnU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2016 08:43:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, megaraidlinux.pdl@avagotech.com, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Offline Logical drives (LDs) should not allowed to be visible
to the OS, as the OS will hang trying to send commands to it.
This patch skips offline LDs like it already does for
non-system physical drives (PDs).

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 97a1c1c..f32831b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1760,7 +1760,7 @@ static void megasas_set_dma_alignment(struct scsi_device *sdev)
 
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
-	u16 pd_index = 0;
+	u16 pd_index = 0, ld_index;
 	struct megasas_instance *instance;
 
 	instance = megasas_lookup_instance(sdev->host->host_no);
@@ -1772,6 +1772,11 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 			if (instance->pd_list[pd_index].driveState !=
 				MR_PD_STATE_SYSTEM)
 				return -ENXIO;
+		} else {
+			ld_index = ((sdev->channel - MEGASAS_MAX_PD_CHANNELS) *
+				    MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id;
+			if (instance->ld_ids[ld_index] == 0xff)
+				return -ENXIO;
 		}
 	}
 	megasas_set_dma_alignment(sdev);
-- 
1.8.5.6

