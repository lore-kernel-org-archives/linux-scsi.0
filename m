Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D099F41F359
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787660506; cv=none; b=FRP7vl+MAHPrjNYD2XmrY5mOHtYo5G0v0XGXT5EoxkPT7Cmd2b0gSFNO8GaTPVYn8+7tNWnW08bP32boHl/zAVSwhoJ4PGH8egOoT920eBr8IEvEzFRayzdA8UZSlRaFbuXj4lKIBQ+XbdtH52E6z8fmVtGjP5KcQhKtzvy90Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787660506; c=relaxed/simple;
	bh=0uliIV/7qOiPXfORttlKypFR0cVcaPHzxbAULGWPqEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HoYqUucAey4OQCqdtMNBO5ITu2nsd4uu7Cp5ndhJ6qTSAFtxEDhL0AIkLoNNhwlcbMacVTVH5XIe3AV6Y55mP68E1OQ1rXYx36AoFHmr2v1Z7K2HiQZ9D/hkAP0pblYXkXMDoNMiiwa6z58WTKf6baEa2ozZs3l0Jnf7hmuuATo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=R7O2plXw; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="R7O2plXw"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3900e39d935so5101840a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787660487; x=1788265287;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iVU/2MMx6hHnYoERgrrBq/D16JN5J0gXxx1g80d+4OQ=;
        b=X7bzhpoaCkAtMNqCD6nG68zPU5lspeE+3cdzSPhLl5utgDurpt/oKsSGR4qT3ruLZm
         zGJBcljYNPc1GRHEMYNIBpg5fyoie3MKy5iKgkEoVfCfVTAx3HD0xlHLuYTtnm/BUrL6
         YZuielyWM+OkeCeCDz+xh+QXCrDy0Wkj+MFf60QqIlNJe5zarYXkts13HrJusifqU4OF
         04WYIHULhM4mvRzYE1KXwNJ6KZUHuxOOAnUfxZTc2RONy6MWs+VmUOONM4oe2D9kFEA/
         KsY55Z40rONRFzstPkQNfj3lGfm3vKlqzG2bSG2ZnE2hVxrOUCU1nLiRbvV7im9IzyRW
         v/zw==
X-Gm-Message-State: AFuF++lHa7yrY3HaNJzUV7YiAkUTTfZOvwl+bqQHUXWvbad+y0aQOeLK
	EE96yKhi9FNge2KReQCvqqb3yAqEyXNKnfYJxJMM9mzvKlz0QsG+UHoEtQRj4q8koERf1X4QiHV
	L7ZBIh7OvwXpInasdHWBZJyaN4jhvvrxmX7d70tNAjFgZ5oEMU9NvcjYX1ZUQCRO4aaKuPAxnEe
	SBOPpeBZ6US2O6lQhnkXviA8R02dYXw0JbRFXWspmAMAWTNKZu6mLKfmIQ6TizbMDcSw/10WpD+
	ABhBd5AkcXVbOqXW4R5kgHV
X-Gm-Gg: AR+sD120+w0kuJUAXXMwyOc2YAUPaR/w3SgG5F6DcuahbiY1i138WD3zfI3Le2u4aQO
	4V4Ha55AC8CJ9dokis0RasHEoMJHg50xxH5fJ0LpE6Khecub7YEzD2jYUklIJ99KyDuuotqHlRT
	MlZJSGxgbuhI7BKjuyMZrs8xXH+W/sJL3Yj+KCz3nxqqd2zR/1ogjAVmWR0bbS06rVwvfFGuTY2
	+Ua9WqCMoP94oEtpSJBlSILA1ARP7san/eCw6jeurGm5ujH2NfI+T4FU0/Gd5v2TlwL8gNFxvLL
	1I0FkxzcFqC3cN8mTd63p+C1ibwcOhV7zwiiSpoNHR13PkYqwwXT6MGBPtBk2NUypZt915MfleS
	eHa2Zi7Myvz6i8H0Uk7wExdIbczgiWaBfX/qfO6oQsiqTKfPgNCxqttfjZkQdK11JrdAzLHU7MW
	x5uG+HVRh3UTST0V8peF2d61LDA0R8TwOAEX1WPEUBO2A=
