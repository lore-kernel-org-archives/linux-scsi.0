Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1501EC388F9
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A03F822264
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:10:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eJ68gK9Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgKCOKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 09:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729485AbgKCOI6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 09:08:58 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5D6C0613D1
        for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2020 06:08:58 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id i7so11831510pgh.6
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2020 06:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HY7qgx7DbH5dyQUVtk9IIE7Ar0qcvIccR/Ro4PjOb4Q=;
        b=eJ68gK9ZwxKy0uq4xMVE0xzzY1jiKJ4Xi0nMSs2oQTMWifugOm6fkxX33lGVOfXnG8
         4REiHYWQofr/wirKG0dPLUVodwDhLMsahZ5boXbfNyLLo2sLwFbDOO/1ZP20wRhE4evg
         k6DNYyihXvpTxcPw2XTdOY8L+Zct599s3QIBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HY7qgx7DbH5dyQUVtk9IIE7Ar0qcvIccR/Ro4PjOb4Q=;
        b=uR2U0ckPqmvihD0hMoGtWKjxEKmn4v/FwShty3b2TwDYKNZ0dt1EQHJ07Z9FT1o6O/
         0jVFT2WxEC1HQXbJmrvRJKAhN03TjzaCjdC1lklhyv8JFscszht8thPPFPV3lQ2DTbOe
         D/NucAdDGiXNaD9VbUgX+oM2ORn67r/qemVvmmHKKvcat1qZqyUSLvGokfgDTBYb+gTU
         LdgIGhG6Gx6fSqfxa1j+Oc47jL3xgPbOQTUJsHeeVK7uG1xwsDEqOt8oK6aEuIvTWb6J
         qRFZoeXUvOr0onBuh4iKaRr6kUCLbKXzKIR7U93RxfYotskk1U8DSxKWtM18q/YMt45r
         4sNg==
X-Gm-Message-State: AOAM53085FIDPYYN1WPbu4Zie0q7kGF4gRfSlsLjCdg0q0sDTaX5FsmR
        nn0GHt5pcGjNjzfvXf3Z7GnrC7SvPKMpfKdAhIJXUihK33IfLwVz4/qS+fkvwxwjl/J2Ey+RTZP
        VJ8hfTH0PyoadevpUlayJJkhlqgqN53IvtoMJL29NGKxtEeeC9tvjxw2DDHDWRHYHxjWX/ipani
        Qpf8AkxmFE7RE=
X-Google-Smtp-Source: ABdhPJx/s4eWvQca4GW+Cxl8H1tMwHkE1YsZLcuZciJ+sgff+ZxgKAJ1OKbkHe6sThNVOif2YRaUZA==
X-Received: by 2002:a63:5458:: with SMTP id e24mr17024945pgm.73.1604412537471;
        Tue, 03 Nov 2020 06:08:57 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id r19sm3525959pjo.23.2020.11.03.06.08.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 06:08:56 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [patch v5 5/5] scsi_transport_fc: Added store fucntionality to set the rport port_state using sysfs
Date:   Tue,  3 Nov 2020 12:45:12 +0530
Message-Id: <1604387712-19801-6-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604387712-19801-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1604387712-19801-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000065858005b33467cd"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000065858005b33467cd

Added a store functionality to set rport port_state using sysfs
under  fc_remote_ports/rport-*/port_state

With this functionality the user can move the port_state from
Marginal -> Online and Online->Marginal.

On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
scmd->state for all the pending io's on the scsi device associated
with target port.

On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
scmd->state for all the pending io's on the scsi device associated
with target port.

Below is the interface provided to set the port state to Marginal
and Online.

echo "Marginal" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
echo "Online" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v5:
No change

v4:
Addressed the error reported by kernel test robot
Removed the code needed to traverse all the devices under rport
to set/clear SCMD_NORETRIES_ABORT
Removed unncessary comments.
Return the error values on failure while setting the port_state

v3:
Removed the port_state from starget attributes.
Enabled the store functionality for port_state under remote port.
used the starget_for_each_device to traverse around all the devices
under rport

v2:
Changed from a noretries_abort attribute under fc_transport/target*/ to
port_state for changing the port_state to a marginal state
---
 drivers/scsi/scsi_transport_fc.c | 56 ++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 0ac490816f3e..979032e1dafc 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -943,7 +943,59 @@ show_fc_rport_roles (struct device *dev, struct device_attribute *attr,
 static FC_DEVICE_ATTR(rport, roles, S_IRUGO,
 		show_fc_rport_roles, NULL);
 
-fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
+static ssize_t fc_rport_set_marginal_state(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct fc_rport *rport = transport_class_to_rport(dev);
+	enum fc_port_state port_state;
+	int ret = 0;
+
+	ret = get_fc_port_state_match(buf, &port_state);
+	if (ret)
+		return -EINVAL;
+	if (port_state == FC_PORTSTATE_MARGINAL) {
+		/*
+		 * Change the state to marginal only if the
+		 * current rport state is Online
+		 * Allow only Online->marginal
+		 */
+		if (rport->port_state == FC_PORTSTATE_ONLINE)
+			rport->port_state = port_state;
+		else
+			return -EINVAL;
+	} else if (port_state == FC_PORTSTATE_ONLINE) {
+		/*
+		 * Change the state to Online only if the
+		 * current rport state is Marginal
+		 * Allow only  MArginal->Online
+		 */
+		if (rport->port_state == FC_PORTSTATE_MARGINAL)
+			rport->port_state = port_state;
+		else
+			return -EINVAL;
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
@@ -2267,7 +2319,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
-	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
+	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(port_state);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
 
-- 
2.26.2


--00000000000065858005b33467cd
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
BCBieAoaO46QiHhGGdq0AWbysxWUpTQpitTjYbj8C6wE/zAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDMxNDA4NTdaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAV4hQrD6Icnxrghau
CurOanw91ZV1v82hUg9pN+25tzrJLTmp3LBx7YPGuxsy83aFYd8X7ABM8lbKBQXVipRYQlncviZz
3CMkHNQaJnXzSxJ/Maggni4DeRLQ2NdYe5XPJlFR7myIu0Qd3EulayKUgdlFYyhuLy1GjZVX6qwl
RUI/p8K8kBFPdoLQua1s/YtmKqj0O+oDTRJHqhVPJPLkPw8IO1wIvMPnWqHNcO0kWMmsnb4ogO5D
ZZF4fAdMhaXxjdC9fB9ilQI90Lmxh+qnCxVrvzf/IuvdrkALbXIuqtJYOKit+TgIxodn67VS5QT4
DuRCUaF1fd2HVZ+eZ1V3kA==
--00000000000065858005b33467cd--
