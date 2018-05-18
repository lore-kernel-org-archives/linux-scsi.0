From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] aic94xx: don't return zero on failure paths in aic94xx_init()
Date: Sat, 19 May 2018 00:27:18 +0300
Message-ID: <1526678838-31469-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org, Peter Melnichenko <melnichenko@ispras.ru>
List-Id: linux-scsi@vger.kernel.org

If sas_domain_attach_transport() fails in aic94xx_init(),
it breaks off initialization, deallocates all resources, but returns zero.

The patch adds -ENOMEM as return value in this case.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Peter Melnichenko <melnichenko@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 6c838865ac5a..4a4746cc6745 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -1030,8 +1030,10 @@ static int __init aic94xx_init(void)
 
 	aic94xx_transport_template =
 		sas_domain_attach_transport(&aic94xx_transport_functions);
-	if (!aic94xx_transport_template)
+	if (!aic94xx_transport_template) {
+		err = -ENOMEM;
 		goto out_destroy_caches;
+	}
 
 	err = pci_register_driver(&aic94xx_pci_driver);
 	if (err)
-- 
2.7.4
