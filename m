Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76517C4741F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 20:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 038682074B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 20:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OtO15o6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgKEUCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 15:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEUCp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 15:02:45 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8CFC0613CF
        for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2020 12:02:45 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id t16so2943158oie.11
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2020 12:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=xub4fded6oUceeS63EbKrGcwb5WjUa/pvuGO51MUvNg=;
        b=OtO15o6wYitmms2Ci4kw/4fkAGFIvLoLPJtzt6rRf7wvWeDB6zcZHamVzkdZBczftV
         zoSdoisKannYv0JI4zYXeFa88AL4Ws6EdQ0RiD7RFUC2KCGCVQEjGCzqgUw7t/IeaUnw
         788JWxwMLZHgv+uxdx2x9BLmlH5y3MeHSXuWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=xub4fded6oUceeS63EbKrGcwb5WjUa/pvuGO51MUvNg=;
        b=MNuA9US8SWgGN4dCqfmTLSXW0qTmx1ltK69B89tJqvHzdv54nhunvkPOu4WdiTszeR
         PLIDl8pdnQNHCn0zgHq6LwtNiRBEQYCTd7P47mWD+VNlx7xx9GMeddgZWp+sYaBeNtoW
         Fuhx3yt5bvU9HtSF75tgHQS39nZjmDoY0dZif4cAqw3H7q2+tkI6PF+AnCkwbMeyGyHg
         qTv4DIYmlDRMleme2lLkG22Eq5Eif3YPkQODS/uieoAGYQTH1T9HX9rCsfn5GIKiwG2z
         SJzLORWFhnPBF3g/Zy7yQuyJnLwuSvlB+udv7amIE0LZdI62ff8IW1V6w4J7/Jt60D4s
         9TcA==
X-Gm-Message-State: AOAM533Hp6yugVoJWCFWb/Z8T6kLCvZ5rVdes0uqa5NGx9xBwNocRGFG
        3IpxAAuOwZj+F+WyVfoJs7/KNfqtsL2X/wDhdvCYGQ==
X-Google-Smtp-Source: ABdhPJwdQXNEWGvJhRtqR/NGKHnWKCdTZGWhQifDFv8xpBVucx0HXAXajg7Ds7MaoGtvbT9rwupol9cH7IqzkzJ00Ro=
X-Received: by 2002:aca:c70b:: with SMTP id x11mr713098oif.104.1604606564550;
 Thu, 05 Nov 2020 12:02:44 -0800 (PST)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1604556596-27228-1-git-send-email-muneendra.kumar@broadcom.com>
 <1604556596-27228-4-git-send-email-muneendra.kumar@broadcom.com>
 <e575da88-8b40-3062-9835-419456b46989@oracle.com> <08d150e63f2b79cd0199fb49355ce601@mail.gmail.com>
 <eed1c6b0-1b9c-572c-a9f6-8468a6996491@oracle.com>
In-Reply-To: <eed1c6b0-1b9c-572c-a9f6-8468a6996491@oracle.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJbIqKuxKDp76OdHE9svWN8tlfO/QIOdQWIAbeXNKQCjjFYMwNRi63YqGPpqQA=
Date:   Fri, 6 Nov 2020 01:32:42 +0530
Message-ID: <580c59bb83eaff8dd60705ede02ae133@mail.gmail.com>
Subject: RE: [PATCH v6 3/4] scsi_transport_fc: Added a new rport state FC_PORTSTATE_MARGINAL
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004e845d05b3619476"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000004e845d05b3619476
Content-Type: text/plain; charset="UTF-8"

Hi Mike,
Thanks for the detailed input.
I will apply the below changes and will resubmit the patches.

Regards,
Muneendra.

-----Original Message-----
From: Mike Christie [mailto:michael.christie@oracle.com]
Sent: Friday, November 6, 2020 12:46 AM
To: Muneendra Kumar M <muneendra.kumar@broadcom.com>;
linux-scsi@vger.kernel.org; hare@suse.de
Cc: jsmart2021@gmail.com; emilne@redhat.com; mkumar@redhat.com
Subject: Re: [PATCH v6 3/4] scsi_transport_fc: Added a new rport state
FC_PORTSTATE_MARGINAL

On 11/5/20 11:27 AM, Muneendra Kumar M wrote:
> Hi Mike,
> Thanks for the input.
> Below are my replies.
>
>
>> Hey sorry for the late reply. I was trying to test some things out
>> but am not sure if all drivers work the same.
>
>> For the code above, what will happen if we have passed that check in
>> the driver, then the driver does the report del and add sequence?
>> Let's say it's initially calling the abort callout, and we passed
>> that check, we then do the >del/add seqeuence, what will happen next?
>> Do the fc drivers return success or failure for the abort call. What
>> happens for the other callouts too?
>
>> If failure, then the eh escalates and when we call the next callout,
>> and we hit the check above and will clear it, so we are ok.
>
> If success then we would not get a chance to clear it right?
> [Muneendra]Agreed. So what about clearing the flags in
> fc_remote_port_del. I think this should address all the concerns?
>
>> If this is the case, then I think you need to instead go the route
>> where you add the eh cmd completion/decide_disposition callout. You
>> would call it in scmd_eh_abort_handler, scsi_eh_bus_device_reset, etc
>> when we are deciding if we want to retry/fail the command.
> [Muneendra]Sorry I didn't get what you are saying could you please
> elaborate on the same.
>
> In this approach you do not need the eh_timed_out changes, since we
> only seem to care about the port state after the eh callout has completed.
> [Muneendra]what about setting the SCMD_NORETRIES_ABORT bit?
>

