From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Fri, 14 Mar 2008 10:46:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803141036150.4478-100000@iolanthe.rowland.org>
References: <20080314183434J.tomof@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080314183434J.tomof-HInyCGIudOg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: FUJITA Tomonori <tomof-HInyCGIudOg@public.gmane.org>
Cc: fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dougg-c4O3jRSCrQ+sTnJN9+BGXg@public.gmane.org, Geert.Uytterhoeven-osDt5Q4Chk1BDgjK7y7TUQ@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mark_Salyzyn-ugMvIWC9OiRBDgjK7y7TUQ@public.gmane.org, ed.lin-XjgVRL3kVzRBDgjK7y7TUQ@public.gmane.org, linuxraid-6mNVq6Owofk@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.orgfujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 14 Mar 2008, FUJITA Tomonori wrote:

> > If nents doesn't change then for_each_sg() won't work right.  There 
> > could be an alternative macro:
> 
> Oops, I thought that for_each_sg is defined like:
> 
> #define for_each_sg(sglist, sg, nr, __i)	\
> 	for (__i = 0, sg = (sglist); __i < (nr) && sg; __i++, sg = sg_next(sg))
> 
> 
> > /*
> >  * Loop over each sg element, stopping at the end of the chain
> >  */
> > #define for_each_sg_all(sglist, sg, __i)	\
> > 	for (__i = 0, sg = (sglist); sg; __i++, sg = sg_next(sg))
> > 
> > If you added this macro to include/linux/scatterlist.h and used it
> > instead of for_each_sg() then you can get rid of nents entirely.  
> > However I'm not sure whether this would be safe.  Do people sometimes 
> > use a subset of the entries in a scatterlist?
> 
> IIRC, some drivers do that (though they might use sg_next).

But will usb-storage ever receive a scatterlist like that?  For 
example, if there are three 4096-byte entries in the list, but the 
transfer length is 8192 and nents is 2, then there could be a problem.

(This could happen if some software layer preallocated an sg chain and
used it over and over again, each time setting nents to whatever value
was needed for a particular transfer.)

> I don't think that we add a new macro just for this function. We could
> change for_each_sg in the above way or we could just do in
> usb_stor_access_xfer_buf
> 
> for (i = 0, sg = *sgl; i < nents && sg; i++, sg = sg_next(sg))

This wouldn't be safe in the example I just mentioned if the
usb-storage driver tried to do three transfers, each of 4096 bytes.  
All three would succeed, but in fact the third call shouldn't transfer
any data.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
