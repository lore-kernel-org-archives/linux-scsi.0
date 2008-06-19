From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Date: Thu, 19 Jun 2008 12:54:19 -0600
Message-ID: <20080619185419.GN4392@parisc-linux.org>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <485AA7EA.6080105-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Cc: Pekka J Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dsd-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vegardno-6miFZF/5cTBuMpJDpNschA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 19, 2008 at 08:39:38PM +0200, Stefan Richter wrote:
> The problem is AFAIU not exactly how many Scsi_Host instances (initiator 
> port representations, or something remotely related to that) are 
> instantiated, but rather _when_ they are instantiated.  On multi 
> protocol buses or networks like USB and FireWire, it makes sense to 
> create the SCSI initiator port representation when we discovered that 
> there are actually SCSI targets on the bus or network.

I'm not convinced of that.  Why shouldn't we create one scsi host for
all USB scsi devices?  I know that today there's a certain amount of
per-device state stored in the scsi_host, but that should be fixable.

> scsi_scan's API is geared towards drivers which create one or more 
> initiator port representations right up front before going on target 
> discovery, right?

Today, yes.  The mail that I just pinged described a way to enhance the
API -- letting you tell scsi "I've started scanning, save me a place in
the queue" and "I've finished scanning, hook me up".

The advantage to this is that you can spend a lot more time waiting for
devices without increasing boot time significantly, since you wait while
the rest of the system initialises.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
