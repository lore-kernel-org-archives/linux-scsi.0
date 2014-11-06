From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Large disk drives
Date: Thu, 06 Nov 2014 11:30:14 +0100
Message-ID: <1415269814.29907.19.camel@jarvis.quadriga.com>
References: <1415203668.13212.2.camel@jarvis>
	 <Pine.LNX.4.44L0.1411051130470.1531-100000@iolanthe.rowland.org>
	 <20141105193045.GA13265@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141105193045.GA13265-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, "Dale R. Worley" <worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-11-05 at 11:30 -0800, Christoph Hellwig wrote:
> On Wed, Nov 05, 2014 at 11:34:11AM -0500, Alan Stern wrote:
> > > Sorry, meant to.  In principle I'm OK with this as the lever for the
> > > hack (largely because it means we don't need to do anything) but will
> > > the distributions support it?
> > 
> > While I can't speak for the distributions, it's reasonable to assume 
> > that if something becomes part of the upstream kernel then they will 
> > include it.
> 
> Btw, we do have precedence for looking at partition tables from SCSI
> code with scsi_partsize(), so the layering violation of looking at
> EFI labels for disks sizes wouldn't be something entirely new even
> if we did it in kernel space.

We really don't want to make the decision within the kernel of whether
we believe the partition size or the disk capacity.   For these disk
problems we need it to be the former, but if we choose that always,
we'll get weird results on mispartitioned devices.

The usual rule is no policy in the kernel and which to choose is policy,
so just export the knob (as Alan's patch does) and then let userspace
decide.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
