From: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] scsi: ufs: Schedule clk gating work on correct queue
Date: Wed, 17 Oct 2018 13:06:31 -0700
Message-ID: <CAD=FV=UR2b4XoyhKz6XpBByQ=MKNq-qyPjbLTNaLfSmzNXkgMQ@mail.gmail.com>
References: <20181005172732.203793-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005172732.203793-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, sayalil@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On Fri, Oct 5, 2018 at 10:28 AM Evan Green <evgreen@chromium.org> wrote:
>
> With commit 10e5e37581fc ("scsi: ufs: Add clock ungating to a separate
> workqueue"), clock gating work was moved to a
> separate work queue with WQ_MEM_RECLAIM set, since clock
> gating could occur from a memory reclaim context. Unfortunately,
> clk_gating.gate_work was left queued via schedule_delayed_work,
> which is a system workqueue that does not have WQ_MEM_RECLAIM set.
> Because ufshcd_ungate_work attempts to cancel gate_work, the
> following warning appears:
>
> [   14.174170] workqueue: WQ_MEM_RECLAIM ufs_clk_gating_0:ufshcd_ungate_work is flushing !WQ_MEM_RECLAIM events:ufshcd_gate_work
> [   14.174179] WARNING: CPU: 4 PID: 173 at kernel/workqueue.c:2440 check_flush_dependency+0x110/0x118
> [   14.205725] CPU: 4 PID: 173 Comm: kworker/u16:3 Not tainted 4.14.68 #1
> [   14.212437] Hardware name: Google Cheza (rev1) (DT)
> [   14.217459] Workqueue: ufs_clk_gating_0 ufshcd_ungate_work
> [   14.223107] task: ffffffc0f6a40080 task.stack: ffffff800a490000
> [   14.229195] PC is at check_flush_dependency+0x110/0x118
> [   14.234569] LR is at check_flush_dependency+0x110/0x118
> [   14.239944] pc : [<ffffff80080cad14>] lr : [<ffffff80080cad14>] pstate: 60c001c9
> [   14.333050] Call trace:
> [   14.427767] [<ffffff80080cad14>] check_flush_dependency+0x110/0x118
> [   14.434219] [<ffffff80080cafec>] start_flush_work+0xac/0x1fc
> [   14.440046] [<ffffff80080caeec>] flush_work+0x40/0x94
> [   14.445246] [<ffffff80080cb288>] __cancel_work_timer+0x11c/0x1b8
> [   14.451433] [<ffffff80080cb4b8>] cancel_delayed_work_sync+0x20/0x30
> [   14.457886] [<ffffff80085b9294>] ufshcd_ungate_work+0x24/0xd0
> [   14.463800] [<ffffff80080cfb04>] process_one_work+0x32c/0x690
> [   14.469713] [<ffffff80080d0154>] worker_thread+0x218/0x338
> [   14.475361] [<ffffff80080d527c>] kthread+0x120/0x130
> [   14.480470] [<ffffff8008084814>] ret_from_fork+0x10/0x18
>
> The simple solution is to put the gate_work on the same WQ_MEM_RECLAIM
> work queue as the ungate_work.
>
> Fixes: 10e5e37581fc ("scsi: ufs: Add clock ungating to a separate workqueue")
> Signed-off-by: Evan Green <evgreen@chromium.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Seems sane to me:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