X-Received: by 2002:a17:90b:5706:b0:38f:de97:b06 with SMTP id 98e67ed59e1d1-395deea4a72mr50535276a91.5.1787660487405;
        Tue, 25 Aug 2026 05:21:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39645c58313sm1271798a91.8.2026.08.25.05.21.26
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:21:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15fff01a30so294555266b.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787660485; x=1788265285; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iVU/2MMx6hHnYoERgrrBq/D16JN5J0gXxx1g80d+4OQ=;
        b=R7O2plXwLUog7/eBbLmGC2jdA6eImBrG3SC6eyxdo9VDAXHOJ4ODkxSomKy3T1XMhA
         g1yXSQzZGM8f7cFDLury+jxo4Go0EYi060FzfQ4nHLyrWR8iivMLwysA8PCD6GnefsTC
         86QdROb5hBYjBbgQro+jzauzAuqdrVRcQ1gO4=
X-Received: by 2002:a17:907:5c5:b0:c20:f6d9:d8c7 with SMTP id a640c23a62f3a-c24e5c0d2d7mr643430366b.24.1787660485235;
        Tue, 25 Aug 2026 05:21:25 -0700 (PDT)
X-Received: by 2002:a17:907:5c5:b0:c20:f6d9:d8c7 with SMTP id
 a640c23a62f3a-c24e5c0d2d7mr643424666b.24.1787660484646; Tue, 25 Aug 2026
 05:21:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-18-chandrakanth.patil@broadcom.com> <20260818183223.B90ED1F000E9@smtp.kernel.org>
In-Reply-To: <20260818183223.B90ED1F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:51:11 +0530
X-Gm-Features: AcwNN1UEJAAr2zNOE0ngWzZwtuLIypR8Nz7OpKyeLvnGkxdY54gwLoITZGTW9V4
Message-ID: <CABvwm=PRFH1cdco_o0MLbEK1cGhjwawaxxtRyy=kyvaWQzN9ag@mail.gmail.com>
Subject: Re: [PATCH 17/17] mpi3mr: Fix NULL pointer dereference on PCI error recovery
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000003c10d10659de2458"

--0000000000003c10d10659de2458
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 12:02=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 5 potential issu=
e(s) to consider:
>
> New issues:
> - [High] Calling `mpi3mr_cleanup_fwevt_list` during PCI error recovery ca=
uses a deadlock due to a race with the fwevt worker thread calling SML func=
tions.
> - [High] Setting `stop_drv_processing =3D 1` during PCI channel freeze br=
eaks transparent I/O recovery by permanently failing commands with `DID_NO_=
CONNECT`.
>
> Pre-existing issues:
> - [High] Unprotected and unreferenced access to `mrioc->current_event` an=
d `fwevt` in `mpi3mr_cleanup_fwevt_list` leads to a Use-After-Free, exacerb=
ated by the patch executing it asynchronously during PCI error recovery.
> - [High] Skipping `cancel_work_sync` for events blocked in the SCSI mid-l=
ayer (SML) leaves the worker thread running, allowing access to unmapped re=
gisters on suspend.
> - [High] Missing memory barriers between `stop_drv_processing` and `mrioc=
->current_event` allows the worker thread to bypass the abort check and acc=
ess unmapped memory.
> --
>
> --- Patch [17]: [PATCH 17/17] mpi3mr: Fix NULL pointer dereference on PCI=
 error recovery ---
