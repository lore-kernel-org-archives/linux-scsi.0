From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 14:27:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015142733.A2611@eng2.beaverton.ibm.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <3DAC7A05.31B17A39@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DAC7A05.31B17A39@splentec.com>; from luben@splentec.com on Tue, Oct 15, 2002 at 04:26:45PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Oct 15, 2002 at 04:26:45PM -0400, Luben Tuikov wrote:

> Re. bashing the too large a number of tags allowed -- this actually
> makes sense sometimes -- e.g. an iSCSI Initiator wants to have
> as many tagged commands under its control rather than they
> be waiting in SCSI core. If the mid layer has a problem with
> a scsi tagged command, then it can notify the LLDD and it
> will resolve this (*** please see my next Q. posting ***).
> 
> Statements like this: ``The queue depth should be as small as
> possible without limiting the performance.'' cannot be generalized
> to all devices, be it hardware or software emulations (YKWIM).
> 

I'm saying don't set the queue depth really high when it gives no or
very little performance gain. If an adapter driver finds that a large
queue depth helps more than it hurts for all IO loads (for sequential
as well as random IO), go ahead, but I would guess that queue depths over
100 give zero or very little performance gain compared to a queue depth
of say 50 for most devices. I was trying to run some tests on this
in the past but never had time to get it working well, plus it would have
been for only two different devices (disk and disk array), and the
drives I have are not really fast (20 mb/sec for disk, about 50mb/sec for
the disk array).

What is really needed are IO performance numbers for varying queue depths.

With 2.5, the number of commands outstanding to the device is not
subtracted from the blk request queue size (we don't release a blk request
until the IO is completed, there is no call to blkdev_release_request in
scsi_request_fn) - this means large queue depths will cause the blk request
queue to fill up and even be full without any available blk request queue
commands to merge or sort with.

There are also issues like Andrew had with the read latency - although
his benchmark is aritificial, and has more to do with too many dirty
pages, it still showed that higher queue depths can have an impact
on interactive performance (i.e. read latencies).

-- Patrick Mansfield
