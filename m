Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35131C33C9E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 003B1206ED
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgAIBQO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 20:16:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:40678 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726654AbgAIBQO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 20:16:14 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1A07780C708DD0E74F7B;
        Thu,  9 Jan 2020 09:16:13 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 9 Jan 2020 09:16:07 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] scsi: sd: Clear sdkp->protection_type when the disk isn't DIF in sd_read_protection_type()
Date:   Thu, 9 Jan 2020 09:12:24 +0800
Message-ID: <1578532344-101668-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For a SAS disk, format it as a SAS DIF disk, then if re-format SAS DIF disk to normal
SAS disk,it will report errors as follows:
...
[root@localhost ~]# [77380.678276] sd 4:0:0:0: [sda] tag#67 UNKNOWN(0x2003) Result:
hostbyte=0x07 driverbyte=0x00
[77380.686511] sd 4:0:0:0: [sda] tag#67 CDB: opcode=0x28 28 20 00 00 00 00 00 00 08 00
[77380.694139] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0
phys_seg 1 prio class 0
[77380.703929] Buffer I/O error on dev sda, logical block 0, async page read
[77380.790267] sd 4:0:0:0: [sda] tag#72 UNKNOWN(0x2003) Result: hostbyte=0x07
driverbyte=0x00
[77380.798496] sd 4:0:0:0: [sda] tag#72 CDB: opcode=0x28 28 20 00 00 00 00 00 00 08 00
[77380.806123] blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0
phys_seg 1 prio class 0
[77380.815907] Buffer I/O error on dev sda, logical block 0, async page read
[77380.822676]  sda: unable to read partition table
...

When re-format SAS disk to normal SAS disk, it will send command READ_CAPACITY to get
protection info. In function sd_read_protection_type(), it checks whether the disk is
DIF from protection info, if not directly return. But if the disk was DIF disk, so
sdkp->protection_type of the disk is still be set. So the system will mistake the normal
disk as DIF disk(from CDB log 0x20 indicates there is DIF info with data).)
To avoid the issue, clear sdkp->protection_type when the disk is not DIF disk in
function sd_read_protection_type().

Fixes: fe542396da73 ("[SCSI] sd: Ensure we correctly disable devices with unknown protection type")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cea6259..65ce10c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2211,8 +2211,10 @@ static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer
 	u8 type;
 	int ret = 0;
 
-	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0)
+	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0) {
+		sdkp->protection_type = 0;
 		return ret;
+	}
 
 	type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
 
-- 
2.8.1

