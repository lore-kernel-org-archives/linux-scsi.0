From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PATCH: usb-storage-psc1350-v4.patch (was
	Linux	scsi	/	usb-mass-storage and HP printer cardreader bug + fix)
Date: Mon, 14 Jan 2008 13:09:18 -0600
Message-ID: <1200337759.3159.58.camel@localhost.localdomain>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com>
	<4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>
	<4787CE08.5000304@hhs.nl> <1200303645.11301.15.camel@littletux>
	<478B2F90.7010105@hhs.nl> <20080114160310.GH14375@one-eyed-alien.net>
	<1200328388.3159.20.camel@localhost.localdomain>
	<478BABF0.1040403@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <478BABF0.1040403@hhs.nl>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Guillaume Bedot <littletux@zarb.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, David Brown <usb-storage2@davidb.org>, fedora-kernel-list@redhat.com, Boaz Harrosh <bharrosh@panasas.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org


On Mon, 2008-01-14 at 19:37 +0100, Hans de Goede wrote:
> James Bottomley wrote:
> > On Mon, 2008-01-14 at 08:03 -0800, Matthew Dharm wrote:
> >> On Mon, Jan 14, 2008 at 10:46:56AM +0100, Hans de Goede wrote:
> >>> Guillaume Bedot wrote:
> >>>> But it fixes only two models.
> >>>> Do you think other devices (hp or not) can be impacted ?
> >>>> There are hundreds of models with card readers only for hp :
> >>>> http://hplip.sourceforge.net/supported_devices/combined.html
> >>>>
> >>>> Will this be possible to use "LAST_SECTOR_BUG" quirk for testing without
> >>>> recompiling a kernel ?
> >>>>
> >>> This is not possible AFAIK, I've already wrote a blog post about this 
> >>> asking for people to test this, but got no responses.
> >> Once the patches are accepted by the SCSI people, one of the things we can
> >> consider doing is enabling this quirk for all USB devices.  It should be
> >> pretty harmless to all properly working devices, and the performance hit
> >> should be pretty minimal.
> > 
> > The SCSI patches look OK, with the stylistic points fixed below ...
> > we'll need two separate patches as well (one for SCSI, one for USB).
> > 
> 
> Okay,
> 
> Thanks for the review! I'll do a new scsi changes only patch once I get an 
> answer to some questions regarding your review.
> 
> >> +       /* Some devices (some sdcards for one) don't like it if the last sector
> >> +          gets read in a larger then 1 sector read */
> > 
> > The comment style in sd is
> > 
> > /*
> >  * comment
> >  */
> > 
> 
> Will fix,
> 
> >> +       if (sdp->last_sector_bug && rq->nr_sectors > sdp->sector_size / 512 &&
> > 
> > An unlikely() here, please to force the compiler to optimise for the
> > non-buggy case.
> 
> Will do.
> 
> > Plus what is the rq->nr_sectors > sdp->sector_size /
> > 512 test supposed to be doing?  that being true is supposed to be a
> > guarantee of the block layer (and if something goes wrong there's a
> > check for this lower down).
> > 
> 
> It first is was just:
> rq->nr_sectors > 1
> 
> Then I changed it to also do the right thing for 1024 and larger sector disks. 
> The whole purpose is to not read the last sector in a larger then one sector 
> read, so the amount of sectors gets reduced by one if (block + rq->nr_sectors 
> == get_capacity(disk)) but we do want still want to be able to read the last 
> sector by itself, so we must not reduce the no sectors to be read by one if it 
> is already one.

Yes, I know that.  What I mean is the block subsystem sends reads and
writes down in increments of the sector size.  Checking if the current
number of pending sectors is greater than the current block size is
checking that guarantee.  The current code already has a check in it to
see if this guarantee is observed ... you don't need to check it again.

> >> +           block + rq->nr_sectors == get_capacity(disk)) {
> > 
> > rq->nr_sectors should be this_count
> > 
> 
> Fine by me, but in this place in the code they are the same value, and the 
> check for a read beyond the end of disk a few lines above also uses 
> rq->nr_sectors, which one should be used when?

this_count is the adjusted sector size.  At the moment, there's no size
transformation in the code between your check and the top (where
this_count is set to rq->nr_sectors).  But if there were (and someone
might add one one day) you'd be wanting to check the adjusted size (i.e.
this_count).

> >> +               this_count -= sdp->sector_size / 512;
> > 
> > If you relocate this code to after the sector_size/this_count adjustment
> > code (i.e. about line 442) you can just do --this_count;
> > 
> 
> I cannot move the check down as then block has been adjusted for the sector 
> size, so if I move the check down it becomes:
> if (block * (sdp->sector_size / 512) + rq->nr_sectors == get_capacity(disk))
> 
> I would rather not have the sdp->sector_size / 512 code in the check (slow) but 
> rather in the not often entered if block.

OK, point taken, it would be worse.  I think today's compilers are happy
to translate x/512 to x>>9, so it shouldn't be that slow.

James



-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
