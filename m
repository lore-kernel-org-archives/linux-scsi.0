Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114DDC433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D80CF64ED7
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhBTVjs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:39:48 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:24626 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhBTVjr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:39:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857187; x=1645393187;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gR05BOvoajtwCw+9SUY0u9DvFzgIKgvpvEKZDII0cAE=;
  b=XDsDgOd/yhesqM7DdfnzydJg9i3SIUAeEI4xeuQKEOelIfhtaA29gRJU
   p9EHfoE03sSjveVsYJA9OmzzdoNud4vz/EFeH75TVfCGJof7JyV7NRO31
   r2xhmd4uAw67keO0Rhy/vDjWv7BpJZyCoAHZNexJB9J9EgJJ5GV+PIPcT
   k3w2wKZQ/hb6/N2oUZ3FxefgcYbfO86vqX2Z2q5UvqmJAN+Ay0YE5P2h7
   n65qsTRHwH3hHL0olr3GOTQKJB2hXO+Ue8K37PK205W7x2ESdDsstFGUY
   Zs5eeruJKgNNSVB2cC8ONtJ8JPlQJBSQa6MXrCFtiYuJV1zIDXPDZpdfB
   A==;
IronPort-SDR: bLhcJzipadL6S6VQN4z4ydXuwjDFT0AflC4ptY67tyn7i7wkGFL9VtHwywzJluZtZwI3AEeN76
 gBdAnPFGOZi1Mah35GiUvntV584YYxMDomgq0ROQ5pDFNjPftxz98KogreF3eEVl2K02MdPY3w
 Yt72Xerl45//UNrV/3BDabUAnmzXUR1h8uMeiIh+6FnI7bWcTj/KM1z1Tv0Npb0jQzPtLEkVFI
 kgqZDgYEbMxIDUHscyVL1Nb+JvQJnaQzP2GIRUwxzERW4ygzbSw9BFP93+yb+JwOXP8F8CGBv4
 oPg=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="270954957"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:38:53 +0800
IronPort-SDR: jLzTkOCjfdg1aEP1IOzFzW+fV5/3d1dgiRZKGNcNYnAqBpYeROYsbgmpwprzYt9EyBFyVjtZb0
 NOA/DimJDfGGoeiNMFmXwSrIqa2mjEPgI2haprmm17tCej6lboIHPFx7lip2eenmBIGFkqbppM
 Jr5Gaq3iwZF52ruGb5WUTiEwc2XC+hQ8JQTy/cDKSU84yTklyLOa3zKy0Kpfuq+TUfyHdttsFh
 3KROZMMuKCaJ/85vh4+5QGI0gThSpPxmJG0pWjY1d1V6vmO0qzqk4Nw3Uq8RXUK1yDHirYWHTz
 pUqu46QoxH0LwLRK9YaqhuI5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:20:27 -0800
IronPort-SDR: KHr8h6Y5DPRs8OwaELo29Iq2eatOGlyhP0X/u+RGl/4zvK1s9icGQ/oo47y3sY/mruWNvUv2cf
 WPElidHjeWVlMJN+sZ7MDlJ6p1Y3rrkQqaGLk/aIkUX+Dsnp6O5U2UGjhH5fvtfQ5SvV5T3VjS
 JX33ovA9q6U+ngSUyGV1dJQd3Q9Z+FPO1UnhxY0SthJrheO3oa9Hc/Xm3XHvjHAmgABbuPGPrB
 I24QttAkW9PGjJndJMCljagG1v5xfpTAkhETp1ScGyxHXxV+bRJFcSJVoTJ1dC6YKmc3N/m0se
 ZRU=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:38:53 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 11/24] target/iscsi: remove unsed macro PRINT_BUF
Date:   Sat, 20 Feb 2021 13:38:52 -0800
Message-Id: <20210220213852.6831-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 45ba07c6ec27..2db45cdd66af 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -28,23 +28,6 @@
 #include "iscsi_target_util.h"
 #include "iscsi_target.h"
 
-#define PRINT_BUFF(buff, len)					\
-{								\
-	int zzz;						\
-								\
-	pr_debug("%d:\n", __LINE__);				\
-	for (zzz = 0; zzz < len; zzz++) {			\
-		if (zzz % 16 == 0) {				\
-			if (zzz)				\
-				pr_debug("\n");			\
-			pr_debug("%4i: ", zzz);			\
-		}						\
-		pr_debug("%02x ", (unsigned char) (buff)[zzz]);	\
-	}							\
-	if ((len + 1) % 16)					\
-		pr_debug("\n");					\
-}
-
 extern struct list_head g_tiqn_list;
 extern spinlock_t tiqn_lock;
 
-- 
2.22.1

