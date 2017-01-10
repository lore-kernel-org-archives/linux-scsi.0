From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Tue, 10 Jan 2017 14:12:25 -0800
Message-ID: <1484086345.2518.9.camel@HansenPartnership.com>
References: <Pine.LNX.4.44L0.1701101551591.2462-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1701101551591.2462-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Dainius =?UTF-8?Q?Masili=C5=ABnas?= <pastas4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-01-10 at 16:00 -0500, Alan Stern wrote:
> In theory, I suppose we could change the kernel so that it would 
> default to READ CAPACITY(16) for devices that report a SCSI level >= 
> 3, or something along those lines.  In general we hesitate to make
> changes of this sort, because they almost always end up breaking 
> _some_ devices -- and if that happens then the change is reverted, 
> with no exceptions.  Linus has a very strict rule about not breaking 
> working systems.

You shouldn't have to change anything: it already does (otherwise how
else would we detect physical exponent for proper SCSI devices) see
sd.c:sd_try_rc16_first().  It always returns false for USB because you
set sdev->try_rc_10_first

James

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
