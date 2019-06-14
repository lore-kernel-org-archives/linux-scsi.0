From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: cxgb4i: remove set but not used variable 'ppmax'
Date: Fri, 14 Jun 2019 02:48:56 +0000
Message-ID: <20190614024856.115652-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Varun Prakash <varun@chelsio.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: YueHaibing <yuehaibing@huawei.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/cxgbi/cxgb4i/cxgb4i.c: In function 'cxgb4i_ddp_init':
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:2072:15: warning:
 variable 'ppmax' set but not used [-Wunused-but-set-variable]

It's not used since commit a248384e6420 ("cxgb4/libcxgb/cxgb4i/cxgbit:
enable eDRAM page pods for iSCSI")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 66d6e1f4b3c3..0fbb4edc4161 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -2069,7 +2069,6 @@ static int cxgb4i_ddp_init(struct cxgbi_device *cdev)
 	struct cxgb4_lld_info *lldi = cxgbi_cdev_priv(cdev);
 	struct net_device *ndev = cdev->ports[0];
 	struct cxgbi_tag_format tformat;
-	unsigned int ppmax;
 	int i, err;
 
 	if (!lldi->vr->iscsi.size) {
@@ -2078,7 +2077,6 @@ static int cxgb4i_ddp_init(struct cxgbi_device *cdev)
 	}
 
 	cdev->flags |= CXGBI_FLAG_USE_PPOD_OFLDQ;
-	ppmax = lldi->vr->iscsi.size >> PPOD_SIZE_SHIFT;
 
 	memset(&tformat, 0, sizeof(struct cxgbi_tag_format));
 	for (i = 0; i < 4; i++)
