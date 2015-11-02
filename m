From: Hannes Reinecke <hare@suse.de>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 02 Nov 2015 14:56:28 +0100
Message-ID: <56376B8C.5010001@suse.de>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com> <20151029131810.GA26841@redhat.com> <5634DF67.7060302@redhat.com> <20151031181312.GA11587@redhat.com> <5635115B.7080805@redhat.com> <20151031224707.GA12805@redhat.com> <56371095.6020400@suse.de> <20151102133119.GA23234@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbbKBN4a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 08:56:30 -0500
In-Reply-To: <20151102133119.GA23234@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On 11/02/2015 02:31 PM, Mike Snitzer wrote:
> On Mon, Nov 02 2015 at  2:28am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
>=20
>> On 10/31/2015 11:47 PM, Mike Snitzer wrote:
>>>
>>> For Hannes, and in my head, it didn't matter if a future bdev satis=
fies
>>> the length condition.  I don't think Hannes was trying to guard aga=
inst
>>> dangerous partition ioctls being issued by udev... but now I _do_
>>> question what exactly _is_ the point of his commit 21a2807bc3f.  Wh=
ich
>>> invalid ioctls, from udev, did Hannes' change actually disallow?
>>>
>=20
> FYI, I meant s/21a2807bc3f/a1989b33/
>=20
>> The reasoning is thus:
>>
>> With the original code we would need to wait for path activation
>> before we would be able to figure out if the ioctl is valid.
>> However, the callback to verify the ioctl is sd_ioctl(), which as
>> a first step calls scsi_verify_ioctl().
>> So my reasoning was that we can as well call scsi_verify_ioctl()
>> early, and allow it to filter out known invalid ioctls.
>> Then we wouldn't need to wait for path activation and return
>> immediately.
>=20
> Right, I understood that to be your intent.  And it seemed reasonible=
=2E
> Unfortuntely, as we now know, scsi_verify_blk_ioctl() only really car=
es
> to filter out ioctls that are invalid for partitions.
>=20
> I'm still curious: which ioctls were being issued by udev that your
> commit a1989b33 "fixed" (so udev workers didn't hang)?  Is the right =
fix
> to modify udev to not issue such ioctls?  What was invalid about the
> udev issued ioctls?
>=20
Thing is, it's not udev itself which issues ioctl. It's the programs
started by udev via the various rules (PROGRAM or IMPORT keywords).
They might (and occasionally, will) issue ioctls, and we have no
means of controlling them.

>> Incidentally, in the 'r =3D=3D -ENOTCONN' case, we're waiting
>> for path activation, but then just bail out with -ENOTCONN.
>> As we're not resetting -ENOTCONN, where's the point in activate the
>> paths here?
>> Shouldn't we retry to figure out if -ENOTCONN is still true?
>=20
> We do, in DM core, see _your_ commit that added this ;)
> 6c182cd88d ("dm mpath: fix ioctl deadlock when no paths")
>=20
Indeed.

But then the real question remains:

What is the 'correct' behaviour for ioctls when no path retry
is active (or when no paths are present)?

Should we start path activation?
If so, should we wait for path activation to finish, risking udev
killing the worker for that event (udev has a built-in timeout of
120 seconds, which we might easily exceed when we need to activate
paths for large installations or slow path activation ... just
thinking of NetApp takeover/giveback cycle)?
If we're not waiting for path activation, where would be the point
in starting it, seeing that we're not actually interested in the result=
?
And if we shouldn't start a path activation, what is the point of
having code for it in the first place?
Couldn't we just rip it out altogether, and avoid much of the
current unpleasantness?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
