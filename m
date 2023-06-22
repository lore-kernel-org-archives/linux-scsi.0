Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9E6EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jun 2023 15:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbjFVP3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jun 2023 11:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjFVP2N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jun 2023 11:28:13 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E9F2942
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2023 08:27:25 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-7623bd6933eso36022585a.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2023 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1687447628; x=1690039628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bDCNh8geGpiLLABlfUpnCapEb2RGdI+nGqJOj6YdEuY=;
        b=hu2eVZYIydEq96Y7GkbWkTsf4ouSxtUv3+/uBsVKMoQxo9r1MqVqsjeAwOj8iaej3R
         xN3MbislDSliIhspDm1aKLJbpGdU2HVBOPSRxMABNy6Kq8T8yZn+429E4xndW3LSWSf5
         W4Dye6jaGAsf/uS3kZpl9aQF9hFx8qp2w2Pnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687447628; x=1690039628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bDCNh8geGpiLLABlfUpnCapEb2RGdI+nGqJOj6YdEuY=;
        b=ktFiYd+yMbZr9TZoqo8ZzwSjGlr5fA9C4YWHTCYk33ais57glf2pI4KVhthgbBaMvs
         F+Cm3xT30M7pncU27wUEjgqqlDTvIBzpcQaiGuHoDcBDy8EPBH2B7K5hLBfvhg8y9k8W
         3YNcAGv9430xv5GgDMajT/GRUxKNa+yS7TQt45VHt/vsJkVncR7BN3AAoYPxaiDOLYRa
         0NVyIEB/w9wFkwsnmTD7t+IZ0OspoTgHhFcsROuUcaX2il2qR4/sgo7ikwVBAPW88vMU
         wDF61iS2knVMNv3uSpLvjAJ1Z91rW7W5aX07OC/Gw7+gUDvI5WMhk2tDWraSVNjluvp9
         ecrg==
X-Gm-Message-State: AC+VfDzYNOqpy9tsWOfdfhtSu1J4wq1u8YdCO0q+DbPQQh7QmiF+EJnJ
        Uz9tEZZPQ4LaqAi/F1ueNhuCTIuayziazgF0+2Sl+3fS3nyQaMvWQs+TCj3cqYKLZlT6Unjss/j
        VGhAZDHkyAQrnf+Xbsm6A1f4OfUc=
X-Google-Smtp-Source: ACHHUZ55a1SJ4+EEPMB75IR5xHdS1wxBbxhEJz7h6yVgFip/y2DBAs1MpGeDQ4NDz+gOPu7KLxoZnIGDEYU12Sl/vMk=
X-Received: by 2002:a05:6214:20cc:b0:5dd:b986:b44 with SMTP id
 12-20020a05621420cc00b005ddb9860b44mr22822216qve.6.1687447628081; Thu, 22 Jun
 2023 08:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230615083010.45837-1-ranjan.kumar@broadcom.com> <2023061538-dizzy-amiable-9ec7@gregkh>
In-Reply-To: <2023061538-dizzy-amiable-9ec7@gregkh>
From:   Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date:   Thu, 22 Jun 2023 09:26:50 -0600
Message-ID: <CAFdVvOwjQZZnViCYbJqPC81ZJPsZdqjNuQE=dH4bHWD4Pyu7Ew@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: Perform additional retries if Doorbell read
 returns 0
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sreekanth.reddy@broadcom.com, stable@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000077fc3405feb984fa"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000077fc3405feb984fa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 15, 2023 at 2:47=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Thu, Jun 15, 2023 at 02:00:10PM +0530, Ranjan Kumar wrote:
> > Doorbell and Host diagnostic registers could return 0 even
> > after 3 retries and that leads to occasional resets of the
> > controllers, hence increased the retry count to thirty.
> >
> > 'Fixes: b899202901a8 ("mpt3sas: Add separate function for aero doorbell=
 reads ")'
