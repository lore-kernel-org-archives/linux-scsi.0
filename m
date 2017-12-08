From: John Garry <john.garry@huawei.com>
Subject: [PATCH 18/19] scsi: hisi_sas: re-add the lldd_port_deformed()
Date: Sat, 9 Dec 2017 01:16:49 +0800
Message-ID: <1512753410-50924-19-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:36068 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754093AbdLHQbD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Dec 2017 11:31:03 -0500
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

In function sas_suspend_devices(), it requires
callback lldd_port_deformed callback to be
implemented if lldd_port_deformed is
implemented.

So add a stub for lldd_port_deformed.

Callback lldd_port_deformed was not required as the
port deformation is done elsewhere in the LLDD.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9bd98e5..ad12237 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1613,6 +1613,10 @@ static void hisi_sas_port_formed(struct asd_sas_phy *sas_phy)
 	hisi_sas_port_notify_formed(sas_phy);
 }
 
+static void hisi_sas_port_deformed(struct asd_sas_phy *sas_phy)
+{
+}
+
 static void hisi_sas_phy_disconnected(struct hisi_sas_phy *phy)
 {
 	phy->phy_attached = 0;
@@ -1703,6 +1707,7 @@ void hisi_sas_kill_tasklets(struct hisi_hba *hisi_hba)
 	.lldd_query_task	= hisi_sas_query_task,
 	.lldd_clear_nexus_ha = hisi_sas_clear_nexus_ha,
 	.lldd_port_formed	= hisi_sas_port_formed,
+	.lldd_port_deformed = hisi_sas_port_deformed,
 };
 
 void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
-- 
1.9.1
