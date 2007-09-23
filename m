From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
Date: Sun, 23 Sep 2007 18:05:23 -0500
Message-ID: <1190588723.3378.25.camel@localhost.localdomain>
References: <20070923040437.GA30170@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756591AbXIWXFi@vger.kernel.org>
In-Reply-To: <20070923040437.GA30170@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2007-09-23 at 00:04 -0400, Jeff Garzik wrote:
> Rather than sitting on this for far too long, I wanted to go ahead and
> get this out there.  I heard some chips might be trickling out into
> public hands.

The first thing to note is about the specs and the pre-production
hardware: the Linux Foundation has mechanism to get both into the hands
of interested developers; if you can point me to contacts, I can at
least get the NDA documentation programme ball rolling.

> This is a bare bones Broadcom 8603 SAS+SATA driver, attempting to use
> the vaunted libsas.  Notes:

I wouldn't call it "vaunted" but it's been a fun project.

> * A quick glance at the FIXMEs will tell you obviously doesn't work.

The first thing I really noted is that SMP and STP protocol support is
stubbed out ... you really can't do anything other than direct device
connection without them.

> * The hardware is quite simple and straightforward and easy to program
>   in an efficient way:  each SAS port has a command queue (DMA ring) and
>   a response queue (DMA ring).  Or if in SATA mode, just a command
>   queue.

That's not such a bad way of doing it ... it pretty much mimics the wire
protocol, which is simply frame in/frame out for SAS.

> * The SAS/SATA negotiation is largely out of our hands.  The silicon
>   does its thing, and then tells us what type of device connected.  We
>   are then expected to switch the port to either SAS mode or SATA mode,
>   accordingly.
> 
> * There is no firmware or anything.  Just DMA and register bitbanging.
>   We have plenty of low-level control.
> 
> * The state of SAS/SATA integration is perpetually pathetic.  Updates
>   in this area are likely.  There's a rumor Brian King @ IBM may look
>   into this area too.
> 
> * This driver pretty much completely lacks exception handling.

I also note there's a slight nomenclature issue which will trip up SAS
people.  All through the driver, you seem to use the word "port" to
refer to a physical phy.  the struct bs_port seems to actually be a phy
descriptor ... unless there's some missing phy<->port setup logic that
will be in the final driver?  The trouble is that phys and ports are
distinct (and not equivalent) objects in SAS.

> As an aside, I am also writing a driver for Marvell chips that behave
> quite similarly to this chip.  It seems the future of storage might look
> like these Broadcom and Marvell SAS+SATA DMA ring interfaces, in the
> volume marketspace at least.

If you have a contact here too, I can get the LF NDA and hardware
programmes rolling.

James
