From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: Help - how to identify the callers in a SCSI lower-leveldriver
Date: Wed, 7 Apr 2004 22:57:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040407205701.GA27311@devserv.devel.redhat.com>
References: <519672568F040C41B6FAC21ADF51B18FEFA0@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49307 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264159AbUDGU5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2004 16:57:33 -0400
Content-Disposition: inline
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FEFA0@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@crossroads.com>
Cc: linux-scsi@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 07, 2004 at 03:42:45PM -0500, Lee Xing wrote:
> Thanks for the response.
> 
> The shim (a pseudo SCSI lower-level driver) we are working on sits in
> between Linux SCSI mid-level driver and our existing kernel driver which
> interfaces with a FC driver which interacts with the FC HBA.

wow that sounds like a great way to kill performance, that many extra layers

> 
> To track SCSI initiators' tasks, it would be great if our existing kernel
> driver knows which application makes the (SCSI passthrough ioctl) call to
> /dev/sda.

well... it's a fundamentally hard problem. For example the application that
submitted the IO may no longer exist on disk by the time you get to see the
IO, or the process may already have exited. It sounds like a fundamentally
fragile/broken concept to use this information for *anything*, it's still
not clear to me what you'd use it for (other than doing a gross hack by
faking IO priorities based on application name but that's sooo not the right
solution to that problem)

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAdGsdxULwo51rQBIRAomKAJ43M9poIrKSRnlDGNBfXZDwZMIiAgCeL7MJ
gZIef0STmcy80SB9bNonuA4=
=02SM
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
