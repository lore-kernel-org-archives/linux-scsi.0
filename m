From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] uas: leave can_queue as MAX_CMNDS if device reports
 larger qdepth
Date: Mon, 23 May 2016 10:00:25 -0700
Message-ID: <20160523170025.GA3309@kroah.com>
References: <574329ae.c726620a.60f3.ffffd14b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbcEWRA1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2016 13:00:27 -0400
Content-Disposition: inline
In-Reply-To: <574329ae.c726620a.60f3.ffffd14b@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: kraxel@redhat.com, stern@rowland.harvard.edu, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, hdegoede@redhat.com

On Tue, May 24, 2016 at 12:02:43AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> Commit 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level") made
> qdepth limit set in host template (`.can_queue = MAX_CMNDS`) useless.
> 
> Instead of removing the template limit, now we only change limit according
> to the qdepth reported by the device if it is smaller than MAX_CMNDS.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 4d49fce..d7790e6 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -972,7 +972,8 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	 * 1 tag is reserved for untagged commands +
>  	 * 1 tag to avoid off by one errors in some bridge firmwares
>  	 */
> -	shost->can_queue = devinfo->qdepth - 2;
> +	if (devinfo->qdepth - 2 < MAX_CMNDS)
> +		shost->can_queue = devinfo->qdepth - 2;

What's wrong with Hans's patch for this issue instead?

