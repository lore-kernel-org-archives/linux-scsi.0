From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] SCSI: minor bug fixes and cleanups
Date: Wed, 11 Oct 2006 08:18:24 +0200
Message-ID: <200610110818.25158.eike-kernel@sf-tec.de>
References: <20061010232231.GA19015@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1271319.9g9qtjkpBh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:26020 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1030647AbWJKGRT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Oct 2006 02:17:19 -0400
In-Reply-To: <20061010232231.GA19015@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>

--nextPart1271319.9g9qtjkpBh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Jeff Garzik wrote:
> BusLogic: use kzalloc(), remove cast to/from void*
>
> aic7xxx_old: fix typo in cast
>
> NCR53c406a: ifdef out static built code
>
> fd_mcs: ifdef out static built code
>
> ncr53c8xx: ifdef out static built code
>
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
>
> ---
>
>  drivers/scsi/BusLogic.c       |   12 ++++++------
>  drivers/scsi/NCR53c406a.c     |    5 +++++
>  drivers/scsi/aic7xxx_old.c    |    2 +-
>  drivers/scsi/fd_mcs.c         |    2 ++
>  drivers/scsi/ncr53c8xx.c      |   19 +++++++++++--------
>
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 7c59bba..689dc4c 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2186,21 +2186,21 @@ #endif
>
>  	if (BusLogic_ProbeOptions.NoProbe)
>  		return -ENODEV;
> -	BusLogic_ProbeInfoList = (struct BusLogic_ProbeInfo *)
> -	    kmalloc(BusLogic_MaxHostAdapters * sizeof(struct BusLogic_ProbeInfo),
> GFP_ATOMIC); +	BusLogic_ProbeInfoList =
> +	    kzalloc(BusLogic_MaxHostAdapters * sizeof(struct BusLogic_ProbeInfo),
> GFP_KERNEL); if (BusLogic_ProbeInfoList == NULL) {
>  		BusLogic_Error("BusLogic: Unable to allocate Probe Info List\n", NULL);
>  		return -ENOMEM;
>  	}
> -	memset(BusLogic_ProbeInfoList, 0, BusLogic_MaxHostAdapters *
> sizeof(struct BusLogic_ProbeInfo));

kcalloc

Eike

--nextPart1271319.9g9qtjkpBh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBFLIyxXKSJPmm5/E4RAvFqAKCF16dI/+zlI19DfZWp2nknxQkXMwCcCdfa
4iXSvvijOc6R44XbwnZn/Ik=
=nA4y
-----END PGP SIGNATURE-----

--nextPart1271319.9g9qtjkpBh--
