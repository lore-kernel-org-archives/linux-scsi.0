From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: mpt3sas: mpt3sas_base.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 18:49:43 +0200
Message-ID: <1406393383-5475-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And removed unnecessary magic numbers.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0cf4f70..acc02eb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2233,7 +2233,7 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 	u32 bios_version;
 
 	bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
-	strncpy(desc, ioc->manu_pg0.ChipName, 16);
+	strlcpy(desc, ioc->manu_pg0.ChipName, sizeof(desc));
 	pr_info(MPT3SAS_FMT "%s: FWVersion(%02d.%02d.%02d.%02d), "\
 	   "ChipRevision(0x%02x), BiosVersion(%02d.%02d.%02d.%02d)\n",
 	    ioc->name, desc,
-- 
1.7.10.4
