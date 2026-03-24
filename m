Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BC33D3CED;
	Tue, 24 Mar 2026 08:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774342331; cv=none; b=kM7w9d6FIwfT4NvdRVdcRE1IiPcTuBLGDml5ZYUZLPenWf3ZN+4+g7R0RuQFiTZKiV0V2bE1p2XvKLOrxNzsnJz2eKFf1/Z3jjJQUPb1IBz977fSSKmYuUMaz0IpSyyUUtOv5LOnrVXK4atFXCU2Y2B6nJ8R4J1Ecqe7YCYpc9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774342331; c=relaxed/simple;
	bh=0JBrM+ahYhr96ciEIEu7XXCraWqEdv+UBTQIZG4fnK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U6sUggBIOd1cOSiX5s4cpf9vAtG6iyGxtWxP2TGJ8tw8Z8kjtlX+HbLpjhgY3ckL/wQKEZNil6J+Ktbj+swnKnc7mLyWfXLQjUOE7nHkpA5jCw1SluXEnptzRieuhXupZ5VZxx/iwBadH5Db4aDtwdqH2A+BLwa5jKm/s2acxx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.197])
	by APP-01 (Coremail) with SMTP id qwCowAB3IW2xUMJpv6j8Cg--.9861S2;
	Tue, 24 Mar 2026 16:52:02 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pengpeng@iscas.ac.cn
Subject: [PATCH] scsi: megaraid_sas: validate dynamic RAID map descriptor element counts
Date: Tue, 24 Mar 2026 16:52:01 +0800
Message-ID: <20260324085201.75176-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB3IW2xUMJpv6j8Cg--.9861S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCr48Gr48JryDuF1DWryrtFb_yoW5tw4rpF
	yrXanFk3yrA3WxXrW09a1qyryYka1kGrW5C3W2yw1Yvr1vgryIvF1vyFy2yF48ArykJF17
	uw42v34fCay5KaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCT
	nIWIevJa73UjIFyTuYvjfU5dgADUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

MR_PopulateDrvRaidMap() uses raid_map_desc_elements from the firmware's
dynamic RAID map to drive memcpy() sizes and array-copy loops into the
driver-owned devHndlInfo[], ldTgtIdToLd[], arMapInfo[] and ldSpanMap[]
buffers. Those destinations are fixed-size arrays, but the descriptor
element counts are currently trusted without checking that they fit the
corresponding driver map arrays.

Reject dynamic RAID map descriptors whose element counts exceed the
destination array capacities before copying them into the driver map.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 4e65583ca19d..01ff44619c27 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -164,6 +164,7 @@ static int MR_PopulateDrvRaidMap(struct megasas_instance *instance, u64 map_id)
 	struct MR_FW_RAID_MAP_DYNAMIC *fw_map_dyn;
 	struct MR_FW_RAID_MAP_EXT *fw_map_ext;
 	struct MR_RAID_MAP_DESC_TABLE *desc_table;
+	u32 desc_elements;
 
 
 	struct MR_DRV_RAID_MAP_ALL *drv_map =
@@ -195,8 +196,15 @@ static int MR_PopulateDrvRaidMap(struct megasas_instance *instance, u64 map_id)
 			le32_to_cpu(fw_map_dyn->desc_table_size);
 
 		for (i = 0; i < le32_to_cpu(fw_map_dyn->desc_table_num_elements); ++i) {
+			desc_elements = le32_to_cpu(desc_table->raid_map_desc_elements);
 			switch (le32_to_cpu(desc_table->raid_map_desc_type)) {
 			case RAID_MAP_DESC_TYPE_DEVHDL_INFO:
+				if (desc_elements > MAX_RAIDMAP_PHYSICAL_DEVICES_DYN) {
+					dev_dbg(&instance->pdev->dev,
+						"invalid dev handle descriptor count %u\n",
+						desc_elements);
+					return 1;
+				}
 				fw_map_dyn->dev_hndl_info =
 				(struct MR_DEV_HANDLE_INFO *)(raid_map_data + le32_to_cpu(desc_table->raid_map_desc_offset));
 				memcpy(pDrvRaidMap->devHndlInfo,
@@ -205,6 +213,12 @@ static int MR_PopulateDrvRaidMap(struct megasas_instance *instance, u64 map_id)
 					le32_to_cpu(desc_table->raid_map_desc_elements));
 			break;
 			case RAID_MAP_DESC_TYPE_TGTID_INFO:
+				if (desc_elements > MAX_LOGICAL_DRIVES_DYN) {
+					dev_dbg(&instance->pdev->dev,
+						"invalid target id descriptor count %u\n",
+						desc_elements);
+					return 1;
+				}
 				fw_map_dyn->ld_tgt_id_to_ld =
 					(u16 *)(raid_map_data +
 					le32_to_cpu(desc_table->raid_map_desc_offset));
@@ -214,6 +228,12 @@ static int MR_PopulateDrvRaidMap(struct megasas_instance *instance, u64 map_id)
 				}
 			break;
 			case RAID_MAP_DESC_TYPE_ARRAY_INFO:
+				if (desc_elements > MAX_API_ARRAYS_DYN) {
+					dev_dbg(&instance->pdev->dev,
+						"invalid array descriptor count %u\n",
+						desc_elements);
+					return 1;
+				}
 				fw_map_dyn->ar_map_info =
 					(struct MR_ARRAY_INFO *)
 					(raid_map_data + le32_to_cpu(desc_table->raid_map_desc_offset));
@@ -223,6 +243,12 @@ static int MR_PopulateDrvRaidMap(struct megasas_instance *instance, u64 map_id)
 				       le32_to_cpu(desc_table->raid_map_desc_elements));
 			break;
 			case RAID_MAP_DESC_TYPE_SPAN_INFO:
+				if (desc_elements > MAX_LOGICAL_DRIVES_DYN) {
+					dev_dbg(&instance->pdev->dev,
+						"invalid span descriptor count %u\n",
+						desc_elements);
+					return 1;
+				}
 				fw_map_dyn->ld_span_map =
 					(struct MR_LD_SPAN_MAP *)
 					(raid_map_data +
-- 
2.50.1 (Apple Git-155)

