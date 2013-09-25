From: Hannes Reinecke <hare@suse.de>
Subject: Re: notify userspace of offline -> running transitions
Date: Wed, 25 Sep 2013 10:54:21 +0200
Message-ID: <5242A4BD.10107@suse.de>
References: <1380050595.4010.121.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab3IYIyX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Sep 2013 04:54:23 -0400
In-Reply-To: <1380050595.4010.121.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: linux-scsi@vger.kernel.org

On 09/24/2013 09:23 PM, Ewan Milne wrote:
> http://marc.info/?l=3Dlinux-scsi&m=3D133901769900806&w=3D2
>=20
> Can we reconsider applying patch 4 in Mike's set?
> The problem still exists, and there was never another
> solution proposed as far as I can see.  (I posted a
> question about this a while back...)
>=20
> It is a big issue for people who happen to get a
> KOBJ_CHANGE uevent while their iSCSI session happens
> to be disconnected for some reason, because udev
> will end up removing the /dev/by-xxx links when it
> can't access the device.  If there is no subsequent
> uevent when the device is available again, the links
> are never recreated.
>=20
Right. The original issue here is that we'll be getting a 'CHANGE'
uevent for _EVERY_ device connected to that port / iscsi session.

This has two potential issues:
1) We'll be pushing quite some events through udev, increasing the
load at times when already is quite some I/O going on.
2) Currently SCSI devices only had to react to 'add' events for
generating udev links, with 'change' events virtually non-existing.
When we're not generating 'change' events for SCSI devices we
absolutely have to audit / test the udev rules as they need to
re-create _all_ device links etc on 'change', too.
Otherwise we'll end up with the situation you've just described.

Hence my original comment to send 'change' events for the session or
rport, as this would result in only _one_ event thereby eliminating
the event multiplication.
It has the drawback that we won't get the automatic udev database
update like we would be getting with the patch.

But then we could easily achieve that by auditing the udev rules to
fetch the required information off the udev database in case the
device is not accessible.
And as we have to audit the udev rules _anyway_ it feels like a
better solution to me.
(It certainly is for me, as I've already done this on the SUSE side;
we've had a similar issue already :-)
But if others feel strongly about this patch I won't object to it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
