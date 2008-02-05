From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage & isd200.c
Date: Tue, 05 Feb 2008 10:41:31 +0200
Message-ID: <47A8213B.9050705@panasas.com>
References: <Pine.LNX.4.44L0.0802041500420.5186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0802041500420.5186-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 04 2008 at 22:05 +0200, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> On Sun, 3 Feb 2008, Matthew Dharm wrote:
> 
>> But, the modifications to usb_stor_access_xfer_buf() look good -- no
>> request from a sub-driver should be allowed to scribble into memory.  The
>> current code does make the implicit assumption that there is enough
>> storage, and will walk right off the end of the sg list if there isn't.
>>
>> I'm not sure I like the mods to usb_stor_set_xfer_buf().  Any place we set
>> a status that we know is going to be thrown away is an invitation for a
>> problem later if someone changes the code to preserve that status.  It's a
>> jack-in-the-box, waiting to spring open in our face later.  The limit check
>> (which mirrors the usb_stor_access_xfer_buf modification) and WARN_ON() are
>> probably good.
>>
>> In a strictly technical sense, the change to protocol.c are sufficient.
>> That is, they will prevent a serious error.  There is a justification tho
>> to fix all of the users of usb_stor_access_buf() to not attempt to use more
>> SCSI buffer than exists.
>>
>> My opinion is this:  Let's make the protocol.c mods (modulo my comments
>> about setting useless status bits) now.  Then, let's decide if we're going
>> to patch all the other users of the usb_stor_*_xfer_buf() functions as a
>> separate discussion.
> 
> I think the correct approach is to modify those routines so that they 
> will never overrun the s-g buffer (like Boaz has done), and _document_ 
> this behavior.  Then the callers can feel free to try and transfer as 
> much as they want, knowing that an overrun can't occur.  There won't 
> be any need for a WARN_ON or anything else.
> 
> However the interface to usb_stor_access_xfer_buf() will have to change
> slightly.  Right now if it sees that *sgptr is NULL, it assumes this
> means it should start at the beginning of the s-g buffer.  But with 
> Boaz's change, *sgptr == NULL means the transfer has reached the end of 
> the buffer.  So I'll have to go through and audit all the callers.
> 
> Alan Stern
> 
> -
No it does not, this as not changed. Please look again.
Note that this patch was tested and working. It is a bug
in v2.2.24 and it should be accepted already. One way or
the other.

Callers of usb_stor_access_xfer_buf() need not change.
Matthew Dharm should decide if he wants the WARN_ON in 
usb_stor_set_xfer_buf() or not and be done with it.

I have found and fixed the bug, but it is not a SCSI
related bug, and it is not do to any scsi changes. It
is a bug from the SG changes of early 2.6.24. Please
take it through the USB tree. Feel free to change it
the way you like it, and submit it.

Boaz
