Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A663AC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7507764E4A
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 05:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhB1F7u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 00:59:50 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34894 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhB1F7q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 00:59:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492687; x=1646028687;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wPdIvppD0YsC5I7aHdBmZrV0Q8Rh2FzwPy4aY7o3FMk=;
  b=pIlPnPgWak9YcrRUId9w96jN2Dxcq4r2W2lsdvu3zYGVxTMcIcO3Yna+
   fIGbm7eWUyrzjEsuiOI9A0ONR8qT9TNqDcFlE2MkDbfzT8QG1ImJn8zKS
   obbicbXy+I7sKIjsTWGFKla4kXRl15sL/ioX9A0RDwsDAfHu+54bE/oXQ
   B05bj55agX90VBaPmov6wRNrHYkRYITX+EwogOwQQXe05Dh3csypjZCkj
   WSI34o2qnGxKl7tsIkvvjFq/O4Bc8q/Z/4AW+elD7OEXhvBohWlthDinE
   QukCwsbOtYWGaFJyPKuD4/qDP0RIs8QQLh5GvNMVyQer4XYJjAn3vhkXV
   A==;
IronPort-SDR: Ug8pQgtoMs5+E061BMwemvCTkFUtZ1CJxR690L6eQhTFX2RxrV4roQyVqTC5neJjaAqTtGljQ1
 svBsFvMZyaMQGGdFnGvsuxjm8RIEm4AamD8uHmZq6V10/q9S65OjGVASwdN116hx9MRtXyf/ye
 pdrHg2ZDLXIwGLcLnF6yx9ldevRwJTLhbHUbO1ePbBjNoxp8Z40tQYXIbWbn/0v9F2ekJdTZA6
 lQsRFC9nfQWju/699xORQ8xIxrMG0U2bvIwI8TNgP2EFB8EL2E0g8ZGuc4dbVnOtYHC91jP0Dx
 ZR0=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="265236080"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 14:08:59 +0800
IronPort-SDR: Fp2xBH0LQTu/Ba8VMc1E9X0Pxqn5pD1w18Pfn3RHRQikvemoZRwv+C11H3Ilu51X7bB1RxGfXO
 ew/fuhV2AVzroh9C9O4RvIi5RORsXlwv2AGdSAs3vxzT3LGR4xntwV7yCDeEpsPhxDkm/4cRar
 cO0GF+q6mdVwh5D1XncoqS22vJh6RcWWtMiRWOrMi+Zta+J3G3OfzcPUBe5KCT0mejFl8rD+Iu
 v4GLoaQvs29+9ORKy25ZFpzua0J28Xr3FUOZParbic2RNR+7MUM9Hzi8HYEEEtUGDgX1RCH/+7
 mR/l8BDbySi/8l2X3czogr3W
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:41:18 -0800
IronPort-SDR: zc63QTPprKAyK0tS4S22G+LQT1cONyRWNTeWQTBCiUJcOEbi/Ewx1u7lYJbyB1GTKQZhzoas2i
 AIWAEL0sCmX92F0jEiBM4/OiaSwYa5kic+h3ypLvFr/y0ywc9pzMkvkbjb6Pzvr0EiIV55R47R
 TRyUEmmm4sn+qjaC4GuIx9/PHZQgYjXpSd8viCiPYHUOH/H4BSgUvYhPa9Df2/JQRZreNm4ofh
 eRW8NUIoQCox93EW2slwejn9tEH9CUG97trxOzpjUxaPY/7BPbJNGvpHa1oDZRBNjtARQeMzSJ
 Mek=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:58:08 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 07/23] target/stat: remove unsed macro ISPRINT
Date:   Sat, 27 Feb 2021 21:56:29 -0800
Message-Id: <20210228055645.22253-8-chaitanya.kulkarni@wdc.com>
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

drivers/target//iscsi/iscsi_target_stat.c:36: warning: macro "ISPRINT" is not used [-Wunused-macros]
#define ISPRINT(a)   ((a >= ' ') && (a <= '~'))

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

