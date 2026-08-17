Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77194153BE9
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 14:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976695; cv=pass; b=FAjGch3mFBNLg0IJUPhBgV9pLaSc0Rl0Ry4f5E++I/JLYZZHDsHJX6cSag6vjBB+E+WUael8G8KqmVUeD9D7XC5vB0QrkvT7DpFLuYIslBpK69Hlhp/nJciLM26DoJR14qYDyHz5UxU1v2/JqUrMveT5RYYU9w9lD0N4teFlvvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976695; c=relaxed/simple;
	bh=5zMANYOL6OMX63n9a2mTSlmz6sYz7y/VGD+m3NyD6Vw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EbeJuamHBh7L4IEzqQejvg0Cp9mqUxpWwxr8hXXYT19JfjO+EVrKGS8+Y4iz4NFacAkT8dMwWcX+WraYMqFayyY42o+sXAmmVDIGPy3jdR6oPfhnLS/XwKBIJshtXtRtA2UhT0RhoGaazaFSiG1408aj50u1mQE/YjDG7JI2VSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LP+61kEE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GXtizEdE; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LP+61kEE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GXtizEdE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786976692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1AzHe4P7wnTJu3tJI94lrInGSy7mvVyAJicROGnecY=;
	b=LP+61kEERetedd7HWGv3SbLXQxWiE1feBcWfUZReksNL1EUBso4S5RAvBt9+bxCewrwPpl
	wCbCrkUEBSR87hY0XzjpRPkkIyrWrd0xkOjHFr6rKmbGwlyND/wMvFb3mju/Wp0k1zT20C
	IiL5XR9YpJy0c/rettc3iYUVRvs85Xs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-064aZFo4MB2BPra3OgEGuw-1; Mon, 17 Aug 2026 10:24:51 -0400
X-MC-Unique: 064aZFo4MB2BPra3OgEGuw-1
X-Mimecast-MFC-AGG-ID: 064aZFo4MB2BPra3OgEGuw_1786976690
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4997b060af8so20972775e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 07:24:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786976689; cv=none;
        d=google.com; s=arc-20260327;
        b=LKsyJ4CI7llsEYwEhozTGveiIXiHHOzJvXyuEbZWKK0K7atLJTMJgpqY5I05MNOj3w
         7fcqfBYr9rPWGbGHPJefBdlYGz1HNTo/Fzj2emrYj3Sza2F0xEmhMGtV1et2xF6t1Oj5
         xEGrl2Snpe3AO51yRcQ+f7bv6CRamIOHmw67epUEPz7vdzv0x0uOICJHb38QXyfeeBBA
         +vlF2gDfjZ08nevxriG2XmxnvDotnoju2WWJWlbRffpAvFFZLjdjtevARMCetJjjh78H
         1v0ZAVY/L5ipO8ArTFtQl+TLtH19fMKlrxFUMtYYNIEN2f7OUAhSUHTGaTbIR+DEJ0S/
         z8Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N1AzHe4P7wnTJu3tJI94lrInGSy7mvVyAJicROGnecY=;
        fh=gUfsL9ppqjROwdjOOpA7gVU01au1qshFQ+BhECdF0Kg=;
        b=UnBS6XPcx2YJeWWA5ES1IKRFVXEXknKYQoHPlh7tfnPND+6iawOxsOrt7/7SAo0pR0
         i/FAnnzdTEXxHoU2/NElQTSkjt1jMjlTkNdiPnAuo8dn82qenfdVkn1Uxf8DK4TnhXaS
         pcAbafAyLgx1pI7fPf3g5HYkRPAtsB7hPwV6OuQjK8dkGKl1aWP9I9OZPd4sELRak3u6
         qYQwHaaWi9cWMMtYnogsuhCZ9T592qpFU/PODkVMI5vfiSJH58junCs90RfT+JNBkNse
         mvjycND/DS9oikqE4VixwfEPEOPCEh8gEAGsYNNG34q4FE+w6hNdw8fxfLSWTphKR9N3
         FIBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786976689; x=1787581489; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N1AzHe4P7wnTJu3tJI94lrInGSy7mvVyAJicROGnecY=;
        b=GXtizEdEyk5ecZSF0UHu2WsxIB6BodAKivAgZWUvapG7yndPqpLXseWMHOOpPRKpnO
         oCbhCcLtQtfFzSb27X7wNzk5/QeqZQAXGu+YSyW67PuYzsBP7LhY44PlXilZbFuHCjvp
         71qL+FsVVLkETFQRBpnXiShXU47NZn7hdS8S7D1ZP6W1Nn7BgevBixNx+ivGdL3Fo9+I
         srAtu0PTX4FdtmmQSxRS08LEmjajdQeg2a7wzWDZkWiY1Z/bwp6smTEI1UBgy0nXa2SC
         EPxfSza7KsbnsN6T2KgG9bFMitKpYRfM521SyLoIvW0XdZBTyRbgDaPhE2rkqv+LOE/+
         7GVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786976689; x=1787581489;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N1AzHe4P7wnTJu3tJI94lrInGSy7mvVyAJicROGnecY=;
        b=jBtRt5UtMP2etNXFn+SNHM3SyVRSNSsJW4phK+dZnjinbKg8Gg7ndvZxuIkiH72gwd
         Clm2Ufhi+qoQ57trcHqnylmfpyAEXcxOUDopqEb+qo+gzIE0CnWEVnspFMWWl3HG6Bqp
         K4ASrkxVOhYI319PLFY1+r8pDKMzV5N0pIkD0WSvNdjZlzYpgdwxAqq3u4GJpNaU4Wci
         KUwHYIqa6V1CW0ko7vCZPGc89SpFZO7u3KR/1QjeLMzoUEeVGs2t0ouiUs5ufccoa+QP
         BP6AGUvbyOOzXDI7KeNAoPHsbmJ0+D1wF1b2dIs44M0hIKto2yHuw7eA/9RdSVW8Wb4+
         oeGA==
