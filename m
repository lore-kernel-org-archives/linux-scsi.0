From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd name space exhaustion causes system hang
Date: Tue, 21 Sep 2010 17:08:36 +0200
Message-ID: <4C98CA74.7060500@suse.de>
References: <4C9789C6.7080601@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab0IUPIh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2010 11:08:37 -0400
In-Reply-To: <4C9789C6.7080601@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>, Tony Ernst <tee@sgi.com>

Michael Reed wrote:
> Following a site power outage which re-enabled all the ports on my FC
> switches, my system subsequently booted with far too many luns!  I ha=
d
> let it run hoping it would make multi-user.  It didn't.  :(  It hung =
solid
> after exhausting the last sd device, sdzzz, and attempting to create =
sdaaaa
> and beyond.  I was unable to get a dump.
>=20
> Discovered using a 2.6.32.13 based system.
>=20
> Patch at the bottom corrects this by detecting when the last index is
> utilized and failing the sd probe of the device.  Patch applies to
> scsi-misc-2.6.
>=20
Hmm. Shouldn't we rather use dynamic majors once we're over
SD_MAJORS? We do have enough space in the 'index' field and the name
is generated dynamically anyway ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
