From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Mon, 17 Feb 2003 15:17:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030217151729.A21987@redhat.com>
References: <3E4AAA3F.8040002@splentec.com> <20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com> <20030213154748.A1965@infradead.org> <3E4BEA13.50402@splentec.com> <20030213192440.A6660@redhat.com> <20030214165827.GA1165@beaverton.ibm.com> <3E4D44EB.1090402@splentec.com> <1045257640.1726.23.camel@mulgrave> <3E5119EC.7080907@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E5119EC.7080907@splentec.com>; from luben@splentec.com on Mon, Feb 17, 2003 at 12:20:44PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Feb 17, 2003 at 12:20:44PM -0500, Luben Tuikov wrote:
> James Bottomley wrote:
> 
> It is *not* ``philosophical''.  It's what's in SAM-2/3.  And it is what
> most SPI HBA do this already (since you use SPI HBA's in your example).



> When was the last time a SPI HBA set channel/bus to anything different
> than 0?

The last time someone booted up an Adaptec 2742T controller for one.

> My Adaptec AIC-7899P dual channel, presents two hosts, not two channels.
> And this is the right behaviour.

It is the right behaviour for that controller, no more.  The right
behaviour is determined by the controller in question, not philosophical
beliefs.  In the case of the 2742T controllers there are two busses on one
scsi chip, you have to flip a bit in the chip to switch control regs
between busses, the chip has a maximum number of commands it can handle
and those are shared between the two busses, etc.  Representing that as
one host is the right thing to do because that's how all the resource
limits, etc. have to be calculated.

> IOW, it already is hinting that those are ``portals''.  There is no
> such thing as a ``host'' in SCSI-3.  ``host'' is an SPI term, and is gone
> from SAM and SPC (which is what scsi-core should represent).

I disagree with that last statement strongly!  I've mentioned this in
private email before.  The scsi core should represent reality, not any
version of any spec!  It should *implement* the scsi protocol, but it need
not and should not try to emulate any specific version of the scsi spec in
design and it needs to and should try to represent the reality of the
hardware you are working with.  And reality is that no matter what
interconnect we are using there is a host in that chain and that host is
some piece of hardware that handles our interconnect.  Hosts have their
own set of resource requirements, concurrency issues, limitations, etc.  
Ignoring the concept of a host to emulate a spec ignores reality and makes
the job of actually working with these devices harder.  The reason the
current scsi core is a two layer abstraction is because that's the reality
of how the vast majority of this stuff is put together (there are a few
exceptions, tape autoloaders for example, but these are rare and well
known where as individual devices are far more common).

> Not anymore, you don't.
> 
> You queue at LU level, and control parameters
> 	- at LU level, for the device server itself (i.e. the thingy
> which executes scsi commands),
> 	- at Target level, (for target specific parameters),
> 	- at Portal level, for the service delivery subsystem (i.e.
> controls specific for SPI, FC, etc.).

Really, in the above list, just replace portal with host and you have what 
we are doing today.  By creating a separate struct target and putting the 
target specific params into it you aren't changing *what* we are doing, 
just *how* we are doing it (which I have no objection to).  By changing 
the name of host to portal, well, your just changing the name to match 
some document but without any real purpose.

However, what I would like to see is a service delivery subsystem specific 
set of routines in the scsi core.  For example, the new scsi eh code is 
mostly wasted on pretty much all the intelligent RAID controllers that act 
like scsi controllers (megaraid, serveraid, etc.) and a *much* simpler 
error recovery setup could be used on those controllers.  On the other 
hand, iscsi and fc both need a bit more in the way of error recovery 
intelligence than spi does.  So I could see using 3 different error 
recovery strategies depending on the interconnect type (I'm not sure where 
usb and ieee1394 would fit in here) and also due to interconnect 
differences I could see each of these same 3 groups of interconnects 
needing different default disk timeout parameters.  These different 
interconnects also offer totally different device scan capabilities.  SPI 
needs a manual "are you there?" scan, most fc/usb/ieee1394/intelligent 
raid controllers can all tell the scsi layer "here are my devices, set 
them up" and avoid manual scanning.  So, based upon interconnect in use 
and driver capabilities, I'd like to see the ability to select the right 
settings for a controller at controller init time.  To that extent, the 
"portal" abstraction has a use, but I still don't like the name.  No one 
goes out and buys a fiber channel portal, they go buy a fiber channel host 
adapter board or controller.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
