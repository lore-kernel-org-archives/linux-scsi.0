Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65061C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35AE064E4A
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhB1GAd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:00:33 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34894 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhB1GA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:00:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492753; x=1646028753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SwHsfOqG91kLjVw37UarQdw/6ZH3LIQ3j1mjt+uZRbk=;
  b=CMT8ZoSdKsa5OdwqgrBNYO4Jnrwd2nlgPdkPU//1zNuTizkZYMDDtofH
   jmS/xO64/a74kY5VQSxUgDS9avsLLkvRrzOGb4HdPt8/UcqSMCBBoBV81
   s0vns8CLwcXxcwmaaDSuQKzenhu+YnYfPvb4bFhfbor8yE0PKcV2ZvFEC
   BQ3wUyZHdFVfBEJ7hft8s+aUeIN4Rdh9/KW3xVus44HKmkA09VY/kZTDP
   xQnIwICLXHqz22W+nPSpoEFQvq+OEr6OMfdAMu16dNuOFoPIBE6aIXmjU
   JifoymE14pi5fZEqDOhbeRHuu4kM7gOiuINP2OY8RS6EcPSZsKOy1xOg9
   Q==;
IronPort-SDR: NYWSrsjH1UNFYIi81sZWI/ZjWyu+5ZRDQXtIzwxmzO3O4oH56GEO2CyA8T0at2VLZ8pjDOeair
 4nsuK9yUnsGfvPXuhoU0gLF+/Qjw2zvjmKOxNq50o8Ocx2nXfNxlBw/8HO9TRf1Wh6aQv4ZHjt
 p+b5DDN+kng1IbAO0rttLEAy7ChRgMmGUEJx7V6b0sYhUC+V6Q2jsTQGZp8d5xkP79ubsdHsZo
 L60/2YTOZnMbzNyn8htAN88aRH2IKiox8v79rc+XKKdERSekgvtyhQZNjLKg3mw+iuWscL6uiF
 kz4=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="265236161"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 14:11:26 +0800
IronPort-SDR: cNNKsrMHh9GjKdozlC596EKftgXv3wNHJm7K82MPl8XqnuWr59BGxXoqB2VtedGwskkORXow4N
 pIs8I0K9O+ljMHYG3IRTNRgD58aTrEgu57bNXYJpSJvPsFwmq5+f/8RjfG4g7QDh/YlWJYezYO
 y7+Q+GZt00X8+ihwxWXscu0yT2EIZxdHxMB/bkYZ4xlE+ZjLT5xBSbUVGEANYB7w+lVEAFKh6B
 otWvXyp43D1wCC7qw/1U/n0xf7jh/SHUa+SaxjfVgNBEw4WyWKYmQv+jOyCln7OYOMqGRhodI8
 wWpKNlebkMB6OTEpXi/iovO0
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:42:55 -0800
IronPort-SDR: C/GK5K0aI462st4U0ckjwUZEdLgWnVBk4MnT37Mu25aDzubU06z42e03vt58s2U4JJRJ/xt3rj
 HG7JWYZwzivMJhsc7jZhxRMtnTZcQuj+pRKuGLcrPcpTzC8QFp+3qFx6fmSbqYjHvmvYh2X35+
 +agzrGik2kSTtYcgbu+FaHqBhrbvfsZAAsfgCN/yjMOGP27fBRhifNtR6Rcovsci6VuNAKEcRJ
 uKgrF7KzxqY+WhoTvzC05vrO23I+9wDt3iZ0NzGBATJISjMfUIwuwpsjhzouyWURt97LzLRAFy
 tto=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:59:45 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 18/23] target/configfs: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:40 -0800
Message-Id: <20210228055645.22253-19-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of initializing the array with memset, use declare init pattern
that is present under the kernel tree in other drivers so we can remove
the memset call.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_configfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 0ec9fe1ebade..d6554468ef65 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3012,9 +3012,7 @@ static ssize_t target_tg_pt_gp_members_show(struct config_item *item,
 	struct t10_alua_tg_pt_gp *tg_pt_gp = to_tg_pt_gp(item);
 	struct se_lun *lun;
 	ssize_t len = 0, cur_len;
-	unsigned char buf[TG_PT_GROUP_NAME_BUF];
-
-	memset(buf, 0, TG_PT_GROUP_NAME_BUF);
+	unsigned char buf[TG_PT_GROUP_NAME_BUF] = { };
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_for_each_entry(lun, &tg_pt_gp->tg_pt_gp_lun_list,
-- 
2.22.1

