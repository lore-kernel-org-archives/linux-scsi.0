From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
Date: Sun, 23 Sep 2007 19:43:13 -0400
Message-ID: <46F6FA11.2070501@garzik.org>
References: <20070923040437.GA30170@havoc.gtf.org> <1190588723.3378.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52800 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbXIWXnP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Sep 2007 19:43:15 -0400
In-Reply-To: <1190588723.3378.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2007-09-23 at 00:04 -0400, Jeff Garzik wrote:
>> Rather than sitting on this for far too long, I wanted to go ahead and
>> get this out there.  I heard some chips might be trickling out into
>> public hands.
> 
> The first thing to note is about the specs and the pre-production
> hardware: the Linux Foundation has mechanism to get both into the hands
> of interested developers; if you can point me to contacts, I can at
> least get the NDA documentation programme ball rolling.

Well, are there interested, motivated, skilled developers with time?  :)

Otherwise it's a moot point.


>> This is a bare bones Broadcom 8603 SAS+SATA driver, attempting to use
>> the vaunted libsas.  Notes:
> 
> I wouldn't call it "vaunted" but it's been a fun project.

That was sarcasm :)

libsas is a big 'ole pain, that I'm finding has many aic94xx-isms buried 
in the lib.


>> * A quick glance at the FIXMEs will tell you obviously doesn't work.
> 
> The first thing I really noted is that SMP and STP protocol support is
> stubbed out ... you really can't do anything other than direct device
> connection without them.

That's sorta the way I read the hardware docs, too.

I have some engineering questions pending with Broadcom, but from my 
read, SMP and STP don't seem supported.


>> * The hardware is quite simple and straightforward and easy to program
>>   in an efficient way:  each SAS port has a command queue (DMA ring) and
>>   a response queue (DMA ring).  Or if in SATA mode, just a command
>>   queue.
> 
> That's not such a bad way of doing it ... it pretty much mimics the wire
> protocol, which is simply frame in/frame out for SAS.

Yep.  The hardware (on my end of the spectrum) seems to be moving 
towards forcing software to generate all "packets," except (a) data 
frames [generated via DMA engine] or (b) special frames that need to 
modify the software-generate frame.


>> * The SAS/SATA negotiation is largely out of our hands.  The silicon
>>   does its thing, and then tells us what type of device connected.  We
>>   are then expected to switch the port to either SAS mode or SATA mode,
>>   accordingly.
>>
>> * There is no firmware or anything.  Just DMA and register bitbanging.
>>   We have plenty of low-level control.
>>
>> * The state of SAS/SATA integration is perpetually pathetic.  Updates
>>   in this area are likely.  There's a rumor Brian King @ IBM may look
>>   into this area too.
>>
>> * This driver pretty much completely lacks exception handling.
> 
> I also note there's a slight nomenclature issue which will trip up SAS
> people.  All through the driver, you seem to use the word "port" to
> refer to a physical phy.  the struct bs_port seems to actually be a phy
> descriptor ... unless there's some missing phy<->port setup logic that
> will be in the final driver?  The trouble is that phys and ports are
> distinct (and not equivalent) objects in SAS.

Nomemclature came straight from the hardware docs, I'm afraid.

Comparing with the Marvell hardware, I can see how (with Marvell) wide 
ports can be set up, and the port/phy distinction is easily programmable 
depending on the situation.

Not so with BCM8603.

The only places where the docs mention SMP and STP at all is in the SAS 
outgoing DMA descriptor docs, when you fill in connection type.  The 
_only_ other mention of SMP or STP at all is a note saying neither is 
supported.  So, even the docs contradict themselves, but overall I have 
the feeling that SMP/STP are out of my hands.

I wonder if Broadcom's interface is born out of the closed RAID-on-chip 
product that this is descended from.

Hopefully more knowledge will be gained soon, as I debug simple SAS and 
SATA device plug/unplug, and ask Broadcom questions.


>> As an aside, I am also writing a driver for Marvell chips that behave
>> quite similarly to this chip.  It seems the future of storage might look
>> like these Broadcom and Marvell SAS+SATA DMA ring interfaces, in the
>> volume marketspace at least.
> 
> If you have a contact here too, I can get the LF NDA and hardware
> programmes rolling.

Same response as at the top :)  Marvell is actually better at responding 
than Broadcom, but I'm quite reluctant to make /another/ introduction 
(already did so for one hacker) that leads nowhere.

	Jeff


