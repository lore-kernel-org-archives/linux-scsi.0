From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] USB: uas: Fix slave queue_depth not being set
Date: Mon, 23 May 2016 10:36:47 -0700
Message-ID: <1464025007.2331.17.camel@HansenPartnership.com>
References: <1464004158-3062-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34828 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbcEWRgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2016 13:36:50 -0400
In-Reply-To: <1464004158-3062-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Mon, 2016-05-23 at 13:49 +0200, Hans de Goede wrote:
> Commit 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level")
> removed the scsi_change_queue_depth() call from uas_slave_configure()
> assuming that the slave would inherit the host's queue_depth, which
> that commit sets to the same value.
> 
> This is incorrect, without the scsi_change_queue_depth() call the 
> slave's queue_depth defaults to 1, introducing a performance
> regression.
> 
> This commit restores the call, fixing the performance regression.
> 
> Cc: stable@vger.kernel.org
> Fixes: 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level")
> Reported-by: Tom Yan <tom.ty89@gmail.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/usb/storage/uas.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 16bc679..ecc7d4b 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -835,6 +835,7 @@ static int uas_slave_configure(struct scsi_device
> *sdev)
>  	if (devinfo->flags & US_FL_BROKEN_FUA)
>  		sdev->broken_fua = 1;
>  
> +	scsi_change_queue_depth(sdev, devinfo->qdepth - 2);

Are you sure about this?  For spinning rust, experiments imply that the
optimal queue depth per device is somewhere between 2 and 4.  Obviously
that's not true for SSDs, so it depends on your use case.  Plus, for
ATA NCQ devices (which I believe most UAS is bridged to) you have a
maximum NCQ depth of 31.

There's a good reason why you don't want a queue deeper than you can
handle: it tends to interfere with writeback because you build up a lot
of pending I/O in the queue which can't be issued (it's very similar to
why bufferbloat is a problem in networks).  In theory, as long as your
devices return the correct indicator (QUEUE_FULL status), we'll handle
most of this in the mid-layer by plugging the block queue, but given
what I've seen from UAS devices, that's less than probable.

James

