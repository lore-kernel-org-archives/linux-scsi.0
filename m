From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RESEND PATCH 3/3] dm mpath: add ability to
	disable	partition creation
Date: Thu, 26 Jul 2012 12:03:28 -0500
Message-ID: <20120726170328.GD5299@ether.msp.redhat.com>
References: <1340735525-21083-1-git-send-email-snitzer@redhat.com>
	<1340735525-21083-4-git-send-email-snitzer@redhat.com>
	<20120711151839.GC2095@agk-dp.fab.redhat.com>
	<500FE047.8060009@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <500FE047.8060009@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 25, 2012 at 02:02:15PM +0200, Hannes Reinecke wrote:
> On 07/11/2012 05:18 PM, Alasdair G Kergon wrote:
> > On Tue, Jun 26, 2012 at 02:32:05PM -0400, Mike Snitzer wrote:
> >> The new 'no_partitions' feature serves as a notifier to kpartx to _not_
> >> create partitions on these multipath devices.
> >  =

> > This isn't really multipath-specific so doesn't belong in the target.
> > It could go into dm core, but we already have flags attached to
> > udev cookies that can turn udev rules on and off and thereby could
> > allow userspace multipath to control whether or not kpartx creates
> > partitions on any particular device.
> > =

> > But first I'd like us to explore creating a config file for kpartx and
> > controlling the behaviour from there.  Activation could then be
> > triggered by target type, device name, scsi WWID, dm UUID etc. according
> > to rules in that file.
> > =

> But that would mean one would have to maintain _two_ configuration
> files, one for multipath and one for kpartx.
> =

> Also kpartx initially doesn't have any clue about device names, SCSI
> WWIDs etc. It just takes a device-mapper device and acts upon it.
> The only information it's got is the device-mapper name (which could
> be anything) and the device-mapper UUID if present.
> =

> Same goes for udev rules; one would have to traverse the device
> stack backwards to retrieve any information about the hardware.
> =

> So when moving the configuration into kpartx we would lose quite
> some flexibility. And reliability, methinks.
> =

> Flexilibity is a valid goal, but not when it can achieved only by
> adding complexity to other pieces.

Kpartx does already grab the dm device name, uuid and target type
(although it doesn't currently use the target type for anything). So,
aside from adding code to read a config file, we don't really have to
add any complexity to be able to have kpartx configure a device based on
dm name (which admittedly probably isn't that useful), dm UUID, or
target type.  We could also have it configure based on the blkid
results, which should be present when it's called by udev. When
called manually, kpartx could use libblkid.

We do lose the ability to have kpartx easily configure a device based on
hardware type.  However, that's not really essential.  Multipath needs
it because it can't even finish setting up a device until it knows the
hardware type.  For kpartx, it could make configuration simpler in cases
where all of the LUNs from a particular hardware type needed to be
configured the same way.  This may be handy, but its not necessary, and
you could achieve the same results using UUIDs. What we gain is the
ability to set this property for non-multipath devices, which currently
isn't possible.  Also, blkid based (fs type, fs uuid, and fs label)
configuration seems to me like it would be the most useful. =


Now I'm not arguing that adding configuration file handling isn't adding
complexity, and adding libblkid calls would add more. But since
multipath always sets the UUID, I don't see this losing any reliability,
and I does gain the fexibility to work with any dm target type. I
don't feel strongly about this one way or the other, but do see the
benefits of having kpartx own this configuration setting.

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
> =
