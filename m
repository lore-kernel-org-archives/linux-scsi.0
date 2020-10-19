Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B05C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 18:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F13A4223BF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 18:55:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="B9goTsK8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgJSSzr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 14:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbgJSSzr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 14:55:47 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2DAC0613CE
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2020 11:55:47 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id n11so698982ota.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2020 11:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=oikk3C2++MBToLH51/Upar3ZzaG5mYSTuD8WL3aNNM0=;
        b=B9goTsK8hgj5vOeAybEeFnreKHjwClCa1gtBc0EJFs5rSw/+aqLQRiWfvhvEeHVTy+
         NjNNd4WpblXzC/uL/Mt2sRFc7DznfdG8/+/spjOtVMXRSlG0HeGGdN0BrDsdhofqDNh4
         BxbW/NlV/dE7Te1Y21w/6qPO2VNjzq+0AjNzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=oikk3C2++MBToLH51/Upar3ZzaG5mYSTuD8WL3aNNM0=;
        b=pJN59AGNlosIwWGpWkdHCo2TWZn15tSDBETeoFFmnFqp1lieKZfJph2e5a4rsKohY3
         EUDH5oT/uMoQPWooa8rM8ubPyVFFMDtk1qrjBEtipIvGcjxxQrpe+FiMNyAuCdKpiYZe
         lXrcJ0l1FO8+ag2fHsuuipI+V5PiHMUe8NFEWT9Ok4VLa4imz/+TTSZwuFXu7gSWLT7Z
         9zAM9CNBOljF/3kGp55wTVAnjdL4+FbhzQV4oyDFmYDmSPjmBmBc66hdQ9n4NdXUb/38
         MeWAEs3/nz01o+gTMrycgRl0u0/62s5z+PXeaw1xsK7+yGENHNf+dOahQaK1Ol98F3LK
         m6Kw==
X-Gm-Message-State: AOAM530CxGr2Ov7bCzVM9LAemVPolzoSGkzLmfEa4WJuQ8V1tcsmpXy+
        k9fWdbjlrf/2vjqhvebK+q5QcjrtP3UWFuhQiy7cKi03j4b6uw==
X-Google-Smtp-Source: ABdhPJz9LhAzfjgeBuTo07BTwtFZtWmD4xz75cc4x6XA99vIr4bJatkueXvYzNqQ1n9CdJDWvqhNVV2yQq7gYr83MYQ=
X-Received: by 2002:a9d:3f44:: with SMTP id m62mr1017031otc.364.1603133744997;
 Mon, 19 Oct 2020 11:55:44 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
 <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com> <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
 <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com> <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
 <a9b958fb-3c06-c385-f7ce-ce0fc863e64b@suse.de> <e031f239c4bc02cafde13ad573523559@mail.gmail.com>
 <0863bb07-1f74-ba14-50dc-717c7f68af7e@oracle.com>
In-Reply-To: <0863bb07-1f74-ba14-50dc-717c7f68af7e@oracle.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFATVqLRX+cZ5DMpa/LB2sUjSWzQAGJthEBAcREcNICYfc3iwLXtvtQAo/g/YwBakTnWQF1WTuHAZ+CZIGqT0FCcA==
Date:   Tue, 20 Oct 2020 00:25:42 +0530
Message-ID: <9e48826470ef61e2d56922c4290c2c0b@mail.gmail.com>
Subject: RE: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state FC_PORTSTATE_MARGINAL
To:     Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com,
        Benjamin Marzinski <bmarzins@redhat.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000858f7605b20aa992"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000858f7605b20aa992
Content-Type: text/plain; charset="UTF-8"

Hi Micheal,
AFIK As long as the paths are available irrespective of  the path is moved
to marginal path group or not multipathd  will keep sending the send path
tester IO (TUR) to check the health status.

Benjamin,
Please let me know if iam wrong.

Regards,
Muneendra.


-----Original Message-----
From: Mike Christie [mailto:michael.christie@oracle.com]
Sent: Tuesday, October 20, 2020 12:15 AM
To: Muneendra Kumar M <muneendra.kumar@broadcom.com>; Hannes Reinecke
<hare@suse.de>
Cc: linux-scsi@vger.kernel.org; jsmart2021@gmail.com; emilne@redhat.com;
mkumar@redhat.com
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
FC_PORTSTATE_MARGINAL

