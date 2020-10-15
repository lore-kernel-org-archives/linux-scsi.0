Return-Path: <SRS0=rjNM=DW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_HEADER_CTYPE_ONLY,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B73C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 10:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8403E22249
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 10:21:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="H6hR9Pe1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389216AbgJOKVZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Oct 2020 06:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389099AbgJOKVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2020 06:21:25 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC26C061755
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2020 03:21:24 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r10so1612913pgb.10
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2020 03:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T8B9akbRZwipPegQunnvBAXugv0e1h0PbYHIixJnhIE=;
        b=H6hR9Pe1rCQpUKVyXAjlVsMpi5SyApeCDN4PPq53GULhm/Dp58um/h4ikJbOVbDGfd
         ZkJGTk50S3MvPTa0TrGiZVbuM3fc2LLVuPB6wbY0P72MYOkQ77blFT/Wu7wgTYFHgocc
         u5t2LjjemWrf59Dpoq8VHcs+I//Xq7V62Qpv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T8B9akbRZwipPegQunnvBAXugv0e1h0PbYHIixJnhIE=;
        b=ap6ND26ltIPIKU2yGDFWULq3STX2C2d/nagPjhh5HYWEhZsGliaGWGlGpiGtdijfoH
         /2qLop42sQGwfg0XLfJnqK/z+vDbVPntJHmcLWj7YOmzkpF0zBQOHYVJgdO02QrWb54G
         cARsRDyBqaKOef4MjTqsdhdL6kbMiGe/sRKDCT+Cy4LB8le36QX2HtEgk0J1fwqZ22hN
         2IPtvCLBPACf5LuL8J1h7Xfyd0eT/fo2DU4waLJ0woezDeVxjL1XvRyF+lUmtsXawexX
         8MgJFDakPaAHUAZFkOomlRv9gHC1rRjF53YHJHI1YbNHtRhdHACj/XYj9xG3qflT4Wqc
         /qmg==
X-Gm-Message-State: AOAM533zPrR0BTBD7btH3YE0hYYKOUcVOeStDEn98fCuPxTqCnYLmvtV
        l1YIfcrpQ26jUATcvx+hvhg9YATFxrK2YuAvSegjo+HimZyfL+HECVxnBJiDGuViMf3nvzHLSsL
        won/YZELEJxUz7QWFaoNcPoeHp5TE4bOXMi85VaITOL4tKVT3SPGwOMvc+g2KphZFzVne50kfIu
        QLK8gWkCXPnB4=
X-Google-Smtp-Source: ABdhPJz+16fHdFPMcv67z5110G0iwcP53YBOyEGzS8q9l/1d3bkH9qcnhw+vQZ8najLZ5rpdKKqwcQ==
X-Received: by 2002:a63:d111:: with SMTP id k17mr2571274pgg.299.1602757283856;
        Thu, 15 Oct 2020 03:21:23 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 194sm2802258pfz.182.2020.10.15.03.21.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2020 03:21:23 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v3 06/17] scsi_transport_fc: Added store fucntionality to set the rport port_state using sysfs
Date:   Thu, 15 Oct 2020 08:57:31 +0530
Message-Id: <1602732462-10443-7-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000998b4005b1b3025b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000998b4005b1b3025b

Added a store functionality to set rport port_state using sysfs
under  fc_remote_ports/rport-*/port_state

With this functionality the user can move the port_state from
Marginal->Online and Online->Marginal.

On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
scmd->state for all the io's on the scsi device associated
with remote port.

On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
scmd->state for all the pending io's on the scsi device associated
with remote port.

Below is the interface provided to set the port state to Marginal
and Online.

echo "Marginal" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
echo "Online" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v3:
Removed the port_state from starget attributes.
Enabled the store functionality for port_state under remote port.
used the starget_for_each_device to traverse around all the devices
under rport

