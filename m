Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61E8C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 12:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1FE61289
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 12:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbhDLME6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 08:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240812AbhDLMEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Apr 2021 08:04:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14860C061574
        for <linux-scsi@vger.kernel.org>; Mon, 12 Apr 2021 05:04:35 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b8-20020a17090a5508b029014d0fbe9b64so8685274pji.5
        for <linux-scsi@vger.kernel.org>; Mon, 12 Apr 2021 05:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sStEFZXPbZqMGfM+TUbBpoeyAdNzle4ofdrOHJV1q3c=;
        b=RNLw84rV30HTqYulIt9/n+fYb7/NGwouW3wjpEa4E06XwcR23hoRDRWb/rabvcydKl
         6oqvJCldAD2GTS5eoNMglSksbLBadegwAj2KILl5xn/lpieeJoRS96jugXq2/NKe+aEU
         E2rlOXObr4cNtKO4UTtdmlhwL9xR/F2StzJO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sStEFZXPbZqMGfM+TUbBpoeyAdNzle4ofdrOHJV1q3c=;
        b=ah/2LzYjYg7Df5+OUc+OUt6OA6KNspbZgtBc5JBPYS4rgV49zF2GtpFFiXll+ukXBY
         WqH1LWKoq6kHlpqoe4EZZmtXMJTNOqXdVKRVahcY9jjUCc6lTyQ01y7S4I0sTg3Icgat
         3K6tDpqclQZ3mhxilt3ofCdaNtq/oCCHP+nUqdGquKWRHTqCnR4LHXvhbYw9XeTFNCFx
         neXmtCrT8qv5BzImZywOxxKmYOJvjkLuIygjYP+M4lbvAU5KXBTWL99cFS7pGQb5ZiWC
         u0x2ur1BJOMSELsJciiS3nFIQRaJSorPQKNBPTh8vdJf1B6OhzsBC0y07D/9iRqk+J64
         n4/A==
X-Gm-Message-State: AOAM531/e90JjsKoTHf7R+gzsJE9sYGdlpiz4WXpy4iq2toHBSKAq/3g
        pEg+HIBOFrZB+VTDo6k0lmiwStOXj70JpmuzwOIdPA==
X-Google-Smtp-Source: ABdhPJzqOK2buaHg5cnCujOEvKl/T+nvJvChJe8GGXe+gN+nfQnCZuknyDbXdQ/1avwvBB2uNcO4upEKUvzUr3h/Bfs=
X-Received: by 2002:a17:902:8601:b029:e6:7b87:8add with SMTP id
 f1-20020a1709028601b02900e67b878addmr26206710plo.3.1618229074400; Mon, 12 Apr
 2021 05:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <ce228d78-8651-d958-d1e5-2f82cbb8113d@qubes-os.org>
 <c751b535d69b892fee0af8f43cfcce60@mail.gmail.com> <12383f2a-9f7b-ea95-ff52-785b91c1bac8@qubes-os.org>
 <2ef99260-c5ee-f42d-c06e-e37b22ff443d@qubes-os.org>
In-Reply-To: <2ef99260-c5ee-f42d-c06e-e37b22ff443d@qubes-os.org>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Mon, 12 Apr 2021 17:34:08 +0530
Message-ID: <CAL2rwxo9rM+Tcc8_kQ2U9Kxp3mJfFFK0V7ACdrV_4cgZ1YnBVw@mail.gmail.com>
Subject: Re: MegaRaid SAS 9341-8i issue
To:     =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= 
        <frederic.pierret@qubes-os.org>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002c380a05bfc55138"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000002c380a05bfc55138
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 9, 2021 at 11:55 AM Fr=C3=A9d=C3=A9ric Pierret
<frederic.pierret@qubes-os.org> wrote:
>
> Hi,
>
> Le 3/29/21 =C3=A0 11:02 AM, Fr=C3=A9d=C3=A9ric Pierret a =C3=A9crit :
> > Hi,
> > First of all, thank you very much for your answer.
> >
> > Le 3/29/21 =C3=A0 8:24 AM, Kashyap Desai a =C3=A9crit :
> >> Hi -
> >>
> >> Can you send us full dmesg logs of each working and non-working case. =
?
> >
> > I've attached you the working case of one of the two motherboard, refer=
enced here as ASUS, and the nonworking case on the third motherboard, refer=
enced here as ASROCK. In both cases, I've attached you the full dmesg of th=
e same LiveUSB a Fedora 33 with also the full dmesg when I do a rmmod and m=
odprobe of megaraid_sas.
> >
> >> On 3rd motherboard was it any working combination of kernel, driver an=
d FW ?
> >> OR it never worked on 3rd mother board ?
> >
> > Unfortunately, no combination has worked on the ASROCK (third motherboa=
rd) (before or after firmware upgrade, multiple kernel versions (5.10.X and=
 5.11.Y), drivers)
