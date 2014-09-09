From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/2] uas: Disable uas on ASM1051 devices
Date: Tue, 9 Sep 2014 11:23:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1409091120150.968-100000@iolanthe.rowland.org>
References: <1410274800-11578-3-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410274800-11578-3-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 9 Sep 2014, Hans de Goede wrote:

> Even with REPORT SUPPORTED OPERATION CODES blacklisted the ASM1051 chipset
> still does not work when combined with some disks, e.g. a Crucial M500 ssd.
> 
> When used with a troublesome disk, the chipset throws all kinds of USB errors,
> and eventually hangs, where as in BOT mode it works fine.
> 
> To make matters worse the ASM1051 chipset and older versions of the ASM1053
> chipset use the same usb-id.
> 
> When connected over USB-3 the 2 can be told apart by the number of streams
> they support. So this patch adds some less then pretty code to disable uas for
> the ASM1051. When connected over USB-2, simply disable uas alltogether for
> devices with the shared usb-id.
> 
> This ends up disabling uas in many cases where it actually works fine, which
> is unfortunate, but better then leaving some users with completely non working
> external disks. This patch adds a log level explaining how perfomance conscious
> users can re-enable uas.
> 
> Cc: stable@vger.kernel.org # 3.16
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/usb/storage/uas-detect.h | 34 ++++++++++++++++++++++++++++++----
>  1 file changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
> index 503ac5c..3119f3f 100644
> --- a/drivers/usb/storage/uas-detect.h
> +++ b/drivers/usb/storage/uas-detect.h
> @@ -59,10 +59,6 @@ static int uas_use_uas_driver(struct usb_interface *intf,
>  	unsigned long flags = id->driver_info;
>  	int r, alt;
>  
> -	usb_stor_adjust_quirks(udev, &flags);
> -
> -	if (flags & US_FL_IGNORE_UAS)
> -		return 0;
>  
>  	alt = uas_find_uas_alt_setting(intf);
>  	if (alt < 0)
> @@ -72,6 +68,36 @@ static int uas_use_uas_driver(struct usb_interface *intf,
>  	if (r < 0)
>  		return 0;
>  
> +	/*
> +	 * ASM1051 and older ASM1053 devices have the same usb-id, and UAS is
> +	 * broken with some disks on the ASM1051, use the number of streams to
> +	 * differentiate between the 2. Newer ASM1053 devices also support 32
> +	 * streams, but have a different product-id.
> +	 */
> +	if (udev->descriptor.idVendor == 0x174c &&
> +			udev->descriptor.idProduct == 0x55aa) {
> +		if (udev->speed < USB_SPEED_SUPER) {
> +			/* No streams info, assume ASM1051E */
> +			dev_warn(&udev->dev, "Assuming ASM1051E chipset\n");
> +			flags |= US_FL_IGNORE_UAS;
> +		} else if (usb_ss_max_streams(&eps[1]->ss_ep_comp) == 32) {
> +			dev_warn(&udev->dev, "Detected ASM1051E chipset\n");
> +			flags |= US_FL_IGNORE_UAS;
> +		}
> +	}
> +
> +	usb_stor_adjust_quirks(udev, &flags);

This won't work.  usb_stor_adjust_quirks masks out all the quirks that 
it handles before applying the user-specified quirks.  Therefore it 
will erase your US_FL_IGNORE_UAS flag.

You might as well remove this call and leave the earlier call to
usb_stor_adjust_quirks (in the first hunk of the patch) as is.

Alan Stern
