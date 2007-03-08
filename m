From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Thu, 8 Mar 2007 11:35:08 +0100
Message-ID: <20070308103508.GD9671@kernel.dk>
References: <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070307184641.GY20362@kernel.dk> <20070308085209.GB4252@skl-net.de> <20070308090247.GB9671@kernel.dk> <20070308093331.GC4252@skl-net.de> <20070308093651.GC9671@kernel.dk> <20070308102936.GD4252@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:38216 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXCHKgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Mar 2007 05:36:21 -0500
Content-Disposition: inline
In-Reply-To: <20070308102936.GD4252@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

On Thu, Mar 08 2007, Andre Noll wrote:
> On 10:36, Jens Axboe wrote:
> > - Edit .config and set CONFIG_DEBUG_INFO=y (near the bottom)
> > - make oldconfig
> > - rm block/cfq-iosched.o
> > - make block/cfq-iosched.o
> > - gdb block/cfq-iosched.o
> > 
> > (gdb) l *cfq_dispatch_insert+0x28
> > 
> > and see what that says. Should not take you more than a minute or so,
> > would appreciate it!
> 
> No problem, here we go:
> 
> # gdb block/cfq-iosched.o
> GNU gdb 6.4-debian
> Copyright 2005 Free Software Foundation, Inc.
> GDB is free software, covered by the GNU General Public License, and you are
> welcome to change it and/or distribute copies of it under certain conditions.
> Type "show copying" to see the conditions.
> There is absolutely no warranty for GDB.  Type "show warranty" for details.
> This GDB was configured as "x86_64-linux-gnu"...Using host libthread_db library "/lib/libthread_db.so.1".
> 
> (gdb) l *cfq_dispatch_insert+0x28
> 0xcf8 is in cfq_dispatch_insert (block/cfq-iosched.c:865).
> 860     }
> 861
> 862     static void cfq_dispatch_insert(request_queue_t *q, struct request *rq)
> 863     {
> 864             struct cfq_data *cfqd = q->elevator->elevator_data;
> 865             struct cfq_queue *cfqq = RQ_CFQQ(rq);
> 866
> 867             cfq_remove_request(rq);
> 868             cfqq->on_dispatch[rq_is_sync(rq)]++;
> 869             elv_dispatch_sort(q, rq);

Ok, so it's ->next_rq being NULL or invalid. Similar to the report from
Dan last week, that's a bit worrisome. I'll have to look further into
that.

-- 
Jens Axboe

