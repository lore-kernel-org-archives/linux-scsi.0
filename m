Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8A3C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 16:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C3F214F1
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 16:56:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RIab94O/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgJ2Q4o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 12:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgJ2Q4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 12:56:44 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8F9C0613CF
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2020 09:56:44 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id s21so3760909oij.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2020 09:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=s33VaVKSaw2q7yG2uUTQtijnQVJYjeBqd0hN07fuBKI=;
        b=RIab94O/dzQJ3Ack4UYZpS198dOnUzaxTRyCqn6+PDnnZGqlM5sKy5mCSHmjDjwEwr
         d9VIKmpwLa3tjNeUugzVZNoezenpicI0+zD0aXbIbypp/3alma6XFuiwG2Tn4roPRT0w
         BZwpRB66UyXdkT6BcWxHwJwStFcyBQ4JW2/A4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=s33VaVKSaw2q7yG2uUTQtijnQVJYjeBqd0hN07fuBKI=;
        b=D9nMtoHHlv+cCwMH74QuHza/VaUvt3lW8dm8akUROf5kN3IRkTH9Bah/L/UqlowMaA
         +1chgEfqAEWV9n/xxztW7bMGgWCdDXMiLRsMG2j0XpQudEbE6KFoE8JZ3+TldivSZcM9
         lNmyJylGZALmvRMPgRFVr/EbEk2vfcw7Wkl4ojAicY40paVt+JRzXYAnBypduY6mRyl2
         8MVgZc9XO2+KSVFv4OgVkK0USoHb+gBZeu+P99f2Y7zaNm3G4ljCuYXM7sFxkFtxC/2J
         IDL7kcRhs34C4UvL/L1XOmKnWCnDEEn6PAAv6YS0W0Cr+TfPEPFwlX+sbqQpD+ixBENa
         rI1Q==
X-Gm-Message-State: AOAM530UDbhsdrfrXw95Fg6hh92+KlTFNjsg2mGTlDyyszLHWKZbTmqe
        nT1uEtitWSVf5R98lUaegJmWgA5LFW+cqs1ch3cOjw==
X-Google-Smtp-Source: ABdhPJwANWHk1c6UDON7y8ULC99o6cYxBpps7vDUdQkS1WAOZeuXiQ2vFIX6gySg2lEoQWR2KBjII+mKUcX+w5tb+Vs=
X-Received: by 2002:aca:6748:: with SMTP id b8mr386102oiy.77.1603990603263;
 Thu, 29 Oct 2020 09:56:43 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1603370091-9337-1-git-send-email-muneendra.kumar@broadcom.com>
 <1603370091-9337-5-git-send-email-muneendra.kumar@broadcom.com>
 <2818f7af-e2f9-7d20-a0e6-10eb3c03c7ef@oracle.com> <6499e81f001ed33b8430d5f2cd863ae2@mail.gmail.com>
 <49b9b97c-bf84-e9ac-3b74-ffbf3352e2d5@oracle.com>
In-Reply-To: <49b9b97c-bf84-e9ac-3b74-ffbf3352e2d5@oracle.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLv5vf0y45oXVLFrswKM5p1yAny/wICmmMsApYyjekCIoo37wE5UXM1pzyxxbA=
Date:   Thu, 29 Oct 2020 22:26:39 +0530
Message-ID: <16b1982432ed23ef646130c94ed1e9db@mail.gmail.com>
Subject: RE: [patch v4 4/5] scsi_transport_fc: Added a new rport state FC_PORTSTATE_MARGINAL
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000276aef05b2d22a2b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000276aef05b2d22a2b
Content-Type: text/plain; charset="UTF-8"

Hi Mike,

> [Muneendra] I have to  make sure the flag is set after the check for
> blocked state.  If blocked, it's returning BLK_EH_RESET_TIMER, so it
> will restart the eh timer. The io will "sit out" like this, pending,
> until either the adapter fails it back due to logout or io completion,
> or fastio fail or rport devloss timesout and invokes the abort handler
> to force abort .

>Hey,

>I'm not sure if we are talking about the same thing. If port state is
>marginal above, then we set the NORETRIES bit then return BLK_EH_DONE which
>will start up the scsi eh_abort_handler and if that fails the rest of the
>scsi >eh_*_handlers.

>While we are calling the eh handlers, if the driver does a
>fc_remote_port_delete then fc_remote_port_add we still have the NORETRIES
>bit set, so when we return from the eh_*_handlers we will fail the IO
>upwards.

>I was trying to ask if you wanted the IO failed upwards in that case.
>Because the port state went to online, did you want the normal (cleared
>NOTRIES bit) cmd retry behavior? It sounds like below you want the cleared
>NORETRIED bit behavior, right?
[Muneendra]Yes we need the normal cmd behavior(clear noretries bit) when the
portstate went to normal.
I think to achieve this we can  clear the noretries bit in fc_block_scsi_eh/
fc_block_rport .
As this is the last place where the individual abort_handler checks for
blocked state. Is this fine?

Regards,
Muneendra.

>
>> +		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
>>   		spin_unlock_irqrestore(shost->host_lock, flags);
>>   		return;
>
>> It looks like if fc_remote_port_delete is called, then we will allow
>> that function to set the port_state to blocked. If the problem is
>> resolved then fc_remote_port_add will set the state to online. So it
>> would look like the port state is >now ok in the kernel, but would
>> userspace still have it in the marginal port group?
>
>> Did you want this behavior or did you want it to stay in marginal
>> until your daemon marks it as online?
> [Muneendra] We need this behavior.User daemon should not depend on the
> rport_state to move a path from marginal path
>   group.It should only depends on RSCN and LINKUP events/manual
> intervention. events that we look out (rscn for target-side cable
> bounces and link up/down for initiator cable bounces) will result in
> port state changes - so although we don't drive one from the other,
> they are correlated.
>
> Regards,
> Muneendra.
>

--000000000000276aef05b2d22a2b
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
BCCzy7QrHkyRdtKyjRP+rIuqexxWKfdNUsWCTS5NC0vimzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMjkxNjU2NDNaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAsrBCFwxZWkT/jXD3
HhaSZsX9Ij4laMeJQ0I0t5HYn7QlRYWP6kytnwMocX4cWjK2+RuRQ8MqlA+VoAYLbqfFj7xnd/cv
CRNsE2dXec6n2xAgTX+w/qzYSgXMk0IXJad1EdNsEmP9tZWldLO+BWuYTgRyUKO43AzHE6aG0HfF
w18JJGoXnqGdDQFSQTgm2bwilaQGVv1NyVd82wgg1y0JydESBFnTZJAG/2o793uz6zE5/0nLhI/s
uFRfHC5kh6Y9ZjOJTyDSfc40Ipm7LnvyX9C6nnSNWskVt+Z5fqvoQMEbW7OPCdU+6RZyMlTFdkCm
yo2qTBQpHc8ZgbnjNvhSnQ==
--000000000000276aef05b2d22a2b--
