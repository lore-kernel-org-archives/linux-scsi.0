Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FE043BDA7
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 13:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974126; cv=pass; b=TZrg0dGtp0wRzgPrn7Yh11nIkD/pkv4hDoMhMkbFrHX9L0sKTQrfW33s4dZq2WWkQrKMV0ctrrWRwph5X+W9o+9h4zWBQcsopsq18R4vynZF2O2VC4XWbVnKYgZP4QwytXCgTvC48tB6DzHrsZhkcfE7nhLRX3kiKeCgMSD39F4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974126; c=relaxed/simple;
	bh=5t0+awvIEoaGKqMdu39TCk34rZ/73tsfHuxRUuz9SGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QbWboGXA8xE93SzPK8m2wt6dWN/92OgvdvpSASQkC5LYSRsWl9+U+tdd8fxtbe9dSaIdC3LshRLpxR3ypFTcYl9SZlleBbe6CvKzX4l6b4DZahZjGxLEn6ZoXxZPJ6gXqCW4GZr320AZDHH9VlRcTb5VIsBiL0Oa4DbD4LoYZsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IixH3yvI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EOYufjk9; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IixH3yvI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EOYufjk9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786974119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nar5TPwp4YomIFNBACklaS1XT648jZLKltDco2A2dR0=;
	b=IixH3yvI9z2a/X+322aB2nzJdCxUoOtDDpzvHJVXR+Blx/W7LSqGtctRzh8N9tItzRZlRC
	4yZSILNeLiqU8tjZbVzGEDv5X8flcwbIuLoPhdHuuNP8I3tDoPi8z40aAgB4NphjXhR07E
	oz1WxxaBMvrHufO2QL5mpN5ezLnDfeQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-uQlrqowqMfi9ivPzi2himw-1; Mon, 17 Aug 2026 09:41:53 -0400
X-MC-Unique: uQlrqowqMfi9ivPzi2himw-1
X-Mimecast-MFC-AGG-ID: uQlrqowqMfi9ivPzi2himw_1786974112
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f2de3ba47so2245796f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 06:41:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786974112; cv=none;
        d=google.com; s=arc-20260327;
        b=AvPVsT+9ha0WVQrQReqMvO/8oCRwBkCQQw4uMewMztN1cp18sIY6XeQCfpEhgTwl0P
         wrlRkbBL2bdnOxdEiEwwk169vbmYphhz6fUfOLjzzEFqIXXMYCgh5sztdFCt0MZklJXy
         FMnSe20etIOf44Xu5gcQup38H3gYyrwH7AzC3p/tKnTYlSQaa/lQbkyeDEkTSuNFLHGh
         MEWrw6j2YR5RQHfo16aPoMsN/fSu0eJq0Yl7XJKiRTBRuM5aafT66sk/iuBADpZLJXrx
         tH8sE+vBoYVVzkmeDHGwckdHCpl3MSlkf/74msH1SnEWwvdNSbJuEFEMfeDQfy8pGyIQ
         iR/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nar5TPwp4YomIFNBACklaS1XT648jZLKltDco2A2dR0=;
        fh=gUfsL9ppqjROwdjOOpA7gVU01au1qshFQ+BhECdF0Kg=;
        b=DPEEe4MXOSGEwdRjLrYugX9GgyP59qUAdqI9nGOox43XS96OkgeZgG4pTPnTRlqQp4
         3PUzQkAVOTw1Thv/1YUfb74a0Yne7xtF+k5DKcMTH7zsAoFYyTtZXou5Nr2C6HlSWTP7
         DPbHKgzQBsS1H9tmNkmOXN4ljWfwYUBaGgQIAZxqXa9jSzl2EQaDukaH0DY/r3PB+D+O
         ug6NbEOGgNqY7aYyi0L26YTdLL+acXZTevAIOZTsbvhwEBmfKceNr1ac3wtfiXhkN9f2
         zp6fIDokZVsHHsWIuFUK4PLwCcXYRMgiadxvxA3O257+cBRaZKgaBIXT6ABUJorkFske
         FYYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786974112; x=1787578912; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Nar5TPwp4YomIFNBACklaS1XT648jZLKltDco2A2dR0=;
        b=EOYufjk9tTJqQ/EKOIPjFQS5mZtaOuLULwmKTcM7xg3J/3foBjqvWYiTK18JRFnfI4
         QaG6BXMJGayRUXawnqXsVrenjRo4jvZ+XSBthCi9rj+3rSZ9zvb96OPmqMPMIXknP52x
         tz9f27LIrd3Xx93bCM62rxVpjdMKFaipDRu6UxBgzvCZn2Q7YiGG/DujaW50IuGFs3PZ
         /BTEQn+5YW+jVAkQXefBbES8sdj5h9j+Fpn2dsR69G0mtp8EcBTQZTEbDBYXMNKioaF7
         8Fe8NFAKGU6KLHvKm7J+D81r+Tx32/S2Y+draPtGD9t+dIjW6aO9SgUrJA4as8IlMoFx
         fxbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786974112; x=1787578912;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nar5TPwp4YomIFNBACklaS1XT648jZLKltDco2A2dR0=;
        b=OlZcnq0b5QiEscclls+ueZbpJhyuExxNqgv2+OO95dKOps4xXo9P6vaNmmpVmCldtX
         hCXyNmusKbzOaPYzR5TtDND+2M4TilaiGbMhD69ZfCuLVdSUKSoNMrxX3VkmffiVfM4k
         vG/3sQ9Hg2W+2+XubOcRyh2SKEFgoYQRHWVHot+OO7cBU/94beiv8c4hbFSHCe9ajiLr
         B+aYgjNRWYibMR1UbF8jzyBLofmX7UYYVxPBx9RxhV96mS6kwhK/GulAP+PhfJec+qwx
         lossdFAT5xL106DEv6Z6hxOVdLmJwq+5a+MoK8BJJ+JDl34UDJpQZG8A/Zc+72L48vlf
         CHXw==
