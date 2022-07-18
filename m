Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C72C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 09:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiGRJsW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 05:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbiGRJsV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 05:48:21 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738A21ADB6
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 02:48:20 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-10cf9f5b500so21178480fac.2
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 02:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+L1rkRQaOuQYcHcjOyifCg8nVcfu+2h+xjHYtVgDbqs=;
        b=ZGGq5jVhTao3b6qP6r66Wze0gcfAQQ8TlI0+BOo0JsRHaLfdM0MojUQ6wt3q/c8cU+
         Dn3Z0/VtYj9/4jfm5lJ9sGfGXBc6TMPIcntI5CaGcc3nivm/XF3cTSCmPRiwVf/7bH8V
         qz8xlyzKT6tnBxhAW2gIYd95drSuEYLiJKdfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+L1rkRQaOuQYcHcjOyifCg8nVcfu+2h+xjHYtVgDbqs=;
        b=fotpkq7EFkt1xUS6Cth5+AAVMMADS9S2oHwsSFJEegIxgi3nEsAEv0uqXq5j0pY2Ep
         mn008PmA61aNDM+864jeCLaGQfUzIrURTTK0iv8VxINvPobhXCftZomVFdKHD5zv8SBE
         fVW+uYpSW2hbqdbOTy2YvruE5AsKXPlIj2f4ogIa61qvuPq1KHKzKESGrt0DRloFPHD/
         yTNNaulny5SELKeOj42mapA+B686AeaTEBd5P0djfh90EQ8Gdj9SXeAvGf50XRtdPu5R
         zmkYoIoQQDyBMfvkXKDTh8uUWesIDwRhFRjtAHbLAuQO+Y0BqT4Kx2cU0mkVxophVlKb
         w3dw==
X-Gm-Message-State: AJIora8GvW9rOAGzz3le07LBusmklQf0Vk7UE9xFi9z65EwBJtRe4Bzr
        WmCk0ooD3D/LUsgdJGrkjLX1vSvgSzApgDw+GWQqA/sH8U9wUGCp
X-Google-Smtp-Source: AGRyM1uvUwDzIzbxV0alZkrOAS4DaemGhV+WwLZjkbCVE/0nIX/QZqwGu1gs2cvsh3rMyRTOMjPJKLktWxP47glGrTM=
X-Received: by 2002:a05:6870:8308:b0:10c:2b7d:4f19 with SMTP id
 p8-20020a056870830800b0010c2b7d4f19mr13943525oae.234.1658137699575; Mon, 18
 Jul 2022 02:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220715150219.16875-1-sreekanth.reddy@broadcom.com>
 <20220715150219.16875-2-sreekanth.reddy@broadcom.com> <3a869ecf-bd82-2e72-2ec9-7b67a20c2d63@roeck-us.net>
 <CAK=zhgogTnOgCwGytaay3fBJjuj1aw4ssOp-=nG75-2a-k3gkA@mail.gmail.com> <0cd50038-4988-0a6e-1bae-a82edde962b9@roeck-us.net>
In-Reply-To: <0cd50038-4988-0a6e-1bae-a82edde962b9@roeck-us.net>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Mon, 18 Jul 2022 15:18:08 +0530
Message-ID: <CAK=zhgrnU1du6x+Zv5C2QqW6fqDRyoKcunYLm7WT+vPdfyr_ug@mail.gmail.com>
Subject: Re: [PATCH 1/1] mpi3mr: Fix compilation errors observed on i386 arch
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000098cb8a05e4114478"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000098cb8a05e4114478
Content-Type: text/plain; charset="UTF-8"

