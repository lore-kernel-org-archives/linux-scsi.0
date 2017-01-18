From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] nvme: use blk_rq_payload_bytes
Date: Wed, 18 Jan 2017 10:09:21 +0100
Message-ID: <20170118090921.GA24058@lst.de>
References: <1484306953-3194-1-git-send-email-hch@lst.de> <1484306953-3194-4-git-send-email-hch@lst.de> <7532e18a-6cd3-294f-085d-e1ecdc48af6e@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42615 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751354AbdARJJX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Jan 2017 04:09:23 -0500
Content-Disposition: inline
In-Reply-To: <7532e18a-6cd3-294f-085d-e1ecdc48af6e@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Dexuan Cui <decui@microsoft.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Tue, Jan 17, 2017 at 10:06:51PM +0200, Sagi Grimberg wrote:
>
>> @@ -1014,9 +1013,9 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
>>  	}
>>
>
> Christoph, a little above here we still look at blk_rq_bytes(),
> shouldn't that look at blk_rq_payload_bytes() too?

The check is ok for now as it's just zero vs non-zero.  It's somewhat
broken for Write Zeroes, though.  I've fixed it in this series
which I need to submit:

	http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/write-zeroes-take-2
