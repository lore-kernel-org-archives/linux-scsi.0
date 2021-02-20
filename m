Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18749C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE0DA64ED6
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhBTVjG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:39:06 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:24626 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhBTVjF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:39:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857144; x=1645393144;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=a3O4OuuRcJWiUJGkluNQlnmV9xL7PI13uOtxrgN/iu4=;
  b=Bbn3dJDDEHz27F2RfdON2KFKr9TsYQQJTScwhh+8QlICbvIzDvo+4Y52
   fhnIekShdYRiGAwgQTIFAbcp0Nx7X3ks5RvuUOpSswy7DbDe9j/Y1nMct
   aF/9EEq5Yk4JcnkMdG0EPVlCC7CqDQU9ZPrj8IOyZ/PDFyW4XilEczBPZ
   8KHk2FkHyCA6zmPXq8AUJ6yP2XXuLfC76UVqij2+l+qNlkg0rSKXl/DZ3
   KIVi9CLkBBGqRx12vgP82A7UmwgKFDq8b0lJDdy32ZKWbBEBkbd1Krs7G
   NGSGLsGBcjcVNuNa3juw20AmXtD7kysXwMPdgYdXpoy2SaYE8cG8fKZq3
   Q==;
IronPort-SDR: 5gkI+QBxhY+v8lV2aOW4bFaSO6Xca9MXvQ9GZXeyEsJhDQzcltU/q532+GfcbkrZsUSlt67610
 op6+JCqyANMVpGbBgthJKNeCTMJC+XkwRkzoRiLMdmWN8OnrbNDBlexyNl2mjjeouDoiK/EbnB
 1shS9oH/Vk3wlbhTqk3yde6HApY8Oy6PNzq/MgEq3XzHtEXSzTkpe4UdOgxubGRAE4ud8TDsqF
 E3tb4uB6S9RA2LqJEfpqyQubWKIXg26eRaX7JUuXmSYFdyoPC8xazt6A4xGFYcKTjUqAh1RQ4I
 N1c=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="270954940"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:37:59 +0800
IronPort-SDR: e56jwIehBcqz0NCtY7uXfS0Ud28VPdw2E1hD+uJK45YOi1tXTd4MDG+av+niu9letELGPeefOh
 jYe3nmPgdf8OmmJRt6Yle8y+6hZERRDbXVazHn5yf1nmsySC0ahbO168tEilIyaXUt8150pej7
 3JjlHJ5iVsNk8WP/JLv1GMIHs0Krj/Dbe3cFBROb/Uz+PTw8o3Wa0dP6gmRRLo4pj7RVhfhNRT
 /vkH+8oDTHjS/0yiwXc/TEFyg7BZrMQdSc6bLCrX9wHxCyTfc/znpUVfbWwIepCvDZ/6PD3+tI
 1yln0hl48+/vo2JdYaT+/Tg4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:21:21 -0800
IronPort-SDR: gYlZXftLo21f6Vun5NCQb0OYohaGDURUcOPMnoLKTTdcLsPu2s40N5vY1NRoTvDIEMN4nN8mIH
 LDuc+/0cW1KnDg3PD0gG0Dq/SUCgcq52ssfTkHaX8epYth2wCwfclm6HmwhfcQq1t1T8AvV9XD
 CsIW3Jp01Gg/1k6fy8+8ef3YivvcLidDwD2UgaQHcPbuNzVXjnvldsD457qkAHowQYDcMbHFgn
 WB6IyOoFzFKG+zDaTcduNfwvC/2stMyu5jGLz/DrsJwiyiF/oNCslbpLht+fvt9MyormIA5suL
 mzQ=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:37:59 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 06/24] target/pscsi: remove unsed macro ISPRINT
Date:   Sat, 20 Feb 2021 13:37:57 -0800
Message-Id: <20210220213757.6577-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pscsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 003f6867ceb0..3b57e9c50c55 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -34,8 +34,6 @@
 #include "target_core_internal.h"
 #include "target_core_pscsi.h"
 
-#define ISPRINT(a)  ((a >= ' ') && (a <= '~'))
-
 static inline struct pscsi_dev_virt *PSCSI_DEV(struct se_device *dev)
 {
 	return container_of(dev, struct pscsi_dev_virt, dev);
-- 
2.22.1

