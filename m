From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] scsi_dh_rdac: switch to scsi_execute_req_flags()
Date: Wed, 2 Nov 2016 16:06:56 +0100
Message-ID: <20161102150655.GA14320@lst.de>
References: <1478036978-30583-1-git-send-email-hare@suse.de> <1478036978-30583-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33065 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754273AbcKBPG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Nov 2016 11:06:57 -0400
Content-Disposition: inline
In-Reply-To: <1478036978-30583-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Nov 01, 2016 at 10:49:36PM +0100, Hannes Reinecke wrote:
> Switch to scsi_execute_req_flags() instead of
> using the block interface directly. This will set
> REQ_QUIET and REQ_PREEMPT, but this is okay as
> we're evaluating the errors anyway and should be
> able to send the command even if the device is
> quiesced.

Actually most users are switched to scsi_get_vpd_page if I read the patch
right, which is even better.  And it seems like the remaining user of
scsi_execute_req_flags could be switch to use scsi_mode_select() as well,
but maybe we should leave that out for now.

> +	if (scsi_execute_req_flags(sdev, cdb, DMA_TO_DEVICE,
> +				   &h->ctlr->mode_select, data_size, &sshdr,
> +				   RDAC_TIMEOUT * HZ,
> +				   RDAC_RETRIES, NULL, REQ_FAILFAST_MASK)) {

Pleae use the individual failfast flags - REQ_FAILFAST_MASK is just
for block layer use.
