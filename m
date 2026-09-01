Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD4A27FD76
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 12:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788266362; cv=none; b=hCfwb9nH26aAtfFSA+OZH+3XOXtyo1FwiLizKDTyR3EZbN7w0iEsnJVfsumsdYHJUHaOU3QmtfLt+/9gvyNsFMCtb2mX5k26yi94QrQOSULGa7gVoKx27A/SL0/ejrTLBfLwJtHej9q50vs6JAODqV075iK+x0Hx69yFwVAemG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788266362; c=relaxed/simple;
	bh=mlG1dq5V/SXc1FpybCgT2jJdyxJwAHiTB0GEv0AvM3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M3rcKiux+S3iETCZ8Gf4lRbNRtf+3Za5m/zlB5q7QIKDsO74wEd4j9MQhZh8AFQgKJsAEVh0UV8qM/ZzIH21g9fdhOuJGwj9IAi2lQex/4k99nxTZmMFI8OVAppz/oIb3gaFUK6KNsb53JdJE2AM80eiLs4alqUTqPFOtgtR4c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=csaf+6rh; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="csaf+6rh"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2d6f9e2f681so45865665ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 05:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788266360; x=1788871160;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TxUZu/pkeMJC63ulJVnA3whqy3xLM2F98y/IVzSgexU=;
        b=s6SJJVibcNGvFpXgvo6AV564ZfoTA3veAqB4kiw2QYYN0H9iiWIlPZM+myuQ0BxYcc
         fflg4494LwgtEGOuQkLg21MUEAL35XiVGNAfHV1ZAd44ZVIlOFHwS3Qr2JQd58yqZ6iJ
         6Hhk+D5KF88uZR3SbMHXnE0tMNY4aT2hjZx+Cid/AoN0haufhlg+TVu96gym1Oyeb9qh
         YMEpYQ92XVbnewvHOl1yhf/QxSB7z5fRc74ar9656bRMuWTykHO3OwWq5uRXDVFu5zFs
         WCLbGXrNr4A4cCLFbDwiKGsu9yZBtwoT1PuQ0cTdIlUCUmYkgwCaHFUYd6ux+7mUUjA3
         Y7RA==
X-Gm-Message-State: AFuF++n8Gmwivk1ckRQe6D0MdvBbQGuOyxP/zTI3FYUQYX3yYNTN+ih+
	VaPy2kw/hXUtLM8lZmWdmqxNIU9UebcGYwwxd4yGcORqE7LLe8ic15dgDU4XAKTkwffSVjv5o3D
	8H7UZDCUkiSjEwrpwNv/36cJLiyYgkO3eAe6NbEPEtvtgS/cSRjorKXKO0MMUkkotg9mC+x65vP
	rncYErWRkjO8yvAsdqBGBrmN1k1pinZlZo4UUmVhfrmQXw8FcfYToT/HBVQgeOU4dZqf30BLiMJ
	eigNKj3PJbzlbor/jc0QWm1
X-Gm-Gg: AYBFou2tyiUPhneJOt069KnJwyv5KTIi0Szsl39XKy8G+KE4WfMMo/MVn0YVi7jyZH/
	X4sCOBe7b5qNp8IsmRLWuF5Kmf4eTPp7H60mBLBr/1Y3OK2Jz9ZtSWAjhvxXs3eQLa6I4SGG4B2
	2D4gQSrN2ieplKPkLzi6jT9HRuTkoBJfLPdeHYOVFfz4+LpWdhE1hEpc8sikDe0ODtN48PiI6Ot
	LAJe0rZxtm//4RI+GcxT67thE6sQNELb1Cd319N4YrCRbj7rpVGKZwQ8MKa5jC78tm5NGKiwRf+
	jm7Y2yvRHxqran4H88qSieCiip0tg5eJEUk7/eZkSGLjK8swo6p3X5vQGE4dhXU57rZTv2K/8xr
	ALZNLFaif/ydDqRhFe03x4ijadGBpC2u9zAupHDVrD53tCWOxsaTwwYYfpmR3zxQQzutB1Vlcg/
	RsC+KviVwb76lMM9kWfarmSvkGtQ7urcWt7RX54v3I/78=
