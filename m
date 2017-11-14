From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] uas: Add US_FL_NO_ATA_1X quirk for one more Seagate
 device
Date: Tue, 14 Nov 2017 15:04:44 +0100
Message-ID: <9f0486e5-7ff7-b612-3465-04f47e8c2545@redhat.com>
References: <20171114140017.17782-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114140017.17782-1-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 14-11-17 15:00, Hans de Goede wrote:
> Just like all previous UAS capable Seagate disk enclosures, this
> one needs a US_FL_NO_ATA_1X quirk.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.16
> Reported-by: Wido <wido.gg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


So far we've been adding quirks for Seagate drives on a one by one
basis (I started this myself) hoping that one day they will fix
their ATA_1X pass-through support. But that does not seem to
be happening.

Maybe we need to do something like this instead ?   :

--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -111,6 +111,10 @@ static int uas_use_uas_driver(struct usb_interface *intf,
                 }
         }

+ /* All Seagate disk enclosures have broken ATA pass-through support */
+ if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2)
+         flags |= US_FL_NO_ATA_1X;
+
         usb_stor_adjust_quirks(udev, &flags);

         if (flags & US_FL_IGNORE_UAS) {


Then we can remove a whole lot of quirks and we avoid future
churn when new Seagate device ids show up.

Regards,

Hans



> ---
>   drivers/usb/storage/unusual_uas.h | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
> index 2fe4fd336446..a1ddcbfb7323 100644
> --- a/drivers/usb/storage/unusual_uas.h
> +++ b/drivers/usb/storage/unusual_uas.h
> @@ -114,6 +114,13 @@ UNUSUAL_DEV(0x0bc2, 0xab21, 0x0000, 0x9999,
>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>   		US_FL_NO_ATA_1X),
>   
> +/* Reported-by: Wido <wido.gg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> */
> +UNUSUAL_DEV(0x0bc2, 0xab24, 0x0000, 0x9999,
> +		"Seagate",
> +		"BUP Slim BK",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> +		US_FL_NO_ATA_1X),
> +
>   /* Reported-by: G. Richard Bellamy <rbellamy-1/AleqyZJC8ybS5Ee8rs3A@public.gmane.org> */
>   UNUSUAL_DEV(0x0bc2, 0xab2a, 0x0000, 0x9999,
>   		"Seagate",
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
