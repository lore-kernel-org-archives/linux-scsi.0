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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B39AC61DD8
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37FB122264
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 14:10:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OU0VCG46"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgKCOKj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 09:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729470AbgKCOIy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 09:08:54 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485FEC0613D1
        for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2020 06:08:54 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c20so14278874pfr.8
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2020 06:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zFAyFa3GXu2CuUWMnmaYYZToQuRMkUUMDU7jXY22ATc=;
        b=OU0VCG4660hcdxrzHGzZY11caVZlas/NJK8vD1ByWiTv1cy9N1scmJxnumEifi9irb
         GJO5zf0CpANJoRvQRpJWaD2ZFSPS91Gs3F4rmi2YqS5+d2LUSOBGPSTailvGw44VAhsD
         /Y1rplipDb+N+0ZDl6a9lzfI9SruRHp9UhvQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zFAyFa3GXu2CuUWMnmaYYZToQuRMkUUMDU7jXY22ATc=;
        b=IZjDrhBO/2p+pD824u2y9JbDhRdGdnagbyBQm2Sb2FKa2z8dSVLBPnv7yCE40fVRGF
         FsqFJB/wy8dpUh1zvTJ2n+JAuj6uJ00Q5aIiP5mqF8A5NCaBGRmgn2197/AtoRQ1bRUV
         1bhA9je/BzCx8ZkTNLpY7Fc6az23pfvxSxKJPcdVQzicUaZa265b2mai7t7TsvSEpUUy
         SmD4BX2PKTDp9KOKwE/M/5xvCrYtpKFK+XviRo5NyAc0aLqkhp8yQoD5MrMo4AarUdvr
         g+DN6+QDNp4WwMfTNNloK4DryXSohDWbiPtmOJyh0MXRIufCdcvepETjE4N8NKaXMbzE
         KHiQ==
X-Gm-Message-State: AOAM533x6VoCOMvoXWF8XnOuxMkeSveAW+urL4kx6JjPjwkbX3JvoMB4
        l9spaGqdntL00ig0+FqWXocRTdz8e8zyux+OCbe2IEMQ3U72TttL/aGDDZGUKezhQAC3nyJ/LTh
        GjAl2lNyViPf5e6/Ib9HdZeFYpIX6WptLMXnMrs3Lnl9ZoB1F9/QadSi7jxQOn1INYN43x+Z3YF
        GRTedf60TtzU8=
X-Google-Smtp-Source: ABdhPJyRypSw8DqL1guD3/ezkMdEoi3EHSwimQrnEZ9tXd3Y0snjMVZvhmaXUNkJ6uv8s7vPOB98NQ==
X-Received: by 2002:a63:7985:: with SMTP id u127mr16947753pgc.396.1604412533286;
        Tue, 03 Nov 2020 06:08:53 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id r19sm3525959pjo.23.2020.11.03.06.08.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 06:08:51 -0800 (PST)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [patch v5 4/5] scsi_transport_fc: Added a new rport state FC_PORTSTATE_MARGINAL
Date:   Tue,  3 Nov 2020 12:45:11 +0530
Message-Id: <1604387712-19801-5-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604387712-19801-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1604387712-19801-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000026077f05b334671d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000026077f05b334671d

Added a new rport state FC_PORTSTATE_MARGINAL.

Added a new inline function fc_rport_chkmarginal_set_noretries
which will set the SCMD_NORETRIES_ABORT bit in cmd->state if rport state
is marginal.

Made changes in fc_eh_timed_out to call fc_rport_chkmarginal_set_noretries
Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
fc_timeout_deleted_rport functions  to handle the new rport state
FC_PORTSTATE_MARGINAL.

Made changes in fc_block_scsi_eh to clear the SCMD_NORETRIES_ABORT bit
if the port_state is not  marginal

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v5:
Made changes to clear the SCMD_NORETRIES_ABORT bit if the port_state
has changed from marginal to online due to port_delete and port_add
as we need the normal cmd retry behaviour

Made changes in fc_scsi_scan_rport as we are checking FC_PORTSTATE_ONLINE
instead of FC_PORTSTATE_ONLINE and FC_PORTSTATE_MARGINAL

