From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [RESEND PATCH 3/3] dm mpath: add ability to disable
 partition creation
Date: Wed, 25 Jul 2012 14:02:15 +0200
Message-ID: <500FE047.8060009@suse.de>
References: <1340735525-21083-1-git-send-email-snitzer@redhat.com> <1340735525-21083-4-git-send-email-snitzer@redhat.com> <20120711151839.GC2095@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab2GYMCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jul 2012 08:02:17 -0400
In-Reply-To: <20120711151839.GC2095@agk-dp.fab.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Peter Rajnoha <prajnoha@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>

On 07/11/2012 05:18 PM, Alasdair G Kergon wrote:
> On Tue, Jun 26, 2012 at 02:32:05PM -0400, Mike Snitzer wrote:
>> The new 'no_partitions' feature serves as a notifier to kpartx to _n=
ot_
>> create partitions on these multipath devices.
> =20
> This isn't really multipath-specific so doesn't belong in the target.
> It could go into dm core, but we already have flags attached to
> udev cookies that can turn udev rules on and off and thereby could
> allow userspace multipath to control whether or not kpartx creates
> partitions on any particular device.
>=20
> But first I'd like us to explore creating a config file for kpartx an=
d
> controlling the behaviour from there.  Activation could then be
> triggered by target type, device name, scsi WWID, dm UUID etc. accord=
ing
> to rules in that file.
>=20
But that would mean one would have to maintain _two_ configuration
files, one for multipath and one for kpartx.

Also kpartx initially doesn't have any clue about device names, SCSI
WWIDs etc. It just takes a device-mapper device and acts upon it.
The only information it's got is the device-mapper name (which could
be anything) and the device-mapper UUID if present.

Same goes for udev rules; one would have to traverse the device
stack backwards to retrieve any information about the hardware.

So when moving the configuration into kpartx we would lose quite
some flexibility. And reliability, methinks.

=46lexilibity is a valid goal, but not when it can achieved only by
adding complexity to other pieces.

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
