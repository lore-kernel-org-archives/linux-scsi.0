Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_HEADER_CTYPE_ONLY,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B97C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 11:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E2362068D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 11:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gUDyfHzj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgKILRi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 06:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgKILRe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 06:17:34 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFCFC0613CF
        for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2020 03:17:33 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f18so2395842pgi.8
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2020 03:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XwaPnflY4aOcOvSKzwyv5f1z8l/fujjz6jlR34MaqzQ=;
        b=gUDyfHzjV6PkDlm4uoMiX0wx0LPXQ6ww8ynDUsEsJFtUT31rMmcWVqFMr4aoQedLee
         UNgEFAjNYzgxUC8KKAxFZftKjXI8Zst62HWvbvYnApG6fTTw5e7o9DMEzwmppmlhz1Q6
         LWXrdVBApZ8PuH8zMWdlaUEmA3XnIThyuqU7M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XwaPnflY4aOcOvSKzwyv5f1z8l/fujjz6jlR34MaqzQ=;
        b=t6+CdIlKHkXKLQqerAywFsSYDNBBDtwHPFvt6Nnf1Dwyp3LLippyYA4Ny+iuW0lPIW
         CfmnFbrxlAJZNv7ceHP11szHAN3g8GDF1/PdShbXFJqfcLVLLS7NIrbbWYoicQM9DKie
         uSIXBRIsHpYaToPonlxSwUlOtGwbgNpOZilXPyWEu64AgWudsQjSqOrC1QTJleMQANxl
         TVGj4Lalbe3sUdLG8YCMlQs7LDaNeEnjvLiuM/3eiTmkz4OW46j+5MD9H93uSlH5x/jS
         sG/ReAyCGm7aGdENZMJXow2+5KkntfS2t8sVVMEA6OY6Rj0EEXVjimexg8/h05+5dMFG
         Cefw==
X-Gm-Message-State: AOAM53039oB+UqZPOQ6ua/0gp/bw+On4twIPxJ8plrnqruqdzwiaLnag
        eseMHvhb/N8Jw0euRDxJ8q84Bg==
X-Google-Smtp-Source: ABdhPJzXAJ6MkDCZuEoyQYFhqM/qPNoLHRDU7IPXCt1FTRibYCzfL7GXIV0DDA0gxcScuyDl9h5NZQ==
X-Received: by 2002:a63:174b:: with SMTP id 11mr12641266pgx.57.1604920653379;
        Mon, 09 Nov 2020 03:17:33 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k9sm10889364pfp.68.2020.11.09.03.17.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Nov 2020 03:17:32 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com, Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v4 02/19] blkcg: Added a app identifier support for blkcg
Date:   Mon,  9 Nov 2020 09:53:48 +0530
Message-Id: <1604895845-2587-3-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000075c4a005b3aab5cb"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000075c4a005b3aab5cb

This Patch added a unique application identifier i.e
app_id  knob to  blkcg which allows identification of traffic
sources at an individual cgroup based Applications
(ex:virtual machine (VM))level in both host and
fabric infrastructure.

Provided the interface blkcg_get_fc_appid to
grab the app identifier associated with a bio.

Provided the interface blkcg_set_fc_appid to
set the app identifier in a blkcgrp associated with cgroup id

Added a new config BLK_CGROUP_FC_APPID and moved the changes
under this config

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v4:
No change

v3:
Renamed the functions and app_id to more specific

Addressed the reference leaks in blkcg_set_app_identifier

Added a new config BLK_CGROUP_FC_APPID and moved the changes
under this config

Added blkcg_get_fc_appid,blkcg_set_fc_appid as inline functions

v2:
renamed app_identifier to app_id
removed the  sysfs interface blkio.app_identifie under
---
 block/Kconfig              |  9 ++++++
 include/linux/blk-cgroup.h | 65 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/block/Kconfig b/block/Kconfig
index bbad5e8bbffe..ed22df654ce5 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -144,6 +144,15 @@ config BLK_CGROUP_IOLATENCY
 
 	Note, this is an experimental interface and could be changed someday.
 
+config BLK_CGROUP_FC_APPID
+	bool "Enable support to track FC io Traffic across cgroup applications"
+	depends on BLK_CGROUP=y
+	help
+	Enabling this option enables the support to track FC io traffic across
+	cgroup applications.It enables the Fabric and the storage targets to
+	identify, monitor, and handle FC traffic based on vm tags by inserting
+	application specific identification into the FC frame.
+
 config BLK_CGROUP_IOCOST
 	bool "Enable support for cost model based cgroup IO controller"
 	depends on BLK_CGROUP=y
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index c8fc9792ac77..00ea1cfa3420 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -30,6 +30,8 @@
 
 /* Max limits for throttle policy */
 #define THROTL_IOPS_MAX		UINT_MAX
+#define APPID_LEN              128
+
 
 #ifdef CONFIG_BLK_CGROUP
 