I don't think you need it. It sounds like we only care about the port state
when the cmd is completing. For example we have:

1. the case where the cmd times out, we do aborts/resets, then the port
state goes into marginal, then the aborts/resets complete. We want to fail
the cmds without retries.

2. If the port state is in marginal, the cmd times out, we do the
aborts/resets and when we are done if the port state is still marginal we
want to fail the cmd without retries.

3. If the port state is marginal (or any value), before or after the cmd
initially times out, but the port state goes back to online, then when the
aborts/resets complete we want to retry the cmd.

So can we just add a callout to check the port state when the eh has
completed like the untested unfinished patch below:


diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 983eeb0..8ad3a9a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6041,6 +6041,7 @@ struct scsi_host_template lpfc_template = {
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_timed_out		= fc_eh_timed_out,
+	.eh_timed_out		= fc_eh_should_retry_cmd,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler, diff --git
a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c index
f11f51e..7c66d17 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -140,6 +140,7 @@ static bool scsi_cmd_retry_allowed(struct scsi_cmnd
*cmd)
 	struct scsi_cmnd *scmd =
 		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
+	struct Scsi_Host *host = sdev->host;
 	int rtn;

 	if (scsi_host_eh_past_deadline(sdev->host)) { @@ -159,7 +160,8 @@ static
bool scsi_cmd_retry_allowed(struct scsi_cmnd *cmd)
 						    "eh timeout, not retrying "
 						    "aborted command\n"));
 			} else if (!scsi_noretry_cmd(scmd) &&
-				   scsi_cmd_retry_allowed(scmd)) {
+				   scsi_cmd_retry_allowed(scmd) &&
+				   host->hostt->eh_should_retry_cmd(scmd)) {
 				SCSI_LOG_ERROR_RECOVERY(3,
 					scmd_printk(KERN_WARNING, scmd,
 						    "retry aborted command\n"));
@@ -2105,7 +2107,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
 		list_del_init(&scmd->eh_entry);
 		if (scsi_device_online(scmd->device) &&
-		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd)) {
+		    !scsi_noretry_cmd(scmd) && scsi_cmd_retry_allowed(scmd) &&
+		    host->hostt->eh_should_retry_cmd(scmd)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
 					     "%s: flush retry cmd\n",
diff --git a/drivers/scsi/scsi_transport_fc.c
b/drivers/scsi/scsi_transport_fc.c
index 2ff7f06..7011963 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2043,6 +2043,18 @@ static int fc_vport_match(struct attribute_container
*cont,
 	return &i->vport_attr_cont.ac == cont;  }

+bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd) {
+	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
+
+	if (rport->port_state == FC_PORTSTATE_MARGINAL)
+		return false;
+
+	/* Other port states will set the sdev state */
+	/* TODO check comment above */
+	return true;
+}
+EXPORT_SYMBOL_GPL(fc_eh_should_retry_cmd);

 /**
  * fc_eh_timed_out - FC Transport I/O timeout intercept handler diff --git
a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h index 701f178..51d5af0
100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -315,6 +315,13 @@ struct scsi_host_template {
 	 */
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);

+	/*
+	 * Optional routine that allows the transport to decide if a cmd is
+	 * retryable. Return true if the transport is in a state the cmd
+	 * should be retried on.
+	 */
+	bool (*eh_should_retry_cmd)(struct scsi_cmnd *);
+
 	/* This is an optional routine that allows transport to initiate
 	 * LLD adapter or firmware reset using sysfs attribute.
 	 *
diff --git a/include/scsi/scsi_transport_fc.h
b/include/scsi/scsi_transport_fc.h
index 1c7dd35..f21b583 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -803,6 +803,7 @@ struct fc_vport *fc_vport_create(struct Scsi_Host
*shost, int channel,  int fc_block_rport(struct fc_rport *rport);  int
fc_block_scsi_eh(struct scsi_cmnd *cmnd);  enum blk_eh_timer_return
fc_eh_timed_out(struct scsi_cmnd *scmd);
+bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd);

 static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job *job)  {

--0000000000004e845d05b3619476
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
BCA8r6IpsOiYzdd82rosHnhDuCaXWHHQaxiBcVzetisucDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDExMDUyMDAyNDRaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAkfvZgx2DargUcZzi
JebtA7z/MKILo932FookD4+9fW2t66qjb+NNE068nYbM9IWH1FK8D6u0wHsZHi0l/ydSG97yCP8N
mMEYjquYnjvT6p3QFzFv2rV1V53u+4t/cwgBqQCMK/jPCgO8NRG3CbGt34e4fSn/NjsLYi0/7/64
VVmyQkg3OoqkWiKCjtco8gBGBSKPgIwgTnqVMIPgd8f5sKT03BzuSlkZktjuXNqH+SMfMcZKGUJQ
+rxXbwTPE0iSrws5Gto2FIf5FHyepkVUvFEVkpZAkq5r7hwxHI2you5+ES3Gq8MK5yjbrkUrteiu
SbpVU65En1W2l9hWg4T3bA==
--0000000000004e845d05b3619476--
