From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [RFC] fix our current target reap infrastructure.
Date: Sun, 15 Dec 2013 21:44:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312152134580.3175-100000@netrider.rowland.org>
References: <1387145674.2284.60.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387145674.2284.60.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 15 Dec 2013, James Bottomley wrote:

> No, I was thinking of the two thread scan bug (i.e. two scan threads)
> not one scan and one remove, which is a bug in the old code.  This is a
> race between put and get when the kref is incremented from zero (an
> illegal operation which triggers a warn on).
> 
> The way to mediate this is to check for the kref already being zero
> condition, like below.

Yes, that seems reasonable.  Consider now: Having done this, to what
extent do starget->reap_ref and starget->state really need to be
protected by the host_lock?  Maybe only the linked lists require
protection.  (I haven't checked.)

Can you post a single, combined patch incorporating all your proposed
changes?  It's little hard to review them in pieces...

Alan Stern

P.S.: Would you agree that the phrase "pretty astonishing cockup" did
indeed turn out to be appropriate?  :-)

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
