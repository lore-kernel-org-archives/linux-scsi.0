Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC6FC19F28
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbiHCQaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238237AbiHCQ3j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:39 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFBA474F4;
        Wed,  3 Aug 2022 09:29:37 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A18BD412E1;
        Wed,  3 Aug 2022 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544175; x=1661358576; bh=jubGnQCrnCDFL33MMWXxIHBDx
        I+VOZF7E1/ZWoaPbsw=; b=SwZnMUBM8ToAfRvUWEPoAu3htANkVUvh//TB32N1J
        QlHTwJgLUL1lfKnuAluKe8F++y9yFjh1XuKl+ZM9nWDqj2JGFXH6Peu3Me2gATmu
        1sJzRvEf8/k6mOWUWSx04cBUAbSBGzdn8P/V3LvGJiwcWrHuF/9CQVghJ2gqsNre
        Gw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MiMwK-Ux0DeK; Wed,  3 Aug 2022 19:29:35 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 026C841283;
        Wed,  3 Aug 2022 19:29:20 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:20 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:19 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 28/48] target: core: add function to compare TransportID
Date:   Wed, 29 Jun 2022 13:06:41 +0300
Message-ID: <20220803162857.27770-29-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803162857.27770-1-d.bogdanov@yadro.com>
References: <20220803162857.27770-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_fabric_lib.c | 27 +++++++++++++++++++++----
 drivers/target/target_core_internal.h   |  2 ++
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 34fdab558e24..0eb03d7b9e78 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -350,22 +350,27 @@ u32 iscsi_parse_pr_out_transport_id(
 	return out_tid_len;
 }
 
-int target_get_pr_transport_id_len(struct t10_pr_registration *pr_reg)
+static int __target_get_pr_transport_id_len(const char *tid)
 {
-	switch (pr_reg->pr_tid[0] & 0xF) {
+	switch (tid[0] & 0xF) {
 	case SCSI_PROTOCOL_FCP:
 	case SCSI_PROTOCOL_SBP:
 	case SCSI_PROTOCOL_SRP:
 	case SCSI_PROTOCOL_SAS:
 		return 24;
 	case SCSI_PROTOCOL_ISCSI:
-		return get_unaligned_be16(&pr_reg->pr_tid[2]) + 4;
+		return get_unaligned_be16(&tid[2]) + 4;
 	default:
-		WARN(1, "Unknown proto_id: %#x\n", pr_reg->pr_tid[0] & 0xF);
+		WARN(1, "Unknown proto_id: %#x\n", tid[0] & 0xF);
 		return -EINVAL;
 	}
 }
 
+int target_get_pr_transport_id_len(struct t10_pr_registration *pr_reg)
+{
+	return __target_get_pr_transport_id_len(pr_reg->pr_tid);
+}
+
 int target_get_pr_transport_id(
 		struct t10_pr_registration *pr_reg,
 		unsigned char *buf)
@@ -378,6 +383,20 @@ int target_get_pr_transport_id(
 	return  len;
 }
 
+int target_cmp_pr_transport_id(
+		struct t10_pr_registration *pr_reg,
+		unsigned char *tid)
+{
+	int len1 =  __target_get_pr_transport_id_len(pr_reg->pr_tid);
+	int len2 =  __target_get_pr_transport_id_len(tid);
+
+	if (len1 != len2)
+		return 1;
+
+	return memcmp(pr_reg->pr_tid, tid, len1);
+}
+
+
 int target_gen_pr_transport_id(
 	struct t10_pr_registration *pr_reg,
 	int proto_id,
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index bbdddcd83fa4..b0d29c30ab1e 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -101,6 +101,8 @@ int	target_fabric_setup_cits(struct target_fabric_configfs *);
 int	target_get_pr_transport_id_len(struct t10_pr_registration *pr_reg);
 int	target_get_pr_transport_id(struct t10_pr_registration *pr_reg,
 				   unsigned char *buf);
+int target_cmp_pr_transport_id(struct t10_pr_registration *pr_reg,
+			       unsigned char *tid);
 int target_gen_pr_transport_id(struct t10_pr_registration *pr_reg,
 			       int proto_id,
 			       const char *initiatorname,
-- 
2.25.1