On Sat, Jul 16, 2022 at 7:34 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 7/16/22 06:35, Sreekanth Reddy wrote:
> > Hi Guenter,
> >
> > Please check the changes below. I hope this change will work with
> > 32-bit pointers as well.  If it looks good then I will post this
> > change as a patch.
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > index 0901bc932d5c..0bba19c0f984 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct
> > mpi3mr_ioc *mrioc,
> >                  ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
> >                  return;
> >          }
> > -       *(__le64 *)fwevt->event_data = (__le64)tg;
> > +       memcpy(fwevt->event_data, (char *)&tg, sizeof(void *)); >          fwevt->mrioc = mrioc;
> >          fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
> >          fwevt->send_ack = 0;
> > @@ -1660,8 +1660,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
> >          {
> >                  struct mpi3mr_throttle_group_info *tg;
> >
> > -               tg = (struct mpi3mr_throttle_group_info *)
> > -                   (*(__le64 *)fwevt->event_data);
> > +               memcpy((char *)&tg, fwevt->event_data, sizeof(void *));
> >                  dprint_event_bh(mrioc,
> >                      "qd reduction event processed for tg_id(%d)
> > reduction_needed(%d)\n",
> >                      tg->id, tg->need_qd_reduction);
> >
>
> If I understand correctly, you want to pass the pointer to tg along. If so,
> the following seems cleaner and less confusing to me.

Yes, it is correct. I have posted a new patch with your suggested changes below.
https://patchwork.kernel.org/project/linux-scsi/patch/20220718095351.15868-2-sreekanth.reddy@broadcom.com/

Thanks,
Sreekanth

>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 6a47f8c77256..f581c07c2665 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct mpi3mr_ioc *mrioc,
>                  ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
>                  return;
>          }
> -       *(__le64 *)fwevt->event_data = (__le64)tg;
> +       *(struct mpi3mr_throttle_group_info **)fwevt->event_data = tg;
>          fwevt->mrioc = mrioc;
>          fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
>          fwevt->send_ack = 0;
> @@ -1652,8 +1652,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
>          {
>                  struct mpi3mr_throttle_group_info *tg;
>
> -               tg = (struct mpi3mr_throttle_group_info *)
> -                   (*(__le64 *)fwevt->event_data);
> +               tg = *(struct mpi3mr_throttle_group_info **)fwevt->event_data;
>                  dprint_event_bh(mrioc,
>                      "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
>                      tg->id, tg->need_qd_reduction);
>
> or simply
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 6a47f8c77256..cc93b41dd428 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct mpi3mr_ioc *mrioc,
>                  ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
>                  return;
>          }
> -       *(__le64 *)fwevt->event_data = (__le64)tg;
> +       *(void **)fwevt->event_data = tg;
>          fwevt->mrioc = mrioc;
>          fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
>          fwevt->send_ack = 0;
> @@ -1652,8 +1652,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
>          {
>                  struct mpi3mr_throttle_group_info *tg;
>
> -               tg = (struct mpi3mr_throttle_group_info *)
> -                   (*(__le64 *)fwevt->event_data);
> +               tg = *(void **)fwevt->event_data;
>                  dprint_event_bh(mrioc,
>                      "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
>                      tg->id, tg->need_qd_reduction);
>
> Thanks,
> Guenter
>
> > Thanks,
> > Sreekanth
> >
> > On Fri, Jul 15, 2022 at 10:19 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >>
> >> On 7/15/22 08:02, Sreekanth Reddy wrote:
> >>> Fix below compilation errors observed on i386 ARCH,
> >>>
> >>> cast from pointer to integer of different size
> >>> [-Werror=pointer-to-int-cast]
> >>>
> >>> Fixes: c196bc4dce ("scsi: mpi3mr: Reduce VD queue depth on detecting throttling")
> >>> Reported-by: Guenter Roeck <linux@roeck-us.net>
> >>> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> >>> ---
> >>>    drivers/scsi/mpi3mr/mpi3mr_os.c | 5 ++---
> >>>    1 file changed, 2 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> >>> index 0901bc932d5c..d8013576d863 100644
> >>> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> >>> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> >>> @@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct mpi3mr_ioc *mrioc,
> >>>                ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
> >>>                return;
> >>>        }
> >>> -     *(__le64 *)fwevt->event_data = (__le64)tg;
> >>> +     memcpy(fwevt->event_data, (char *)&tg, sizeof(u64));
> >>>        fwevt->mrioc = mrioc;
> >>>        fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
> >>>        fwevt->send_ack = 0;
> >>> @@ -1660,8 +1660,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
> >>>        {
> >>>                struct mpi3mr_throttle_group_info *tg;
> >>>
> >>> -             tg = (struct mpi3mr_throttle_group_info *)
> >>> -                 (*(__le64 *)fwevt->event_data);
> >>> +             memcpy((char *)&tg, fwevt->event_data, sizeof(u64));
> >>
> >> How is this expected to work on a system with 32-bit pointers ?
> >>
> >> Guenter
> >>
> >>>                dprint_event_bh(mrioc,
> >>>                    "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
> >>>                    tg->id, tg->need_qd_reduction);
> >>
>

--00000000000098cb8a05e4114478
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQdgYJKoZIhvcNAQcCoIIQZzCCEGMCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3NMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVUwggQ9oAMCAQICDHJ6qvXSR4uS891jDjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMzAyMTFaFw0yMjA5MTUxMTUxNTZaMIGU
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGDAWBgNVBAMTD1NyZWVrYW50aCBSZWRkeTErMCkGCSqGSIb3
DQEJARYcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAM11a0WXhMRf+z55FvPxVs60RyUZmrtnJOnUab8zTrgbomymXdRB6/75SvK5zuoS
vqbhMdvYrRV5ratysbeHnjsfDV+GJzHuvcv9KuCzInOX8G3rXAa0Ow/iodgTPuiGxulzqKO85XKn
bwqwW9vNSVVW+q/zGg4hpJr4GCywE9qkW7qSYva67acR6vw3nrl2OZpwPjoYDRgUI8QRLxItAgyi
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFahIo+A8A/wqUe7bTxp
VmFvs5dLUYVEDa7UFDCkDC/YMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcxODA5NDgxOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAb8zOagsvRfa7ERwbAJQJ/VI4AQQwL5lI8w7EE
FOMLK35jlaS0L1YjGjvRO8DWzUdt+MdoZIbwMSm6uCZjYFzwmofGKpXiN19SD01ZZW+G2ajr02Q+
y7qS82oJokel/kMNV++03mKzaqlt4vAqTA9P1yf5lQMQA9OiwCu6X5d+DOAjJdqMMxbRm6+s6RpA
b1ZlfEDtuHBLOlkXEfakNAM7K8uRZbYSEr56BtKl6gvuuQgk1YPMLNro1z0DdPwVptbjsCGJ2hRz
8T/3/iE75xOyUFmJqjKDPdGy7pxsHbyjBZAS3cBCyQcIiFIfp59RDoQVSiOIC0N38H7GxEw2wIXl
--00000000000098cb8a05e4114478--
