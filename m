Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C84B40098D
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 12:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659228; cv=none; b=nK0kPpYdbVQ51EjSWUQKPGwTeA7y8cgTl33ny3jo0enfG914d3ea+/IbuiIxUaPC30ZXfPngs+yn0kPH2lJqinjwJbWyMOYuQ2M4JBScra845+9eEZTniUT+uSyfAtlfm19h0fdk/MIUHuZzoZFeGJ0ElVVhu5DQtU+XE/4428U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659228; c=relaxed/simple;
	bh=kt8Zo6gNlZgFgQdZsuEM3uIdbhiQIGnAX9g0jiDtwwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uwBkXROPJxD9IZ5PS/Tb77dF4FBFzGVy/ARnnQHHQngGaAHzrER7dg++fkoiyGjx8+bRfNi7lTNNMxJupGBCvWN4y+6Jno3VVdg9JrHqipZ6TFShXGVcx5K7n8PuGb7kZInGXy5Nzwm8tIrqcq6AAB38adBsz50VnBvNW24+ONI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PhSitGEb; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PhSitGEb"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cbeea240819so2812736a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787659224; x=1788264024;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CSMCxWqJqykNnAn8V7lCdnvxdl0PIf1MfU2ojT5bGXg=;
        b=ZX1kzqO1vW584j2AH3tJ94uat9m0U5mdI3xVBbrd//cLkg6BRLeU7Yyz79mVpySDPS
         GIvIUh9K/qK1XA5bIyUAuCdun1qSa2torlLxobqq8FKNnM+0RSoITunyI6+Mm9hf4gEe
         LuhmAzwA3XrcOSJovj7aJ3tZnOwFA+t/uGUuBkA0hpfOlPly4AfEicVhzOVrB+Ii4xBD
         +y+lL6quR1XoZp5Lokr8ebO9LFqiWDYJF0NyLL4gFwEQQrn2Dm2ZSkKoeDW6O+ugmLMj
         5q3U07QKvNpKytrOapqZ1Sfd3bThJU9zgbbY2PD8pegiPBfoDk/gOPqMKZPj/DUw06iH
         NiJA==
X-Gm-Message-State: AFuF++nTdxa7sma9m4MqBfU6bZKIaIAEYvHKFV4U3C+PAYfDpovmX5ZW
	tU6/TNx5ReYUyMnvvfoYkspum1ajJTQXvDdlcq5OE4+QxevcFLjWd9JzywbhJqhsRBFhD9YP6Hn
	b0WZyHsMUFT5N89VvRgJa76Jjcucd5+NAvKRsS5YsDvsVkR5f+98RbhvSXLtwmsbyhmX7CWNU7X
	2j4ICw8PrKcXehBKQaYgwLLT+3f+h0hqYaZy/eVizcxHDhXPtnC7Qft3I29JSOPuK9DmyJthnKY
	VtYwIsogjp5aWDAWdKqAoru
X-Gm-Gg: AR+sD13WqwCqu+mcVL0r5CgHLnNdE7sIWAv5laztnAifAhJsi4Tv3Myw/s5yfzyzmxh
	ZvExBF12ZR4MWPfEHF+ZixW2K7GzToVd8JB3y7FWiBd7rA6W1u4hciIlh2fGd36ZM29o7ZIAcSK
	QlFsx1Am0MspPHvtgfxQ2eaYGmkUThZ1LTeoKVfpANMJO16gZiuOdcPkP5Kb1L5QsBGB3EaP1lw
	eYUrCZgziZp43XrV2xRNK2yz77x00eRIJCuH80NdnIpYtXEVf5REoFK+Vaf3thZWy8NlUXFgL43
	vpsxieQk7twR7C/LuupHs81RUnH2G6rqM5mtYRkDP6LD9J+6Rs56kmodBsW7Y6r08rsZ09KmZ/z
	QxSIZ5k4iYxWlyVxP8fMeFPZgUKlUnifR0bfvKL42iiGWXM1NtJKrSVAKAfMqy4WkfWO/cXjMKw
	zTZUTIekLH1tOBdi/G6rh77R26TEmeWZ0HYqYoEWzaLzI=
X-Received: by 2002:a17:90b:3bc6:b0:393:194d:5366 with SMTP id 98e67ed59e1d1-395c354da4fmr63671132a91.10.1787659221717;
        Tue, 25 Aug 2026 05:00:21 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39645b1a52esm1254957a91.11.2026.08.25.05.00.21
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 05:00:21 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a3f8cbd9feso5444263a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 05:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787659219; x=1788264019; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CSMCxWqJqykNnAn8V7lCdnvxdl0PIf1MfU2ojT5bGXg=;
        b=PhSitGEbutACHx/W0wSRdX9gdTBt7qC0dhlcuEW0z3Sk7MucBHLOIw7d53vkWk611y
         nmuQo+7ht9xSku9T9a4Gw/GlvCHsINyLyTWXMDm7Sq22NB3BqNmhd58Rkxn8oPM3jI5f
         Xbn7WK8YC1xnBGeSQhag8CCNlBhYScoeViwxg=