On 10/19/20 1:03 PM, Muneendra Kumar M wrote:
> Hi Michael,
> Regarding the TUR (Test Unit Ready)command which I was mentioning .
> Multipath daemon issues TUR commands on a regular intervals to check
> the path status.
> When a port_state is set to marginal we are not suppose to end up
> failing the cmd  with DID_TRANSPORT_MARGINAL with out proceeding it.
> This may  leads to give wrong health status.


If your daemon works such that you only move paths from marginal to active
if you get an ELS indicating the path is ok or you get a link up, then why
have multipathd send path tester IO to the paths in the marginal path group?
They do not do anything do they?



> Hannes/James Correct me if this is wrong.
>
> Regards,
> Muneendra.
>
> -----Original Message-----
> From: Muneendra Kumar M [mailto:muneendra.kumar@broadcom.com]
> Sent: Monday, October 19, 2020 11:01 PM
> To: 'Hannes Reinecke' <hare@suse.de>; 'Michael Christie'
> <michael.christie@oracle.com>
> Cc: 'linux-scsi@vger.kernel.org' <linux-scsi@vger.kernel.org>;
> 'jsmart2021@gmail.com' <jsmart2021@gmail.com>; 'emilne@redhat.com'
> <emilne@redhat.com>; 'mkumar@redhat.com' <mkumar@redhat.com>
> Subject: RE: [PATCH v3 05/17] scsi_transport_fc: Added a new rport
> state FC_PORTSTATE_MARGINAL
>
> Hi Michael,
>
>
>>
>>
>> Oh yeah, to be clear I meant why try to send it on the marginal path
>> when you are setting up the path groups so they are not used and only
>> the optimal paths are used.
>> When the driver/scsi layer fails the IO then the multipath layer will
>> make sure it goes on a optimal path right so you do not have to worry
>> about hitting a cmd timeout and firing off the scsi eh.
>>
>> However, one other question I had though, is are you setting up
>> multipathd so the marginal paths are used if the optimal ones were to
>> fail (like the optimal paths hit a link down, dev_loss_tmo or
>> fast_io_fail fires, etc) or will they be treated like failed paths?
>>
>> So could you end up with 3 groups:
>>
>> 1. Active optimal paths
>> 2. Marginal
>> 3. failed
>>
>> If the paths in 1 move to 3, then does multipathd handle it like a
>> all paths down or does multipathd switch to #2?
>>
>> Actually, marginal path work similar to the ALUA non-optimized state.
>> Yes, the system can sent I/O to it, but it'd be preferable for the
>> I/O to be moved somewhere else.
>> If there is no other path (or no better path), yeah, tough.
>
>> Hence the answer would be 2)
>
>
> [Muneendra]As Hannes mentioned if there are no active paths, the
> marginal paths will be moved to normal and the system will send the io.
>
> Regards,
> Muneendra.
>

--000000000000858f7605b20aa992
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
BCCv9OCidskL8EkDZy8Eu6A9wCsBzJM94IonmTGdiu7KqjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMTkxODU1NDdaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAtoukuX2bd1Ej3UK6
xxcabySF1s7G9alvM4SUo6ZzngnZhUhoGLRF8bNwH0UURfReYxjeB77RFO2LnGgOc0xCIiydN/Ug
CmlWiX8k2HUMeG2xzKlRWTZ2O0z2rMGQl6s6AIdMllKpPu4L0kBfZmnUNjSYRxMAzXJFxx90F14j
03iy53WeRSWb0lKIoemrY8LfDrkay5yvNVSc2dQbNxmuQi4qbNEDBYn1s1NJ+qpfHDBQn99fuxQd
g/KY0sytrusHMeQjOP0YksV3LeeyqZ8fI0Whm3Biz3mtD6OyArbmrpe655uuLX4D3THsN3Nj31rh
dlrRtV83nM9uxed3HEROfQ==
--000000000000858f7605b20aa992--
