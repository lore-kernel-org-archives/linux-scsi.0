From: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
Date: Thu, 19 Jun 2008 22:34:33 +0200
Message-ID: <485AC2D9.2060406@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de> <20080619185419.GN4392@parisc-linux.org> <485AB95E.5070609@s5r6.in-berlin.de> <20080619202226.GP4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080619202226.GP4392-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Cc: Pekka J Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dsd-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vegardno-6miFZF/5cTBuMpJDpNschA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jun 19, 2008 at 09:54:06PM +0200, Stefan Richter wrote:
>> When to say "I've finished scanning"? --- I think the answer is:  When
>> (a) probing of a configurable number of SCSI targets or logical units
>> was finished or (b) a configurable timeout occurs, whatever of the two
>> happens first.
...
> Yes, I do see the problem.  There's no way the SCSI core can know when
> a driver has finished scanning, so I've punted to the driver to set its
> own timeout here.

This can of course (and frequently is) implemented in userspace, but
requires an initrd.  I'm not up to speed how scsi_wait_scan is put to
use --- it can be used without initrd, can't it?

> I know that new devices really can show up at any
> time, but I think it's reasonable to say that if a machine is booted
> with the same configuration as last time, the drives should show up with
> the same names.

I know that is not what you meant here, but...:

They do show up with the same target identifiers and logical unit
identifiers.  The SCSI core doesn't pass the identifiers through to
userland though.  (Couldn't resist to go off-subject.  Sorry.)
-- 
Stefan Richter
-=====-==--- -==- =--==
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
