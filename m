From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: libfc: Fix potential NULL pointer dereference
Date: Wed, 30 Jan 2019 18:11:41 +0800
Message-ID: <20190130101141.20132-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

There is a potential NULL pointer dereference in case
fc_rport_create() fails and returns NULL.

Fixes: 2580064b5ec6 ("scsi: libfc: Replace ->rport_create callback with function call")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/libfc/fc_lport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index ff943f4..e2a3551 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -250,6 +250,10 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
 	}
 	mutex_lock(&lport->disc.disc_mutex);
 	lport->ptp_rdata = fc_rport_create(lport, remote_fid);
+	if (!lport->ptp_rdata) {
+		mutex_unlock(&lport->disc.disc_mutex);
+		return;
+	}
 	kref_get(&lport->ptp_rdata->kref);
 	lport->ptp_rdata->ids.port_name = remote_wwpn;
 	lport->ptp_rdata->ids.node_name = remote_wwnn;
-- 
2.7.0
