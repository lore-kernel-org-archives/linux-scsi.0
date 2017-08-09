From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] hpsa: handle unsupported devices more gracefully
Date: Wed, 9 Aug 2017 15:48:00 +0200
Message-ID: <20170809134800.GG25852@lst.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de> <1502181315-102499-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53594 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752459AbdHINsB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 09:48:01 -0400
Content-Disposition: inline
In-Reply-To: <1502181315-102499-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>

On Tue, Aug 08, 2017 at 10:35:15AM +0200, Hannes Reinecke wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Add a warning message if an unsupported device is found and the
> hpsa_allow_any parameter is not set.
> Also make the hpsa_allow_any parameter writeable once the hpsa
> driver is loaded.

This looks ok, but maybe we should also plan for just setting the
flag by defauly sooner or later?

> +static struct kernel_param_ops hpsa_allow_any_ops = {

const?

> +
> +	if (hpsa_allow_any && !newval) {
> +		if (hpsa_claimed_unsupported) {
> +			pr_info("hpsa: can't disable hpsa_allow_any parameter. Devices already in use.\n");
> +			return -EPERM;
> +		} else
> +			hpsa_allow_any = false;
> +	} else if (!hpsa_allow_any && newval) {
> +		pr_info("hpsa: allowing unsupported devices. If devices are claimed, this will result in an unsupported environment.\n");
> +		hpsa_allow_any = true;
> +	}
> +	return 0;

Do we really need this to start with?  It's normal that module
parameters only affect newly probed devices when changed at runtime,
so I think we could just stick to the simple module parameter with
permissions that allow runtime changes.
