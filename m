From: Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: qedi: remove set but not used variables 'cdev' and 'udev'
Date: Wed, 24 Apr 2019 16:02:56 +0800
Message-ID: <20190424080256.30012-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/qedi/qedi_iscsi.c: In function 'qedi_ep_connect':
drivers/scsi/qedi/qedi_iscsi.c:813:23: warning: variable 'udev' set but not used [-Wunused-but-set-variable]
drivers/scsi/qedi/qedi_iscsi.c:812:18: warning: variable 'cdev' set but not used [-Wunused-but-set-variable]

They are never used since introduction.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index e4391ee..688a6d8 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -809,8 +809,6 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	struct qedi_endpoint *qedi_ep;
 	struct sockaddr_in *addr;
 	struct sockaddr_in6 *addr6;
-	struct qed_dev *cdev  =  NULL;
-	struct qedi_uio_dev *udev = NULL;
 	struct iscsi_path path_req;
 	u32 msg_type = ISCSI_KEVENT_IF_DOWN;
 	u32 iscsi_cid = QEDI_CID_RESERVED;
@@ -830,8 +828,6 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	}
 
 	qedi = iscsi_host_priv(shost);
-	cdev = qedi->cdev;
-	udev = qedi->udev;
 
 	if (test_bit(QEDI_IN_OFFLINE, &qedi->flags) ||
 	    test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
-- 
2.7.4