> commit 21853a66ae88d53ee80d24101e9ce79158e66a4e
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: Fix NULL pointer dereference on PCI error recovery
>
> On a frozen PCI channel the driver unmaps the register window and frees
> the interrupts, but leaves the firmware event workqueue running. An
> event handler that is already in flight can still reach the register
> window after it has been unmapped. Stop event processing and drain the
> queue first, and start it again when the channel resumes.
>
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -5972,6 +5972,8 @@ mpi3mr_pcierr_error_detected(struct pci_dev *pdev=
, pci_channel_state_t state)
> >                       return PCI_ERS_RESULT_DISCONNECT;
> >               }
> >
> > +             mrioc->stop_drv_processing =3D 1;
>
> [Severity: High]
> Does setting stop_drv_processing to 1 here break transparent I/O recovery=
?
>
> If mrioc->stop_drv_processing evaluates to true in mpi3mr_qcmd(), it
> preempts the block_on_pci_err check. Instead of returning
> SCSI_MLQUEUE_HOST_BUSY to allow the midlayer to safely pause and retry
> I/Os once the PCI channel recovers, it causes all incoming queued
> read/write commands to immediately fail with DID_NO_CONNECT:
>
> mpi3mr_qcmd() {
>     ...
>     if (mrioc->stop_drv_processing && !(mpi3mr_allow_scmd_to_fw(scmd))) {
>         scmd->result =3D DID_NO_CONNECT << 16;
>         scsi_done(scmd);
>         goto out;
>     }
>     ...
> }
>
> Could this lead to immediate I/O errors and potential filesystem corrupti=
on
> instead of transparently pausing I/O?
>
> [Severity: High]
> This is a pre-existing issue, but does the lack of explicit memory barrie=
rs
> here allow a race condition?
>
> The synchronization between writing stop_drv_processing here and reading
> mrioc->current_event in mpi3mr_cleanup_fwevt_list() appears to be lockles=
s.
> Concurrently, mpi3mr_fwevt_bh() writes mrioc->current_event and reads
> stop_drv_processing.
>
> Without smp_mb(), could the CPU reorder these operations such that
> mpi3mr_pcierr_error_detected() reads a NULL current_event while
> mpi3mr_fwevt_bh() sees stop_drv_processing as 0? This would let the worke=
r
> continue and access PCI registers after they have been unmapped.
>
> > +             mpi3mr_cleanup_fwevt_list(mrioc);
>
> [Severity: High]
> Can calling mpi3mr_cleanup_fwevt_list() during PCI error recovery cause a
> deadlock?
>
> During PCI error recovery, mrioc->block_on_pci_err is true. This cleanup
> function reads fwevt->pending_at_sml locklessly. If the worker hasn't yet
> set pending_at_sml to 1, the cleanup function sees 0 and calls
> cancel_work_sync(), which blocks the PCI error handler.
>
> The worker thread could then set pending_at_sml to 1 and call SCSI mid-la=
yer
> functions like scsi_remove_target(), issuing I/O commands like
> SYNCHRONIZE_CACHE. Because mpi3mr_allow_scmd_to_fw() permits these bypass
> commands, mpi3mr_qcmd() will hit the block_on_pci_err check and return
> SCSI_MLQUEUE_HOST_BUSY.
>
> Since the SCSI mid-layer retries indefinitely, the worker thread remains
> permanently blocked, and cancel_work_sync() deadlocks the PCI error handl=
er.
>
> [Severity: High]
> This is a pre-existing issue, but does the asynchronous call to
> mpi3mr_cleanup_fwevt_list() introduced here exacerbate a use-after-free
> risk?
>
> In mpi3mr_cleanup_fwevt_list(), mrioc->current_event is read locklessly
> into a local fwevt pointer. Concurrently, the firmware event worker threa=
d
> might finish its execution, drop all references via mpi3mr_fwevt_put(), a=
nd
> free the mpi3mr_fwevt structure.
>
> If mpi3mr_cleanup_fwevt_list() accesses fwevt->pending_at_sml or fwevt->w=
ork
> after the last reference is dropped but before mrioc->current_event is
> set to NULL, does this trigger a use-after-free?
>
> [Severity: High]
> This isn't a bug introduced by this patch, but does skipping
> cancel_work_sync() in mpi3mr_cleanup_fwevt_list() when
> fwevt->pending_at_sml is set leave the worker thread running?
>
> If the event is pending at the SCSI mid-layer, the code sets
> fwevt->discard =3D 1 and returns early without stopping the worker thread=
:
>
> mpi3mr_cleanup_fwevt_list() {
>     ...
>     if (current_work() =3D=3D &fwevt->work || fwevt->pending_at_sml) {
>         fwevt->discard =3D 1;
>         return;
>     }
>     ...
> }
>
> During operations like system suspend where pci_err_recovery is false, th=
e
> caller unmaps mrioc->sysif_regs. Once unblocked, the worker thread contin=
ues
> to mpi3mr_process_event_ack() and mpi3mr_admin_request_post().
>
> Since pci_err_recovery is false, it blindly dereferences the unmapped
> mrioc->sysif_regs to post the request, causing a kernel panic.
>
> >               scsi_block_requests(mrioc->shost);
> >               mpi3mr_stop_watchdog(mrioc);
> >               mpi3mr_cleanup_resources(mrioc);
>
> [ ... ]
>
> > @@ -6069,6 +6071,7 @@ static void mpi3mr_pcierr_resume(struct pci_dev *=
pdev)
> >
> >       if (mrioc->block_on_pci_err) {
> >               mrioc->block_on_pci_err =3D false;
> > +             mrioc->stop_drv_processing =3D 0;
> >               scsi_unblock_requests(shost);
> >               mpi3mr_start_watchdog(mrioc);
> >       }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D17

