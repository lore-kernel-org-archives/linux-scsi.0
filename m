From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: sym53c8xx: 'echo "scsi dump 1" > /proc/scsi/scsi' generates an oops
Date: Wed, 29 May 2002 10:44:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020529104451.A5229@eng2.beaverton.ibm.com>
References: <200205272332.g4RNWgi22980@bach.leonora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200205272332.g4RNWgi22980@bach.leonora.org>; from vladimir@acm.org on Mon, May 27, 2002 at 04:32:42PM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Cc: linux-scsi@vger.kernel.org

On Mon, May 27, 2002 at 04:32:42PM -0700, Vladimir G. Ivanovic wrote:
> The command 
> 
>     echo "scsi dump 1" > /proc/scsi/scsi
> 
> generated an oops (syslog entries appended) on my SMP machine running a
> 2.4.18 custom kernel derived from Red Hat's 2.4.18-4 kernel. My SCSI
> controller is an sym53c1010-33, and its driver is
> sym53c8xx-1.7.3c-20010512. 
> 
> Is this (1) operator error, (2) a high/mid/low-level SCSI problem, or
> (3) some other kind of kernel problem that should be reported on the
> linux-kernel list?
> 
> If some more information is needed, please let me know.
> 
> Thanks. 
> 
> --- Vladimir
> 
> P.S. I know, if it hurts, don't do that. ;-)

It's a mid layer SCSI bug, it improperly references the queue:

	queue_head = &blk_dev[i].request_queue.queue_head;

It should really be something like:

	queue_head = SDpnt->request_queue;

Better yet the code should be deleted, as it is also dumping all queues for
each Scsi_Device. The code is gone in the current 2.5.x.

-- Patrick Mansfield
