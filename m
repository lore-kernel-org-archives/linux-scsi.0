From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 14/15] mpt3sas: fix possible memory leak.
Date: Fri, 30 Mar 2018 15:07:23 +0530
Message-ID: <1522402644-3016-15-git-send-email-chaitra.basappa@broadcom.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

In ioctl exit path driver refers ioc_list to free memory associated with
diag buffers and event_log pointer used to save events by driver.
If ctl_exit() func is called after unregistering driver, then ioc_list will
be empty and hence driver will not be able to free the allocated memory
which in turn causes memory leak.
So call ctl_exit() function before unregistering mpt3sas driver.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index f5344cc..562b13d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11286,10 +11286,10 @@ _mpt3sas_exit(void)
 	pr_info("mpt3sas version %s unloading\n",
 				MPT3SAS_DRIVER_VERSION);
 
-	pci_unregister_driver(&mpt3sas_driver);
-
 	mpt3sas_ctl_exit(hbas_to_enumerate);
 
+	pci_unregister_driver(&mpt3sas_driver);
+
 	scsih_exit();
 }
 
-- 
1.8.3.1
