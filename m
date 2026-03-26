Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA5134E747;
	Thu, 26 Mar 2026 18:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774548721; cv=none; b=MdU1t3AQ9xKbvrWHQ+jXA1v3subGwlEkuVndlwCPCTBMIVa2/hVDQ8bmfQrC1B0T47ppDJT37sF0BQ+NxyNwiNjDCfSXY299JFb50jVHnKSijk5kj90CI1zUEGioQpMil3JuVh9/5wegoVM/a1S7RpQM9j2cz3TNHSCf4xDhFhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774548721; c=relaxed/simple;
	bh=6uMxnzpbo3gB14Yo5tKI8r6+IG5cODG/qNqvlakdHIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0voD4qjwxhRbU2EbZUWmSVhBELhfO/lo/N6qrd4upLoqURlepO3vBDp3nlNK0LuhUwjzLZfC1phhlU63udWHGbXjFyqBbaAnQqpseqQnY28tHZd30AEYzS8CGwyBhnYOiL7OslGELMTpU6HdRZxe88+tS2YO2f+hDpp5GacL1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=felix.busch1@gmx.net header.b=jPuUvaFj; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=felix.busch1@gmx.net header.b="jPuUvaFj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1774548713; x=1775153513; i=felix.busch1@gmx.net;
	bh=Tp6QKWQhmdBHaTWFKn5wQor30Rz478JBzTUpuMZvqaI=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=jPuUvaFjQc8/Sb6o6UpgLxD+Y7ailt5LxMZXPdIskGV49wbWA264+0YKfCrEe5Qz
	 JxeleOK2e3jreGC+mHWZliMF/BBw7Bzw7Pmm41d4MVsyw409vlGmMMbje+8Xf+3x/
	 loqIqJqvRwW8ukmHIRaKRaTEFw16oLdmQxIkaT8xdtF2OSwZsUzzJmy7zHv69LLy9
	 BhoybL0EhzrE/gff9OeIXa9Yazu+vRGW9CW7hw80Kj5lJgWUGf1j3ETAuQUA/x/gC
	 0dJW1zTsm7DsMLS5MG+TRzH0M56M9GSDL4oJ8Idxps+PNmVngskvDNMkDM/xQJghG
	 Jm9WuYxdndA1Y61Ggw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MxDkm-1vLgeH0JIm-017CNL; Thu, 26
 Mar 2026 19:11:53 +0100
Date: Thu, 26 Mar 2026 19:11:12 +0100
From: Felix Busch <felix.busch1@gmx.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
	phil@philpotter.co.uk, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] CD-ROM: Additional LBA bound check
Message-ID: <acV2wMjupsEd25Ry@LaptopFB>
References: <20260325065335.7783-1-felix.busch1@gmx.net>
 <20260325074401.6530-1-felix.busch1@gmx.net>
 <f9cd34054a5fe11abb269ad708b4267d73ace99d.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <f9cd34054a5fe11abb269ad708b4267d73ace99d.camel@HansenPartnership.com>
X-Provags-ID: V03:K1:/C8lpV6uha0zb1lxSdglTmiYfXwbJzSYOsglJrL/wLI723WCmxW
 j9Yw1gfYddNAh9Xu0FXWL7CiDhKZF0h93TOQ34GpgG4J2I1I6wjV2BzXT5ABZ/kaLaI3ohJ
 D1p+cmd7qACfQIR2IPRbgVOeWYVAUNN6ZQkeL7FFyBjjFGlKoqvAaPffkm3x85Y9a3oEnTm
 YStt3A3Scdo5cVTVidntQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xu9fVHQ3fmQ=;JPu8Iw/saX/afVare4TYnw5VB+l
 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
 v7OmcatKGSeWevWO711kFqDyhKvPAYUQA==

On Wed, Mar 25, 2026 at 08:55:24AM -0400, James Bottomley wrote:
> On Wed, 2026-03-25 at 08:44 +0100, Felix Busch wrote:
> [...]
> > mmc_ioctl_cdrom_read_data(struct cdrom_device_info *cdi,
> > =A0	if (copy_from_user(&msf, (struct cdrom_msf __user *)arg,
> > sizeof(msf)))
> > =A0		return -EFAULT;
> > =A0	lba =3D msf_to_lba(msf.cdmsf_min0, msf.cdmsf_sec0,
> > msf.cdmsf_frame0);
> > -	/* FIXME: we need upper bound checking, too!! */
> > -	if (lba < 0)
> > +	nr_blocks =3D cdo->get_capacity(cdi);
>=20
> Since you only give sr.c a get_capacity method, doesn't this crash for
> every other CD backend?
>=20
> [...]
>=20
> > @@ -782,7 +792,7 @@ static int get_sectorsize(struct scsi_cd *cd)
> > =A0			sector_size =3D 2048;
> > =A0			fallthrough;
> > =A0		case 2048:
> > -			cd->capacity *=3D 4;
> > +			//cd->capacity *=3D 4;
> > =A0			fallthrough;
>=20
> You mentioned this in the cover letter.  It's because of the
> 		set_capacity(cd->disk, cd->capacity); below.  The block layer always s=
peaks512bytesectorsforcapacities.Sothiswillbeabreakingchangeforlargesector=
devicesbecausethey'llappearfourtimessmallertotheblocklayer.
>=20
> I suppose I'm also a bit hazy about the actual justification.  Today if
> you send an over capacity request via the ioctl, you'll get an error
> from the device.  If we apply the patch you'll get a -EINVAL instead.=20
> So you get an error in both cases (i.e. the macro behaviour doesn't
> change, so it's hard to justify why we need the patch) but a different
> one, which might confuse some tools ... have you checked?
>=20
> The cover letter says "improve execution performance" but I can't see
> how introducing an indirect call into the read path can do that.  I
> can't actually see why you need an indirect call since the capacity
> doesn't change except if the device is writeable and rewritten.
>=20
> Regards,
>=20
> James
>=20
>=20
My intension was to fail as early as possible instead of relying on
the device to reject. However, as you pointed out, this does not really
change the overall macro behaviour. Given that, the benefit appears
limited, but it results in an additional error handling. The execution
performance argument relates to the fact that when it's possible to
return, due to wrong input, there's no reason to continue processing
and waiting for the device to reject. Maybe it's fine to leave it was it
is, unless someone as another idea about this.

Regards

