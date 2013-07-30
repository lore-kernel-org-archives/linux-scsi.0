From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Tue, 30 Jul 2013 13:00:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1307301252590.1105-100000@iolanthe.rowland.org>
References: <1375197142.14458.4.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375197142.14458.4.camel-B2T3B9s34ElbnMAlSieJcQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux PM List <linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, hare-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 30 Jul 2013, Oliver Neukum wrote:

> On Mon, 2013-07-29 at 10:21 -0400, Alan Stern wrote:
> > On Mon, 29 Jul 2013, Oliver Neukum wrote:
> > 
> > > On Fri, 2013-07-26 at 16:31 -0400, Alan Stern wrote:
> > > 
> > > > In addition to my earlier comment, the patch below should be applied.  
> > > > It will fix your immediate problem, although not in the best way.
> > > 
> > > Alan,
> > > 
> > > I think your diagnosis is correct, but not the fix.
> > > This is run even in the runtime case. We might lose
> > > data if the flush is not done.
> > 
> > Actually no, the scsi_bus_suspend_common() routine does not run during 
> > runtime PM.  It gets called only from scsi_bus_suspend(), 
> > scsi_bus_freeze(), and scsi_bus_poweroff(), which are all part of 
> > system sleep.
> 
> Well yes, but you handled only the system case that way. The runtime
> case is still affected.

That's why I said the patch would fix the immediate problem but it
wasn't the best solution.  You do agree that the patch is correct, as
far as it goes?

If you would like to handle the problems in sd.c concerning the
sync-cache and spin-down stuff, that will be fine with me.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
