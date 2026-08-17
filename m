Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE8C39EF05
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976779; cv=pass; b=OFFYLQmZZySEmkK/Z2oslG/KgMgkDuVumUlLygpB9N89YxP2A7lVHiXquvBZE6tPpPvvSKZckAJ5tdHzKkQRUq7Pu7HneuOtOsfVUARftmVwSUphX7+xxtfmJOIcNQVDFzrhXVix47eueS2AIFZDTozqbf2KGgt1S+47e8XDNKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976779; c=relaxed/simple;
	bh=5Fx/jLBt4NjgKsouyRUj62+jA3S0tsigRG7T1AupIoU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k2a2cxZF2dOhDYblGwG+WSG0v7C1aD7fMIwf1voIPX1bL2cVMmkOpJ8K0AlkUnAJGYFFiTtap4j9dfhbffKHouhbVvEk4ZPgYHvjM/0ud2iinpP2rgpvb8oFw1RhxD5vwwv+sWEAkKFYZpA5cpTs+dD/3fu1aOgW5mPYVNK71y0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dTEFdRV9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iS2uGnrd; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dTEFdRV9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iS2uGnrd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786976776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xVoO4PGa93cBgoTmsmPlqVbYL9tE4BTnM50GMQnOmg=;
	b=dTEFdRV9uiiE7aQI0N0cTEB0Czz5GMPIP2fp9PJmdzuPh6o7DbUNDzn7jDn5tbUdtWmPQD
	M6blIgsOmQw78mJ1TcFpJ2d0UgxEqGIyYWeEMIUGxuNK8VQCWyNmqIx03A+QcagftIUXZ7
	U+AnxRcM3/tHfcqbyuIOGBozZhrw3YI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-gPBv8xJQPpGK4biiXnHgKg-1; Mon, 17 Aug 2026 10:26:10 -0400
X-MC-Unique: gPBv8xJQPpGK4biiXnHgKg-1
X-Mimecast-MFC-AGG-ID: gPBv8xJQPpGK4biiXnHgKg_1786976769
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-47feac2021eso1949339f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 07:26:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786976769; cv=none;
        d=google.com; s=arc-20260327;
        b=Vn3wi9tUVDZYWGrAzxdjs2WpbdUu9J+OA8CM7VY+ecfMoBeTT/j9KVfsyhCTKZ6Znk
         8zhJ7ZMR9L3qabzf+7M/MpBeAIK7/dcpQeEETVbOo5f/94MdYlEKY474nDFwHHUxBp4g
         3GwX3BBocDYutL+DUZgIo45Dg3LH8pEAVvJB/zSLwdGf+tGFSk6h4sSAZnkwntnMvcXQ
         blF/cIDejuTuk9KMS3qCBhmfnJyWlWk7V4OVBYbpSD0hHMPHSim/F0vfJIPW1mU8bxUO
         tBo2x9S8W6BcbaSBnRCeMhDo5hxAV2oozE5tBiCLNHsgxreGEJUhTKTe9HLHXmBot+tJ
         zTtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0xVoO4PGa93cBgoTmsmPlqVbYL9tE4BTnM50GMQnOmg=;
        fh=gUfsL9ppqjROwdjOOpA7gVU01au1qshFQ+BhECdF0Kg=;
        b=hPyiflaL00zBLx3Y4rbW30iGXc231XT3Gc1zkw6VaybVCrKPpqF2Sd0TFHMMctiUZ9
         qKS8w+w4YZCFz0siFlTxMToraFVJLztnLqM1WCtV+olU2U7Omh5txSjsWWUycXtKfUAC
         aphGSRLeeX4NMdMo2jcyosJr3LvG7cCFUGRi5d/SvkTGzEcjV3PLD2XiBTrnGAbAUo7U
         XFU+MWAWruDJx0qIr6PlDhe9+kQfmbpCftzogvYC79zeZZ7z3zLLK6TAIXKaine2d1bG
         B92RLpRUnL6YKP+PYRXAkFCNdMXVdsHThim6BpjJQBZz2/rpcM0mbUHoUgVEbam2pfax
         +Ukw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786976769; x=1787581569; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0xVoO4PGa93cBgoTmsmPlqVbYL9tE4BTnM50GMQnOmg=;
        b=iS2uGnrdZdGpvgPbJsX/oU3E0DhG+WiPQIEQMA0hoBRPZHE00qWBAOqvsJMxUKgFMJ
         7DDROVZXIkcZuWty/z6cI45ijNMJkgFCZ6Uxt87kM2Mx58xW4pozEC1m5uNR7IgtJ1KN
         uurkVs6/sECQWb1dJTY8FbKcBO13/Rlvv1Jin+357S0pRcYV8NAd4RY0SPW/Hb/doYIm
         R0uQwbL2h6A4pXbV6ZbUxoPRN/8EotwLahScGfpWjZK8IUrzWQOLKfiygiPE8rxW2A3i
         Gp7QWbMjg4yLytIAYtkunTAh9S4Mga+kJOI4AhaIqBEHXp13BokrQxIgQr4Z930ZSA3v
         5/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786976769; x=1787581569;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0xVoO4PGa93cBgoTmsmPlqVbYL9tE4BTnM50GMQnOmg=;
        b=g1yPnsB6sTConnZH4XN0QUXEKvj2d3614/kiZ90kPT3BgDcZWQJJfyAVPWULi8iAei
         l7Vf77VZ9aecd9uxQDwulofbTxxfZ0IIOiH69PkdqtX7u/cve+xT2zm1hnbuEMIOKfNj
         p0Tij3WFXNKJ1dnJWvcMbblPN+/gwIxC613m3FXwcTFnT55IkgJHM8DDOkrVdaNwEA8D
         xaUjI6yFjMcG9ub26LtSSRmLEgfm37UJ9EQBR+5gaHv6chnn+G+KWWtWDcNrdO5+Aj2C
         eKYqDjGVkWrMdTDOznefXdlvwAGD7ggZMy4rL4RJHjgKzmCZkjzltaKiSAgLQEHzTBiC
         e8tA==
