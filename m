Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4C0C433E9
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07FCA64E2F
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBTVl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:41:28 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43906 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhBTVlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:41:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857284; x=1645393284;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2YO4BsWafjPFqQDWBRowWiri1qYzIAiaVzl+bi4mvu8=;
  b=k5mlfe4PUb4BQpNBKvqcXnfBMwcOLoG3JRELBJEG6xDS4N/EsSEMaLhR
   x/XCFxoyJ4Zh+cfyQp+q/k7DZIZnEZJ/g/CRLp2fKZqSZCDtN5/UhYozx
   pcMYTrr1ycR6dIjD69GZxWgWmVEtdms2JL8ZI5F8FYuwDO8wuyXmOafUF
   rsRzm449VuBaOnMiAc1rjYBwN53cduh+2LmD4sgt9HnF1bJr6i1G1Et9l
   bLM6GwI5B0LoKGiDBtKsx7w48jW8Iiv+VQeKxrjyzFRsdRSajrmROIQlR
   8PhcO3b7L1KhquK86RybwOXYW6Hxe41YZoyRJpyezHVdrtD+dRBROpNMm
   w==;
IronPort-SDR: V/xg9FJ+Z+PZtRP0GFrXFC1d/gLvk2Nc4f/BGT8VK57188bu8Ls78NExIOhO3qB+QEwx5Ug8mh
 SIUBU+s4RD68H4FaC9zhPIK4rCKKjgPFasY71Dz5GPy/vmWNBJgAXdc4jPDqXnqj40Di8m7Ler
 JaCbjkC8/D0FlJWKlePJSJwTaJagocvk5sQ8n5ucZj/9QP92+jJ/Zy2nof7V3qVAbt3kejG8No
 JbZYMkafVuS6rmH0FnIgOsqptoT00CkY7CLJIACh8YH0mXVK2c3Pqm4G+EsUfZLCWJUK+sotVz
 G30=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="161591315"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:40:20 +0800
IronPort-SDR: 8tMX7j1ao8BO5o8Dcu6s8CRVzV6TiAqDyvAXjikdbluxbyMRsAev8/4dnrCOkfowXfXBn9XvWH
 bkOX0yJVVyth/gIPDflXLHYIUmkjT6UE0vVHSRPwcvWTH43hcma6OvYHRY7jan9alGOf6CXkqw
 CLutlLeIzvWmPeujhCXITYt228bEwLLTfTXX9fcPeTXGxBAWCCz09IxIdqD8zl44ifc9yEZO3x
 wGwLhfPWVCdtbxsCqfNBR2aD9Ga2MLGxx16VzxNU/yKmuNy7jGEKEM0zQSsXzZc2olUUG3vV2F
 5cjqWr0kO/+W8kr3sFcnMxl5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:23:42 -0800
IronPort-SDR: tonu6DCmzb4hSW/RX3Ni3J+eR4v1RMx6OXW7XcHiYbQEzNNWJyXIZdamL4aejOZoRgOJ/pWYXx
 0atZyayObVl6Uk2HPDopu+A/uQiuplExIOhHH17FA0dHhlQ2HR9fv3HsVt4Jyle+15N4QNB5oR
 7uWv3F6O0Jyk1ID0YqhsjqWp6L9B6DiihpwaBWBO34sciZ44qRjTmOyg8PKz2NMSX9/CF4UNZ8
 sfTPHRhpXtNk1+qj5cMHM0u8X8GJ90W9WBmkfk61uvYgCyqCD1FaCukDuKf3i0SxtoAkFYOGFM
 RRw=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:40:20 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 19/24] target/configfs: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:40:18 -0800
Message-Id: <20210220214018.7237-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_configfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index d6554468ef65..9cb1ca8421c8 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3399,11 +3399,10 @@ static struct config_group *target_core_call_addhbatotarget(
 {
 	char *se_plugin_str, *str, *str2;
 	struct se_hba *hba;
-	char buf[TARGET_CORE_NAME_MAX_LEN];
+	char buf[TARGET_CORE_NAME_MAX_LEN] = { };
 	unsigned long plugin_dep_id = 0;
 	int ret;
 
-	memset(buf, 0, TARGET_CORE_NAME_MAX_LEN);
 	if (strlen(name) >= TARGET_CORE_NAME_MAX_LEN) {
 		pr_err("Passed *name strlen(): %d exceeds"
 			" TARGET_CORE_NAME_MAX_LEN: %d\n", (int)strlen(name),
-- 
2.22.1

