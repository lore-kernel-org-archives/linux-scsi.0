From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: mpt3sas: make sysfs error messages ratelimited
Date: Fri,  7 Sep 2018 11:39:24 +0100
Message-ID: <20180907103924.17598-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

It is possible to heavily spam the kernel logs with messages by
excessive reading of the mpt3sas sysfs files.  Make the error messages
ratelimited to reduce the spamming effect.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 5e8c059ce2c9..656cec5adb17 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2958,7 +2958,7 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	ssize_t rc = 0;
 
 	if (!ioc->is_warpdrive) {
-		pr_err(MPT3SAS_FMT "%s: BRM attribute is only for"
+		pr_err_ratelimited(MPT3SAS_FMT "%s: BRM attribute is only for"
 		    " warpdrive\n", ioc->name, __func__);
 		goto out;
 	}
@@ -3039,7 +3039,7 @@ _ctl_host_trace_buffer_size_show(struct device *cdev,
 	struct DIAG_BUFFER_START *request_data;
 
 	if (!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) {
-		pr_err(MPT3SAS_FMT
+		pr_err_ratelimited(MPT3SAS_FMT
 			"%s: host_trace_buffer is not registered\n",
 			ioc->name, __func__);
 		return 0;
@@ -3047,7 +3047,7 @@ _ctl_host_trace_buffer_size_show(struct device *cdev,
 
 	if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
-		pr_err(MPT3SAS_FMT
+		pr_err_ratelimited(MPT3SAS_FMT
 			"%s: host_trace_buffer is not registered\n",
 			ioc->name, __func__);
 		return 0;
@@ -3089,7 +3089,7 @@ _ctl_host_trace_buffer_show(struct device *cdev, struct device_attribute *attr,
 	u32 size;
 
 	if (!ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE]) {
-		pr_err(MPT3SAS_FMT
+		pr_err_ratelimited(MPT3SAS_FMT
 			"%s: host_trace_buffer is not registered\n",
 			ioc->name, __func__);
 		return 0;
@@ -3097,7 +3097,7 @@ _ctl_host_trace_buffer_show(struct device *cdev, struct device_attribute *attr,
 
 	if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) == 0) {
-		pr_err(MPT3SAS_FMT
+		pr_err_ratelimited(MPT3SAS_FMT
 			"%s: host_trace_buffer is not registered\n",
 			ioc->name, __func__);
 		return 0;
-- 
2.17.1
