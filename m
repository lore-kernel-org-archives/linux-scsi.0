Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6848EE81E1E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 17:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjJFRgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 13:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjJFRf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 13:35:59 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 43CCCC2
        for <linux-scsi@vger.kernel.org>; Fri,  6 Oct 2023 10:35:57 -0700 (PDT)
Received: (qmail 52300 invoked by uid 1000); 6 Oct 2023 13:35:56 -0400
Date:   Fri, 6 Oct 2023 13:35:56 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        oneukum@suse.com, jonathan.derrick@linux.dev
Subject: Re: [RFC PATCH 3/6] usb-storage: use fflags index only in
 usb-storage driver
Message-ID: <a81f4e04-fecf-4e04-9253-5dedec20c580@rowland.harvard.edu>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231006125445.122380-4-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006125445.122380-4-gmazyland@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 06, 2023 at 02:54:42PM +0200, Milan Broz wrote:
> This patch adds a parameter to use driver_info translation function
> (which will be defined in the following patch).
> 
> Only USB storage driver will use it, as other drivers do not need
> more than 32-bit quirk flags.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---

Apart from the one issue noted below,

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>

> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index d1ad6a2509ab..72b48b94aa5f 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -574,7 +574,7 @@ EXPORT_SYMBOL_GPL(usb_stor_adjust_quirks);
>  
>  /* Get the unusual_devs entries and the string descriptors */
>  static int get_device_info(struct us_data *us, const struct usb_device_id *id,
> -		const struct us_unusual_dev *unusual_dev)
> +		const struct us_unusual_dev *unusual_dev, int fflags_use_index)
>  {
>  	struct usb_device *dev = us->pusb_dev;
>  	struct usb_interface_descriptor *idesc =
> @@ -590,6 +590,7 @@ static int get_device_info(struct us_data *us, const struct usb_device_id *id,
>  			idesc->bInterfaceProtocol :
>  			unusual_dev->useTransport;
>  	us->fflags = id->driver_info;
> +
>  	usb_stor_adjust_quirks(us->pusb_dev, &us->fflags);
>  
>  	if (us->fflags & US_FL_IGNORE_DEVICE) {

Extraneous whitespace change.  This doesn't belong in the patch.

Alan Stern
