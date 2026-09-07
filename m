Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A8B3B1031
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 20:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788814419; cv=pass; b=Ilug26L4BJ+r1+k6W6rKPFVH2PlpMJOvyehr0RLDuRaTvf5P7CXXJ2ApRy/yjHIMTH1W6720adGNYDU7bfiQMO5t8aLBgK+wHCfVgKKG9sE6ph48mg+br93OwVOKIW0g3m0RxjYlhGCrYRgswdMGYdzxwyiSchAnRH53dGXajM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788814419; c=relaxed/simple;
	bh=oADjS74yaCkWe9821RWCLnkuNy1GBgTXgo9PkAO7+T8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OY5OwSIGW+Jpa9v389G5iTdBj0zhrzL+IY6xgWPn6HS2BHkUEEOu5Rz5q7Bwk9VAM58E7z6w8Y1IrZ9rfYNU1AiTByG/Y6QcNq6tOQBrueNyM+gtN+1iWZJiS1KoDy5MpNXo6UknHdg7paxd2p1H6k0D7Mtoq/A+gNqDKe1zJ18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=nDcx8v2r; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Ysj3Vlxs; arc=pass smtp.client-ip=85.215.255.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="nDcx8v2r";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Ysj3Vlxs"
ARC-Seal: i=1; a=rsa-sha256; t=1788814229; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=iUS4C8ouwLvgk/q3JnsZFrKg4XFLY8Ko8FC6u6Dzsb4EfQ/TUHa3VJJSMGdKwzA1FD
    DXRoN2/sB/RI8cgj62YZDTIIisnWODq7K6KFo7zn75Phn7Dc8avgRPMf4jFllsz81ZRd
    nkA+wNmV0rZSMEMhF5Sa1XDSsOY1p7SWte3Ht5JmPvS5AjqhIEHK+AQpbQmXHj1lSrhu
    UB8NIWqTjTVEFx8P3/eE9Y1/AG/XiGcGp0f7tkbQia4ANvhdhnXO3loKL0dNxcooEBYo
    6jvhDzigFTv0xx4mQ85K+0QZTfAYZEAl0fo/edBpVHd+z2NatXKE31WVSmNYxJyO9oWi
    O9iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788814229;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oADjS74yaCkWe9821RWCLnkuNy1GBgTXgo9PkAO7+T8=;
    b=f+2bRREgqOtLnrcaGLpczaalfpgbTNJ813UFj4/iVj+gFC7NjrIoE/iFFHPAv9fSwR
    FnPJlz/vxJxRubXqgwXIcFs9I+ormFepP8CRG96LNLzorsOWSrm64VVAqm9ExmpOkCY5
    6zVQQgI3nnG5JQfm0/cn5EorO7pJ6xXQ29lTtf6eYKyOWfTsr+SXb5DMV8qWK3uPo2uz
    KyHar/KClE/N/mDp2mRLChXK0TwBsgu7O0j4P2M2pQVCQY7cp6q0I0RMMEcLLZLgigUU
    IsY7KXKQnKPFqG+Rj/bQTkeN2rT/ntaPmG/H2p0BlfqK2qiCxxLvAnR3l4xiDzKwQdVe
    /0TA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788814229;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oADjS74yaCkWe9821RWCLnkuNy1GBgTXgo9PkAO7+T8=;
    b=nDcx8v2r2aUiozDWrsiVF0DwW3UK4SPt5LVJztE3hXKrV7iA5Fr+Nn7AhmslUA0TCP
    drjUl1rl94Zt5J8Tna3p+1IiAHAUyP1ZOqn2s6fT8iCy6d1k76sjViu0Xc9ZpzhDKFMv
    W3o8AJBFGLriWDI1C/Eu20oh+wEp3PUX3kQOYw6nK1igf3YtpZ41KT2OmZBT+8+vavcw
    OJsCdcNwT5YDPk2mliDLlkHU62h+n3/4k1BMCIJnXm9KOZZKedj7NNrp/EemiGS0OTeE
    JpEqHiUOSQDQUr/nONUM8TTZgQEejOU30SKGzuJIsswxYCi908QRifqrx+zPePN9nkyJ
    580A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788814229;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=oADjS74yaCkWe9821RWCLnkuNy1GBgTXgo9PkAO7+T8=;
    b=Ysj3VlxsXVwv/kGE33yyOLFitWDnKbugupvPs5pHYErddQVq/tE9ApTfU796eejYxS
    PABzyS1OAVxVlmBymgDA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V2DZ1j3VzZR8ZYnVF9Wg="
