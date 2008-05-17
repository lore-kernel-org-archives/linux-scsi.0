From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Sat, 17 May 2008 09:49:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0805170933530.22979-100000@netrider.rowland.org>
References: <8db1092f0805162359k2def1738s91cc78d48bea2581@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8db1092f0805162359k2def1738s91cc78d48bea2581-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maciej Rutecki <maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Summary: 2.6.26-rc2 doesn't detect a USB drive's write-protect setting 
correctly.

On Sat, 17 May 2008, Maciej Rutecki wrote:

> 2.6.25.4 (works fine):
> http://unixy.pl/maciek/download/kernel/2.6.25.4/syslog_debug.txt
> http://unixy.pl/maciek/download/kernel/2.6.25.4/usbmon.txt
> 
> 2.6.26-rc2 ("write protect is on" problem; can't mount device):
> http://unixy.pl/maciek/download/kernel/2.6.26-rc2/syslog_debug.txt
> http://unixy.pl/maciek/download/kernel/2.6.26-rc2/usbmon.txt

I'm not sure exactly what changed to cause this regression, but the 
problem lies in the SCSI layer, not the USB layer.

The logs show that in response to the 192-byte MODE SENSE command (used
to read the write-protect status), the device sends back no data, good
status, and Residue = 192.  The SCSI core ignores the Residue and
thinks that the old left-over data in the buffer (in this case left
over from the READ CAPACITY command) actually indicates the
write-protect status -- which it obviously doesn't.

Boaz, is scsi_mode_sense() the right place to check for this sort of 
thing?  It probably should be treated the same as an Illegal Request 
error.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
