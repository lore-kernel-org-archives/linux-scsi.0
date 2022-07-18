Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D90C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 15:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235391AbiGRP0S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiGRP0P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 11:26:15 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A23B286FF;
        Mon, 18 Jul 2022 08:26:13 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 87CA1411FD;
        Mon, 18 Jul 2022 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1658157971; x=1659972372; bh=ixVEhoT2YJBgYHUnIF7qjt+OP
        uhWHzCI4cNU+hzt7ew=; b=FcQXOc/22RLDTC9RJudWrgwiznb2AN5fa/4u6IKpZ
        oQ40IheviZTRCGDazmSOVhFr1Fc8zy9Gvw4gAG5Xdl8rJaJyWu8+K7HFlEVBmjoB
        uQtcjxbsyKVWIuFMl+P76P4MLpD8eYcJrJ7BeuO746rkBUXJZO/RwRO4tqERBI6/
        zQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ER9f5WtjJ_Lr; Mon, 18 Jul 2022 18:26:11 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 90E0D4126D;
        Mon, 18 Jul 2022 18:26:09 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Jul 2022 18:26:09 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 18 Jul 2022 18:26:08 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 4/4] target: iscsi: not require target authentication
Date:   Mon, 18 Jul 2022 18:25:55 +0300
Message-ID: <20220718152555.17084-5-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718152555.17084-1-d.bogdanov@yadro.com>
References: <20220718152555.17084-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RFC7143 states that Initiator decides what type of authentication to
choice:
The initiator MUST continue with:
    CHAP_N=<N> CHAP_R=<R>
or, if it requires target authentication, with:
    CHAP_N=<N> CHAP_R=<R> CHAP_I=<I> CHAP_C=<C>

Allow one way authentication if mutual authentication is configured.
That passes some tests from Windows HLK for Mutual CHAP with iSNS.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target_auth.c |  8 +++++++-
 drivers/target/iscsi/iscsi_target_nego.c | 10 +++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index a5b72968f356..c8a248bd11be 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -416,7 +416,13 @@ static int chap_server_compute_hash(
 	/*
 	 * Get CHAP_I.
 	 */
-	if (extract_param(nr_in_ptr, "CHAP_I", 10, identifier, &type) < 0) {
+	ret = extract_param(nr_in_ptr, "CHAP_I", 10, identifier, &type);
+	if (ret == -ENOENT) {
+		pr_debug("Could not find CHAP_I. Initiator uses One way authentication.\n");
+		auth_ret = 0;
+		goto out;
+	}
+	if (ret < 0) {
 		pr_err("Could not find CHAP_I.\n");
 		goto out;
 	}
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index a167fab80588..f2919319ad38 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -62,15 +62,15 @@ int extract_param(
 	int len;
 
 	if (!in_buf || !pattern || !out_buf || !type)
-		return -1;
+		return -EINVAL;
 
 	ptr = strstr(in_buf, pattern);
 	if (!ptr)
-		return -1;
+		return -ENOENT;
 
 	ptr = strstr(ptr, "=");
 	if (!ptr)
-		return -1;
+		return -EINVAL;
 
 	ptr += 1;
 	if (*ptr == '0' && (*(ptr+1) == 'x' || *(ptr+1) == 'X')) {
@@ -84,12 +84,12 @@ int extract_param(
 
 	len = strlen_semi(ptr);
 	if (len < 0)
-		return -1;
+		return -EINVAL;
 
 	if (len >= max_length) {
 		pr_err("Length of input: %d exceeds max_length:"
 			" %d\n", len, max_length);
-		return -1;
+		return -EINVAL;
 	}
 	memcpy(out_buf, ptr, len);
 	out_buf[len] = '\0';
-- 
2.25.1