X-Gm-Message-State: AOJu0YyOxQuApxOxojs2hKcMapIoPH8a+M0PI3ZGEAR7FRIOGrX7Abi3
	ZD0R5odupWZ8m/I7EfdMK5U6atlmRcwTeCbXY1ezx+rc2j4EjbvDfpCFCy11+/AgAqcSUrhPlw2
	8Aecf6o6pTtancpUi8DLYMphQ3AdYbIzv4MBXSPrn/ZgyJqeMJnGtzAp3NILG187ktoKWNPqIet
	6KfuXDZUku96SiGhp+xpp6nWhmMamHwKMeMU7rdg==
X-Gm-Gg: AR+sD11f+ZlWzTyEOZl0fR71M1FZF47+c5mPuCtVtt8dJgQttqGCedWUaT5UZ+N/Bc8
	QcLG/qvWH1VyglDx/GidKZ75lTHEqxAf+EdkcrFUyDBCOWGOXz1GtsJOSL2mY3To2R0j54L7XGD
	qLeoSbb6FYyXbwSmkNGdaOZzfSnqRvqTOINSDMDlLg5cqNDgBbAnTO+d/HtL+qJEfaVpaf4Sn1q
	qR2nYA/toSk3hunPA==
X-Received: by 2002:a05:600c:8509:b0:496:c9cd:e7ab with SMTP id 5b1f17b1804b1-499879337acmr453690275e9.5.1786976689577;
        Mon, 17 Aug 2026 07:24:49 -0700 (PDT)
X-Received: by 2002:a05:600c:8509:b0:496:c9cd:e7ab with SMTP id
 5b1f17b1804b1-499879337acmr453689025e9.5.1786976688989; Mon, 17 Aug 2026
 07:24:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812181300.3712426-1-jtaubepe@redhat.com> <20260812181300.3712426-10-jtaubepe@redhat.com>
 <20260812182733.309881F000E9@smtp.kernel.org>
In-Reply-To: <20260812182733.309881F000E9@smtp.kernel.org>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Mon, 17 Aug 2026 10:24:36 -0400
X-Gm-Features: AcwNN1U5N3XQmwsxmOb1TCuFX1muZNY1UIu4l6yc7tEcDI5Zd5X-qM0qbhm5h-M
Message-ID: <CADRr4bd_aa=W7DMxzcJA+50TQh8WHtdEmAPtdFzJ_WjqbnTuow@mail.gmail.com>
Subject: Re: [PATCH 09/13] nvme-fc: add nvme_fc_set_remoteport_fpin()
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 2:27=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] `nvme_fc_ctrl_connectivity_loss()` clears the `NVME_CTRL_MARGINA=
L` bit on the wrong structure's flags field, causing state corruption and p=
ermanent marginal state.
> --
>
> --- Patch [9]: [PATCH 09/13] nvme-fc: add nvme_fc_set_remoteport_fpin() -=
--
> commit a1aaa3c652a2b842059c76da3884f9c0dcb9925a
> Author: Jesse Taube <jtaubepe@redhat.com>
>
> nvme-fc: add nvme_fc_set_remoteport_fpin()
>
> Add nvme_fc_set_remoteport_fpin() and supporting functions. This
> function is called by the SCSI FC transport and driver layer to set or
> clear the 'marginal' path status for a specific rport.
>
> > diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> > index d2ca65f70a0c5..4acf23ea8aea2 100644
> > --- a/drivers/nvme/host/fc.c
> > +++ b/drivers/nvme/host/fc.c
> > @@ -895,6 +895,22 @@ nvme_fc_set_remoteport_devloss(struct nvme_fc_remo=
te_port *portptr,
> >  }
> >  EXPORT_SYMBOL_GPL(nvme_fc_set_remoteport_devloss);
> >
> > +void
> > +nvme_fc_set_remoteport_fpin(struct nvme_fc_remote_port *portptr, bool =
marginal)
> > +{
> > +     struct nvme_fc_rport *rport =3D remoteport_to_rport(portptr);
> > +     struct nvme_fc_ctrl *ctrl;
> > +
> > +     spin_lock_irq(&rport->lock);
> > +     list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list) {
> > +             if (marginal)
> > +                     set_bit(NVME_CTRL_MARGINAL, &ctrl->ctrl.flags);
> > +             else
> > +                     clear_bit(NVME_CTRL_MARGINAL, &ctrl->ctrl.flags);
>
> [Severity: High]
> This code correctly uses &ctrl->ctrl.flags for NVME_CTRL_MARGINAL. Howeve=
r, in
> nvme_fc_ctrl_connectivity_loss() introduced in the earlier commit "nvme: =
add
> NVME_CTRL_MARGINAL flag", the marginal state is cleared like this:
>
> drivers/nvme/host/fc.c:nvme_fc_ctrl_connectivity_loss() {
>         ...
>         /* clear 'marginal' flag as controller will be reset */
>         clear_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
>         ...
> }
>
> Could clearing NVME_CTRL_MARGINAL on the transport-specific &ctrl->flags
> instead of &ctrl->ctrl.flags leave the NVMe controller permanently marked=
 as
> marginal across reconnects, preventing the multipath scheduler from fully
> utilizing the repaired path?

Will fix, same issue brought up earlier.

>
> > +     }
> > +     spin_unlock_irq(&rport->lock);
> > +}
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.37=
12426-1-jtaubepe@redhat.com?part=3D9
>

