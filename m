From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] scsi: pm8001: fix pm8001_store_update_fw
Date: Wed, 9 Jul 2014 23:43:01 -0700
Message-ID: <20140710064301.GA18156@infradead.org>
References: <1404746401-25229-4-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaGJGnC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 02:43:02 -0400
Content-Disposition: inline
In-Reply-To: <1404746401-25229-4-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

On Mon, Jul 07, 2014 at 05:20:01PM +0200, Tomas Henzl wrote:
> The current implementation may mix the negative value returned
> from pm8001_set_nvmd with with count. -(-ENOMEM) could be interpreted
> as bytes programmed, this patch fixes it.

This still doesn;t look correct to me as err mixes up the driver
internal FAIL_* codes with Linux error codes.  It seems like for the
FAIL_* codes should only go into ->fw_status and the return value
should be a proper Linux error code.

Funny fact: the FAIL_* / FLASH_IN_PROGRESS codes seems to be the same
between aic94xx and pm8001.

