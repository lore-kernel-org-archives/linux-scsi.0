From: Hannes Reinecke <hare@suse.de>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 2 Nov 2015 08:28:21 +0100
Message-ID: <56371095.6020400@suse.de>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com> <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com> <5635115B.7080805@redhat.com>
 <20151031224707.GA12805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbbKBH2Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 02:28:24 -0500
In-Reply-To: <20151031224707.GA12805@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On 10/31/2015 11:47 PM, Mike Snitzer wrote:
> On Sat, Oct 31 2015 at  3:07pm -0400,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
>>
>>
>> On 31/10/2015 19:13, Mike Snitzer wrote:
>>>> But that's wrong, I think.  It's a false positive in
>>>> scsi_verify_blk_ioctl().
>>>>
>>>> If the ioctl is valid when bdev becomes non-NULL (and it will be i=
f
>>>> ti->len becomes equal to i_size_read(bdev->bd_inode) >> SECTOR_SHI=
=46T),
>>>> you should not return -ENOIOCTLCMD aka ENOTTY, because userspace d=
oesn't
>>>> think the ioctls can go away and come back.  So Hannes's patch bro=
ke the
>>>> userspace ABI. :(
>>>
>>> Huh?  All that Hannes' patch did was add early verification of the =
ioctl
>>> if there are no paths, since: there is no point queueing an ioctl t=
hat
>>> is invalid.
>>>
>>> [snip discussion of Christoph's patches]
>>>
>>> The point is scsi_verify_blk_ioctl() is saying the ioctl isn't vali=
d.
>>> It has nothing to do with the existance of a bdev or not; but every=
thing
>>> to do with the unprivledged user's request to issue an ioctl.
>>
>> ... but the call is skipped (and all ioctls are valid) if ti->len =3D=
=3D
>> i_size_read(bdev->bd_inode) >> SECTOR_SHIFT.  Therefore, until you h=
ave
>> the bdev you don't know which ioctls are valid, and you must assume =
all
>> of them are.  You can't do anything unsafe anyway until you have the
>> bdev.  This is the reasoning prior to Hannes's change.
>=20
> Yes, with your commit ec8013be ("dm: do not forward ioctls from logic=
al
> volumes to the underlying device") you added protections to disallow
> issuing ioctls to a partition that could impact the rest of the devic=
e.
>=20
> Given that I can see why you're seizing on the "ti->len !=3D
> i_size_read(bdev->bd_inode) >> SECTOR_SHIFT" negative checks that gat=
e
> the call to scsi_verify_blk_ioctl().
>=20
>> Afterwards, you end up calling scsi_verify_blk_ioctl() when bdev =3D=
=3D
>> NULL.  If the future bdev satisfies the above condition on ti->len, =
this
>> means that ioctl(SG_IO) switches from ENOTTY to available.  Userspac=
e is
>> clearly not expecting that.
>=20
> For Hannes, and in my head, it didn't matter if a future bdev satisfi=
es
> the length condition.  I don't think Hannes was trying to guard again=
st
> dangerous partition ioctls being issues by udev... but now I _do_
> question what exactly _is_ the point of his commit 21a2807bc3f.  Whic=
h
> invalid ioctls, from udev, did Hannes' change actually disallow?
>=20
The reasoning is thus:

With the original code we would need to wait for path activation
before we would be able to figure out if the ioctl is valid.
However, the callback to verify the ioctl is sd_ioctl(), which as
a first step calls scsi_verify_ioctl().
So my reasoning was that we can as well call scsi_verify_ioctl()
early, and allow it to filter out known invalid ioctls.
Then we wouldn't need to wait for path activation and return
immediately.

Incidentally, in the 'r =3D=3D -ENOTCONN' case, we're waiting
for path activation, but then just bail out with -ENOTCONN.
As we're not resetting -ENOTCONN, where's the point in activate the
paths here?
Shouldn't we retry to figure out if -ENOTCONN is still true?

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