> >
> >> Kashyap
> >>
> >>> -----Original Message-----
> >>> From: Fr=C3=A9d=C3=A9ric Pierret [mailto:frederic.pierret@qubes-os.or=
g]
> >>> Sent: Sunday, March 28, 2021 10:26 PM
> >>> To: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> >>> shivasharan.srikanteshwara@broadcom.com; jejb@linux.ibm.com;
> >>> martin.petersen@oracle.com
> >>> Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
> >>> Subject: MegaRaid SAS 9341-8i issue
> >>>
> >>> Hi,
> >>>
> >>> I'm having issue with a MegaRaid 9341-8i card which is properly worki=
ng on
> >>> two motherboards (kernel-5.10.25 and kernel-5.11.10) but not on a thi=
rd
> >>> for
> >>> which I want it to work. I originally received this card with a firmw=
are
> >>> from
> >>> 2018 and I've updated it to the latest from Broadcom website
> >>> (24.21.0-0148)
> >>> but in both cases, I've the same issue on the third motherboard:
> >>>
> >>> [   14.013135] megaraid_sas 0000:01:00.0: BAR:0x1  BAR's
> >>> base_addr(phys):0x00000000fe800000  mapped virt_addr:0x(ptrval)
> >>> [   14.013142] megaraid_sas 0000:01:00.0: FW now in Ready state
> >>> [   14.013148] megaraid_sas 0000:01:00.0: 63 bit DMA mask and 32 bit
> >>> consistent mask
> >>> [   14.013933] megaraid_sas 0000:01:00.0: firmware supports msix     =
   :
> >>> (96)
> >>> [   14.014439] megaraid_sas 0000:01:00.0: requested/available msix 5/=
5
> >>> [   14.014445] megaraid_sas 0000:01:00.0: current msix/online cpus   =
   :
> >>> (5/4)
> >>> [   14.014447] megaraid_sas 0000:01:00.0: RDPQ mode     : (disabled)
> >>> [   14.014453] megaraid_sas 0000:01:00.0: Current firmware supports
> >>> maximum commands: 272        LDIO threshold: 237
> >>> [   14.014631] megaraid_sas 0000:01:00.0: Configured max firmware
> >>> commands: 271
> >>> [   14.015377] megaraid_sas 0000:01:00.0: Performance mode :Latency
> >>> [   14.015380] megaraid_sas 0000:01:00.0: FW supports sync cache     =
   :
> >>> Yes
> >>> [   14.015388] megaraid_sas 0000:01:00.0: megasas_disable_intr_fusion=
 is
> >>> called outbound_intr_mask:0x40000009
> >>> [   14.037098] megaraid_sas 0000:01:00.0: Init cmd return status FAIL=
ED
> >>> for
> >>> SCSI host 2
> >>> [   14.037762] megaraid_sas 0000:01:00.0: Failed from megasas_init_fw=
 6399
