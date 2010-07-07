From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] block: push down BKL into .open and .release
Date: Tue, 6 Jul 2010 21:50:00 -0400
Message-ID: <20100707015000.GC2950@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
 <1278193640-24223-3-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1278193640-24223-3-git-send-email-arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I might be missing something, but this doesn't actually push the
BKL anyway.  It adds duplicate BKL locking inside the ->open and
->release methods without actually removing it in the callers.

That's a pretty pointless thing to do.  If you're not feeling
confident enough about touching block_dev.c I can look into that
part of the pushdown, but this patch on it's own is not actually
useful.

