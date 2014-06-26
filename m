From: Bruno Wolff III <bruno@wolff.to>
Subject: Re: [regression] fix 32-bit breakage in block device read(2) (was
 Re: 32-bit bug in iovec iterator changes)
Date: Thu, 26 Jun 2014 10:27:19 -0500
Message-ID: <20140626152719.GA15967@wolff.to>
References: <20140621055306.GP18016@ZenIV.linux.org.uk>
 <20140621230922.GA13188@thunk.org>
 <20140621234913.GQ18016@ZenIV.linux.org.uk>
 <1403395400.2592.4.camel@jarvis.lan>
 <20140622002618.GR18016@ZenIV.linux.org.uk>
 <1403397164.2177.40.camel@dabdike.int.hansenpartnership.com>
 <20140622005352.GS18016@ZenIV.linux.org.uk>
 <20140622010032.GT18016@ZenIV.linux.org.uk>
 <20140622115007.GA5333@thunk.org>
 <20140623074440.GV18016@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140623074440.GV18016@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 23, 2014 at 08:44:40 +0100,
  Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
>blkdev_read_iter() wants to cap the iov_iter by the amount of
>data remaining to the end of device.  That's what iov_iter_truncate()
>is for (trim iter->count if it's above the given limit).  So far,
>so good, but the argument of iov_iter_truncate() is size_t, so on
>32bit boxen (in case of a large device) we end up with that upper
>limit truncated down to 32 bits *before* comparing it with iter->count.

This seems to fix a problem I had 
(https://bugzilla.kernel.org/show_bug.cgi?id=78711) with a partition device 
(/dev/sda3) being zero size on 3.16 kernels. However I am having some 
other issues with 3.16 on i686 and the amount of testing was the raid 
array using /dev/sda3 appeared to start (which it hadn't previously), but 
the system hung before finishing the boot process.
