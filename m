From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: redefine hisi_sas_phy.phy_type as u32
Date: Mon, 26 Jun 2017 18:27:28 +0800
Message-ID: <1498472848-174945-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:8797 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbdFZJ5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 05:57:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, John Garry <john.garry@huawei.com>

Element phy_type is a bitmask and it only ever has 2
bits possibly set, and it is overkill to define as a u64,
so redefine as a u32.

This change resolves static code check complaint that
"phy->phy_type &= ~PORT_TYPE_SAS;" would
unintentionally clear the high 32 bits as well.

Structure hisi_sas_phy is also reordered to ensure
packing efficiency.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 4fc2308..22dd48b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -85,11 +85,11 @@ struct hisi_sas_phy {
 	struct work_struct	phyup_ws;
 	u64		port_id; /* from hw */
 	u64		dev_sas_addr;
-	u64		phy_type;
 	u64		frame_rcvd_size;
 	u8		frame_rcvd[32];
 	u8		phy_attached;
 	u8		reserved[3];
+	u32		phy_type;
 	enum sas_linkrate	minimum_linkrate;
 	enum sas_linkrate	maximum_linkrate;
 };
-- 
1.9.1
