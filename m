From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi/sata write barrier support
Date: Fri, 28 Jan 2005 08:12:22 -0500
Message-ID: <1106917942.5175.7.camel@mulgrave>
References: <200501272242.j0RMgoP5016154@falcon30.maxeymade.com>
	 <41F97299.2070909@pobox.com> <20050128065358.GA4800@suse.de>
	 <41F9F386.7070501@pobox.com> <20050128081814.GH4800@suse.de>
	 <20050128093840.GI4800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:17546 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261342AbVA1NMh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2005 08:12:37 -0500
In-Reply-To: <20050128093840.GI4800@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, Doug Maxey <dwm@maxeymade.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-01-28 at 10:38 +0100, Jens Axboe wrote:
> +/*
> + * snoop succesfull completion of mode select commands that update the
> + * write back cache state
> + */
> +#define MS_CACHE_PAGE	0x08
> +static void sd_snoop_cmd(struct scsi_cmnd *cmd)
> +{
> +	struct scsi_disk *sdpk;
> +	char *page;
> +
> +	if (cmd->result)
> +		return;
> +
> +	switch (cmd->cmnd[0]) {
> +		case MODE_SELECT:
> +		case MODE_SELECT_10:
> +			page = cmd->request_buffer;
> +			if (!page)
> +				break;
> +			if ((page[0] & 0x3f) != MS_CACHE_PAGE)
> +				break;
> +			sdpk = dev_get_drvdata(&cmd->device->sdev_gendev);
> +			sdpk->WCE = (page[2] & 0x04) != 0;
> +			break;
> +	}
> +}
> +
>  /**
>   *	sd_rw_intr - bottom half handler: called when the lower level
>   *	driver has completed (successfully or otherwise) a scsi command.
> @@ -773,6 +831,9 @@ static void sd_rw_intr(struct scsi_cmnd 
>  			SCpnt->sense_buffer[13]));
>  	}
>  #endif
> +
> +	sd_snoop_cmd(SCpnt);
> +

Good grief no!

If you're going to try something like this, it needs to be a separate
patch over the scsi-list for one thing.  And to save time:

1) The patch is actually wrong.  There's more than one caching mode page
and not all of them affect current behaviour.
2) We have a current interface to update the WCE bit:  You twiddle all
the disc parameters and then trigger a device rescan via sysfs (I'll
check that this updates the cache bits, I think it does, but if it
doesn't I'll make it).
3) If we think this is a quantity the users would like to see and alter,
then reading and setting it should be exported via sysfs.
4) Snooping SCSI commands is really bad ... it can get you into all
sorts of trouble which is why we prefer asking the device what state
it's in to trying to guess ourselves.

James


