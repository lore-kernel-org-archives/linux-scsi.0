Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D499FC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 18:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82DE22BF3
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 18:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732952AbgLISvS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 13:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387488AbgLISvN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 13:51:13 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856CBC0613D6
        for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2020 10:50:32 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id z20so1719141qtq.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Dec 2020 10:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=EOMfAPCFkCJqLO/45K3nLUQCjHjoQib5nDs+k5/Hocc=;
        b=Msx5phT3K10WJRyky6w+0Z/QfgtVuS0MQnGUeR4iMPluXE6d1ljYIb4reg1sbAx7zv
         r+iTz2n2VzZpwv8VJneNMUAh0cWc4BNlpLbhGjYpU5rn+BHUIRusnSfETJUGl0tEVrF/
         /9rXQMDgpGqpu4xQHqbLFaOrI+/tpNLZXBoKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=EOMfAPCFkCJqLO/45K3nLUQCjHjoQib5nDs+k5/Hocc=;
        b=YvoNiOLvOA/cIJLp/6n4dFrBfrz6+pYFy76uij/YvDvoeF+K7ZGc+dyZ6E0blvnGUJ
         kQUx6O3qjBuxIOcnl/qVTFQOIXtMZnj1LSWdWY+Usfe3iDBFglL7yvFXwl9eiHaWQf6i
         H8T8dVx9ckchbwIsVwc+aT7xU79UqQ8JlwoEcNdp/cSovdyakZzNscKYSK5/bc6V/NxF
         4woqllpZb27PRTU4NzuWU5Lzcox7KCJUHpBCKlz6yUJKA+AnJc1xqkgFCwkNl7MTJB+I
         JVmbg15bVYb7yzyefSE0Zwm1ajCVjvch5JwNLgfyy8XK8dNCUVBopYRmJXRwA7uaknEA
         zCuw==
X-Gm-Message-State: AOAM532+jQmz806dfc3vbZDCuYEWXSgX4Usr1T/DNXKrWub4qsSevMx8
        To50YQvRz/EjyCu1BMRfK5umfujiNROse2YIIyuMNBSBU2EKve2U4HF6QA9hrg+dfhA77rnsWI+
        CSjc6LOsRedzS7jAoPdHAJxiWuA1u
X-Google-Smtp-Source: ABdhPJxznWaweuBKS+UFe3/I37lFLUY2TxYcaKG1eDoXi6iWhnYjZhSitLNwznMWnhJH2goMisn7J5UeIJtKO6Bj/dI=
X-Received: by 2002:ac8:5514:: with SMTP id j20mr4751899qtq.387.1607539831003;
 Wed, 09 Dec 2020 10:50:31 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
 <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
 <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com> <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
 <9106e994-bb4b-4148-1280-f08f71427420@huawei.com> <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
 <alpine.DEB.2.22.394.2012082339470.16458@hadrien> <yq1sg8fud7y.fsf@ca-mkp.ca.oracle.com>
 <4f3cd4d4-87d3-dc9a-027d-293cba469d5a@huawei.com> <alpine.DEB.2.22.394.2012091644010.2691@hadrien>
 <db450cdf-f411-c0ed-d2ce-60283dacfd06@huawei.com>
In-Reply-To: <db450cdf-f411-c0ed-d2ce-60283dacfd06@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQI6im7hpQs4L8XyrGxklOx9XNwlawEJJlS/AkXit50CG832ogGicv5tAVdX1GsBilpIZgLev9eeAkuQtKwBMI3SnQEjoLAFqJw2qBA=
Date:   Thu, 10 Dec 2020 00:20:27 +0530
Message-ID: <8c02bc953eee2a0300caf1278a58d04e@mail.gmail.com>
Subject: RE: problem booting 5.10
To:     John Garry <john.garry@huawei.com>,
        Julia Lawall <julia.lawall@inria.fr>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009d2f9b05b60c8876"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000009d2f9b05b60c8876
Content-Type: text/plain; charset="UTF-8"

> -----Original Message-----
> From: John Garry [mailto:john.garry@huawei.com]
> Sent: Wednesday, December 9, 2020 9:22 PM
> To: Julia Lawall <julia.lawall@inria.fr>; Kashyap Desai
> <kashyap.desai@broadcom.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>; Linus Torvalds
> <torvalds@linux-foundation.org>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>; nicolas.palix@univ-grenoble-alpes.fr; linux-scsi
> <linux-scsi@vger.kernel.org>; Ming Lei <ming.lei@redhat.com>; Sumit Saxena
> <sumit.saxena@broadcom.com>; Shivasharan S
> <shivasharan.srikanteshwara@broadcom.com>
> Subject: Re: problem booting 5.10
>
> On 09/12/2020 15:44, Julia Lawall wrote:
> >
> > On Tue, 8 Dec 2020, John Garry wrote:
> >
> >> On 08/12/2020 22:51, Martin K. Petersen wrote:
> >>> Julia,
> >>>
> >>>> This solves the problem.  Starting from 5.10-rc7 and doing this
> >>>> revert, I get a kernel that boots.
> >> Hi Julia,
> >>
> >> Can you also please test Ming's patchset here (without the megaraid
> >> sas
> >> revert) when you get a chance:
> >> https://lore.kernel.org/linux-block/20201203012638.543321-1-ming.lei@
> >> redhat.com/
> > 5.10-rc7 plus these three commits boots fine.
> >
>
> Hi Julia,
>
> Ok, Thanks for the confirmation. A sort of relief.
>
> @Kashyap, It would be good if we could recreate this, just in case.

I already tested series and issue fixed for me. Final patch (V2) provided by
Ming already has "Tested-by" Tag from me.
I once again confirm using config file provided by Julia Lawall and same
result - Issue recreated once again and fixed by Ming's below patch.

https://lore.kernel.org/linux-block/20201203012638.543321-2-ming.lei@redhat.com/

Kashyap

>
> Cheers,
> John

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--0000000000009d2f9b05b60c8876
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgw/BEdvjD
7iiZZWBRRZg2MBLKK9AsJFHTi4K14LKxXmkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjA5MTg1MDMxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBACbUdgVG1+HXmaNx2Tqw/59X9wd2
qu9xSanm5ADt4siYpmMZIGwsWF4dDeoh3S2wQa/S5MwZ3lpTLVlQzIQMczzsdrv2UmT0t6ai+6A6
zSEYoE0Hb4is7OLRbN4foYBa7PUnwtJew7GenBCMJ2K7W288m/bCyGer/5TmU2z8xHBWhsBFzJvH
vZJrA/Vu+pB/1I7ke7ztkPC/CVmrOxxV5hy8aT73RkRseBK3p010xKAtCIiHidWz24d0IfWPVefN
6VS9SfU9YS3QwRRF7vlGXdpCXXqvEHK07M7jBp9K/nExxsu2BTVwamlMNNVtAUiVEaVeooU9lQHr
Q4/tPSHuTp0=
--0000000000009d2f9b05b60c8876--
