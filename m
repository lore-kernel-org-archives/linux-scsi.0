From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fixes defect with kernel BUG using multipath on 2.6.0-test5
Date: Sat, 27 Sep 2003 10:33:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030927083303.GE3416@suse.de>
References: <1064541435.4763.51.camel@persist.az.mvista.com> <20030926121703.GG24824@parcelfarce.linux.theplanet.co.uk> <20030926122646.GA15415@suse.de> <1064607249.4779.1.camel@persist.az.mvista.com> <1064622862.4779.38.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1064622862.4779.38.camel@persist.az.mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: neilb@cse.unsw.edu.au, Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 26 2003, Steven Dake wrote:
> Folks,
> Thanks Matt and Jens for the debug help on the multipath problem.  I now
> have a patch (attached) which solves the problem and makes multipath
> work properly.   There are two types of "flags" that are used in a block
> io request, bi_flags, and bi_rw.  bi_flags is used for flags to the
> block level code, and bi_rw is used for flags to the low level device
> drivers.  The code in the multipath driver used the wrong flag in the
> wrong field.  In this case, the flag FASTFAIL (value 3) was being set to
> the bi_flags field.  FASTFAIL is a hint to the low level driver that it
> should try to fail out quickly.  Unfortunately, the value 3 is also
> BIO_SEG_VALID, which is a flag to the block subsystem that the segments
> shouldn't be recalculated.  The result was that the wrong field was set,
> telling the block layer not to recalculate the segments resulting in
> phys and hw segments of 0.  Not good.
> 
> Neil can you send upstream ?

Auch good catch! I'm sorry to say this is actually my fault...

-- 
Jens Axboe
