From: Andreas Herrmann <aherrmann@suse.com>
Subject: Re: [RFC PATCH v2] blk-mq: Introduce per sw queue time-slice
Date: Wed, 10 Feb 2016 23:09:19 +0100
Message-ID: <20160210220919.GA16029@suselix.suse.de>
References: <20151119120235.GA7966@suselix.suse.de>
 <20160201224340.GA16639@suselix.suse.de>
 <20160209171239.GE12437@suselix.suse.de>
 <20160209174156.GA323@x4>
 <20160210193414.GC14676@suselix.suse.de>
 <20160210194715.GA324@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160210194715.GA324@x4>
Sender: linux-kernel-owner@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 10, 2016 at 08:47:15PM +0100, Markus Trippelsdorf wrote:
> On 2016.02.10 at 20:34 +0100, Andreas Herrmann wrote:
> > On Tue, Feb 09, 2016 at 06:41:56PM +0100, Markus Trippelsdorf wrote=
:
> > > > Recently Johannes sent a patch to enable scsi-mq per driver, se=
e
> > > > http://marc.info/?l=3Dlinux-scsi&m=3D145347009631192&w=3D2
> > > >=20
> > > > Probably that is a good solution (at least in the short term) t=
o allow
> > > > users to switch to blk-mq for some host adapters (with fast sto=
rage
> > > > attached) but to stick to legacy stuff on other host adapters w=
ith
> > > > rotary devices.
> > >=20
> > > I don't think that Johannes' patch is a good solution.
> >=20
> > Why? Because it's not per device?
>=20
> Yes. Like Christoph said in his reply to the patch: =C2=BBThe host is=
 simply
> the wrong place to decide these things.=C2=AB
>=20
> > > The best solution for the user would be if blk-mq could be toggle=
d
> > > per drive (or even automatically enabled if queue/rotational =3D=3D=
 0).
> >=20
> > Yes, I aggree, but ...
> >=20
> > > Is there a fundamental reason why this is not feasible?
> >=20
> > ... it's not possible (*) with the current implementation.
> >=20
> > Tag handling/command allocation differs. Respective functions are s=
et
> > per host.
> >=20
> > (*) Or maybe it's possible but just hard to achieve and I didn't lo=
ok
> > long enough into relevant code to get an idea how to do it.
> >=20
> > > Your solution is better than nothing, but it requires that the us=
er
> > > finds out the drive <=3D> host mapping by hand and then runs some=
thing
> > > like:=20
> > > echo "250" > /sys/devices/pci0000:00/0000:00:11.0/ata2/host1/targ=
et1:0:0/1:0:0:0/block/sdb/mq/0/time_slice_us
> > > during boot for spinning rust drives...
> >=20
> > Or it could automatically be set in case of rotational device.
> > (Once we know for sure that it doesn't cause performance degradatio=
n.)
>=20
> Yes, this sound like a good idea.
>=20
> But, if I understand things correctly, your patch is only an interim
> solution until proper I/O scheduler support gets implemented for blk-=
mq, no?

That's to be discussed. (Hence the RFC)

My (potentially wrong) claims are

- I don't think that fast storage (e.g. SSDs) requires I/O scheduler
  support with blk-mq. blk-mq is very good at pushing a large number
  of requests from per CPU sw queues to hw queue(s). Why then
  introduce any overhead for I/O scheduler support?

- Slow storage (e.g. spinning drives) is fine with the old code which
  provides scheduler support and I doubt that there is any benefit for
  those devices when switching to blk-mq.

- The big hammer (scsi_mod.use_blk_mq) for the entire scsi stack to
  decide what to use is suboptimal. You can't have optimal performance
  when you have both slow and fast storage devices in your system.

I doubt that it is possible to add I/O scheduling support to blk-mq
which can be on par with what CFQ is able to achieve for slow devices
at the moment.

Requests are scattered among per-CPU software queues (and almost
instantly passed to hardware queue(s)). Due to CPU scheduling,
requests initiated from one process might come down via different
software queues. What is an efficient way to sort/merge requests from
all the software queues in such a way that the result is comparable to
what CFQ does (assuming that CFQ provides optimal performance)? So far
I didn't find a solution to this problem. (I just have this patch
which adds not too much overhead and improves the situation a little
bit.)

Maybe the solution is to avoid per-CPU queues for slow storage and
fall back to a set of queues comparable to what CFQ uses.

One way to do this is by falling back to non-blk-mq code and direct
use of CFQ.

Code that allows to select blk-mq per host would help to some
extent. But when you have both device types connected to the same host
adapter it doesn't help either.


Andreas
