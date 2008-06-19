From: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
Date: Thu, 19 Jun 2008 21:54:06 +0200
Message-ID: <485AB95E.5070609@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de> <20080619185419.GN4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080619185419.GN4392-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Cc: Pekka J Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dsd-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vegardno-6miFZF/5cTBuMpJDpNschA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jun 19, 2008 at 08:39:38PM +0200, Stefan Richter wrote:
>> The problem is AFAIU not exactly how many Scsi_Host instances (initiator 
>> port representations, or something remotely related to that) are 
>> instantiated, but rather _when_ they are instantiated.  On multi 
>> protocol buses or networks like USB and FireWire, it makes sense to 
>> create the SCSI initiator port representation when we discovered that 
>> there are actually SCSI targets on the bus or network.
> 
> I'm not convinced of that.

Drivers like usb-storage and sbp2 are high-level drivers (protocol
drivers) on top of driver stacks.  They a priori talk to struct device
instances which represent subunits on "external" devices; they don't
have much business with the local host controller device.  For them,
"SCSI initiator port" is a rather hazy and, in the implementation,
uninteresting concept.  (That's how it is with sbp2; I'm only guessing
how it is with usb-storage.)

However, there are several ways to accomplish the same thing in the
implementation.  I heard there were more constraints under Linux 2.4;
some current implementation details may just be legacy.

> Why shouldn't we create one scsi host for
> all USB scsi devices?

Or one for each USB HCD.

I thought about that for FireWire but never started to actually try it
out.  Parent-child relationships of struct devices would be different
from what we have today.

[...]
> The mail that I just pinged described a way to enhance the
> API -- letting you tell scsi "I've started scanning, save me a place in
> the queue" and "I've finished scanning, hook me up".

When would be the right time to say "I've started scanning"?  SCSI
transport driver initialization?  Or end of USB/FireWire/... HCD
registration?

When to say "I've finished scanning"? --- I think the answer is:  When
(a) probing of a configurable number of SCSI targets or logical units
was finished or (b) a configurable timeout occurs, whatever of the two
happens first.

(Explanation, if one is necessary:  SCSI targets may pop out of the
woods any time; it is impossible to say "from this moment on there won't
show up any new ones anymore".  This is just as true for cold boot and
warm boot as it is for subsequent operation.)
-- 
Stefan Richter
-=====-==--- -==- =--==
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
