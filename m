Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7CD38E8B8
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 17:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778779673; cv=pass; b=XCMx9pztZAy1UdgtOw3LfmlLuUGQusyf8CKhUdWZqPTacdscPziLNFiDWhm0XIHObP+thXRnZzZ/R6ZogY9lKB9t419L/guXshTuqTpLgRX6+II0lhh8F6CtaD117NH4Pm1VTSI7Jx0vJ4cMozPfpMIpgktWrFSqTMiVfBiiqE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778779673; c=relaxed/simple;
	bh=caS0jM/zkOOo/hpfImrJrmrVXT2oeN5fq61ivWwP+h4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qkH6vgeUxzmblol8kBUoP7VDM9+1lodXHn0BfoSSYv7dBb2B/0jDbgVNhbc8SK1vqHTPz3vrJGgEGkxczQhCBgudmQVTKNSkYIAiT1NmQsP54TIuIbQev3H6rljkcQMi/HLeTM7pbKmySnpEz8pv02CdBCxiFzbOC598vPlgplk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fk/XqdoT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EiipPqpy; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fk/XqdoT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EiipPqpy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778779670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2r5nkVMUfAgaFyXQVTDqEsZEP+fOt4UUMQH+KUzU0Y=;
	b=Fk/XqdoTmSUKbTkyk6bcKiuDxyu01Xgt3SjOByUpEdc4oGG6dObO6d72MnjO3sLRc8ttxJ
	hqGJXCpynTcEl6teQGGL6vWGu/VUIn4tIKz1+nT4OI2OrzKVcYyE3XiWOASJTqinnElcA9
	CCvWF024/lVGzlQjue8wOZ27gclYju4=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-MtHaS6RTMjq6wIbjhQzpsQ-1; Thu, 14 May 2026 13:27:49 -0400
X-MC-Unique: MtHaS6RTMjq6wIbjhQzpsQ-1
X-Mimecast-MFC-AGG-ID: MtHaS6RTMjq6wIbjhQzpsQ_1778779669
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-6327b45f59dso2766857137.1
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 10:27:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778779668; cv=none;
        d=google.com; s=arc-20240605;
        b=RSHPHiyeci/Q9Ev9wXM9cuqJpJjvuxP/NtAx2sL5bCWYjT4r8nbhbrBlfoTyghlntT
         KCPKP9dZrq6OME+AVeG9V7t9pWEDSPrkiCtFiPA+zW9UY9gQPFlW2WvSR+sgw7cgFigl
         yoBl3DlUskK5cut6Ox+HxIIkMBhhoBrmohklCOLPkvY1cYbGlKyFaUCm1eP7HFci/QSn
         DWMPUkT32Sg+jX/7o/pOBAMnRFUNVzz95z1+uXQeyh1m36Q96sbSKlpziH+wQ4skSCjB
         ygGGpoKQbvQygOt/RgZ7F8CyiDSWgyrysEwOEqzANUjEBnhaMujcl171O0f4k31Bua4m
         /fTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F2r5nkVMUfAgaFyXQVTDqEsZEP+fOt4UUMQH+KUzU0Y=;
        fh=tScm2eAN0HS9mCdl3iBYquTZsazadfL7sZDsu6+Quyk=;
        b=ZDemFn6PzrphyfGEwcwRVdIwtboHe6RITjiK+Hhx2/kK84I4g4PrZAyCfeyjFGTyIK
         meBs8yTy8DInp7wd3SMTDBfxAje1Hmn3Ohr6nLJbquP4mm2UZDQF775SExnRivD6UTgw
         S8S3KZP8WDS8SGmD3V7IS6fW1WOdoKHTbzq2NRzpeCNwrp5mk4UgeeLMi7ZmCFuZUitm
         46hxNHrgKFnoRRfjpWgD0wOS7xuKEdC2xG+nbwZT3TjJbrlgaED0lI1G0902osD6PlH6
         yMnUie50Fo8McLlHkbIUA9F4E8xkejzd6Z3b7iU7HrU3i2P8Nb9QZUtQkilh+uoO9mrU
         yTyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778779668; x=1779384468; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F2r5nkVMUfAgaFyXQVTDqEsZEP+fOt4UUMQH+KUzU0Y=;
        b=EiipPqpyeBturVjJxCil0T7DEI9AKr9IZ0ItGPeZuKxD1Ne4CLURSqq4QlAI7gw3t3
         np49AbLoY1zAsG+a4hv72iavDaGtJ6Xon4F0SansOeWSl2wvKToKEmHccmeIlydWt17v
         th6lExNFrZmyZtsm8MQpXJDUw5TaM29gGNY8wF+/iXls1nLdI2X4LFdsmdFSNUd2i3fO
         taLVFZ+ohDxzBkP/E4VFfnglKQncJGyXDh1eMatZYmNbAcprhr87l09F/6YeWWwgGvjH
         5hdYD6hACCVFuzFhOdaw+wqFrHgUsokmh7mR03pvAmd/ZkBzSNuUAyblKSSG/X/kxwp8
         wuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778779668; x=1779384468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F2r5nkVMUfAgaFyXQVTDqEsZEP+fOt4UUMQH+KUzU0Y=;
        b=Q/ND04e8xa5n7LPFjW3+bG1+7OEgzamRIfIxdZ6hjgcBYqS8XVOmTqo/WTQabia9B5
         /yPFdd8lwt/r5DRHr9xDfmDSFqDpOM6TrNmti0BQYJK2FXWuQ94a3H4PmcGNWpUTZ74N
         iwdEbl5lxEzWQgYODEhb0arOgOLpAPtTl20KDaFSCqOQwO+Vj+7lXHDxMXJU5PpnmEQv
         AZ5FlgM+8TxapYudWR+BiJnPnb3R6taggqVcVf+DcPilSj/CmidF6mLkg6yBgA2db4EK
         pdF1lgAyKhVkWxJt1+U70rfOK8rrZN67QvHc7EZozH1i6h5kJi0UVZjHzbx7nvUMAYCm
         rzig==
