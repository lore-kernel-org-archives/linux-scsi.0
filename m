From: Jan Kara <jack@suse.cz>
Subject: Re: dramatic I/O slowdown after upgrading 2.6.38->3.0+
Date: Wed, 11 Apr 2012 20:28:22 +0200
Message-ID: <20120411182822.GD16008@quack.suse.cz>
References: <4F75E46E.2000503@msgid.tls.msk.ru>
 <20120405232913.GA6640@quack.suse.cz>
 <4F7E74F4.90604@msgid.tls.msk.ru>
 <20120410022628.GN18323@dastard>
 <4F83CC86.2010805@msgid.tls.msk.ru>
 <20120410151326.GA4936@quack.suse.cz>
 <4F855173.40902@msgid.tls.msk.ru>
 <4F85BD2F.80905@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F85BD2F.80905@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed 11-04-12 12:19:43, Mike Christie wrote:
> On 04/11/2012 04:40 AM, Michael Tokarev wrote:
> > On 10.04.2012 19:13, Jan Kara wrote:
> >> > On Tue 10-04-12 10:00:38, Michael Tokarev wrote:
> > []
> >>> >>   2.6.38:
> >>> >>   # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
> >>> >>   100+0 records in
> >>> >>   100+0 records out
> >>> >>   104857600 bytes (105 MB) copied, 1.73126 s, 60.6 MB/s
> >>> >>
> >>> >>   3.0:
> >>> >>   # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
> >>> >>   100+0 records in
> >>> >>   100+0 records out
> >>> >>   104857600 bytes (105 MB) copied, 29.4508 s, 3.6 MB/s
> >>> >>
> >>> >> That's about 20 times difference on direct read from the
> >>> >> same - idle - device!!
> >> >   Huh, that's a huge difference for such a trivial load. So we can rule out
> >> > filesystems, writeback, mm. I also wouldn't think it's IO scheduler but
> >> > you can always check by comparing dd numbers after
> >> >   echo none >/sys/block/sdb/queue/scheduler
> 
> Did you try newer 3.X kernels or just 3.0?
> 
> We were hitting a similar problem with iscsi. Same workload and it
> started with 2.6.38. I think it turned out to be this issue:
> 
> // thread with issue like what we hit:
> http://thread.gmane.org/gmane.linux.kernel/1244680
> 
> // Patch that I think fixed issue:
> commit 3deaa7190a8da38453c4fabd9dec7f66d17fff67
> Author: Shaohua Li <shaohua.li@intel.com>
> Date:   Fri Feb 3 15:37:17 2012 -0800
> 
>     readahead: fix pipeline break caused by block plug
  I already asked about this but that doesn't seem to be the cause.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
