From: John Garry <john.garry@huawei.com>
Subject: [PATCH 11/15] hisi_sas: fix HBA SAS addr endianness for v1 hw
Date: Tue, 6 Sep 2016 23:36:21 +0800
Message-ID: <1473176185-217808-12-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:47582 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935890AbcIFPX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2016 11:23:59 -0400
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>

The endianness for the SAS address in the TX_ID_DWORD
registers is set incorrectly.
We see errors like this in the boot log for v2 hw (which would
have the same issue as v1 hw):
[    7.583284] sas: target proto 0x0 at 50000d1108e7923f:0x1f not handled

This is due to the host SAS addr not matching the PHY SAS
addr in the expander host-attached phy discovery responses.

To fix, we byte swap the SAS addr from BE to LE (which is
the endianness of the SAS controller).

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index b537464..c030df0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -490,13 +490,13 @@ static void config_id_frame_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD0,
 			__swab32(identify_buffer[0]));
 	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD1,
-			identify_buffer[2]);
+			__swab32(identify_buffer[1]));
 	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD2,
-			identify_buffer[1]);
+			__swab32(identify_buffer[2]));
 	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD3,
-			identify_buffer[4]);
+			__swab32(identify_buffer[3]));
 	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD4,
-			identify_buffer[3]);
+			__swab32(identify_buffer[4]));
 	hisi_sas_phy_write32(hisi_hba, phy_no, TX_ID_DWORD5,
 			__swab32(identify_buffer[5]));
 }
-- 
1.9.1

