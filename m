Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4E32D2487
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 19:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786563560; cv=pass; b=utOIGaaNTbtJ6Eg7QDDSj8LDFNw3kvVD8d5ASkyVwIaT2eL1w182FCD/MIpXZ+kWulEVm9hB3vo65LV+8FbU8T8DZBKuhL7pyRNpuV+Fcrbti2iQ2p3H/qv0/GQG2vxV2gmfm4KSYqjgTVtPh412FnLBuP3JHz0h9MHskpDISP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786563560; c=relaxed/simple;
	bh=tRgGCOewA0lp8S+K3RImRNPbX0DuxXTz1l30c+3uZoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mxcg/Mq2rj0FRD8M/2yOSKvtdbIym+ZE+4PopANhNt6T/dORNqnyxq4X0Fgj+znCEtwcLRRXfn25/4fFZHoE3+NliZHiDJN9Q2zb5M5LvEI2nY7HcA3rXNCogc5+YM2R8X4U9OUWPXSDNNOZBrrPu6G6PI7KscExf/BE5YDEIf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AE6ryjOz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZFVKXQBq; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AE6ryjOz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFVKXQBq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786563558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3C4X2UvQfeeNnOmqDKpOYErY1uer3KEJgj1Xf3vKCt0=;
	b=AE6ryjOz26RxLq9Mb1cTMYcd6h6cOIq61eJ9m0g6Ecbo1PdQN2fOl7zWOfO0L0p9AjzuoK
	pjOD1Pi6bBRHyEo8XXRLgnlpy1N3kgFf0dq5M78obH5EAxtsgxtkDpqV/Uo664SJ/3Jnx4
	Yyj8ifcabwAWMcLuFLw8CHiYEKXN6m8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-fb1UkH_kO1q3-xa0JnTc1A-1; Wed, 12 Aug 2026 15:39:04 -0400
