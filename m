From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] Drivers: scsi: storvsc: Change the limits to reflect
 the values on the host
Date: Wed, 9 Jul 2014 01:39:54 -0700
Message-ID: <20140709083954.GA6012@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaGIIj4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 04:39:56 -0400
Content-Disposition: inline
In-Reply-To: <1404866812-26950-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Tue, Jul 08, 2014 at 05:46:45PM -0700, K. Y. Srinivasan wrote:
> + * In Hyper-V, each port/path/target maps to 1 scsi host adapter.

Does it still?  The STORVSC_FC_MAX_TARGETS define suggests otherwise.

> -	.cmd_per_lun =		1,
> +	.cmd_per_lun =		255,

This looks like an unrelated change.

> +		/* max # of devices per target */
> +		host->max_lun = STORVSC_FC_MAX_LUNS_PER_TARGET;
> +		/* max # of targets per channel */
> +		host->max_id = STORVSC_FC_MAX_TARGETS;
> +		/* max # of channels */
> +		host->max_channel = STORVSC_FC_MAX_CHANNELS - 1;

I don't think these comments add any value..

Also any reason you use off by one defines for max_channel, but not the
others?

