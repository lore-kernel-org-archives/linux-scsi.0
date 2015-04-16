From: Steve Bangert <sbangert-/1bC63wxbnBWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/3] uas: Allow uas_use_uas_driver to return usb-storage
 flags
Date: Thu, 16 Apr 2015 07:05:17 -0700
Message-ID: <1429193117.2742.4.camel@frontier.com>
References: <1429186634-6184-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429186634-6184-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-04-16 at 14:17 +0200, Hans de Goede wrote:
> uas_use_uas_driver may set some US_FL_foo flags during detection, currently
> these are stored in a local variable and then throw away, but these may be
> of interest to the caller, so add an extra parameter to (optionally) return
> the detected flags, and use this in the uas driver.
> 
> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


Patched (all 3 of them) and compile tested on the current Fedora kernel
(3.19.3-200), 

device is accessible and functioning without a kernel parameter

Steve


> ---
>  drivers/usb/storage/uas-detect.h | 6 +++++-
>  drivers/usb/storage/uas.c        | 6 +++---
>  drivers/usb/storage/usb.c        | 2 +-
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
> index 9893d69..63ae161 100644
> --- a/drivers/usb/storage/uas-detect.h
> +++ b/drivers/usb/storage/uas-detect.h
> @@ -51,7 +51,8 @@ static int uas_find_endpoints(struct usb_host_interface *alt,
>  }
>  
>  static int uas_use_uas_driver(struct usb_interface *intf,
> -			      const struct usb_device_id *id)
> +			      const struct usb_device_id *id,
> +			      unsigned long *flags_ret)
>  {
>  	struct usb_host_endpoint *eps[4] = { };
>  	struct usb_device *udev = interface_to_usbdev(intf);
> @@ -132,5 +133,8 @@ static int uas_use_uas_driver(struct usb_interface *intf,
>  		return 0;
>  	}
>  
> +	if (flags_ret)
> +		*flags_ret = flags;
> +
>  	return 1;
>  }
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 6cdabdc..c6109c1 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -887,8 +887,9 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	struct Scsi_Host *shost = NULL;
>  	struct uas_dev_info *devinfo;
>  	struct usb_device *udev = interface_to_usbdev(intf);
> +	unsigned long dev_flags;
>  
> -	if (!uas_use_uas_driver(intf, id))
> +	if (!uas_use_uas_driver(intf, id, &dev_flags))
>  		return -ENODEV;
>  
>  	if (uas_switch_interface(udev, intf))
> @@ -910,8 +911,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	devinfo->udev = udev;
>  	devinfo->resetting = 0;
>  	devinfo->shutdown = 0;
> -	devinfo->flags = id->driver_info;
> -	usb_stor_adjust_quirks(udev, &devinfo->flags);
> +	devinfo->flags = dev_flags;
>  	init_usb_anchor(&devinfo->cmd_urbs);
>  	init_usb_anchor(&devinfo->sense_urbs);
>  	init_usb_anchor(&devinfo->data_urbs);
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index 5600c33..db6f6b5 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -1080,7 +1080,7 @@ static int storage_probe(struct usb_interface *intf,
>  
>  	/* If uas is enabled and this device can do uas then ignore it. */
>  #if IS_ENABLED(CONFIG_USB_UAS)
> -	if (uas_use_uas_driver(intf, id))
> +	if (uas_use_uas_driver(intf, id, NULL))
>  		return -ENXIO;
>  #endif
>  


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