Thanks for the review.

New issues:
- The observations regarding stop_drv_processing and
mpi3mr_cleanup_fwevt_list() are valid and will be fixed in v2:
  1. Setting stop_drv_processing during pci_channel_io_frozen caused
mpi3mr_qcmd() to fail I/Os with DID_NO_CONNECT instead of pausing them
with SCSI_MLQUEUE_HOST_BUSY
     via block_on_pci_err. In v2, stop_drv_processing and
mpi3mr_cleanup_fwevt_list() calls have been removed from
pci_channel_io_frozen.
  2. To prevent in-flight firmware event handlers from accessing
unmapped MMIO register space during PCI error recovery,
mpi3mr_fwevt_bh() now checks mrioc->pci_err_recovery
     and safely skips event processing when PCI recovery is in
progress. Incoming I/O remains safely paused via block_on_pci_err for
transparent recovery.

Pre-existing issues:
- The lockless current_event UAF in mpi3mr_cleanup_fwevt_list(),
missing cancel_work_sync() for pending SML events, and memory barrier
observations are pre-existing issues
  in the driver and will be addressed in a separate follow-up patch series.

--0000000000003c10d10659de2458
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
oIHHMC8GCSqGSIb3DQEJBDEiBCD8KveVI0uxHIa6V3enaaroBkT5hqD5o0VwngED74TjHzAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjIxMjVaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAU7CCctauu
FrO1wyVYNRngWszv8ruEtifWx88XlcDYh9r4A9hjgaCr6xcNuHjCPTp/MWTfUUF8PZmU7Wqf9kfk
xMzFsAOg8edKl7XZnlm+60qKVfeIrHf2WxCqBDQAj0503bKN7S34Eqpj6/eGgYgb9TFP7nqpMN6E
9aEBv2SE0UbuDmOY7HXy68TTf4tpdCCS6PiQ/MbH0mhZ8Sq4ZMcjFPxHPdUZgpcsyfRY2Tb65Rzn
/clSiY1m3xCo5G4DujBvbkzNMxcMplYf1RJohBAnH25YXmm4TT8Tk7N4y/l2MRRXjmxvWteJjh3I
RiiFbYbHQJCyEbgPPfc7OoEJpH68
--0000000000003c10d10659de2458--
