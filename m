From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] USB enclosures seem to require read(16) with >2TB drives
Date: Mon, 12 Nov 2012 11:06:47 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1211121056070.26926-100000@netrider.rowland.org>
References: <50A1173D.8090603@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50A1173D.8090603-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Jason J. Herne" <public-hernejj-Re5JQEeQqe8AvxtiuMwx3w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 12 Nov 2012, Paolo Bonzini wrote:

> Il 12/11/2012 16:10, James Bottomley ha scritto:
> >> Actually it only turns it on for large capacity drives, as said in the
> >> comment.  sdp->force_read_16 only matters for >2TB drives: 
> > 
> > If you follow the discussion, we'll need to turn it on for some drives
> > regardless of size.
> 
> Even if the two reasons to use r/w(16) commands were setting the same
> flag, it would be handled in a separate patch; it doesn't really make
> sense to complicate the code now when a one-liner does it.
> 
> The proposed change is not part of the Oct 31st draft available on
> t10.org, for what we know the discussion could end up in nothing.

There's a simple way to do what everybody wants.  Add a "use_16_for_rw"  
flag with the understanding that it overrides use_10_for_rw, and set
this flag in sd_read_capacity() if the actual capacity is >= 2^32
blocks (as opposed to 2^41 bytes).  Similarly, clear the flag if the
actual capacity is smaller -- a device with removable media might 
require this, in theory.

Then the test in sd_prep_fn() becomes

	if (sdp->use_16_for_rw) {

rather than

	if (block > 0xffffffff) {

which on 32-bit architectures is a simpler test.  If T10 decides to
deprecate the 10-byte commands then a second patch can set the new flag
(and avoid clearing it) under the appropriate circumstances.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
