From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v3] scsi: mpt3sas: wait_for_completion_timeout timeout not reported
Date: Wed, 31 Dec 2014 03:54:12 -0500
Message-ID: <1420016053-19521-1-git-send-email-der.herr@hofr.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Joe Lawrence <joe.lawrence@stratus.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
List-Id: linux-scsi@vger.kernel.org

wait_for_completion_timeout reaching timeout was being ignored,
this also should fail if timeout condition occurs.

v3: proper labeling and attribution - no change of actual patch

this was only compile tested with x86_64_defconfig + 
CONFIG_SCSI_LOWLEVEL=y, CONFIG_SCSI_MPT3SAS=m

patch is against linux-next 3.19.0-rc1 -next-20141226

Acked-by: Joe Lawrence <joe.lawrence@stratus.com>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 4472c2a..04ff21b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -393,7 +393,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	mpt3sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
 	    timeout*HZ);
-	if (!(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
+	if (timeleft == 0 || !(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
 		    ioc->name, __func__);
 		_debug_dump_mf(mpi_request,
-- 
1.7.10.4