X-Received: by 2002:a05:6402:52d5:b0:6a0:a644:355e with SMTP id 4fb4d7f45d1cf-6a42f1848fdmr38376130a12.2.1787659219235;
        Tue, 25 Aug 2026 05:00:19 -0700 (PDT)
X-Received: by 2002:a05:6402:52d5:b0:6a0:a644:355e with SMTP id
 4fb4d7f45d1cf-6a42f1848fdmr38376038a12.2.1787659218630; Tue, 25 Aug 2026
 05:00:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
 <20260818231426.58105-2-chandrakanth.patil@broadcom.com> <20260818181445.E16AC1F000E9@smtp.kernel.org>
In-Reply-To: <20260818181445.E16AC1F000E9@smtp.kernel.org>
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date: Tue, 25 Aug 2026 17:30:06 +0530
X-Gm-Features: AcwNN1VAPTA4rWxBjUPsQoU9UTFgOrTogCkW2LJainwVlu7AupCZS8A-ecz2k54
Message-ID: <CABvwm=NVoHZ6md78xN7xkx9yEb6RXKPs0kteDVk7Rh-66oyKqg@mail.gmail.com>
Subject: Re: [PATCH 01/17] mpi3mr: Fix buffer overflow in BSG passthrough
 request copy
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000c6e4520659ddd8e5"

--000000000000c6e4520659ddd8e5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:44=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 5 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] Pointer arithmetic wrap-around on 32-bit architectures allow=
s bypassing bounds checks, leading to arbitrary kernel memory read/write vi=
a DMA.
> - [High] DMA coherent memory allocated for NVMe PRPs is leaked on BSG com=
mand timeout or submission failure.
> - [High] Target device `block_io` atomic counter is leaked if BSG command=
 submission fails.
