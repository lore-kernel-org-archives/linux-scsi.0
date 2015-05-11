From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/17] scsi_dh_alua: Disable ALUA handling for non-disk
	devices
Date: Mon, 11 May 2015 08:46:43 +0200
Message-ID: <20150511064643.GB30516@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38959 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbbEKGqp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 02:46:45 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, May 04, 2015 at 02:42:08PM +0200, Hannes Reinecke wrote:
> Non-disk devices should be ignored when detecting
> ALUA capabilities.

Hmm.  I don't think we should even attach the alua handler in this case,
e.g. refine the check in scsi_dh_find_driver.  But then again I don't
remember how the spec wording actually disallows this, and a quick grep
of SPC-4 can't find anything either.  Can you put a reference to the spec
section that disallows attachment to non-disk devices into the code?

> +	if (sdev->type != TYPE_DISK &&
> +	    sdev->type != TYPE_RBC &&
> +	    sdev->type != TYPE_OSD) {

And does it really allow RBC (but not ZBC)?
