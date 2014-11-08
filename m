From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] st: call scsi_set_medium_removal directly
Date: Sat, 8 Nov 2014 14:26:23 +0100
Message-ID: <20141108132623.GA22610@lst.de>
References: <1414661229-15199-1-git-send-email-hch@lst.de> <1414661229-15199-5-git-send-email-hch@lst.de> <94D0CD8314A33A4D9D801C0FE68B402959378554@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32917 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbaKHN00 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Nov 2014 08:26:26 -0500
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402959378554@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>

On Thu, Nov 06, 2014 at 11:54:41PM +0000, Elliott, Robert (Server Stora=
ge) wrote:
> A few comments spawned by this (and patch 5/6):
>=20
> 1. Although PREVENT ALLOW MEDIUM REMOVAL was a generic
> command defined in SPC-2, In 2006 T10 proposal
> 06-248r1 changed it to be a command-set specific=20
> command for SPC-3.  MMC, SSC, SBC, and SMC had slight
> differences and the groups wouldn't agree on a converged
> definition.
>=20
> For example:
> * SSC and SBC only define two of the bit combinations=20
>   in byte 4 bits 1:0 - allowed and prevented
> * MMC defines all four combinations of byte 4 bits 1:0 -
>   unlocked, locked, persistent allow, and persistent prevent
> * SMC follows SSC/SBC but adds a PREEMPT bit in=20
>   byte 4 bit 7
>=20
> So, relying on one SCSI-wide scsi_set_medium_removal
> call could theoretically be a problem (though not yet,
> since none of those extra features are used).

The scsi_set_medium_removal is fairly trivial.  For the unlikely case
that we are going to make use of these additional features we'll
need to split it.

> 2. Reviewing the callers for scsi_set_medium_removal,
> I noticed sd.c sd_release ignores the return value=20
> from scsi_set_medium_removal (like many others).
>=20
> Its comment says:
> *      Returns 0.
> but it is a void function so doesn't really return anything:
> static void sd_release(struct gendisk *disk, fmode_t mode)

Right.  That's actually a fairly recent change from Al, before
that the ->release method for block devices had a return value,
which we then always i=C5=8Bnored higher up.

> 3. Reviewing the callers, st_release has an initialized
> result variable but does nothing else with it but return it:
> 	int result =3D 0;
> 	...
> 	return result;
>=20
> It ignores the do_door_lock -> scsi_set_medium_removal
> result (like many others).

The st driver defintively could use an audit for error code propagation=
=2E
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