X-Gm-Message-State: AOJu0YxqGdrdY/JvcVMjMH0SoxlXa4o93JT0JJnDXhqRDCvsd4uq7Hzb
	vRZrZpeMtYO+t0xkQqsYvBs/+KpkkqIYWBDKCKXgTlZbzB2hg0/KQqJLC1VqNf+j/Tzp9GLK15q
	BhjmFdKmV+IUKKt4Gj5r84oIj+u4lhK6hqVMErmy/yJydMsAaGKlgtSukhjLwI03w9bdCZmCif7
	Op7TchtSJDh6mNkCLGtsv1MIqNBokPO6wvNsPKyw==
X-Gm-Gg: AR+sD12g9uwkNBmTEj1kYTwgwNxnWPAyK9u4CIctqSj/HfokEf1hZR38yiZvfJ1TBM0
	5Y2P9BaKLhyPf31vU7gQA038VItQVXzgyV1/ZtdhdiGfyNOpVrjQMaWnF3tFztzTZsN+T0T8EWK
	cM6iHCLjNQXll2XdpnK2XxE/IjKwg7agc/bhzx44h6sRefnyUxgFnbVxQMJx8ljsxIhazrcxlMo
	AvElRV9WoNqbO9Wcg==
X-Received: by 2002:a05:6000:2612:b0:47f:c648:e265 with SMTP id ffacd0b85a97d-48160758afcmr42033779f8f.17.1786974112291;
        Mon, 17 Aug 2026 06:41:52 -0700 (PDT)
X-Received: by 2002:a05:6000:2612:b0:47f:c648:e265 with SMTP id
 ffacd0b85a97d-48160758afcmr42033697f8f.17.1786974111934; Mon, 17 Aug 2026
 06:41:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812181300.3712426-1-jtaubepe@redhat.com> <20260812181300.3712426-3-jtaubepe@redhat.com>
 <20260812182142.3207A1F00A3E@smtp.kernel.org>
In-Reply-To: <20260812182142.3207A1F00A3E@smtp.kernel.org>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Mon, 17 Aug 2026 09:41:39 -0400
X-Gm-Features: AcwNN1UC6sQe5yjBCYZbkjh1cT7tfFNaedkvSo-HYeu9LkQg5W4yToVKNkirk2E
Message-ID: <CADRr4bfRsLn2fYcCepK9EjOCn+PH2KUCf6KXcd-a=Hu57LNZRw@mail.gmail.com>
Subject: Re: [PATCH 02/13] nvme: add NVME_CTRL_MARGINAL flag
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 2:26=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] The NVME_CTRL_MARGINAL flag is cleared on the wrong structure's =
flags field in the Fibre Channel transport.
> - [Medium] The NVME_CTRL_MARGINAL flag is not cleared universally on all =
controller resets, leaving non-FC transports and manual resets permanently =
in a marginal state.
> --
>
> --- Patch [2]: [PATCH 02/13] nvme: add NVME_CTRL_MARGINAL flag ---
> commit f9c336bbdc7993d3daa484b869cd6845d7fce7a7
> Author: Bryan Gurney <bgurney@redhat.com>
>
> nvme: add NVME_CTRL_MARGINAL flag
>
> Add a new controller flag, NVME_CTRL_MARGINAL, to help multipath I/O
> policies to react to a path that is set to a "marginal" state.
> The flag is cleared on controller reset, which is often the case when
> faulty cabling or transceiver hardware is replaced.
>
> [ ... ]
>
> > diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> > index 04363b9c4489e..d2ca65f70a0c5 100644
> > --- a/drivers/nvme/host/fc.c
> > +++ b/drivers/nvme/host/fc.c
> > @@ -788,6 +788,10 @@ nvme_fc_ctrl_connectivity_loss(struct nvme_fc_ctrl=
 *ctrl)
> >               "Reconnect", ctrl->cnum);
> >
> >       set_bit(ASSOC_FAILED, &ctrl->flags);
> > +
> > +     /* clear 'marginal' flag as controller will be reset */
> > +     clear_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
>
> [Severity: High]
> Does this clear the flag on the wrong structure?

Yes, Will fix.

>
> Here, ctrl is a pointer to struct nvme_fc_ctrl. Clearing the bit on
> &ctrl->flags will affect the FC-specific flags field instead of the inten=
ded
> core NVMe controller flags (&ctrl->ctrl.flags).
>
> [Severity: Medium]
> Will other transports remain in a marginal state indefinitely?

Yes, this is intended it wont affect their functionality.

> The commit message mentions the flag is cleared on controller reset, but =
the
> clearing logic is only added here in the FC-specific connectivity loss ha=
ndler.
>
> Should this flag instead be cleared universally inside nvme_reset_ctrl() =
in
> drivers/nvme/host/core.c to ensure PCIe, TCP, and RDMA paths also recover
> after a reset?
>
> drivers/nvme/host/core.c:nvme_reset_ctrl() {
>     if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
>         return -EBUSY;
>     ...
>
> > +
> >       nvme_reset_ctrl(&ctrl->ctrl);
> >  }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.37=
12426-1-jtaubepe@redhat.com?part=3D2
>

