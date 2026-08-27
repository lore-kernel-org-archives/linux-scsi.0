Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871CF4B0480
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 19:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787860403; cv=pass; b=EAciorD4CnWRppovB31tYJbvhiXEloKA+RG3gATVAnVCz17phPoG7R4mSwYrgahFW8E0uZEDgvyOV5aEQqDiBY0aP8XNcSydMz+Sn8Jk1yvtdQ7jOiDN3hMxHrDc5JxUzj4g0Dno8iFdqglpXvcgctT+MdPLi2MBJVUhDyZy1+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787860403; c=relaxed/simple;
	bh=gVjMhbAwFcmGN4yhqQ+ojB2Np3m6fVMAekUHo9EEer0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ur+EgxLE7AmzB31hMg2G+JpqVtV4LgrADs6SxbRJNluwqhy44zXQvoxg45jMJhgNhu2WeURNP0Yivcv6GLQV65F/0zec6FCEdWy7tuLZucti2B6jFTtWE01l/0Kvy/lZMMwtXiYeYWX8wdH1ASfmQW04UITYfNl52M2xp4/aNfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KKqnjruD; arc=pass smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KKqnjruD"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-459bd8ea98aso16007fac.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 12:53:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787860396; cv=none;
        d=google.com; s=arc-20260327;
        b=oCGz1PRyNUankxnh0f1NEPMY3lZZJbBjvANUHc1UaYqt6Fxmxjd+GK/VvIvmjCzh3y
         AcBstmFroEYJAwddFqMYchucvI3+Hojmx86FCvoZgQ3f9oM32mOC2WUfENx79r4rYJgQ
         /LU3uWSJfHSAfmVO1YYKIEKyrFnA1Oe8ocae7VIWC+mZDoOKb5eK9Y1PYBTMVlUQGnbe
         HPeOs+sueNlQJFy94lY3bRJ36fakjsuTyOzzsPcbF9kgZClxQaaITuqn3ZKrnbZPJncZ
         KeTImd5hv1OzWQ0pfG/tCPaMU8sZjJVUani/mtrJN7C/cWIPU0HWtC7PvwbGAMGnCNN/
         yEaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h/okYFTS2lL08kFzVd4eJiLNff++PKarqdGjVYshS7E=;
        fh=isiogoDDiKCC6jyK2J76iE7jU+NRi05jWTzvkvruoP4=;
        b=R1RIqd/qKyfPLhVjqk023vSqXAlc9cfRx6SYFcifNHdsHBOo1bdwoDjAz40pJrWX8n
         g3M5ThXd93rSqsMCjCxM/UEfbel5lYp8YIcbNnhEmQt3G5JHLpMC3oJVCZacNXSW36Nc
         YPn7luwcxdPMZEHzLGGFrs/8DMNF2APz8IZcAA60j1awIwLymYwFusIvQX0LIA5T0C6L
         gHyvRuHeibi5I0GsLqv0NKhCoD185DJPt0d+aj+do68JUMhJJnhcKg0t6qZDxY5xwYjM
         abpqiaUGfNeBGuXZyVnpO3zcmijhFmN6n7frsrLXjC4cUk6OdgUgyPTomMkRP2uk78X9
         G+wQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1787860396; x=1788465196; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h/okYFTS2lL08kFzVd4eJiLNff++PKarqdGjVYshS7E=;
        b=KKqnjruDG7BgYYNvYkguIGiSe2cfKaWpoRjv6XjJVVVK3K9go9A0iUqSjQKa1h3lJ+
         Dc6IFJPFk2mrQj9iR53f9go+aPmEYPio4RlVh24DjTYNHcIUnLMSisI1YRckGdr0PpHr
         K6Esaz2Rut7fbayN0gKJSpPh8jqhfFHDguBg4Hv6yv1mvCaQaKvLFNbnXiopx5xjTT4+
         0YsYLK9COp1lnYfZVAjEELN9mrvsss/y8/HJ15+g4lA78KAnPVUSZa9CfYKjCwYmzV/d
         a4URMNX+8DNZ7cQtawU5J3ZkU5L/GFpsSE236xAjswe+06MDKzjvFzqp00nKTz4ua8gV
         V3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787860396; x=1788465196;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h/okYFTS2lL08kFzVd4eJiLNff++PKarqdGjVYshS7E=;
        b=qpuihmVL4zWubI/iIWqO1eyEfnb2CbsxZMrERFUSyaYEXEquHWFk6/SzakakJReVHW
         KJcC5gXX27jAbL4eO8NggFfaZrec6L8V7wFtpRNXatEybA0WVW4mi2Kz3s78rqv5pd/k
         nFPhbFW8JLEwCffjKTSsZR1BKocUc/T8ux76DDxrgZqYg+xN1/n4xsrEJvqeTVGKGDEH
         gZ9kJW2zWQyHRPvGNaAOaGaheJ3ArQhPB/iiXiY95F7z/BlteuO0rbH6t/DQvdKU4Uc8
         Vkk3LFyxysPm9Ycs20FfC4AzJlZIv72AWMo9xzzwOLmAFXLduzPOCkK6D51igI3FfXj0
         kOSQ==
