From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 4/4] Replace scmd->transfersize with scsi_transfer_size()
Date: Fri, 19 Oct 2007 19:45:54 +0200 (CEST)
Message-ID: <tkrat.c6961aca23c6c3f9@s5r6.in-berlin.de>
References: <11927248762034-git-send-email-matthew@wil.cx>
 <1192724876702-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46755 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387AbXJSRqB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 13:46:01 -0400
In-Reply-To: <1192724876702-git-send-email-matthew@wil.cx>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On 18 Oct, Matthew Wilcox wrote:
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
...
> @@ -2355,3 +2354,18 @@ void scsi_kunmap_atomic_sg(void *virt)
>  	kunmap_atomic(virt, KM_BIO_SRC_IRQ);
>  }
>  EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
> +
> +/*
> + * Returns the minimum size that must be transferred in one go.  For
> + * normal commands, this is the sector size of the device.  For special
> + * commands, the whole command must be transferred at once.  If a driver
> + * cannot transfer at least this much, it should fail the command.
> + */


As it is an exported symbol, kerneldoc format for the description is
appropriate:

/**
 * scsi_transfer_size - returns the minimum size that must be transferred in one go
 * @cmd: command for which to get the transfer size
 *
 * For normal commands, this is the sector size of the device.  For special
 * commands, the whole command must be transferred at once.  If a driver
 * cannot transfer at least this much, it should fail the command.
 */

IMO the last paragraph could be condensed to

 * If a driver cannot transfer at least this much, it should fail the command.
 */

> +unsigned int scsi_transfer_size(struct scsi_cmnd *cmd)
> +{
> +	struct request *req = cmd->request;

Whitespace police says:  Here goes a blank line.

> +	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
> +		return req->data_len;
> +	return cmd->device->sector_size;
> +}
> +EXPORT_SYMBOL(scsi_transfer_size);


-- 
Stefan Richter
-=====-=-=== =-=- =--==
http://arcgraph.de/sr/


