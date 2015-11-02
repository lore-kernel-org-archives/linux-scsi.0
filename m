From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 2 Nov 2015 10:14:46 -0500
Message-ID: <20151102151446.GB23665@redhat.com>
References: <20151029131810.GA26841@redhat.com>
 <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com>
 <5635115B.7080805@redhat.com>
 <20151031224707.GA12805@redhat.com>
 <56371095.6020400@suse.de>
 <20151102133119.GA23234@redhat.com>
 <56376B8C.5010001@suse.de>
 <20151102141243.GB23234@redhat.com>
 <563774F1.7090806@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbbKBPOs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 10:14:48 -0500
Content-Disposition: inline
In-Reply-To: <563774F1.7090806@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Mon, Nov 02 2015 at  9:36am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 11/02/2015 03:12 PM, Mike Snitzer wrote:
> > On Mon, Nov 02 2015 at  8:56am -0500,
> > Hannes Reinecke <hare@suse.de> wrote:
> >=20
> >> On 11/02/2015 02:31 PM, Mike Snitzer wrote:
> >>> On Mon, Nov 02 2015 at  2:28am -0500,
> >>> Hannes Reinecke <hare@suse.de> wrote:
> >>>
> >>>> On 10/31/2015 11:47 PM, Mike Snitzer wrote:
> >>>>>
> >>>>> For Hannes, and in my head, it didn't matter if a future bdev s=
atisfies
> >>>>> the length condition.  I don't think Hannes was trying to guard=
 against
> >>>>> dangerous partition ioctls being issued by udev... but now I _d=
o_
> >>>>> question what exactly _is_ the point of his commit 21a2807bc3f.=
  Which
> >>>>> invalid ioctls, from udev, did Hannes' change actually disallow=
?
> >>>>>
> >>>
> >>> FYI, I meant s/21a2807bc3f/a1989b33/
> >>>
> >>>> The reasoning is thus:
> >>>>
> >>>> With the original code we would need to wait for path activation
> >>>> before we would be able to figure out if the ioctl is valid.
> >>>> However, the callback to verify the ioctl is sd_ioctl(), which a=
s
> >>>> a first step calls scsi_verify_ioctl().
> >>>> So my reasoning was that we can as well call scsi_verify_ioctl()
> >>>> early, and allow it to filter out known invalid ioctls.
> >>>> Then we wouldn't need to wait for path activation and return
> >>>> immediately.
> >>>
> >>> Right, I understood that to be your intent.  And it seemed reason=
ible.
> >>> Unfortuntely, as we now know, scsi_verify_blk_ioctl() only really=
 cares
> >>> to filter out ioctls that are invalid for partitions.
> >>>
> >>> I'm still curious: which ioctls were being issued by udev that yo=
ur
> >>> commit a1989b33 "fixed" (so udev workers didn't hang)?  Is the ri=
ght fix
> >>> to modify udev to not issue such ioctls?  What was invalid about =
the
> >>> udev issued ioctls?
> >>>
> >> Thing is, it's not udev itself which issues ioctl. It's the progra=
ms
> >> started by udev via the various rules (PROGRAM or IMPORT keywords)=
=2E
> >> They might (and occasionally, will) issue ioctls, and we have no
> >> means of controlling them.
> >>
> >>>> Incidentally, in the 'r =3D=3D -ENOTCONN' case, we're waiting
> >>>> for path activation, but then just bail out with -ENOTCONN.
> >>>> As we're not resetting -ENOTCONN, where's the point in activate =
the
> >>>> paths here?
> >>>> Shouldn't we retry to figure out if -ENOTCONN is still true?
> >>>
> >>> We do, in DM core, see _your_ commit that added this ;)
> >>> 6c182cd88d ("dm mpath: fix ioctl deadlock when no paths")
> >>>
> >> Indeed.
> >>
> >> But then the real question remains:
> >>
> >> What is the 'correct' behaviour for ioctls when no path retry
> >> is active (or when no paths are present)?
> >>
> >> Should we start path activation?
> >> If so, should we wait for path activation to finish, risking udev
> >> killing the worker for that event (udev has a built-in timeout of
> >> 120 seconds, which we might easily exceed when we need to activate
> >> paths for large installations or slow path activation ... just
> >> thinking of NetApp takeover/giveback cycle)?
> >> If we're not waiting for path activation, where would be the point
> >> in starting it, seeing that we're not actually interested in the r=
esult?
> >=20
> > We only start it: if (r =3D=3D -ENOTCONN && !fatal_signal_pending(c=
urrent))
> >=20
> > -ENOTCONN is set with:
> > if ((pgpath && m->queue_io) || (!pgpath && m->queue_if_no_path))
> >=20
> I know.
>=20
> >> And if we shouldn't start a path activation, what is the point of
> >> having code for it in the first place?
> >=20
> > The point is we have reason to believe paths will be coming back or=
 that
