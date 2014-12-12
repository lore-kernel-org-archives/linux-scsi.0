From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] uas: disable UAS on Apricorn SATA dongles
Date: Fri, 12 Dec 2014 11:42:12 +0100
Message-ID: <548AC684.3020801@redhat.com>
References: <20141211190111.GD21955@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141211190111.GD21955-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

<Adding Greg and stable to the cc>

On 11-12-14 20:01, Darrick J. Wong wrote:
> The Apricorn SATA dongle will occasionally return "USBSUSBSUSB" in
> response to SCSI commands when running in UAS mode.  Therefore,
> disable UAS mode on this dongle.
>
> Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Looks good:

Acked-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Greg, can you add this to your tree please ?

Regards,

Hans


> ---
>   drivers/usb/storage/unusual_uas.h |   10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
> index 18a283d..3530cb0 100644
> --- a/drivers/usb/storage/unusual_uas.h
> +++ b/drivers/usb/storage/unusual_uas.h
> @@ -40,6 +40,16 @@
>    * and don't forget to CC: the USB development list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>    */
>
> +/*
> + * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
> + * commands in UAS mode.  Observed with the 1.28 firmware; are there others?
> + */
> +UNUSUAL_DEV(0x0984, 0x0301, 0x0128, 0x0128,
> +		"Apricorn",
> +		"",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> +		US_FL_IGNORE_UAS),
> +
>   /* https://bugzilla.kernel.org/show_bug.cgi?id=79511 */
>   UNUSUAL_DEV(0x0bc2, 0x2312, 0x0000, 0x9999,
>   		"Seagate",
>
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
