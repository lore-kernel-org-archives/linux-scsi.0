From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Mon, 25 Aug 2014 16:12:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408251545580.1385-100000@iolanthe.rowland.org>
References: <1408995547.3629.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408995547.3629.7.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Tiziano Bacocco <tiziano.bacocco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 25 Aug 2014, James Bottomley wrote:

> On Mon, 2014-08-25 at 10:44 -0400, Alan Stern wrote:
> 
> > James, can you explain how the INQUIRY command in scsi_probe_lun()  
> > managed to work back in the days when multi-lun SCSI-2 devices were
> > common?  sdev->scsi_level doesn't get set when sdev is allocated, so it
> > initially contains 0, so the LUN bits won't get filled in when the
> > first INQUIRY command is sent.  Then how could the target know which
> > logical unit the INQUIRY was meant for?
> 
> Best guess, some patches over the course of time altered the way we do
> this and no-one noticed.  I think it was probably the introduction of
> the unknown SCSI data level that caused the breakage.

Heh.  The change was made by commit 4d7db04a7a69 ([SCSI] add
SCSI_UNKNOWN and LUN transfer limit restrictions) back in 2006 -- the
2.6.17 kernel.  If nobody has complained in all this time then it's
probably not worth changing.

> Historically, the LUN in CMD bits is left over from SCSI-1; it was
> incorporated into SCSI-2 for backward compatibility (even though SCSI-2
> moved the LUN specification to the identify message).  In SCSI-3 and
> beyond, those bits were obsoleted and transports took sole
> responsibility for LUN handling.  I'm fairly certain all the SCSI-1
> devices relying on this behaviour have long ago migrated to the great
> data centre in the sky.
> 
> Alan's fix looks reasonable because we probe LUN 0 first (for SCSI-1 and
> 2 which has parallel scanning), which is why it doesn't matter (the bits
> are set to zero) and once we have LUN 0 we propagate the data to the
> target and make it the basis for future checks.  I'd like to see a
> comment explaining this in the code, though ...

If you think it would be a good idea, I could put it into a separate 
patch with an explanatory comment.  At the moment, I'm inclined to 
forget about it.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
