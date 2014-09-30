From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/23] fas216: Update logging messages
Date: Tue, 30 Sep 2014 07:55:05 -0700
Message-ID: <20140930145505.GC1206@infradead.org>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
 <1412077852-40893-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaI3OzG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 10:55:06 -0400
Content-Disposition: inline
In-Reply-To: <1412077852-40893-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On Tue, Sep 30, 2014 at 01:50:36PM +0200, Hannes Reinecke wrote:
> Update logging messages to use dev_printk() variants for correct
> device annotations.

> -	printk(" CDB: ");
> -	__scsi_print_command(SCpnt->cmnd);
> +	scsi_print_command(SCpnt);

And a __scsi_print_command -> scsi_print_command switch.  Which is
fine, but sould be mentioned.

> -			SCpnt->result &= ~(255 << 16);
> -			SCpnt->result |= DID_BAD_TARGET << 16;
> +			scmd_printk(KERN_ERR, SCpnt,
> +				    "incomplete data transfer "
> +				    "detected: res=%08X ptr=%p len=%X\n",
> +				    SCpnt->result, info->scsi.SCp.ptr,
> +				    info->scsi.SCp.this_residual);
> +			scsi_print_command(SCpnt);
> +			set_host_byte(SCpnt, DID_ERROR);

But the canges to setting ->result really do not belong into this
series.  I'll happily take them as a separate patch, though.

With that bit removed:

Reviewed-by: Christoph Hellwig <hch@lst.de>
