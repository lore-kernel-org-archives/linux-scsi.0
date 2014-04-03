From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] blk-mq: support for shared tags
Date: Thu, 3 Apr 2014 09:36:31 +0200
Message-ID: <20140403073631.GA26921@lst.de>
References: <1396277175-21382-1-git-send-email-hch@lst.de> <533B56D5.5070803@bjorling.me> <20140402074632.GA11359@lst.de> <533CDF24.9030902@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <533CDF24.9030902@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Matias Bjorling <m@bjorling.me>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 02, 2014 at 09:10:12PM -0700, Matias Bjorling wrote:
> For the nvme driver, there's a single admin queue, which is outside
> blk-mq's control, and the X normal queues. Should we allow the shared
> tags structure to be used (get/put) for the admin queue, without
> initializing blk-mq? or should the drivers simply implement their own
> tags for their admin queue?

I'd still create a request_queue for the internal queue, just not register
a block device for it.  For example SCSI sets up queues for each LUN
found, but only a subset actually is exposed as a block device.
