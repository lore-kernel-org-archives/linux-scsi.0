From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Date: Tue, 7 Sep 2010 18:15:43 -0400
Message-ID: <20100907221543.GB22525@redhat.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
 <1283509796-1510-24-git-send-email-tj@kernel.org>
 <4C84CD18.6060906@redhat.com>
 <20100907211724.GA22525@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100907211724.GA22525@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: jack@suse.cz, mst@redhat.com, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, hch@lst.de, k-ueda@ct.jp.nec.com, vst@vlnb.net, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>, mpatocka@redhat.com, swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 07 2010 at  5:17pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Sep 06 2010 at  7:14am -0400,
> Milan Broz <mbroz@redhat.com> wrote:
> 
> > On 09/03/2010 12:29 PM, Tejun Heo wrote:
> > 
> > > +++ b/drivers/md/dm-crypt.c
> > > @@ -1278,7 +1278,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
> > >  	struct dm_crypt_io *io;
> > >  	struct crypt_config *cc;
> > >  
> > > -	if (unlikely(bio_empty_barrier(bio))) {
> > > +	if (bio->bi_rw & REQ_FLUSH) {
> > >  		cc = ti->private;
> > >  		bio->bi_bdev = cc->dev->bdev;
> > >  		return DM_MAPIO_REMAPPED;
> > 
> > ...
> > 
> > > +++ b/drivers/md/dm.c
> > > @@ -1400,14 +1391,22 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
> > >  	ci.io->md = md;
> > >  	spin_lock_init(&ci.io->endio_lock);
> > >  	ci.sector = bio->bi_sector;
> > > -	ci.sector_count = bio_sectors(bio);
> > > -	if (unlikely(bio_empty_barrier(bio)))
> > > +	if (!(bio->bi_rw & REQ_FLUSH))
> > > +		ci.sector_count = bio_sectors(bio);
> > > +	else {
> > > +		/* all FLUSH bio's reaching here should be empty */
> > > +		WARN_ON_ONCE(bio_has_data(bio));
> > >  		ci.sector_count = 1;
> > > +	}
> > 
> > 
> > I would add BUG_ON(bio_has_data(bio)) either to dm-crypt target or directly to DM core
> > in this path.
> 
> I agree, that WARN_ON_ONCE should be changed to BUG_ON.  This is a
> guarantee that the block layer now provides so it seems correct to have
> the DM core bug if that guarantee isn't actually provided.

I was mistaken, DM enforces that guarantee... ;)

(but block layer will also enforce empty flush for request-based)

But it wasn't clear until Christoph and I looked closer.  The point
stands though; we should BUG_ON rather than WARN_ON_ONCE.

I'll send a follow-on patch to help clean this code up a bit more (based
on Christoph's suggestions).  Mainly just making the flush paths a bit
more distinct and adding some comments.

Mike