X-Received: by 2002:a17:90b:388a:b0:398:e436:370 with SMTP id 98e67ed59e1d1-398e43605a7mr19128071a91.2.1788266359660;
        Tue, 01 Sep 2026 05:39:19 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3990cd9f09fsm1002982a91.5.2026.09.01.05.39.19
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2026 05:39:19 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c21946c03e5so92326366b.0
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 05:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788266357; x=1788871157; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TxUZu/pkeMJC63ulJVnA3whqy3xLM2F98y/IVzSgexU=;
        b=csaf+6rh77rGT3K/ZIEY1fC4I0v9wH+ajwKEn4U1/2SMi1XNmezmiuf673tRGER5M4
         00H+0aXQU8XoFtitADGcIMgv4O7QgJ7v/79DZSh+tYys8sXPWFU829m37j1BfPqC7Pd4
         tFO5yhQ4Voywr+tN7xPKypsf+Nf0sZSAmEAdU=
X-Received: by 2002:a17:906:478a:b0:c25:3e36:acc8 with SMTP id a640c23a62f3a-c25b90d57ccmr295823466b.4.1788266357322;
        Tue, 01 Sep 2026 05:39:17 -0700 (PDT)
X-Received: by 2002:a17:906:478a:b0:c25:3e36:acc8 with SMTP id
 a640c23a62f3a-c25b90d57ccmr295820566b.4.1788266356708; Tue, 01 Sep 2026
 05:39:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831120047.14690-1-loberman@redhat.com> <13b7b8a4c0d7a3a80df295f312519d3a5cce87e6.camel@redhat.com>
In-Reply-To: <13b7b8a4c0d7a3a80df295f312519d3a5cce87e6.camel@redhat.com>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 1 Sep 2026 18:09:02 +0530
X-Gm-Features: AcwNN1WpUGxQwNpkjkzA3P-2RrRiO-rMNNX1YJHh-cPS8aXCh-UDiKqPc74J8to
Message-ID: <CABvwm=PJbhZC5OanhFua97vNn6itFZgApbPHAX6Y8W9=K21cfw@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpi3mr: fix use-after-free on tgt_dev->starget
 during target device refresh/update
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com, 
	martin.petersen@oracle.com
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000005360c065a6b3543"

