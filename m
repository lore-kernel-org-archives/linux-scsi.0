Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C897F3264E2
	for <linux-scsi@vger.kernel.org>; Sun,  7 Jun 2026 10:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827811; cv=none; b=HzwXdaFEQ8OPOvh8Fe0ke/OxYQI+pV2LfT9g/d9MssPUuev7doDEsom1nX9ZxyC4bTaNDuLpsadZpd5v1GzeGykeTSvIJY4ea60SeVnyszOFt91IfkN5yvqeDsAOE4a71BSerbUGJTSRnjQo4KvTXWtVC2e647f0wbFbaQKPNY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827811; c=relaxed/simple;
	bh=Hojva8nHXdsdgCE3IYmHbr6iLOXSsLA16ZVrZ5BNUrI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oem/a1lxEAIzZyolSj/KPmXpVj9wtrYC+tJbPHkFV4ZyGJdxZIf9KRkN0ZUua8I0MTZ6mqStMB+LEQCO2M9cDtHwV4q0eM6TeREhO/cE1gHMGbLx/i1X8qqSlzjNuUyWZMoUbbL7csj4HR55VJsi7W1vFLQFCFGFLhKAk04Z+9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MqjK8aEs; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MqjK8aEs"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490abf12f0fso16570345e9.0
        for <linux-scsi@vger.kernel.org>; Sun, 07 Jun 2026 03:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780827807; x=1781432607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1i2PJYgKQ0/FfokPgk6H3Vr4KcPlj/liiAyES78nj8=;
        b=MqjK8aEsvVoe0bK6mDrRuVVCBdLd8/lp2FSrH6kv9ry3bmdimgfP/3fELe3RcuuNZ9
         6TO1+hG+7OLJt0sHUonRc2YZe1kJcu0RW61FkHkAQhPkLI9owVrA4Yu4/2BHKCevHC7d
         qc2a3AaDgQi0SAmI0q5HLuEmOB6qILkAodGJ7DkTVJ0FqvbgNJnnSqY/mdT+6nASFub9
         yKi9bqKHvh2vtJlV8VEzcYGphDa6pTjXjPP0JK6AKL27CK6EBSl1kHmpaeY2LBZDYLTK
         M2kravGzE8CuOHzc1HfecNEsum1MZRjhoQs3KYRAWiCkex5wV3FuACnw/l5GuhlfZTat
         XIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780827807; x=1781432607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z1i2PJYgKQ0/FfokPgk6H3Vr4KcPlj/liiAyES78nj8=;
        b=fKgE7Fl8NuJW/ulyVMYXWmSrgsN28Jb7uBGCfBo3QbHp4eII3k3eIfd9Tu7dcphSU/
         D6MOr3DTBbL96GMmWnOvxg/EpZ02n1PL73QbR1Z845t2duhJoFuzgREoohlE4hVkz689
         GHX0vSBBUY/xMyzdF5zUz2csf9a1B4HTBvRB5rp0bKu0bh6zQxZOHNVc0AjV7ASJxgvW
         /+U4w86R31poLAXZWuQYg+o38BzKvSVBG8htkK4NvgJXBBg2J48IZyP1PFbQRw/Gkcna
         bYOrWgr5ga/dg/73d16px2PPENFwM6U+Hn3yhk9xqbFaLK6gllM03LJmSLW99XThs4PM
         QxgQ==
X-Forwarded-Encrypted: i=1; AFNElJ9/wwHNWfK72QJQj77uV0sj3Y4v0o+26R7CNTQJwiUh6VKi+rQ+DPO3qy5KhLg4FpXPo9aa69SRFc/9@vger.kernel.org
X-Gm-Message-State: AOJu0YwTaD65ys52+BUcFjIGpBStdr1yWDONaIJiqyOgOSWb+h28n1mH
	i9ywr+rQlGAzWLifSqoBfPMNYPziFTtwHViQjbMtDn2/Lx8s8vrIa28h
X-Gm-Gg: Acq92OHzhPA9aQ58CWFUXiR8eBzBCV/AoNUHAa+160G1pXBqMmuNARTnb/4rr++0XPq
	7zJgtFHWKloYfrAG+yRNTeWCIjaBgo2Y2ApMeBOdQRfGUz4sgKPmn/iKyRl6PR5MJx5Z0uYXUqD
	aDdwU/rnVhi12gVJ7dWTsHBs9vmpgmnMjgMTpA5G/bIXk1P2WaPrHeeAujeFv7k1tyzDM15ynw2
	pyvi/sBkxVPsc8Av64gQxn4ut9LKA5jgK7gdNEqZwOV0SstsdtYtPLC/CxFbjnbaMTsSA2lFprv
	YfJu01vjPvQpifZOJCcLzUJC+A6NNvgOhxn9FoEv8XSxDCVkruVHB+Zm/1zz31vXgyfTz+xRw/T
	csxu0PWDkuexkywB+qN7DrIbTJu5peTrvTpiz8LMXt/OInTNJp1P3Yzzmy9dR0DTsLVSGkkhW4y
	hrlUsmLTzZGg1MTqiupiL2yx1X0XxqLSATHBPXINE82oTEYc/CJZEiLcfEB7jGVJf3ZplvWqA6k
	cCuQh78ew==
