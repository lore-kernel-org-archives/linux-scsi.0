From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Wed, 9 May 2012 17:30:16 +0800
Message-ID: <20120509093016.GA12754@gmail.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <4FAA02DA.3000201@gmail.com>
 <20120509061956.GA12329@gmail.com>
 <20120509082527.GA10674@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120509082527.GA10674@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 09, 2012 at 04:25:27AM -0400, Christoph Hellwig wrote:
> On Wed, May 09, 2012 at 02:19:56PM +0800, Zheng Liu wrote:
> > disable FUA detection for SATA disk.  If FUA feature can be used, we
> > could disable io_barrier to improve the performance.  Now one solution
> 
> You can't run with -o nobarrier just because the driver/hardware support
> FUA.  However the implementation of -o barrier (aka REQ_FUA) is a lot
> more efficient if it is implemented.  If your workload has a high
> percentage of REQ_FUA requests it might be better to switch the disks to
> write through mode entirely.

Thanks for your advice.  Indeed, it is more efficient when data is
flushed with REQ_FUA, and this is the reason why I submit this patch.
IMHO, FUA provides a solution that we can get better performance in write
cache mode when we do many flush operations.  If I set the disk to write
through mode, I won't get this benefit.  Am I missing something?

Currently, the key issue is that we disable FUA detection for SATA disk.
We almost have no chance to change it because it is too complicated to
set libata_fua variable when this module is loaded.  So why not give
SATA disk an opportunity to enable this feature?  After all, there is a
lot of SATA disks that support this feature.

Regards,
Zheng
