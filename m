From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Mon, 19 May 2008 15:17:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0805191514300.2111-100000@iolanthe.rowland.org>
References: <4831B2E2.8030700@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4831B2E2.8030700-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Maciej Rutecki <maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 19 May 2008, Boaz Harrosh wrote:

> Sure, inspecting other places that emulate MODE_SENSE, (And inspecting the scsi
> spec) all zeros is a very good scsi response. Alan do you want to send a fix for all
> places that initiate a MODE_SENSE command, specifically at
> scsi_scan.c::scsi_unlock_floptical() ? (Some other places do)

I can't send such a fix because at these places the residue information 
has already been lost.  The fix needs to be made lower down.


Besides, everybody seems to be missing an important point.

MODE SENSE is just one example of a command for which a device might
return less data than the host expected.  In principle the same thing
could happen with _any_ command.  The host should be prepared for this
and should be able to handle it correctly.  And the host shouldn't
blindly assume that devices will slavishly follow the letter of the
SCSI spec.

We need something much more thorough than just fiddling with
scsi_mode_sense().  One possibility would be to pass a
minimum-response-length argument to scsi_execute_req().  But even that
wouldn't catch all the code paths where this sort of thing could  
happen (although it probably would catch most of them).

This needs someone who is more familiar than I am with the operation of
the SCSI core.
  
Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
