From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] Improve requeuing behavior
Date: Thu, 24 Aug 2017 18:57:04 +0200
Message-ID: <20170824165704.GA28901@lst.de>
References: <20170823210535.1072-1-bart.vanassche@wdc.com> <20170824120944.GB23186@lst.de> <1503591261.2702.9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50730 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753277AbdHXQ5F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 12:57:05 -0400
Content-Disposition: inline
In-Reply-To: <1503591261.2702.9.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>

On Thu, Aug 24, 2017 at 04:14:22PM +0000, Bart Van Assche wrote:
> Commit ca18d6f769d2 ("block: Make most scsi_req_init() calls implicit")
> introduced the scsi_initialize_rq() function in such a way that it is not only
> called for pass-through requests but also for FS requests. Because that commit
> sets .initialize_rq_fn for both blk-sq and blk-mq blk_get_request() now calls
> scsi_initialize_rq() for all SCSI requests. Or did I perhaps overlook something?

initialize_rq_fn is only called from blk_get_request, which is not
called for normal file system read/write/flush/discard request.

Also unless my memory fails me that's something that I and Jens requested
to be changed from your original version.
