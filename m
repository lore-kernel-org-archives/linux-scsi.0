Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11E6C433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B785F64E4A
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhB1GB0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:01:26 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23239 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbhB1GBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:01:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492060; x=1646028060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wng4eyKHQVoNSBh/6v3kyiCfAzNiavkALjRIlkS4Lyo=;
  b=n0dPjJNCPe6e/CSiUpINUygFbIQyNzaDVCw5Cji+a7Fm4/AumlQDmdc2
   6v7zHsnTeKfMlvwS5pVS2M7uDyChtQCiMIMGJF1rXRQbeQMsfx4gIsQKf
   KehZrqp+UaX6aQmejbPX5wLRar7jvDhTbdGvZPrljTJCZV0EJULoLWkDF
   kwCQkyo+ZKEi3cQFQH8T0s9rheRWalswT0XlGi9gmqYqCGoWz988MmSx/
   2i/AVxKImjHXD83MGynhLUQ2zWvBgzuPbzK6IejDoGBZCtlTY+P1wsA68
   hRGYKbTVr0qwLJNCxyzlmbY+mb6h6uic28AkL/q2u88wEu3fBfhRAwcyM
   w==;
IronPort-SDR: rZ8NYANNBtz47ya8W2EfC3mqe/XwLdLVJGyzxA09Hzy1faDEgkCejUZY5ZGQ2/F8HN3G8Va+l1
 uivVaZBq2g1tJWtfMqnNNMuy3na+2irW3IZHFGNk5GXD/xvo7/wsdm7jEu+CP/jTlBHvO/GsER
 IIezdXBMDX+THSgcfWWVSozyun4YZ+s98mmDSISRIssTu9lAKo1ARUAKczFnTGNxHg/ake3sbT
 c9thirQrcmAZMBq0KcMBBbamfkwagCsbWdEmY58F61WdGYrQuQIsaag/Xw9GbVgdtUUyw6WPJ6
 z9U=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="271564157"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:59:55 +0800
IronPort-SDR: /dzT1vWvnsw8QgFFH2Uzz6cx9tvpXeGTnPRE7bCmWPmwDkT8aeKTkl9Nrbh8t+DtCCSRFs4jF8
 HVsz2gTBMkzf5/oQtwYL6+vN1TUxtNUtKv7Yq2ZAwIXIzZaeNgZ5gv3s0U6vqgViyifqkm+pkt
 ZBg4W/hxBlgB01AQ8THTB3Z8w0cN2asPEVUNcf9Tkid03HxoI03apIQozeDfzPYGqK48mzMQ+q
 kYaizZNkJrwddJarYlK1xp2h9CBQSBXZCuuglbbiZJwANLvzVXrpKtamEGQMG4bvNHBiAla3Hj
 quznifBGdsLEDxjd2C8z8rfR
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:41:13 -0800
IronPort-SDR: nph52jcAk2WvGgXmmuguTs4rozAIt1x1piyNM+/Q76++gzd1dZyXTAGe/oZNCGiawkmf/UhoM0
 wIMJ6gzEslwWgdSG8Qfa/CAWtJlCxz046C7k+07zf3h+rCCS8XljsxXOTCqItJJzZgJdNP/9gp
 xlVCHp0x9tkdRzyhXFlcO2q3JLOaQQ/VnAZMDZUzh28GkCqWtCEtQpFE66afDxFZptaGORgfx8
 ujDZkhgq9p88ix0QfhRUQv2MlbPEjnyDekrIxNVPRqQOCHV7R+4J8Zz88henmd6yNfUuN255AD
 4Ak=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:59:55 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 19/23] target/configfs: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:41 -0800
Message-Id: <20210228055645.22253-20-chaitanya.kulkarni@wdc.com>
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
 drivers/target/target_core_configfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index d6554468ef65..9cb1ca8421c8 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3399,11 +3399,10 @@ static struct config_group *target_core_call_addhbatotarget(
 {
 	char *se_plugin_str, *str, *str2;
 	struct se_hba *hba;
-	char buf[TARGET_CORE_NAME_MAX_LEN];
+	char buf[TARGET_CORE_NAME_MAX_LEN] = { };
 	unsigned long plugin_dep_id = 0;
 	int ret;
 
-	memset(buf, 0, TARGET_CORE_NAME_MAX_LEN);
 	if (strlen(name) >= TARGET_CORE_NAME_MAX_LEN) {
 		pr_err("Passed *name strlen(): %d exceeds"
 			" TARGET_CORE_NAME_MAX_LEN: %d\n", (int)strlen(name),
-- 
2.22.1

