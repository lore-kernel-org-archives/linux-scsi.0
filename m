Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CB4C55179
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB75C20782
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 11:53:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FAwPN30B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgJ2Lxx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgJ2Lxx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 07:53:53 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295FAC0613CF
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2020 04:53:53 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id k3so2006624otp.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2020 04:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=oeZ6d/THNOVE0jPl0MN9o4OQ8e/AYRO4PT8Ku0c2LhY=;
        b=FAwPN30BOfs+uYP/nh05IFUvErPrAGwYDyA2GStufia78mv3y1PFEP7RVKM7AeWx1C
         2MJoiDysgqaA4/HhEaFo317TTXpNs6BQJ1qjlP2UWmsRZ1aSvleq1/3fE4HXPcqEI5Sy
         jZ39X0dfAUYTpMq1OumuTZsynRHZmhFLpZV7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=oeZ6d/THNOVE0jPl0MN9o4OQ8e/AYRO4PT8Ku0c2LhY=;
        b=dEA1CUNwXV5554f+SEKXjqDyK1EL+K8yBEfs88EOZphDzyO98yCpQvvt+xagN0YQzA
         zSfDZrtrsglnXm7GvuGz2Xa04hEqxAPlyk+zZEPjRl1XaQ5nBKUuu9sEMpzcOCAOqs1+
         Hv9nm/Qi7nT4z8sXyYyjm6yTqy/qgqCOcfG29gLKJF5PAsmIQgSC++OjIzcvcA+6euOV
         Qhm6nSNBenysAk/DXvrpnv3XWKKv0e+sSyrqdhJ+mA/QSXTSPMTRurm5YLKGPY1K/cQd
         Vzj4HXhZt9PEDPM2cILKenK8SbaBqPbqlH0IfM2dbK5cP8sM1SnClLB18takA+egRYHU
         mzsg==
X-Gm-Message-State: AOAM533DW/QK5F6dREbFz0l9/q51K5FE+ZwfvlMnu5+DfuEjJHyNDiTE
        8qe3SCtm3kex9IfjCH/BfSSvGIC6UJ61M1HfmNQXbA==
X-Google-Smtp-Source: ABdhPJyMXGzfCDtyzSZgOe8FxjaGrqYamelTq8IJ5QnIDH3l6U1D6SyPHX6N2Mcur7IOzufNwV7JDjtl4ONLLMv4Mo0=
X-Received: by 2002:a9d:942:: with SMTP id 60mr2861170otp.360.1603972432451;
 Thu, 29 Oct 2020 04:53:52 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1603370091-9337-1-git-send-email-muneendra.kumar@broadcom.com>
 <1603370091-9337-5-git-send-email-muneendra.kumar@broadcom.com> <2818f7af-e2f9-7d20-a0e6-10eb3c03c7ef@oracle.com>
In-Reply-To: <2818f7af-e2f9-7d20-a0e6-10eb3c03c7ef@oracle.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLv5vf0y45oXVLFrswKM5p1yAny/wICmmMsApYyjemnVyn9oA==
Date:   Thu, 29 Oct 2020 17:23:47 +0530
Message-ID: <6499e81f001ed33b8430d5f2cd863ae2@mail.gmail.com>
Subject: RE: [patch v4 4/5] scsi_transport_fc: Added a new rport state FC_PORTSTATE_MARGINAL
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000015d2de05b2cdefba"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000015d2de05b2cdefba
Content-Type: text/plain; charset="UTF-8"

Hi Mike,
Below are my replies.

-----Original Message-----
From: Mike Christie [mailto:michael.christie@oracle.com]
Sent: Monday, October 26, 2020 10:45 PM
To: Muneendra <muneendra.kumar@broadcom.com>; linux-scsi@vger.kernel.org;
hare@suse.de
Cc: jsmart2021@gmail.com; emilne@redhat.com; mkumar@redhat.com
Subject: Re: [patch v4 4/5] scsi_transport_fc: Added a new rport state
FC_PORTSTATE_MARGINAL

On 10/22/20 7:34 AM, Muneendra wrote:
> @@ -2071,6 +2074,7 @@ fc_eh_timed_out(struct scsi_cmnd *scmd)  {
>  	struct fc_rport *rport =
> starget_to_rport(scsi_target(scmd->device));
>
> +	fc_rport_chkmarginal_set_noretries(rport, scmd);
>  	if (rport->port_state == FC_PORTSTATE_BLOCKED)
>  		return BLK_EH_RESET_TIMER;

>If we are in port state marginal above, then we will try to abort the cmd,
>but if while doing the abort we call fc_remote_port_delete and
>fc_remote_port_add then the port state will be online when the EH callouts
>complete. In >this case, the port state is online in the end, but we would
>fail the command like it was in marginal.
[Muneendra] I have to  make sure the flag is set after the check for blocked
state.  If blocked, it's returning BLK_EH_RESET_TIMER, so it will restart
the eh
timer. The io will "sit out" like this, pending, until either the adapter
fails it back due to logout or io completion, or fastio fail or
rport devloss timesout and invokes the abort handler to force abort .

> +		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  		return;

>It looks like if fc_remote_port_delete is called, then we will allow that
>function to set the port_state to blocked. If the problem is resolved then
>fc_remote_port_add will set the state to online. So it would look like the
>port state is >now ok in the kernel, but would userspace still have it in
>the marginal port group?

>Did you want this behavior or did you want it to stay in marginal until
>your daemon marks it as online?
[Muneendra] We need this behavior.User daemon
should not depend on the rport_state to move a path from marginal path
 group.It should only depends on RSCN and LINKUP events/manual
intervention. events that we look out (rscn for target-side cable  bounces
and link up/down for initiator cable bounces) will result in
port state changes - so although we don't drive one from the other, they are
correlated.

Regards,
Muneendra.

--00000000000015d2de05b2cdefba
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
BCDPufv1HCxII2unleAWdZj4/MW6ovF3SlUcfc9N3Yo7pzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMjkxMTUzNTJaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAlsWCvo3wuXfbIae/
eEJCwe6ebPU4jlZxzQ209fKF3CzOsNOvI1GVwigiFmlY1KWwdDZ2E0KkDG09qTSc95ACZE+i0pTF
XivW+r7Xni4Tgq8Q5Y7IYE3Ua9AnGg3oyezkEu8eMmrbxp1CugZ24aulJwM6INFSZK7uYIS7n3Jq
9fEDjEbyuohF+JBDISBb3deb3570ARG/D9DSqesOpCYysy8zGwu6YdnSfIsKgnz3N1kAqvLI3F1M
6Q+n8G6VUuNkgSl2UGFPurLGyoj00As6SESL5sGAUtg9O5+ZQPfAeQLUJx8acqBLU3pObNrNX7O/
SY0lnk8VjkPJsShwFn64Xw==
--00000000000015d2de05b2cdefba--
