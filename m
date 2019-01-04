From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/3] scsi: libsas: Check SMP PHY control function result
Date: Sat, 5 Jan 2019 00:01:27 +0800
Message-ID: <1546617688-240623-3-git-send-email-john.garry@huawei.com>
References: <1546617688-240623-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1546617688-240623-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: yanaijie@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently the SMP PHY control execution result is checked, however the
function result for the command is not.

As such, we may be missing all potential errors, like SMP FUNCTION FAILED,
INVALID REQUEST FRAME LENGTH, etc., meaning the PHY control request has
failed.

In some scenarios we need to ensure the function result is accepted, so
add a check for this.

Tested-by: Jian Luo <luojian5@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 17eb418..8817b8e 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -614,7 +614,14 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 	}
 
 	res = smp_execute_task(dev, pc_req, PC_REQ_SIZE, pc_resp,PC_RESP_SIZE);
-
+	if (res) {
+		pr_err("ex %016llx phy%02d PHY control failed: %d\n",
+		       SAS_ADDR(dev->sas_addr), phy_id, res);
+	} else if (pc_resp[2] != SMP_RESP_FUNC_ACC) {
+		pr_err("ex %016llx phy%02d PHY control failed: function result 0x%x\n",
+		       SAS_ADDR(dev->sas_addr), phy_id, pc_resp[2]);
+		res = pc_resp[2];
+	}
 	kfree(pc_resp);
 	kfree(pc_req);
 	return res;
-- 
1.9.1
