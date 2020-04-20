Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF509C19F29
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbiHCQ3W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236679AbiHCQ3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:17 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0470BDEDB;
        Wed,  3 Aug 2022 09:29:16 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A790F412C5;
        Wed,  3 Aug 2022 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544153; x=1661358554; bh=M7bIgwjGB8IpWO1nTeQabcybK
        tqluBRod/zJ/cf+cGs=; b=JfwhYYZA8IZzRQkY3uDO4k1K6B8lvzywYvosJg0vo
        0W0p5/IipvDYozuhj+buH1DTQCX9Z+GIfbGTHq0D67TDmyCMTswrwbLMPZqbRi7/
        sIO43oLOmCtLkQiCvqQ+fAhXXOrZ+BfLP7Qoy7VfcCSO3cZBGQXYkgnZddSucJdW
        c0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ij2NwWhHly_U; Wed,  3 Aug 2022 19:29:13 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BDD5741284;
        Wed,  3 Aug 2022 19:29:11 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:11 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:10 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 03/48] scsi: target/core: Add cleanup sequence in core_tpg_register()
Date:   Mon, 20 Apr 2020 20:20:16 +0300
Message-ID: <20220803162857.27770-4-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803162857.27770-1-d.bogdanov@yadro.com>
References: <20220803162857.27770-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

It does not change any functionality but allows to introduce more steps
in the cleanup sequence without code duplication later.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_tpg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 736847c933e5..f0d38d77edcc 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -484,10 +484,8 @@ int core_tpg_register(
 
 		ret = core_tpg_add_lun(se_tpg, se_tpg->tpg_virt_lun0,
 				true, g_lun0_dev);
-		if (ret < 0) {
-			kfree(se_tpg->tpg_virt_lun0);
-			return ret;
-		}
+		if (ret < 0)
+			goto out_free_lun0;
 	}
 
 	pr_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, "
@@ -497,6 +495,10 @@ int core_tpg_register(
 		se_tpg->proto_id, se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
 
 	return 0;
+
+out_free_lun0:
+	kfree(se_tpg->tpg_virt_lun0);
+	return ret;
 }
 EXPORT_SYMBOL(core_tpg_register);
 
-- 
2.25.1

