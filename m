From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] mvsas: remove set but not used variables 'res_flag'
Date: Fri, 26 Oct 2018 06:38:36 +0000
Message-ID: <1540535916-45509-1-git-send-email-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>, John Garry <john.garry@huawei.com>, Jack Wang <jinpu.wang@profitbricks.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: YueHaibing <yuehaibing@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/mvsas/mv_init.c: In function 'mvs_ioremap':
drivers/scsi/mvsas/mv_init.c:315:36: warning:
 variable 'res_flag' set but not used [-Wunused-but-set-variable]
  unsigned long res_start, res_len, res_flag, res_flag_ex = 0;

It not used anymore after commit
92b19ff50e8f ("cleanup IORESOURCE_CACHEABLE vs ioremap()")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/mvsas/mv_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 3ac3437..d7534fb 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -312,7 +312,7 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 
 int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
 {
-	unsigned long res_start, res_len, res_flag, res_flag_ex = 0;
+	unsigned long res_start, res_len, res_flag_ex = 0;
 	struct pci_dev *pdev = mvi->pdev;
 	if (bar_ex != -1) {
 		/*
@@ -340,7 +340,6 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
 		goto err_out;
 	}
 
-	res_flag = pci_resource_flags(pdev, bar);
 	mvi->regs = ioremap(res_start, res_len);
 
 	if (!mvi->regs) {
