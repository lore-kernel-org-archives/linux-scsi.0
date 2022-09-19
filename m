Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9958C54EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 09:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiISJtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 05:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiISJtg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 05:49:36 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B34BD5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 02:49:34 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=gumi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VQAn1OM_1663580966;
Received: from nu1m11355.sqa.nu8.tbsite.net(mailfrom:gumi@linux.alibaba.com fp:SMTPD_---0VQAn1OM_1663580966)
          by smtp.aliyun-inc.com;
          Mon, 19 Sep 2022 17:49:32 +0800
From:   Gu Mi <gumi@linux.alibaba.com>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Gu Mi <gumi@linux.alibaba.com>
Subject: [PATCH] scsi: mpt3sas: Modify the comment and exception return value of function _base_get_event_diag_triggers()
Date:   Mon, 19 Sep 2022 17:49:22 +0800
Message-Id: <1663580962-64851-1-git-send-email-gumi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For function _base_get_event_diag_triggers(), it has a return
value, but the description of the comment information is
incorrect. In addition, in the abnormal process, 0 should
not be returned, 0 means success, here an abnormal value
needs to be return, In order to retry after an exception
occurs, the setting returns to -EAGAIN, from code analysis,
it will not cause infinite retries.

Signed-off-by: Gu Mi <gumi@linux.alibaba.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 565339a..dabbab6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5025,7 +5025,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
  *				persistent pages
  * @ioc : per adapter object
  *
- * Return: nothing.
+ * Return: zero on success; otherwise return EAGAIN error codes
+ * asking the caller to retry.
  */
 static int
 _base_get_event_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
@@ -5050,7 +5050,7 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,
 		    ioc_err(ioc,
 		    "%s: Failed to get trigger pg2, ioc_status(0x%04x)\n",
 		   __func__, ioc_status));
-		return 0;
+		return -EAGAIN;
 	}
 
 	if (le16_to_cpu(trigger_pg2.NumMPIEventTrigger)) {
-- 
1.8.3.1

