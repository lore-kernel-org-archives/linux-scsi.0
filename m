From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] training mpath to discern between SCSI errors
Date: Mon, 30 Aug 2010 13:38:54 +0200
Message-ID: <4C7B984E.4070802@suse.de>
References: <20100825155918.GB8509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100825155918.GB8509@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Tejun Heo <tj@kernel.org>, michaelc@cs.wisc.edu, James.Bottomley@suse.de, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Mike Snitzer wrote:
> On Wed, Aug 25 2010 at  4:00am -0400,
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>=20
>>> I'm not sure how to proceed here.  How much work would
>>> discerning between transport and IO errors take?  If it can't be do=
ne
>>> quickly enough the retry logic can be kept around to keep the old
>>> behavior but that already was a broken behavior, so...  :-(
>> I'm not sure how long will it take.
>=20
> We first need to understand what direction we want to go with this.  =
We
> currently have 2 options.  But any other ideas are obviously welcome.
>=20
> 1)
> Mike Christie has a patchset that introduce more specific
> target/transport/host error codes.  Mike shared these pointers but he=
'd
> have to put the work in to refresh them:
> http://marc.info/?l=3Dlinux-scsi&m=3D112487427230642&w=3D2
> http://marc.info/?l=3Dlinux-scsi&m=3D112487427306501&w=3D2
> http://marc.info/?l=3Dlinux-scsi&m=3D112487431524436&w=3D2
> http://marc.info/?l=3Dlinux-scsi&m=3D112487431524350&w=3D2
>=20
> errno.h new EXYZ
> http://marc.info/?l=3Dlinux-kernel&m=3D107715299008231&w=3D2
>=20
> add block layer blkdev.h error values
> http://marc.info/?l=3Dlinux-kernel&m=3D107961883915068&w=3D2
>=20
> add block layer blkdev.h error values (v2 convert more drivers)
> http://marc.info/?l=3Dlinux-scsi&m=3D112487427230642&w=3D2
>=20
> I think that patchset's appoach is fairly disruptive just to be able =
to
> train upper layers to differentiate (e.g. mpath).  But in the end may=
be
> that change takes the code in a more desirable direction?
>=20
> 2)
> Another option is Hannes' approach of having DM consume req->errors a=
nd
> SCSI sense more directly.
>=20

Actually, I think we have two separate issues here:
1) The need of having more detailed I/O errors even in the fs layer. Th=
is
   we've already discussed at the LSF, consensus here is to allow other
   errors than just 'EIO'.
   Instead of Mike's approach I would rather use existing error codes h=
ere;
   this will make the transition somewhat easier.
   Initially I would propose to return 'ENOLINK' for a transport failur=
e,
   'EIO' for a non-retryable failure on the target, and 'ENODEV' for a
   retryable failure on the target.

2) The need to differentiate the various error conditions on the multip=
ath
   layer. Multipath needs to distinguish the three error types as speci=
fied
   in 1)

Mike has been trying to solve 1) and 2) by introducing separate/new err=
or
codes, and I have been trying to use 2) by parsing the sense codes dire=
ctly
from multipathing.

Given that the fs people have expressed their desire to know about thes=
e
error classes, too, it makes sense to have them exposed to the fs layer=
=2E

I see if I can come up with a patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
