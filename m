From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] isd200: Use scsi_get_cmnd for the extra translation
	command
Date: Thu, 13 Mar 2008 11:47:57 -0500
Message-ID: <1205426877.2893.14.camel@localhost.localdomain>
References: <47D7F397.4070903@panasas.com>
	 <1205341209.2941.116.camel@localhost.localdomain>
	 <47D8128D.3050405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47D8128D.3050405-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-03-12 at 19:27 +0200, Boaz Harrosh wrote:
> On Wed, Mar 12 2008 at 19:00 +0200, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > On Wed, 2008-03-12 at 17:15 +0200, Boaz Harrosh wrote:
> >> James
> >> please comment on the use of DID_REQUEUE as return status for 
> >> the command in case of failure to allocate the extra command the first
> >> time.
> > 
> > I'm afraid it won't work.  If you get a NULL return from
> > scsi_get_command, it means that the command you already have was likely
> > taken from the host free_list.  If that command is in the memory
> > clearing writeout path and we don't have any returning commands to
> > replace the free_list, the system is now deadlocked.
> > 
> > James
> > 
> 
> I'm not sure you are right. Please bear in mind that for isd200 an host
> has exactly one device. Now this *very first command* is some kind of
> INQUIRY in the discovery process, so it cannot be mounted for SWAP as yet.
> so it cannot be in the "clearing writeout path". Any kind of error on this
> first command will just result in an "empty" device, No? 

Not with DID_REQUEUE, it won't: it will go round until the command times
out, which is not too long, but unnecessary.

> I guess a newly mounted device on a memory starved system has lots of places 
> to fail before and after this point in time.

The basic problem, I suppose is that the whole structure is wrong.  The
only reason you try this strange method of allocation is because there's
no way to pull a command off the relevant pool without setting up the
host.  Export such a method and we can do the allocation at start of day
where it should be done.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
