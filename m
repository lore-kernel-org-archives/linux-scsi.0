From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Actually using the sg table/chain code
Date: Fri, 22 Feb 2008 10:13:45 -0600
Message-ID: <47BEF4B9.2010401@cs.wisc.edu>
References: <1200412337.9273.28.camel@localhost.localdomain>	 <20080116150645.GE6258@kernel.dk> <1200498475.3136.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59696 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbYBVQOE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 11:14:04 -0500
In-Reply-To: <1200498475.3136.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Yes, I can buy the argument for filesystem I/Os.  What about tapes which
> currently use the block queue and have internal home grown stuff to
> handle larger transfers ... how are they supposed to set the larger
> default sector size?  Just modify the bare q->max_sectors?
> 

Sorry for the late response. I have been doing userspace stuff and not 
keeping up with linux-scsi :(

For scsi tape and passthrough (any place we use REQ_TYPE_BLOCK_PC like 
with st or sg or block/scsi_ioctl or bsg), the block/bio/scatterlist 
building code ignores q->max_sectors and uses q->max_hw_sectors.
