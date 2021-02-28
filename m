Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4710C433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 822AE64E4A
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhB1F7q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:59:46 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2540 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhB1F7n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:59:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614491984; x=1646027984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QvrZhvR2RwJAY+XI+wFrZuuLCAZRVw5n7M7KIGaG594=;
  b=BIyJ7jEA7NmvttJPp9ayO8feeQMMUYoGX8PzKCkUBT+DinaNtUte1FOu
   7GxFJbL5E21eagZ/yyGVSG4++Hv8umL9G0Yk1WIOWBQOez9B1ora8xy2/
   1LpHRM7xyLR2Kv3DYdtIwyG3pp1mu4kzMfPexHAub7ckBM2mkkdx3AMOJ
   Rdsl96LPtwoeCqS/BgvR5HbLAvuQve1+Q77Cvzavo6tfwKmAcuHrukojZ
   CtCmoT7r8dGJhNlnO7LsKUFQitLB0Nh9vOzehRvbkJA9Dzg9FOc8ve6cx
   sH8C27ZOSvEEh1CzO+QmohEhbQ1+4hOY4JA9oe6LvLeld7u3KNFeciDnW
   A==;
IronPort-SDR: KA5s8ZgOKQvSF3prb+fvVXd2iOl5X+ZAXYj/fZDl/aRFHSea90t+0xHAaZy73nUP+Wnh88Zogk
 BsPlKRu0Um9TjSHrvR2Fvvzc/SX9PY1Melmw5zCMr0awIMh3DQm7LScpRjWU9/qnKwIRToxFOC
 4EdWLe8AuPIYSzS5RZ46W/2PrQTjXfWoEsa185nfPxwC+/GzAjFU4+E5agVWAEkI4N8+V9B3V1
 gTFT0kS2IluB35HLX7nQDThs1ewjb/JafI8A7UfKzUF7prYXzMkiZmflTzqm5RBohYQviluyR3
 DMI=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="162152825"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:58:31 +0800
IronPort-SDR: 6tfBvxKLI0XFh6LLTyw/4bBLEnE2n/sDpbMPE3JbNQb2z6l6kqq7Croebm7KBnTWsrv0ollOXR
 4Sh4vYW+W88tJ59rWU3oz3Lb0Mom6RS13AgHfNOsKVkLN9PbKfW1F93Bwg+GMbP68EAq4MZcf1
 fFnpsIdNdrp/H0neL5pADq1U8eFh+Piss7sRl/LLXX+C6OqSi2XndIRql3TrWjdwzQki6/Bm/n
 EZnPTxSnfnnoW6u1X7lZjXanrdo4SJ+Q5HZmYIKNGk2zCuPS+gLbl+MycNi+IhWKoWv66f9lcn
 DSQOodXLki002fKPDO6UJz7B
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:39:49 -0800
IronPort-SDR: 6hth63V4yCu2NcZQZmh0CBvH1bhkcN6LRj/dAjeTjayay2NaGXa9jEV1wE4rgvRlubnNeUStSO
 NPQXoEwXrA8Ust/O5rYa2D3Sjqt8Y9zoQu1qlyriNx5MtEcaYaEezNXIA4awMwEThlOhCEwP5W
 D7ATSbpHy6Uq8Ljc6TM+97zYAjFv/09n2avGF/DcfFR+zoF7K8EPXKNK1QUvqrW2m27CjBOdcY
 wPuSNyXmx8zLMPz4aVbUCWqZBSb8yr0WapJ704dlVuaadu0QA1xOV5Od1gCmSfv+ZgRbCNiE1t
 3XA=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:58:30 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 10/23] target/iscsi: remove unsed macro TEXT_LEN
Date:   Sat, 27 Feb 2021 21:56:32 -0800
Message-Id: <20210228055645.22253-11-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the unused macro that fixes the following compilation warning:-

drivers/target//iscsi/iscsi_target_nego.c:31: warning: macro "TEXT_LEN" is not used [-Wunused-macros]
#define TEXT_LEN 4096

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

