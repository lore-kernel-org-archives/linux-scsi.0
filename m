From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Thu, 19 Jul 2007 10:57:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-584337861-1553872990-1184835473=:8661"
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <20070718163637.3f0e0164.akpm@linux-foundation.org>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1553872990-1184835473=:8661
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

	Hi Andrew,

On Wed, 18 Jul 2007, Andrew Morton wrote:
> On Mon, 16 Jul 2007 18:15:40 +0200
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
>=20
> > From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> >=20
> > Add a Disk Storage Driver for the PS3:
>=20
> Your patchset significantly hits powerpc, scsi and block.  So who gets =
to
> merge this?  Jens?  James?  Paul?
>=20
> Me, I guess ;)

As Paul is on holidays, please take it. The PS3 storage driver core suppo=
rt is
already in mainline, but the actual drivers aren't, as Paul was waiting f=
or
acks from the maintainers.

BTW, do you prefer incremental patches for the comments below, or an upda=
te of
the full patchset?

> > +#define KERNEL_SECTOR_SIZE	512
>=20
> Sigh.  We have at least ten separate definitions of SECTOR_SIZE< none o=
f
> them in the right place.  Cleanup opportunity for someone.

Will replace by 512 resp. >> 9, as per Jens' suggestion.

> > +struct ps3disk_private {
> > +	spinlock_t lock;		/* Request queue spinlock */
> > +	struct request_queue *queue;
> > +	struct gendisk *gendisk;
> > +	unsigned int blocking_factor;
> > +	struct request *req;
> > +	u64 raw_capacity;
> > +	unsigned char model[ATA_ID_PROD_LEN+1];
> > +};
> > +#define ps3disk_priv(dev)	((dev)->sbd.core.driver_data)
>=20
> hm, this code has "ata" all over it and actually uses a libata #define =
(at
> least) but there is no Kconfig dependency on ATA.  Fair enough, I guess=
,
> but a bit funny-looking.

I needed the definitions just for drive identification.

> > +static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
> > +				   struct request *req, int gather)
> > +{
> > +	unsigned int sectors =3D 0, offset =3D 0;

> Local variable `sectors' doesn't do anything.

Good catch!

> > +static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
> > +				     struct request *req)
> > +{
> > +	struct ps3disk_private *priv =3D ps3disk_priv(dev);
> > +	int write =3D rq_data_dir(req), res;
> > +	const char *op =3D write ? "write" : "read";
> > +	u64 start_sector, sectors;
> > +	unsigned int region_id =3D dev->regions[dev->region_idx].id;
>=20
> So we're ignoring the sector_t stuff.  I guess it's 64-bit only.  Still=
, it
> might be nice to use sector_t for consistency, readability and possible
> future 32-bitness?

I used u64 as they're directly passed to hypervisor calls and that's what=
 the
hypervisor calls take.

BTW, Cell will never support a 32-bit kernel, as lots of on-chip stuff li=
es
outside the 32-bit address space.

> > +#ifdef DEBUG
> > +	unsigned int n =3D 0;
> > +	struct bio *bio;
> > +	rq_for_each_bio(bio, req)
> > +		n++;
>=20
> I'm surprised that the block core doesn't have a helper to count the nu=
mber
> of bios in a request.
>=20
> Please prefer to put a blank line between end-of-locals and start-of-co=
de.

Done.

> > +	dev_dbg(&dev->sbd.core,
> > +		"%s:%u: %s req has %u bios for %lu sectors %lu hard sectors\n",
> > +		__func__, __LINE__, op, n, req->nr_sectors,
> > +		req->hard_nr_sectors);
> > +#endif
> > +
> > +	start_sector =3D req->sector*priv->blocking_factor;
> > +	sectors =3D req->nr_sectors*priv->blocking_factor;
>=20
> s/*/ * /.  checkpatch missed this.

Will change (yes, checkpatch missed it).

> I suspect you didn't run cehckpatch anyway.

I did ;-)

> Please run checkpatch.

All it complains about is (bogus) <asm/firmware.h> and a single too long =
line I
don't want to break.

> > +/* ATA helpers copied from drivers/ata/libata-core.c */
>=20
> ooh, bad person.

I didn't have much choice, as most of it was static and I don't need the =
full
libata core anyway.

If I would factor it out, any good suggestion where to put the factored o=
ut
code?

> > +	ps3disk_identify(dev);
>=20
> ps3disk_identify() can return an error?

Sending storage commands may fail, but being unable to identify the disk =
isn't
fatal, as it's just for informational purposes.

> > +static int ps3disk_remove(struct ps3_system_bus_device *_dev)
> > +{
> > +	struct ps3_storage_device *dev =3D to_ps3_storage_device(&_dev->cor=
e);
> > +	struct ps3disk_private *priv =3D ps3disk_priv(dev);
> > +
> > +	__clear_bit(priv->gendisk->first_minor / PS3DISK_MINORS,
> > +		    &ps3disk_mask);
>=20
> I see no locking here which makes this __clear_bit and the above __set_=
bit
> non-racy?

Were .probe()/.remove() made concurrent again? I thought that idea was dr=
opped
because it caused too many problems?

> > +	kfree(priv);
> > +	ps3disk_priv(dev) =3D NULL;
>=20
> I suspect this nulling here will just hide any bugs?  If we're going to
> write anything there, probably 0xdeadbeef would be better?

Hmm, earlier reviewers explicitly asked for putting it there...

Thanks for your comments!

With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
Fax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Belg=
ium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
Fortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE3900138235861=
9
---584337861-1553872990-1184835473=:8661
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@ozlabs.org
https://ozlabs.org/mailman/listinfo/linuxppc-dev
---584337861-1553872990-1184835473=:8661--
