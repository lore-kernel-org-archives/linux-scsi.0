From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Need some pointers to debug a target hang
Date: Mon, 17 Oct 2016 22:57:55 -0700
Message-ID: <1476770275.8490.10.camel@haakon3.risingtidesystems.com>
References: <20160902141419.h23stppulnyfrnkz@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160902141419.h23stppulnyfrnkz@c203.arch.suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello Johannes,

Apologies for the extended delayed follow-up on this bug report.

On Fri, 2016-09-02 at 16:14 +0200, Johannes Thumshirn wrote:
> Hi Nick et al,
> 
> I'm having a "interesting" problem with the kernel's iSCSI target and
> could use a debug hint.
> 
> My target uses an iblock backstore on a dm-linear target. When I now
> get I/O form the initiator (I used a simple dd if=/dev/sda
> of=/dev/null) and call 'dmsetup suspend $backstore' it'll take about
> 15 seconds for the iscsi_ttx kernel thread to disapear, the iscsi_trx
> and iscsi_np threads are hanging in 'D'.
> 
> From iscsi_trx's stack I see it's waiting in
> __transport_wait_for_tasks(). The last thing I see in dmesg is the
> 'ABORT_TASK: Found referenced %s task_tag: %llu' printk but the
> 'ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %llu" printk
> is missing from core_tmr_abort_task(). As there's a
> transport_wait_for_tasks() call in between I _think_ it is stuck in
> aborting this one task and none of the
> complete(se_cmd->t_transport_stop_comp) callers is called. What
> puzzels me a bit is that right after transport_wait_for_tasks() in
> core_tmr_abort_task() there's a call to transport_cmd_finish_abort()
> which in turn calls transport_cmd_check_stop_to_fabric() ->
> transport_cmd_check_stop() ->
> complete_all(&cmd->t_transport_stop_comp).
> 
> Doing 
> 
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2739,7 +2739,7 @@ __transport_wait_for_tasks(struct se_cmd
>  
>         spin_unlock_irqrestore(&cmd->t_state_lock, *flags);
>  
> -       wait_for_completion(&cmd->t_transport_stop_comp);
> +       wait_for_completion_interruptible(&cmd->t_transport_stop_comp, 5 * HZ);
>  
>         spin_lock_irqsave(&cmd->t_state_lock, *flags);
>         cmd->transport_state &= ~(CMD_T_ACTIVE | CMD_T_STOP);
> 
> "resolves" the bug, but I don't think this is correct.
> 
> This is all easily reproducible with v4.8-rc4 in qemu (for instance).
> 
> Any advice is aprechiated.
> 

This is likely the missing SCF_ACK_KREF assignment in >= v4.1.y:

http://www.spinics.net/lists/target-devel/msg13530.html

At your earliest convenience, please verify using this patch for TMR
ABORT_TASK due to target-core backend I/O still outstanding, with
simultaneous failed iscsi session reinstatement -> repeated iscsi login
timeout scenario.

Also once target-core backend I/O has (finally) been completed back to
fabric driver code, the iscsi_np configfs group shutdown is allowed to
proceed.
