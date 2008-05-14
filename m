From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi : set target can_queue from devinfo flags
Date: Wed, 14 May 2008 08:34:23 +0200
Message-ID: <482A87EF.4010002@suse.de>
References: <1210700704.16304.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:35428 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYENGeY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 02:34:24 -0400
In-Reply-To: <1210700704.16304.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

Hi James,

James Smart wrote:
> This patch, discussed in the initial thread on target can_queue limit=
s
> (see  http://marc.info/?l=3Dlinux-scsi&m=3D120944296225094&w=3D2 )
> allows the target can_queue limit to be obtained from the device list=
 based on
> Inquiry data obtained during scan.
>=20
> I have pinged several of the array vendors to supply target-port leve=
l values
> for their arrays. Hopefully, we will see them populate the device lis=
t with some
> real values shortly.
>=20
I know :-)

> This patch was cut against scsi-misc-2.6, and depends on Mike Christi=
es patches
> contained in the original thread.
>=20
Hmph.

I don't quite agree with this one.
=46or once, /proc/scsi/scsi has been marked as 'obsolete' for quite som=
e time now,
so adding other usages to this is of questionable value.

And we've actually have a similar issue when developing the SCSI device=
_handler
stuff where we also have a device list to maintain.

Seeing there is quite some overlap between those two cases I think we s=
hould
come up with a way of handling these things properly, ie tied into sysf=
s.

So, what we should do here is
a) add a 'can_queue' sysfs attribute to the starget (which we can nowad=
ays, as
   the starget is a proper sysfs object)
b) define a 'modalias' style definition for matching SCSI vendor/model/=
rev
   and create a scsi_devinfo module from which all these special cases
   can be invoked from.

That would also allow us to get rid of the device tables in the device_=
handler
modules which I never really liked.

What do you think?

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
