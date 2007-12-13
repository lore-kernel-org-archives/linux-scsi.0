From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
Date: Thu, 13 Dec 2007 11:42:21 -0700
Message-ID: <20071213184221.GP26334@parisc-linux.org>
References: <47617B92.6020908@rtr.ca> <47617C07.3020501@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47617C07.3020501@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 13, 2007 at 01:37:59PM -0500, Mark Lord wrote:
> The problem is, the block layer *never* sends an SG entry larger than 8192 
> bytes,
> and even that size is exceptionally rare.  Nearly all I/O segments are 4096 
> bytes,
> so I never see a single I/O larger than 512KB (128 * 4096).
> 
> If I patch various parts of block and SCSI, this limit doesn't budge,
> but when I change the hardware PRD limit in libata, it scales by exactly
> whatever I set the new value to.  This tells me that adjacent I/O segments
> are not being combined.
> 
> I thought that QUEUE_FLAG_CLUSTER (aka. SCSI host .use_clustering=1) should
> result in adjacent single pages being combined into larger physical 
> segments?

I was recently debugging a driver and noticed that consecutive pages in
an sg list are in the reverse order.  ie first you get page 918, then
917, 916, 915, 914, etc.  I vaguely remember James having patches to
correct this, but maybe they weren't merged?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