v4:
Made changes in fc_eh_timed_out to call fc_rport_chkmarginal_set_noretries
so that SCMD_NORETRIES_ABORT bit in cmd->state is set if rport state
is marginal.

Removed the newly added scsi_cmd argument to fc_remote_port_chkready
as the current patch handles only SCSI EH timeout/abort case.

v3:
Rearranged the patch so that all the changes with respect to new
rport state is part of this patch.
Added a new argument to scsi_cmd  to fc_remote_port_chkready

v2:
New patch
---
 drivers/scsi/scsi_transport_fc.c | 47 ++++++++++++++++++++------------
 include/scsi/scsi_transport_fc.h | 19 +++++++++++++
 2 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2ff7f06203da..0ac490816f3e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -142,20 +142,23 @@ fc_enum_name_search(host_event_code, fc_host_event_code,
 static struct {
 	enum fc_port_state	value;
 	char			*name;
+	int			matchlen;
 } fc_port_state_names[] = {
-	{ FC_PORTSTATE_UNKNOWN,		"Unknown" },
-	{ FC_PORTSTATE_NOTPRESENT,	"Not Present" },
-	{ FC_PORTSTATE_ONLINE,		"Online" },
-	{ FC_PORTSTATE_OFFLINE,		"Offline" },
-	{ FC_PORTSTATE_BLOCKED,		"Blocked" },
-	{ FC_PORTSTATE_BYPASSED,	"Bypassed" },
-	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics" },
-	{ FC_PORTSTATE_LINKDOWN,	"Linkdown" },
-	{ FC_PORTSTATE_ERROR,		"Error" },
-	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
-	{ FC_PORTSTATE_DELETED,		"Deleted" },
+	{ FC_PORTSTATE_UNKNOWN,		"Unknown", 7},
+	{ FC_PORTSTATE_NOTPRESENT,	"Not Present", 11 },
+	{ FC_PORTSTATE_ONLINE,		"Online", 6 },
+	{ FC_PORTSTATE_OFFLINE,		"Offline", 7 },
+	{ FC_PORTSTATE_BLOCKED,		"Blocked", 7 },
+	{ FC_PORTSTATE_BYPASSED,	"Bypassed", 8 },
+	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics", 11 },
+	{ FC_PORTSTATE_LINKDOWN,	"Linkdown", 8 },
+	{ FC_PORTSTATE_ERROR,		"Error", 5 },
+	{ FC_PORTSTATE_LOOPBACK,	"Loopback", 8 },
+	{ FC_PORTSTATE_DELETED,		"Deleted", 7 },
+	{ FC_PORTSTATE_MARGINAL,	"Marginal", 8 },
 };
 fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
+fc_enum_name_match(port_state, fc_port_state, fc_port_state_names)
 #define FC_PORTSTATE_MAX_NAMELEN	20
 
 
@@ -2074,6 +2077,7 @@ fc_eh_timed_out(struct scsi_cmnd *scmd)
 	if (rport->port_state == FC_PORTSTATE_BLOCKED)
 		return BLK_EH_RESET_TIMER;
 
+	fc_rport_chkmarginal_set_noretries(rport, scmd);
 	return BLK_EH_DONE;
 }
 EXPORT_SYMBOL(fc_eh_timed_out);
@@ -2095,7 +2099,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
 		if (rport->scsi_target_id == -1)
 			continue;
 
