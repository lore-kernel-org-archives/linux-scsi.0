From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: JMS56x not working reliably with uas driver
Date: Wed, 21 Dec 2016 12:50:10 +0100
Message-ID: <77741cc0-12fd-e380-b687-2c7bf1dd30a4@redhat.com>
References: <585A69E6.6040009@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754744AbcLULuN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Dec 2016 06:50:13 -0500
In-Reply-To: <585A69E6.6040009@caviumnetworks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: George Cherian <gcherian@caviumnetworks.com>, oneukum@suse.com
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, stern@rowland.harvard.edu

Hi,

On 21-12-16 12:39, George Cherian wrote:
> Hi Oliver,
>
> I was working with this JMicron device and using the uas driver.
> I am seeing the following 2 issues.
>
> 1) On connect I see the following messages.
> xhci_hcd 0000:00:11.0: ERROR Transfer event for disabled endpoint or incorrect stream ring
>  This was eliminated using the following scissor patch.
>
> ---------------------------------8<------------------------------------
> [PATCH] usb: storage: unusual_uas: Add JMicron JMS56x to unusual device
>
> This device gives the following error on detection.
> xhci_hcd 0000:00:11.0: ERROR Transfer event for disabled endpoint or incorrect stream ring
>
> The same error is not seen when it is added to unusual_device
> list with US_FL_NO_REPORT_OPCODES passed.
>
> Signed-off-by: George Cherian <george.cherian@cavium.com>
> ---
>  drivers/usb/storage/unusual_uas.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
> index cbea9f3..d292299 100644
> --- a/drivers/usb/storage/unusual_uas.h
> +++ b/drivers/usb/storage/unusual_uas.h
> @@ -142,6 +142,13 @@ UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
>          USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>          US_FL_BROKEN_FUA | US_FL_NO_REPORT_OPCODES),
>
> +/* Reported-by George Cherian <george.cherian@cavium.com> */
> +UNUSUAL_DEV(0x152d, 0x9561, 0x0000, 0x9999,
> +                "JMicron",
> +                "JMS56x",
> +                USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> +                US_FL_NO_REPORT_OPCODES),
> +
>  /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
>  UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
>          "VIA",
> --------------------------------->8------------------------------------
>
> 2) On disconnect I am seeing the following issue
>
>  scsi host4: uas_post_reset: alloc streams error -19 after reset
>  sd 4:0:0:0: [sdb] Synchronizing SCSI cache
>
> This is more fatal because after these messages the USB port becomes unusable. Even an lsusb invocation hangs for ever.
>
> Also please note that the device works fine with usb-storage driver.
> I am attaching the usbmon capture of disconnect using uas and usb-storage driver.
>
> Any help in this regard is highly appreciated.

Are you still seeen this second problem with the first patch applied ? Is this after
an actual disconnect, or after the kernel seeing a disconnect without the device
being actually disconnected.

This second problem sounds like it is an issue with your xhci controller. Can you
try this on another motherboard (with another xhci controller) ?

Regards,

Hans
