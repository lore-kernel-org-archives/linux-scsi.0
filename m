From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Wed, 11 Apr 2018 20:52:18 -0400
Message-ID: <20180412005218.GA12237@animx.eu.org>
References: <595a10cfb387e6b2ab4d2053b84fed9b3da9e079.camel@wdc.com>
 <20180406014644.GA16112@animx.eu.org>
 <20180406020651.GB16112@animx.eu.org>
 <fb0640c203409a84ab1bfbbc41078a5416138ad2.camel@wdc.com>
 <20180407165335.GA2515@animx.eu.org>
 <1ff8d234cc565ba9701ce31899fca5faa597e050.camel@wdc.com>
 <20180408160254.GA22869@animx.eu.org>
 <f9467e78ce05446e7a89f06713c36fb638d1b6ad.camel@wdc.com>
 <20180409233436.GC6450@ming.t460p>
 <20180411004525.GA9107@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180411004525.GA9107@animx.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Wakko Warner wrote:
> Ming Lei wrote:
> > Sure, thanks for your sharing.
> > 
> > Wakko, could you test the following patch and see if there is any
> > difference?
> > 
> > --
> > diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> > index 0d99b242e82e..6147178f1f37 100644
> > --- a/drivers/target/target_core_pscsi.c
> > +++ b/drivers/target/target_core_pscsi.c
> > @@ -888,7 +888,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
> >  		if (len > 0 && data_len > 0) {
> >  			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
> >  			bytes = min(bytes, data_len);
> > -
> > + new_bio:
> >  			if (!bio) {
> >  				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
> >  				nr_pages -= nr_vecs;
> > @@ -931,6 +931,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
> >  				 * be allocated with pscsi_get_bio() above.
> >  				 */
> >  				bio = NULL;
> > +				goto new_bio;
> >  			}
> >  
> >  			data_len -= bytes;
> 
> Sorry for the delay.  I reverted my change, added this one.  I didn't
> reboot, I just unloaded and loaded this one.
> Note: /dev/sr1 as seen from the initiator is /dev/sr0 (physical disc) on the
> target.
> 
> Doesn't crash, however on the initiator I see this:
> [9273849.707777] ISO 9660 Extensions: RRIP_1991A
> [9273863.359718] scsi_io_completion: 13 callbacks suppressed
> [9273863.359788] sr 26:0:0:0: [sr1] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> [9273863.359909] sr 26:0:0:0: [sr1] tag#1 Sense Key : 0x2 [current] 
> [9273863.359974] sr 26:0:0:0: [sr1] tag#1 ASC=0x8 ASCQ=0x0 
> [9273863.360036] sr 26:0:0:0: [sr1] tag#1 CDB: opcode=0x28 28 00 00 22 f6 96 00 00 80 00
> [9273863.360116] blk_update_request: 13 callbacks suppressed
> [9273863.360177] blk_update_request: I/O error, dev sr1, sector 9165400
> [9273875.864648] sr 26:0:0:0: [sr1] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
> [9273875.864738] sr 26:0:0:0: [sr1] tag#1 Sense Key : 0x2 [current] 
> [9273875.864801] sr 26:0:0:0: [sr1] tag#1 ASC=0x8 ASCQ=0x0 
> [9273875.864890] sr 26:0:0:0: [sr1] tag#1 CDB: opcode=0x28 28 00 00 22 f7 16 00 00 80 00
> [9273875.864971] blk_update_request: I/O error, dev sr1, sector 9165912

Just FYI: The jobs that I do that uses the disc over iscsi didn't cause any
kernel messages on either system (except for the informational when the disc
was mounted)

I have a dumb question though.  Could the label be placed just after the
'if' statement instead of before it?  bio is set to null and the 'if'
statement checks if it's null, which it always would be after the goto.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
