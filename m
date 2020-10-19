Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2B1C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 18:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 414D922260
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 18:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fNiwOLMn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgJSSDH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 14:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729511AbgJSSDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 14:03:06 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FE4C0613CE
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2020 11:03:06 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id f1so80011oov.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2020 11:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=smti5Kt/aEiui7MtgbnAHXT0e1DpQ/PbricSqDhhB/s=;
        b=fNiwOLMnZGu2gVmmk0apf0Odzt+/CnWUyXFVJHnAJArPFR6ORvwp9sTPSlYGBgruOF
         shwBAxxQfiR0RVxsZsVPpVsDEUPMlJntbqN0zY3w/i2UHTwnGDvsbxYHowoxbk9LNukP
         PVfG6KM9i25QfZEegsNN6sOHowmm7sZku2vM8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=smti5Kt/aEiui7MtgbnAHXT0e1DpQ/PbricSqDhhB/s=;
        b=QHhTqVvbcgWBWb1BpiQMS21KwBmhrSih+cKdqMUFXZ5yfhVe1BGwNooKP+Gj9e1ttA
         0VgQK3AvNSKhiahf8kHMWMpyugy5Fx1rDwQKSQ+/90hULxRHmrO1Eh9tPFUbuhxBZuc9
         C0XSt5qUZQCfd+Uzzg7Nt2ObgYx/5DBiM6fIN+6Urnn9kToEQS66yDf25VBCUkawWTPq
         s6iO3LrvAmkEdFCZiMFKT35yN+38IDMPjNVKeKCKANF7xQMo/q3r+1zrAK2AKslILwU1
         d6LBuqogitzDStt4c4f/LYPwxRuk0qthFKMSMeu4XlqAgPq+fE5JdZelCLRZtkhLerXd
         SYVw==
X-Gm-Message-State: AOAM533Pfm9P31t2GmBTL8kc3+vbvW+aij5geaeRFBDnXIO1Zqk7RX1P
        IhXFdpS7XfmhDDqfDOIMjZ3lcCZ02mhG2v+Kja0bFg==
X-Google-Smtp-Source: ABdhPJxjEH7pbMw7sAB7MRPiw2MkQoaQA6i/ifRq86k67mrY+FaTzEMx4XUWvn3/0J3UdSxWXuC8zI1Icv8y1C9IRYw=
X-Received: by 2002:a4a:1e43:: with SMTP id 64mr844756ooq.7.1603130585613;
 Mon, 19 Oct 2020 11:03:05 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
 <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com> <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
 <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com> <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
 <a9b958fb-3c06-c385-f7ce-ce0fc863e64b@suse.de> bf347ae232d73c4a21af6514085a92f2@mail.gmail.com
In-Reply-To: bf347ae232d73c4a21af6514085a92f2@mail.gmail.com
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFATVqLRX+cZ5DMpa/LB2sUjSWzQAGJthEBAcREcNICYfc3iwLXtvtQAo/g/YwBakTnWapnz3KAgAAFtNA=
Date:   Mon, 19 Oct 2020 23:33:03 +0530
Message-ID: <e031f239c4bc02cafde13ad573523559@mail.gmail.com>
Subject: RE: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state FC_PORTSTATE_MARGINAL
To:     Hannes Reinecke <hare@suse.de>,
        Michael Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001b9e0d05b209edd2"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001b9e0d05b209edd2
Content-Type: text/plain; charset="UTF-8"

Hi Michael,
Regarding the TUR (Test Unit Ready)command which I was mentioning .
Multipath daemon issues TUR commands on a regular intervals to check the
path status.
When a port_state is set to marginal we are not suppose to end up failing
the cmd  with DID_TRANSPORT_MARGINAL with out proceeding it.
This may  leads to give wrong health status.
Hannes/James Correct me if this is wrong.

Regards,
Muneendra.

-----Original Message-----
From: Muneendra Kumar M [mailto:muneendra.kumar@broadcom.com]
Sent: Monday, October 19, 2020 11:01 PM
To: 'Hannes Reinecke' <hare@suse.de>; 'Michael Christie'
<michael.christie@oracle.com>
Cc: 'linux-scsi@vger.kernel.org' <linux-scsi@vger.kernel.org>;
'jsmart2021@gmail.com' <jsmart2021@gmail.com>; 'emilne@redhat.com'
<emilne@redhat.com>; 'mkumar@redhat.com' <mkumar@redhat.com>
Subject: RE: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
FC_PORTSTATE_MARGINAL

Hi Michael,


>
>
> Oh yeah, to be clear I meant why try to send it on the marginal path
> when you are setting up the path groups so they are not used and only the
> optimal paths are used.
> When the driver/scsi layer fails the IO then the multipath layer will
> make sure it goes on a optimal path right so you do not have to worry
> about hitting a cmd timeout and firing off the scsi eh.
>
> However, one other question I had though, is are you setting up
> multipathd so the marginal paths are used if the optimal ones were to
> fail (like the optimal paths hit a link down, dev_loss_tmo or
> fast_io_fail fires, etc) or will they be treated like failed paths?
>
> So could you end up with 3 groups:
>
> 1. Active optimal paths
> 2. Marginal
> 3. failed
>
> If the paths in 1 move to 3, then does multipathd handle it like a all
> paths down or does multipathd switch to #2?
>
>Actually, marginal path work similar to the ALUA non-optimized state.
>Yes, the system can sent I/O to it, but it'd be preferable for the I/O to
>be moved somewhere else.
>If there is no other path (or no better path), yeah, tough.

>Hence the answer would be 2)


[Muneendra]As Hannes mentioned if there are no active paths, the marginal
paths will be moved to normal and the system will send the io.

Regards,
Muneendra.

--0000000000001b9e0d05b209edd2
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
BCAKKVF8Eq6hEOUC7YC+L6qVMwiO8x9aVYFbDwRT5FFWuTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMTkxODAzMDZaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAJA22sz4UD9ooYW30
tzDIaCWTyT1RTkikNdzdYJQ3LZZpvXodF1VbDgSxVXmjSY70ztPLFd8Ynplbx0JBn0Ut5yzth/Xu
0rRH8z/uSQEKZ4rnm0Fs37Fjfj9t5NUx/zopY3NJ4tIHMZs4SP6Vd9bYsqRp14dwhtMPxAsn4q30
9OEXFmmdGsEpKzH73m+BKV7pnk8yDMsaMBVsrrm7XiDQfbSS9Rd3Kuy8fB/SHp3SgiwA0dz1Wdr1
7LexazIcy92rmQhuRfyCHb+SNCszz+nJJ0s6xUDSCaW9xNTPyKHHJDYQcSy3EzOA0U6+GtA0vWT/
XUiNppiuiGVzz51yg72BcQ==
--0000000000001b9e0d05b209edd2--