v2:
Changed from a noretries_abort attribute under fc_transport/target*/ to
port_state for changing the port_state to a marginal state
---
 drivers/scsi/scsi_transport_fc.c | 85 +++++++++++++++++++++++++++++++-
 1 file changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index df66a51d62e6..ac5283b645a6 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -943,7 +943,88 @@ show_fc_rport_roles (struct device *dev, struct device_attribute *attr,
 static FC_DEVICE_ATTR(rport, roles, S_IRUGO,
 		show_fc_rport_roles, NULL);
 
-fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
+static void
+device_chg_noretries_abort(struct scsi_device *sdev, void *data)
+{
+	scsi_chg_noretries_abort_io_device(sdev, *(bool *)data);
+}
+
+static int
+target_chg_noretries_abort(struct device *dev, void *data)
+{
+	if (scsi_is_target_device(dev))
+		starget_for_each_device(to_scsi_target(dev), data,
+					device_chg_noretries_abort);
+	return 0;
+}
+
+static void scsi_target_chg_noretries_abort(struct device *dev, bool set)
+{
+	if (scsi_is_target_device(dev))
+		starget_for_each_device(to_scsi_target(dev), &set,
+					device_chg_noretries_abort);
+	else
+		device_for_each_child(dev, &set, target_chg_noretries_abort);
+}
+
+/*
+ * Sets port_state to Marginal/Online.
+ * On Marginal it Sets  no retries on abort in scmd->state for all
+ * outstanding io of all the scsi_devs
+ * This only allows ONLINE->MARGINAL and MARGINAL->ONLINE
+ */
+static ssize_t fc_rport_set_marginal_state(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+	enum fc_port_state port_state;
+	int ret = 0;
+
+	ret = get_fc_port_state_match(buf, &port_state);
+
+	if (port_state == FC_PORTSTATE_MARGINAL) {
+		/*
+		 * Change the state to marginal only if the
+		 * current rport state is Online
+		 * Allow only Online->marginal
+		 */
+		if (rport->port_state == FC_PORTSTATE_ONLINE) {
+			rport->port_state = port_state;
+			scsi_target_chg_noretries_abort(&rport->dev, 1);
+		}
+	} else if (port_state == FC_PORTSTATE_ONLINE) {
+		/*
+		 * Change the state to Online only if the
+		 * current rport state is Marginal
+		 * Allow only  MArginal->Online
+		 */
+		if (rport->port_state == FC_PORTSTATE_MARGINAL) {
+			rport->port_state = port_state;
+			scsi_target_chg_noretries_abort(&rport->dev, 0);
+		}
+	} else
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t
+show_fc_rport_port_state(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	const char *name;
+	struct fc_rport *rport = transport_class_to_rport(dev);
+
+	name = get_fc_port_state_name(rport->port_state);
+	if (!name)
+		return -EINVAL;
+
+	return snprintf(buf, 20, "%s\n", name);
+}
+
+static FC_DEVICE_ATTR(rport, port_state, 0444 | 0200,
+			show_fc_rport_port_state, fc_rport_set_marginal_state);
+
 fc_private_rport_rd_attr(scsi_target_id, "%d\n", 20);
 
 /*
@@ -2266,7 +2347,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
-	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(port_state);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
 
-- 
2.26.2


--000000000000998b4005b1b3025b
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
BCB6C0k9XZ4aR03uUy5qMFXDPICmAPvy3psp1rmSKGoe2DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMTUxMDIxMjRaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAJx4ZzU5LbkQ73+Lv
UMVvzl0qzTl1ye5FkyHtoaHylOXyKSwxXYWqeu7mhD2EW0aa0QBv4aCibGj31VzqdEd7dzw6Jd5b
HCljZ4d5VZReh8APzVFKeAU1MpUeNXFY8+Wr3r8A5zULVRaXj6zw9UOqRdG1X3cpdp4I0plnDdN/
kNPi/Zj3Jv4KVb/Fes+owlW/5Knv+EULkCSxExy3oSH5Ji6p7JeZNxFymuNKulvgIrUtze/4Pnip
KyWB9vHvDVWiLEzmW0sAN0JTL2/D6hJaysfIbhmPd59eQl/pgL17vow6wlIjvnCQcQiw8Zky4+Rm
B7cz223IszHljkoZA11lRg==
--000000000000998b4005b1b3025b--
