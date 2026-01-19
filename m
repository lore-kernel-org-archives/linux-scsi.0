Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD52927F171;
	Mon, 19 Jan 2026 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768838579; cv=none; b=lFzxtj6PQSutaSndGcoeAhC51mG3fPfD61tqIL6BaMmPnzzQaexZnwOsRtZQEYQjlgyN6YuQ2pmS6Z28RkTfTMcMusS9/RjBXtGwpwWb/4fNErkPq1qVpIGcqW8weI5U688LoafzSiCMRrphUOqjKtMj1jQg3MqweZiY2zryspg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768838579; c=relaxed/simple;
	bh=ktq8vOgwfZf1eYjzxIoYtfzpMgZGFYlyLj+sVg3V9ng=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lesVdTgW3Jqfsg5qmjl/Lp9pKyIlazeg1d0zBrngR3kc6marqVxwAYh3YN4bbNKy0HApI5hA0Afgh+GvXE3BUr/o6lvYV4akMV/R/1IPcP5s+eauwh3KWOFENqID2vjGpUGzROTMB+XiW6a4lI81UPnnByB+PkLW5X6me2oT+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=ktoLmtOc; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ktoLmtOc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1768838576;
	bh=ktq8vOgwfZf1eYjzxIoYtfzpMgZGFYlyLj+sVg3V9ng=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=ktoLmtOci7zIjp04zHstEm+AcFPtcPf8bya1ACnH0f4crKhY9OKDF6/+N9IQaA4wC
	 v/uJm5ez6tDLRmYTf2HSd4S82Mi6x/iyde/9CmsrwtLLgb/3eGkgs2Et4OCwyMGEVh
	 QWxo8/4qYbbTP+3MZ7qWxMwQRtVD8fj7ECtqIVhs=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 6CAEC1C01CC;
	Mon, 19 Jan 2026 11:02:56 -0500 (EST)
Message-ID: <9308e357ecff18971b216c5e037b89b66acf7606.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: Don't free dev_name() manually
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Greg KH
	 <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2026 11:02:55 -0500
In-Reply-To: <aW4_fbfNUMTDTAN1@tzungbi-laptop>
References: <20260117193221.152540-1-tzungbi@kernel.org>
	 <de7b19fe19ccb117cad8cd32d9c51796ee81b752.camel@HansenPartnership.com>
	 <aW4_fbfNUMTDTAN1@tzungbi-laptop>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-01-19 at 22:28 +0800, Tzung-Bi Shih wrote:
> On Sun, Jan 18, 2026 at 09:45:26AM -0500, James Bottomley wrote:
> > On Sun, 2026-01-18 at 03:32 +0800, Tzung-Bi Shih wrote:
[...]
> > > > =C2=A0
> > > > =C2=A0static struct class shost_class =3D {
> > > > @@ -279,11 +278,9 @@ int scsi_add_host_with_dma(struct
> > > > Scsi_Host
> > > > *shost, struct device *dev,
> > > > =C2=A0 goto out_disable_runtime_pm;
> > > > =C2=A0
> > > > =C2=A0 scsi_host_set_state(shost, SHOST_RUNNING);
> > > > - get_device(shost->shost_gendev.parent);
> >=20
> > We need a reference to the parent to prevent surprise removal ...
> > where else is the reference held?
>=20
> It looks to me the same question as above.=C2=A0 IIUC, device_add() holds
> a reference count to its parent[3].=C2=A0 Drivers don't need to do it
> explicitly.

That's not good enough for SCSI: we have a rather complicated state
model for hosts.  device_add() doesn't occur until the host moves out
of the SHOST_CREATED state, which can be quite a time after device
_initialize() so something has to pin the resources until then, which
is why these references are taken.   You're certainly free to suggest a
different way of doing this, but you can't just get rid of the existing
mechanism without replacing it with something else.

Regards,

Jaems

