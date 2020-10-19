Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4987CC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 14:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0B28222D9
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 14:36:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="IaitxpAe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgJSOgw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 10:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729493AbgJSOgw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 10:36:52 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D64C0613CE
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2020 07:36:52 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id e7so46686pfn.12
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2020 07:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jab7UiBrSBcDJgJGPi3vgYoEAB2gbCP7BwMD0y+Jt7A=;
        b=IaitxpAePj2EdF/gbaY0p0aPhbkgFC+nlbJCjsUkLwLMYi7n0R7I3sjRbE5XNJLskg
         7qYIoVt1FErM42U4PP4wPuKtabMik6er1ZoGTzmh8VkMP+z/uIFk1CXPIW81O1ekamup
         1ujf8UIETkHYDohSY/6tXail8QLAvtTBfMr/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jab7UiBrSBcDJgJGPi3vgYoEAB2gbCP7BwMD0y+Jt7A=;
        b=kA+7jsIpROsfPAaAOJOH2ahEcT+fu0nim6L2nEI6SlheyQnWqDmo3vzBgY6C6MHa2U
         /l1q0+ESWr1taZurF/399BDRSKtKrdNnPXxPgg8LauJPVvbc+lG9/kiRCyEt/15ILTFO
         tFL4M66HPptdBH6Wdwn8LIssmdXCm6+NslQizhb9jiGthw6DtJvcy82USP/KWpo3bBQ4
         AitY9sFz4W105Ki9zfNd1nS6dadfBH1S8/QJfDvWp53N05zOtD2cFnQF6zQBUtiCIuyr
         9ya1LZRh1qdiKZJp+aXepbl5mAoU7OK3pcFMItGgO7j4o4BaEMv1h+xTUFplR1pm8Uba
         ZyDA==
X-Gm-Message-State: AOAM5326EhctK6iLyFHknTisHR/iDm9JBxwHOEay2URYpK4mELJn5qgx
        XQJtBuQElnkpG0Vq26knjXuNaRG9ldirmNiC
X-Google-Smtp-Source: ABdhPJwmmk6blB8qpEr0fgye8elVjKECa5Jt8AW2N5FEUas8YJvglKJJdr5eGngTsk9qfu5RZWvxoA==
X-Received: by 2002:aa7:9e05:0:b029:158:ca8c:fe36 with SMTP id y5-20020aa79e050000b0290158ca8cfe36mr17679134pfq.62.1603118211789;
        Mon, 19 Oct 2020 07:36:51 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id kb15sm53377pjb.17.2020.10.19.07.36.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 07:36:51 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com, Muneendra <muneendra.kumar@broadcom.com>
Subject: [RFC v2 03/18] nvme: Added a newsysfs attribute appid_store
Date:   Mon, 19 Oct 2020 13:12:58 +0530
Message-Id: <1603093393-12875-4-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603093393-12875-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1603093393-12875-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000091914705b2070b76"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000091914705b2070b76

