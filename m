From: Ming Lei <ming.lei@redhat.com>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Tue, 10 Apr 2018 07:34:37 +0800
Message-ID: <20180409233436.GC6450@ming.t460p>
References: <20180401163604.GB25011@animx.eu.org>
 <20180401182723.GA31755@animx.eu.org>
 <595a10cfb387e6b2ab4d2053b84fed9b3da9e079.camel@wdc.com>
 <20180406014644.GA16112@animx.eu.org>
 <20180406020651.GB16112@animx.eu.org>
 <fb0640c203409a84ab1bfbbc41078a5416138ad2.camel@wdc.com>
 <20180407165335.GA2515@animx.eu.org>
 <1ff8d234cc565ba9701ce31899fca5faa597e050.camel@wdc.com>
 <20180408160254.GA22869@animx.eu.org>
 <f9467e78ce05446e7a89f06713c36fb638d1b6ad.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f9467e78ce05446e7a89f06713c36fb638d1b6ad.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "wakko@animx.eu.org" <wakko@animx.eu.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 09, 2018 at 09:30:11PM +0000, Bart Van Assche wrote:
> On Sun, 2018-04-08 at 12:02 -0400, Wakko Warner wrote:
> > I finished with git bisect.  Here's the output:
> > 84c8590646d5b35804bac60eb58b145839b5893e is the first bad commit
> > commit 84c8590646d5b35804bac60eb58b145839b5893e
> > Author: Ming Lei <tom.leiming@gmail.com>
> > Date:   Fri Nov 11 20:05:32 2016 +0800
> > 
> >     target: avoid accessing .bi_vcnt directly
> >     
> >     When the bio is full, bio_add_pc_page() will return zero,
> >     so use this information tell when the bio is full.
> >     
> >     Also replace access to .bi_vcnt for pr_debug() with bio_segments().
> >     
> >     Reviewed-by: Christoph Hellwig <hch@lst.de>
> >     Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> >     Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> >     Signed-off-by: Jens Axboe <axboe@fb.com>
> > 
> > :040000 040000 a3ebbb71c52ee4eb8c3be4d033b81179211bf704 de39a328dbd1b18519946b3ad46d9302886e0dd0 M      drivers
> > 
> > I did a diff between HEAD^ and HEAD and manually patched the file from
> > 4.15.14.  It's not an exact revert.  I'm running it now and it's working.
> > I'll do a better test later on.  Here's the patch:
> > 
> > --- a/drivers/target/target_core_pscsi.c	2018-02-04 14:31:31.077316617 -0500
> > +++ b/drivers/target/target_core_pscsi.c	2018-04-08 11:43:49.588641374 -0400
> > @@ -915,7 +915,9 @@
> >  					bio, page, bytes, off);
> >  			pr_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
> >  				bio_segments(bio), nr_vecs);
> > -			if (rc != bytes) {
> > +			if (rc != bytes)
> > +				goto fail;
> > +			if (bio->bi_vcnt > nr_vecs) {
> >  				pr_debug("PSCSI: Reached bio->bi_vcnt max:"
> >  					" %d i: %d bio: %p, allocating another"
> >  					" bio\n", bio->bi_vcnt, i, bio);
> 
> Hello Ming,
> 
> Can you have a look at this? The start of this e-mail thread is available at
> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg72574.html.

Sure, thanks for your sharing.

Wakko, could you test the following patch and see if there is any
difference?

--
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 0d99b242e82e..6147178f1f37 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -888,7 +888,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		if (len > 0 && data_len > 0) {
 			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
 			bytes = min(bytes, data_len);
-
+ new_bio:
 			if (!bio) {
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
 				nr_pages -= nr_vecs;
@@ -931,6 +931,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 				 * be allocated with pscsi_get_bio() above.
 				 */
 				bio = NULL;
+				goto new_bio;
 			}
 
 			data_len -= bytes;

-- 
Ming