X-Gm-Message-State: AOJu0Yy2QxSFFe+T8pm/5JM9BrWept/3VhapFEu3rWdiUyMYBv/kLd/I
	Aq+19vRHp82AZ991GjUVHD8bSClfaNYwM0Lmzg7xAufO87AXae/e0o3lOALd3PKMvkNjDz6uY5C
	76kamHIgfiGUSHzFbp0+TIowcWrWLM6XaOKyV3bymUtkE2m3z2tC+SZWxJ/TG+vB7rpTo/0W28b
	EdZnZvxKjwqqpzFhNsSAeE2BoZSrSsJBKW4kw+Ng==
X-Gm-Gg: Acq92OED1fb7FDDLit5hyE34p/9bFIuBgWQINySJCp+ZZaFdFbOloywnyWwFQGKeb0d
	p7Yatg4N5xwP8q16Uh3T8DGtlU0uNh3agwCkCQroUr0IAjX0M6M4a/uJwzU+lq76Y4GoavSIoAy
	PGgtxeAZQYJWwwev8TbByOrsCjno53nVFSNQ8Yd6U0zjCuL2d8Vi+o7cDfNfzlMe8nIt1oe0/kE
	LYPLPYEghafkAQX6jI+GLYixejK/b9wlwkCXzgy5j/h5XEjAPoL2BWOE7u4
X-Received: by 2002:a05:6102:32c1:b0:607:798d:8083 with SMTP id ada2fe7eead31-63a3ee80766mr71653137.15.1778779668588;
        Thu, 14 May 2026 10:27:48 -0700 (PDT)
X-Received: by 2002:a05:6102:32c1:b0:607:798d:8083 with SMTP id
 ada2fe7eead31-63a3ee80766mr71637137.15.1778779668149; Thu, 14 May 2026
 10:27:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513173552.9222-1-djeffery@redhat.com> <65a4ac0a-ea6f-4a83-958c-169d4e2a62e8@acm.org>
In-Reply-To: <65a4ac0a-ea6f-4a83-958c-169d4e2a62e8@acm.org>
From: David Jeffery <djeffery@redhat.com>
Date: Thu, 14 May 2026 13:27:35 -0400
X-Gm-Features: AVHnY4Iuks8Kw79LrepbC7OZX3jkBNxfrKKtKrDKGn8P6k8j_Lv-ztuRMDm5fzU
Message-ID: <CA+-xHTHvYtDX+qg_HLhCgnTdrr0q-btGVoY9gb3kwHY_Q4CQTQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: run queues for all non-SDEV_DEL devices from scsi_run_host_queues
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2026 at 5:58=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 5/13/26 10:35 AM, David Jeffery wrote:
> > +             if (sdev->sdev_state =3D=3D SDEV_DEL ||
> > +                 !get_device(&sdev->sdev_gendev))
> > +                     continue;
> A comment would be welcome above this statement that explains that
> get_device() is called instead of scsi_device_get() because the latter
> skips devices that are in the state SDEV_CANCEL state.
>

Would the wording:
                /*
                 * Only skip devices so deep into removal they will never n=
eed
                 * another kick to their queues. Thus scsi_device_get canno=
t
                 * be used as it would skip devices in SDEV_CANCEL state wh=
ich
                 * may need a queue kick.
                 */

work for you? Thanks for the feedback.

David Jeffery

