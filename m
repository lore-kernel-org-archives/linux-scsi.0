From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [SCSI] mpt2sas: Don't disable device twice at suspend.
Date: Wed, 28 May 2014 03:45:08 -0700
Message-ID: <20140528104508.GA911@infradead.org>
References: <1398458464-11826-1-git-send-email-tstache1@binghamton.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaE1KpL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 06:45:11 -0400
Content-Disposition: inline
In-Reply-To: <1398458464-11826-1-git-send-email-tstache1@binghamton.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyler Stachecki <tstache1@binghamton.edu>
Cc: Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, JBottomley@parallels.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

On Fri, Apr 25, 2014 at 04:41:04PM -0400, Tyler Stachecki wrote:
> On suspend, _scsih_suspend calls mpt2sas_base_free_resources, which
> in turn calls pci_disable_device if the device is enabled prior to
> suspending. However, _scsih_suspend also calls pci_disable_device
> itself.
> 
> Thus, in the event that the device is enabled prior to suspending,
> pci_disable_device will be called twice. This patch removes the
> duplicate call to pci_disable_device in _scsi_suspend as it is both
> unnecessary and results in a kernel oops.
> 
> Signed-off-by: Tyler Stachecki <tstache1@binghamton.edu>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
