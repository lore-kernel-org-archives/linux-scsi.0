From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing
 file transfers
Date: Fri, 27 Sep 2002 07:30:55 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <389902704.1033133455@aslan.scsiguy.com>
References: <20020927074509.GA860@suse.de>
 <Pine.BSF.4.21.0209270055290.18408-100000@beppo>
 <20020927102503.GA15101@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020927102503.GA15101@suse.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>
Cc: "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> The starvation I'm talking about is the drive starving requests. Just
> keep it moderately busy (10-30 outstanding tags), and a read can take a
> long time to complete.

As I tried to explain to Andrew just the other day, this is neither a
drive nor HBA problem.  You've essentially constructed a benchmark where
a single process can get so far ahead of the I/O subsystem in terms of
buffered writes that there is no choice but for there to be a long delay
for the device to handle your read.  Consider that because you are queuing,
the drive will completely fill its cache with write data that is pending
to hit the platters.  The number of transactions in the cache is marginally
dependant on the number of tags in use since that will affect the ability
of the controller to saturate the drive cache with write data.  Depending
on your drive, mode page settings, etc, the drive may allow your read to
pass the write, but many do not.  So you have to wait for the cache to
at least have space to handle your read and perhaps have even additional
write data flush before your read can even be started.  If you don't like
this behavior, which actually maximizes the throughput of the device, have
the I/O scheduler hold back a single processes from creating such a large
backlog.  You can also read the SCSI spec and tune your disk to behave
differently.

Now consider the read case.  I maintain that any reasonable drive will
*always* outperform the OS's transaction reordering/elevator algorithms
for seek reduction.  This is the whole point of having high tag depths.
In all I/O studies that have been performed todate, reads far outnumber
writes *unless* you are creating an ISO image on your disk.  In my opinion
it is much more important to optimize for the more common, concurrent
read case, than it is for the sequential write case with intermittent
reads.  Of course, you can fix the latter case too without any change to
the driver's queue depth as outlined above.  Why not have your cake and
eat it too?

--
Justin