-		if (rport->port_state != FC_PORTSTATE_ONLINE)
+		if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
+			(rport->port_state != FC_PORTSTATE_MARGINAL))
 			continue;
 
 		if ((channel == rport->channel) &&
@@ -2958,7 +2963,8 @@ fc_remote_port_delete(struct fc_rport  *rport)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	if (rport->port_state != FC_PORTSTATE_ONLINE) {
+	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
+		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		return;
 	}
@@ -3100,7 +3106,8 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	 * target, validate it still is. If not, tear down the
 	 * scsi_target on it.
 	 */
-	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
+	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
+		(rport->port_state == FC_PORTSTATE_MARGINAL)) &&
 	    (rport->scsi_target_id != -1) &&
 	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
 		dev_printk(KERN_ERR, &rport->dev,
@@ -3243,7 +3250,8 @@ fc_scsi_scan_rport(struct work_struct *work)
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	unsigned long flags;
 
-	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
+	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
+		(rport->port_state == FC_PORTSTATE_MARGINAL)) &&
 	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
 	    !(i->f->disable_target_scan)) {
 		scsi_scan_target(&rport->dev, rport->channel,
@@ -3308,11 +3316,15 @@ EXPORT_SYMBOL(fc_block_rport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
+	int ret = 0;
 
 	if (WARN_ON_ONCE(!rport))
 		return FAST_IO_FAIL;
 
-	return fc_block_rport(rport);
+	ret = fc_block_rport(rport);
+	if (rport->port_state != FC_PORTSTATE_MARGINAL)
+		clear_bit(SCMD_NORETRIES_ABORT, &cmnd->state);
+	return ret;
 }
 EXPORT_SYMBOL(fc_block_scsi_eh);
 
@@ -3747,7 +3759,8 @@ static blk_status_t fc_bsg_rport_prep(struct fc_rport *rport)
 	    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
 		return BLK_STS_RESOURCE;
 
-	if (rport->port_state != FC_PORTSTATE_ONLINE)
+	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
+		(rport->port_state != FC_PORTSTATE_MARGINAL))
 		return BLK_STS_IOERR;
 
 	return BLK_STS_OK;
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 1c7dd35cb7a0..829bade13b89 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -14,6 +14,7 @@
 #include <linux/bsg-lib.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_netlink.h>
 #include <scsi/scsi_host.h>
 
@@ -67,6 +68,7 @@ enum fc_port_state {
 	FC_PORTSTATE_ERROR,
 	FC_PORTSTATE_LOOPBACK,
 	FC_PORTSTATE_DELETED,
+	FC_PORTSTATE_MARGINAL,
 };
 
 
@@ -707,6 +709,22 @@ struct fc_function_template {
 	unsigned long	disable_target_scan:1;
 };
 
+/**
+ * fc_rport_chkmarginal_set_noretries - Set the SCMD_NORETRIES_ABORT bit
+ * in cmd->state if port state is marginal
+ * @rport:	remote port to be checked
+ * @scmd:	scsi_cmd to set/clear the SCMD_NORETRIES_ABORT bit on Marginal state
+ **/
+static inline void
+fc_rport_chkmarginal_set_noretries(struct fc_rport *rport, struct scsi_cmnd *cmd)
+{
+	if ((rport->port_state == FC_PORTSTATE_MARGINAL) &&
+		 (cmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT))
+		set_bit(SCMD_NORETRIES_ABORT, &cmd->state);
+	else
+		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
+
+}
 
 /**
  * fc_remote_port_chkready - called to validate the remote port state
@@ -723,6 +741,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
 
 	switch (rport->port_state) {
 	case FC_PORTSTATE_ONLINE:
+	case FC_PORTSTATE_MARGINAL:
 		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
 			result = 0;
 		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
-- 
2.26.2


--00000000000026077f05b334671d
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
BCBYYvxpIsmpmsmkUDNR6qQrkk7EiGinR1GNDC0Sg0Ij0zAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDMxNDA4NTNaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAT9RkD50CPmWZzhbh
UVvkvm4RPuksZstFQwjMQE2z2WNpvsvwVDO34hXyj63Jtg/r1cvRcOlBK6lDxO6dzA0w/XqISfgx
aDincb/9Ppr6G3cb9/8ncj0zksWgtrBF4dtlgm4NVPDBj30HdMselD8RpLIGJDcz7fo1xAHUigDN
7Hr3mEkdGvjGzxDnlpKyO9moPlUOmACtnsGBfJQ60G6bJHXxLSM8AJCxdIcU0Cd0OKk9+N74dw5j
oelpgkzuwCRAsbMcjTZDZOGJtW9UJoQ2Rqzp4T2VN8LS3uZtMpmj9kgSViEN61ixZmiTqo91+Hod
FNXyxtgKL06G9NBiG1Lm4Q==
--00000000000026077f05b334671d--
