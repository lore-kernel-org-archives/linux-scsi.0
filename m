From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: mq queue stall during command requeue
Date: Thu, 19 Jan 2017 15:46:51 +0100
Message-ID: <20170119144651.GA31548@lst.de>
References: <1484835465-66514-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57742 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753986AbdASSYy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Jan 2017 13:24:54 -0500
Content-Disposition: inline
In-Reply-To: <1484835465-66514-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, Jan 19, 2017 at 03:17:45PM +0100, Hannes Reinecke wrote:
> When we're hitting a busy condition in queuecommand() we need to
> stop the hardware queue before calling blk_mq_delay_queue(); if
> we don't blk_mq_delay_queue() will not do anything and requeue
> will never triggered.

I suspect the stop needs to move into blk_mq_delay_queue to make
it more useful.
