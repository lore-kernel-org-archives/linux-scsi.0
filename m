From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] megaraid_sas: boot hangs while LD is offline
Date: Tue, 15 Aug 2017 13:59:15 +0200
Message-ID: <1502798355-59330-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50625 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752337AbdHOL7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 07:59:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Offline Logical drives (LDs) should not allowed to be visible
to the OS, as the OS will hang trying to send commands to it.
This patch skips offline LDs like it already does for
non-system physical drives (PDs).

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5202c2f..39b08fc 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1897,14 +1897,19 @@ static void megasas_set_static_target_properties(struct scsi_device *sdev,
 
 static int megasas_slave_configure(struct scsi_device *sdev)
 {
-	u16 pd_index = 0;
+	u16 pd_index = 0, ld_index;
 	struct megasas_instance *instance;
 	int ret_target_prop = DCMD_FAILED;
 	bool is_target_prop = false;
 
 	instance = megasas_lookup_instance(sdev->host->host_no);
 	if (instance->pd_list_not_supported) {
-		if (!MEGASAS_IS_LOGICAL(sdev) && sdev->type == TYPE_DISK) {
+		if (MEGASAS_IS_LOGICAL(sdev)) {
+			ld_index = ((sdev->channel - MEGASAS_MAX_PD_CHANNELS) *
+				    MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id;
+			if (instance->ld_ids[ld_index] == 0xff)
+				return -ENXIO;
+		} else if (sdev->type == TYPE_DISK) {
 			pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
 				sdev->id;
 			if (instance->pd_list[pd_index].driveState !=
-- 
1.8.5.6
