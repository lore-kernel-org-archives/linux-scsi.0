From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] target: Fix target_wait_for_sess_cmds breakage with
 active signals
Date: Wed, 10 Oct 2018 22:40:12 -0700
Message-ID: <1539236412.6150.18.camel@haakon3.daterainc.com>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
         <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
         <20181010084335.GN5728@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010084335.GN5728@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Hey Peter & Co,

On Wed, 2018-10-10 at 10:43 +0200, Peter Zijlstra wrote:
> On Wed, Oct 10, 2018 at 03:23:10AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > With the addition of commit 00d909a107 in v4.19-rc, it incorrectly assumes no
> > signals will be pending for task_struct executing the normal session shutdown
> > and I/O quiesce code-path.
> > 
> > For example, iscsi-target and iser-target issue SIGINT to all kthreads as
> > part of session shutdown.  This has been the behaviour since day one.
> 
> Not knowing much context here; but does it make sense for those
> kthreads to handle signals, ever? Most kthreads should be fine with
> ignore_signals().
> 

iscsi-target + ib-isert uses SIGINT amongst dedicated rx/tx connection
kthreads to signal connection shutdown, requiring in-flight se_cmd I/O
descriptors to be quiesced before making forward progress to release
se_session.

By the point wait_event_lock_irq_timeout() is called in the example
here, one of the two rx/tx connection kthreads has been stopped, and the
other kthread is still processing shutdown.  So while historically the
pending SIGINTs where not cleared (or ignored) during shutdown at this
point, there is no reason why they could not be ignored for iscsi-target
+ ib-isert.

That said, pre commit 00d909a107 code always used wait_for_completion()
and ignored pending signals.  As-is target_wait_for_sess_cmds() is
called directly from fabric driver code and in one case also from
user-space via configfs_write_file(), so AFAICT it does need
TASK_UNINTERRUPTIBLE.
