From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: JMS56x not working reliably with uas driver
Date: Thu, 22 Dec 2016 17:44:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1612221734120.15794-100000@netrider.rowland.org>
References: <585A69E6.6040009@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <585A69E6.6040009-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: George Cherian <gcherian-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Cc: oneukum-IBi9RG/b67k@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 21 Dec 2016, George Cherian wrote:

> Hi Oliver,
> 
> I was working with this JMicron device and using the uas driver.
> I am seeing the following 2 issues.
> 
> 1) On connect I see the following messages.
> xhci_hcd 0000:00:11.0: ERROR Transfer event for disabled endpoint or 
> incorrect stream ring
>   This was eliminated using the following scissor patch.
> 
> ---------------------------------8<------------------------------------
> [PATCH] usb: storage: unusual_uas: Add JMicron JMS56x to unusual device
> 
> This device gives the following error on detection.
> xhci_hcd 0000:00:11.0: ERROR Transfer event for disabled endpoint or 
> incorrect stream ring
> 
> The same error is not seen when it is added to unusual_device
> list with US_FL_NO_REPORT_OPCODES passed.
> 
> Signed-off-by: George Cherian <george.cherian-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/usb/storage/unusual_uas.h | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/usb/storage/unusual_uas.h 
> b/drivers/usb/storage/unusual_uas.h
> index cbea9f3..d292299 100644
> --- a/drivers/usb/storage/unusual_uas.h
> +++ b/drivers/usb/storage/unusual_uas.h
> @@ -142,6 +142,13 @@ UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
>   		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>   		US_FL_BROKEN_FUA | US_FL_NO_REPORT_OPCODES),
> 
> +/* Reported-by George Cherian <george.cherian-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> */
> +UNUSUAL_DEV(0x152d, 0x9561, 0x0000, 0x9999,
> +                "JMicron",
> +                "JMS56x",
> +                USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> +                US_FL_NO_REPORT_OPCODES),
> +
>   /* Reported-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> */
>   UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
>   		"VIA",
> --------------------------------->8------------------------------------

I don't see how this patch fixes anything.  Unless I'm mistaken, it
just avoids the problem by preventing the system from issuing the
command that provokes the error, rather than really fixing the
underlying error.

> 2) On disconnect I am seeing the following issue
> 
>   scsi host4: uas_post_reset: alloc streams error -19 after reset
>   sd 4:0:0:0: [sdb] Synchronizing SCSI cache
> 
> This is more fatal because after these messages the USB port becomes 
> unusable. Even an lsusb invocation hangs for ever.

This problem looks pretty simple.  uas doesn't check properly to see if 
the device was disconnected following a reset.

Try changing the line in uas_post_reset() that says:

	if (devinfo->shutdown)

to:

	if (devinfo->shutdown ||
			devinfo->udev->state == USB_STATE_NOTATTACHED)

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