X-MC-Unique: fb1UkH_kO1q3-xa0JnTc1A-1
X-Mimecast-MFC-AGG-ID: fb1UkH_kO1q3-xa0JnTc1A_1786563543
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f7039fa59so1090635f8f.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 12:39:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786563543; cv=none;
        d=google.com; s=arc-20260327;
        b=WJE/UsMgKqABDt2oL2JgsOroxFo+DOYbQxKiL1Dfgezq4+YOxWk7llS37KK5UHGE7Y
         +z5fVcm0oDDLliTYPeAfXr+saYi3LF/c3k5uUJW+6lJMRvZnvnC6206RVlRYje/4bLIH
         UKKamPMxmLDHBAgzmF0unjuLT42cFHZMSvbC7j93QruTRZPuHUjelzX7EhJQfYn+EZT1
         QtU9QTxicOJxMGUCdUD6Np92cGpWwHa4/0No2ZhURxEm2i48349s5OHQqU/F6074iC9L
         T+azf+bSeESSmgMyMLkEjgGC598US2An002p0s8u00jzXiOZCSujTt46d0W98wL5bc3z
         n5tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3C4X2UvQfeeNnOmqDKpOYErY1uer3KEJgj1Xf3vKCt0=;
        fh=gUfsL9ppqjROwdjOOpA7gVU01au1qshFQ+BhECdF0Kg=;
        b=aCIbkH6MZCxDJwfn4LhhTFwkU3gguXQkeZu+GSzuOsnE6JajievmP2r+xLkYxRtVzo
         gF4hceOXta4LW3ngA7fb2jS6jzXLiVX1J6gJh+Xk9ZGiztb2WyeprXKDCGOjDqyyZitT
         d/pkFvgIc8kiY10/vxz5O8a61vYMAAw183tmZ4r6w7y2qPuoqYrqlayBJLvEwlptKZzs
         F/ulUbjsKpaXQyCZV0drjDaRy2xJ0DO4Y4NcYkBGYHg4HBySK+NT4pL0/xiEnVM9GM78
         f+mKqjRvbTtLZP6IjHBNUI3OTycEuD7EXvh1R22i9/1I66zqvHeL9Y9ZqX0wViHPK7zZ
         BFeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786563543; x=1787168343; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3C4X2UvQfeeNnOmqDKpOYErY1uer3KEJgj1Xf3vKCt0=;
        b=ZFVKXQBqiFeaku8dfb3FEge8UNIYHGTsvgVgOgNpU5DQvo9QHMJwQhlYexFTbFMerS
         D2NbUWEAKx92dEEFHNYjAlwBaRPKpcAULcpW/R2SuqE1nS4BhWrniP+A3U0mrnfOwHbf
         Pn9LkkDGHO6OLi17NZFQDtXm5DpCXJ0AOwexS2RY9p5N92cXvDjFUvwgCOhfMbFLH1MM
         vjl0M+WVmaIUYvxjqZ78fph3p9y/BX7sts7ELyCYazMSZI/u24qu449sq1bogedIXDSR
         4LHxN++VRcTOY/Rw8XZtsTZzGayKej4Kiuf8e0JZ+xWDXZ/+WgL0hwumrOL1EQQFIa1l
         zWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786563543; x=1787168343;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3C4X2UvQfeeNnOmqDKpOYErY1uer3KEJgj1Xf3vKCt0=;
        b=OpLtTulXIFna/fXmGtWctDVfU5pvZlMDcfyB/b4EJSnyW2ru5tsq+Prs1l88JcpsYT
         NF+Cp6si10gS7vuZ9Me3K69VhkXKeqI4YNHFki5T6HYfrxXMg2NSYTJFDYSUjkmkMaI6
         ziriKGXrdGPp8S3q4Z6hcyHWqoVXpPIX+FiBLn6eOOC4n5paA5E4uoZVlUV2MfkmkdHf
         jAzFrUIsiPs0GK6xU0EUVkWC4ifuAwcBpryD32U7t/f96ux9WrOS88Rk6HTqRrsF7xA/
         +cf3/teEQi1tq9V2L7rqx/svj8BwxRHvSrJ60GfuX5d+yyz35BDEXUyCnNGINGc64cfJ
         rt1Q==
X-Gm-Message-State: AOJu0YyKSKZ0pXXh0geTeLhKwxH7RxRP0h6Ag5V8uIpt8JH1Aa8/KG2c
	+rWWQ9cq8vTz207DPlT6do/vfzdLihjgqproWCQO+rNqjrEw9U3cZMaj3l/niWuLWq7AmxN6L13
	c2pwTWUhXKIxdbO8HoOy1JTKnidCmBfBd8PvL0FWT50UjAVUCe9OFUinYofgCzd2wFDzp1pfWQZ
	XLiTKXWGE+0vuX1wBB+T8j1x+8NdCqsn2eUR9Z4pH2aPQ3CmgG
X-Gm-Gg: AR+sD10AvhZUESDX446L5l2RLDMeDWF6SzP7jGaQYZKb2N/CUMFYLm9fD08J+kkTXli
	D9UuZezyP2u/RcfwiWNNPsoEudM9idZ8OFiNlSyI81zQ/sKqU5+oNbaxh1DYoVx2DAt/BXIfgBC
	JyaXSH/t27dGXL4tzYpPpo6z/2pJRI15qOhRJqxsv0NhxTF1qWLgpYy7uflf5/TCsKZABBc3Qs7
	3vxp9+qsrhJDdn3og==
X-Received: by 2002:a5d:4749:0:b0:47f:8ff9:c9bc with SMTP id ffacd0b85a97d-48159fe3dbamr560750f8f.14.1786563543189;
        Wed, 12 Aug 2026 12:39:03 -0700 (PDT)
