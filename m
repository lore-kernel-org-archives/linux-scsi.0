From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH 02/35] block: add REQ_OP definitions and
 bi_op/op fields
Date: Sat, 9 Jan 2016 23:15:58 -0800
Message-ID: <20160110071558.GB12831@infradead.org>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
 <1452027218-32303-3-git-send-email-mchristi@redhat.com>
 <20160109133716.GB26660@infradead.org>
 <5691AC2E.2050403@cs.wisc.edu>
 <5691B208.9060001@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5691B208.9060001@cs.wisc.edu>
Sender: linux-bcache-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, mchristi@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, ocfs2-devel@oss.oracle.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 09, 2016 at 07:21:12PM -0600, Mike Christie wrote:
> Oh yeah, to answer the second part of your question, REQ_OP_FLUSH is
> only a flush operation like what request_fn drivers wanted.

And that's the odd part that trips me up.

> 
> REQ_PREFLUSH can be set with a REQ_OP_WRITE bio when filesystems want to
> do both.
> 
> There is then the case where filesystems and blkdev_issue_flush could
> just want to request a flush. I left them as a REQ_PREFLUSH with
> REQ_OP_WRITE set, so there would be a single code path.

But the pure flush without data transfer case is pretty different,
so it seems rather odd to handle it like that.  But I suspec we could
just fix that up later.
