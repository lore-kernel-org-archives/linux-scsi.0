Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69809C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 20:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiKJUXU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 15:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKJUXS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 15:23:18 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8214023A
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 12:23:17 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id d6so5248313lfs.10
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 12:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4+uF/Bhs23qxvjY6C4l36r5Yq97IdiM5YBsRw4ts8f8=;
        b=dDZKtoWApypoMQ5lttN8DlyBf3WLdZLCZLOnT91PP0XtI55mRHRo3JDI9PpdrWzfoJ
         VupB9Wu6iD1s4N0IOOoLK+VK/kJaYTzw9cbdrhG/KQtQ/kzWH3GWkEkYUobRcOSI53mZ
         HUHGjoyuJwA/hDJDF3AlEvWXgjoC4HawOe1JM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+uF/Bhs23qxvjY6C4l36r5Yq97IdiM5YBsRw4ts8f8=;
        b=2T2zojEloRzy6aQwZ4qJTZ/3oT7IFG/GRksPLztZSaoel2b76z7l8COpVRE+ODdW4a
         1aQDK5lCi9VKhdJPDpALPneHR/O9MMQoYyNfEqIdICtbKWE7kG3FX4ZlLpOtSHhsvePZ
         8Dr2DfAX6PS/LjAqHOxtjQ2JTLGrA7PYi3GNL0Wt25VLaWCdbGgU70mmOvlYM8TAj+or
         3tsdya+f1F30LaDzNhE/oY7PhZhwpOgjlLn6dwBUPqK4VPy9DVhF6NsCEU8rZw6MBLNb
         C/llac5YCsvs96+YGDNP0KdTKdYBdGjbkUWubca+4ukrxgd+fAcxjucZET2MiR226Kre
         q/Dw==
X-Gm-Message-State: ACrzQf1RZtONIXiRHsoDVqrgxBnJXSV1aIadxuGimnixGaAm/a2jY9Qf
        /aVUQbB3h+9PjiM8I9pMPjkf995YT52Y9/ad/+1okpQ2lL1itL/o6WtktyWsHOX0+TW6rU7fd5W
        dE8ipBL7fQ+pFRydPuSn0PxT2VcE=
X-Google-Smtp-Source: AMsMyM5Sjl9XA1qPYBt6hCDgldb1rq8zL3mhPqKS5SISVhT2LdDhEKevVT+lxCkJ4VDBOgf1Gpv60ofu89KGUq5XNDQ=
X-Received: by 2002:ac2:4ec2:0:b0:4b0:efed:e3a7 with SMTP id
 p2-20020ac24ec2000000b004b0efede3a7mr1911870lfr.323.1668111795642; Thu, 10
 Nov 2022 12:23:15 -0800 (PST)
MIME-Version: 1.0
References: <20221109031207.1605138-1-shinichiro.kawasaki@wdc.com> <e4824691-aa3c-d054-eab9-679f83fa9c67@opensource.wdc.com>
In-Reply-To: <e4824691-aa3c-d054-eab9-679f83fa9c67@opensource.wdc.com>
From:   Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date:   Thu, 10 Nov 2022 13:22:57 -0700
Message-ID: <CAFdVvOxxJZiXe74jB3T-=HjJ8Bb=O3baHbjueo9r3adsATQeGg@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpi3mr: suppress command reply debug prints
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000c7ed805ed238b54"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000000c7ed805ed238b54
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 8, 2022 at 10:22 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> On 11/9/22 12:12, Shin'ichiro Kawasaki wrote:
> > After it receives command reply, mpi3mr driver checks command result. If
> > the result is not zero, it prints out command information. This debug
> > information is confusing since they are printed even when the non-zero
> > result is expected. "Power-on or device reset occurred" is printed for
> > Test Unit Ready command at drive detection. Inquiry failure for
> > unsupported VPD page header is also printed. They are harmless but look
> > like failures.
> >
> > To avoid the confusion, print the command reply debug information only
> > when the module parameter logging_level has value MPI3_DEBUG_REPLY=128,
> > in same manner as mpt3sas driver.
> >
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  drivers/scsi/mpi3mr/mpi3mr_os.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > index f77ee4051b00..2b95d1d375f2 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -3265,7 +3265,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
> >       }
> >
> >       if (scmd->result != (DID_OK << 16) && (scmd->cmnd[0] != ATA_12) &&
> > -         (scmd->cmnd[0] != ATA_16)) {
> > +         (scmd->cmnd[0] != ATA_16) &&
> > +         mrioc->logging_level & MPI3_DEBUG_REPLY) {

>>> Thanks for fixing this, Can you please use MPI3_DEBUG_SCSI_ERROR instead of MPI3_DEBUG_REPLY as that makes more sense.

> >               ioc_info(mrioc, "%s :scmd->result 0x%x\n", __func__,
> >                   scmd->result);
> >               scsi_print_command(scmd);
>
> Looks OK.
>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>
> --
> Damien Le Moal
> Western Digital Research
>

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

--0000000000000c7ed805ed238b54
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
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMTY18iH
MikYZDcJ8mdJrEBBn4XjKX3GGLmXWem+jrRFMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIyMTExMDIwMjMxNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBErfUbaJbNR1kGwJ21ihyFxlBU
RPmQ7KqrfFR7tXoXxCuQS7TOttUNNW+jlCxdHUZhNsxLpTn9z487Ob7TV0KYZOHM+Qb63H7XnUdc
nCqfr5tQie7AVNhYne1cejAJk4BAeD72aX1Hn2P/w6Zi8Ft6/kSuUfk8lz18/pVccuevoURc/ME9
rINFlfIP1a7Ox2jttYMvnkOBTKzZbEBR8PRatB9Ss1E/HuTmZReWcjLJE7wxYXBlil7dBrbjBbCm
yWlTBkOCGp9I2+4S4mUBpoMCFHS2w76C8f8ipysRLVVcggP2OtjgjdaRsTABFbtQuoYcP42LH2pj
6bYbAZEYzJc6
--0000000000000c7ed805ed238b54--
