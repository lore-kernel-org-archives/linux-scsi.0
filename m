From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 32-bit bug in iovec iterator changes
Date: Sat, 21 Jun 2014 06:53:07 +0100
Message-ID: <20140621055306.GP18016@ZenIV.linux.org.uk>
References: <20140619153550.GA12836@thunk.org>
 <53A308DE.7080000@fb.com>
 <20140619160801.GB4907@thunk.org>
 <20140619162144.GC4907@thunk.org>
 <20140619223820.GN4453@dastard>
 <20140621035144.GA8526@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:47628 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaFUFxQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Jun 2014 01:53:16 -0400
Content-Disposition: inline
In-Reply-To: <20140621035144.GA8526@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 20, 2014 at 11:51:44PM -0400, Theodore Ts'o wrote:
> On Fri, Jun 20, 2014 at 08:38:20AM +1000, Dave Chinner wrote:
> > 
> > Short reads are more likely a bug in all the iovec iterator stuff
> > that got merged in from the vfs tree. ISTR a 32 bit-only bug in that
> > stuff go past in to do with not being able to partition a 32GB block
> > dev on a 32 bit system due to a 32 bit size_t overflow somewhere....
> 
> Dave Chinner called it.  
> 
> Al, I'm seeing a regression which shows up using a 32-bit x86 kernel.
> The symptoms of the bug is when run under KVM, with a 5 GB /dev/vdc
> virtual block device, a read at offset 2 ** 30 fails with a short
> read:
> 
> # dd if=/dev/vdc of=/dev/null bs=4k skip=262144 count=1
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.0164144 s, 0.0 kB/s

Argh...

ed include/linux/uio.h <<EOF
/iov_iter_truncate/s/size_t/u64/
w
q
EOF

Could you check if that fixes the sucker?
