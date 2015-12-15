From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Tue, 15 Dec 2015 10:16:02 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1512151013320.1891-100000@iolanthe.rowland.org>
References: <1450179271.17387.19.camel@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450179271.17387.19.camel-IBi9RG/b67k@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Jun Itou <itou_jun-6LX5ZuzTTw53+QwDJ9on6Q@public.gmane.org>, Markus Rathgeb <maggu2810-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt <vickm78-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Dan Williams <dcbw-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, brad <bradhaack-97jfqw80gc5zbRFIqnYvSA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 15 Dec 2015, Oliver Neukum wrote:

> On Thu, 2015-12-03 at 13:36 -0500, Alan Stern wrote:
> > This is an old problem, but it was never resolved and it still affects
> > people (Bugzilla #89511).  In short, there are USB-(S)ATA bridges that
> > claim to be write-back but don't support the SYNCHRONIZE CACHE
> > command.  
> > This causes errors when filesystems try to flush data out to the disk.
> 
> OK, maybe this is a stupid idea, but could we test the command as we
> enumerate the slave and store the result?

Maybe, although doing so within usb-storage would be kind of difficult
-- that driver is set up to forward requests from the SCSI layer, not
to generate requests of its own.  Besides, usb-storage doesn't know 
anything about write-back vs. write-through; only sd does.  I suppose 
sd could perform that test.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
