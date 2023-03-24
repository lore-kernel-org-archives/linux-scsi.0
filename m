Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563A3C6FD20
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 15:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjCXPC0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 11:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjCXPCZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 11:02:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9513E199E3
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 08:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679670098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B4tL8croKD/v4eH0U1kmJCyqhohosjWOQr9oI3RNYX8=;
        b=Vjl/3EJj9SVhiWX10OaUKL2IHS+kpWsDvaGz9Et+xTgIO5+0jDPMeVzcy508hR1rrfeOLR
        9k+/KpKj5CGIOi9rYBZkECcpNetuj0ZBASqHRNzGTeNLGV/YF/US9wA6IK1ahOe8FhWAQX
        zvew1auqQ/CKWftG8bOTuuXzvPg4gZo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-weKHCYR8NzW2gEhuNICTYg-1; Fri, 24 Mar 2023 11:01:36 -0400
X-MC-Unique: weKHCYR8NzW2gEhuNICTYg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 034CE101A54F;
        Fri, 24 Mar 2023 15:01:36 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.225.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F91A492C3E;
        Fri, 24 Mar 2023 15:01:35 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com
Subject: [PATCH] scsi: megaraid_sas: fix for a crash after a double completion
Date:   Fri, 24 Mar 2023 16:01:34 +0100
Message-Id: <20230324150134.14696-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a physical disk is attached directly "without JBOD MAP support"
(see megasas_get_tm_devhandle) then there is no real error handling in the
driver.
Return FAILED instead of SUCCESS.

Fixes: 18365b138508 ("megaraid_sas: Task management support")

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 6597e118c805..52b71eb3fd34 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4768,7 +4768,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"task abort issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
@@ -4838,7 +4838,7 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"target reset issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
-- 
2.39.1