X-Forwarded-Encrypted: i=1; AHgh+RpIdqR+wbMAKiq2ORpZG49q55owpOvRNB+GwqJY2Qb5CKy9Fc8guIIR68vITn1d1WZT5UUPZCDt97Vg@vger.kernel.org
X-Gm-Message-State: AFuF++l+LVPBhDvtPTJFd1jHJFTSfRyyswkIVrLJinwTjpDSnuzGhG0I
	z4RFISLwPve6AcxR4+SePeM00skAz/xsHzjJO37OctPcj2kzdBIbdvoQ/nbCKIA4gnRqQZ+IXAz
	p7MKI5jA3fq+1MUnPL09lC+DEnrBtowbzTy7DQbqSblqvsMpXWvO2lN0/zQ==
X-Gm-Gg: AR+sD13BCr9UCpyTyx1ueAJ0xkSsTuzE/+2ehRu6Mq6E04gvuP5owP8jpMg1uu8QwbM
	xTUKmM5p+cpUBRY4cNQJp/UhaWblwT65iWKt+hAgVPI+4wHi3P94RCsFi2Q0F+mGb5FhaIm2/ye
	qw0ctgPYWRB7dhkKo4vLFFgLMweBByay8fOqphzqQr64eOWcyuWKENOkELjGWgKZ4Nd87OC1sUB
	xDKU816E7bXGHgSwQTNkuJbkGl8vAbFrL6KyVuvrUKCeCUdV1ZiGxobs+6gCHo+cRasdGMwHvec
	q9hzmEj5t0uhI841EnN7lnx1BhEkGBusJUq7MFMDnlN5
X-Received: by 2002:a05:6871:4183:b0:45f:32fe:3223 with SMTP id
 586e51a60fabf-4683778aef5mr1163905fac.4.1787860395608; Thu, 27 Aug 2026
 12:53:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827185722.3234622-1-csander@purestorage.com>
 <20260827185722.3234622-3-csander@purestorage.com> <20260827191705.D53C91F000E9@smtp.kernel.org>
