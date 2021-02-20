Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29905C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF95864ED7
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhBTVj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:39:29 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:50438 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhBTVj1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:39:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857166; x=1645393166;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WcdoB4TYk6EI/9vfGmmzq6WJRU35o7uu66Ug5r/oOmY=;
  b=WtrphSzXh92QPFkcFvQuU5a/iEax1u6bQJl2rz54JQYucRzHc3E1u1ea
   AhpOCvb/dUSBq+pwL4pHTLNPZ96U8MzSFlY0tkDjaL2fUoIpLVGJv6O+v
   Aw/DkuhuRiyGM/uZS6PjW4mpiMTtmt03i+tvPog0e44xasIWWJHn9zx0J
   CjfkpX+ypEB9nQF50K24NY7Yai+H1vsj7mWQG+zlle+EbXhjcpJFIE51d
   nW9s1V9I2rgwwaHu9QlNv6EcrxAMudp6V1AbzslGdSWKRqWuPvohWCV5V
   vGsevYap/Jf5SAQQLnfSALaN5LlWawYWyqWIO3aurUchs9eoHp3ju8xF0
   w==;
IronPort-SDR: ZHg2c2GPu2la1Ld0fuzP+dFn51kur5a+f0+VTIXT9l7ux6KUy04SSqLBwYychF5GdH53pGCT5F
 3o1LgI/3BHqx+jNXS1byH1FcyoP73XBrG6dyxljvl89XpX5bY4RKLjvw1pPNngWZNto70nci4Y
 P53hF36LVx2+twYba8uw6DD8Y7WWLs3TDeC3lf75rQWkm9JwcCnPkY+GFj4jEDwL1RZFYOCnFz
 3RBhSfCFRqnhoeT0ooqqYeKSiRRRU5pkprPJGzZU2FSe6Td5bjp9qYIIvlQkSKvoVNGsYFqHwZ
 J/g=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="160409669"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:38:20 +0800
IronPort-SDR: zh1qaT+taTfgSRtARU8BnldAQ35X40n6muTj7Vhi2jcMQH8bndk7RYjSHu2X3wMcUas0Z3z95c
 zgkoxvyWvoJk0XqaxOu1y4Tc02lEKrZKqDZM2bpxzz5Up/xcFiRyZ7Er3WdX3YBle82enpOhPX
 PVpwYI3eLk3HnAHbAEknGKKAzaQnfO9iPYVHmdTtLz6OHMu8GeSD+ihdiOuME+7sFxOlGYJyIi
 hP1KAMwMfLidwMN+trp4zlc/DVvRUypLPfJ7B+9t3eB93KJXTS2iwLh5dtLzhbnyPtquAhiZ2Z
 UQThYmXH5duIPj+B3WA6/sCN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:19:54 -0800
IronPort-SDR: hjIokE8umHyoO/2EgcsOayl0MAAoFpCzclfkjdOOnfQFbxlZ881XQiXvbGKfy89XclSB7ixtsN
 YFtnHolMLTvqtQ3tWeyI268JeHfyueNjCU4qd0hgveU7blvAk637I3DZ5vqomvrnJYqpkA4QTM
 N5zt96xz3/slFAjbZXfuxZnEaiMcwKQhCvkRUf+CjXTEOMy4WD/aluoCFQt77WgkvgPgqgMjTd
 WuDJfhyI7WgYM/2ePtsC4f13zY+XlbQWlAC4kmilCzFZreI6wCH5d2YBnrYGWOXlAtRrVftX2b
 7yc=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:38:21 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 08/24] target/stat: remove unsed macro NONE
Date:   Sat, 20 Feb 2021 13:38:19 -0800
Message-Id: <20210220213819.6687-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_stat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 2d2c7e377722..62d15bcc3d93 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -31,8 +31,6 @@
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
 #endif
 
-#define NONE		"None"
-
 #define SCSI_LU_INDEX			1
 #define LU_COUNT			1
 
-- 
2.22.1

