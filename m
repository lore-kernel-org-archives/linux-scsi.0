Return-Path: <linux-scsi-owner@kernel.org>
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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBD8C5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 11:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE5D120709
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 11:51:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HrcJWx9J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgKKLvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 06:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgKKLva (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 06:51:30 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D74C0613D1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2020 03:51:29 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 62so1274889pgg.12
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2020 03:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8XKbWlR0P9nEOHQKylW8DIvraE/TYQZotEMJiMFSX04=;
        b=HrcJWx9JLc/qE3zIX2cwDH7+F+lHi+qCY7rtStE7JvKpPKT4mncQQIOiUTiBe+a4qD
         j8ho7O4r0FzZvrKzhdpX0Z63QnskatqJ8YEs1Suewm7+eOFEvgMmTiH0VWt9atvbZhEB
         Rqee5nDktdjdaZysi7aTxItqqyt7yck7wN5f8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8XKbWlR0P9nEOHQKylW8DIvraE/TYQZotEMJiMFSX04=;
        b=n5udSIO4xwVUfPtllxA/Ic6ZJKxThRTgNTwyi7SWcQqf3VO9v1uwx0gUWX1SkCjqK8
         +frJAMz9TDXr5lbGJJ3mZ5f7VpUgztbLA9UQ1QUn01zlAgngdk3ZuaWD/pgfW8Afs9Gj
         tu8bjl9ASUyWAZ4Hx/WnX7aBmpdCK88XNSE2O/9bXNN5FM8cFNuh7Ng3gG9I5dnGIzGP
         Rvgb5Fz1DJt7CWlIwjzC1pHhV5IqmUyOXtcLrfqVlriNceEWz2pbXAwHFhQuUMqaCJcG
         DsWp1UB269p4xW9xrQXaCCg7O9jBM37+5LZ4b08LDlZpaBC6kpES0DRhJdnaLklFdnWB
         hhbw==
X-Gm-Message-State: AOAM533wRY5PCXRX6z14SaS4mWgRV6vCYkeSBI9vGuRZyWp8Z+S0/tOC
        G3BsRHlw90Bz31VJv7FobBRWLtwIAzqQxIm+Tf7EwPVvxJxS5b6IjNivAsKtsadNqxz0VVhANaT
        mbOIZe7s8lhMWEgbycRhCTtBWroLmeh53fjmg+0Kd7CyyHDeSholU3r4W16kWMd6xAVFePiAsr9
        zLYqn60NHEPzw=
X-Google-Smtp-Source: ABdhPJxHR4P51kPNXNFKFgiLjPjtDUI+E9o8d0a8eoFjbFO4TqTgrKCm87QqwgDdMBMduhF60ql7eQ==
X-Received: by 2002:a62:1455:0:b029:18b:83a2:768b with SMTP id 82-20020a6214550000b029018b83a2768bmr22812725pfu.3.1605095488765;
        Wed, 11 Nov 2020 03:51:28 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o1sm1160221pfk.67.2020.11.11.03.51.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Nov 2020 03:51:28 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v7 2/5] scsi: No retries on abort success
Date:   Wed, 11 Nov 2020 10:28:02 +0530
Message-Id: <1605070685-20945-3-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000789c2905b3d36a15"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000789c2905b3d36a15

Added a new optional routine eh_should_retry_cmd
in scsi_host_template that allows the transport to decide if a
cmd is retryable.Return true if the transport is in a state the
cmd should be retried on.

Added a new interface scsi_eh_should_retry_cmd which checks and
calls the new routine eh_should_retry_cmd.

Made changes in scmd_eh_abort_handler and scsi_eh_flush_done_q which
calls the scsi_eh_should_retry_cmd to check whether the
command needs to be retried.

The above changes were done based on a patch by Mike Christie.

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v7:
Added New routine in scsi_host_template to decide if a cmd is
retryable instead of checking the same using  SCMD_NORETRIES_ABORT
bit as the cmd retry part can be checked by validating the port state.

Moved the DID_TRANSPORT_MARGINAL changes to previous patch
for reordering

v6:
Rearranged the patch by merging second hunk of the patch2 in v5
to this patch

v5:
added the DID_TRANSPORT_MARGINAL case to
scsi_decide_disposition
v4:
Modified the comments in the code appropriately

v3:
Merged  first part of the previous patch(v2 patch3) with
this patch.

v2:
set the hostbyte as DID_TRANSPORT_MARGINAL instead of
DID_TRANSPORT_FAILFAST.
---
 drivers/scsi/scsi_error.c | 17 +++++++++++++++--
 include/scsi/scsi_host.h  |  6 ++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 28056ee498b3..1cdfa5a8ca09 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -124,6 +124,17 @@ static bool scsi_cmd_retry_allowed(struct scsi_cmnd *cmd)
 	return ++cmd->retries <= cmd->allowed;
 }
 
+static bool scsi_eh_should_retry_cmd(struct scsi_cmnd *cmd)
+{
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *host = sdev->host;
+
+	if (host->hostt->eh_should_retry_cmd)
+		return  host->hostt->eh_should_retry_cmd(cmd);
+
+	return true;
+}
+
 /**
  * scmd_eh_abort_handler - Handle command aborts
  * @work:	command to be aborted.
@@ -159,7 +170,8 @@ scmd_eh_abort_handler(struct work_struct *work)
 						    "eh timeout, not retrying "
 						    "aborted command\n"));
 			} else if (!scsi_noretry_cmd(scmd) &&
-				   scsi_cmd_retry_allowed(scmd)) {
+				   scsi_cmd_retry_allowed(scmd) &&
+				scsi_eh_should_retry_cmd(scmd)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
 						    "retry aborted command\n"));
@@ -2111,7 +2123,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
-		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd)) {
+		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd) &&
+			scsi_eh_should_retry_cmd(scmd)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
 					     "%s: flush retry cmd\n",
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 701f178b20ae..e30fd963b97d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -314,6 +314,12 @@ struct scsi_host_template {
 	 * Status: OPTIONAL
 	 */
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
+	/*
+	 * Optional routine that allows the transport to decide if a cmd
+	 * is retryable. Return true if the transport is in a state the
+	 * cmd should be retried on.
+	 */
+	bool (*eh_should_retry_cmd)(struct scsi_cmnd *scmd);
 
 	/* This is an optional routine that allows transport to initiate
 	 * LLD adapter or firmware reset using sysfs attribute.
-- 
2.26.2


--000000000000789c2905b3d36a15
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
BCBqCZ3vQOkYfYJoadijbIGoc+vW92JvVT+eZQsZ0/JSdzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMTExMTUxMjlaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAK+Caeh36hu5bK1RS
qgCmc5/HkQJtHvPkbAVdb/DWJq5emRnMgnm3ONJ3Ktc7isu8Uz3EWSdEVbWSJTcbe2dB92ysGFHN
h57eYURE1zrhJtmolYLvmgZnrBzIiQIGAP07Fr3xdD5l2zH08nTchZNLREdPPizQDxCy6BHrVukp
OfBZ8vduYuVzmbt3G6cBV5f0pMLyQDQXnxbYMmv8vKlSqVgluqvOZqhKx/+D6MuIHzGZoITSLlN3
nLa/wfQjYo896WG+7MaEcP2P93RzEC5ZFOS2tQrj3zLNFT+xfGL9ecs3SSjStl6h4dPMCbGNU06W
JsQ3VKvgw4qyP+D8QJA2og==
--000000000000789c2905b3d36a15--
