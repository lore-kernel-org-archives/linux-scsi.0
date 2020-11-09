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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5CBC2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 11:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE79120897
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 11:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bys6JMDg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgKILRc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 06:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbgKILRa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 06:17:30 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B96C0613CF
        for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2020 03:17:30 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c66so2136340pfa.4
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2020 03:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bYaqDyHlUOGibR7tX3hHCoOSVm1gaUK15169GGLsr6o=;
        b=bys6JMDgvlSlg6km/faITtL0+PGteN2C0zS3eg4Y24KOB4gIiYEQG5/yUnx4J0bVJ1
         2f/e87dbVTux92JiJ9Nbl5Qso7CEh0q9NcbnZchV/xFauNIHXoBZVjordIazGO8bj2sG
         t3JxfL2Ga+iSmfhDokgLoB9UrqLbZmGfxxLoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bYaqDyHlUOGibR7tX3hHCoOSVm1gaUK15169GGLsr6o=;
        b=I0RAgf0fjgANdPqZGC9ELzQZPJVuloQdlC/k0upJv6Vc8tZqvmyrbJbOluWY7afbD0
         rWbnrDbQLJ5LVPxsWhDupa+zVsuhPayJGqHAFUYNAnVAB19bUKGfQkcOt0+D9W3CCVa6
         lkKi9TakMV4vzVCZxDCve1x49qEGSv8Rh2vxDDuYJxGspH+98IsNCQsqrUvrns0HA8Kn
         QMOBhb5hxFYuE4XCQopDI+BXrebKasAKF7IMy/qG4hoJSq+tqSkfp5NVfImAmnVz/QRR
         3GZVr+7G/vWw2se9CiNFPBtFqFZotwhh+C+W2raIF5onrVnPIqJXyocoCPj9F5NJtBpv
         nUXw==
X-Gm-Message-State: AOAM533msd1YYzyWDJGRLpZydwc7olM93bI+wgwiFmSqeAQT3PX2ZIfn
        C/mSCpiOEgKVYZlJ4Vt+p9jA5g==
X-Google-Smtp-Source: ABdhPJwWUEgPyCdgMOJLastt8Q8dPEQ5cCal+j3gGAoHpcak4z3S4xrigxKUtcyNFoqXHfdMNCPlzw==
X-Received: by 2002:a05:6a00:88d:b029:164:5a00:29b8 with SMTP id q13-20020a056a00088db02901645a0029b8mr13935521pfj.10.1604920649995;
        Mon, 09 Nov 2020 03:17:29 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k9sm10889364pfp.68.2020.11.09.03.17.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Nov 2020 03:17:29 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com, Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v4 01/19] cgroup: Added cgroup_get_from_kernfs_id
Date:   Mon,  9 Nov 2020 09:53:47 +0530
Message-Id: <1604895845-2587-2-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1604895845-2587-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000041a05105b3aab5ad"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000041a05105b3aab5ad

Added a new function cgroup_get_from_kernfs_id  to retrieve the cgroup
associated with cgroup id.
It takes cgroupid as an argument and returns cgrp and on failure
it returns NULL.
Exported the same as this can be used by blk-cgorup.c

Added function declaration of cgroup_get_from_kernfs_id in cgorup.h
Exported the cgroup_get_e_css

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v4:
No change

v3:
Exported the cgroup_get_e_css

v2:
New patch
---
 include/linux/cgroup.h |  6 ++++++
 kernel/cgroup/cgroup.c | 26 ++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 618838c48313..1741f02a41d6 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -696,6 +696,7 @@ static inline void cgroup_kthread_ready(void)
 }
 
 void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen);
+struct cgroup *cgroup_get_from_kernfs_id(u64 id);
 #else /* !CONFIG_CGROUPS */
 
 struct cgroup_subsys_state;
@@ -743,6 +744,11 @@ static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
 
 static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 {}
+
+static struct cgroup *cgroup_get_from_kernfs_id(u64 id)
+{
+	return NULL;
+}
 #endif /* !CONFIG_CGROUPS */
 
 #ifdef CONFIG_CGROUPS
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dd247747ec14..53046deeb9ca 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -580,6 +580,7 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
 	rcu_read_unlock();
 	return css;
 }
+EXPORT_SYMBOL_GPL(cgroup_get_e_css);
 
 static void cgroup_get_live(struct cgroup *cgrp)
 {
@@ -5803,6 +5804,31 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 	kernfs_put(kn);
 }
 
+/*
+ * cgroup_get_from_kernfs_id : get the cgroup associated with cgroup id
+ * @id: cgroup id
+ * On success it returns the cgrp on failure it returns NULL
+ */
+struct cgroup *cgroup_get_from_kernfs_id(u64 id)
+{
+	struct kernfs_node *kn;
+	struct cgroup *cgrp = NULL;
+
+	mutex_lock(&cgroup_mutex);
+	kn = kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
+	if (!kn)
+		goto out_unlock;
+
+	cgrp = kn->priv;
+	if (cgroup_is_dead(cgrp) || !cgroup_tryget(cgrp))
+		cgrp = NULL;
+	kernfs_put(kn);
+out_unlock:
+	mutex_unlock(&cgroup_mutex);
+	return cgrp;
+}
+EXPORT_SYMBOL_GPL(cgroup_get_from_kernfs_id);
+
 /*
  * proc_cgroup_show()
  *  - Print task's cgroup paths into seq_file, one line for each hierarchy
-- 
2.26.2


--00000000000041a05105b3aab5ad
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
BCBxSe2h9OvDO31uqn2H/fumo3G+stGTSR0kGKakhMupSTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDkxMTE3MzBaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAxTkoGGslokf1vAjF
gAf/1sF9U4x7ygN8zUtBRkmq96OQYjOLa/AXbLQKhXhfdosGtGEnQOwoVLVviqRfV7sYgeI5rQtC
ipK3M1+CKCY5pNaEQjo/VUIpiJ8FKPmk5DAY33RqFpACC1LlRQpgm9lSUYOFVa+ydXJsqYJzFywt
DwxG0iRpGIq8wqHZckASwCwQV7kBGZ+B2gYwU+xl7+VOc43MdKKlOba1E/8CjLVGMZo3gdOzb5pX
Man9HfFKZWHMI32gyQ+J0j5GaqbqbGBEFkh2kaSqcMHpm8Kus20CTVu1lIEIoa8tE6NfiVoZHQNQ
tB8fOtulBJkjcKPW4kGiGA==
--00000000000041a05105b3aab5ad--
