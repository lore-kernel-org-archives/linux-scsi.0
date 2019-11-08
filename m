Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A52CC5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE94D2178F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:29:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="m42Dt3Pl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfKHI3E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:29:04 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:21333 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfKHI3E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 03:29:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573201804; x=1604737804;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=a9NTSHio6xx22Fyu71wO2ofDUyx3CgnJo/lvLDxRkmw=;
  b=m42Dt3Pl6OFaSTPQbATnCvQCHBoahraf25W9Wm/ptbLdAH4lvbDktgai
   C0Q7QRvb+btGYD9ceclq/3QmlqxtvnTirqs3G80epMubJoQX2bDB9lGTV
   m+F52VeUBLjHLhE4ziAPjyCS29pOfxq5NlgaO1/Fir++FK6z0RuxcAm4D
   q8p8Zdv2nc68xLqLnV0kwVjWuyjoeUdqu0BAzzwYS0ZdQrGvEPtjSoZYc
   vbynbYhAG4O75iqgCJBisKntXZSUS+VzkCPPS5tQDNeAIxWp7x+XuusA4
   IVRORl0OpoRoPqXxRlACr4+zHItG8Cxfitb9z4SLaIGFKf4NrgItFivLm
   w==;
IronPort-SDR: CCh+pFyexuxs/FhmjQG6Q9clG9NHW3CLz7P2HIizRrbKYLgS2g/n1zAmERJ0NC6dy9dhJyEy4j
 wnv1Eu+cu+/LwE+9Qdhx0O0myWhQqp/Fze3vXv0o1y4UMNHVuUlp9cmPmlIEDefjq+zHHA5vZU
 vwLuZPN7jIxTfUvhZGFtQthTK/bfzBBsEgJO4Qh1r+STSl8uhw6KRe6Vg2aojeXN2o5enrfWNz
 DJe4CDVJRpckj08jkb7s8VP4aunaMkUvCLrNe+HFYckbJ+b1J4sAwpixDcJ0EViajK7TlU+AVK
 oSg=
X-IronPort-AV: E=Sophos;i="5.68,280,1569254400"; 
   d="scan'208";a="223680323"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2019 16:30:04 +0800
IronPort-SDR: tyQRd5goDw0Fhn/F+YXTja95S4aARrT3ZelRKgVFf8Hex1VBHy0BCJDYYlg6R9iddLl2XKsR5K
 kVP+ipinbjbJSX5jTSqMpWpcuR/Yn8mwL7OsoiUfBPQABaBYBERi+ADOjM85WSyhyJWgY1fzih
 0mE40ODSj+yYD9JOOUlhm7adQjHqO8OkOuHbkedgosPHDxGPj1ViRY3lxZaCTUF4SOo2wFpOds
 lHMZAPPG6PKSyMlimjJ2qVdMs7qRWOFBXjNohCPovy7Ss2tAIJYATg1TG0DemESOj5E/lmg5TN
 iU2Cwl2Da/PWqkmZkcJ4PHsT
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 00:24:12 -0800
IronPort-SDR: GSEOgYsfhsaFpSxnUsaBvZXGo5mPlKs5aFU22Lj/gQHdvZ0XA3REmMkT6Yy9ESs9tgi10n0+vh
 HmWmi1Jbxv4r30VRvadZp7g6pvrWDo3VH8qCZgxKKqTwRtPA6SrH1QbA2cU+YG6t0l65jln9Zj
 djgbvsRNfptLdiHYd/ivLWQ9ihFnfDeO3Uy+jBN7q9u0Ya4c25IZghcpb1mEDX81JGe3bNIGJr
 /kr/UvxkqKiCTaIIEn1OUFa+dq8qBbvC2fsonLCUmQUfQoNQaUN4ZXKLW9BuzMSvo2239qmgs/
 RsQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2019 00:29:02 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH v2] target: core: Prevent memory reclaim recursion
Date:   Fri,  8 Nov 2019 17:29:01 +0900
Message-Id: <20191108082901.417950-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prevent recursion into the IO path under low memory conditions by using
GFP_NOIO in place of GFP_KERNEL when allocating a new command with
tcmu_alloc_cmd() and user ring space with tcmu_get_empty_block().

Reported-by: Masato Suzuki <masato.suzuki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---

Changes from v1:
* Added reported-by tag

 drivers/target/target_core_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 35be1be87d2a..0b9dfa6b17bc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -499,7 +499,7 @@ static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
 			schedule_delayed_work(&tcmu_unmap_work, 0);
 
 		/* try to get new page from the mm */
-		page = alloc_page(GFP_KERNEL);
+		page = alloc_page(GFP_NOIO);
 		if (!page)
 			goto err_alloc;
 
@@ -573,7 +573,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 	struct tcmu_cmd *tcmu_cmd;
 
-	tcmu_cmd = kmem_cache_zalloc(tcmu_cmd_cache, GFP_KERNEL);
+	tcmu_cmd = kmem_cache_zalloc(tcmu_cmd_cache, GFP_NOIO);
 	if (!tcmu_cmd)
 		return NULL;
 
@@ -584,7 +584,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
 	tcmu_cmd->dbi_cnt = tcmu_cmd_get_block_cnt(tcmu_cmd);
 	tcmu_cmd->dbi = kcalloc(tcmu_cmd->dbi_cnt, sizeof(uint32_t),
-				GFP_KERNEL);
+				GFP_NOIO);
 	if (!tcmu_cmd->dbi) {
 		kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 		return NULL;
-- 
2.23.0

