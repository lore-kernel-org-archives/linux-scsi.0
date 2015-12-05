From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/3] badblocks: Add core badblock management code
Date: Fri, 04 Dec 2015 16:06:35 -0800
Message-ID: <1449273995.27077.32.camel@HansenPartnership.com>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com>
	 <1448477013-9174-2-git-send-email-vishal.l.verma@intel.com>
	 <1449271801.27077.25.camel@HansenPartnership.com>
	 <1449273524.16905.103.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449273524.16905.103.camel@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "neilb@suse.com" <neilb@suse.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "axboe@fb.com" <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-12-04 at 23:58 +0000, Verma, Vishal L wrote:
> On Fri, 2015-12-04 at 15:30 -0800, James Bottomley wrote:
> [...]
> > > + * We return
> > > + *  0 if there are no known bad blocks in the range
> > > + *  1 if there are known bad block which are all acknowledged
> > > + * -1 if there are bad blocks which have not yet been acknowledg=
ed
> > > in metadata.
> > > + * plus the start/length of the first bad section we overlap.
> > > + */
> >=20
> > This comment should be docbook.
>=20
> Applicable to all your comments - (and they are all valid), I simply
> copied over all this from md. I'm happy to make the changes to commen=
ts,
> and the other two things (see below) if that's the right thing to do =
--
> I just tried to keep my own changes to the original md badblocks code
> minimal.
> Would it be better (for review-ability) if I made these changes in a =
new
> patch on top of this, or should I just squash them into this one?

If you were moving it, that might be appropriate.  However, this is
effectively new code because you're not removing the original, so we
should begin at least with a coherent API. (i.e. corrections to the
original patch rather than incremental).

Thanks,

James


> >=20
> > > +int badblocks_check(struct badblocks *bb, sector_t s, int sector=
s,
> > > +			sector_t *first_bad, int *bad_sectors)
> > [...]
> > > +
> > > +/*
> > > + * Add a range of bad blocks to the table.
> > > + * This might extend the table, or might contract it
> > > + * if two adjacent ranges can be merged.
> > > + * We binary-search to find the 'insertion' point, then
> > > + * decide how best to handle it.
> > > + */
> >=20
> > And this one, plus you don't document returns.  It looks like this
> > function returns 1 on success and zero on failure, which is really
> > counter-intuitive for the kernel: zero is usually returned on succe=
ss
> > and negative error on failure.
> >=20
> > > +int badblocks_set(struct badblocks *bb, sector_t s, int sectors,
> > > +			int acknowledged)
> > [...]
> > > +
> > > +/*
> > > + * Remove a range of bad blocks from the table.
> > > + * This may involve extending the table if we spilt a region,
> > > + * but it must not fail.  So if the table becomes full, we just
> > > + * drop the remove request.
> > > + */
> >=20
> > Docbook and document returns.  This time they're the kernel standar=
d
> > of
> > 0 on success and negative error on failure making the convention fo=
r
> > badblocks_set even more counterintuitive.
> >=20
> > > +int badblocks_clear(struct badblocks *bb, sector_t s, int sector=
s)
> > > +{
> > [...]
> > > +#define DO_DEBUG 1
> >=20
> > Why have this at all if it's unconditionally defined and always set=
=2E
>=20
> Neil - any reason or anything you had in mind for this? Or is it just=
 an
> artifact and can be removed.
>=20
> >=20
> > > +ssize_t badblocks_store(struct badblocks *bb, const char *page,
> > > size_t len,
> > > +			int unack)
> > [...]
> > > +int badblocks_init(struct badblocks *bb, int enable)
> > > +{
> > > +	bb->count =3D 0;
> > > +	if (enable)
> > > +		bb->shift =3D 0;
> > > +	else
> > > +		bb->shift =3D -1;
> > > +	bb->page =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
> >=20
> > Why not __get_free_page(GFP_KERNEL)?  The problem with kmalloc of a=
n
> > exactly known page sized quantity is that the slab tracker for this
> > requires two contiguous pages for each page because of the overhead=
=2E
>=20
> Cool, I didn't know about __get_free_page - I can fix this up too.
>=20
> >=20
> > James
> >=20
> > NrybX=C7=A7v^)=DE=BA{.n+{"{ay=1D=CA=87=DA=99,j=07fhz=1Ew=0Cj:+vwjm=07=
zZ+=DD=A2j"!



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
