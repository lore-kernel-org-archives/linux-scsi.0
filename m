From: "jack wang" <jack_wang@usish.com>
Subject: Re: [PATCH 1/3] block: add blk-iopoll, a NAPI like approach forblock  devices
Date: Thu, 20 Aug 2009 19:30:49 +0800
Message-ID: <B021CBAD133A4E45A4BF6E6BDFDCA28F@usish.com.cn>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com> <1249588685-4662-2-git-send-email-jens.axboe@oracle.com> <20090806223257.0c33cf15@lxorguk.ukuu.org.uk> <20090807063745.GQ12579@kernel.dk> <4A7BE80A.6080808@garzik.org> <20090807085004.GV12579@kernel.dk> <20090807110517.GW12579@kernel.dk> <20090807113146.GX12579@kernel.dk> <20090819190804.GP12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53660 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZHTLba (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 07:31:30 -0400
In-Reply-To: <20090819190804.GP12579@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Jens Axboe' <jens.axboe@oracle.com>, 'Jeff Garzik' <jeff@garzik.org>
Cc: 'Alan Cox' <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

On Fri, Aug 07 2009, Jens Axboe wrote:
> On Fri, Aug 07 2009, Jens Axboe wrote:
> > On Fri, Aug 07 2009, Jens Axboe wrote:
> > > > I'm not NAK'ing...  just inserting some relevant NAPI field
experience,  
> > > > and hoping for some numbers that better measure the costs/benefits.
> > > 
> > > Appreciate you looking over this, and I'll certainly be posting some
> > > more numbers on this. It'll largely depend on both storage,
controller,
> > > and worload.
> > 
> > Here's a quick set of numbers, beating with random reads on a drive.
> > Average of three runs for each, stddev is very low so confidence in the
> > numbers should be high.
> > 
> > With iopoll=0 (disabled), stock:
> > 
> > blocksize       IOPS    ints/sec        usr     sys
> > ------------------------------------------------------
> > 4k              48401   ~30500          3.36%   27.26%
> > 
> > clat (usec): min=1052, max=21615, avg=10541.48, stdev=243.48
> > clat (usec): min=1066, max=22040, avg=10543.69, stdev=242.05
> > clat (usec): min=1057, max=23237, avg=10529.04, stdev=239.30
> > 
> > 
> > With iopoll=1
> > 
> > blocksize       IOPS    ints/sec        usr     sys
> > ------------------------------------------------------
> > 4k              48452   ~29000          3.37%   26.47%
> > 
> > 
> > clat (usec): min=1178, max=21662, avg=10542.72, stdev=247.87
> > clat (usec): min=1074, max=21783, avg=10534.14, stdev=240.54
> > clat (usec): min=1102, max=22123, avg=10509.42, stdev=225.73
> 
> Lets raise the bar a bit, this time using 8k reads on the faster box.
> 
> iopoll=0
> 
> blocksize       IOPS    ints/sec        usr     sys
> ------------------------------------------------------
> 8k              64050   ~76000          4.12%   45.01%
> 
> clat (usec): min=1326, max=18994, avg=7967.54, stdev=214.12
> clat (usec): min=1325, max=25404, avg=7968.06, stdev=239.87
> clat (usec): min=1273, max=21414, avg=7963.43, stdev=231.27
> 
> 
> iopoll=1
> 
> blocksize       IOPS    ints/sec        usr     sys
> ------------------------------------------------------
> 8k              64162   ~55000          4.07%   42.32%
> 
> clat (usec): min=1380, max=19681, avg=7960.31, stdev=197.41
> clat (usec): min=1370, max=37508, avg=7954.61, stdev=210.35
> clat (usec): min=1332, max=23383, avg=7947.99, stdev=209.60
> 
> Again, purely a synthetic IO benchmark, but the sys reduction is
> interesting.

Upping the ante a bit more, this time on a really fast box. Just to show
that iopoll works well even on just about the fastest CPU you can throw
at it.

iopoll=0

blocksize       IOPS    ints/sec        usr     sys
------------------------------------------------------
8k              64823   ~67000          4.75%   13.41%

clat (usec): min=1430, max=15770, avg=7880.60, stdev=118.95
clat (usec): min=1249, max=17810, avg=7887.34, stdev=120.39
clat (usec): min=1729, max=15473, avg=7888.13, stdev=118.70


iopoll=1

blocksize       IOPS    ints/sec        usr     sys
------------------------------------------------------
8k              64825   ~65000         4.37%   11.39%

clat (usec): min=1530, max=15195, avg=7910.01, stdev=111.43
clat (usec): min=1495, max=16180, avg=7885.11, stdev=115.56
clat (usec): min=1446, max=19733, avg=7890.46, stdev=139.05

-- 
Jens Axboe


Hi Jens
Could you tell me what tool do you use to get the IO benchmark?  
Thanks
Jack Wang
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

