From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Fri, 22 Aug 2014 08:05:08 -0700
Message-ID: <20140822150508.GA1321@infradead.org>
References: <20140821215744.GA29651@infradead.org>
 <Pine.LNX.4.44L0.1408221044450.967-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1408221044450.967-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Tiziano Bacocco <tiziano.bacocco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 22, 2014 at 10:53:42AM -0400, Alan Stern wrote:
> Good idea.  An enhanced patch is below.  If I can get a Tested-By: from
> Tiziano and one or two Acked-By: responses, I'll submit this for the
> current and stable kernels.
> 
> Sending the initial INQUIRY command to LUNs larger than 0 involves a
> chicken-and-egg problem -- we don't know whether to fill in the LUN
> bits in the command until we know the SCSI level, and we don't know the
> SCSI level until the INQUIRY response is received.  The solution we 
> have been using is to store the most recently discovered level in the 
> target structure, and use it as a default.  If probing starts with LUN 
> 0, and if all the LUNs have similar levels, this ought to work.
> 
> Except for one thing: The code does store the default level in the
> scsi_target, but forgets to copy it back into each newly allocated
> scsi_device!  I added a line to do that into the patch.

Looks good to me,

Acked-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Do you want to queue this up in the USB tree?  From the looks of what I
have on my plate so far it seems like we could avoid conflicts with it
in the SCSI tree.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
