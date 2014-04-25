From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/1] random vs blk-mq
Date: Fri, 25 Apr 2014 00:36:10 -0700
Message-ID: <20140425073610.GA2143@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A tester found out that we need add_disk_randomness for my scsi-mq
branch.  The patch applied exports add_disk_randomness so that modular
scsi still works with a driver that either uses the low-level I/O
completion routines for the old block layer, or blk-mq, and I'd love
to get this in through Jens' tree which has all the other block work
scsi-mq requires.

But this also brings up an interesting question:  blk-mq currently
does not set QUEUE_FLAG_ADD_RANDOM in the default queue flags, so
simply converting a driver to blk-mq will mean it stops contributing
to the random pool.  Do we need a more fine grained way to control
this, especially for SCSI?
