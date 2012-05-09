From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Wed, 9 May 2012 07:12:43 -0400
Message-ID: <20120509111243.GB29593@infradead.org>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <4FAA02DA.3000201@gmail.com>
 <20120509061956.GA12329@gmail.com>
 <20120509082527.GA10674@infradead.org>
 <20120509093016.GA12754@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120509093016.GA12754@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 09, 2012 at 05:30:16PM +0800, Zheng Liu wrote:
> IMHO, FUA provides a solution that we can get better performance in write
> cache mode when we do many flush operations.  If I set the disk to write
> through mode, I won't get this benefit.  Am I missing something?

If you set the disk to write through mode you never have to flush the
cache.  So as soonas your number of flushes gets close to the number of
writes it tends to be a clear win - for ATA the tradeoff is even more in
favour of write through because the flush command can't be queued yetin
commonly available standards versions.  So if you have a workload that
basically needs to flush out every write you win - if you have workloads
where you have a lot more writes than cache flushes write back mode
wins.

> Currently, the key issue is that we disable FUA detection for SATA disk.
> We almost have no chance to change it because it is too complicated to
> set libata_fua variable when this module is loaded.  So why not give
> SATA disk an opportunity to enable this feature?  After all, there is a
> lot of SATA disks that support this feature.

I'm all in favour of your patch, I just wanted to point out that the
argument in the description wasn't quite correct.
