From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Mon, 19 May 2008 09:36:56 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0805190929170.32253@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0805191106270.15266-100000@iolanthe.rowland.org> <4831A60A.5010308@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4831A60A.5010308-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Maciej Rutecki <maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



On Mon, 19 May 2008, Boaz Harrosh wrote:

> Alan Stern wrote:
> > 
> > Yes, it never worked properly.  But now it fails in a bad way whereas 
> > before it failed in a benign way.
> 
> You do realize that, that was pure lock to have a zero'ed buffer.

Umm. Maybe it SHOULD NOT HAVE BEEN!

The thing is, if we can get partial results back, we really *should* 
either error out, or we should have at least cleared the buffer (either 
beforehand or when seeing the partial result). Returning a buffer with the 
old random contents is a bug.

And if clearing the buffer not only avoids any security holes and possible 
undefined behavior, but _also_ ends up fixing the write protect sense 
issue, all the better!

		Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
