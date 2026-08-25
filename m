Received: from mail-vk1-f225.google.com (mail-vk1-f225.google.com [209.85.221.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C429A41BA77
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787660421; cv=none; b=Nnv6FG+njSGZu3qM/mbFClzV964EW3f0GoWzxF3k9IqomSsJMe0WIN8W2XjW0GClxEGadpFnY0f8I2DUQlqe0rSeDfmngHweXXuwbbH2Fz7hcrZ40zbwe3Tu7NrUka2FTR4qIF0sfl1Yf/+WLaAHLIhjVkAW0pmpB1J4yMKXJ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787660421; c=relaxed/simple;
	bh=0eeXxEyfssQRhlgewmsF4Gp93Z0Lg1D2g/uKStZfk0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ly6folflhpdDPsc54axPBulQQggQVhDrtVYtDfm0SqoRRe3fZma9iRTH6z/Rjev21489P2fetKZbhopTsRgbNbd7louHsJTNvD9nvLTN+ukVoYdV9+437ri/K+FOJvsKdTDTqFlHlc0/umBj72IWBehjg+Lxdcqb7n4hemB9Cbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=O6p6xRxC; arc=none smtp.client-ip=209.85.221.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="O6p6xRxC"
Received: by mail-vk1-f225.google.com with SMTP id 71dfb90a1353d-5bfbbe5220dso467580e0c.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787660417; x=1788265217;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ze8RxenBjb56H0aWTXEzNeK6bKxXvTxV27NqWXyKP8Y=;
        b=TyPtuYk2M4fIMnhU2mWHBXCG8/OITaHnw+ETJPrES5VwR9xlzbdgVsh+1r2T05dSPI
         usTzDerDRLzIAJaTezg55DkvhUTRhsO+lSEtRnd24GPe4G60sUWbZwFay0oJgq6tXpuV
         SgG1ItdBL0q0xU3dmcxJ/6LR5OBKur6gtqOSKOxfbW0fdGDluVfNe7s3xfgRCp7G7kL4
         uPqMjus3oRPJ+8qKQ6U9LxaftwVIFSKBcLjRxkOVbdnfSV7D5YowW2uWCIN7vN6Wz54D
         fdItIZM9JiTIdXye4yiR8BuLukCuLijNjTUZLy+iLcy6V2mcTecbsSB3cYKn5uj0Gjof
         dVkQ==
X-Gm-Message-State: AFuF++nMNe3DAfRxCjjmyG5FRiXyer5lD8TSVGs0Vgvlci2aFilpyPC4
	49boddCgMIAT392V/c2xqk+Gj4yDQbzK8Xal88VBoBOSvR3Yx+QIBaxiZVHK5Wo/Fic6NG1QTlF
	5QXatSjwAQpAd1YOK8Q8bvOArijbklarCrFGndsLy/FlXWoiBnxANn7apNHWIf5JyQ5D+/megII
	FvPWpETEhq8wPGbhOJ7tmnbOdJ15HyRknfwgykcOyOXX7aHED5XQ7z2c1H/FMKG75dU89OFOjIE
	MAxtM0kuvgQSoEkv/ZEzFUa
X-Gm-Gg: AR+sD10Rhy99OCMlBhz1+B7W33EQrBhOO8KZd3/jBPAZ9JgMv2NWoe3qpbMdCC4CEFJ
	IoewGPWI/4QJT78fFFcPhJ/OOHMUPxZ/84mKOIIcUTN+XexpPR/x8xLTDbPzPRx1SKzQvSqug6h
	b/6Sg615iHZXmgxn65EkY+Hf6l2Jsf8KclcBuzBQrI7XxXKhMRmAsEyz9NFrhaVm2qqDqfpu+Vm
	apdCM4rC+amO6cGeFzX1t4NZt38WvQL2Yu1cpSb0a88K1rPT3du2g72vBxoYI/E8AyxfThJPXCP
	LeGYDLhBrjV5GeBWYxYcoVPjDiwVIwW9/aFlVF1tj0VyDjaXpfAg95zNj6Pe0hI7ErZf5I/tm9k
	FoGfzTnwzXrFzcLHl6cPUdOWlmtrOewyThMGoZbyhLzHuIFg1tD87j3jmYIXoCP94k+SxrVZS3a
	5baqWo7+wC0RWNlqtDa92a+R5DBshodLzpv2nxqjKSCaM=
X-Received: by 2002:ac5:c775:0:b0:5c5:924a:4616 with SMTP id 71dfb90a1353d-5c641602533mr1265690e0c.0.1787660416820;
        Tue, 25 Aug 2026 05:20:16 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c623dad280sm2106023e0c.3.2026.08.25.05.20.15
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:20:16 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15c6a68406so314641266b.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787660414; x=1788265214; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ze8RxenBjb56H0aWTXEzNeK6bKxXvTxV27NqWXyKP8Y=;
        b=O6p6xRxC5X6KOAZgHfsDnEo0b5KomiptITGyR9GuKu9APl7Xf7NYsKgxE2tkIwHQ48
         IB53YSeFbRbcoNQwI8ECGio6KSQ3Y2dYs/7CUtodJwWOfwUv1jUbi3RY+gLlulqsIyN9
         f1LV09/glmH3R21Xlz2SXJgL30gRE+pCrPc38=
X-Received: by 2002:a17:907:9814:b0:c21:792:8257 with SMTP id a640c23a62f3a-c24e5ad9556mr686532266b.15.1787660414534;
        Tue, 25 Aug 2026 05:20:14 -0700 (PDT)
X-Received: by 2002:a17:907:9814:b0:c21:792:8257 with SMTP id
 a640c23a62f3a-c24e5ad9556mr686522566b.15.1787660413951; Tue, 25 Aug 2026
 05:20:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-17-chandrakanth.patil@broadcom.com> <20260818182335.C3EBE1F000E9@smtp.kernel.org>
In-Reply-To: <20260818182335.C3EBE1F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:50:01 +0530
X-Gm-Features: AcwNN1WVv-13rUaW2qUEOJfbDVd3sls2OitVfDqZfEPENqk8PdOn_hNgdPh63r0
Message-ID: <CABvwm=PzwVZc6szk-bnkDOzfjzGNX+RkwrZHdaOGrAKq86U7tQ@mail.gmail.com>
Subject: Re: [PATCH 16/17] mpi3mr: Fix use-after-free of the firmware event workqueue
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000027f690659de20b9"

--000000000000027f690659de20b9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:53=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Use-After-Free of firmware event (`fwevt`) in `mpi3mr_cleanup_fw=
evt_list` during driver teardown.
> --
>
> --- Patch [16]: [PATCH 16/17] mpi3mr: Fix use-after-free of the firmware =
event workqueue ---
> commit d1068d82a1a0b06d1a9647481bac5d43ff5f1ebc
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: Fix use-after-free of the firmware event workqueue
>
> This commit fixes a use-after-free issue regarding the firmware event
> workqueue in the mpi3mr driver. It ensures the worker thread pointer is
> checked while holding the event lock to prevent a race condition with the
> workqueue being destroyed.
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3=
mr_os.c
> > index 510c990d42d1b..4a72b3d89c294 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -233,10 +233,11 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3m=
r_ioc *mrioc,
> >  {
> >       unsigned long flags;
> >
> > -     if (!mrioc->fwevt_worker_thread)
> > -             return;
> > -
> >       spin_lock_irqsave(&mrioc->fwevt_lock, flags);
> > +     if (!mrioc->fwevt_worker_thread) {
> > +             spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
> > +             return;
> > +     }
> >       /* get fwevt reference count while adding it to fwevt_list */
> >       mpi3mr_fwevt_get(fwevt);
> >       INIT_LIST_HEAD(&fwevt->list);
>
> [Severity: High]
> This is a pre-existing issue, but while reviewing the firmware event
> lifecycle, I noticed another potential use-after-free during driver teard=
own.
>
> In mpi3mr_dequeue_fwevt(), the list reference is dropped before returning
> the pointer:
>
> drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_dequeue_fwevt() {
>     ...
>                 fwevt =3D list_first_entry(&mrioc->fwevt_list,
>                     struct mpi3mr_fwevt, list);
>                 list_del_init(&fwevt->list);
>                 /*
>                  * Put fwevt reference count after
>                  * removing it from fwevt_list
>                  */
>                 mpi3mr_fwevt_put(fwevt);
>         }
>         spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
>
>         return fwevt;
> }
>
> Then in mpi3mr_cleanup_fwevt_list(), we pass this unreferenced pointer to
> cancel_work_sync():
>
> drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_cleanup_fwevt_list() {
>     ...
>         while ((fwevt =3D mpi3mr_dequeue_fwevt(mrioc)))
>                 mpi3mr_cancel_work(fwevt);
>     ...
> }
>
> Could the background worker thread (mpi3mr_fwevt_worker) concurrently fin=
ish
> executing and free the fwevt structure, causing cancel_work_sync() inside
> mpi3mr_cancel_work() to access freed memory?
>
> Additionally, lockless access to mrioc->current_event in
> mpi3mr_cleanup_fwevt_list() could similarly read a concurrently freed eve=
nt if
> the worker thread finishes in the middle of cleanup:
>
> drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_cleanup_fwevt_list() {
>     ...
>         if (mrioc->current_event) {
>                 fwevt =3D mrioc->current_event;
>         ...
>                 mpi3mr_cancel_work(fwevt);
>         }
> }
>
> Does this code need to hold a reference to fwevt while calling
> mpi3mr_cancel_work() to prevent the worker thread from freeing it?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D16

Thanks for the review.

New issues:
- None. This patch specifically ensures that
mrioc->fwevt_worker_thread is checked while holding fwevt_lock to
prevent a race with workqueue destruction.

Pre-existing issues:
- The teardown reference counting observation in
mpi3mr_cleanup_fwevt_list() and mpi3mr_dequeue_fwevt() is a
pre-existing issue in the driver and will be
  addressed in a separate follow-up patch series.

--000000000000027f690659de20b9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIVcQYJKoZIhvcNAQcCoIIVYjCCFV4CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghLeMIIGqDCCBJCgAwIBAgIQfofDCS7XZu8vIeKo0KeY9DANBgkqhkiG9w0BAQwFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSNjETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMzA0MTkwMzUzNTNaFw0yOTA0MTkwMDAwMDBaMFIxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBS
NiBTTUlNRSBDQSAyMDIzMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAwjAEbSkPcSyn
26Zn9VtoE/xBvzYmNW29bW1pJZ7jrzKwPJm/GakCvy0IIgObMsx9bpFaq30X1kEJZnLUzuE1/hlc
hatYqyORVBeHlv5V0QRSXY4faR0dCkIhXhoGknZ2O0bUJithcN1IsEADNizZ1AJIaWsWbQ4tYEYj
ytEdvfkxz1WtX3SjtecZR+9wLJLt6HNa4sC//QKdjyfr/NhDCzYrdIzAssoXFnp4t+HcMyQTrj0r
pD8KkPj96sy9axzegLbzte7wgTHbWBeJGp0sKg7BAu+G0Rk6teO1yPd75arbCvfY/NaRRQHk6tmG
71gpLdB1ZhP9IcNYyeTKXIgfMh2tVK9DnXGaksYCyi6WisJa1Oa+poUroX2ESXO6o03lVxiA1xyf
G8lUzpUNZonGVrUjhG5+MdY16/6b0uKejZCLbgu6HLPvIyqdTb9XqF4XWWKu+OMDs/rWyQ64v3mv
Sa0te5Q5tchm4m9K0Pe9LlIKBk/gsgfaOHJDp4hYx4wocDr8DeCZe5d5wCFkxoGc1ckM8ZoMgpUc
4pgkQE5ShxYMmKbPvNRPa5YFzbFtcFn5RMr1Mju8gt8J0c+dxYco2hi7dEW391KKxGhv7MJBcc+0
x3FFTnmhU+5t6+CnkKMlrmzyaoeVryRTvOiH4FnTNHtVKUYDsCM0CLDdMNgoxgkCAwEAAaOCAX4w
ggF6MA4GA1UdDwEB/wQEAwIBhjBMBgNVHSUERTBDBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQB
gjcUAgIGCisGAQQBgjcKAwwGCisGAQQBgjcKAwQGCSsGAQQBgjcVBjASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBQAKTaeXHq6D68tUC3boCOFGLCgkjAfBgNVHSMEGDAWgBSubAWjkxPioufi
1xzWx/B/yGdToDB7BggrBgEFBQcBAQRvMG0wLgYIKwYBBQUHMAGGImh0dHA6Ly9vY3NwMi5nbG9i
YWxzaWduLmNvbS9yb290cjYwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjYuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yNi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUAA4IC
AQCRkUdr1aIDRmkNI5jx5ggapGUThq0KcM2dzpMu314mJne8yKVXwzfKBtqbBjbUNMODnBkhvZcn
bHUStur2/nt1tP3ee8KyNhYxzv4DkI0NbV93JChXipfsan7YjdfEk5vI2Fq+wpbGALyyWBgfy79Y
IgbYWATB158tvEh5UO8kpGpjY95xv+070X3FYuGyeZyIvao26mN872FuxRxYhNLwGHIy38N9ASa1
Q3BTNKSrHrZngadofHglG5W3TMFR11JOEOAUHhUgpbVVvgCYgGA6dSX0y5z7k3rXVyjFOs7KBSXr
dJPKadpl4vqYphH7+P40nzBRcxJHrv5FeXlTrb+drjyXNjZSCmzfkOuCqPspBuJ7vab0/9oeNERg
nz6SLCjLKcDXbMbKcRXgNhFBlzN4OUBqieSBXk80w2Nzx12KvNj758WavxOsXIbX0Zxwo1h3uw75
AI2v8qwFWXNclO8qW2VXoq6kihWpeiuvDmFfSAwRLxwwIjgUuzG9SaQ+pOomuaC7QTKWMI0hL0b4
mEPq9GsPPQq1UmwkcYFJ/Z4I93DZuKcXmKMmuANTS6wxwIEw8Q5MQ6y9fbJxGEOgOgYL4QIqNULb
5CYPnt2LeiIiEnh8Uuh8tawqSjnR0h7Bv5q4mgo3L1Z9QQuexUntWD96t4o0q1jXWLyrpgP7Zcnu
CzCCBYMwggNroAMCAQICDkXmuwODM8OFZUjm/0VRMA0GCSqGSIb3DQEBDAUAMEwxIDAeBgNVBAsT
F0dsb2JhbFNpZ24gUm9vdCBDQSAtIFI2MRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpH
bG9iYWxTaWduMB4XDTE0MTIxMDAwMDAwMFoXDTM0MTIxMDAwMDAwMFowTDEgMB4GA1UECxMXR2xv
YmFsU2lnbiBSb290IENBIC0gUjYxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2Jh
bFNpZ24wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCVB+hzymb57BTKezz3DQjxtEUL
LIK0SMbrWzyug7hBkjMUpG9/6SrMxrCIa8W2idHGsv8UzlEUIexK3RtaxtaH7k06FQbtZGYLkoDK
RN5zlE7zp4l/T3hjCMgSUG1CZi9NuXkoTVIaihqAtxmBDn7EirxkTCEcQ2jXPTyKxbJm1ZCatzEG
xb7ibTIGph75ueuqo7i/voJjUNDwGInf5A959eqiHyrScC5757yTu21T4kh8jBAHOP9msndhfuDq
jDyqtKT285VKEgdt/Yyyic/QoGF3yFh0sNQjOvddOsqi250J3l1ELZDxgc1Xkvp+vFAEYzTfa5MY
vms2sjnkrCQ2t/DvthwTV5O23rL44oW3c6K4NapF8uCdNqFvVIrxclZuLojFUUJEFZTuo8U4lptO
TloLR/MGNkl3MLxxN+Wm7CEIdfzmYRY/d9XZkZeECmzUAk10wBTt/Tn7g/JeFKEEsAvp/u6P4W4L
sgizYWYJarEGOmWWWcDwNf3J2iiNGhGHcIEKqJp1HZ46hgUAntuA1iX53AWeJ1lMdjlb6vmlodiD
D9H/3zAR+YXPM0j1ym1kFCx6WE/TSwhJxZVkGmMOeT31s4zKWK2cQkV5bg6HGVxUsWW2v4yb3BPp
DW+4LtxnbsmLEbWEFIoAGXCDeZGXkdQaJ783HjIH2BRjPChMrwIDAQABo2MwYTAOBgNVHQ8BAf8E
BAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUrmwFo5MT4qLn4tcc1sfwf8hnU6AwHwYD
VR0jBBgwFoAUrmwFo5MT4qLn4tcc1sfwf8hnU6AwDQYJKoZIhvcNAQEMBQADggIBAIMl7ejR/ZVS
zZ7ABKCRaeZc0ITe3K2iT+hHeNZlmKlbqDyHfAKK0W63FnPmX8BUmNV0vsHN4hGRrSMYPd3hckSW
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
oIHHMC8GCSqGSIb3DQEJBDEiBCDWafw7KbFiyfDX/qQI1AfOXIXBg72tRtNQ5HwaZxZY/zAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjIwMTRaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQABiGsEMml6
quQuQd3xNWjKePiYUmsMeGdnAUkirrfx9m5i+a/lnbMHE8phEpIWEm0Z/Lm8zaWREqIIMf4Eqjp7
fQJq5MWZ5ftI0ms4FpACNYOpwxRd9+8FQjhykiOXjKbWkafeOWNOj/92ckxJ0UVkuazG/sCBaZX/
1iX+2n6sStPkSge8xo8129B/NAR7AXt1N1zQxMN0zxp9k/L2ki2ZbwjOOXTo4e5dIxERhXtygA2H
9n8oNeDRCUu2vn7gGhoOxsHoJTnSs7EIc8YppCvqlXFlNQ/Zjjp8x+mzAmP026AcL6KZy6H9cPGT
hZqedFtmd6egb7CUC6EFzVvtR5mz
--000000000000027f690659de20b9--