> > the user wants to queue_if_no_path.
> >=20
> Yes. But taken at face value, it means that any I/O will be stuck in
> the queue for an indefinite amount of time.
> Which doesn't work for things like udev, which _requires_ an answer
> after a certain time.
> And if that answer isn't forthcoming, the entire udev worker is
> killed, rendering the device useless as the event is never delivered.
>=20
> So if the user has set queue_if_no_path, we might never get a path
> down event delivered as udev is stuck.
>=20
> What do we do then?
> Tell the customer "Hey, you screwed up" is possibly not the best of
> ideas, especially not as multipath sets an unconditional
> queue_if_no_path per default for quite some arrays.
>=20
> I can see a point for waiting the path initialisation to complete
> (ie if queue_io is active). But for queue_if_no_path I'd rather
> return an error directly (like -EAGAIN).
>=20
> With that change we could retry path selection until queue_io is
> done, and would be able to retrieve a valid status (as we'd always
> have a bdev).
>=20
> See the attached patch for a detailed explanation.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)

> From b0d5848e91cfc3b97adb49121085c994b707eac3 Mon Sep 17 00:00:00 200=
1
> From: Hannes Reinecke <hare@suse.de>
> Date: Mon, 2 Nov 2015 15:33:58 +0100
> Subject: [PATCH] dm-mpath: Retry ioctl if paths need to be initialize=
d
>=20
> If paths need to be initialized (m->queue_io is set) we should
> be starting the initialization and retry the ioctl to retrieve
> the final status.
> At the same time, we should _not_ wait for queue_if_no_path
> to go away as this might take forever, resulting in the
> ioctl to be stuck.

I understand your goal.. but the patch is a bit incomplete.

In your patch the activation is still in progress; so there is no
bdev.. so it'll yield false positives still.

And DM core has retry via -ENOTCONN.. yet you're adding it to
multipath_ioctl (meaning nothing will use DM core's retry logic now).

Also, you still haven't established what it is about
scsi_verify_blk_ioctl() that you see as beneficial.  If we return EAGAI=
N
to userspace that should "fix" the udev worker issue (so no need for
extra ioctl verification.. which you're clearly still implicitly
overloading with the hopes that it is more generally applicable than
just being concerned about whether an ioctl is valid against a
partition).


> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 5a67671..7352397 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1543,6 +1543,7 @@ static int multipath_ioctl(struct dm_target *ti=
, unsigned int cmd,
>  	unsigned long flags;
>  	int r;
> =20
> +again:
>  	bdev =3D NULL;
>  	mode =3D 0;
>  	r =3D 0;
> @@ -1559,8 +1560,10 @@ static int multipath_ioctl(struct dm_target *t=
i, unsigned int cmd,
>  		mode =3D pgpath->path.dev->mode;
>  	}
> =20
> -	if ((pgpath && m->queue_io) || (!pgpath && m->queue_if_no_path))
> +	if (pgpath && m->queue_io)
>  		r =3D -ENOTCONN;
> +	else if (!pgpath && m->queue_if_no_path)
> +		r =3D -EAGAIN;
>  	else if (!bdev)
>  		r =3D -EIO;
> =20
> @@ -1569,7 +1572,7 @@ static int multipath_ioctl(struct dm_target *ti=
, unsigned int cmd,
>  	/*
>  	 * Only pass ioctls through if the device sizes match exactly.
>  	 */
> -	if (!bdev || ti->len !=3D i_size_read(bdev->bd_inode) >> SECTOR_SHI=
=46T) {
> +	if (r =3D=3D -ENOTCONN && ti->len !=3D i_size_read(bdev->bd_inode) =
>> SECTOR_SHIFT) {
>  		int err =3D scsi_verify_blk_ioctl(NULL, cmd);
>  		if (err)
>  			r =3D err;
> @@ -1585,6 +1588,8 @@ static int multipath_ioctl(struct dm_target *ti=
, unsigned int cmd,
>  			__pg_init_all_paths(m);
>  		spin_unlock_irqrestore(&m->lock, flags);
>  		dm_table_run_md_queue_async(m->ti->table);
> +		msleep(10);
> +		goto again;
>  	}
> =20
>  	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
> --=20
> 1.8.5.6
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
