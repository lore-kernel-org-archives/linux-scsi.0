From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/35 v3] eparate operations from flags in the
 bio/request structs
Date: Mon, 18 Jan 2016 10:15:47 -0800
Message-ID: <20160118181547.GA30789@infradead.org>
References: <1452543693-4440-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452543693-4440-1-git-send-email-mchristi@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: mchristi@redhat.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

The whole sries looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

There are a few pieces of future work on top of this I'd rather see
sooner than later though:

 - use REQ_OP_FLUSH for all empty flushes, including those at the bio
   level.
 - merge the req->cmd_type values into req->op.  Right now that's
   basically only a new REQ_OP_BLOCK_PC (or better REQ_OP_SCSI while
   we're at it) and a REQ_OP_DRV_PRIV as the last value.
 - drop as many of the crazy defines based on REQ_* in fs.h (e.g.
   (READ_SYNC, WRITE_SYNC, WRITE_ODIRECT, WRITE_FLUSH, WRITE_FUA,
   WRITE_FLUSH_FUA, RW_MASK, RWA_MASK)
