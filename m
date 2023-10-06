Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB653E81E1E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 17:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjJFRQw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 13:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbjJFRQv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 13:16:51 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 503BAC5
        for <linux-scsi@vger.kernel.org>; Fri,  6 Oct 2023 10:16:45 -0700 (PDT)
Received: (qmail 51731 invoked by uid 1000); 6 Oct 2023 13:16:43 -0400
Date:   Fri, 6 Oct 2023 13:16:43 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        oneukum@suse.com, jonathan.derrick@linux.dev
Subject: Re: [RFC PATCH 1/6] usb-storage: remove UNUSUAL_VENDOR_INTF macro
Message-ID: <691010ef-d388-4ce0-b6a0-427bf77bea95@rowland.harvard.edu>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231006125445.122380-2-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006125445.122380-2-gmazyland@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 06, 2023 at 02:54:40PM +0200, Milan Broz wrote:
> This patch removes macro that was used only
> by commit that was reverted in
>  commit ab4b71644a26d1ab92b987b2fd30e17c25e89f85
>  USB: storage: fix Huawei mode switching regression

The standard format for referring to commits in patch descriptions is 
like this:

commit ab4b71644a26 ("USB: storage: fix Huawei mode switching regression")

That is, the commit hash is abbreviated to its first 12 hex digits and 
is followed by the commit title enclosed in parentheses and quotation 
marks.

Apart from that minor issue,

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  drivers/usb/storage/usb.c          | 12 ------------
>  drivers/usb/storage/usual-tables.c | 15 ---------------
>  2 files changed, 27 deletions(-)
> 
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index 7b36a3334fb3..bb1fbeddc5aa 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -110,17 +110,6 @@ MODULE_PARM_DESC(quirks, "supplemental list of device IDs and their quirks");
>  	.useTransport = use_transport,	\
>  }
>  
> -#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
> -		vendor_name, product_name, use_protocol, use_transport, \
> -		init_function, Flags) \
> -{ \
> -	.vendorName = vendor_name,	\
> -	.productName = product_name,	\
> -	.useProtocol = use_protocol,	\
> -	.useTransport = use_transport,	\
> -	.initFunction = init_function,	\
> -}
> -
>  static const struct us_unusual_dev us_unusual_dev_list[] = {
>  #	include "unusual_devs.h"
>  	{ }		/* Terminating entry */
> @@ -132,7 +121,6 @@ static const struct us_unusual_dev for_dynamic_ids =
>  #undef UNUSUAL_DEV
>  #undef COMPLIANT_DEV
>  #undef USUAL_DEV
> -#undef UNUSUAL_VENDOR_INTF
>  
>  #ifdef CONFIG_LOCKDEP
>  
> diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
> index 529512827d8f..b3c3ea04c11c 100644
> --- a/drivers/usb/storage/usual-tables.c
> +++ b/drivers/usb/storage/usual-tables.c
> @@ -26,20 +26,6 @@
>  #define USUAL_DEV(useProto, useTrans) \
>  { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans) }
>  
> -/* Define the device is matched with Vendor ID and interface descriptors */
> -#define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
> -			vendorName, productName, useProtocol, useTransport, \
> -			initFunction, flags) \
> -{ \
> -	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO \
> -				| USB_DEVICE_ID_MATCH_VENDOR, \
> -	.idVendor    = (id_vendor), \
> -	.bInterfaceClass = (cl), \
> -	.bInterfaceSubClass = (sc), \
> -	.bInterfaceProtocol = (pr), \
> -	.driver_info = (flags) \
> -}
> -
>  const struct usb_device_id usb_storage_usb_ids[] = {
>  #	include "unusual_devs.h"
>  	{ }		/* Terminating entry */
> @@ -49,7 +35,6 @@ MODULE_DEVICE_TABLE(usb, usb_storage_usb_ids);
>  #undef UNUSUAL_DEV
>  #undef COMPLIANT_DEV
>  #undef USUAL_DEV
> -#undef UNUSUAL_VENDOR_INTF
>  
>  /*
>   * The table of devices to ignore
> -- 
> 2.42.0
> 
