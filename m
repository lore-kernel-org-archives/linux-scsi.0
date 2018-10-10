From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] target: Fix target_wait_for_sess_cmds breakage with
 active signals
Date: Wed, 10 Oct 2018 10:43:35 +0200
Message-ID: <20181010084335.GN5728@hirez.programming.kicks-ass.net>
References: <1539141790-13557-1-git-send-email-nab@linux-iscsi.org>
 <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1539141790-13557-3-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 10, 2018 at 03:23:10AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> With the addition of commit 00d909a107 in v4.19-rc, it incorrectly assumes no
> signals will be pending for task_struct executing the normal session shutdown
> and I/O quiesce code-path.
> 
> For example, iscsi-target and iser-target issue SIGINT to all kthreads as
> part of session shutdown.  This has been the behaviour since day one.

Not knowing much context here; but does it make sense for those
kthreads to handle signals, ever? Most kthreads should be fine with
ignore_signals().
