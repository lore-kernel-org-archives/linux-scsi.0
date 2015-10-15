From: sumit.saxena@avagotech.com
Subject: [PATCH 05/12] megaraid_sas : Donot use PAGE_SIZE macro for
 calculation of max_sectors per IO request
Date: Thu, 15 Oct 2015 13:40:04 +0530
Message-ID: <201510150817.t9F8HMD6029627@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com
List-Id: linux-scsi@vger.kernel.org

Do not use PAGE_SIZE marco to calculate max_sectors per IO request. Driver code assumes PAGE_SIZE will be always 4096 which can do lead to wrongly calculated value if PAGE_SIZE is not 4096. This issue was reported in Ubuntu Bugzilla Bug #1475166.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |    2 ++
 drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index d236cc2..fab7602 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -388,6 +388,8 @@ enum MR_EVT_ARGS {
 	MR_EVT_ARGS_GENERIC,
 };
 
+
+#define SGE_BUFFER_SIZE	4096
 /*
  * define constants for device list query options
  */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 92c5bbe..6204a66 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4871,7 +4871,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 
 	instance->max_sectors_per_req = instance->max_num_sge *
-						PAGE_SIZE / 512;
+						SGE_BUFFER_SIZE / 512;
 	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
 		instance->max_sectors_per_req = tmp_sectors;
 
-- 
1.7.1
