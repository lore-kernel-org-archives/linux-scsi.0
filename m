Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EF4C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 12:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BEE361153
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 12:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhDHM4d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 08:56:33 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15983 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbhDHM4d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 08:56:33 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FGLmw2TJmzyNjp;
        Thu,  8 Apr 2021 20:54:08 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.498.0; Thu, 8 Apr 2021
 20:56:09 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <jinpu.wang@cloud.ionos.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <luojiaxing@huawei.com>
Subject: [PATCH v3 2/2] scsi: pm8001: clean up for open brace
Date:   Thu, 8 Apr 2021 20:56:33 +0800
Message-ID: <1617886593-36421-3-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617886593-36421-1-git-send-email-luojiaxing@huawei.com>
References: <1617886593-36421-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are few error about open brace is reported by checkpatch.pl:

ERROR: that open brace { should be on the previous line
+static struct error_fw flash_error_table[] =
+{

So fix them all.

Signed-off-by: Jianqin Xie <xiejianqin@hisilicon.com>
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 90b816f..8c253b0 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -645,8 +645,7 @@ struct flash_command {
      int     code;
 };
 
-static struct flash_command flash_command_table[] =
-{
+static const struct flash_command flash_command_table[] = {
      {"set_nvmd",    FLASH_CMD_SET_NVMD},
      {"update",      FLASH_CMD_UPDATE},
      {"",            FLASH_CMD_NONE} /* Last entry should be NULL. */
@@ -657,8 +656,7 @@ struct error_fw {
      int     err_code;
 };
 
-static struct error_fw flash_error_table[] =
-{
+static const struct error_fw flash_error_table[] = {
      {"Failed to open fw image file",	FAIL_OPEN_BIOS_FILE},
      {"image header mismatch",		FLASH_UPDATE_HDR_ERR},
      {"image offset mismatch",		FLASH_UPDATE_OFFSET_ERR},
-- 
2.7.4

