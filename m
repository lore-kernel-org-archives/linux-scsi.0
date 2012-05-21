From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] notify userspace of offline->running transitions
 (v2)
Date: Mon, 21 May 2012 13:50:15 +0200
Message-ID: <4FBA2BF7.7070500@suse.de>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab2EULuQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2012 07:50:16 -0400
In-Reply-To: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

On 05/18/2012 06:56 AM, michaelc@cs.wisc.edu wrote:
> The following patches were made over the misc branch of the scsi tree=
=2E
>=20
> The patches fix a issue where if the device is offlined or IO is
> failed due to fast_io_fail (fc) /recovery_tmo (iscsi) then comes
> back, apps do not have a way a nice way to figure out the state
> has transitioned to running. Apps have to either poll the sysfs state
> file or send a SG IO to figure it out. With the patch apps can listen
> for the KOBJ CHANGE event like some of them (at least udev does) do
> already.
>=20
> v2:
> - Rebased to misc.
>=20
In principle, yes.

However, when doing this, we're now sending 'CHANGE' uevents from
SCSI devices. With the potential of putting _quite_ some strain on udev=
=2E
Kay explicitely debarred me from using uevents for my SCSI sense
code handling stuff, on the grounds that the SCSI subsystem might
flood the netlink socket and thereby starving udev from handling
really important messages.

(Keeping in mind that Kay doesn't believe in multipathing. But even
so, he has a point. Even more so with him being the udev maintainer :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
