From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [RFC] relaxed barrier semantics
Date: Tue, 03 Aug 2010 01:47:22 +0900 (JST)
Message-ID: <20100803.014722.208373518.ryusuke@osrg.net>
References: <20100728090025.GA9252@lst.de>
	<4C4FF592.9090800@kernel.org>
	<20100728092859.GA11096@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44361 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab0HBQw2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Aug 2010 12:52:28 -0400
In-Reply-To: <20100728092859.GA11096@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Wed, 28 Jul 2010 11:28:59 +0200, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Jul 28, 2010 at 11:17:06AM +0200, Tejun Heo wrote:
> > I'll re-read barrier code and see how hard it would be to implement a
> > proper solution.
> 
> If we move all filesystems to non-draining barriers with pre- and post-
> flushes that might actually be a relatively easy first step.  We don't
> have the complications to deal with multiple types of barriers to
> start with, and it'll fix the issue for devices without volatile write
> caches completely.
> 
> I just need some help from the filesystem folks to determine if they
> are safe with them.
> 
> I know for sure that ext3 and xfs are from looking through them.  And
> I know reiserfs is if we make sure it doesn't hit the code path that
> relies on it that is currently enabled by the barrier option.
> 
> I'll just need more feedback from ext4, gfs2, btrfs and nilfs folks.

With regard to nilfs, barrier is applied to writeback of super block
since it saves position of a recent log and this log needs to be
written to the platter prior to the super block.

And so, I think a pre-flush + a FUA write can be used instead of
draining for the barrier use in nilfs.

Thanks,
Ryusuke Konishi
