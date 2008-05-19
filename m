From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Mon, 19 May 2008 12:16:41 -0600
Message-ID: <20080519181641.GE2638@parisc-linux.org>
References: <Pine.LNX.4.44L0.0805191106270.15266-100000@iolanthe.rowland.org> <4831A60A.5010308@panasas.com> <alpine.LFD.1.10.0805190929170.32253@woody.linux-foundation.org> <4831B2E2.8030700@panasas.com> <alpine.LFD.1.10.0805191026120.32253@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805191026120.32253-5CScLwifNT1QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Maciej Rutecki <maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 19, 2008 at 10:27:17AM -0700, Linus Torvalds wrote:
> On Mon, 19 May 2008, Boaz Harrosh wrote:
> > 
> > Sure, inspecting other places that emulate MODE_SENSE, (And inspecting the scsi
> > spec) all zeros is a very good scsi response. Alan do you want to send a fix for all
> > places that initiate a MODE_SENSE command, specifically at
> > scsi_scan.c::scsi_unlock_floptical() ? (Some other places do)
> 
> I was actualyl more thinking that the safest thing to do would be to just 
> pre-clear the sense buffer. Then, if some driver doesn't fill it 
> correctly, big deal..
> 
> It's not like pre-clearing the bugger is a performance issue.

Actually, I think it might be.  I don't have any hard evidence for this
right now, but I'll let you know if I do.  There's certainly a lot of L2
cache misses in the scsi command submission path.

I'm not arguing that speed should trump performance, just we might
want to not clear the sense buffer if we know we have a non-USB device.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
