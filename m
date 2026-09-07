Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4A54B8DE8
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 20:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788813003; cv=pass; b=QrapceCg5FewB/YZtE1JRy9hXEQ1WENN0ogaYQJDWfET6jp0ERdMqrS2J0W5ViZneJtbuq0O7NZAmhUpcFvj8kUm+sCcXkwagPD2RUu/70eKqn4zpgAR8v+Sp6B1WmPlBgTbYvkW67JZEltlGCVFrdWLLjGTzZLeitVepSxM+l8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788813003; c=relaxed/simple;
	bh=mTBFg+ZMh6Oga0I8G8NQ6omhDoRyCGFpY895ehxdIvs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pz+zcxP4kAexoT5PFID93ivkYm+TGajcYOSUOv8g1rkfr2jh8pnsaXfscd+5Ncd4uTgWCVBnA3J/zjki7aEAXo6ftUgxB8LyTsoGYF4FfUQb3JHsYiLKSc0ehxWZTzFfoLRMNnAeMSPQdXmCULNH3HBozQVqNRfYdKifkBsmj6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=S3Fx34mi; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=foyPSoX0; arc=pass smtp.client-ip=85.215.255.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="S3Fx34mi";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="foyPSoX0"
ARC-Seal: i=1; a=rsa-sha256; t=1788812999; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=LBLbh7AjNrnqoybDwuUsbF4Jc6cvTjimw9WRH+88iSBCt+7AxEUSXVKlq9QvgIzVjX
    oTnzm3Lox8AQsUtX0IG9e5ftL2dSwPsg8D9BEqGrtpMWcwS7682RHyevHJJ4QS9+/wO+
    j9itZyQHOaWGlpUHDeLW+sDOpF29ysnuxIec1d+TsDS7hIaPVSaFov9oYDn5vScNO6Hf
    V+OcIe52NCuJ35eDg7nKXrMnLi48CDuIljsxrqxTUFrbfCjO7VA4xLeufnlML8SH4ZRB
    Yvhgm7jlbXlijphbOxqcOtzSWXKm2oMwr3n7v276I9siL7oeW+NL3ikI8EAN/3J/kj1w
    OMPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788812999;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=mTBFg+ZMh6Oga0I8G8NQ6omhDoRyCGFpY895ehxdIvs=;
    b=r9LrzWw2KDzKiGq86xScPJMD2H08kTiUjIaUfE3OSWzZopwh6KzojRanGHjeSg6uBd
    twVeszoD1dtF3SwbvX0lGiTe6QFHjGOwgPJvyN9B+cB8tJp8LyTdQtrydVr8HePztD/+
    mOWelUYbwDm8eFRXvWAhl93YiGIgSwhYggZebGZ3KcrwXh3yIyumWq/3F7N5WUVwHreR
    BAoWqakIONr6P/C0mm2hQpEiBflsIYH08cdgG5uJicGIEnb/pDK9arGA1+P8JOFN4S4b
    nzMmud3UyzzAWHgPDniXjvXdB3igeScbmmqwHqbuVVwGi5i5YXEj/VDTSVLEVoEEiJCH
    MICg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788812999;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=mTBFg+ZMh6Oga0I8G8NQ6omhDoRyCGFpY895ehxdIvs=;
    b=S3Fx34miY6bioL9BcTDeSA55D/4hj9epzxHD1fJ9pa1s3l4jlGRepYiGT43c2Sv2G8
    8ZvwugkgOXOtUBAhGCp0t1YlExBj19ckBD8308lyB7jY07NZx2ymMlWh3inRBkxnAqV+
    wPnJxr0cBu2YTsP7ngiAvp+aS8D+u7I+APqXpF5CW7zQmE+t1xojOBoZ0vzXqsB1clO/
    U1zxT48n5oJFVSZKgkYA1xn8hNEnH0O2Ms54nDWSAcTkkUqcrvlyvTEQkLL/zR8Er5SX
    0tA0SqQHZWnzzaOXoegd8lR4RhdwOCyGl4CA3BX+N33t+OcupwLB+TjeQin1hYL2g9D3
    vfwg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788812999;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=mTBFg+ZMh6Oga0I8G8NQ6omhDoRyCGFpY895ehxdIvs=;
    b=foyPSoX0z/DcFVpw5Rh0yDFpExY9kr57WUp+Dfb8aZOE7ajYL8W8oGSDouj1jhLz+1
    hNze4YP5WyuPqJcrgWBQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V2DZ1j3VzZR8ZYnVF9Wg="
Received: from [192.168.65.16]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id ze37e1287KTvCzN
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 7 Sep 2026 22:29:57 +0200 (CEST)
Message-ID: <e37a178b48d23abdfa4fcc9e5efa060e5b5ca76d.camel@iokpp.de>
Subject: Re: [PATCH v2 1/4] PM / devfreq: Fall back to previous_freq when
 get_cur_freq() fails
From: Bean Huo <beanhuo@iokpp.de>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Date: Mon, 07 Sep 2026 22:29:53 +0200
In-Reply-To: <20260907193342.841D91F00A3A@smtp.kernel.org>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
	 <20260907192140.2701755-2-beanhuo@iokpp.de>
	 <20260907193342.841D91F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-09-07 at 19:33 +0000, sashiko-bot@kernel.org wrote:
> Pre-existing issues:
> - [Medium] devfreq->resume_freq is incorrectly overwritten with devfreq-
> >suspend_freq during system suspend, causing devices to resume to their
> suspend frequency rather than their active frequency.
> --
>=20
> commit 252cf4045ad4d642d45961b4d6845aa317e8ee57
> Author: Bean Huo <beanhuo@micron.com>
>=20
> PM / devfreq: Fall back to previous_freq when get_cur_freq() fails
>=20
> This commit updates devfreq_set_target() to fall back to the previous
> frequency when get_cur_freq() returns an error. This prevents uninitializ=
ed
> stack values from being passed to notifiers during frequency changes.
>=20
> > diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> > index f08fc6966eaee..f20d9a6607791 100644
> > --- a/drivers/devfreq/devfreq.c
> > +++ b/drivers/devfreq/devfreq.c
> > @@ -348,9 +348,8 @@ static int devfreq_set_target(struct devfreq *devfr=
eq,
> > unsigned long new_freq,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long cur_freq;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int err =3D 0;
> > =C2=A0=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (devfreq->profile->get_cu=
r_freq)
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0devfreq->profile->get_cur_freq(devfreq->dev.parent,
> > &cur_freq);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!devfreq->profile->get_c=
ur_freq ||
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devfreq->=
profile->get_cur_freq(devfreq->dev.parent, &cur_freq))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0cur_freq =3D devfreq->previous_freq;
> > =C2=A0=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0freqs.old =3D cur_freq;
>=20
> [Severity: Medium]
> This is a pre-existing issue, but since we are modifying devfreq_set_targ=
et(),
> I noticed a potential issue with how resume frequencies are stored.
>=20
> Further down in devfreq_set_target(), there is this unconditional assignm=
ent:
>=20
> drivers/devfreq/devfreq.c:devfreq_set_target() {
> =C2=A0=C2=A0=C2=A0 ...
> =C2=A0=C2=A0=C2=A0 if (devfreq->suspend_freq)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devfreq->resume_freq =3D new_f=
req;
>=20
> =C2=A0=C2=A0=C2=A0 return err;
> }

this should be a seperated fix patch, not for this patch.

