Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA7EC47420
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 08:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7330220BED
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 08:59:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Bwgk935f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgJAI7a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 04:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgJAI7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 04:59:30 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43958C0613D0
        for <linux-scsi@vger.kernel.org>; Thu,  1 Oct 2020 01:59:30 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id x69so4802542oia.8
        for <linux-scsi@vger.kernel.org>; Thu, 01 Oct 2020 01:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=+iVfQ8ztYs1JxgBj/781ZlAkR1gplZM/+esCLmA37vo=;
        b=Bwgk935f+PwqM9DxZZr0D6TU+oz3Q5VtzcBChjZb65kfwF1csSi6jil9OMgpYyt+Ma
         HnR3C9YmbHJXVE+ENxf6/m+AXFtsy1/DUl+WmcOXNaFp06vgnNj4Htnt9JQ9gkQuj2vv
         U5jvfImxYVJM7puXknC8GQGLPja8/nUrmRgyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=+iVfQ8ztYs1JxgBj/781ZlAkR1gplZM/+esCLmA37vo=;
        b=Cyst5ML+om2Tf5ZzuvmTjleCN7LRjUr+Q3TgEHVMURTkjvUITwbwByknVyRzbFcige
         kVFhtb1gpMb8nZmHy+QDxcwqt6kEiaXxiXDT5DKnhBxQG7EwfRaOk0CaP0ba2zPOZygU
         WFdmf35uTBB63az0NquH28TxqfuU5yqrXXboYBt955OA6lUAnST0IZXyVeO6xcbFaoJz
         8VQeXsbr6DkXatHkI20pgkcRWVZV2QiIVFHSLowsP2yfUtYsPu/O6oWc1V4qRCDIuyPi
         6/zXOoyhmaYQWnzczAh2/Fl3Jtg03MCbIGjyEZ3Xi3OH+VQwmaRaIUk61cRNjsjFBMjp
         IgRw==
X-Gm-Message-State: AOAM531u41bp7MyKEvcaSzBljl/oYXB5jEjUS1LVV8V5eZX8zAuz2QmL
        v5/zJD9Vie1jXIs7ocW19AiR1UV6WuFaSi1Jx6zsww==
X-Google-Smtp-Source: ABdhPJxY9+8McGNwLkVlnqYXgX3jL2oqERee5IEPcfBKq54GHRRCo0P+ezp0JNwSugjY02InU9xmLEgYjL0IFB/MYMQ=
X-Received: by 2002:aca:fc95:: with SMTP id a143mr3664866oii.104.1601542769636;
 Thu, 01 Oct 2020 01:59:29 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-9-git-send-email-muneendra.kumar@broadcom.com>
 <a0fb7bae-b6e7-8f28-f45f-0453311f383e@suse.de> <ce3d51fbc3fe51b29e82f6a3e317388b@mail.gmail.com>
 <dbda3941-727b-293f-97f8-4c67342c7920@suse.de> d113192920ae65d1b94ffe8dadd9d5ad@mail.gmail.com
In-Reply-To: d113192920ae65d1b94ffe8dadd9d5ad@mail.gmail.com
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHCNtb+JUCHm5+nw84r+9ykkbRKNAEWqyatAe56aFIBc84lOAHMySvLqXkBMqCAAAVpwA==
Date:   Thu, 1 Oct 2020 14:29:27 +0530
Message-ID: <a3bf7bf7f24eeab2dcbc6cdbe21bd296@mail.gmail.com>
Subject: RE: [PATCH v2 8/8] lpfc: Added support to handle marginal state
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e4453205b0983b1c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e4453205b0983b1c
Content-Type: text/plain; charset="UTF-8"

Hi Hannes,

>>> +     * If port state is marginal
>>> +     * Set the SCMD_NORETRIES_ABORT bit in scmd->state
>>> +     */
>>> +               fc_rport_chkmarginal_set_noretries(rport, cmnd);
>>>        ndlp = rdata->pnode;
>>>
>>>        if ((scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) &&
>>>
>> This really should be moved into the transport class;
>> fc_block_rport() would be an ideal place for it.
>
>> [Muneendra]Correct me if I didn't understand correctly.
>> As fc_block_rport cannot take arg of scsi_cmd can we add it as part of
>> fc_block_scsi_eh ?
> >
>>Ah, right.
>>Actually I meant 'fc_remote_port_chkready()'.
>>That doesnt' take an scmd as argument, but I don't see why we can't modify
>>it to have an additonal 'sdev' parameter...

fc_remote_port_chkready function is even getting called in slave alloc
(lpfc_slave_alloc, qla2xxx_slave_alloc,...)  and few ELS initiative
functions
bnx2fc_initiate_els, qedf_initiate_els.. where scsi_cmnd cannot be passed.
In these cases we need to pass NULL for scsi_cmnd ?

Regards,
Muneendra.

--000000000000e4453205b0983b1c
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
BCC9l7ZrF5OeDQ2cFUTVGkhRzbMPFMFwoaUGn4VKARu2lTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
AQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMDEwODU5MjlaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEK
MAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAxtF/1L3xvqNpFCmI
G0XHnYEictx69ZsHfI4SwXZcjHYpyRYhxc+Ux9MeTSkuHoV3tVKtDt7YKVxTOdlE3cdqu8ITH6Bt
BRS6RFmjjFwYwQ7iOHIvqcD7aFYzhP3RUt79NMXqvFiZXvRHCLk8eC3yfELHcjy7QIIqjiu6pcdu
Fn8Q2k8/wYoivI5Hc0rTABy3eu92fLFjaBdbBmiWWWzmdiwFeJ7144dTYKsRx6yOOZ8lI4UgToi5
CbR7mqas0S65uepTJzdt5XHbBGn4lzfXhB8nd/MvIzELCVjrQy9bkuu3/i71OgfiY8a2jaOIOgE5
aIMdAYPBFlrOEQ9Ray49ig==
--000000000000e4453205b0983b1c--
