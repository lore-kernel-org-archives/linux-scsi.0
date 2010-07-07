From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/6] block: push BKL into blktrace ioctls
Date: Wed, 7 Jul 2010 15:46:53 +0200
Message-ID: <201007071546.53922.arnd@arndb.de>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-4-git-send-email-arnd@arndb.de> <20100707015036.GD2950@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100707015036.GD2950@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 07 July 2010, Christoph Hellwig wrote:
> On Sat, Jul 03, 2010 at 11:47:17PM +0200, Arnd Bergmann wrote:
> > The blktrace driver currently needs the BKL, but
> > we should not need to take that in the block layer,
> > so just push it down into the driver itself.
> 
> Does blktrace actually need it?  Anyway, pushing it down is a good
> start.

I'm rather sure that the blktrace code does not need the BKL
specifically, but it probably needs some form of serialization.
Most of the blktrace code holds both the BKL and bdev->bd_mutex,
so the right solution is probably to remove the BKL and rely
on bd_mutex.

It should be straightforward to do for anyone who understands
the blktrace code.

	Arnd
