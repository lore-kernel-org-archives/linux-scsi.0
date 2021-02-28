Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F42EC433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 543A464E4A
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhB1GAM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:00:12 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:30790 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhB1GAI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:00:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492008; x=1646028008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ffxg5rt34+0W+6X6+LGzDD7EK3QeprcJQQxUrjVzy7E=;
  b=LdVrm75Iz552jwnvTZv4+LZeaN23lCfgZS49Kp4f5sNUHL3pArb6f0pN
   Kn5Iu6wyMYBGcBwM9sJ/s0pAmNVQEX1RfTuxoRtYmQ+pvQ18PaA2J8dFY
   G0yJe+b/Yx/en/P3QsVf206W1BgHJ7oN0DoNu3CRurQ04BGpw2venoHjL
   reM2XoY2NxBFBkI7u1pLKYHu6g0W/eAItvAuqIexfMUHRDnHQBiLn7nbg
   OQp96XcqDagzeCpjK7Uhu+cDErvLIJhg8usDgMIxRkG62L2hXlpG3hSri
   zO8B0uddYcSchhI7HM44IxM0kbb7nMxbyd1E+ramKWO7DrtA/3/6OCGx6
   w==;
IronPort-SDR: M499dDfj3zTnC94vgio5sYXiOT9f4RhhQ3P5Wk+Pd6H5MxKk1TsgPthPb1Q+CEwj0oWX3dw8Ns
 DosdUvlOe6mH6oLAElNTH7r3r91DsciHNlQVLu0zIYPg8PQobQl5GTJ3YyOfYXgyY1gBIIpCXR
 +F2EoPLnMmjCwlvYH5tqCmNdrfANi17Y4LEBAGDDuww1cPC5QillhQiPKSmVHwcCtB8j76ZT09
 9107cTDQVGAyQEV5+psgGjKY3sb39EKmMes1puY9qG3JsXBvRLlLxvv11TxU85G0GoIK/4Krkk
 GZY=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="160972989"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:59:00 +0800
IronPort-SDR: A2M3b2nAMe+Sa/gzZ5xD4yGLc1FvNm6Ay78i+a1Yu+FzUZAh4GYZMkxf1yEzaWY/CzrBWbxAFP
 OpZ0sDqkaTWldJFJ2DYHKedaRHY+ke1SJR7nQxFLX9bFAC86cY3z78nFUKk+eFemN6pQJgpvnY
 tEWXcO2/FngcPFd0eZnGbkqwweq6R2pELPh7wcHkgASDRG6oVPuBvdINdMj42vzdvQgG+hhroi
 35ksoQJaXn7DUzSz5/OP7m5Mr7Je/RGOg/8/jmSHT4GJtY1W/PHlrnV9Oq/dGr8an2MnJTINle
 IyeA4py5FCzEIeIqSagZ2EkU
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:40:19 -0800
IronPort-SDR: ABHSs0K3IQ21uuNGTt0AqIeTiU0cshomPFgiSn7AvLgLPu8Plz1B3DxRkrjwqlnj394/0isRfW
 Xdku9QkzodfKsmRHRmyiJOgamSxqKu4GmMCjdzl3LLFYug44GQRNajHHlX3Fe9z692PUZkrI6A
 +2hlgdaHYjYmCTnrsmxpAH8w0F63SheTDuR1PpXWfexSTsaA+6UrMzlRhHH0wAyTmjadls96oB
 hcVOr3T10q666TAdmeifCd+IfNyY40/Z6EFpGk442i9TDrMo/zJFTA38zVGsuwezf90NO/TPun
 Cbw=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:59:00 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 14/23] target/configfs: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:36 -0800
Message-Id: <20210228055645.22253-15-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of initializing the array with memset, use declare init pattern
that is present under the kernel tree in other drivers so we can remove
the memset call.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_configfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 56ea47f5cda9..4c60334a1e9f 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1555,11 +1555,9 @@ static ssize_t target_wwn_vpd_protocol_identifier_show(struct config_item *item,
 {
 	struct t10_wwn *t10_wwn = to_t10_wwn(item);
 	struct t10_vpd *vpd;
-	unsigned char buf[VPD_TMP_BUF_SIZE];
+	unsigned char buf[VPD_TMP_BUF_SIZE] = { };
 	ssize_t len = 0;
 
-	memset(buf, 0, VPD_TMP_BUF_SIZE);
-
 	spin_lock(&t10_wwn->t10_vpd_lock);
 	list_for_each_entry(vpd, &t10_wwn->t10_vpd_list, vpd_list) {
 		if (!vpd->protocol_identifier_set)
-- 
2.22.1

