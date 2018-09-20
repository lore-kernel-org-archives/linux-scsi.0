From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: mpt3sas: Remove unnecessary parentheses and simplify null checks
Date: Thu, 20 Sep 2018 13:10:02 -0700
Message-ID: <20180920201002.23979-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Clang warns when multiple pairs of parentheses are used for a single
conditional statement.

drivers/scsi/mpt3sas/mpt3sas_base.c:535:11: warning: equality comparison
with extraneous parentheses [-Wparentheses-equality]
        if ((ioc == NULL))
             ~~~~^~~~~~~
drivers/scsi/mpt3sas/mpt3sas_base.c:535:11: note: remove extraneous
parentheses around the comparison to silence this warning
        if ((ioc == NULL))
            ~    ^      ~
drivers/scsi/mpt3sas/mpt3sas_base.c:535:11: note: use '=' to turn this
equality comparison into an assignment
        if ((ioc == NULL))
                 ^~
                 =
drivers/scsi/mpt3sas/mpt3sas_base.c:539:12: warning: equality comparison
with extraneous parentheses [-Wparentheses-equality]
        if ((pdev == NULL))
             ~~~~~^~~~~~~
drivers/scsi/mpt3sas/mpt3sas_base.c:539:12: note: remove extraneous
parentheses around the comparison to silence this warning
        if ((pdev == NULL))
            ~     ^      ~
drivers/scsi/mpt3sas/mpt3sas_base.c:539:12: note: use '=' to turn this
equality comparison into an assignment
        if ((pdev == NULL))
                  ^~
                  =
2 warnings generated.

Remove them and while we're at it, simplify the NULL checks as '!var' is
used more than 'var == NULL'.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 59d7844ee022..a49f16fed4c8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -532,11 +532,11 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	struct MPT3SAS_ADAPTER *ioc = (struct MPT3SAS_ADAPTER *)arg;
 	struct pci_dev *pdev;
 
-	if ((ioc == NULL))
+	if (!ioc)
 		return -1;
 
 	pdev = ioc->pdev;
-	if ((pdev == NULL))
+	if (!pdev)
 		return -1;
 	pci_stop_and_remove_bus_device_locked(pdev);
 	return 0;
-- 
2.19.0
