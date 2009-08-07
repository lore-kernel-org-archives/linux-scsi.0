From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] block: add blk-iopoll, a NAPI like approach for
	block  devices
Date: Fri, 7 Aug 2009 13:05:17 +0200
Message-ID: <20090807110517.GW12579@kernel.dk>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com> <1249588685-4662-2-git-send-email-jens.axboe@oracle.com> <20090806223257.0c33cf15@lxorguk.ukuu.org.uk> <20090807063745.GQ12579@kernel.dk> <4A7BE80A.6080808@garzik.org> <20090807085004.GV12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:37002 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308AbZHGLFQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Aug 2009 07:05:16 -0400
Content-Disposition: inline
In-Reply-To: <20090807085004.GV12579@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

On Fri, Aug 07 2009, Jens Axboe wrote:
> > I'm not NAK'ing...  just inserting some relevant NAPI field experience,  
> > and hoping for some numbers that better measure the costs/benefits.
> 
> Appreciate you looking over this, and I'll certainly be posting some
> more numbers on this. It'll largely depend on both storage, controller,
> and worload.

Here's a quick set of numbers, beating with random reads on a drive.
Average of three runs for each, stddev is very low so confidence in the
numbers should be high.

With iopoll=0 (disabled), stock:

blocksize       IOPS    ints/sec        usr     sys
------------------------------------------------------
4k              48401   ~30500          3.36%   27.26%

clat (usec): min=1052, max=21615, avg=10541.48, stdev=243.48
clat (usec): min=1066, max=22040, avg=10543.69, stdev=242.05
clat (usec): min=1057, max=23237, avg=10529.04, stdev=239.30


With iopoll=1

blocksize       IOPS    ints/sec        usr     sys
------------------------------------------------------
4k              48452   ~29000          3.37%   26.47%


clat (usec): min=1178, max=21662, avg=10542.72, stdev=247.87
clat (usec): min=1074, max=21783, avg=10534.14, stdev=240.54
clat (usec): min=1102, max=22123, avg=10509.42, stdev=225.73

The system utilization numbers are significant, I can say that for these
three runs, the iopoll=0 numbers were 27.25%, 27.28%, and 27.26%. For
iopoll=1, they were 26.44%, 26.26%, and 26.36%. The usr numbers were
equally stable. The latencies numbers are too close to call here.


On a slower box, I get:


iopoll=0

blocksize       IOPS    ints/sec        usr     sys
------------------------------------------------------
4k              13100   ~12000          3.37%   19.70%

clat (msec): min=7, max=99, avg=78.32, stdev= 1.89
clat (msec): min=6, max=96, avg=77.00, stdev= 1.89
clat (msec): min=8, max=111, avg=78.27, stdev= 1.84

iopoll=1

blocksize       IOPS    ints/sec        usr     sys
------------------------------------------------------
4k              13745   ~400            3.30%   19.74%


clat (msec): min=8, max=91, avg=73.33, stdev= 1.66
clat (msec): min=7, max=90, avg=72.94, stdev= 1.64
clat (msec): min=6, max=103, avg=73.11, stdev= 1.77

Now, 13K iops isn't very much, so there isn't a huge performance
difference here and system utilization is practically identical. If we
were to hit 100k+ iops, I'm sure things would look different. If you
look at the IO completion latencies, they are actually better. This box
is a bit special, in that the 13k iops is purely limited by the softirq
that runs the completion. The controller only generates irqs on a single
CPU, so the softirqs all happen there (unless you use IO affinity by
setting rq_affinity=1, in which case you can reach 30k IOPS with the
same drive).

Anyway, just a first stack of numbers. Both of these are with using the
mpt sas controller.

-- 
Jens Axboe

