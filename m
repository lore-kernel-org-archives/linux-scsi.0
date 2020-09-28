Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MIME_HEADER_CTYPE_ONLY,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B3B7C2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 11:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F65621D95
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 11:44:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AG35NFpn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgI1Lou (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 07:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgI1Lot (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 07:44:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3929C061755
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 04:44:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b124so730630pfg.13
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2020 04:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sc7vonzpvvxGP5Sb4LAvWi24bRLGzgQpwutoTor0jWQ=;
        b=AG35NFpn6hFB75n2vilyQmN06BqOU2STeslbtTl4fqc5Y77oyO1KtNpFmL72LnWs20
         a0RxCifipGDh7UESTDkREth9ocxUELyRG3ELA9ulO1pcmgQ7zFiwKPOv0uJcMeamz2cn
         8JsZAMyk1rpe/IKNoY63bs1KLvPUdxq6rA7E8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sc7vonzpvvxGP5Sb4LAvWi24bRLGzgQpwutoTor0jWQ=;
        b=F+wexXDDdsCIEVUdRVL9DVDo29rgcT/IH8Gb0cY+5LWO63LEUxUH++nNraTTNRtqOp
         FnOWhc7mMhuixfBFYNY1AxyThxlf9AbqcuGUpTk7VnlJBcvw+RLi1Lwuexf3YrEmEytH
         OuSTEUv5Njt8zGyS3cvaTO3bgh2ouVNluADXCgKcsve5TdTyLqop5J5eXVrrCAMap7dc
         JCgUdyI7P2AYdL4qA0yqrrjEkkwYWNLKsCepWNUCVHzIE/YXWyIclBaIMVJwrq8uWPq9
         W7VRPHiy4MLEG2liSw9f3fHgfN90aSurGlCvcFjtitLy+vptK+NKihBeNbp7WB1LNcuX
         hWvA==
X-Gm-Message-State: AOAM530gYDGgQ0RyvC0genghNwnzejis5cRBl49IjQnwKENgO6VFpFkf
        2HxROOiahX7cJgOd8JHNNeqfZTQVfV8geNjhyUPprWbH2Bppzn5ZpRkLlx1S4/Jw0iUOBlrpCwr
        HObdCax+gva1/T/by/Osj4EJmSRiLXGXTkcbwQ0lCVgjpa7pMgFzgoCr8sL+0s5YNKlKEFQk5Zw
        bZgckxWAyf
X-Google-Smtp-Source: ABdhPJxMa2VkH3VNhJlR7xaL/8Xve5XkMDWxQrcvHyxd+TW+bMVL8zZZt7Yi3bBswgPv/28PwGUBCA==
X-Received: by 2002:a05:6a00:1b:b029:13e:d13d:a101 with SMTP id h27-20020a056a00001bb029013ed13da101mr9603790pfk.29.1601293488661;
        Mon, 28 Sep 2020 04:44:48 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w19sm1468866pfq.60.2020.09.28.04.44.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2020 04:44:48 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v2 7/8] scsi_transport_fc: Added a new sysfs attribute port_state
Date:   Mon, 28 Sep 2020 10:20:56 +0530
Message-Id: <1601268657-940-8-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009a678605b05e31d3"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000009a678605b05e31d3

Added a new sysfs attribute port_state under fc_transport/target*/

With this new interface the user can move the port_state from
Marginal -> Online and Online->Marginal.

On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
scmd->state for all the pending io's on the scsi device associated
with target port.

On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
scmd->state for all the pending io's on the scsi device associated
with target port.

Below is the interface provided to set the port state to Marginal
and Online.

echo "Marginal" >> /sys/class/fc_transport/targetX\:Y\:Z/port_state
echo "Online" >> /sys/class/fc_transport/targetX\:Y\:Z/port_state

Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
fc_timeout_deleted_rport functions  to handle the new rport state
FC_PORTSTATE_MARGINAL.

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

---
v2:
Changed from a noretries_abort attribute under fc_transport/target*/ to
port_state for changing the port_state to a marginal state
---
 drivers/scsi/scsi_transport_fc.c | 140 +++++++++++++++++++++++++++----
 1 file changed, 122 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2ff7f06203da..6fe2463c5a68 100644
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
 
 
@@ -306,7 +309,7 @@ static void fc_scsi_scan_rport(struct work_struct *work);
  * Attribute counts pre object type...
  * Increase these values if you add attributes
  */
-#define FC_STARGET_NUM_ATTRS 	3
+#define FC_STARGET_NUM_ATTRS	4
 #define FC_RPORT_NUM_ATTRS	10
 #define FC_VPORT_NUM_ATTRS	9
 #define FC_HOST_NUM_ATTRS	29
@@ -358,10 +361,12 @@ static int fc_target_setup(struct transport_container *tc, struct device *dev,
 		fc_starget_node_name(starget) = rport->node_name;
 		fc_starget_port_name(starget) = rport->port_name;
 		fc_starget_port_id(starget) = rport->port_id;
+		fc_starget_port_state(starget) = rport->port_state;
 	} else {
 		fc_starget_node_name(starget) = -1;
 		fc_starget_port_name(starget) = -1;
 		fc_starget_port_id(starget) = -1;
+		fc_starget_port_state(starget) = FC_PORTSTATE_UNKNOWN;
 	}
 
 	return 0;
@@ -995,6 +1000,93 @@ static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
 /*
  * FC SCSI Target Attribute Management
  */
+static void scsi_target_chg_noretries_abort(struct scsi_target *starget, int set)
+{
+	struct scsi_device *sdev, *tmp;
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry_safe(sdev, tmp, &starget->devices, same_target_siblings) {
+		if (sdev->sdev_state == SDEV_DEL)
+			continue;
+
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		if (scsi_device_get(sdev))
+			continue;
+
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		scsi_chg_noretries_abort_io_device(sdev, set);
+		spin_lock_irqsave(shost->host_lock, flags);
+		scsi_device_put(sdev);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+/*
+ * Sets port_state to Marginal/Online.
+ * On Marginal it Sets  no retries on abort in scmd->state for all
+ * outstanding io of all the scsi_devs
+ * This only allows ONLINE->MARGINAL and MARGINAL->ONLINE
+ */
+static ssize_t fc_target_set_marginal_state(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct scsi_target *starget = transport_class_to_starget(dev);
+	struct fc_rport *rport = starget_to_rport(starget);
+	enum fc_port_state port_state;
+	int ret = 0;
+
+	ret = get_fc_port_state_match(buf, &port_state);
+
+	if (port_state == FC_PORTSTATE_MARGINAL) {
+
+		/*
+		 * Change the state to marginal only if the
+		 * current rport state is Online
+		 * Allow only Online->marginal
+		 */
+		if (rport->port_state == FC_PORTSTATE_ONLINE) {
+			rport->port_state = port_state;
+			scsi_target_chg_noretries_abort(starget, 1);
+		}
+
+	} else if (port_state == FC_PORTSTATE_ONLINE) {
+		/*
+		 * Change the state to Online only if the
+		 * current rport state is Marginal
+		 * Allow only  MArginal->Online
+		 */
+
+		if (rport->port_state == FC_PORTSTATE_MARGINAL) {
+			rport->port_state = port_state;
+			scsi_target_chg_noretries_abort(starget, 0);
+		}
+
+
+	} else
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t
+fc_target_show_port_state(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	const char *name;
+	struct scsi_target *starget = transport_class_to_starget(dev);
+	struct fc_rport *rport = starget_to_rport(starget);
+
+	name = get_fc_port_state_name(rport->port_state);
+	if (!name)
+		return -EINVAL;
+
+	return snprintf(buf, 20, "%s\n", name);
+}
+
+static FC_DEVICE_ATTR(starget, port_state, 0444 | 0200,
+		fc_target_show_port_state, fc_target_set_marginal_state);
 
 /*
  * Note: in the target show function we recognize when the remote
@@ -1037,6 +1129,13 @@ static FC_DEVICE_ATTR(starget, field, S_IRUGO,			\
 	if (i->f->show_starget_##field)					\
 		count++
 
+#define SETUP_PRIVATE_STARGET_ATTRIBUTE_RW(field)			\
+do {									\
+	i->private_starget_attrs[count] = device_attr_starget_##field; \
+	i->starget_attrs[count] = &i->private_starget_attrs[count];	\
+	count++;							\
+} while (0)
+
 #define SETUP_STARGET_ATTRIBUTE_RW(field)				\
 	i->private_starget_attrs[count] = device_attr_starget_##field; \
 	if (!i->f->set_starget_##field) {				\
@@ -2095,7 +2194,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
 		if (rport->scsi_target_id == -1)
 			continue;
 
-		if (rport->port_state != FC_PORTSTATE_ONLINE)
+		if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
+			(rport->port_state != FC_PORTSTATE_MARGINAL))
 			continue;
 
 		if ((channel == rport->channel) &&
@@ -2198,7 +2298,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_STARGET_ATTRIBUTE_RD(node_name);
 	SETUP_STARGET_ATTRIBUTE_RD(port_name);
 	SETUP_STARGET_ATTRIBUTE_RD(port_id);
-
+	SETUP_PRIVATE_STARGET_ATTRIBUTE_RW(port_state);
 	BUG_ON(count > FC_STARGET_NUM_ATTRS);
 
 	i->starget_attrs[count] = NULL;
@@ -2958,7 +3058,8 @@ fc_remote_port_delete(struct fc_rport  *rport)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	if (rport->port_state != FC_PORTSTATE_ONLINE) {
+	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
+		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		return;
 	}
@@ -3100,7 +3201,8 @@ fc_timeout_deleted_rport(struct work_struct *work)
 	 * target, validate it still is. If not, tear down the
 	 * scsi_target on it.
 	 */
-	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
+	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
+		(rport->port_state == FC_PORTSTATE_MARGINAL)) &&
 	    (rport->scsi_target_id != -1) &&
 	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
 		dev_printk(KERN_ERR, &rport->dev,
@@ -3243,7 +3345,8 @@ fc_scsi_scan_rport(struct work_struct *work)
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	unsigned long flags;
 
-	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
+	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
+		(rport->port_state == FC_PORTSTATE_ONLINE)) &&
 	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
 	    !(i->f->disable_target_scan)) {
 		scsi_scan_target(&rport->dev, rport->channel,
@@ -3747,7 +3850,8 @@ static blk_status_t fc_bsg_rport_prep(struct fc_rport *rport)
 	    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
 		return BLK_STS_RESOURCE;
 
-	if (rport->port_state != FC_PORTSTATE_ONLINE)
+	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
+		(rport->port_state != FC_PORTSTATE_MARGINAL))
 		return BLK_STS_IOERR;
 
 	return BLK_STS_OK;
-- 
2.26.2


--0000000000009a678605b05e31d3
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
BCANmt1aH58NISTFcv1cg3u9MTpTKekV4CD/Enq8KIRRiTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDA5MjgxMTQ0NDlaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEABmaWoK7+/+bGZ1xs
9nVWjXa5bzVbvfXsFeYs449HNwV3OCnBBf4ZgZakR7H27VJ7n8kZhdzR5HEVUjA8YtXDQAczPIsp
cY6RU70t6Mbv0tmjDd8iiTcZFB9LojRoi+lP94NV8fnTjtPSY5hHwtZIu7X3JX/zmaozRN4n50Pj
6SsoK8IfGeNAFtJmlXrqsBHaKm/bU1Hm1CoPeyf9XdPKG36ocxGNgZgUdhtzKZztxE0D0QuiUfK3
Dv1Sd47rskW+AMELeBwXC2DgoMUZD65t1V4OyCEXGLmuGtaYkatxP6dWrkALNXXfXc6UBtrH8lpi
yjLLgpUMphgB32IJ8kiF1w==
--0000000000009a678605b05e31d3--
