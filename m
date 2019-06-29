From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 1/4] megaraid_sas: Fix calculation of target ID
Date: Fri, 28 Jun 2019 18:02:12 -0700
Message-ID: <1561770132-27408-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com, sasikumar.pc@broadcom.com, chandrakanth.patil@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In megasas_get_target_prop(), driver is incorrectly calculating the
target ID for devices with channel 1 and 3.
Due to this, firmware will either fail the command (if there is no
device with the target id sent from driver) or could return the
properties for a target which was not intended.
Devices could end up with the wrong queue depth due to this.

Fix target id calculation for channel 1 and 3.

Fixes: 96188a89cc6d ("scsi: megaraid_sas: NVME interface target prop added")
Cc: stable@vger.kernel.org
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b4c0bbc..9321878 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6558,7 +6558,8 @@ megasas_get_target_prop(struct megasas_instance *instance,
 	int ret;
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
-	u16 targetId = (sdev->channel % 2) + sdev->id;
+	u16 targetId = ((sdev->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +
+			sdev->id;
 
 	cmd = megasas_get_cmd(instance);
 
-- 
2.9.5