In-Reply-To: <20260827191705.D53C91F000E9@smtp.kernel.org>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 27 Aug 2026 12:53:04 -0700
X-Gm-Features: AcwNN1W4YwDKJsJ4I9wWFXfEnGuBCnFCExgwaK_ALpgcocy3M7K8ifopiYrTRDc
Message-ID: <CADUfDZoJj6_wHv7_hpCOGRfAEGfb7J=5PJJ+++VrLqH-MZvNfg@mail.gmail.com>
Subject: Re: [PATCH 2/2] nvme/ioctl: call io_uring_cmd_set_res32() in ->end_io()
To: sashiko-reviews@lists.linux.dev
Cc: dsterba@suse.cz, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 12:17=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] Polled NVMe uring_cmd requests completing via IRQ cause a Us=
e-After-Free in nvme_ns_chr_uring_cmd_iopoll.
> - [Critical] io_do_iopoll unconditionally overwrites req->cqe.flags, dest=
roying IORING_CQE_F_32 for polled uring_cmd requests.
> --
>
> commit 67604b5180877187b81d959a1a1acc3b5bc52ca4
> Author: Caleb Sander Mateos <csander@purestorage.com>
>
> nvme/ioctl: call io_uring_cmd_set_res32() in ->end_io()
>
> This commit moves io_uring_cmd_set_res32() from the task work callback
> into the end_io handler for nvme uring commands. This eliminates the need
> to store the result and status in the PDU, saving memory and unifying
> the completion path.
>
> > diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> > index 269afd5bc02e3..8d357c47111f8 100644
> > --- a/drivers/nvme/host/ioctl.c
> > +++ b/drivers/nvme/host/ioctl.c
>
> [ ... ]
>
> > @@ -414,15 +411,17 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(s=
truct request *req,
> >  {
> >       struct io_uring_cmd *ioucmd =3D req->end_io_data;
> >       struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
> > +     u64 result =3D le64_to_cpu(nvme_req(req)->result.u64);
> > +     int status;
> >
> >       if (nvme_req(req)->flags & NVME_REQ_CANCELLED) {
> > -             pdu->status =3D -EINTR;
> > +             status =3D -EINTR;
> >       } else {
> > -             pdu->status =3D nvme_req(req)->status;
> > -             if (!pdu->status)
> > -                     pdu->status =3D blk_status_to_errno(err);
> > +             status =3D nvme_req(req)->status;
> > +             if (!status)
> > +                     status =3D blk_status_to_errno(err);
> >       }
> > -     pdu->result =3D le64_to_cpu(nvme_req(req)->result.u64);
> > +     io_uring_cmd_set_res32(ioucmd, status, result);
>
> [Severity: Critical]
> This is a pre-existing issue, but does moving this call before polling ex=
pose
> a regression with IORING_CQE_F_32?
>
> When io_uring_cmd_set_res32() posts 32-byte CQE results, it sets:
>     req->cqe.flags |=3D IORING_CQE_F_32;
>
> However, for polled requests, io_do_iopoll() later executes:
>     req->cqe.flags =3D io_put_kbuf(req, max(req->cqe.res, 0), NULL);
>
> This unconditional assignment completely overwrites the flags, erasing
> IORING_CQE_F_32. As a result, when io_fill_cqe_req() processes the
> completion, it allocates a 16-byte slot instead of 32 bytes and silently
> drops extra1 and extra2 (the NVMe-specific result values).

Yes, this does look like an existing issue. Perhaps the req->cqe.flags
=3D io_put_kbuf(...) should be using |=3D instead? That would match how
io_req_rw_complete() uses it.
>
> >
> >       /*
> >        * For IOPOLL, check if this completion is happening in the conte=
xt
> > @@ -435,7 +434,6 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(str=
uct request *req,
> >           iob->poll_ctx =3D=3D io_uring_cmd_ctx_handle(ioucmd)) {
> >               if (pdu->bio)
> >                       blk_rq_unmap_user(pdu->bio);
> > -             io_uring_cmd_set_res32(ioucmd, pdu->status, pdu->result);
> >               io_uring_cmd_done(ioucmd, 0);
> >       } else {
> >               io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
> >       }
> >       return RQ_END_IO_FREE;
>
> [Severity: Critical]
> This isn't a bug introduced by this patch, but is there a use-after-free
> regression when a polled NVMe uring_cmd completes via an interrupt?

Aren't the blk-mq poll queues mutually exclusive with the
interrupt-driven queues? I'm not sure this is possible.

Best,
Caleb

>
> If the completion is not in the expected poll context (e.g. hybrid pollin=
g
> or a spurious interrupt), this path queues nvme_uring_task_cb() via
> io_uring_cmd_do_in_task_lazy() and returns RQ_END_IO_FREE, which frees th=
e
> block request immediately.
>
> However, the io_uring state flag req->iopoll_completed is not set to 1 un=
til
> the task_work runs. Concurrently, the io_uring polling thread in
> io_do_iopoll() sees req->iopoll_completed =3D=3D 0 and invokes
> nvme_ns_chr_uring_cmd_iopoll().
>
> This function then dereferences pdu->req (which points to the just-freed
> block request) to check blk_rq_is_poll(req):
>
> drivers/nvme/host/ioctl.c:nvme_ns_chr_uring_cmd_iopoll() {
>     ...
>     struct request *req =3D pdu->req;
>
>     if (req && blk_rq_is_poll(req))
>     ...
> }
>
> Can this lead to memory corruption if the unprivileged user issuing the
> command continues polling while the interrupt path frees the request?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827185722.32=
34622-1-csander@purestorage.com?part=3D2
