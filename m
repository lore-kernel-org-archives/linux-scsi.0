From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 00/11] scsi: fix module reference mismatch for scsi
 host
Date: Mon, 19 Jan 2015 09:22:06 -0500
Message-ID: <20150119142206.GE8140@htj.dyndns.org>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:37882 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbbASOWK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2015 09:22:10 -0500
Content-Disposition: inline
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, Hans de Goede <hdegoede@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Robert Love <robert.w.love@intel.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, fcoe-devel@open-fcoe.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Mon, Jan 19, 2015 at 12:05:58AM +0900, Akinobu Mita wrote:
> While accessing a scsi_device, the use count of the underlying LLDD
> module is incremented.  The module reference is retrieved through
> .module field of struct scsi_host_template.
> 
> This mapping between scsi_device and underlying LLDD module works well
> except some drivers which consist with the core driver and the actual
> LLDDs and scsi_host_template is defined in the core driver.  In these
> cases, the actual LLDDs can be unloaded even if the scsi_device is
> being accessed.
> 
> This patch series fixes the module reference mismatch problem for
> ufs, usb-storage, esp_scsi, ahci_platform, and pata_platform drivers
> by moving owner module reference field from struct scsi_host_template
> to struct Scsi_Host and allowing the LLDDs to set their correct module
> reference.

Hmmm, can't we just move sht definitions to actual LLDDs?  libata can
do that easily.  sht, as its name implies, is the template for
creating the scsi_hosts of a given type.  We're now just moving module
ownership from sht definition site to whatever callsite the actual
instance is being created which can also be wrapped in a separate
layer requiring explicit propagation.  Why not just propagate sht's
directly?  What's the difference?

Thanks.

-- 
tejun