> - [High] Lockless TOCTOU check of `MPI3MR_CMD_COMPLETE` causes a Use-Afte=
r-Free of `sense_buff_k` and data races on `reply` buffers.
> - [High] Missing validation of the BSG request length (`job->request_len`=
) allows a user to send an undersized request buffer, leading to out-of-bou=
nds memory reads and kernel panics.
> --
>
> --- Patch [1]: [PATCH 01/17] mpi3mr: Fix buffer overflow in BSG passthrou=
gh request copy ---
> commit ed6513158d24e842e223917348ef598d4d161609
> Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> Subject: mpi3mr: Fix buffer overflow in BSG passthrough request copy
>
> This commit fixes a buffer overflow in the BSG passthrough request copy.
> The check for an incoming BSG request size used a narrower variable than
> its source field, allowing large values to wrap and pass the check.
> The variable is widened to ensure the full size is validated properly.
>
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi=
3mr_app.c
> > index 1353a8ff9c85d..8e5d24793efd0 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> > @@ -2384,7 +2384,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bs=
g_job *job)
> >       long rval =3D -EINVAL;
> >       struct mpi3mr_ioc *mrioc =3D NULL;
> >       u8 *mpi_req =3D NULL, *sense_buff_k =3D NULL;
> > -     u8 mpi_msg_size =3D 0;
> > +     u32 mpi_msg_size =3D 0;
> >       struct mpi3mr_bsg_packet *bsg_req =3D NULL;
> >       struct mpi3mr_bsg_mptcmd *karg;
> >       struct mpi3mr_buf_entry *buf_entries =3D NULL;
> > @@ -2538,7 +2538,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bs=
g_job *job)
> >                               rval =3D -EINVAL;
> >                               goto out;
> >                       }
> > -                     memcpy(mpi_req, sgl_iter, buf_entries->buf_len);
> > +                     memcpy(mpi_req, sgl_iter, mpi_msg_size);
> >                       break;
> >               default:
> >                       invalid_be =3D 1;
>
> [Severity: Critical]
> This is a pre-existing issue, but can the pointer arithmetic nearby lead =
to
> an integer wrap-around on 32-bit architectures?
>
> When iterating over buffer entries in the same function:
>
>         case MPI3MR_BSG_BUFTYPE_DATA_OUT:
>                 sgl_iter =3D sgl_dout_iter;
>                 sgl_dout_iter +=3D buf_entries->buf_len;
>
> If a user submits a BSG request with a crafted buf_len, does the u32 valu=
e wrap
> the sgl_dout_iter pointer on 32-bit systems? This wrapped pointer could t=
hen
> bypass the later bounds check:
>
>         if (sgl_dout_iter > (dout_buf + job->request_payload.payload_len)=
) {
>
> and allow arbitrary kernel memory access during subsequent payload proces=
sing.
>
> While reviewing this patch, I noticed a few other pre-existing issues.
>
> > drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_request()
> > {
> >       long rval =3D -EINVAL;
> >       unsigned int reply_payload_rcv_len =3D 0;
> >
> >       struct mpi3mr_bsg_packet *bsg_req =3D job->request;
> >
> >       switch (bsg_req->cmd_type) {
>
> [Severity: High]
> This isn't a bug introduced by this patch, but does this function properl=
y
> validate job->request_len before dereferencing bsg_req->cmd_type?
>
> If userspace submits a BSG request with a request_len of zero, could this
> trigger a zero size pointer dereference and cause a kernel panic? Similar=
ly,
> if the length is too small, would this read uninitialized heap memory?
>
> > drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds()
> > {
> [ ... ]
> >       if (block_io) {
> >               tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle)=
;
> >               if (tgtdev && tgtdev->starget && tgtdev->starget->hostdat=
a) {
> >                       stgt_priv =3D (struct mpi3mr_stgt_priv_data *)
> >                           tgtdev->starget->hostdata;
> >                       atomic_inc(&stgt_priv->block_io);
> >                       mpi3mr_tgtdev_put(tgtdev);
> >               }
> >       }
> [ ... ]
> >       rval =3D mpi3mr_admin_request_post(mrioc, mpi_req,
> >           MPI3MR_ADMIN_REQ_FRAME_SZ, 0);
> >
> >       if (rval) {
> >               mrioc->bsg_cmds.is_waiting =3D 0;
> >               dprint_bsg_err(mrioc,
> >                   "%s: posting bsg request is failed\n", __func__);
> >               rval =3D -EAGAIN;
> >               goto out_unlock;
> >       }
>
> [Severity: High]
> This is a pre-existing issue, but does this error path permanently leak t=
he
> block_io atomic counter?
>
> If mpi3mr_admin_request_post() fails, the goto out_unlock bypasses the
> atomic_dec(&stgt_priv->block_io) that occurs after the completion timeout
> logic. Does this leave the SCSI target device blocked indefinitely?
>
> [Severity: High]
> Similarly, this is a pre-existing issue, but does the same goto out_unloc=
k
> skip freeing the DMA memory allocated for NVMe PRPs?
>
> If mpi3mr_build_nvme_prp() successfully allocated DMA memory in
> mrioc->prp_list_virt earlier in this function, the jump to out_unlock ski=
ps
> the success-path cleanup block:
>
>         if (mrioc->prp_list_virt) {
>                 dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
>                     mrioc->prp_list_virt, mrioc->prp_list_dma);
>
> Would subsequent commands overwrite mrioc->prp_list_virt and permanently
> leak the previous DMA coherent allocation?
>
> > drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_process_admin_reply_desc()
> > {
> [ ... ]
> >       cmdptr =3D mpi3mr_get_drv_cmd(mrioc, host_tag, def_reply);
> >       if (cmdptr) {
> >               if (cmdptr->state & MPI3MR_CMD_PENDING) {
> >                       cmdptr->state |=3D MPI3MR_CMD_COMPLETE;
> >                       cmdptr->ioc_loginfo =3D ioc_loginfo;
> [ ... ]
> >                       if (sense_buf && cmdptr->sensebuf) {
> >                               cmdptr->is_sense =3D 1;
> >                               memcpy(cmdptr->sensebuf, sense_buf,
> >                                      MPI3MR_SENSE_BUF_SZ);
> >                       }
>
> [Severity: High]
> This isn't a bug introduced by this patch, but does setting the
> MPI3MR_CMD_COMPLETE flag before the memory copy create a race condition?
>
> If the application thread in mpi3mr_bsg_process_mpt_cmds() wakes up from =
a
> natural timeout exactly when this flag is set, it performs a lockless che=
ck:
>
>         if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE)) {
>
> Could the application thread assume the handler has fully finished, proce=
ed
> to read uninitialized reply memory, and free sense_buff_k before the inte=
rrupt
> handler finishes copying into it? Would this result in a use-after-free w=
hen
> the interrupt handler eventually executes the memcpy?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818231426.58=
105-1-chandrakanth.patil@broadcom.com?part=3D1

Thanks for the review.

New issues:
- None. This patch specifically fixes a buffer overflow during BSG MPT
command copy by widening mpi_msg_size to u32.

Pre-existing issues:
- Issue #3 (block_io counter leak on post failure) is already
addressed by Patch 3/17 in this series.
- Issues #1, #2, #4, and #5 are pre-existing in the driver and will be
addressed in a separate follow-up series.

--000000000000c6e4520659ddd8e5
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
oIHHMC8GCSqGSIb3DQEJBDEiBCDU2jit1XVKm0OzIkIDYxYXjV5ZUQ5oXJFyGmyMi3QLZjAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4MjUxMjAwMTlaMFwGCSqG
SIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZI
hvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAUNa1Q1CaV
p6yEVvhLtHoE1tQDySY92F/LHqH/iy2Q+6H/eq89M90sYPVssgwJ9Lksi1/tOqAB0iBFSTuxitz+
zFpoh32LbWtjcoE3zy3/pIO03qyvTdVis1DjwKtZIHfhFbv2eYq8/oZh1xKAr9RvhCX/keGJzHGS
6j4vu/1yhYuEJA8fkPaTwtYOVOU3ZI59a6z3BydRxc7EDiRjKKeAJPOTbwHURdaMLbb09K5Emqhc
4Fr9ln0mYu9l4vqsiQ0pGTc4KY5LCJQjSjHoOn7k89RnzHhQLWPcpO6WQOop1symK4OsxKFtng5+
h7RphVMpssoi2XUqk5b//ljC0eJq
--000000000000c6e4520659ddd8e5--
