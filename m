Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20B3C433E9
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D9CD64E51
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhB1GAN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:00:13 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6288 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhB1GAK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492010; x=1646028010;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1wbH/tii0VH/dbuuyyUFSquAFgn70CaFzqbRksUlvyU=;
  b=ClzdxL617TOUdFz7/r9QLiEeDQ3Yu7s9mv+7F5Z774j6iXsauX9ClQFp
   zYGz2hwMHr/8UhH2dyyEYin8u8hMTkmy3KyLr1o3B+PXHt9UeqmAAWDBq
   /Wg0pdULMGUHaEnXli0mNcwZxaaxsCSO0mA8Q/X6VW35Mbs/OqDC/NKqi
   IiVksWKOMpsXT+I8xgK7aWfLrSaX3oYgG0BWo0+4UYyMbbRGz3kWp/OTc
   gFFyOlrSocF1W8COp46MYswLm44y7QQkRgyE7vbQhmb9LdXIE5WYdWkqV
   Mn+1GlthG1aFGYfnNodg0r/HKwh3OJrHlGphkfqozGm2e4K9iz9SqF224
   Q==;
IronPort-SDR: CVpfMFUhMSfR9rykoiBQR5mm6Ax7gH0LwHp6hih+I3M4dQsT6bBdrsqxFigudansQvREekRBKF
 kEm3rsPo327zvl6M60CXQoWnCOvBx5cw+p6mGrch7O9msj40ySGl6AWrv/VmOKsYsj5uMM09TW
 JY3GanO8ZAhVJkCQ5aNjdI/NdBR6DBRxhClKbJt1G1nn8qH9eoMrUAuJH9erQf4e9yedsJvNt0
 mi7JzFJTNZmDKKAYHy41IvunHfWBJJTtUfqZpV/nCaWkutVE0TuF9xKxPaTgPgOdrcQtTxD2vw
 8Lw=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="165466159"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:58:38 +0800
IronPort-SDR: CyXwvX5SI23vUzm0QmvOX8LwKyABxdo6ucA3vH49N5hyYJs6lt7ludImtmsj/+ObexR7BiyeYE
 7Q/Gmo9Np2mXj7YqmY8R8ZKj2qCfFxg6K2/EcO4P4xaXcHBZX2uXA7WVgxxHL3QLwVTS2rYXWB
 693TpkdQOWFs0vgx1ZTsZgPwvuXe8joGJh6EU9EOZk+neu/qZX6w3RpCF59rZuLtMqTZzmpxhe
 ycC7cIc+RdLhy5fHJJk6MF0rzd/Geuw+NGNst9cpm6mNqRHOaZis/NqsVGAsz5MWqBEaRNzelT
 I5OyvBEO7J+xOB1DiZ7BgLwW
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:41:48 -0800
IronPort-SDR: lJWeujZDKckaZd3TUpDcX/PyE2mZ/idmvqCXuP8lOwdHcpX84p4qLJzTgdIN2XP+irshYqkzxZ
 52/KOqcc1Wqi06ZhsN27MecTIDzC2pkVMO2DrZgGFyYktUO87umUzCpzX2jdvso+1QK5hU++dT
 3DaSBNCi229MHH6EHxmoE/rKJM9tz0elzooDiRQB0wioE5V3Lp1y6paDxgFhrdDq2n3EJKB9jI
 BU8CQigTgzO9od3HOyk3CRWwJ0Q1iZ5f2mZJr4CgFKjErYQ/WYv3yfM7buP0eunwiMu1ucQ3PZ
 ymE=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:58:37 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 11/23] target/iscsi: remove unsed macro PRINT_BUF
Date:   Sat, 27 Feb 2021 21:56:33 -0800
Message-Id: <20210228055645.22253-12-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the unused macro that fixes the following compilation warning:-

drivers/target//iscsi/iscsi_target_util.c:31: warning: macro "PRINT_BUFF" is not used [-Wunused-macros]
#define PRINT_BUFF(buff, len)     \

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 9468b017b4a7..6dd5810e2af1 100644
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

