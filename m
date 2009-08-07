From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] block: add blk-iopoll, a NAPI like approach for
	block devices
Date: Fri, 7 Aug 2009 08:37:45 +0200
Message-ID: <20090807063745.GQ12579@kernel.dk>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com> <1249588685-4662-2-git-send-email-jens.axboe@oracle.com> <20090806223257.0c33cf15@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755596AbZHGGhr@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090806223257.0c33cf15@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, jeff@garzik.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 06 2009, Alan Cox wrote:
> > doing the command completion when the irq occurs, schedule a dedicated
> > softirq in the hopes that we will complete more IO when the iopoll
> > handler is invoked. Devices have a budget of commands assigned, and will
> > stay in polled mode as long as they continue to consume their budget
> > from the iopoll softirq handler. If they do not, the device is set back
> > to interrupt completion mode.
> 
> This seems a little odd for pure ATA except for NCQ commands. Normal ATA
> is notoriously completion/reissue latency sensitive [to the point I
> suspect we should be dequeuing 2 commands from SCSI and loading the next
> in the completion handler as soon as we recover the result task file and
> see no error rather than going up and down the stack)

Yes certainly, it's only for devices that do queuing. If they don't,
then we will always have just the one command to complete. So not much
to poll! As to pre-prep for extra latency intensive devices, have you
tried experimenting with just pretending that non-ncq devices in libata
have a queue depth of 2? That should ensure that the first command
available upon completion of the existing command is already prepped.
Not sure how much time that would save, I would hope that our prep phase
isn't too slow to begin with (or that would be the place to fix :-)

> What do the numbers look like ?

On a slow box (with many cores), the benefits are quite huge:


blocksize       blk-iopoll      IOPS    IRQ/sec         Commands/IRQ
--------------------------------------------------------------------
512b            0               25168   ~19500          1,3
512b            1               30355     ~750          40
4096b           0               25612   ~21500          1,2
4096b           1               30231    ~1200          25

I suspect there's some cache interaction going on here too, but the
numbers do look very good. On a faster box (and different architecture),
on a test that does 50k IOPS, they perform identically but the iopoll
approach uses less CPU. The interrupt rate drops from 55k ints/sec to
39-40k ints/sec for that case.

These are all synthetic IO only benchmarks, I hope to have some numbers
for some mixed benchmarks soon too.

> > This patch holds the core bits for blk-iopoll, device driver support
> > sold separately.
> 
> You've been at Oracle too long ;) You'll be telling me its not a
> supported configuration next.

;-)

-- 
Jens Axboe
