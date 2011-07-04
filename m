From: Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Mon, 4 Jul 2011 13:27:27 +0200
Message-ID: <20110704112727.GA2557@osiris.boeblingen.de.ibm.com>
References: <1309609482.2554.8.camel@mulgrave>
 <Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107021320180.14703-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel development list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 02, 2011 at 01:37:59PM -0400, Alan Stern wrote:
> The second bug, which hit me but apparently not any of you, is that the 
> request_queue's elevator gets deallocated while it is still in use.  
> That's because __scsi_remove_device() calls scsi_free_queue(), which 
> does blk_cleanup_queue(), which calls elevator_exit(), even though the 
> device file is still open and more requests will be submitted when the 
> file is closed.
> 
> I'm not sure of the right fix for this.  One possibility is to move the 
> scsi_free_queue() call to scsi_device_dev_release_usercontext().  Or 
> maybe the elevator_exit() call should be moved to blk_release_queue().
> 
> Also, I have no idea why this shows up with USB drives but not other 
> SCSI transports.  A fluke of timing?

FWIW, I reported a bug where the request_queue's elevator got deallocated
while it was still in use (fc transport with device hotplug):

http://www.spinics.net/lists/linux-scsi/msg52879.html
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