X-Gm-Message-State: AOJu0Yx3pGZsUDg4Bx3p2n5MnYWpi2Z3KMNo7/0vkmM4Bbpz2pcQdHbF
	pozwm7cDlsl+X05SX5AWxSxDTw314W/jCIm+XqH5EinMi0RYYN87FgbqSKJa2ApiuU+I2qK7fdb
	NyX9o/Ves/Q7LU2k0jEKXn+bVA4wd5z8VvPUbMnDcMZvWcTZkZa+U1zH93b8JK7GgIIfzsr+s1W
	cdiDJbNAK6TWxnynDQINuwpmcy5RnTzvmPia6n9pgflcCYBg==
X-Gm-Gg: AR+sD127O/nyiAVY1NFKYmLjTmilR4VnjAiOcrxufBGU80cMgx8/TB269SHUO79gZWd
	fYM7qQkHHz20jGgBvw1uYY+TMlonHkhdNQsBDsnZaxO+TxV0xxoxFFQiUzZFAfQPtZ0oGrZs0H2
	aRspVAVar5sYFeHvdm1GFWJwhWvSZkno2a7mC2xdjSFj3oVcHk0O756Cz3K9zSo4T2cHK9hOFhY
	Ajvh0jVTbnFemS0pg==
X-Received: by 2002:a5d:4b45:0:b0:47f:8f8f:db74 with SMTP id ffacd0b85a97d-482a908a3ddmr728345f8f.12.1786976768695;
        Mon, 17 Aug 2026 07:26:08 -0700 (PDT)
X-Received: by 2002:a5d:4b45:0:b0:47f:8f8f:db74 with SMTP id
 ffacd0b85a97d-482a908a3ddmr728270f8f.12.1786976768264; Mon, 17 Aug 2026
 07:26:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812181300.3712426-1-jtaubepe@redhat.com> <20260812181300.3712426-12-jtaubepe@redhat.com>
 <20260812183533.423061F00A3A@smtp.kernel.org>
