From: sumit.saxena@avagotech.com
Subject: [PATCH 01/12] megaraid_sas : Expose TAPE drives unconditionally
Date: Thu, 15 Oct 2015 13:39:24 +0530
Message-ID: <201510150816.t9F8GgOq029543@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com
List-Id: linux-scsi@vger.kernel.org

Expose non-disk(TAPE drive, CD-ROM) unconditionally. This issue is reported in Redhat Bugzilla [Bug 1254762].

Cc: <stable@vger.kernel.org>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d2ebcdd..d00d494 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1743,8 +1743,9 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 		pd_index =
 			(sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
 			sdev->id;
-		if (instance->pd_list[pd_index].driveState ==
-					MR_PD_STATE_SYSTEM) {
+		if ((instance->pd_list[pd_index].driveState ==
+			MR_PD_STATE_SYSTEM) ||
+			(instance->pd_list[pd_index].driveType != TYPE_DISK)) {
 			return 0;
 		}
 		return -ENXIO;
-- 
1.7.1
