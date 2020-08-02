Return-Path: <SRS0=GQ+9=BM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CEFC433E1
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Aug 2020 15:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAE822075B
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Aug 2020 15:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHBPWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Aug 2020 11:22:33 -0400
Received: from zg8tmtm5lju5ljm3lje2naaa.icoremail.net ([139.59.37.164]:59997
        "HELO zg8tmtm5lju5ljm3lje2naaa.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726257AbgHBPWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2020 11:22:33 -0400
X-Greylist: delayed 7391 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2020 11:22:30 EDT
Received: from oslab.tsinghua.edu.cn (unknown [166.111.139.112])
        by app-4 (Coremail) with SMTP id EgQGZQDn7+sL2iZfB9zpAw--.9401S2;
        Sun, 02 Aug 2020 23:21:52 +0800 (CST)
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
To:     linuxdrivers@attotech.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Subject: [PATCH] scsi: esas2r: fix possible buffer overflow caused by bad DMA value in esas2r_process_fs_ioctl()
Date:   Sun,  2 Aug 2020 23:21:45 +0800
Message-Id: <20200802152145.4387-1-baijiaju@tsinghua.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EgQGZQDn7+sL2iZfB9zpAw--.9401S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4DZry7KF4rJF1kZw17Awb_yoW8tryUpr
        4rCr4UAF95ZFZFqw17Gr15ZF93tan5tFyvgrWjqasxu3Z5CFsYyry5K34Uta4vqr129F1k
        tFyDX345ta47J3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkv14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW5WwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUz6wAUUUUU=
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In esas2r_read_fs():
  struct esas2r_ioctl_fs *fs = 
         (struct esas2r_ioctl_fs *)a->fs_api_buffer;

Because "a->fs_api_buffer" is mapped to coherent DMA (allocated in
esas2r_write_fs()), "fs" is also mapped to DMA.

Then esas2r_read_fs() calls esas2r_process_fs_ioctl() with "fs".

In esas2r_process_fs_ioctl():
  fsc = &fs->command;
  ...
  if (fsc->command >= cmdcnt) {
    fs->status = ATTO_STS_INV_FUNC;
    return false;
  }
  func = cmd_to_fls_func[fsc->command];
  if (func == 0xFF) {
    fs->status = ATTO_STS_INV_FUNC;
    return false;
  }

Because "fs" is mapped to DMA, its data can be modified at anytime by
malicious or malfunctioning hardware. In this case, the check 
"if (fsc->command >= cmdcnt)" can be passed, and then "fsc->command" 
can be modified by hardware to cause buffer overflow.

To fix this problem, "fsc->command" is assigned to a local variable, and
then this local variable is used to replace "fsc->command".

Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
---
 drivers/scsi/esas2r/esas2r_flash.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index b02ac389e6c6..ca5ff0d4c7d0 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -851,6 +851,7 @@ bool esas2r_process_fs_ioctl(struct esas2r_adapter *a,
 	struct esas2r_ioctlfs_command *fsc = &fs->command;
 	u8 func = 0;
 	u32 datalen;
+	u8 command = fsc->command;
 
 	fs->status = ATTO_STS_FAILED;
 	fs->driver_error = RS_PENDING;
@@ -860,18 +861,18 @@ bool esas2r_process_fs_ioctl(struct esas2r_adapter *a,
 		return false;
 	}
 
-	if (fsc->command >= cmdcnt) {
+	if (command >= cmdcnt) {
 		fs->status = ATTO_STS_INV_FUNC;
 		return false;
 	}
 
-	func = cmd_to_fls_func[fsc->command];
+	func = cmd_to_fls_func[command];
 	if (func == 0xFF) {
 		fs->status = ATTO_STS_INV_FUNC;
 		return false;
 	}
 
-	if (fsc->command != ESAS2R_FS_CMD_CANCEL) {
+	if (command != ESAS2R_FS_CMD_CANCEL) {
 		if ((a->pcid->device != ATTO_DID_MV_88RC9580
 		     || fs->adap_type != ESAS2R_FS_AT_ESASRAID2)
 		    && (a->pcid->device != ATTO_DID_MV_88RC9580TS
-- 
2.17.1