Received: from [192.168.65.16]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e1287KoTD1Y
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 7 Sep 2026 22:50:29 +0200 (CEST)
Message-ID: <9e46b8e788fe6f935db18e7968e73c63cc0786bd.camel@iokpp.de>
Subject: Re: [PATCH v2 3/4] scsi: ufs: core: Record the frequency the
 controller starts at
From: Bean Huo <beanhuo@iokpp.de>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Date: Mon, 07 Sep 2026 22:50:27 +0200
In-Reply-To: <20260907194106.BBF131F00A3A@smtp.kernel.org>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
	 <20260907192140.2701755-4-beanhuo@iokpp.de>
	 <20260907194106.BBF131F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-09-07 at 19:41 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s)
> to consider:
> - [Medium] Unprotected concurrent modification of the globally shared
> `ufs_hba_vps` structure during asynchronous probe.
> --
>=20
> commit d1d1b66402811c53b2fbc0d56ed07cd4f77540ee
> Author: Bean Huo <beanhuo@micron.com>
>=20
> scsi: ufs: core: Record the frequency the controller starts at
>=20
> This commit records the maximum frequency during ufshcd_devfreq_init(),
> preventing devfreq from reporting an initial 0 Hz frequency. It avoids
> an unnecessary governor scale that resets the same frequency and gear.
> It addresses the issue for both modes with and without OPPs.
>=20
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 2ba244cf40ac7..351c76094b9ff 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
>=20
> [ ... ]
>=20
> > @@ -1727,12 +1722,21 @@ static int ufshcd_devfreq_init(struct ufs_hba *=
hba)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (list_empty(clk_list=
))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > =C2=A0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0clki =3D list_first_entry(cl=
k_list, struct ufs_clk_info, list);
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!hba->use_pm_opp) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0clki =3D list_first_entry(clk_list, struct ufs_clk_inf=
o,
> > list);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0dev_pm_opp_add(hba->dev, clki->min_freq, 0);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0dev_pm_opp_add(hba->dev, clki->max_freq, 0);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * ufshcd_init_clocks() has =
already set the clocks to the highest
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * frequency, and nothing ha=
s changed them since. Save that
> > frequency,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * so that devfreq and the c=
lock scaling code know where we start.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->clk_scaling.target_freq=
 =3D clki->max_freq;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->vps->devfreq_profile.in=
itial_freq =3D clki->max_freq;
>=20
> [Severity: Medium]
> Could this introduce a data race during asynchronous probe?
>=20
> Because ufs_hba_vps is a globally shared static structure assigned to all=
 UFS
> host controllers by default (hba->vps =3D &ufs_hba_vps), writing directly=
 to
> hba->vps->devfreq_profile.initial_freq mutates this shared state.
>=20
> If multiple controllers probe concurrently during system initialization
> (e.g. via ufshcd_async_scan), they will race to overwrite this field.
> If the controllers have different maximum frequencies, they might overwri=
te
> each other's initial devfreq settings, causing devfreq to start with an
> incorrect frequency on one or more controllers.

hba->vps points at one global structure shared by every controller, but thi=
s is
not new in this patch, The same issue exists in wb_flush_threshold, which i=
s
even writable from sysfs, so a write on one controller changes the other on=
e,
for the system with multiple UFS controllers, it is better to seperate
ufs_hba_vps by using devm_kmemdup.





>=20
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_vops_config_scal=
ing_param(hba, &hba->vps->devfreq_profile,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &hba->vps->ondemand_data);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0devfreq =3D devfreq_add=
_device(hba->dev,
>=20