X-Received: by 2002:a05:600c:4689:b0:490:bbc1:c9be with SMTP id 5b1f17b1804b1-490c2c63f53mr142083535e9.0.1780827806915;
        Sun, 07 Jun 2026 03:23:26 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2c9ea37sm318815445e9.0.2026.06.07.03.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 03:23:26 -0700 (PDT)
Date: Sun, 7 Jun 2026 11:23:24 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org, Arnd
 Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH next] drivers/scsi/aic7xxx/aic79xx_osm: Use kstrdup()
 instead of kmalloc() and strcpy()
Message-ID: <20260607112324.1015af5b@pumpkin>
In-Reply-To: <921d629d-79ac-46c3-8e7e-8ac92a50678a@wanadoo.fr>
References: <20260606202633.5018-32-david.laight.linux@gmail.com>
	<921d629d-79ac-46c3-8e7e-8ac92a50678a@wanadoo.fr>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 6 Jun 2026 23:42:36 +0200
Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> Le 06/06/2026 =C3=A0 22:26, david.laight.linux@gmail.com a =C3=A9crit=C2=
=A0:
> > From: David Laight <david.laight.linux@gmail.com>
> >=20
> > Signed-off-by: David Laight <david.laight.linux@gmail.com>
> > ---
> > This is one of a group of patches that remove potentially unbounded
> > strcpy() calls.
> >=20
> > They are mostly replaced by strscpy() or, when strlen() has just been
> > called, with memcpy() (usually including the '\0').
> >=20
> > Calls with copy string literals into arrays are left unchanged.
> > They are safe and easily detected as such.
> >=20
> > The changes were made by getting the compiler to detect the calls and
> > then fixing the code by hand.
> >=20
> > Note that all the changes are only compile tested.
> >=20
> > Some Makefiles were changed to allow files to contain strcpy().
> > As well as 'difficult to fix' files, this included 'show' functions
> > as they really need to use sysfs_emit() or seq_printf().
> >=20
> > All the patches are being sent individually to avoid very long cc lists.
> > Apologies for the terse commit messages and likely unexpected tags.
> > (There are about 100 patches in total.)
> >=20
> >   drivers/scsi/aic7xxx/aic79xx_osm.c | 6 ++----
> >   1 file changed, 2 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/=
aic79xx_osm.c
> > index feb1707feb7e..97ebee94230e 100644
> > --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> > +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> > @@ -1233,11 +1233,9 @@ ahd_linux_register_host(struct ahd_softc *ahd, s=
truct scsi_host_template *templa
> >   	ahd_set_unit(ahd, ahd_linux_unit++);
> >   	ahd_unlock(ahd, &s);
> >   	sprintf(buf, "scsi%d", host->host_no);
> > -	new_name =3D kmalloc(strlen(buf) + 1, GFP_ATOMIC);
> > -	if (new_name !=3D NULL) {
> > -		strcpy(new_name, buf);
> > +	new_name =3D kstrdup(buf, GFP_ATOMIC); =20
>=20
> I think that kasprintf() would simplify code and do the same.
>=20
> Otherwise, s/sprintf/snprintf/ could be done, as in the patch for=20
> aic7xxx_osm.c

Looks like I missed the sprintf() here.
I was doing a lot of simple changes and trying not to rewrite too much.

Looking a bit deeper into the ahd code there is an 8 byte pointer
that usually references an 8 byte buffer.
A fixed char name[16] will use less memory overall.
The only other thing it ever references is the result of:
	sprintf(buf, "ahd_pci:%d:%d:%d",
		ahd_get_pci_bus(pci),
		ahd_get_pci_slot(pci),
		ahd_get_pci_function(pci));
which it only does temporarily during ahd_linux_pci_dev_probe().
Even that is usually less than 16 bytes.
Given the probe function pretty much never fails, the scsi%d
string could be generated earlier with just a trace to tie
the two together.

But that is far beyond this set of changes.

Doing a 'v2' that isn't just an edit of the email will be a pita.

-- David

>=20
> CJ
>=20
> > +	if (new_name !=3D NULL)
> >   		ahd_set_name(ahd, new_name);
> > -	}
> >   	host->unique_id =3D ahd->unit;
> >   	ahd_linux_initialize_scsi_bus(ahd);
> >   	ahd_intr_enable(ahd, TRUE); =20
>=20

