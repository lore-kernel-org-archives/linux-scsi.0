From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Fri, 2 Aug 2013 10:18:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1308021015200.1176-100000@iolanthe.rowland.org>
References: <1375452665.2138.17.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375452665.2138.17.camel-B2T3B9s34ElbnMAlSieJcQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux PM List <linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, hare-l3A5Bk7waGM@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2 Aug 2013, Oliver Neukum wrote:

> On Fri, 2013-08-02 at 09:54 -0400, Alan Stern wrote:
> > On Fri, 2 Aug 2013, Oliver Neukum wrote:
> > 
> > > On Thu, 2013-08-01 at 11:53 -0400, Alan Stern wrote:
> > > > On Thu, 1 Aug 2013, Oliver Neukum wrote:
> > > > 
> > > > > On Wed, 2013-07-31 at 11:13 -0400, Alan Stern wrote:
> > > > > 
> > > > > > More importantly, if we already know that the medium is not present or
> > > > > > has been changed since it was last used, then there's no reason to call
> > > > > > sd_sync_cache() at all.
> > > > > 
> > > > > Like this?
> > > > 
> > > > Yes, I like this a lot better, except I would put the test for 
> > > > !sdkp->media_present in sd_suspend_common() -- no need to print the
> > > 
> > > But your observation that it makes no sense while no medium is present
> > > is valid whatever be the reason for wanting to flush.
> > 
> > So do the test in both places.
> 
> Code duplication for what reasons?

Like I said before, to avoid printing a misleading line in the kernel 
log.

If you prefer, just get rid of the log message.  Or make it KERN_DEBUG 
instead of KERN_NOTICE, along with the "Stopping disk" message.  Those 
two things might get pretty annoying when people start using 
block-layer runtime PM.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
