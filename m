From: Chen Gang <gang.chen@sunrus.com.cn>
Subject: [PATCH] scsi: bfa: bfad_bsg: Avoid memory overflow in bfad_iocmd_ioc_get_info()
Date: Sat, 03 Jan 2015 12:40:41 +0800
Message-ID: <54A772C9.3050500@sunrus.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

'iocmd->adapter_hwpath' and 'iocmd->hwpath' are both zero terminated
string within BFA_STRING_32 (include '\0'). So need be sure of it.

 - Use strlcpy() instead of strcpy() for copying 'pci_name'.

 - Check border firstly, before check ':'.

 - Check border firstly, before set '\0'.

The related warning (allmodconfig under s390 by gcc 5):

    CC [M]  drivers/scsi/bfa/bfad_bsg.o
  drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_ioc_get_info':
  drivers/scsi/bfa/bfad_bsg.c:108:46: warning: loop exit may only be reached after undefined behavior [-Waggressive-loop-optimizations]
    for (i = 0; iocmd->adapter_hwpath[i] != ':' && i < BFA_STRING_32; i++)
                                                ^
  drivers/scsi/bfa/bfad_bsg.c:108:35: note: possible undefined statement is here
    for (i = 0; iocmd->adapter_hwpath[i] != ':' && i < BFA_STRING_32; i++)
                                     ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/scsi/bfa/bfad_bsg.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 023b9d4..cc60773 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -101,15 +101,17 @@ bfad_iocmd_ioc_get_info(struct bfad_s *bfad, void *cmd)
 
 	strcpy(iocmd->name, bfad->adapter_name);
 	strcpy(iocmd->port_name, bfad->port_name);
-	strcpy(iocmd->hwpath, bfad->pci_name);
+	strlcpy(iocmd->hwpath, bfad->pci_name, BFA_STRING_32);
 
 	/* set adapter hw path */
-	strcpy(iocmd->adapter_hwpath, bfad->pci_name);
-	for (i = 0; iocmd->adapter_hwpath[i] != ':' && i < BFA_STRING_32; i++)
+	strlcpy(iocmd->adapter_hwpath, bfad->pci_name, BFA_STRING_32);
+	for (i = 0; i < BFA_STRING_32 - 1 && iocmd->adapter_hwpath[i] != ':';
+									i++)
 		;
-	for (; iocmd->adapter_hwpath[++i] != ':' && i < BFA_STRING_32; )
+	for (; i < BFA_STRING_32 - 1 && iocmd->adapter_hwpath[++i] != ':'; )
 		;
-	iocmd->adapter_hwpath[i] = '\0';
+	if (i <  BFA_STRING_32 - 1)
+		iocmd->adapter_hwpath[i] = '\0';
 	iocmd->status = BFA_STATUS_OK;
 	return 0;
 }
-- 
1.7.9.5
