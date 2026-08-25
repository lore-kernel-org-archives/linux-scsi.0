Received: from mail-vk1-f226.google.com (mail-vk1-f226.google.com [209.85.221.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09B1401A01
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659781; cv=none; b=eKtIlFI3htqP5nsdw0dlltA3X9DDuiPuT3mx8Nb4xzGoJRBPJzEyQ8rv8MdTMHqYaYgZs2L8Xym54pzL/t8EFPC6zb+4lEJVDYDCeIYjr899Fdw2Z248XQmxp5EPKwyGcuHwenzZDjJsoxMxwU0ywpSsOWuatu5sxzB/JhiF/yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659781; c=relaxed/simple;
	bh=mEF+04PocuUHmASdhBppUqLc5BbEi2XrNSmmivMQcDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CTNkcnryrcAPStg/rkQekfi2SNRBZmShEPcAYS4q2U4u7+0uuj9MhYVdMJJ32kOODc2AEaRamk5XCttHe3chsiQ6HSyqkO+A1lw6DWW5D6Rawsp06hP/mTMKPLnOntBp/dFLcdKFgVB9nh6jgc3AT6496nStGMQOnZ2u2v0oWh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=br2KsHRs; arc=none smtp.client-ip=209.85.221.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="br2KsHRs"
Received: by mail-vk1-f226.google.com with SMTP id 71dfb90a1353d-5bfa6766cf6so2920420e0c.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787659778; x=1788264578;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6op+UbzHI1KHB5KXyUkyXnyxTb462HgGtNx9JpJquH8=;
        b=X75oQqCJZNXyKN95lMxxTnsYx0aGyWtXLyQWBnDsFEVgG8iK/wzFD1y/hfBlTLqbz4
         wVrHYSbAIfwItYsnCnRUXhki18nbZolRqM47myhCPZYMh+2Tab6ODrgnzgbhr34mHW6j
         o5ZvALUDmNkB/TGeUqftZIv9eJHYH/cuo6ATagOWtRkhKvUJMO251hUYE2ABOjQXLPPv
         lrH2WU5mpDLM5GwgkBLJD18BJO7sQODe+8qlAgr+t49eiSASV//9eGOOVlYBlFYn0qJn
         7ow5TWix/L/PbUwZMIVyH12SEzOdJ6Fd+42+fXsdn5OQAuOK4vbhIACR8iVluzOsbI+T
         kRNA==
X-Gm-Message-State: AFuF++l6aaiysSS4BP0Fs+1GbHuphA1LHd0j2xwXz1fCBHcn3ocjvDXE
	k2KGzMU2X4VPViK5oP/KPuPivOY1rhQdHNef6/uH8hds04jGWXbiWHEU6IFhBcJB2tJVu0mmFVi
	U7yIhnXNg4DjQ8HRkMZst+zglOPp4SNSgc8PJu88FXtXwwvZDGqdf52rkD6esqpnZBmbmyeWnj1
	LNHTrQRp6KatvbCk6fGx5upAZHwawXLmL+hImZ52eaNfZvD//M1RyuU5bZMEq4vX9wit4R10Uiq
	KV8Coh+UKxHl/1qqC+0j6nE
X-Gm-Gg: AR+sD13noZfcWvhFTaZmOsxcp8p9Do9+YKvtupoZFcMjGW3Bp3x8gMKDWSO8esGUUrs
	LvXhs8CsMeuQCzjeea/ZGFbn6kF8BjJHhKjkTzrkQFVdFD9wKyBjIoK/GaC8iuupj/a44mkCqf6
	EznxkLq0CmSLiUlezoEsLeI1nVc4W2/bv+QWLPx3deZOLcTA52HF8N2cfXG/n3SDQhJctw4q721
	HVP5N0CGLKslqh1q5qiJ38oeJjJAMkK3U5a41jaWOBRDK3r2+WVKENRME/afpKORExQ7q7+3R3a
	ACMx46oXKWg506x0CdYwYGTOHdjcWk+63+iQ1wZzkrxuUGwD4QTK9CI7lQJ6RhDYdJ2S9ywjI/l
	4hnr2aZUPvW75ymToy/bqmEOonKq/neBE7AaMtQAzOZJmZmNRc0umc+N8j7UnAvCRIpcef5u0Ry
	NS50ZdxeCACudEGYrnoHGz8BTjrOxA8U6UsVXm0ggzN/w=
X-Received: by 2002:a05:6122:221a:b0:5bd:73b5:6d2b with SMTP id 71dfb90a1353d-5c60deafa17mr10611237e0c.8.1787659777810;
        Tue, 25 Aug 2026 05:09:37 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-97c83279941sm780162241.1.2026.08.25.05.09.37
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:09:37 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c16740eb587so365753466b.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787659776; x=1788264576; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6op+UbzHI1KHB5KXyUkyXnyxTb462HgGtNx9JpJquH8=;
        b=br2KsHRsjZj74iWxJ2ek5T2t7PRBPyitJ+7+P8pxf+fwLodazZDHB9EIZ+Jfgxqqqd
         S/ji+oWgL7rTYWxlGfe3qLwSfbAeRamhK6H/KVn14nso00bHz8PcM11GBotWq9iAJt1n
         v/GqkplB0CuDvb4Ymwi+yjh6uu1rkZsy0L+Jw=
X-Received: by 2002:a17:907:8e86:b0:c1c:4db0:8314 with SMTP id a640c23a62f3a-c24e5b55335mr637061966b.13.1787659776151;
        Tue, 25 Aug 2026 05:09:36 -0700 (PDT)
X-Received: by 2002:a17:907:8e86:b0:c1c:4db0:8314 with SMTP id
 a640c23a62f3a-c24e5b55335mr637054166b.13.1787659775454; Tue, 25 Aug 2026
 05:09:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-9-chandrakanth.patil@broadcom.com> <20260818181328.867D91F00A3A@smtp.kernel.org>
In-Reply-To: <20260818181328.867D91F00A3A@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:39:22 +0530
X-Gm-Features: AcwNN1V9k4hTCVhdLv-o8dzzS_z3oUxwt68AJqkd7n3_vraCkHzF5wRYHaIiDbc
Message-ID: <CABvwm=NVp8RmHhwM4dSt1wRSLrZky0_s102t0=niRMeo6DMA5A@mail.gmail.com>
Subject: Re: [PATCH 08/17] mpi3mr: Fix out-of-bounds bitmap access during
 device removal
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000f68be20659ddf964"

--000000000000f68be20659ddf964
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:43=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> New issues:
> - [High] Placement of the newly added bounds check introduces a delayed c=
ommand queue stall and async chain breakage.
>
> Pre-existing issues:
> - [Critical] Concurrent lockless modification of delayed lists from proce=
ss and IRQ contexts.
> - [High] TOCTOU race window during delayed command hardware dispatch allo=
ws double-free.
> --
>
> --- Patch [8]: [PATCH 08/17] mpi3mr: Fix out-of-bounds bitmap access duri=
ng device removal ---
> commit 498a49c2b9e406ac25107bbe9cd216b5c786f292
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: Fix out-of-bounds bitmap access during device removal
>
> Device handles reported by the controller are used to index the remove
> pending bitmap and to build a task management request without being
> compared against the maximum handle the controller reported.
>
> Check the handle before using it.
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3=
mr_os.c
> > index f80a21ec161b6..7ae4b4fad3f4a 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -2401,7 +2401,8 @@ static void mpi3mr_dev_rmhs_complete_iou(struct m=
pi3mr_ioc *mrioc,
> >               ioc_info(mrioc,
> >                   "%s :dev removal handshake completed successfully: ha=
ndle(0x%04x)\n",
> >                   __func__, drv_cmd->dev_handle);
> > -             clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
> > +             if (drv_cmd->dev_handle < mrioc->facts.max_devhandle)
> > +                     clear_bit(drv_cmd->dev_handle, mrioc->removepend_=
bitmap);
> >       }
> >
> >       if (!list_empty(&mrioc->delayed_rmhs_list)) {
>
> [Severity: High]
> This is a pre-existing issue, but is there a race window here if the
> hardware request completes extremely quickly?
>
> mpi3mr_dev_rmhs_send_tm() sends the request to hardware. Only after it
> returns does the code list_del() and kfree() the delayed_dev_rmhs node:
>
> mpi3mr_dev_rmhs_complete_iou()
> {
>         ...
>         mpi3mr_dev_rmhs_send_tm(mrioc, drv_cmd->dev_handle, drv_cmd,
>             drv_cmd->iou_rc);
>         list_del(&delayed_dev_rmhs->list);
>         kfree(delayed_dev_rmhs);
>         return;
> }
>
> If the completion executes concurrently and triggers another call to
> mpi3mr_dev_rmhs_complete_iou(), could it dequeue and dispatch the exact
> same node before the first thread has a chance to remove it, leading to
> a double-free?
>
> Similar patterns seem to exist in mpi3mr_complete_evt_ack().
>
> [Severity: Critical]
> This is also a pre-existing issue, but I noticed there might be unprotect=
ed
> list operations on delayed_rmhs_list.
>
> The delayed_rmhs_list is appended to in mpi3mr_dev_rmhs_send_tm():
>
>         list_add_tail(&delayed_dev_rmhs->list,
>             &mrioc->delayed_rmhs_list);
>
> And it is removed from in mpi3mr_dev_rmhs_complete_iou():
>
>         list_del(&delayed_dev_rmhs->list);
>
> Are these list operations safe from concurrent modifications between proc=
ess
> and IRQ contexts, or should they be protected by a spinlock to prevent
> list corruption? Similar patterns exist for delayed_evtack_cmds_list.
>
> [ ... ]
>
> > @@ -2564,6 +2565,12 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3m=
r_ioc *mrioc, u16 handle,
> >       drv_cmd->callback =3D mpi3mr_dev_rmhs_complete_tm;
> >       drv_cmd->dev_handle =3D handle;
> >       drv_cmd->iou_rc =3D iou_rc;
> > +     if (handle >=3D mrioc->facts.max_devhandle) {
> > +             ioc_err(mrioc, "dev_remove_hs: handle(0x%04x) >=3D max_de=
vhandle(0x%04x)\n",
> > +                     handle, mrioc->facts.max_devhandle);
> > +             goto out_failed;
> > +     }
> > +
>
> [Severity: High]
> If handle >=3D mrioc->facts.max_devhandle, the code goes to out_failed.
> This frees the command slot synchronously but does not invoke the
> completion callback.
>
> If this was called from mpi3mr_dev_rmhs_complete_iou() to process a delay=
ed
> command, would this synchronous failure prevent any subsequent delayed
> items from being processed since the completion chain is broken?
>
> Also, because this check is placed here, out-of-bounds handles can still =
be
> appended to the delayed_rmhs_list earlier in this function when command
> slots are full:
>
> mpi3mr_dev_rmhs_send_tm()
> {
>         ...
>         if (cmd_idx >=3D MPI3MR_NUM_DEVRMCMD) {
>                 delayed_dev_rmhs =3D kzalloc_obj(*delayed_dev_rmhs, GFP_A=
TOMIC);
>                 ...
>                 delayed_dev_rmhs->handle =3D handle;
>                 list_add_tail(&delayed_dev_rmhs->list, ...);
>                 return;
>         }
>         ...
> }
>
> Should the bounds check happen before allocating and adding to the delaye=
d
> list?
>
> >       tm_req.dev_handle =3D cpu_to_le16(handle);
> >       tm_req.task_type =3D MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET;
> >       tm_req.host_tag =3D cpu_to_le16(drv_cmd->host_tag);
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D8

Thanks for the review.

New issues:
- The observation regarding the placement of the handle bounds check
is valid and will be fixed in the v2 submission by moving the check to
the entry of mpi3mr_dev_rmhs_send_tm().

Pre-existing issues:
- The lockless list operations and race window in delayed command
queue handling are pre-existing issues in the driver and will be
addressed in a separate follow-up patch series.

--000000000000f68be20659ddf964
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
oIHHMC8GCSqGSIb3DQEJBDEiBCDzGUTVjmGaqvy/v+bq9ufoV7mYQTfKsd0dG6N1cF8ZzTAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjA5MzZaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBcanAK8Zdl
GtgIHtQZZCqxU6KGhsjlJ7vFWsbRaStnlnPryBnq4alraupj9xeJl9KVrcMQImVJQGGEUZ88gPK7
L8IlS/1lJ4RnVIkm6LzwSOp5FqvYjabW+X8KmjgziIras0Jw3mrUN6RFgE4j2Cg3cICsvhQibK8r
qarveTi5bi6wxXgTJC65G8axQI+0IA5wO3xkdp3bTYR4OjXo8OiNJ8YP6DBnqVqnuJ0DOl1UTS81
XvMJyApu8WZacPgFSSUI2Xd+zij7TdqmhcCyD+9hY20aTY56SfTKTBRYZ96TCbYITg6b5K34mZ7F
u+HDL4jcfv6JBcFwB9Higf16HmfQ
--000000000000f68be20659ddf964--
