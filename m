Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E634FC433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 06:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B230E611CE
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 06:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhDCGkr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 02:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbhDCGkq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 02:40:46 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D523C0613E6;
        Fri,  2 Apr 2021 23:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=wWw/XBjY5V
        L8TFNyvy6yE86/G3l3Tzkz04ZUjZ/7vf0=; b=ui3x58DwvRdpOPvdK0w2Xv2yPY
        LZFxD+a5fqMpyuXSwrSUTapJkeFsiYhQlZoWXBKVLAIgSe7ZA2D7N5kyIa/nA151
        BFFmYVw0HeB78L4uJM29LZX99p57TOn0GVKcVYTBv7QWpvXg8e4f7taRc0M58B6W
        f9eXppkwXXngApCus=
Received: from ubuntu.localdomain (unknown [202.38.69.14])
        by newmailweb.ustc.edu.cn (Coremail) with SMTP id LkAmygAXHKTjDWhgMpyPAA--.610S4;
        Sat, 03 Apr 2021 14:40:35 +0800 (CST)
From:   Lv Yunlong <lyl2019@mail.ustc.edu.cn>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Subject: [PATCH] scsi: be2iscsi: Fix a use after free in beiscsi_if_clr_ip
Date:   Fri,  2 Apr 2021 23:40:31 -0700
Message-Id: <20210403064031.5949-1-lyl2019@mail.ustc.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LkAmygAXHKTjDWhgMpyPAA--.610S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr17Wr48Cw1kKw4fKw4DJwb_yoW8Xw18pa
        4UX3WjyaykGF40kFnrAFWS9rnI9ayFy342vFy2g3yruFn5urWj9r98Ga4j9FnFkrZ5Jry7
        JF4kJr98GF48taUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lc2xSY4AK67AK6r47MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUjylk7UUUUU==
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the free_cmd error path of callee beiscsi_exec_nemb_cmd(),
nonemb_cmd->va is freed by dma_free_coherent().
As req = nonemb_cmd.va, we can see that the freed nonemb_cmd.va
is still dereferenced and used by req->ip_params.ip_record.status.

My patch uses status to replace req->ip_params.ip_record.status
to avoid the uaf.

Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 0d4928567265..b93b1a8c6c81 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -509,6 +509,7 @@ beiscsi_if_clr_ip(struct beiscsi_hba *phba,
 {
 	struct be_cmd_set_ip_addr_req *req;
 	struct be_dma_mem nonemb_cmd;
+	u32 status;
 	int rc;
 
 	rc = beiscsi_prep_nemb_cmd(phba, &nonemb_cmd, CMD_SUBSYSTEM_ISCSI,
@@ -531,11 +532,12 @@ beiscsi_if_clr_ip(struct beiscsi_hba *phba,
 	memcpy(req->ip_params.ip_record.ip_addr.subnet_mask,
 	       if_info->ip_addr.subnet_mask,
 	       sizeof(if_info->ip_addr.subnet_mask));
+	status = req->ip_params.ip_record.status;
 	rc = beiscsi_exec_nemb_cmd(phba, &nonemb_cmd, NULL, NULL, 0);
-	if (rc < 0 || req->ip_params.ip_record.status) {
+	if (rc < 0 || status) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 			    "BG_%d : failed to clear IP: rc %d status %d\n",
-			    rc, req->ip_params.ip_record.status);
+			    rc, status);
 	}
 	return rc;
 }
-- 
2.25.1


