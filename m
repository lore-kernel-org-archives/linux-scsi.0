From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dpt_i2o pci_driver model
Date: Fri, 19 Aug 2005 15:59:02 +0100
Message-ID: <20050819145902.GA2015@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01709253@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54933 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964955AbVHSO7E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 10:59:04 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01709253@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Aug 17, 2005 at 01:04:05PM -0400, Salyzyn, Mark wrote:
> Christoph Hellwig [mailto:hch@infradead.org] writes:
> > ... update the driver to use the pci_driver model ...
> 
> The patch applies to the scsi-misc-2.6 git tree. The moving of
> adpt_install_hba to the near bottom of the dpt_i2o.c file creates a
> dirty context diff in that region which is hard to inspect from within
> the patch. No coding style changes were made when moving content from
> the original initialization code to the module_init and module_exit
> functions to aid before and after comparisons for inspection; even
> despite the fact C++ style comments are used in these sections. We
> expect such style cleanup to occur either on any necessary follow-up
> rewrites after basic functional approval, or as a follow-up cleanup
> patch.

This looks wrong to me.  It's still walking a lot of driver-global
hba lists in the init routine.  All hba initialization should happen
in the ->probe callback, and there should be very little global
initialization.  There shouldn't really be any global list of hbas.