@@ -55,6 +57,9 @@ struct blkcg {
 	struct blkcg_policy_data	*cpd[BLKCG_MAX_POLS];
 
 	struct list_head		all_blkcgs_node;
+#ifdef CONFIG_BLK_CGROUP_FC_APPID
+	char                            fc_app_id[APPID_LEN];
+#endif
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head		cgwb_list;
 #endif
@@ -660,4 +665,64 @@ static inline void blk_cgroup_bio_start(struct bio *bio) { }
 
 #endif	/* CONFIG_BLOCK */
 #endif	/* CONFIG_BLK_CGROUP */
+
+#ifdef CONFIG_BLK_CGROUP_FC_APPID
+/*
+ * Sets the fc_app_id field associted to blkcg
+ * @buf: application identifier
+ * @id: cgrp id
+ * @len: size of appid
+ */
+static inline int blkcg_set_fc_appid(char *buf, u64 id, size_t len)
+{
+	struct cgroup *cgrp = NULL;
+	struct cgroup_subsys_state *css = NULL;
+	struct blkcg *blkcg = NULL;
+	int ret  = 0;
+
+	cgrp = cgroup_get_from_kernfs_id(id);
+	if (!cgrp)
+		return -ENOENT;
+	css = cgroup_get_e_css(cgrp, &io_cgrp_subsys);
+	if (!css) {
+		ret = -ENOENT;
+		goto out_cgrp_put;
+	}
+	blkcg = css_to_blkcg(css);
+	if (!blkcg) {
+		ret = -ENOENT;
+		goto out_put;
+	}
+	if (len > APPID_LEN) {
+		ret = -EINVAL;
+		goto out_put;
+	}
+	strlcpy(blkcg->fc_app_id, buf, len);
+out_put:
+	css_put(css);
+out_cgrp_put:
+	cgroup_put(cgrp);
+	return ret;
+}
+
+/**
+ * blkcg_get_fc_appid - grab the app identifier associated with a bio
+ * @bio: target bio
+ *
+ * This returns the app identifier associated with a bio,
+ * %NULL if not associated.
+ * Callers are expected to either handle %NULL or know association has been
+ * done prior to calling this.
+ */
+static inline char *blkcg_get_fc_appid(struct bio *bio)
+{
+	if (bio && bio->bi_blkg &&
+			strlen(bio->bi_blkg->blkcg->fc_app_id))
+		return bio->bi_blkg->blkcg->fc_app_id;
+	return NULL;
+}
+#else
+static inline int blkcg_set_fc_appid(char *buf, u64 id, size_t len) { return -EINVAL; }
+static inline char *blkcg_get_fc_appid(struct bio *bio) { return NULL; }
+#endif /*CONFIG_BLK_CGROUP_FC_APPID*/
 #endif	/* _BLK_CGROUP_H */
-- 
2.26.2


--00000000000075c4a005b3aab5cb
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
J/4V6ms/nIUi+/4vPYjckYUbRzkXm1/X0IyUfpp5cgdrFn9jBIk69fQGAUEhnVvwcXnHWotYxZFd
Xew5Fz0CAwEAAaOCAdMwggHPMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYI
KwYBBQUHMAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxz
aWduMnNoYTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5j
b20vZ3NwZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsG
AQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAA
MEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNp
Z24yc2hhMmczLmNybDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMG
A1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFGlygmIxZ5VEhXeRgMQENkmdewthMB0GA1Ud
DgQWBBR6On9cEmlB2VsuST951zNMSKtFBzANBgkqhkiG9w0BAQsFAAOCAQEAOGDBLQ17Ge8BVULh
hsKhgh5eDx0mNmRRdhvTJnxOTRX5QsOKvsJGOUbyrKjD3BTTcGmIUti9HmbqDe/3gRTbhu8LA508
LbMkW5lUoTb8ycBNOKLYhNE8UEOY8jRTUtMEhzT6NJDEE+1hb3kSGfArrrF3Z8pRYiUUhcpC5GKL
9KsxA+DECRfSGfXJJQSq6nEZUGKhz+dz5CV1s8UIZLe9HEEfyJO4eRP+Fw9X16cthAbY0kpVnAvT
/j45FAauY/h87uphdvSb5wC9v5w4VO0JKs0yNUjyWXg/RG+6JCvcViLFLAlRCLrcRcVaQwWZQ3YB
EpmWnHflnrBcah5Ozy137DGCAm8wggJrAgEBMG0wXTELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEds
b2JhbFNpZ24gbnYtc2ExMzAxBgNVBAMTKkdsb2JhbFNpZ24gUGVyc29uYWxTaWduIDIgQ0EgLSBT
SEEyNTYgLSBHMwIMX/krgFDQUQNyOf+1MA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEi
BCAEf47OisalIfoHCR2bm1uVZZlEATf5AB4jQEj97eql5jAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDkxMTE3MzNaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAiYQLWPrNjt5sguwb
PJw9q3cWTx9o6/zQY4WCkTL2hHT0H4RVpuKhFSwy3Hgrp9rYp6xp65QacHfWt/58/Is/tTPKvyxm
k1SzhWsRa+NiylSn5fr0sUmFZHJ3jmexW02xVzCveYpXEoy7a2TjGesz5yaTRiMcV4BoCn3nLbVT
I72lthUaufB/Q2v1oXIvpyaQAxNDrAF/GRij2WE6YugeLUeErT4IHgSijsFeXzzVQDlJPqYXmBC1
b8NURu3Lq5p3VBiSZSYY88ihhKQrwIlqlA3LfbLO48581AdhyEHsr4g15Axof+NR1hpUoPVGJOrh
ZmjnZITCnCUp2FsCTaVgGw==
--00000000000075c4a005b3aab5cb--
