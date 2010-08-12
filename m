From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] BLOCK: fix bio.bi_rw handling
Date: Thu, 12 Aug 2010 18:08:09 +0200
Message-ID: <20100812160809.GC28689@lst.de>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz> <1281616266-4709-3-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1281616266-4709-3-git-send-email-jslaby@suse.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 12, 2010 at 02:31:06PM +0200, Jiri Slaby wrote:
> Return of the bi_rw tests is no longer bool after commit 74450be1. But
> results of such tests are stored in bools. This doesn't fit in there
> for some compilers (gcc 4.5 here), so either use !! magic to get real
> bools or use ulong where the result is assigned somewhere.

I'd have to look at my copy of the C standard if it's guaranteed, but
at least currently the values just get truncated down and bool still
is set to true.  I'd much prefer just making these flags unsigned longs
instead of adding syntactic surage to make them true bools.

