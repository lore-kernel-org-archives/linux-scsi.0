From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 3/3] scsi: libsas: initialize sas_phy status according to response of DISCOVER
Date: Tue, 2 Jan 2018 20:15:10 +0800
Message-ID: <20180102121510.12570-4-yanaijie@huawei.com>
References: <20180102121510.12570-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3259 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751759AbeABMIR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jan 2018 07:08:17 -0500
In-Reply-To: <20180102121510.12570-1-yanaijie@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hch@lst.de, hare@suse.com, chenxiang <chenxiang66@hisilicon.com>, Jason Yan <yanaijie@huawei.com>

From: chenxiang <chenxiang66@hisilicon.com>

The status of SAS PHY is in sas_phy->enabled. There is an issue that the
status of a remote SAS PHY may be initialized incorrectly: if disable remote
SAS PHY through sysfs interface (such as echo 0 > /sys/class/sas_phy/phy-1:0:0/enable),
then reboot the system, and we will find the status of remote SAS PHY which is
disabled before is 1 (cat /sys/class/sas_phy/phy-1:0:0/enable). But actually
the status of remote SAS PHY is disabled and the device attached is not found.

In SAS protocol, NEGOTIATED LOGICAL LINK RATE field of DISCOVER response is 0x1
when remote SAS PHY is disabled. So initialize sas_phy->enabled according to
the value of NEGOTIATED LOGICAL LINK RATE field.

Signed-off-by: chenxiang <chenxiang66@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_expander.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 6eab487..c79cfd1 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -293,6 +293,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	phy->phy->minimum_linkrate = dr->pmin_linkrate;
 	phy->phy->maximum_linkrate = dr->pmax_linkrate;
 	phy->phy->negotiated_linkrate = phy->linkrate;
+	phy->phy->enabled = (phy->linkrate == SAS_PHY_DISABLED) ? 0:1;
 
  skip:
 	if (new_phy)
-- 
2.9.5
