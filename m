Received: from mail-pf1-f227.google.com (mail-pf1-f227.google.com [209.85.210.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132AB349CCD
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659384; cv=none; b=jYrREQ2onJd/ZevRlqVbkM2dXBpsVSIdh9q1pLYa+0SQEvgRyWtHFWSHlUa2cAz8DJ75996q82HRTjMp7W82RNHLlzPOj2yVoeWluxIo/r+eXjNJv7uAUr1A81k1B8AjKgJCVeL2g/QBhMQiNdMtX+ZYqQE2NzEA7pZuFGApIkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659384; c=relaxed/simple;
	bh=ovvlq0ibqY16iPbQ2d4D6uuoA5MkxtE0kvZZ3BRkO1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AncndgYScIktIofSin1NWlhlFHZBxftKMYouPOkKPxztoI7jcxTTNqlG5m964PmL9N411X3ustWRJ9n3HQz7VL6c6dLL+y6SAZiyRM0AeNlo0nnzGpSFRQ3dccASYlg2n00mWpF5bWhkCCNynCipAV9066IWBFofGfHgiaaQ5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Xcd5zpFr; arc=none smtp.client-ip=209.85.210.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Xcd5zpFr"
Received: by mail-pf1-f227.google.com with SMTP id d2e1a72fcca58-8485b358552so1898388b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:03:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787659382; x=1788264182;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=17H3Nn/fwYXnRIA+qVdEKEpt+rzuU8oxJxCQRB81GNg=;
        b=f+GLc9z53EliBBJtyRlftVTOVn6BsYdbasfNCx1bNZh+yeeVKn8Jyz6v+Nw21TOepU
         yt8CvnU6x4ZY8YmUJcRBTSwsctN3EjpVgqg4/TKiY2XPzvcupYN1Gpfi1XCSj+Z/I4Ev
         4oGlUZ9bOwhFoDFhhJpAlsGKIyxSFcPSsv7nKh9m7ZZjnBhokB70irWoFH1NpFwp1B5S
         tnvtUALk/AW7WV1BP5dehpngvtLGJiWDK1QNIgTIYEYus2uNmY7pUF9jtFOeIbrQ6FQW
         i+yS5keT2V6Eb4TPKWGJ/uMnAQbrWl/wgpZcILKVLH6kA8zCOXTucfQa06hrpr/qjAh6
         e8HQ==
X-Gm-Message-State: AFuF++nBtK2vtzAdBvFA6rsmJqDCiHOPlxZBqjyzkF0c115eY13gWGI9
	dho322Z62OiRwaeAb1XGMVMU8mZJzXrWAtEUfjZ35azKfiHoTU9SsdLxn5bjhdHtB/dvu+VYqWk
	N5wSabDpU/PM/0/AwTM+cvnyaSKar01UFooImwkyMs+ET7xpfunCDI4bM8cz52ckHY3SsyHc4eH
	HRHf5mi2r0Z187TTBjChIgq0D5VxrTdOJydrKIxo7awnlYe5j0Xyh3cvq1rE329WxFd/1Cxt3X6
	12auEN36Ml08v+Uk2QU6Fg3
X-Gm-Gg: AR+sD13WNJDSRUDHCyqwRsO6czW7Z5dNRSQFAjUgQxliv7lz4vpIm53tRAzzkbe3v6s
	aoLN8KXaQWTib6xmlS8Zz2JhnmNAFAgyqYmTUm654ChSvSG8ammi7lGfKk/wmCEXzbI4clm7xtT
	yXOtQdqVn9f8omzsZHKZEGlowiI7tOkI3agpt4PfWkzrXyRK0hzXsjkuzb6tU9Gu9Dk8tRV8mxt
	pvuoxyBML/BJnrWONfajVDQfAeSqZKbYCWwg0ESYTeglB7+5nwQJ2nLPAYIR9PJsBZDzQBqgXyD
	Uw8WHWkCCLvq8JYzCoGdU51g/0WwC1xKKGfpmpnhFi3LI+oW54tg7UfqiirDj9eGKVO8xszjTba
	XkMu1imQzEWb4DuuUJxwotA+MoBPNYSFU+XVg6Pd26z0Ic92D4EoHNwpTzdireF8sWeWi+ovjpv
	xZmrga1xkEIQFLUyB1fYRwo/KrxTUfZPAkoJ3fv4E/omtEiQ==
X-Received: by 2002:a05:6a00:2283:b0:848:3f07:c5a2 with SMTP id d2e1a72fcca58-851f9bb67d5mr57740675b3a.4.1787659381844;
        Tue, 25 Aug 2026 05:03:01 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-852102693dasm5047257b3a.1.2026.08.25.05.03.01
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:03:01 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c1630a90890so326249866b.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787659378; x=1788264178; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=17H3Nn/fwYXnRIA+qVdEKEpt+rzuU8oxJxCQRB81GNg=;
        b=Xcd5zpFrJGJaebwRk70dlPjWN8uYHDNNVmP2/njxUPIBMnPQxHfZW/h1jHZJMHyfS3
         4jdBSNG+H24AgEFJNmeqWb5iui+ruWv3ABpZlU290cI+At/r2nfHs8cX98EnkbyAqwnV
         kKpp7c8FMS6swpyCTu/885UQ4RZylAvm51MMs=
X-Received: by 2002:a17:906:81d8:b0:c16:12ff:dc93 with SMTP id a640c23a62f3a-c246a6ca584mr3088944666b.18.1787659378555;
        Tue, 25 Aug 2026 05:02:58 -0700 (PDT)
X-Received: by 2002:a17:906:81d8:b0:c16:12ff:dc93 with SMTP id
 a640c23a62f3a-c246a6ca584mr3088936766b.18.1787659377959; Tue, 25 Aug 2026
 05:02:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-3-chandrakanth.patil@broadcom.com> <20260818181511.75BDB1F000E9@smtp.kernel.org>
In-Reply-To: <20260818181511.75BDB1F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:32:45 +0530
X-Gm-Features: AcwNN1XSCYKA_lTmPmP4hry_7_KUZ2M0Z9aRq9LVID3g4DN2NmTwJ_TzVVVVtRo
Message-ID: <CABvwm=OM7-iDg33KL8TksqjUjEZx1yk_oJhwAayvKznrLjuADA@mail.gmail.com>
Subject: Re: [PATCH 02/17] mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000004358360659dde2b3"

--0000000000004358360659dde2b3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:45=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 4 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] On 32-bit architectures, pointer wrap-around and integer tru=
ncation bypass buffer bounds checks, leading to arbitrary kernel memory rea=
d/write.
> - [Critical] The driver fails to validate the user-provided `job->request=
_len` before casting and parsing the BSG request packet, leading to an out-=
of-bounds heap read and a kernel panic.
> - [High] Failure to decrement `stgt_priv->block_io` on early failure of `=
mpi3mr_admin_request_post`.
> - [High] DMA coherent memory allocated for PRP lists is leaked on command=
 timeout or post failure.
> --
>
> --- Patch [2]: [PATCH 02/17] mpi3mr: Fix out-of-bounds read when copying =
BSG MPI requests ---
> commit 0259dbaa420364e7270c5c71574f90668291edf7
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> mpi3mr: Fix out-of-bounds read when copying BSG MPI requests
>
> The MPI request is copied out of the caller supplied payload without
> first checking that the requested amount is actually present, so the
> copy can read past the end of the payload buffer.
>
> Check the range before copying.
>
> Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
> Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi=
3mr_app.c
> > index 8e5d24793efd0..1cd1c38dcd565 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> > @@ -2538,6 +2538,14 @@ static long mpi3mr_bsg_process_mpt_cmds(struct b=
sg_job *job)
> >                               rval =3D -EINVAL;
> >                               goto out;
> >                       }
> > +                     if (sgl_iter + mpi_msg_size >
> > +                         dout_buf + job->request_payload.payload_len) =
{
>
> [Severity: Critical]
> This is a pre-existing issue, but can pointer arithmetic wrap around on 3=
2-bit
> architectures and bypass this new bounds check?
>
> If a userspace application sends an MPI3MR_MPT_CMD BSG request with a cra=
fted
> buf_len (e.g., 0x10001000) such that the sum modulo 2^32 remains small, t=
he
> sgl_iter pointer wrap-around could mathematically bypass both the end-of-=
buffer
> limit check and this newly added check.
>
> Concurrently, can kern_buf_len / MPI3MR_IOCTL_SGE_SIZE truncate from 0x10=
001
> to 1 in the u16 needed_desc variable in mpi3mr_map_data_buffer_dma()?
>
> This would bypass the descriptor limits, allowing the driver to create DM=
A
> mappings for arbitrary kernel addresses.
>
> > +                             dprint_bsg_err(mrioc, "%s: MPI request bu=
f exceeds dout_buf\n",
> > +                                            __func__);
> > +                             mutex_unlock(&mrioc->bsg_cmds.mutex);
> > +                             rval =3D -EINVAL;
> > +                             goto out;
> > +                     }
> >                       memcpy(mpi_req, sgl_iter, mpi_msg_size);
> >                       break;
> >               default:
>
> [Severity: Critical]
> This is a pre-existing issue, but does the driver validate job->request_l=
en
> before casting and parsing the BSG request packet?
>
> If a userspace application submits a BSG request with request_len set to =
0,
> the BSG core invokes memdup_user(), which returns ZERO_SIZE_PTR (0x10).
>
> Will the driver unconditionally dereference this pointer here?
>
> drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_request() {
>         ...
>         switch (bsg_req->cmd_type) {
>         ...
> }
>
> Could this lead to an immediate unhandled kernel panic?  Additionally, if=
 a
> small non-zero length is provided, does the driver read bufcnt from the
> unvalidated payload in mpi3mr_bsg_process_mpt_cmds() and loop over unallo=
cated
> heap memory?
>
> [Severity: High]
> This is a pre-existing issue, but is there a missing decrement of
> stgt_priv->block_io on early failure of mpi3mr_admin_request_post()?
>
> When processing a SCSI task management request that specifies blocking I/=
O,
> stgt_priv->block_io is incremented. If mpi3mr_admin_request_post() fails,
> the code jumps directly to out_unlock:
>
> drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
>         ...
>                 goto out_unlock;
>         ...
> }
>
> Does this skip the atomic_dec(&stgt_priv->block_io) matching the earlier
> increment, permanently blocking all future I/O to the affected SCSI targe=
t?
>
> [Severity: High]
> This is a pre-existing issue, but is DMA coherent memory allocated for PR=
P
> lists leaked on command timeout or post failure?
>
> When an NVMe encapsulated request utilizes a PRP list, mpi3mr_build_nvme_=
prp()
> allocates a DMA coherent buffer in mrioc->prp_list_virt.
>
> If mpi3mr_admin_request_post() fails, or if wait_for_completion_timeout()
> times out, the code branches to out_unlock without freeing the memory:
>
> drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds() {
>         ...
>         if (mrioc->prp_list_virt) {
>                 dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
>         ...
> }
>
> Would a subsequent NVMe command blindly overwrite mrioc->prp_list_virt wi=
th a
> new allocation, permanently leaking the previous DMA buffer?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D2

Thanks for the review.

New issues:
- None. This patch specifically fixes an out-of-bounds read during BSG
MPI request copy by checking that sgl_iter + mpi_msg_size does not
exceed the payload length.

Pre-existing issues:
- The block_io counter leak on post failure is already addressed by
Patch 3/17 in this series.
- The pointer wrap-around on 32-bit, job->request_len validation, and
PRP DMA memory leaks are pre-existing in the driver and will be
addressed in a separate follow-up series.

--0000000000004358360659dde2b3
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
oIHHMC8GCSqGSIb3DQEJBDEiBCBk/h3MlnUzOqrlOFBCWlH+DGjtHg/Ma6qf5vCsP0Yi4zAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjAyNThaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQADA0wBW1sg
o8M36y6QXdq7YmqYrz6RAob4m9pS1k1RSn7L6UzNTB3ZgVJP0964ZHwDUT4wZwtLeNhUIvGtx8S1
enqJd8/8gV9c62W2ymiamLghQ9zKEbLADVj/9756ChiWxOHnt0HXumW1DaA+c8Qsnb6vwWwPOL+K
VznULW/oJ/g5F+IIYx/6KpIcl9lqLPX+ty8OtELyPGdRcYDrYMie8RbmQwEDVfPAOxcBiLiaQun5
RMYr25mvFitW4Dt0CpMjuWk3TGHKezDx6op4rSXFNsBG3pW36HR2FVmT5dH3bovan5CgDSDKGgd4
dGH/CpiBwM04pGnrh+PyZfvSTkdy
--0000000000004358360659dde2b3--
