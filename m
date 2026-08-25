Received: from mail-vk1-f226.google.com (mail-vk1-f226.google.com [209.85.221.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B703CFF61
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659465; cv=none; b=LhFFlAs8kH43//lFhEh1oLCkvKXZ3lUuBDlhYE33kto4aAtxbKNgBsBvQ8bcA0pDIZUTWBaDoGOtioKIRVu82qfZHtz0KFuuyAFDYFpV4ePyS7t/cznXlnLVmYgqx1qd4EjxeXcrFahrTZPbKD5xPMw5knpnOBgs4qzlgNnlK5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659465; c=relaxed/simple;
	bh=OTRfQZDQZrDXkoiVqPk7j3JLG7m2k0cPTpEUz0zUBdk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JzXAFUCTmGtnuwJTSqLS0BkNOkZZPx1lCOWwuDox3+RYhql+w0Latn0etpEY/5U5dC3L1GlyfxDfZ6Z4r4LQ+0V542NQCokeMMdxlCnTEjZuAUejZHi5f6nPQBsf2n22ZdSAjGcYpY64zY0fWphwpzvi29U2wEnvszdEuqLooMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Fen/Dx1V; arc=none smtp.client-ip=209.85.221.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Fen/Dx1V"
Received: by mail-vk1-f226.google.com with SMTP id 71dfb90a1353d-5c2dbaf828eso1954806e0c.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787659463; x=1788264263;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KVp+w8oEdENeGsYsICn2p3Ju1XMVGj279A/kAHtg/hU=;
        b=gGbJ9dmuXvEU9eRD90TkOOAGjjEgVbaMY74atp8G5g4vuWtx3tUThRxWGi6f7Iv0wp
         rTqbBwmKsEr1NPMq8Qhu5lW/Se/4t4RKtplUdzLWkHND4CmGacx682O4WhOHqkaa7QnD
         DQEJcFRPY442bD9V5+5qRYuN0HedgTeflycqH/1097ex8oh/wNrOs3q6UE51Dse/dd4l
         bezVdRf2M2h7Jw2sywJy3psl/s11ZDbS/Xu1iMnmAtzshPUQ+JUOnVHM40NyJEziYWhc
         SDsnt2XQtLTm3YBZfzU6ObShgo73VVWUrel9A3oLW/5zC1Us5CwZGI0R+kqCNfW2G17K
         f1ew==
X-Gm-Message-State: AFuF++nFfhmYe4lYaOd7mVkzD5HP6Y3MqmLbUyAfhdRI4cIok9OrtY2z
	GFVvAQY9DwG00RWg+RnYCGHFb4diYotszRB+GWs8vFVItDeQDkqGDPfRYrrllR7VVNxi/N9VVED
	ZE8WTFag5AApwSsa/3S+iFgYsYylwYgA67D20I0qID6b+PIeYFp3OtDyfqykeb5Ml7BtYjMiTaO
	VK0+2vAW8IiFAdgZZLRz3xKF9wLcDrqqwCrBEdNMQ8/jRHlBOk4EPrgfMHI2o+hnJhJCyVdgo00
	Spcl2p6B2IpOUlRuB//Rp8C
X-Gm-Gg: AR+sD10ZduRDzXNG8lUNjUXHQkeMQDzlckW7T11csv1iE5+om0NKbD+Ccup/VJd8kY0
	NSLkpGuCuTIKqByuOdoL2x4Fu+grquP7qtkdbYvIxoacMd82LPgzo/tqVGmJUfxJSAG57ocvq+2
	bRrVM7wDGuuWrHyTuHdeg+UnQctcGUb9hf9Mw0e4M55C8cUoMFo7pAx1g1xG+Zyk0FOrcb+3F34
	fySn2ZO41J8LIMKMDTYo/JVySq1jCnGjdtaBHcbB5jQ4cE0u+HdtM71KvBscoALGJw3qU7YVIyK
	iHu8xqaI/1Xqhn1IHmNI9qcP46W6B/Be6wVkko/zGCarZtUBHxB+AcvgERdcDDubh8jrtqXghrU
	xMG7QsLAHQxm8tZLfh5rdXSi+Qnx69Kg48NQgBW7xNDVlurjIoNSMUPi7DG1BmyWczTOAhpgS9h
	6p5dVKe8KpaXieSlPfrohPKpeIcN6+erQBtMT2W5cHBbc=
X-Received: by 2002:a05:6122:8b03:b0:5bd:af82:fd9e with SMTP id 71dfb90a1353d-5c60deb6161mr10144649e0c.8.1787659462542;
        Tue, 25 Aug 2026 05:04:22 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-97c83279941sm777061241.1.2026.08.25.05.04.22
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:04:22 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c1f3117bc6bso427500066b.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787659461; x=1788264261; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KVp+w8oEdENeGsYsICn2p3Ju1XMVGj279A/kAHtg/hU=;
        b=Fen/Dx1V9gfmzI5GzqnS2bE2VBqH+jgIkeMiehx2B1OgVcBBu7y4VzMRs+YJESNrDQ
         GhK1dxtd+B35Xl6ncUUjA32aJkW0qiOVAHLcqmyuqw3fhq7EK9mmvx/9GDYbZUAsHkCV
         80w9sY9gicszJzgM2KdYcF35eUoVC0TV0vNiw=
X-Received: by 2002:a17:907:d0c:b0:c20:53c7:488d with SMTP id a640c23a62f3a-c24e5ade3a4mr674422766b.14.1787659460814;
        Tue, 25 Aug 2026 05:04:20 -0700 (PDT)
X-Received: by 2002:a17:907:d0c:b0:c20:53c7:488d with SMTP id
 a640c23a62f3a-c24e5ade3a4mr674411666b.14.1787659460085; Tue, 25 Aug 2026
 05:04:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-4-chandrakanth.patil@broadcom.com> <20260818181131.B7A541F000E9@smtp.kernel.org>
In-Reply-To: <20260818181131.B7A541F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:34:08 +0530
X-Gm-Features: AcwNN1XQsIL_k4kkB_41hzk8OMRP6ENZANiYMBGV0XWL9qsRT8zcNUxRiKSP9-4
Message-ID: <CABvwm=PWk07NjVmTCQzkU=rC53gGWdFSLttb_qBzb+f_3gBxKg@mail.gmail.com>
Subject: Re: [PATCH 03/17] mpi3mr: Fix I/O block counter leak on admin request
 post failure
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000002bd4910659dde786"

--0000000000002bd4910659dde786
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:41=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] Dereferencing `stgt_priv` on the error and timeout/completio=
n paths leads to a Use-After-Free if the SCSI target is concurrently remove=
d.
> --
>
> --- Patch [3]: [PATCH 03/17] mpi3mr: Fix I/O block counter leak on admin =
request post failure ---
> commit 1533f8fc86e8eb7e7a5042ad5aab564671eb7b8c
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: Fix I/O block counter leak on admin request post failure
>
> This commit addresses an issue where the per-device I/O block counter is =
not
> decremented if posting a task management request fails. It lowers the cou=
nter
> on the failure path to prevent I/O from remaining blocked.
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi=
3mr_app.c
> > index 1cd1c38dcd565..a4fe10a05cb3a 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> > @@ -2782,6 +2782,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bs=
g_job *job)
> >               dprint_bsg_err(mrioc,
> >                   "%s: posting bsg request is failed\n", __func__);
> >               rval =3D -EAGAIN;
> > +             if (block_io && stgt_priv)
> > +                     atomic_dec(&stgt_priv->block_io);
>
> [Severity: Critical]
> This is a pre-existing issue, but does this add another path that can tri=
gger
> a use-after-free if the SCSI target is concurrently removed?
>
> Looking at mpi3mr_bsg_process_mpt_cmds(), stgt_priv is fetched from
> tgtdev->starget->hostdata, but the tgtdev reference is immediately droppe=
d
> before posting the bsg request:
>
>         if (block_io) {
>                 tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle)=
;
>                 if (tgtdev) {
>                         if (tgtdev->starget && tgtdev->starget->hostdata)=
 {
>                                 stgt_priv =3D (struct mpi3mr_stgt_priv_da=
ta *)
>                                     tgtdev->starget->hostdata;
>                                 atomic_inc(&stgt_priv->block_io);
>                         }
>                         mpi3mr_tgtdev_put(tgtdev);
>                 }
>         }
>
> Because there are no references or locks held, if the device is concurren=
tly
> removed (e.g., via hot-unplug), the SCSI midlayer can invoke
> mpi3mr_target_destroy(), which unconditionally frees the hostdata memory:
>
> mpi3mr_target_destroy() {
>         ...
>         kfree(starget->hostdata);
>         ...
> }
>
> Since the original completion path also dereferences stgt_priv after slee=
ping
> in wait_for_completion_timeout(), both the timeout/completion path and th=
is
> newly added error path seem to potentially call
> atomic_dec(&stgt_priv->block_io) on freed memory.
>
> >               goto out_unlock;
> >       }
> >       wait_for_completion_timeout(&mrioc->bsg_cmds.done,
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D3

Thanks for the review.

New issues:
- None. This patch specifically fixes an I/O block counter leak when
posting a task management request fails by decrementing
stgt_priv->block_io on the failure path.

Pre-existing issues:
- The stgt_priv lifecycle/UAF risk during concurrent target removal is
a pre-existing issue in mpi3mr_bsg_process_mpt_cmds() (also present on
the completion path)
  and will be addressed in a separate follow-up series.

--0000000000002bd4910659dde786
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
tJVewHuOmXgWQxNWV7Oiszu1d9xAcqyj65s1PrEIIaHnxEM3eTK+teecLEy8QymZjjDTrCHg4x36
2AczdlQAIiq5TSAucGja5VP8g1zTnfL/RAxEZvLS471GABptArolXY2hMVHdVEYcTduZlu8aHARc
phXveOB5/l3bPqpMVf2aFalv4ab733Aw6cPuQkbtwpMFifp9Y3s/0HGBfADomK4OeDTDJfuvCp8g
a907E48SjOJBGkh6c6B3ace2XH+CyB7+WBsoK6hsrV5twAXSe7frgP4lN/4Cm2isQl3D7vXM3PBQ
ddI2aZzmewTfbgZptt4KCUhZh+t7FGB6ZKppQ++Rx0zsGN1s71MtjJnhXvJyPs9UyL1n7KQPTEX/
07kwIwdMjxC/hpbZmVq0mVccpMy7FYlTuiwFD+TEnhmxGDTVTJ267fcfrySVBHioA7vugeXaX3yL
SqGQdCWnsz5LyCxWvcfI7zjiXJLwefechLp0LWEBIH5+0fJPB1lfiy1DUutGDJTh9WZHeXfVVFsf
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGpzCCBI+g
AwIBAgIMAgfxQ1Z7DrZKmCE/MA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI1MDYyMDEwMzUwNFoXDTI3MDYyMTEwMzUwNFowgekxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEOMAwGA1UEBBMFUGF0aWwxFTATBgNVBCoTDENoYW5kcmFrYW50aDEWMBQGA1UEChMNQlJP
QURDT00gSU5DLjEoMCYGA1UEAwwfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTEuMCwG
CSqGSIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAJwyF5qSHwwr1zJWkKvkMnY7V/sVFYYjTpjgxS4XA76pD6eLsZvS
4J73HkKSNEzORxBE7OyZSnuBJ9zeeRcypuItG9YrHm+0OSF0psIWsH15FBYJ0nvsUnlFbCSNvOdr
Co0WJ1KTe/7caj014uRZM2j7zH1vC+9fjEgrJdDRZakZXarl8M7k9okvVj1N+EuHiYUMvsAuMadE
a3p31Z6QdvMpr+30UdJXHshV1mXca+UBpCx26GbY6NgxhHM2LtHiaCK8Vn4HMofDkFg4nQ6eK4ai
uCiTtPj5aNlkdpcCzcZ+j1eCu6ZfPIq2ycwDaHi8d6Dwcgm+XoxDmD97Ehp2FOkCAwEAAaOCAeMw
ggHfMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggr
BgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1l
Y2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2Ny
NnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGg
MgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5
LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWlt
ZWNhMjAyMy5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTAT
BgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNV
HQ4EFgQUyqNnwId/JCbRPslVl3nm48YRek0wDQYJKoZIhvcNAQELBQADggIBAKPmllSh8cRXzNRs
3OATCVDgrdOfIsZMB9UVXcYQ+HtR1fu9bafeyuuupF9gcCmi+onLsANYRKaEDjC8h+V5FMAgm6TI
bww4EFGpWvP/XEVKrpcpMkYNMLw89lagx9ZZDhx9DmfQMI9gG9MPpCkSMEPnJvEs7gqtOo08aL1+
ts10tGfePsHF/I42Da21hJIJ01XN+Z91y//1cJkHwCBvDmoB8gdMXp3g4sjzahTxRZ25BdZB9W+n
0jfWJXFKtp9MYS1SaVo17usfrlTeyaH3zPyDvfAfGoLB5+i8vyVL6wta2vgVpfsL9iwhbJnAIxr+
ljECWkh1weDJw3UnV6nooG1RztnwqbG4eAG/KSCToXgVH9qSDv5S1lve5mvhv9AHzLjGLs+QtMeg
WEdMM4G0PWyibzGgNrmVgKaLjV6EMo/IZW7KjBtvjyKQZhes90D4GyxXv+/mrTo2rruz53+FoSc/
nuyLmg/SxnnZRaf7JGHFvu0IbwkeINwdHynAanOg9AD4zits7k7jjQ0fwIdhCaoRA3ao7PXUL1t8
LfSp/K5DCYsrXNqitPmQaAAGAiG4d4WDxBev6vtoyH7ejLcuCKkxCefrLO5qYnuDHsMNCObdslAe
tMVer+USn6AqB//6EwmqdiLr4o20UQ79jxNFMAEKdwyNkA8mVCVUAtTe3mPrMYICVzCCAlMCAQEw
YjBSMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xv
YmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0EgMjAyMwIMAgfxQ1Z7DrZKmCE/MA0GCWCGSAFlAwQCAQUA
oIHHMC8GCSqGSIb3DQEJBDEiBCAujwE1rZDmhaQlD+qiq4gP3cT8dV3KTX9QmgvNicRoyTAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjA0MjFaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA3yOULt/wq
WHRhcbpm1Y39Fo693WbKQjObc1A2sNHzh1HpEY1rjppuq5BQ0ql7NOEfKviU3Jh9Wf3MzKJxVwII
QYD1vKz/hUKKyCkjzdUJj3ONNOMAPSwI6P5CMsAoa302DJYsSOUMSuruIuEFO07dV6hefnjzFen5
LPiEmSPv3P9uSxugleAOWnGH3amtkBrhh1U128GXHOS77AFd+Tip3cdTwwwARwmZCntl9OdIJU5B
SWtrwJvIONTBGx27HsAa8uCKIaa00q1xzCZoXdPGX7zlRjDVJeBAZ0l6kLC/BFTXoqWNxg7YEypi
o7NOhSqDs/ITMEax/rwKz91C7hBz
--0000000000002bd4910659dde786--
