Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EACEC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 358C360F38
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbhHQMTK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 08:19:10 -0400
Received: from verein.lst.de ([213.95.11.211]:58288 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237125AbhHQMTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 08:19:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6BD6467357; Tue, 17 Aug 2021 14:18:34 +0200 (CEST)
Date:   Tue, 17 Aug 2021 14:18:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 03/51] sym53c8xx_2: split off bus reset from host reset
Message-ID: <20210817121834.GC30436@lst.de>
References: <20210817091456.73342-1-hare@suse.de> <20210817091456.73342-4-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817091456.73342-4-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 17, 2021 at 11:14:08AM +0200, Hannes Reinecke wrote:
> The current handler does both, bus reset and host reset.
> So split them off into two distinct functions.

Well, it splits out both the bus and the host reset from sym_eh_handler,
which also handles abort and device reset.

> +	/*
> +	 * Escalate to host reset if the PCI bus went down
>  	 */

That's a pretty big change from the old code and warrants a little
explanation.  I suspect this is fine, but I'd like to read the
thoughts about it in the commit log.

> +	spin_lock_irq(shost->host_lock);
> +	sym_reset_scsi_bus(np, 1);
> +	spin_unlock_irq(shost->host_lock);

This loses the cmd_queued handling.  Which I guess should be fine, but
again needs to be properly documented.  Same for the host reset.

> +						(sym_data->io_reset,
> +						WAIT_FOR_PCI_RECOVERY*HZ);
> +		spin_lock_irq(shost->host_lock);
> +		sym_data->io_reset = NULL;
> +		spin_unlock_irq(shost->host_lock);
> +	}
> +
> +	if (finished_reset) {
> +		sym_reset_scsi_bus(np, 0);
> +		sym_start_up(shost, 1);
> +	}
> +
> +	shost_printk(KERN_WARNING, shost, "HOST RESET operation %s.\n",
> +			finished_reset==1 ? "complete" : "failed");
> +	return finished_reset ? SCSI_SUCCESS : SCSI_FAILED;

The old code just returned early for the !finished_reset case, why
does this change it?
