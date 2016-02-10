From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC PATCH v2] blk-mq: Introduce per sw queue time-slice
Date: Wed, 10 Feb 2016 20:47:15 +0100
Message-ID: <20160210194715.GA324@x4>
References: <20151119120235.GA7966@suselix.suse.de>
 <20160201224340.GA16639@suselix.suse.de>
 <20160209171239.GE12437@suselix.suse.de>
 <20160209174156.GA323@x4>
 <20160210193414.GC14676@suselix.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160210193414.GC14676@suselix.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Herrmann <aherrmann@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 2016.02.10 at 20:34 +0100, Andreas Herrmann wrote:
> On Tue, Feb 09, 2016 at 06:41:56PM +0100, Markus Trippelsdorf wrote:
> > > Recently Johannes sent a patch to enable scsi-mq per driver, see
> > > http://marc.info/?l=3Dlinux-scsi&m=3D145347009631192&w=3D2
> > >=20
> > > Probably that is a good solution (at least in the short term) to =
allow
> > > users to switch to blk-mq for some host adapters (with fast stora=
ge
> > > attached) but to stick to legacy stuff on other host adapters wit=
h
> > > rotary devices.
> >=20
> > I don't think that Johannes' patch is a good solution.
>=20
> Why? Because it's not per device?

Yes. Like Christoph said in his reply to the patch: =BBThe host is simp=
ly
the wrong place to decide these things.=AB

> > The best solution for the user would be if blk-mq could be toggled
> > per drive (or even automatically enabled if queue/rotational =3D=3D=
 0).
>=20
> Yes, I aggree, but ...
>=20
> > Is there a fundamental reason why this is not feasible?
>=20
> ... it's not possible (*) with the current implementation.
>=20
> Tag handling/command allocation differs. Respective functions are set
> per host.
>=20
> (*) Or maybe it's possible but just hard to achieve and I didn't look
> long enough into relevant code to get an idea how to do it.
>=20
> > Your solution is better than nothing, but it requires that the user
> > finds out the drive <=3D> host mapping by hand and then runs someth=
ing
> > like:=20
> > echo "250" > /sys/devices/pci0000:00/0000:00:11.0/ata2/host1/target=
1:0:0/1:0:0:0/block/sdb/mq/0/time_slice_us
> > during boot for spinning rust drives...
>=20
> Or it could automatically be set in case of rotational device.
> (Once we know for sure that it doesn't cause performance degradation.=
)

Yes, this sound like a good idea.

But, if I understand things correctly, your patch is only an interim
solution until proper I/O scheduler support gets implemented for blk-mq=
, no?

--=20
Markus
