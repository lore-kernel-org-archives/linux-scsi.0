From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 4.14] scsi:be2iscsi: Fix a kernel address leakage in be_main.c
Date: Tue, 16 Apr 2019 15:06:34 +0800
Message-ID: <20190416070634.13421-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, Fuqian Huang <huangfq.daxian@gmail.com>, Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Outputting kernel addresses will reveal the locations of kernel code
and data. And there is no need to print the address of a global object 
beiscsi_iscsi_transport in beiscsi_module_init.
This case is similar to CVE-2018-7273[1].
Just remove the print statement.

[1] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-7273

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b4542e7..f0dcd1f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5844,8 +5844,6 @@ static int __init beiscsi_module_init(void)
 		       "beiscsi_module_init - Unable to  register beiscsi transport.\n");
 		return -ENOMEM;
 	}
-	printk(KERN_INFO "In beiscsi_module_init, tt=%p\n",
-	       &beiscsi_iscsi_transport);
 
 	ret = pci_register_driver(&beiscsi_pci_driver);
 	if (ret) {
-- 
2.11.0