>
> No ' characters here please.
>
> > Cc: stable@vger.kernel.org
> >
> > Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
>
> No blank line before the signed-off-by and the other fields please.
>
> Didn't checkpatch warn you about this?
>
> > ---
> >  drivers/scsi/mpt3sas/mpt3sas_base.c | 50 ++++++++++++++++-------------
> >  drivers/scsi/mpt3sas/mpt3sas_base.h |  4 ++-
> >  2 files changed, 31 insertions(+), 23 deletions(-)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas=
/mpt3sas_base.c
> > index 53f5492579cb..44e7ccb6f780 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> > @@ -201,20 +201,20 @@ module_param_call(mpt3sas_fwfault_debug, _scsih_s=
et_fwfault_debug,
> >   * while reading the system interface register.
> >   */
> >  static inline u32
> > -_base_readl_aero(const volatile void __iomem *addr)
> > +_base_readl_aero(const volatile void __iomem *addr, u8 retry_count)
>
> Are you sure that volatile really does what you think it does here?
>
>
Greg,  the volatile definition is present for a long time and we don't
want to change it in this patch, we will review and see whether we can
remove it later.

> >  {
> >       u32 i =3D 0, ret_val;
> >
> >       do {
> >               ret_val =3D readl(addr);
> >               i++;
> > -     } while (ret_val =3D=3D 0 && i < 3);
> > +     } while (ret_val =3D=3D 0 && i < retry_count);
>
> So newer systems will complete this failure loop faster than older ones?
> That feels very wrong, you will be changing this in a year or so.  Use
> time please, not counts.
>
This is nothing to do with the system speed, this is our hardware
specific behavior and we are confident that the increased retry count
is sufficient from our hardware perspective for any new systems too.

> thanks,
>
> greg k-h

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--00000000000077fc3405feb984fa
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
v82E+npLwqC8bSHh1m6BJewfpawx72uKM9aFs6SVpLPtN6a5369OCwVeEwkk2FeFU9tZXWBnI4Wu
d1Q4a3vhOColD6PdTWv74Ez2I3ahCkmpeEQ1YMt61TUH3W8NUJJeYN2xkR6OGsA1AgMBAAGjggHc
MIIB2DAOBgNVHQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRw
Oi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcnQwQQYIKwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJz
b25hbHNpZ24yY2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZo
dHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRC
MEAwPqA8oDqGOGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3JsMCYGA1UdEQQfMB2BG3NhdGh5YS5wcmFrYXNoQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
VyBc/F5XGkYNCP9Rb96mru8lU4AwDQYJKoZIhvcNAQELBQADggEBACiysbqj0ggjcc9uzOpBkt1Q
nGtvHhd9pbNmshJRUoNL11pQEzupSsUkDoAa6hPrOaJVobIO+yC84D4GXQc13Jk0QZQhRJJRYLwk
vdq704JPh4ULIwofTWqwsiZ1OvINzX9h9KEw/+h+Mc3YUCO7tvKBGLJTUaUhrjxyjLQdEK1Xp/8B
kYd5quZssxYPJ3nl37Moy/U9ZM2F0Ivv4U3wyP5y5cdmBUBAGOd94rH60fVDVogEo5F9gXrZhT/4
jKzCG3LclOOzLinCkK2J5GYngIUHSmnqk909QPG6jkx5RJWwkpTzm+AAVbJ9a+1F/8iR3FiDddEK
8wQJuWG84jqd/9wxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPnbKpsW
EPqioC0IKwB08mpzIynemiI9GXgnzBFhK8YKMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIzMDYyMjE1MjcwOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQChLBICJ2v7MQMMz0jFiCWpLUgR
0gY6WrqoFnQnnp0IZCdZ1aqjZC74EdBaH4dGwbNlXyZ8YcuOCN8ni25PgPO1c3bjkxevbjj6hdkX
WrY8U1sf5kmUrBlgCSh8gy45QGUhstALgIfGY76QFYvTbt1NIdxH+B9gvgeIRu+laMUfDMn0oYED
jIDb2ozkfK3zt5FPZc6ZI4ThAOqgcWDvpqGnQNzIjUo/jjLU+WIewpyKk30mpCXNWDpJcFEh3vA7
Aj5GCsixazw5cI1ZUIC7/WHlt3z+jV/ZNaL3gMv4KZ7s9iiVf+vjXAcJR98PcNmx+LNnxB4lyxZE
MkJj/ZpHEEuT
--00000000000077fc3405feb984fa--
