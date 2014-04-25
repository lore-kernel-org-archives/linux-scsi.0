From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/1] random vs blk-mq
Date: Fri, 25 Apr 2014 08:18:47 -0600
Message-ID: <535A6EC7.10305@kernel.dk>
References: <20140425073610.GA2143@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140425073610.GA2143@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/25/2014 01:36 AM, Christoph Hellwig wrote:
> A tester found out that we need add_disk_randomness for my scsi-mq
> branch.  The patch applied exports add_disk_randomness so that modular
> scsi still works with a driver that either uses the low-level I/O
> completion routines for the old block layer, or blk-mq, and I'd love
> to get this in through Jens' tree which has all the other block work
> scsi-mq requires.
> 
> But this also brings up an interesting question:  blk-mq currently
> does not set QUEUE_FLAG_ADD_RANDOM in the default queue flags, so
> simply converting a driver to blk-mq will mean it stops contributing
> to the random pool.  Do we need a more fine grained way to control
> this, especially for SCSI?

Or, we could just fix the horribly slow pool mix and have it always be
on if it's "free", or almost free. Perhaps just default to on for
rotating devices, that'd lessen the impact.

-- 
Jens Axboe
