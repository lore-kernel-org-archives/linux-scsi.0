From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport
        requeues
Date: Wed, 4 Oct 2017 09:20:59 +0200
Message-ID: <20171004072059.GA21411@lst.de>
References: <20171003104845.10417-1-hch@lst.de> <20171003104845.10417-10-hch@lst.de> <mqd7ewbidos.fsf@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48061 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750951AbdJDHVB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Oct 2017 03:21:01 -0400
Content-Disposition: inline
In-Reply-To: <mqd7ewbidos.fsf@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

On Wed, Oct 04, 2017 at 09:18:11AM +0200, Johannes Thumshirn wrote:
> Wouldn't it make sense to put the ->release() method into bsg_ops as
> well? The current prototype of bsg_register_queue isn't exactly what I
> would call a sane API.

It's a different level of callback - ops are the type of request
passed through (scsi vs transport) and ->release is s whacky
implementation detail of the SAS passthrough.  If at all ->release
should go away eventually by cleaning that mess up.
