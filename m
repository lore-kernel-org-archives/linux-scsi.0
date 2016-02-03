From: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Subject: Re: [usb-storage] Re: [PATCH 04/14] uas: lock the abort handler
Date: Wed, 03 Feb 2016 15:28:56 +0100
Message-ID: <1454509736.1930.9.camel@suse.com>
References: <Pine.LNX.4.44L0.1601261026301.2062-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1601261026301.2062-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-01-26 at 10:28 -0500, Alan Stern wrote:
> On Tue, 26 Jan 2016, Oliver Neukum wrote:

> > That is problematic. The ABORT_TMF does need IO for which we need
> > to wait. And if we just submit and pretend the abort worked, the tag
> > will be reused.
> > Perhaps we could drop the spinlock. I think it is time to talk to
> > the SCSI people.
> 
> The abort handler doesn't have to wait for the command to terminate.  
> It merely has to initiate an abort and return.  The SCSI layer gets 
> notified via the usual mechanism when the command eventually finishes, 
> whether it was successful or not.

This is stange. I don't see how we can guarantee a command completion
if eh_abort_handler() has sent the TMF.
It was my understanding that returning from eh_abort_handler()
means that a tag is considered free again and will be reused.
Could you clarify?

	Regards
		Oliver



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
