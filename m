From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Mon, 11 Jul 2016 10:33:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1607111032310.27546-100000@netrider.rowland.org>
References: <1468238032-17835-1-git-send-email-oneukum@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:60932 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753613AbcGKOdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2016 10:33:31 -0400
In-Reply-To: <1468238032-17835-1-git-send-email-oneukum@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Mon, 11 Jul 2016, Oliver Neukum wrote:

> Some SATA to USB bridges fail to cooperate with some
> drives resulting in no cache being present being reported
> to the host. That causes the host to skip sending
> a command to synchronize caches. That causes data loss
> when the drive is powered down.

> @@ -581,6 +582,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
>  		case 'w':
>  			f |= US_FL_NO_WP_DETECT;
>  			break;
> +		case 'y':
> +			f |= US_FL_ALWAYS_SYNC;
> +			break;
>  		/* Ignore unrecognized flag characters */
>  		}
>  	}

You need to update Documentation/kernel-parameters.txt too.

Alan Stern

