From: John Garry <john.garry@huawei.com>
Subject: [PATCH 6/8] scsi: hisi_sas: check IPTT is valid before using it for v3 hw
Date: Sat, 24 Mar 2018 00:05:13 +0800
Message-ID: <1521821115-120040-7-git-send-email-john.garry@huawei.com>
References: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

There is a bug of v3 hw development version. When AXI error
happen, hw may return an abnormal CQ that IPTT value is 0xffff.
This will cause IPTT out-of-bounds reference.

This patch add an check of IPTT in cq_tasklet_v3_hw(), and
discard invalid slot. This workaround scheme is just to enhance
fault-tolerance of the driver. So, we will apply this scheme for
all version of v3 hw, although release version has fixed this SoC
bug.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index efe64bc..aa52d5e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1731,15 +1731,19 @@ static void cq_tasklet_v3_hw(unsigned long val)
 
 	while (rd_point != wr_point) {
 		struct hisi_sas_complete_v3_hdr *complete_hdr;
+		struct device *dev = hisi_hba->dev;
 		int iptt;
 
 		complete_hdr = &complete_queue[rd_point];
 
 		iptt = (complete_hdr->dw1) & CMPLT_HDR_IPTT_MSK;
-		slot = &hisi_hba->slot_info[iptt];
-		slot->cmplt_queue_slot = rd_point;
-		slot->cmplt_queue = queue;
-		slot_complete_v3_hw(hisi_hba, slot);
+		if (likely(iptt < HISI_SAS_COMMAND_ENTRIES_V3_HW)) {
+			slot = &hisi_hba->slot_info[iptt];
+			slot->cmplt_queue_slot = rd_point;
+			slot->cmplt_queue = queue;
+			slot_complete_v3_hw(hisi_hba, slot);
+		} else
+			dev_err(dev, "IPTT %d is invalid, discard it.\n", iptt);
 
 		if (++rd_point >= HISI_SAS_QUEUE_SLOTS)
 			rd_point = 0;
-- 
1.9.1
