From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] mpt2sas: store scsi io tracker data in the scsi
	request
Date: Mon, 13 Apr 2015 11:49:44 +0200
Message-ID: <20150413094944.GE5259@lst.de>
References: <1428427120-20971-1-git-send-email-axboe@fb.com> <1428427120-20971-5-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428427120-20971-5-git-send-email-axboe@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 07, 2015 at 11:18:38AM -0600, Jens Axboe wrote:
> Instead of storing the IO tracker structure in a separate list
> that we need to pop/push to on every submit and complete (and
> lock), store it in the pdu associated with a request. This is
> possible on scsi-mq only, and further cuts the spinlock associated
> time for higher IOPS IO workloads. At 100K IOPS, this effectively
> cuts the locking time in half.

As mentioned before please call scsi_init_shared_tag_map and use your
new code path for the !mq case as well.
