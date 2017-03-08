From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3 00/14] qla2xxx: Bug Fixes and updates for target.
Date: Tue, 07 Mar 2017 23:34:52 -0800
Message-ID: <1488958492.10589.9.camel@haakon3.risingtidesystems.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
         <1488760974.2808.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1488760974.2808.1.camel@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-03-06 at 00:43 +0000, Bart Van Assche wrote:
> On Fri, 2017-02-24 at 13:37 -0800, Himanshu Madhani wrote:
> > Please consider this series for inclusion in target-pending.
> 
> Hello Himanshu,
> 
> I applied this patch series on top of kernel v4.11-rc1 and installed it on
> a test system. Unfortunately the regression I reported one month ago against
> v2 of this patch series still occurs with v3 of this patch series:

Btw, the regression reported here in v2:

http://www.spinics.net/lists/target-devel/msg14348.html

is completely different from what you've reported here.

> 
> INFO: task kworker/2:1:71 blocked for more than 120 seconds.
>       Not tainted 4.11.0-rc1-dbg+ #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kworker/2:1     D    0    71      2 0x00000000
> Workqueue: events qlt_free_session_done [qla2xxx]
> Call Trace:
>  __schedule+0x1ef/0xa70
>  schedule+0x40/0x90
>  schedule_timeout+0x258/0x4a0
>  wait_for_completion+0x108/0x170
>  target_wait_for_sess_cmds+0x56/0x1b0 [target_core_mod]
>  tcm_qla2xxx_free_session+0x45/0x90 [tcm_qla2xxx]
>  qlt_free_session_done+0x44a/0x550 [qla2xxx]
>  process_one_work+0x20d/0x6c0
>  worker_thread+0x4e/0x4a0
>  kthread+0x10c/0x140
>  ret_from_fork+0x31/0x40
> 

It would be useful to explain how you reproduced this, instead of just
posting backtrace with zero context..?

Can we at least identify which patch in this series is causing this..?

Also, I assume you are running this on stock v4.11-rc1 with only this
qla2xxx series applied, and not all of your other stuff, right..?
