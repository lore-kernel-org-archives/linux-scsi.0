From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi_debug: Use scsi-mq if it has been enabled
Date: Fri, 26 Jan 2018 08:58:37 +0100
Message-ID: <20180126075837.GF2356@lst.de>
References: <20180124003958.3945-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41745 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751852AbeAZH6j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Jan 2018 02:58:39 -0500
Content-Disposition: inline
In-Reply-To: <20180124003958.3945-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>

On Tue, Jan 23, 2018 at 04:39:58PM -0800, Bart Van Assche wrote:
> Since we want to remove the single queue code from the SCSI core
> at the appropriate time and since scsi-mq performs better than
> scsi-sq even when using only a single hardware queue, use scsi-mq
> if it has been enabled.

scsi_debug already always uses scsi-mq if enabled.  The somewhat
misnamed sdebug_mq_active variable is only used for decoding
multiqueue tags.  That being said the blk_mq_unique_tag* helpers
should be safe to use even without blk-mq, so the variable could
probably just be removed entirely.
