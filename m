Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA723C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 15:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbiGRP0P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiGRP0O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 11:26:14 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D2E286DE;
        Mon, 18 Jul 2022 08:26:12 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5919A404D1;
        Mon, 18 Jul 2022 15:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1658157969; x=1659972370; bh=0zhnVcXRJKTdD5iH8wLK4lnc2
        qAvL+GcKmMvx3TVJ0Y=; b=RXum5ZIaeJtcvjXBYVuUrEciwlO59xmjCs5fCKgJB
        aAaj6em3KbTQx7GJZBpvkRC8jKUymsHrQ9pYNJdpff42U5OExC8+ZUxmHcCmfMU6
        wlpdqtKbFsmqu+U/7j+9KT1FjudtRaezcIpV78gOhUsbZlhvn+NSp+4eZi6ZFmt9
        uE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0VINJSsGnpMe; Mon, 18 Jul 2022 18:26:09 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E4A8F41242;
        Mon, 18 Jul 2022 18:26:08 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Jul 2022 18:26:08 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 18 Jul 2022 18:26:08 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 2/4] scsi: target: iscsi: support base64 in CHAP
Date:   Mon, 18 Jul 2022 18:25:53 +0300
Message-ID: <20220718152555.17084-3-d.bogdanov@yadro.com>
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

RFC7143 allows both Base64 and Hex encoding for CHAP binary entities
like Challenge and Response. Currently Linux iSCSI target supports only
Hex encoding. This patch adds a support of Base64 encoded CHAP Challenge
and CHAP Response that are required for CHAP tests in Windows HLK.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 114 ++++++++++++++++++-----
 drivers/target/iscsi/iscsi_target_nego.c |   3 +
 drivers/target/iscsi/iscsi_target_nego.h |   1 +
 3 files changed, 94 insertions(+), 24 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 6e5611d8f51b..a5b72968f356 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -205,6 +205,38 @@ static struct iscsi_chap *chap_server_open(
 	return chap;
 }
 
+static const char base64_lookup_table[] =
+	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+
+static int chap_base64_decode(u8 *dst, const char *src, size_t len)
+{
+	int i, bits = 0, ac = 0;
+	const char *p;
+	u8 *cp = dst;
+
+	for (i = 0; i < len; i++) {
+		if (src[i] == '=')
+			return cp - dst;
+
+		p = strchr(base64_lookup_table, src[i]);
+		if (p == NULL || src[i] == 0)
+			return -2;
+
+		ac <<= 6;
+		ac += (p - base64_lookup_table);
+		bits += 6;
+		if (bits >= 8) {
+			*cp++ = (ac >> (bits - 8)) & 0xff;
+			ac &= ~(BIT(16) - BIT(bits - 8));
+			bits -= 8;
+		}
+	}
+	if (ac)
+		return -1;
+
+	return cp - dst;
+}
+
 static int chap_server_compute_hash(
 	struct iscsit_conn *conn,
 	struct iscsi_node_auth *auth,
@@ -295,16 +327,27 @@ static int chap_server_compute_hash(
 		pr_err("Could not find CHAP_R.\n");
 		goto out;
 	}
-	if (type != HEX) {
-		pr_err("Could not find CHAP_R.\n");
-		goto out;
-	}
-	if (strlen(chap_r) != chap->digest_size * 2) {
-		pr_err("Malformed CHAP_R\n");
-		goto out;
-	}
-	if (hex2bin(client_digest, chap_r, chap->digest_size) < 0) {
-		pr_err("Malformed CHAP_R\n");
+
+	switch (type) {
+	case HEX:
+		if (strlen(chap_r) != chap->digest_size * 2) {
+			pr_err("Malformed CHAP_R\n");
+			goto out;
+		}
+		if (hex2bin(client_digest, chap_r, chap->digest_size) < 0) {
+			pr_err("Malformed CHAP_R: invalid HEX\n");
+			goto out;
+		}
+		break;
+	case BASE64:
+		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
+		    chap->digest_size) {
+			pr_err("Malformed CHAP_R: invalid BASE64\n");
+			goto out;
+		}
+		break;
+	default:
+		pr_err("Could not find CHAP_R\n");
 		goto out;
 	}
 
@@ -404,23 +447,46 @@ static int chap_server_compute_hash(
 		goto out;
 	}
 
-	if (type != HEX) {
+	switch (type) {
+	case HEX:
+		initiatorchg_len = DIV_ROUND_UP(strlen(initiatorchg), 2);
+		if (!initiatorchg_len) {
+			pr_err("Unable to convert incoming challenge\n");
+			goto out;
+		}
+		if (initiatorchg_len > 1024) {
+			pr_err("CHAP_C exceeds maximum binary size of 1024 bytes\n");
+			goto out;
+		}
+
+		if (hex2bin(initiatorchg_binhex, initiatorchg,
+			    initiatorchg_len) < 0) {
+			pr_err("Malformed CHAP_C: invalid HEX\n");
+			goto out;
+		}
+		break;
+	case BASE64:
+		initiatorchg_len = chap_base64_decode(initiatorchg_binhex,
+						      initiatorchg,
+						      strlen(initiatorchg));
+		if (initiatorchg_len < 0) {
+			pr_err("Malformed CHAP_C: invalid BASE64\n");
+			goto out;
+		}
+		if (!initiatorchg_len) {
+			pr_err("Unable to convert incoming challenge\n");
+			goto out;
+		}
+		if (initiatorchg_len > 1024) {
+			pr_err("CHAP_C exceeds maximum binary size of 1024 bytes\n");
+			goto out;
+		}
+		break;
+	default:
 		pr_err("Could not find CHAP_C.\n");
 		goto out;
 	}
-	initiatorchg_len = DIV_ROUND_UP(strlen(initiatorchg), 2);
-	if (!initiatorchg_len) {
-		pr_err("Unable to convert incoming challenge\n");
-		goto out;
-	}
-	if (initiatorchg_len > 1024) {
-		pr_err("CHAP_C exceeds maximum binary size of 1024 bytes\n");
-		goto out;
-	}
-	if (hex2bin(initiatorchg_binhex, initiatorchg, initiatorchg_len) < 0) {
-		pr_err("Malformed CHAP_C\n");
-		goto out;
-	}
+
 	pr_debug("[server] Got CHAP_C=%s\n", initiatorchg);
 	/*
 	 * During mutual authentication, the CHAP_C generated by the
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index fb93a1173954..767646438391 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -76,6 +76,9 @@ int extract_param(
 	if (*ptr == '0' && (*(ptr+1) == 'x' || *(ptr+1) == 'X')) {
 		ptr += 2; /* skip 0x */
 		*type = HEX;
+	} else if (*ptr == '0' && (*(ptr+1) == 'b' || *(ptr+1) == 'B')) {
+		ptr += 2; /* skip 0b */
+		*type = BASE64;
 	} else
 		*type = DECIMAL;
 
diff --git a/drivers/target/iscsi/iscsi_target_nego.h b/drivers/target/iscsi/iscsi_target_nego.h
index ed30b9ee75e6..21d3cab90d08 100644
--- a/drivers/target/iscsi/iscsi_target_nego.h
+++ b/drivers/target/iscsi/iscsi_target_nego.h
@@ -4,6 +4,7 @@
 
 #define DECIMAL         0
 #define HEX             1
+#define BASE64          2
 
 struct iscsit_conn;
 struct iscsi_login;
-- 
2.25.1

