From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/3] usb: storage: adjust module reference for scsi host
Date: Mon, 5 Jan 2015 10:27:08 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1501051021370.1485-100000@iolanthe.rowland.org>
References: <1420468479-4508-4-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49916 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753607AbbAEP1J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2015 10:27:09 -0500
In-Reply-To: <1420468479-4508-4-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Mon, 5 Jan 2015, Akinobu Mita wrote:

> While accessing a unusual usb storage (ums-alauda, ums-cypress, ...),
> the module reference count is not incremented.  Because these drivers
> allocate scsi hosts with usb_stor_host_template defined in usb-storage
> module.  So these drivers always can be unloaded.
> 
> This fixes it by adjusting module reference after scsi host allocation.

> diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
> index 62c2d9d..77660d6 100644
> --- a/drivers/usb/storage/alauda.c
> +++ b/drivers/usb/storage/alauda.c
> @@ -1242,6 +1242,7 @@ static int alauda_probe(struct usb_interface *intf,
>  	us->transport = alauda_transport;
>  	us->transport_reset = usb_stor_Bulk_reset;
>  	us->max_lun = 1;
> +	us_to_host(us)->module = THIS_MODULE;
>  
>  	result = usb_stor_probe2(us);
>  	return result;

... etc.

An easier and more foolproof approach would be to change
usb_store_probe2 to take an extra argument for the owner:

int _usb_stor_probe2(struct us_data *us, struct module *owner)
...
	us_to_host(us)->module = owner;
...

Then in usb.h:

extern int _usb_stor_probe2(struct us_data *us, struct module *owner);
#define usb_stor_probe2(us)	_usb_stor_probe2(us, THIS_MODULE)

This pattern is already used in several other places in the kernel.

Alan Stern

