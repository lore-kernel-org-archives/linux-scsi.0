From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: PMP and SEMB messages to SEP
Date: Mon, 17 Jan 2011 12:05:04 -0600
Message-ID: <1295287504.3015.190.camel@mulgrave.site>
References: <20110114142018.GA978@htj.dyndns.org>
	 <20110114165957.GH16039@MAIL.13thfloor.at>
	 <20110114170407.GE978@htj.dyndns.org>
	 <20110114173759.GI16039@MAIL.13thfloor.at>
	 <20110117154042.GG27123@htj.dyndns.org>
	 <1295281131.3015.44.camel@mulgrave.site>
	 <20110117171312.GL16039@MAIL.13thfloor.at>
	 <20110117172054.GJ27123@htj.dyndns.org>
	 <20110117173433.GM16039@MAIL.13thfloor.at>
	 <20110117173946.GL27123@htj.dyndns.org>
	 <20110117174806.GN16039@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110117174806.GN16039@MAIL.13thfloor.at>
Sender: linux-ide-owner@vger.kernel.org
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-01-17 at 18:48 +0100, Herbert Poetzl wrote:
> On Mon, Jan 17, 2011 at 06:39:46PM +0100, Tejun Heo wrote:
> > On Mon, Jan 17, 2011 at 06:34:33PM +0100, Herbert Poetzl wrote:
> > > hmm, haven't had the time to dig through the specs yet, but
> > > at least addonics seems to disagree here:
> > > 
> > > http://www.addonics.com/products/host_controller/tutorial_pm.asp
> > > 
> > > but maybe that's just a marketing page with no relation
> > > to reality ....
> > 
> > That's hardware RAID PMP.  It would just show up as a single drive to
> > the host.  They can do whatever they want to if they do that.
> 
> okay, understood.
> 
> > > > AFAIK, it just doesn't care.  It could be ses-2 or whatever else.  It
> > > > just transmits the binary blob it receives via sysfs and vice-versa.
> > > 
> > > the interesting part here is, that the AHCI host controller
> > > my PMP is connected to recognizes the PMP perfectly fine
> > > (i.e. more than one drive works just as expected), but doesn't
> > > seem to allow for the em_message part (despite the fact that
> > > the attached PMP seems to be SEMB/SEP capable) ...
> > > 
> > > maybe this is just a bug in the kernel code, maybe the AHCI
> > > implementation doesn't allow a PMP to receive enclosure
> > > management messages at all ...
> > 
> > AFAIK, the ahci em message thing is not via PMP. 
> > It's for cases where the ahci controller is directly connected 
> > to an enclosure. Well, that's my understanding anyway.
> 
> okay, so something similar would be useful for controlling
> enclosures attached to PMPs then?
> 
> what would be the 'proper' place in the sysfs tree, espceically
> as the PMP doesn't show up there (yet)?
> 
> how would I go about adding something like that to the kernel
> and where should it be placed (sysfs and code wise)?

OK, just so we're not at cross purposes:

     1. For an enclosure processor to show up and be attached to the
        enclosure driver, it has to present as a SCSI target.  This
        often means handling nasty encapsulations somewhere (SES is most
        often used on non-standard busses like i2c or GPIO).  If it's
        within a PMP and has a defined encapsulation which ATA
        recognises, it sounds like libata is the best place for this.
     2. The above has nothing to do with whether the PMP device shows up
        in sysfs or has a bsg command port.  That's a completely
        separate discussion based on whether it makes sense (and whether
        we can cope with the topological complexity).  Just by way of
        example, it's mostly not possible to use expanders with
        enclosure devices via our expander bsg device, because there's
        no SMP encapsulation of SES.  What mostly happens is that the
        expander has two or more target ports, one of which is SMP and
        the other (completely separate one) is an addressable SES
        target.

James


