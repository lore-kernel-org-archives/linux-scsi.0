Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684A5E94101
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 18:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbjJFS5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjJFS51 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 14:57:27 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 52101F7
        for <linux-scsi@vger.kernel.org>; Fri,  6 Oct 2023 11:57:19 -0700 (PDT)
Received: (qmail 54422 invoked by uid 1000); 6 Oct 2023 14:57:18 -0400
Date:   Fri, 6 Oct 2023 14:57:18 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        oneukum@suse.com, jonathan.derrick@linux.dev
Subject: Re: [RFC PATCH 6/6] usb-storage,uas: Disable security commands
 (OPAL) for RT9210 chip family
Message-ID: <e9aad1d3-1aa1-4f09-955f-6d9f6f604600@rowland.harvard.edu>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231006125445.122380-7-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006125445.122380-7-gmazyland@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 06, 2023 at 02:54:45PM +0200, Milan Broz wrote:
> Realtek 9210 family (NVME to USB bridge) adapters always set
> the write-protected bit for the whole drive if an OPAL locking range
> is defined (even if the OPAL locking range just covers part of the disk).
> 
> The only way to recover is PSID reset and physical reconnection of the device.
> 
> This looks like a wrong implementation of OPAL standard (and I will try
> to report it to Realtek as it happens for all firmware versions I have),
> but for now, these adapters are unusable for OPAL.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  drivers/usb/storage/unusual_devs.h | 11 +++++++++++
>  drivers/usb/storage/unusual_uas.h  | 11 +++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
> index 20dcbccb290b..b7c0df180e5d 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -1476,6 +1476,17 @@ UNUSUAL_DEV( 0x0bc2, 0x3332, 0x0000, 0x9999,
>  		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>  		US_FL_NO_WP_DETECT ),
>  
> +/*
> + * Realtek 9210 family set global write-protection flag
> + * for any OPAL locking range making device unusable
> + * Reported-by: Milan Broz <gmazyland@gmail.com>
> + */
> +UNUSUAL_DEV( 0x0bda, 0x9210, 0x0000, 0xffff,
> +		"Realtek",
> +		"",

Doesn't Realtek have some sort of product name you can put here?

> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> +		US_FL_IGNORE_OPAL),
> +
>  UNUSUAL_DEV(  0x0d49, 0x7310, 0x0000, 0x9999,
>  		"Maxtor",
>  		"USB to SATA",
> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
> index 1f8c9b16a0fb..71ab824bfb32 100644
> --- a/drivers/usb/storage/unusual_uas.h
> +++ b/drivers/usb/storage/unusual_uas.h
> @@ -185,3 +185,14 @@ UNUSUAL_DEV(0x4971, 0x8024, 0x0000, 0x9999,
>  		"External HDD",
>  		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>  		US_FL_ALWAYS_SYNC),
> +
> +/*
> + * Realtek 9210 family set global write-protection flag
> + * for any OPAL locking range making device unusable
> + * Reported-by: Milan Broz <gmazyland@gmail.com>
> + */
> +UNUSUAL_DEV(0x0bda, 0x9210, 0x0000, 0xffff,
> +		"Realtek",
> +		"",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> +		US_FL_IGNORE_OPAL),

This entry is not in the right position.  The file is supposed to be 
sorted by vendor ID, then product ID.

Alan Stern
