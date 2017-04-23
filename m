From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] scsi: pmcraid: fix endianess sparse annotations
Date: Sun, 23 Apr 2017 01:38:52 -0700
Message-ID: <20170423083852.GC30869@infradead.org>
References: <20170420175549.3435196-1-arnd@arndb.de>
 <20170420175549.3435196-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34845 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1427990AbdDWIiz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Apr 2017 04:38:55 -0400
Content-Disposition: inline
In-Reply-To: <20170420175549.3435196-3-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Berg <johannes.berg@intel.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>  	mb();
> -	iowrite32(le32_to_cpu(cmd->ioa_cb->ioarcb.ioarcb_bus_addr),
> -		  pinstance->ioarrin);
> +	iowrite32(le64_to_cpu(cmd->ioa_cb->ioarcb.ioarcb_bus_addr), pinstance->ioarrin);

It really seems like some of these fields should be swapped once
and store in an in-memory structure.

But for now this patch looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
