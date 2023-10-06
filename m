Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B507EE81E1F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 17:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjJFR0K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 13:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbjJFR0J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 13:26:09 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id F264DD8
        for <linux-scsi@vger.kernel.org>; Fri,  6 Oct 2023 10:26:06 -0700 (PDT)
Received: (qmail 51972 invoked by uid 1000); 6 Oct 2023 13:26:06 -0400
Date:   Fri, 6 Oct 2023 13:26:06 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        oneukum@suse.com, jonathan.derrick@linux.dev
Subject: Re: [RFC PATCH 2/6] usb-storage: make internal quirks flags 64bit
Message-ID: <0135a490-59f7-4ef2-bc25-6b89497ac5db@rowland.harvard.edu>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231006125445.122380-3-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006125445.122380-3-gmazyland@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 06, 2023 at 02:54:41PM +0200, Milan Broz wrote:
> Switch internal usb-storage quirk value to 64-bit as quirks currently
> already use all 32 bits.
> 
> (Following patches are needed to properly use driver_info
> for 64-bit value.)
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>

>  drivers/usb/storage/uas-detect.h   | 4 ++--
>  drivers/usb/storage/uas.c          | 4 ++--
>  drivers/usb/storage/usb.c          | 8 ++++----
>  drivers/usb/storage/usb.h          | 4 ++--
>  drivers/usb/storage/usual-tables.c | 2 +-
>  5 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
> index d73282c0ec50..4d3b49e5b87a 100644
> --- a/drivers/usb/storage/uas-detect.h
> +++ b/drivers/usb/storage/uas-detect.h
> @@ -54,12 +54,12 @@ static int uas_find_endpoints(struct usb_host_interface *alt,
>  
>  static int uas_use_uas_driver(struct usb_interface *intf,
>  			      const struct usb_device_id *id,
> -			      unsigned long *flags_ret)
> +			      u64 *flags_ret)
>  {
>  	struct usb_host_endpoint *eps[4] = { };
>  	struct usb_device *udev = interface_to_usbdev(intf);
>  	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
> -	unsigned long flags = id->driver_info;
> +	u64 flags = id->driver_info;
>  	struct usb_host_interface *alt;
>  	int r;
>  
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 2583ee9815c5..696bb0b23599 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -37,7 +37,7 @@ struct uas_dev_info {
>  	struct usb_anchor cmd_urbs;
>  	struct usb_anchor sense_urbs;
>  	struct usb_anchor data_urbs;
> -	unsigned long flags;
> +	u64 flags;
>  	int qdepth, resetting;
>  	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
>  	unsigned use_streams:1;
> @@ -988,7 +988,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	struct Scsi_Host *shost = NULL;
>  	struct uas_dev_info *devinfo;
>  	struct usb_device *udev = interface_to_usbdev(intf);
> -	unsigned long dev_flags;
> +	u64 dev_flags;
>  
>  	if (!uas_use_uas_driver(intf, id, &dev_flags))
>  		return -ENODEV;
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index bb1fbeddc5aa..d1ad6a2509ab 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -460,13 +460,13 @@ static int associate_dev(struct us_data *us, struct usb_interface *intf)
>  #define TOLOWER(x) ((x) | 0x20)
>  
>  /* Adjust device flags based on the "quirks=" module parameter */
> -void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
> +void usb_stor_adjust_quirks(struct usb_device *udev, u64 *fflags)
>  {
>  	char *p;
>  	u16 vid = le16_to_cpu(udev->descriptor.idVendor);
>  	u16 pid = le16_to_cpu(udev->descriptor.idProduct);
> -	unsigned f = 0;
> -	unsigned int mask = (US_FL_SANE_SENSE | US_FL_BAD_SENSE |
> +	u64 f = 0;
> +	u64 mask = (US_FL_SANE_SENSE | US_FL_BAD_SENSE |
>  			US_FL_FIX_CAPACITY | US_FL_IGNORE_UAS |
>  			US_FL_CAPACITY_HEURISTICS | US_FL_IGNORE_DEVICE |
>  			US_FL_NOT_LOCKABLE | US_FL_MAX_SECTORS_64 |
> @@ -605,7 +605,7 @@ static int get_device_info(struct us_data *us, const struct usb_device_id *id,
>  		us->fflags &= ~US_FL_GO_SLOW;
>  
>  	if (us->fflags)
> -		dev_info(pdev, "Quirks match for vid %04x pid %04x: %lx\n",
> +		dev_info(pdev, "Quirks match for vid %04x pid %04x: %llx\n",
>  				le16_to_cpu(dev->descriptor.idVendor),
>  				le16_to_cpu(dev->descriptor.idProduct),
>  				us->fflags);
> diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
> index fd3f32670873..97c6196d639b 100644
> --- a/drivers/usb/storage/usb.h
> +++ b/drivers/usb/storage/usb.h
> @@ -95,7 +95,7 @@ struct us_data {
>  	struct usb_interface	*pusb_intf;	 /* this interface */
>  	const struct us_unusual_dev   *unusual_dev;
>  						/* device-filter entry     */
> -	unsigned long		fflags;		 /* fixed flags from filter */
> +	u64			fflags;		 /* fixed flags from filter */
>  	unsigned long		dflags;		 /* dynamic atomic bitflags */
>  	unsigned int		send_bulk_pipe;	 /* cached pipe values */
>  	unsigned int		recv_bulk_pipe;
> @@ -192,7 +192,7 @@ extern int usb_stor_probe2(struct us_data *us);
>  extern void usb_stor_disconnect(struct usb_interface *intf);
>  
>  extern void usb_stor_adjust_quirks(struct usb_device *dev,
> -		unsigned long *fflags);
> +		u64 *fflags);
>  
>  #define module_usb_stor_driver(__driver, __sht, __name) \
>  static int __init __driver##_init(void) \
> diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
> index b3c3ea04c11c..a26029e43dfd 100644
> --- a/drivers/usb/storage/usual-tables.c
> +++ b/drivers/usb/storage/usual-tables.c
> @@ -19,7 +19,7 @@
>  		    vendorName, productName, useProtocol, useTransport, \
>  		    initFunction, flags) \
>  { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
> -  .driver_info = (flags) }
> +  .driver_info = (kernel_ulong_t)(flags) }
>  
>  #define COMPLIANT_DEV	UNUSUAL_DEV
>  
> -- 
> 2.42.0
> 
