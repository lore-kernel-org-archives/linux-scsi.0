From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Fri, 16 Sep 2016 22:14:56 -0700
Message-ID: <1474089296.2353.101.camel@HansenPartnership.com>
References: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
         <yq1d1k6l43x.fsf@sermon.lab.mkp.net>
         <CAHmME9pX1sSdFLfsgBqunh=5ttmPg5-vAzvTEfD1Xt4NBk6JzA@mail.gmail.com>
         <yq1twdhb0zr.fsf@sermon.lab.mkp.net>
         <CAHmME9qq5vSC+hZckCystU6cdRPihO492U2B2-pozbwg=3_5nw@mail.gmail.com>
         <5af202ea-a632-28c2-515f-c361e27de5da@suse.de>
         <c2c154db-67fe-dcaa-a46a-48a53e15d1cf@gmail.com>
         <1474042904.2353.52.camel@HansenPartnership.com>
         <add395b3-80df-0402-d8b7-d2fb79d9aebf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <add395b3-80df-0402-d8b7-d2fb79d9aebf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Hannes Reinecke <hare@suse.de>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-09-16 at 13:06 -0400, Austin S. Hemmelgarn wrote:
> On 2016-09-16 12:21, James Bottomley wrote:
> > On Fri, 2016-09-16 at 11:53 -0400, Austin S. Hemmelgarn wrote:
> > > On 2016-09-16 07:16, Hannes Reinecke wrote:
> > > > On 09/15/2016 10:52 PM, Jason A. Donenfeld wrote:
> > > > > Hi Martin,
> > > > > 
> > > > > On Thu, Sep 15, 2016 at 6:07 PM, Martin K. Petersen
> > > > > > But how do they signal that ATA passthrough is possible? Is
> > > > > > there an ATA Information VPD page? Is REPORT SUPPORTED
> > > > > > OPERATION CODES supported?
> > > > > > 
> > > > > > We need really solid discovery data before we can entertain
> > > > > > enabling something like this.
> > > > > 
> > > > > `sg_opcodes` said invalid request, so I think there isn't REPORT
> > > > > SUPPORTED OPERATION CODES, and `sg_vpd -p ai` came up illegal
> > > > > too.
> > > > > 
> > > > > However, sg_sat_identify worked reliably, which means a solid way
> > > > > of probing this would be to send IDENTIFY DEVICE ATA via
> > > > > SG_ATA_16 or SG_ATA_12.
> > > > > 
> > > > > Let me know and I can give you access to the hardware if you're
> > > > > curious.
> > > > > 
> > > > Sadly, that's not sufficient.
> > > > linux is not the only provider of an SATL (mpt3sas being the most
> > > > prominent other one).
> > > > And while they might support ATA_12/ATA_16, there is no indication
> > > > that you can pass DSM TRIM that way.
> > > So it's better to not support it at all than to support it on
> > > hardware we can reliably identify?
> > > 
> > > I get that having feature parity is a good thing, but the discussion
> > > isn't about providing support for all SATL devices, it's specifically
> > > about UAS connected SATL devices.  Last I checked, mpt3sas doesn't do
> > > anything with UAS, which means it's kind of irrelevant WRT supporting
> > > this for UAS devices.
> > 
> > We're getting a bit off topic on mptsas and it's eccentric SATL.
> > 
> > The point is, you're asking for UAS devices which each have an internal
> > SATL which you say potentially doesn't support discard.  The three
> > problems we have are
> > 
> >    1. How do we identify if the UAS SATL doesn't support discard.  If it
> >       does, we really don't want to cause further SATL related issues by
> >       bypassing it, so we need a way of telling this.
> >    2. If the SATL doesn't support discard, will it reliably support the
> >       ATA_12 or ATA_16 pass through (and which one) .. we need a way of
> >       checking this because there are known SATLs that don't do pass
> >       through.
> >    3. How do we actually configure it?  Presumably if the SATL doesn't
> >       support discard, it also doesn't give us the useful mode page
> >       indications we use to configure TRIM, so we're going to have to do
> >       some pass through discovery as well.
> I assume by 'discard' here you're referring to SCSI UNMAP, as 
> anything that supports ATA_12 or ATA_16 pass through correctly will 
> support ATA TRIM/DISCARD on drives that support it.

discard is the block layer terminology it's mapped per transport to
UNMAP or WRITE SAME on SCSI and TRIM on ATA.

>   If that's the case, then:
> 1. If SCSI UNMAP fails, it doesn't support UNMAP.  This is of course 
> non-trivial to verify safely (we pretty much have to assume it is 
> supported if we have no clear indication it isn't, and then switch 
> based on what happens the first time we try to use it).

It's not quite that simple: to get us to configure discard in the first
place, you have to indicate support in READ CAPACITY (16): the LBPME
bit.  The chances are your UAS SATL isn't setting this.

> 2. Unless there are SATL's out there that write garbage to the device 
> or die when sent an ATA_12 or ATA_16 pass through command


Yes, there are; the problems with USB devices that fail to speak
standard versions of SCSI are legion.

> encapsulating an ATA DEVICE IDENTIFY command, this isn't an issue. 
>  Even if such SATL's exist, they can easily be blacklisted.
> 3. This isn't hard, a SATL which actually supports ATA pass through 
> will almost always pass through the mode page unmodified.

You mean the ATA Information VPD page?  Yes, that's feasible because we
already queried the supported VPD pages, so we can tell if this one's
there.

> On the note of UAS SATL's, all of them that I've seen fall into one 
> of four categories:
> 1. Supports one or both of ATA_12 or ATA_16 pass through, and 
> supports passing through ATA TRIM/DISCARD, but not SCSI UNMAP.
> 2. Supports one of ATA_12 or ATA_16 pass through, and does not 
> support passing through ATA TRIM/DISCARD or translating SCSI UNMAP. 
>  All devices I've seen that fit this will modify the ATA DEVICE 
> IDENTIFY data so it doesn't report DISCARD support, or will simply 
> return an error for DISCARD requests.  I haven't seen any like this 
> that were manufactured after UAS became standardized.
> 3. Supports neither ATA_12 or ATA_16 pass through, and doesn't 
> support UNMAP.
> 4. Like type 1, except it supports both pass through commands, and 
> also properly translates SCSI UNMAP commands (I've only ever seen one 
> of these, have no idea what chipset it had, and it was insanely
> expensive (upside of 300 USD)).
> All we really can do anything about is category 1.  Category 4 works 
> with the current drivers, and we can't properly support it on 
> category 2 or 3.

Right, but you need to make sure it continues to work.

>   All three devices I have right now are in category 1, I know a
 
> number of other people in a similar situation, and it sounds like 
> Jason has at least one such device as well.  Given that Windows does 
> this (I've confirmed this with a hardware USB analyzer I borrowed 
> from a friend), and that I've not seen anything since the UAS spec 
> was actually released that falls into category 2 (and if I understand 
> the spec correctly, such a device is actually not compliant with it 
> anyway), think it's probably safe to do this in Linux and just base 
> the check on:
> 1. UAS (not some other SCSI transport) without UNMAP support.
> 2. Supports ATA_12 or ATA_16 pass through.
> 3. ATA DEVICE IDENTIFY via SAT indicates that the device supports 
> DISCARD/TRIM.
> Then we'd be matching behavior on Windows, and should probably be 
> relatively safe.

OK, well I think we've all expressed the concerns, let's see the patch.

James
