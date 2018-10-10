From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] sched/wait: Add wait_event_lock_irq_timeout for
 TASK_UNINTERRUPTIBLE usage
Date: Wed, 10 Oct 2018 10:31:27 +0200
Message-ID: <20181010083127.GL5728@hirez.programming.kicks-ass.net>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
 <1539141790-13557-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1539141790-13557-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 10, 2018 at 03:23:09AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Short of reverting commit 00d909a107 for v4.19, target-core needs a
> wait_event_t marco can be executed using TASK_UNINTERRUPTIBLE to
> function correctly with existing fabric drivers that expect to run
> with signals pending during session shutdown and active se_cmd I/O
> quiesce.
> 
> The most notable is iscsi-target/iser-target, while ibmvscsi_tgt invokes
> session shutdown logic from userspace via configfs attribute that could
> also potentially have signals pending.
> 
> So go ahead and introduce wait_event_lock_irq_timeout() to achieve this,
> and update + rename __wait_event_lock_irq_timeout() to make it accept
> 'state' as a parameter.
> 
> Fixes: 00d909a107 ("scsi: target: Make the session shutdown code also wait for commands that are being aborted")
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Tested-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