--00000000000005360c065a6b3543
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 6:21=E2=80=AFPM Laurence Oberman <loberman@redhat.c=
om> wrote:
>
> On Mon, 2026-08-31 at 07:59 -0400, Laurence Oberman wrote:
> > mpi3mr_refresh_tgtdevs() and mpi3mr_devinfochg_evt_bh() read
> > tgt_dev->starget and immediately pass it to starget_for_each_device()
> > without holding mrioc->tgtdev_lock. Every writer of this field --
> > mpi3mr_target_alloc(), mpi3mr_target_destroy(),
> > mpi3mr_slave_destroy()
> > and mpi3mr_sdev_init() -- correctly serializes access under
> > tgtdev_lock, but these two read sites do not, which leaves a
> > check-then-use window against the SCSI core's target teardown path
> > (scsi_remove_target(), invoked e.g. via a concurrent host reset,
> > sysfs "delete", or SCSI EH device offlining running independently of
> > the fwevt workqueue).
> >
> > Sequence observed on production hardware, triggered on the
> > mpi3mr0_fwevt_wrkr workqueue during a SAS topology change shortly
> > after a controller reset:
> >
> >   BUG: kernel NULL pointer dereference, address: 0000000000000058
> >   RIP: scsi_is_host_device+0x7/0x20
> >   Call Trace:
> >    starget_for_each_device+0x34/0x100
> >    mpi3mr_refresh_tgtdevs+0x152/0x1d0 [mpi3mr]
> >    mpi3mr_fwevt_bh+0x514/0x6c0 [mpi3mr]
> >    mpi3mr_fwevt_worker+0x1a/0x50 [mpi3mr]
> >    process_one_work+0x194/0x380
> >    worker_thread+0x2fe/0x410
> >
> > mpi3mr_refresh_tgtdevs() reads tgt_dev->starget as non-NULL, but by
> > the time starget_for_each_device() dereferences it, a concurrent
> > mpi3mr_target_destroy() has already cleared tgt_dev->starget under
> > tgtdev_lock and the SCSI/device core has freed the underlying
> > scsi_target (and its embedded struct device). The stale pointer is
> > then walked by dev_to_shost() -> scsi_is_host_device(), producing the
> > NULL/garbage dereference above.
> >
> > Fix this by taking mrioc->tgtdev_lock around every read of
> > tgt_dev->starget, matching the existing writer-side discipline. Since
> > starget_for_each_device() and mpi3mr_update_sdev() can end up doing
> > non-atomic work (e.g. queue_limits_commit_update()), the lock cannot
> > be held across the whole call, so instead pin the target's device
> > with get_device() while holding the lock, drop the lock, then run
> > starget_for_each_device() against the pinned reference and
> > put_device() afterwards. This closes the TOCTOU window instead of
> > merely narrowing it.
> >
> > The same unlocked read-and-dereference pattern also exists earlier in
> > mpi3mr_refresh_tgtdevs()'s first removal-scan loop
> > (tgt_dev->starget->hostdata); fix it the same way by holding
> > tgtdev_lock across that check, which is cheap since it only touches
> > plain struct fields.
> >
> > Assisted-by: Claude:Sonnet5 [Claude Code]
> > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > ---
> >  drivers/scsi/mpi3mr/mpi3mr_os.c | 45 +++++++++++++++++++++++++------
> > --
> >  1 file changed, 35 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > index 402d1f35d214..922b28c3fe12 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -1094,10 +1094,13 @@ static void mpi3mr_refresh_tgtdevs(struct
> > mpi3mr_ioc *mrioc)
> >  {
> >       struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
> >       struct mpi3mr_stgt_priv_data *tgt_priv;
> > +     struct scsi_target *starget;
> > +     unsigned long flags;
> >
> >       dprint_reset(mrioc, "refresh target devices: check for
> > removals\n");
> >       list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc-
> > >tgtdev_list,
> >           list) {
> > +             spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> >               if (((tgtdev->dev_handle =3D=3D
> > MPI3MR_INVALID_DEV_HANDLE) ||
> >                    tgtdev->is_hidden) &&
> >                    tgtdev->host_exposed && tgtdev->starget &&
> > @@ -1106,6 +1109,7 @@ static void mpi3mr_refresh_tgtdevs(struct
> > mpi3mr_ioc *mrioc)
> >                       tgt_priv->dev_removed =3D 1;
> >                       atomic_set(&tgt_priv->block_io, 0);
> >               }
> > +             spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> >       }
> >
> >       list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc-
> > >tgtdev_list,
> > @@ -1127,15 +1131,25 @@ static void mpi3mr_refresh_tgtdevs(struct
> > mpi3mr_ioc *mrioc)
> >       tgtdev =3D NULL;
> >       list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
> >               if ((tgtdev->dev_handle !=3D
> > MPI3MR_INVALID_DEV_HANDLE) &&
> > -                 !tgtdev->is_hidden) {
> > -                     if (!tgtdev->host_exposed)
> > +                             !tgtdev->is_hidden) {
> > +                     if (!tgtdev->host_exposed) {
> >                               mpi3mr_report_tgtdev_to_host(mrioc,
> > -                                                          tgtdev-
> > >perst_id);
> > -                     else if (tgtdev->starget)
> > -                             starget_for_each_device(tgtdev-
> > >starget,
> > -                                                     (void
> > *)tgtdev, mpi3mr_update_sdev);
> > -     }
> > +                                  tgtdev->perst_id);
> > +                             continue;
> > +                     }
> > +                     spin_lock_irqsave(&mrioc->tgtdev_lock,
> > flags);
> > +                     starget =3D tgtdev->starget;
> > +                     if (starget)
> > +                             get_device(&starget->dev);
> > +                     spin_unlock_irqrestore(&mrioc->tgtdev_lock,
> > flags);
> > +                     if (starget) {
> > +                             starget_for_each_device(starget,
> > (void *)tgtdev,
> > +                                                     mpi3mr_updat
> > e_sdev);
> > +                             put_device(&starget->dev);
> > +                     }
> > +             }
> >       }
> > +     dprint_reset(mrioc, "refresh target devices: done\n");
> >  }
> >
> >  /**
> > @@ -1515,6 +1529,8 @@ static void mpi3mr_devinfochg_evt_bh(struct
> > mpi3mr_ioc *mrioc,
> >       struct mpi3_device_page0 *dev_pg0)
> >  {
> >       struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> > +     struct scsi_target *starget;
> > +     unsigned long flags;
> >       u16 dev_handle =3D 0, perst_id =3D 0;
> >
> >       perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
> > @@ -1535,9 +1551,18 @@ static void mpi3mr_devinfochg_evt_bh(struct
> > mpi3mr_ioc *mrioc,
> >               mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
> >       if (tgtdev->is_hidden && tgtdev->host_exposed)
> >               mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
> > -     if (!tgtdev->is_hidden && tgtdev->host_exposed && tgtdev-
> > >starget)
> > -             starget_for_each_device(tgtdev->starget, (void
> > *)tgtdev,
> > -                 mpi3mr_update_sdev);
> > +     if (!tgtdev->is_hidden && tgtdev->host_exposed) {
> > +             spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> > +             starget =3D tgtdev->starget;
> > +             if (starget)
> > +                     get_device(&starget->dev);
> > +             spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> > +             if (starget) {
> > +                     starget_for_each_device(starget, (void
> > *)tgtdev,
> > +                                             mpi3mr_update_sdev);
> > +                     put_device(&starget->dev);
> > +             }
> > +     }
> >  out:
> >       if (tgtdev)
> >               mpi3mr_tgtdev_put(tgtdev);
> >
> >
> > Re:
>
> sashiko found Pre-existing issues:
> - [High] The patch fixes the unprotected check-then-use window for
> `tgtdev->starget` in `mpi3mr_refresh_tgtdevs()` and
> `mpi3mr_devinfochg_evt_bh()`, but identical vulnerable patterns remain
> in other functions like `mpi3mr_remove_tgtdev_from_host()`,
> `mpi3mr_update_tgtdev()`, and various event/BSG handlers.
> - [High] Unprotected traversal of `mrioc->tgtdev_list` without holding
> `tgtdev_lock` can lead to list corruption and crashes due to concurrent
> insertions.
> - [High] An AB-BA lock inversion exists between `mrioc->tgtdev_lock`
> and the SCSI host lock (`shost->host_lock`).
>
> The sashiko reviews were all for pre-existing issues and won't be fixed
> in the specific patch submission here.
>
> I will make an attempt to deal with those in a seperate submission as
> already agreed with Chandrekanth
>
> Thanks
> Laurence
>

Looks good to me. Thanks.

Acked-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

--00000000000005360c065a6b3543
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
oIHHMC8GCSqGSIb3DQEJBDEiBCAS44fOQ7p8OJcno2Pbp++f2aijMJ0jJLTzr6jHjPT6tjAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA5MDExMjM5MTdaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBovRmbhBjQ
xy+cnrGZO2IwjlQN1hJAzblMFkPU/g5LQjflOWoVxXvLpwZ4z8RjknBDxelmpD5KflQ4cU99xBM6
Wqk5eWkXXuQky+NPi22ksoJABgkn3OukU8vlTbYa9unYhaNgeJ9Iz9otB/MUY/L19/u8lfF8utEo
ABI+2bfM/+mEsTRoAm6CeYLSwWepUiR2t3Oe1zVoFOqWxu3N/5WqQlXMUxt6PN034X/idmS7qcjg
xNJVfy6VsAxkZaS4e2MetO+qz/Flb9P6V2vBNnWj6bJELgbI52d+3MBtwgQbXFnoQEgXqM++D3zV
ENTS+KngX8sJHBuPevaz0eJjz+OJ
--00000000000005360c065a6b3543--
