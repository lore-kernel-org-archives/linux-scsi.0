From: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Mon, 19 Dec 2011 11:12:25 -0500
Message-ID: <20111219161225.GO14291@linux.intel.com>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
 <20111214225331.GA5508@xanatos>
 <4EE9B375.4020606@linutronix.de>
 <20111215211201.GA6482@xanatos>
 <20111216144724.GC19563@linutronix.de>
 <20111216201236.GE19563@linutronix.de>
 <20111216203146.GN14291@linux.intel.com>
 <20111216204241.GA30915@linutronix.de>
 <20111216213628.GA5509@xanatos>
 <1324072059.10429.27.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1324072059.10429.27.camel@dabdike>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 16, 2011 at 10:47:39PM +0100, James Bottomley wrote:
> Well, no, what you want to do is use a shared tag map at the block
> level.  That will manage a joint tag space for N queues without your
> having to partition it arbitrarily.  see scsi_host_find_tag() and
> scsi_init_shared_tag_map().

By the way, the same verbiage about tags being shared across LUNs is also
present in the SAS spec (and various other specs last time I looked,
which wasn't recently).  We should probably make this the default in
the SCSI core.

I suspect it hasn't bitten us because there are so few multi-LUN devices
out there, and it's only a "May" check, not "Must" check.  But Linux is
technically in violation of the SAS spec by sending two commands to the
same target with the same tag.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
