Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA163C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC0F64ED5
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBTVjR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:39:17 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:38804 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhBTVjQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:39:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857263; x=1645393263;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xgBVSamztb/QEVlrz/STMNpxk152lgYhByCwg+nA08Q=;
  b=ZrIbHUJXXmJtX/QGcY3vCjij/oSJTtEcTnzIWw/PHyl55jXXFki3Ci31
   F1ik6ybkuTRguVzfKYZfsRQjNMBcVy23UKSkT4sgt2kMDaU9DkmWKVnYj
   YYABi/k2lZZbMgm5JmDsxzGO+8K6HU/pZBVK8neSuffM7fmuhZUNdUli4
   iceOYxX2q0lllDukFteDhP9D+9zV/6eRhR+JgotJJK5LdPbrewdzagPYk
   5fGM1x3IO+rKBgudOw+aGaN0i8Yjjz0YryYmTiy4977+AOxgUW8u5hNQQ
   lCbF5MAOJg3OZXOpQGXdxpJ7lQs75tTnFOwzI8yp0mzj9vQwjPF3DygJs
   g==;
IronPort-SDR: reCtUSe1M4gIHtCNmdVhlPK4Jxzapxy4o/vdwm+Jzwprun1sQ8ua4aGB5FRib60ZI30sQoeqAE
 1AusB/QaBfa4yFXIrcj2L0PXxZIE71gH7zWf98u+w/qOb0ZdhDN+KhuhNYQl8Oy9M2UYGByNCx
 XaPpr5sBp7OZ/rDyL2y+DBbo3rXdPU6ZFcjs0VeQfn0f8xbAc9KQb2SXnodIiVs6/i0r/O2Aqi
 Z/sfP8o4N82dAnSK/rl7sfijVqhUMv97ANUcLjcaFapsnTT+ScxzwW2/ICg0SLk9MY7K7w4WCb
 t1M=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="264605641"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:39:23 +0800
IronPort-SDR: PBtAM9woadnVakEp97aF3EPSLs7+C/i4nkpBv8NsT2b7USgULko1ahmr761tnTTEO/zEsHqot6
 X6Eg5ARYiBVYIm4COipAr2jecMwTKyWBQMln1YORuQCBOT9uXLuCIeFjHSgQt9Nkr0qbRaQ4pS
 6WSisgqeWNKBBZFck5nMniSrm8jRThDr/yX2yP+70j0MrF+3z6bZzMDoNQ+lmXfIQJDo+2BjAj
 m5hBfzjA0+RYGdnWEU5zmNuwoM4Z0iECRSJCOkzvuZQ1Ju6yeOybwvkJ85XN5F7hzP8RsMUnoV
 ruVWcMt1f+8R6Wii35+/t2Sy
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:21:32 -0800
IronPort-SDR: Z/bGi8vOfi1w9naJtYFsMESCvVCozUNtb3jdNU0Kq38N1UPUC++ZDLlR35vJtTra14mErBUMK7
 kbalNrazMrxQ2K+HY/98TkYblzMT5lEEYwviTm/YKb0eqnvBM/VyM5aUXT46UOTMCzRR8M+QIM
 T5yOSrInaRYpZKtE6dhGo5eHAytp3irkzu93AXRBnq9f6Cd52Gq8a8wxlxo4no3guoHiYuUiUV
 7b4yJgiwqdK9um0oMuDVTIlj4gbnRO3a1Oryv+pe0FPPB6nDlrUPm5IlHdeNBiHR/iPBmvJKEP
 f4g=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:38:10 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 07/24] target/stat: remove unsed macro ISPRINT
Date:   Sat, 20 Feb 2021 13:38:08 -0800
Message-Id: <20210220213808.6621-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_stat.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 237309db4b33..2d2c7e377722 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -32,7 +32,6 @@
 #endif
 
 #define NONE		"None"
-#define ISPRINT(a)   ((a >= ' ') && (a <= '~'))
 
 #define SCSI_LU_INDEX			1
 #define LU_COUNT			1
-- 
2.22.1

