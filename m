From: sumit.saxena@avagotech.com
Subject: [PATCH 10/12] megaraid_sas : SMAP restriction-do not access user
 memory from IOCTL code
Date: Thu, 15 Oct 2015 13:40:54 +0530
Message-ID: <201510150818.t9F8IDfb029670@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com
List-Id: linux-scsi@vger.kernel.org

This is an issue on SMAP enabled CPUs and 32 bit apps running on 64 bit OS. Donot access user memory from kernel code.
SMAP bit restricts to access user memory from kernel code. Corresponding Redhat Bugzilla id for this is:[Bug 1267911].

Cc: <stable@vger.kernel.org>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c74d7c5..f8d5455 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6470,6 +6470,9 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	int i;
 	int error = 0;
 	compat_uptr_t ptr;
+	unsigned long local_raw_ptr;
+	u32 local_sense_off;
+	u32 local_sense_len;
 
 	if (clear_user(ioc, sizeof(*ioc)))
 		return -EFAULT;
@@ -6487,9 +6490,15 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	 * sense_len is not null, so prepare the 64bit value under
 	 * the same condition.
 	 */
-	if (ioc->sense_len) {
+	if (get_user(local_raw_ptr, ioc->frame.raw) ||
+		get_user(local_sense_off, &ioc->sense_off) ||
+		get_user(local_sense_len, &ioc->sense_len))
+		return -EFAULT;
+
+
+	if (local_sense_len) {
 		void __user **sense_ioc_ptr =
-			(void __user **)(ioc->frame.raw + ioc->sense_off);
+			(void __user **)((u8*)local_raw_ptr + local_sense_off);
 		compat_uptr_t *sense_cioc_ptr =
 			(compat_uptr_t *)(cioc->frame.raw + cioc->sense_off);
 		if (get_user(ptr, sense_cioc_ptr) ||
-- 
1.7.1
