From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] cxgbit: remove set but not used variable 'ppmax'
Date: Fri, 14 Jun 2019 02:44:13 +0000
Message-ID: <20190614024413.110449-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Varun Prakash <varun@chelsio.com>, "David S. Miller" <davem@davemloft.net>, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>
Cc: YueHaibing <yuehaibing@huawei.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/target/iscsi/cxgbit/cxgbit_ddp.c: In function 'cxgbit_ddp_init':
drivers/target/iscsi/cxgbit/cxgbit_ddp.c:303:15: warning:
 variable 'ppmax' set but not used [-Wunused-but-set-variable]

It's not used since commit a248384e6420 ("cxgb4/libcxgb/cxgb4i/cxgbit:
enable eDRAM page pods for iSCSI")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index 1443ef045a5f..fe1be5feaf21 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -300,7 +300,6 @@ int cxgbit_ddp_init(struct cxgbit_device *cdev)
 	struct cxgb4_lld_info *lldi = &cdev->lldi;
 	struct net_device *ndev = cdev->lldi.ports[0];
 	struct cxgbi_tag_format tformat;
-	unsigned int ppmax;
 	int ret, i;
 
 	if (!lldi->vr->iscsi.size) {
@@ -308,8 +307,6 @@ int cxgbit_ddp_init(struct cxgbit_device *cdev)
 		return -EACCES;
 	}
 
-	ppmax = lldi->vr->iscsi.size >> PPOD_SIZE_SHIFT;
-
 	memset(&tformat, 0, sizeof(struct cxgbi_tag_format));
 	for (i = 0; i < 4; i++)
 		tformat.pgsz_order[i] = (lldi->iscsi_pgsz_order >> (i << 3))
