From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/7] Make DISCARD_BARRIER and DISCARD_NOBARRIER writes
 instead of reads
Date: Thu, 03 Sep 2009 18:52:20 +0100
Message-ID: <1252000340.4483.529.camel@macbook.infradead.org>
References: <20090829230332.017137693@bombadil.infradead.org>
	 <20090829231121.144124147@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090829231121.144124147@bombadil.infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, Matthew Wilcox <willy@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2009-08-29 at 19:03 -0400, Christoph Hellwig wrote:
> 
> The commands are conceptually writes, and in the case of IDE and SCSI
> commands actually are writes.  They were only reads because we thought
> that would interact better with the elevators.  Now the elevators know
> about discard requests, that advantage no longer exists.

Can you drop the final sentence of that? It isn't true, and I never said
it.

s/.  Now.*/, but that isn't necessary, and making them writes makes it
easier for the low-level IDE and SCSI code to cope with the fact that
the command has to be sent with a payload./


The elevators _still_ don't know about discards, and will still let
reads and writes (and discards, which are just a special case of writes)
to the same sector all cross each other on the queue unless there's some
external factor to prevent it.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

