From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/5] hisi_sas: use device linkrate in MCR for v2 hw
Date: Fri, 8 Apr 2016 17:23:11 +0800
Message-ID: <1460107395-24501-2-git-send-email-john.garry@huawei.com>
References: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Contrary to the field name, the MCR (max connection rate)
in the ITCT should hold the device linkrate (linkrate of
the connected phy), and not the max linkrate.

This fixes an issue seen where some SATA drives connected
through an expander which would not attach.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index b733747..f462fc4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -544,7 +544,7 @@ static void setup_itct_v2_hw(struct hisi_hba *hisi_hba,
 	}
 
 	qw0 |= ((1 << ITCT_HDR_VALID_OFF) |
-		(device->max_linkrate << ITCT_HDR_MCR_OFF) |
+		(device->linkrate << ITCT_HDR_MCR_OFF) |
 		(1 << ITCT_HDR_VLN_OFF) |
 		(port->id << ITCT_HDR_PORT_ID_OFF));
 	itct->qw0 = cpu_to_le64(qw0);
-- 
1.9.1
