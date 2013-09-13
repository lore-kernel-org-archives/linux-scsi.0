From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Fri, 13 Sep 2013 06:37:28 -0700
Message-ID: <CALCETrWQuJs_7-VoOVaZQMCdZhj2VjQCaH5NWie=h4NSAM9VSg@mail.gmail.com>
References: <1375452665.2138.17.camel@linux-fkkt.site> <Pine.LNX.4.44L0.1308021015200.1176-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1308021015200.1176-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux PM List <linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

What's the status of this?  Do I still need to test it?

I won't have access to the Nook that triggered it the first time for a
couple weeks, but I could try to find another device like that.

--Andy

On Fri, Aug 2, 2013 at 7:18 AM, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> On Fri, 2 Aug 2013, Oliver Neukum wrote:
>
>> On Fri, 2013-08-02 at 09:54 -0400, Alan Stern wrote:
>> > On Fri, 2 Aug 2013, Oliver Neukum wrote:
>> >
>> > > On Thu, 2013-08-01 at 11:53 -0400, Alan Stern wrote:
>> > > > On Thu, 1 Aug 2013, Oliver Neukum wrote:
>> > > >
>> > > > > On Wed, 2013-07-31 at 11:13 -0400, Alan Stern wrote:
>> > > > >
>> > > > > > More importantly, if we already know that the medium is not present or
>> > > > > > has been changed since it was last used, then there's no reason to call
>> > > > > > sd_sync_cache() at all.
>> > > > >
>> > > > > Like this?
>> > > >
>> > > > Yes, I like this a lot better, except I would put the test for
>> > > > !sdkp->media_present in sd_suspend_common() -- no need to print the
>> > >
>> > > But your observation that it makes no sense while no medium is present
>> > > is valid whatever be the reason for wanting to flush.
>> >
>> > So do the test in both places.
>>
>> Code duplication for what reasons?
>
> Like I said before, to avoid printing a misleading line in the kernel
> log.
>
> If you prefer, just get rid of the log message.  Or make it KERN_DEBUG
> instead of KERN_NOTICE, along with the "Stopping disk" message.  Those
> two things might get pretty annoying when people start using
> block-layer runtime PM.
>
> Alan Stern
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
