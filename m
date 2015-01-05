From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH for kernel 3.19] Avoid that scsi_device_put() triggers
	a kernel warning
Date: Mon, 5 Jan 2015 14:02:59 +0100
Message-ID: <20150105130259.GA25960@lst.de>
References: <54AA6F75.7040607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54610 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbbAENDD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 08:03:03 -0500
Content-Disposition: inline
In-Reply-To: <54AA6F75.7040607@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I don't like this.  The problem is that sd_shutdown shouldn't even try
to grab a reference to the scsi device, nevermind the HBA module.

So I'd say this need a two step fix:

 (1) stop trying to call try_module_get from sd_shutdown
 (2) properly propagate the try_module_get return value

