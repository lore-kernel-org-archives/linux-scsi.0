From: Keith Busch <keith.busch@intel.com>
Subject: Re: [Lsf] [LSF/MM TOPIC] block-mq issues with FC
Date: Fri, 8 Apr 2016 18:06:21 +0000
Message-ID: <20160408180621.GA6110@localhost.localdomain>
References: <57079616.4000202@suse.de>
 <20160408174006.GI2781@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:18964 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbcDHSGX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 14:06:23 -0400
Content-Disposition: inline
In-Reply-To: <20160408174006.GI2781@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Hannes Reinecke <hare@suse.de>, lsf@lists.linux-foundation.org, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Fri, Apr 08, 2016 at 01:40:06PM -0400, Matthew Wilcox wrote:
>  - Inability to use all queues supported by a device.  Intel's P3700
>    supports 31 queues, but block-mq insists on assigning an even multiple
>    of CPUs to each queue.  So if you have 48 CPUs, it will use 24 queues.
>    If you have 128 CPUs, it will only use 16 of the queues.

While it'd be better to use all the available h/w resources, that's
actually not the worst part.

The real problems occur when there are more physical/unique CPUs than
h/w queues since blk-mq does not consider CPU topology beyond thread
siblings. With 128 CPUs, blk-mq may use all 31 queues P3700 supports,
but many CPU groups won't share a last-level-cache.

Smarter assignment would reclaim some untapped performance, and we can
share such code prior to the session.
