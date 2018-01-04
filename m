From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 1/3] scsi: libsas: fix memory leak in sas_smp_get_phy_events()
Date: Thu, 4 Jan 2018 19:47:39 +0800
Message-ID: <20180104114741.37358-2-yanaijie@huawei.com>
References: <20180104114741.37358-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:3682 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752775AbeADLkZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jan 2018 06:40:25 -0500
In-Reply-To: <20180104114741.37358-1-yanaijie@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hch@lst.de, hare@suse.com, Jason Yan <yanaijie@huawei.com>, John Garry <john.garry@huawei.com>, chenqilin <chenqilin2@huawei.com>, chenxiang <chenxiang66@hisilicon.com>

We've got a memory leak with the following producer:

while true;
do cat /sys/class/sas_phy/phy-1:0:12/invalid_dword_count >/dev/null;
done

The buffer req is allocated and not freed after we return. Fix it.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
CC: chenqilin <chenqilin2@huawei.com>
CC: chenxiang <chenxiang66@hisilicon.com>
---
 drivers/scsi/libsas/sas_expander.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 3183d63..4b0c67f 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -695,6 +695,7 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
 	phy->phy_reset_problem_count = scsi_to_u32(&resp[24]);
 
  out:
+	kfree(req);
 	kfree(resp);
 	return res;
 
-- 
2.9.5
