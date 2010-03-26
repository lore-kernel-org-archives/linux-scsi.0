From: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 26 Mar 2010 17:30:02 -0400
Message-ID: <4BAD275A.7050903@interlog.com>
References: <Pine.LNX.4.44L0.1003261705340.23253-100000@netrider.rowland.org>
Reply-To: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1003261705340.23253-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
> On Fri, 26 Mar 2010, Sarah Sharp wrote:
> 
>> I think the amount of information is fine, but I'm not sure why the
>> device would respond with a stall to this particular command, so I'm
>> CC'ing the USB storage list and SCSI list.  Does anyone know what the
>> third command is?  The USB storage driver reports it as an "unknown
>> command".  I can see from scsi.h that 0x85 is the code for ATA_16, but
>> I'm not sure what that command actually does.
> 
> I have never heard of any kernel driver issuing either the BLANK 
> command or an ATA_16 pass-through command.  It almost certainly is a 
> user program doing this, but I don't know which one.
> 
> Booting into a minimal userspace environment (for example, with 
> init=/bin/bash) might prove this.
> 
> No doubt the reason the drive fails to respond is because it can't 
> handle these commands and gets fatally confused.

The ATA commands seem to be:
    IDENTIFY DEVICE  (via the ATA_12 tunnel)
    SET FEATURES     (via the ATA_16 tunnel)
    IDENTIFY DEVICE  (via the ATA_16 tunnel)

The last one fails but that could be caused by
the second last one. Doesn't look like smartd.
My money would be on udev.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
