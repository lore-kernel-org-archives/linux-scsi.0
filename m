From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: 21 Jun 2003 19:25:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056241551.1775.14.camel@mulgrave>
References: <20030621165920.F2811@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:58885 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264540AbTFVALz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 20:11:55 -0400
In-Reply-To: <20030621165920.F2811@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: torvalds@transmeta.com, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>

In general, you would have been a bit better off just doing a

	if(cd->device->use_10_for_ms) {
		cgc.cmd[0] = MODE_SENSE_10;
		cgc.cmd[8] = 128;
	} else {
		cdc.cmd[0] = MODE_SENSE;
		cgc.cmd[4] = 128;
	}

Rather than duplicating so much code.

This: 

> +	if (cd->device->use_10_for_ms) {
> +		memset(&cgc, 0, sizeof(struct cdrom_generic_command));
> +		cgc.cmd[0] = MODE_SENSE_10;
> +		cgc.cmd[2] = 0x2a;		/* page code */
> +		cgc.cmd[8] = 128;		/* allocation length */
> +		cgc.buffer = buffer;
> +		cgc.buflen = 128;
> +		cgc.quiet = 1;
> +		cgc.data_direction = SCSI_DATA_READ;
> +		cgc.timeout = SR_TIMEOUT;
> +		rc = sr_do_ioctl(cd, &cgc);
> +	}
> +
> +	/* if we got an error, return to old behavior */
> +	if (rc)
> +		cd->device->use_10_for_ms = 0;

Is slightly incorrect.  Mode sense commands can return errors for many
reasons, you need to check for ILLEGAL_REQUEST sense before assuming it
was a problem with the command.

What probably should happen is that the resetting of the flag should be
in scsi_io_completion (like it is for the use_10_for_rw flag), then the
retry and the flag reset would come for free.

James


