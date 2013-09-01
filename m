From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] Disallow changing the device state via sysfs into
 "deleted"
Date: Sun, 1 Sep 2013 09:49:29 -0700
Message-ID: <20130901164929.GD4344@infradead.org>
References: <52135B99.2000102@acm.org>
 <52135C47.4090106@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab3IAQtq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Sep 2013 12:49:46 -0400
Content-Disposition: inline
In-Reply-To: <52135C47.4090106@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Aug 20, 2013 at 02:08:39PM +0200, Bart Van Assche wrote:
> Changing the state of a SCSI device via sysfs into "cancel",
> "cancel-offline" or "deleted" prevents removal of these devices by
> scsi_remove_host(). Hence do not allow this.

Looks good modulo a minor style nipick below.

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +	if (state == 0 || state == SDEV_CANCEL ||
> +	    state == SDEV_CANCEL_OFFLINE || state == SDEV_DEL ||
> +	    scsi_device_set_state(sdev, state) != 0)
>  		return -EINVAL;

Doing a switch on the state would be a lot more readable here:

	switch (state) {
	case 0:
	case SDEV_CANCEL:
	case SDEV_CANCEL_OFFLINE:
	case SDEV_DEL:
		ret = -EINVAL;
		break;
	default:
		ret = scsi_device_set_state(sdev, state);
	}

	if (ret)
		return ret;
>  	return count;
>  }