In-Reply-To: <20260812183533.423061F00A3A@smtp.kernel.org>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Mon, 17 Aug 2026 10:25:56 -0400
X-Gm-Features: AcwNN1WoAXOWHM0UvOaW2H_aN_oGR153U8en9mLKgo-ACm1moZ0bC2Z130Jd7D8
Message-ID: <CADRr4bfgy_e=2QjTKxGrUWXvKW6KoJZZOmDabgzp0yYx3SSfAw@mail.gmail.com>
Subject: Re: [PATCH 11/13] scsi: lpfc: enable FPIN notification for NVMe
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 2:35=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [Low] Logging Formatting Defect: Error message is improperly split acro=
ss two consecutive `dev_info()` calls.
>
> Pre-existing issues:
> - [High] Concurrency / Use-After-Free: Lockless access to `ndlp->nrport` =
and `nrport->remoteport` can lead to a Use-After-Free due to concurrent unr=
egistration.
> --
>
> --- Patch [11]: [PATCH 11/13] scsi: lpfc: enable FPIN notification for NV=
Me ---
> commit 6d41021b653095acd49d1f7828d07c1405835a16
> Author: Jesse Taube <jtaubepe@redhat.com>
>
> scsi: lpfc: enable FPIN notification for NVMe
>
> Implement set_rport_marginal callback using nvme_fc_set_remoteport_fpin()=
 to
> enable FPIN notifications for NVMe.
>
> > diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_att=
r.c
> > index f4e8164b94abb..d54899cceed99 100644
> > --- a/drivers/scsi/lpfc/lpfc_attr.c
> > +++ b/drivers/scsi/lpfc/lpfc_attr.c
>
> [ ... ]
>
> > @@ -7134,6 +7134,30 @@ lpfc_set_rport_loss_tmo(struct fc_rport *rport, =
uint32_t timeout)
> >  #endif
> >  }
> >
> > +static void
> > +lpfc_set_rport_marginal(struct fc_rport *rport, bool marginal)
> > +{
> > +     struct lpfc_rport_data *rdata =3D rport->dd_data;
> > +     struct lpfc_nodelist *ndlp =3D rdata->pnode;
> > +     struct lpfc_nvme_rport *nrport =3D NULL;
> > +
> > +     /* Break early if NVME_FC is not enabled */
> > +     if (!IS_ENABLED(CONFIG_NVME_FC))
> > +             return;
> > +
> > +     if (!ndlp) {
> > +             dev_info(&rport->dev, "Cannot find remote node to ");
> > +             dev_info(&rport->dev, "set rport marginal, port_id x%x\n"=
,
> > +                      rport->port_id);
>
> [Severity: Low]
> Does this code format the output correctly?

Will fix

>
> Because dev_info() prepends the device name and KERN_INFO to every
> invocation, splitting the message across two calls without a newline on t=
he
> first will cause the prefix to be injected in the middle of the sentence =
in
> the kernel log.
>
> > +             return;
> > +     }
> > +
> > +     nrport =3D lpfc_ndlp_get_nrport(ndlp);
> > +
> > +     if (nrport && nrport->remoteport)
> > +             nvme_fc_set_remoteport_fpin(nrport->remoteport, marginal)=
;
>
> [Severity: High]
> This is a pre-existing issue, but does this lockless retrieval of nrport =
via
> lpfc_ndlp_get_nrport() safely protect against concurrent unregistration?

Will fix

> The macro performs a lockless double-fetch of ndlp->nrport without acquir=
ing
> ndlp->lock:
>
> drivers/scsi/lpfc/lpfc_nvme.h:
> #define lpfc_ndlp_get_nrport(ndlp)                              \
>         ((!ndlp->nrport || (ndlp->fc4_xpt_flags & NVME_XPT_UNREG_WAIT))\
>         ? NULL : ndlp->nrport)
>
> If a concurrent remote port loss triggers lpfc_nvme_unregister_port(), it
> could free the NVMe remote port memory before setting ndlp->nrport =3D NU=
LL.
>
> Could this code then read a dangling pointer and pass nrport->remoteport
> to nvme_fc_set_remoteport_fpin(), resulting in a Use-After-Free?
>
> > +}
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.37=
12426-1-jtaubepe@redhat.com?part=3D11
>

