From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] scsi: fdomain: Fix PCMCIA_FDOMAIN Kconfig warning
Date: Thu, 4 Jul 2019 16:01:56 +0800
Message-ID: <20190704080156.52044-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com, gregkh@linuxfoundation.org, linux@zary.sk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fix Kconfig warning for PCMCIA_FDOMAIN symbol:

WARNING: unmet direct dependencies detected for SCSI_FDOMAIN
  Depends on [n]: SCSI_LOWLEVEL [=n] && SCSI [=y]
  Selected by [m]:
  - PCMCIA_FDOMAIN [=m] && SCSI_LOWLEVEL_PCMCIA [=y] && SCSI [=y] && PCMCIA [=m] && m && MODULES [=y]

Add SCSI_FDOMAIN and SCSI_LOWLEVEL dependency.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 8674a8aa2c39 ("scsi: fdomain: Add PCMCIA support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/pcmcia/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index 2368f34..f23a572 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -22,7 +22,7 @@ config PCMCIA_AHA152X
 
 config PCMCIA_FDOMAIN
 	tristate "Future Domain PCMCIA support"
-	select SCSI_FDOMAIN
+	depends on SCSI_FDOMAIN && SCSI_LOWLEVEL
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
 	  adapter to your computer.
-- 
2.7.4