X-Received: by 2002:a5d:4749:0:b0:47f:8ff9:c9bc with SMTP id
 ffacd0b85a97d-48159fe3dbamr560719f8f.14.1786563542767; Wed, 12 Aug 2026
 12:39:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812181300.3712426-1-jtaubepe@redhat.com> <20260812181300.3712426-11-jtaubepe@redhat.com>
 <20260812183447.69D111F000E9@smtp.kernel.org>
In-Reply-To: <20260812183447.69D111F000E9@smtp.kernel.org>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Wed, 12 Aug 2026 15:38:51 -0400
X-Gm-Features: AUfX_mwPGs6928oyO7D9lNr3R67WeJ-UrYuYK8ZSaH9YZfKKzZ1uertCx9vvxe8
Message-ID: <CADRr4bdf=r802GE8Duz-VMWZ9XFEtjg4n+xWwiO2Ws7Q0C0Q7w@mail.gmail.com>
Subject: Re: [PATCH 10/13] scsi: qla2xxx: enable FPIN notification for NVMe
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 2:35=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] Lockless access to `fcport->nvme_remote_port` in `qla2x00_set_rp=
ort_marginal()` introduces TOCTOU Use-After-Free and NULL pointer dereferen=
ces.
> --
>
> --- Patch [10]: [PATCH 10/13] scsi: qla2xxx: enable FPIN notification for=
 NVMe ---
> commit 1b0bf8a2abd4965d07b3b9fd652b0926356c721b
> Author: Jesse Taube <jtaubepe@redhat.com>
>
> scsi: qla2xxx: enable FPIN notification for NVMe
>
> Implement set_rport_marginal callback using nvme_fc_set_remoteport_fpin()
> to enable FPIN notifications for NVMe.
>
> > diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla=
_attr.c
> > index a4ca22024edeb..92db7d584eeb8 100644
> > --- a/drivers/scsi/qla2xxx/qla_attr.c
> > +++ b/drivers/scsi/qla2xxx/qla_attr.c
> > @@ -2789,6 +2789,15 @@ qla2x00_set_rport_loss_tmo(struct fc_rport *rpor=
t, uint32_t timeout)
> >                                              rport->dev_loss_tmo);
> >  }
> >
> > +static inline void
> > +qla2x00_set_rport_marginal(struct fc_rport *rport, bool marginal)
> > +{
> > +     fc_port_t *fcport =3D *(fc_port_t **)rport->dd_data;
> > +
> > +     if (IS_ENABLED(CONFIG_NVME_FC) && fcport && fcport->nvme_remote_p=
ort)
> > +             nvme_fc_set_remoteport_fpin(fcport->nvme_remote_port, mar=
ginal);
>
> [Severity: High]
> Does this code introduce a Time-Of-Check to Time-Of-Use (TOCTOU) race con=
dition?
>
> The nvme_remote_port pointer is read and dereferenced locklessly here. If=
 a
> device loss event triggers qla_nvme_remoteport_delete() concurrently, it =
sets
> fcport->nvme_remote_port =3D NULL and allows the NVMe FC transport to fre=
e the
> remote port memory.
>
> If qla2x00_set_rport_marginal() checks that nvme_remote_port is non-NULL =
but
> is preempted before calling nvme_fc_set_remoteport_fpin(), it will pass a=
 stale
> pointer to freed memory, causing a use-after-free.
>
> Alternatively, because the pointer is fetched without READ_ONCE(), the co=
mpiler

This is not a valid solution, there would need to be a lock in
fc_port_t or else we would
get a use-after-free. Unless there is a better solution im unaware of
im going to ignore this
as it already exists in the driver.

Thanks,
Jesse Taube

> could reload the now-NULL pointer from memory, leading to a NULL pointer
> dereference inside nvme_fc_set_remoteport_fpin().
>
> This pre-existing vulnerability is also present in qla2x00_set_rport_loss=
_tmo()
> just above this new function.
>
> > +}
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.37=
12426-1-jtaubepe@redhat.com?part=3D10
>