> >>>
> >>> Trying to rmmod then modprobe leads to something that looks like stuc=
k
> >>> state or such:
> >>>
> >>> [  570.269770] megaraid_sas 0000:01:00.0: BAR:0x1  BAR's
> >>> base_addr(phys):0x00000000fe800000  mapped
> >>> virt_addr:0x00000000f42ba0e1 [  570.269775] megaraid_sas 0000:01:00.0=
:
> >>> Waiting for FW to come to ready state [  570.269780] megaraid_sas
> >>> 0000:01:00.0: FW in FAULT state, Fault code:0x10000 subcode:0x0
> >>> func:megasas_transition_to_ready [  570.269782] megaraid_sas
> >>> 0000:01:00.0: System Register set:
> >>> (***)
> >>> [  570.269908] megaraid_sas 0000:01:00.0: Failed to transition contro=
ller
> >>> to
> >>> ready from megasas_init_fw!
> >>> [  570.269919] megaraid_sas 0000:01:00.0: Failed from megasas_init_fw=
 639
> >>>
> >>> The motherboard which is not working is a recent one: Asrock X570D4U-=
2L2T
> >>> with a Ryzen 3900XT.
> >>>
> >>> I've read a lot of things on internet saying that might be CSM issues=
 or
> >>> such
> >>> but no luck with that. On the two working motherboards, it works in
> >>> legacy/UEFI only. I've also tested the card on a x16 or x8 slots, the=
 same
> >>> result. I've attempted to build megaraid driver provided from Broadco=
m
> >>> (07.716.01.00-2). Up to a slight adjustment in a log call using older
> >>> attribute
> >>> "host_busy", I'm hitting an unrelated issue due to KBUILD_CFLAGS recu=
rsion
> >>> in arch/x86/Makefile.
> >>>
> >>> After hours and hours of testing, I'm currently out of ideas. Does an=
yone
> >>> has
> >>> an idea or could help me into adding useful debug info in the driver =
or
> >>> such?
> >>>
> >>> Thank very much in advance,
> >>> Fr=C3=A9d=C3=A9ric
> >
> > Best regards,
> > Fr=C3=A9d=C3=A9ric
>
> Is there something more I could provide and help into troubleshooting thi=
s issue?
First time driver load fails due to IOC INIT failure(writeq API is
used to fire IOC INIT to firmware).
We have seen writeq does not work on a few platforms.
Please try if below change fixes your issue:

diff --git a/megaraid_sas_fusion.c b/megaraid_sas_fusion.c
index 432a0bb..24ef592 100644
--- a/megaraid_sas_fusion.c
+++ b/megaraid_sas_fusion.c
@@ -291,7 +293,8 @@ static void
 megasas_write_64bit_req_desc(struct megasas_instance *instance,
  union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
 {
-#if defined(writeq) && defined(CONFIG_64BIT)
+//#if defined(writeq) && defined(CONFIG_64BIT)
+#if 0
  u64 req_data =3D (((u64)le32_to_cpu(req_desc->u.high) << 32) |
  le32_to_cpu(req_desc->u.low));
  writeq(req_data, &instance->reg_set->inbound_low_queue_port)

Thanks,
Sumit
>
> Best regards,
> Fr=C3=A9d=C3=A9ric
>

--0000000000002c380a05bfc55138
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGYQEk28cv93KdNZT0aDo5tHCPXtfeb4
YZOte4lLOmgGMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQx
MjEyMDQzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAqZ0/0k+sBJH1+t+x3KXYKAROY0jnWT92WQRDQEaLqLGtQSzOx
s31+p+x/dJrpV5/i01uEHzygULlOHbXmvh7DgwXck/+HtTkwVv2VEhM2bFtVUxhxZ509OEFH7ByX
9Azs/WbN1ufjNu8/IIDYvDm7nEA24N+Y216hgZMI0aI71vWGTFTlcZoZSH0X82q6n0tEs7tQae9R
20dWPgaxgYa52m94i7p8ZnB9I0wKRp56fHVoLNFXS1RDS1svkH+dM3KaOMUbpdmwt6st8HtrWa7K
3zvFbdtexAbH6onoepopBy8VISvtTjbVbN8Y9JBkkmtJwElIirCoXhVRzS68/DZq
--0000000000002c380a05bfc55138--