Added a new sysfs attribute appid_store under
/sys/class/fc/fc_udev_device/*

With this new interface the user can set the application identfier
in  the blkcg associted with cgroup id.

Once the application identifer has set with this interface it allows
identification of traffic sources at an individual cgroup based
Applications (ex:virtual machine (VM))level in both host and
fabric infrastructure(FC).

Below is the interface provided to set the app_id

echo "<cgroupid>:<appid>" >> /sys/class/fc/fc_udev_device/appid_store
echo "457E:100000109b521d27" >> /sys/class/fc/fc_udev_device/appid_store

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v2:
New Patch
---
 drivers/nvme/host/fc.c | 73 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index eae43bb444e0..6d6cc06fd54a 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -9,7 +9,7 @@
 #include <uapi/scsi/fc/fc_els.h>
 #include <linux/delay.h>
 #include <linux/overflow.h>
-
+#include <linux/blk-cgroup.h>
 #include "nvme.h"
 #include "fabrics.h"
 #include <linux/nvme-fc-driver.h>
@@ -3768,10 +3768,81 @@ static ssize_t nvme_fc_nvme_discovery_store(struct device *dev,
 
 	return count;
 }
+
+/*parse the Cgroup id from a buf and returns the length of cgrpid*/
+static int fc_parse_cgrpid(const char *buf, u64 *id)
+{
+	char cgrp_id[16+1];
+	int cgrpid_len, j;
+
+	memset(cgrp_id, 0x0, sizeof(cgrp_id));
+	for (cgrpid_len = 0, j = 0; cgrpid_len < 17; cgrpid_len++) {
+		if (buf[cgrpid_len] != ':')
+			cgrp_id[cgrpid_len] = buf[cgrpid_len];
+		else {
+			j = 1;
+			break;
+		}
+	}
+	if (!j)
+		return -EINVAL;
+	if (kstrtou64(cgrp_id, 16, id) < 0)
+		return -EINVAL;
+	return cgrpid_len;
+}
+
+/*
+ * fc_update_appid :parses and updates the appid in the blkcg associated with
+ * cgroupid.
+ * @buf: buf contains both cgrpid and appid info
+ * @count: size of the buffer
+ */
+static int fc_update_appid(const char *buf, size_t count)
+{
+	u64 cgrp_id;
+	int appid_len = 0;
+	int cgrpid_len = 0;
+	char app_id[APPID_LEN];
+	int ret = 0;
+
+	if (buf[count-1] == '\n')
+		count--;
+
+	if ((count > (16+1+APPID_LEN)) || (!strchr(buf, ':')))
+		return -EINVAL;
+
+	cgrpid_len = fc_parse_cgrpid(buf, &cgrp_id);
+	if (cgrpid_len < 0)
+		return -EINVAL;
+	/*appid len is count - cgrpid_len -1 (: + \n) */
+	appid_len = count - cgrpid_len - 1;
+	if (appid_len > APPID_LEN)
+		return -EINVAL;
+
+	memset(app_id, 0x0, sizeof(app_id));
+	memcpy(app_id, &buf[cgrpid_len+1], appid_len);
+	ret = blkcg_set_app_identifier(app_id, cgrp_id, sizeof(app_id));
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+static ssize_t fc_appid_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	int ret  = 0;
+
+	ret = fc_update_appid(buf, count);
+	if (ret < 0)
+		return -EINVAL;
+	return count;
+}
 static DEVICE_ATTR(nvme_discovery, 0200, NULL, nvme_fc_nvme_discovery_store);
+static DEVICE_ATTR(appid_store, 0200, NULL, fc_appid_store);
 
 static struct attribute *nvme_fc_attrs[] = {
 	&dev_attr_nvme_discovery.attr,
+	&dev_attr_appid_store.attr,
 	NULL
 };
 
-- 
2.26.2


--00000000000091914705b2070b76
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
BCDyW6dGSZrgDI/unUj8OVMjqRmLErClYEZHhr6f/0GMvDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMTkxNDM2NTJaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAwp0Etb+WPCYYWy8v
4zvwC8OPJ1feJNbWAvmG0gX20oyVdn00CK4nSskC0oiRaqphyxjxXQEkKkJ5pUENOxpqTjYbIBWo
shc4XJnUxnpNoYSt3K6jnvbYvDLFYlSYfGnxxeFiwM/tHG4g9b70klXmHDaTORuvPc4gTmMRS7Mp
DH5Vh/zgSO+Ouf3hOSgM36eWUEcCfC001JoYO/ixqM3bPXJ4C2zv7+/Ki27BKISyErAj5g2NzFTm
YPTswrAZ+q6FFttX4c+DHS6OZEkQJubt4Ejp7PmtuJWWWbDE+fLKt/K8Jkr6FbdRLc9+GIumL5ZS
ySrtf3YHBI/AAbwPDiD4xA==
--00000000000091914705b2070b76--
