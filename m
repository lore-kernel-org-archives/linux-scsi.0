Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AD4C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF3464ED7
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhBTVj6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:39:58 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:38804 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhBTVj5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857325; x=1645393325;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VJVhaN+b+7PEVqFWOIeibFiMvdKqcg9V0KTFySe1jX8=;
  b=CUm+LVFU2/LXy2D+WdHE5pEb7RZ24WKUe7zKKMDQ8nqtB1L6a7KBr+of
   ICSIZ9UejiFyjaCzyJ9shc1xmGvn4vSLbYiVePz9B3dVxUuCbmb3y37Zh
   K0LPU6EYIlSoVO6taj29o6A8B3OS9az4e2edElGC/9k58DQ+aUvpc/XsB
   /+SSmNOSWsWKgC49mMQmEOe8eFJ/WcHG2IXoKc3ljzC1fctu15usB5mXn
   L5jBOHk0jn2s1q8okMdaq6Kzaat+c40yb+Ri61YK6phOLmmpxrDxoEUo6
   WdcuKSYUAJmdky+qQZ3HDznVY9pBsTioC8wb7A30Pq43hynM+L5w70V9G
   g==;
IronPort-SDR: uR14brqhYca87mbe52daDEyCSRaXmVvnWGGtoCd7LR7Y1vrJQeRMqqTNUXKNI+vCAQQsz0ndIz
 AlOdyieNbHj1GQmUv2NNaAB7eX/a0zE0vF5mzK0Um+uhfu/h2AFVUwt5/DUQROXp1MzZ4kt9lF
 xv/ujHM/R+QybVST6Y257ptdf/HfyWNyw5RXMNSPrcDr9Ncnk2KaLc26+baIa3gTmAXpFJwJ9D
 JyfqzQGq3t5OPLcJ2lR73U6ZqFwZcaKEVegSi4whnG7/MtD0Dm5KJZYbArkApeTNcswrVL8Yne
 HY0=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="264605653"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:40:12 +0800
IronPort-SDR: +iV9XL2/WKwhAbGNQRh2bWzZrVT8Oh7TCVbCc256bBF3BaqH+M6QpNxXaHVTfWs1h9wsIS6Tz/
 v43nZwPpUblRzWuW+SSFTx12Mu/VRCoXS/qZ6dgI1ja1KNq/KHcTHkVWVK355yBCqrvu/ELPHg
 PpbaPzfol4jwm6W6JnQHAIVQJFZCk2JsmWVnmEbyKDjR5z8kBYJ4cVIXYL9kA+X4/hQlXouoqn
 IEJhdraLVfmT+3aerFV8QsJcr8gnEP8FZ49iPmpqEKwQA1ysN0ooWttrdDX5/LT2wvdZviaeb6
 hzodRC6B2Qk/LZPdBt40wNjE
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:20:16 -0800
IronPort-SDR: cmjWuJrivO3UNPSmYQchr1RFRfKkrDhQMj3sZZMDyEDTpF1ZBPh2zSlFLNxlwopJrfUrp0PgKE
 8+bkTCtkNEz0Lw/de7rNHvkQ7X+Pmg7M4FVvfIluB+doNyAjeaP042jd3mIKfG5tt3ElWlREJv
 9rGHgFgeBpO5nEOoNJquy5gHMDmRXpoei1UJUiPznyIVg4DZFRtLIenYD+jxqY++UzPlpZ/yXD
 8YWfRjBlFDIMK/aBj1PHQPom+lDYvP0JGD8idUi5xvzw8OSd/FUeOzcpFX52NwAn0N/+b+av4F
 M24=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:38:42 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 10/24] target/iscsi: remove unsed macro TEXT_LEN
Date:   Sat, 20 Feb 2021 13:38:41 -0800
Message-Id: <20210220213841.6787-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 8b40f10976ff..151e2949bb75 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -28,7 +28,6 @@
 #include "iscsi_target_auth.h"
 
 #define MAX_LOGIN_PDUS  7
-#define TEXT_LEN	4096
 
 void convert_null_to_semi(char *buf, int len)
 {
-- 
2.22.1

