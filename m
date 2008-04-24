From: Hannes Reinecke <hare@suse.de>
Subject: Re: does sym53c8xx_2 hardware support hotplug
Date: Thu, 24 Apr 2008 11:25:41 +0200
Message-ID: <48105215.8040109@suse.de>
References: <480F979E.5060302@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYDXJZn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2008 05:25:43 -0400
In-Reply-To: <480F979E.5060302@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, matthew@wil.cx

Hi Mike,

Mike Christie wrote:
> Hi,
>=20
> Does the hardware sym53c8xx_2 works with support removing and adding=20
> devices?
>=20
Oh. Hmm. That is tricky and complicated.

> When using sym53c8xx_2 if we find storage, remove the device using th=
e=20
> sysfs/proc interface, then physically remove the device, everything g=
oes=20
> well. However, if we physically plug the disk back in and try to read=
d=20
> it through the sysfs/proc scanning interfaces, it looks like=20
> scsi_scan.c's inquiry will time out. This causes the sym error handle=
r=20
> to run, which works great and we end up doing a BUS RESET (BDR failed=
 so=20
> we got escalated), and after that the inqiury is retried and we find =
the=20
> device and it works fine.
>=20
Yes.

> Is the inquiry timing out expected? Does the hardware even support=20
> hotplug? Or does it support it partially support it (support it with=20
> some help), and we are we supposed to be manually resetting the bus,=20
> with something like a sg_reset, after we have physically plug the dis=
k=20
> back in?
>=20
Hi, join the club.

As the saying goes: Radio Yerewan answers: in principle, yes.

The whole matter of SCSI parallel hotplugging depends strongly on
the backplane. For fun reading have a look at=20

SPI-3 Annex D: Removal and insertion of SCSI devices.

It basically leaves it open to the vendor of the backplane how
much intelligence he wants to put in there.
But yes, sending a SCSI reset is listed there. It actually states
that the RST line should be asserted continuously by the initiator
during the hotplugging process.

HTH.

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
