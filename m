From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/3] USB Storage: Make driver less chatty when it finds
 a new device
Date: Sun, 20 Sep 2009 22:09:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0909202202280.15304-100000@netrider.rowland.org>
References: <20090920225758.GE3690@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:56554 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751002AbZIUCJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Sep 2009 22:09:38 -0400
In-Reply-To: <20090920225758.GE3690@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Sun, 20 Sep 2009, Matthew Wilcox wrote:

> From: Matthew Wilcox <willy@linux.intel.com>
> 
> Use dev_dbg() instead of an unconditional printk(KERN_DEBUG).  This has
> two benefits; one is that it identifies the USB device which the messages
> related to, and the other is that the messages won't be produced unless
> debug is turned on.
> 
> Enable the debug messages when CONFIG_USB_STORAGE_DEBUG is set.

> -	printk(KERN_DEBUG
> -		"usb-storage: device found at %d\n", us->pusb_dev->devnum);
> +	dev_dbg(&us->pusb_dev->dev, "usb-storage device found\n");
>  
>  	set_freezable();
>  	/* Wait for the timeout to expire or for a disconnect */
>  	if (delay_use > 0) {
> -		printk(KERN_DEBUG "usb-storage: waiting for device "
> -				"to settle before scanning\n");
> +		dev_dbg(&us->pusb_dev->dev, "usb-storage: waiting for device "
> +			"to settle before scanning\n");
>  		wait_event_freezable_timeout(us->delay_wait,
>  				test_bit(US_FLIDX_DONT_SCAN, &us->dflags),
>  				delay_use * HZ);
> @@ -832,7 +835,7 @@ static int usb_stor_scan_thread(void * __us)
>  			mutex_unlock(&us->dev_mutex);
>  		}
>  		scsi_scan_host(us_to_host(us));
> -		printk(KERN_DEBUG "usb-storage: device scan complete\n");
> +		dev_dbg(&us->pusb_dev->dev, "usb-storage scan complete\n");
>  
>  		/* Should we unbind if no devices were detected? */
>  	}

Each of these dev_dbg() lines should refer to pusb_intf instead of
pusb_dev.  See the existing code at the end of adjust_quirks().  Once
this change is made, the second dev_dbg() line won't need to specify
"usb-storage:" at the start of the message.

With those changes in place,

	Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

