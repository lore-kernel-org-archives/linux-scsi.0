From: Ming Lei <ming.lei@redhat.com>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Fri, 13 Apr 2018 09:55:58 +0800
Message-ID: <20180413015551.GA12601@ming.t460p>
References: <20180406020651.GB16112@animx.eu.org>
 <fb0640c203409a84ab1bfbbc41078a5416138ad2.camel@wdc.com>
 <20180407165335.GA2515@animx.eu.org>
 <1ff8d234cc565ba9701ce31899fca5faa597e050.camel@wdc.com>
 <20180408160254.GA22869@animx.eu.org>
 <f9467e78ce05446e7a89f06713c36fb638d1b6ad.camel@wdc.com>
 <20180409233436.GC6450@ming.t460p>
 <20180411004525.GA9107@animx.eu.org>
 <20180412100751.GB4697@ming.t460p>
 <20180413014302.GA3891@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180413014302.GA3891@animx.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 12, 2018 at 09:43:02PM -0400, Wakko Warner wrote:
> Ming Lei wrote:
> > On Tue, Apr 10, 2018 at 08:45:25PM -0400, Wakko Warner wrote:
> > > Sorry for the delay.  I reverted my change, added this one.  I didn't
> > > reboot, I just unloaded and loaded this one.
> > > Note: /dev/sr1 as seen from the initiator is /dev/sr0 (physical disc) on the
> > > target.
> > > 
> > > Doesn't crash, however on the initiator I see this:
> > > [9273849.707777] ISO 9660 Extensions: RRIP_1991A
> > > [9273863.359718] scsi_io_completion: 13 callbacks suppressed
> > > [9273863.359788] sr 26:0:0:0: [sr1] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> > > [9273863.359909] sr 26:0:0:0: [sr1] tag#1 Sense Key : 0x2 [current] 
> > > [9273863.359974] sr 26:0:0:0: [sr1] tag#1 ASC=0x8 ASCQ=0x0 
> > > [9273863.360036] sr 26:0:0:0: [sr1] tag#1 CDB: opcode=0x28 28 00 00 22 f6 96 00 00 80 00
> > > [9273863.360116] blk_update_request: 13 callbacks suppressed
> > > [9273863.360177] blk_update_request: I/O error, dev sr1, sector 9165400
> > > [9273875.864648] sr 26:0:0:0: [sr1] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> > > [9273875.864738] sr 26:0:0:0: [sr1] tag#1 Sense Key : 0x2 [current] 
> > > [9273875.864801] sr 26:0:0:0: [sr1] tag#1 ASC=0x8 ASCQ=0x0 
> > > [9273875.864890] sr 26:0:0:0: [sr1] tag#1 CDB: opcode=0x28 28 00 00 22 f7 16 00 00 80 00
> > > [9273875.864971] blk_update_request: I/O error, dev sr1, sector 9165912
> > > 
> > > To cause this, I mounted the dvd as seen in the first line and ran this
> > > command: find /cdrom2 -type f | xargs -tn1 cat > /dev/null
> > > I did some various tests.  Each test was done after umount and mount to
> > > clear the cache.
> > > cat <file> > /dev/null causes the message.
> > > dd if=<file> of=/dev/null bs=2048 doesn't
> > > 	using bs=4096 doesn't
> > > 	using bs=64k doesn't
> > > 	using bs=128k does
> > > cat uses a blocksize of 128k.
> > > 
> > > The following was done without being mounted.
> > > ddrescue -f -f /dev/sr1 /dev/null 
> > > 	doesn't cause the message
> > > dd if=/dev/sr1 of=/dev/null bs=128k
> > > 	doesn't cause the message
> > > using bs=256k causes the message once:
> > > [9275916.857409] sr 27:0:0:0: [sr1] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> > > [9275916.857482] sr 27:0:0:0: [sr1] tag#0 Sense Key : 0x2 [current] 
> > > [9275916.857520] sr 27:0:0:0: [sr1] tag#0 ASC=0x8 ASCQ=0x0 
> > > [9275916.857556] sr 27:0:0:0: [sr1] tag#0 CDB: opcode=0x28 28 00 00 00 00 00 00 00 80 00
> > > [9275916.857614] blk_update_request: I/O error, dev sr1, sector 0
> > > 
> > > If I access the disc from the target natively either by mounting and
> > > accessing files or working with the device directly (ie dd) no errors are
> > > logged on the target.
> > 
> > OK, thanks for your test.
> > 
> > Could you test the following patch and see if there is still the failure
> > message?
> > 
> > diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> > index 0d99b242e82e..6137287b52fb 100644
> > --- a/drivers/target/target_core_pscsi.c
> > +++ b/drivers/target/target_core_pscsi.c
> > @@ -913,9 +913,11 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
> >  
> >  			rc = bio_add_pc_page(pdv->pdv_sd->request_queue,
> >  					bio, page, bytes, off);
> > +			if (rc != bytes)
> > +				goto fail;
> >  			pr_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
> >  				bio_segments(bio), nr_vecs);
> > -			if (rc != bytes) {
> > +			if (/*rc != bytes*/0) {
> >  				pr_debug("PSCSI: Reached bio->bi_vcnt max:"
> >  					" %d i: %d bio: %p, allocating another"
> >  					" bio\n", bio->bi_vcnt, i, bio);
> 
> Target doesn't crash but the errors on the initiator are still there.

OK, then this error log isn't related with my commit, because the patch
I sent to you in last email is to revert my commit simply.

But the following patch is one correct fix for your crash.

https://marc.info/?l=linux-kernel&m=152331690727052&w=2


Thanks,
Ming
