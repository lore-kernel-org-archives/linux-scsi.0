From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Need some pointers to debug a target hang
Date: Fri, 2 Sep 2016 16:14:19 +0200
Message-ID: <20160902141419.h23stppulnyfrnkz@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Nick et al,

I'm having a "interesting" problem with the kernel's iSCSI target and
could use a debug hint.

My target uses an iblock backstore on a dm-linear target. When I now
get I/O form the initiator (I used a simple dd if=/dev/sda
of=/dev/null) and call 'dmsetup suspend $backstore' it'll take about
15 seconds for the iscsi_ttx kernel thread to disapear, the iscsi_trx
and iscsi_np threads are hanging in 'D'.

>From iscsi_trx's stack I see it's waiting in
__transport_wait_for_tasks(). The last thing I see in dmesg is the
'ABORT_TASK: Found referenced %s task_tag: %llu' printk but the
'ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %llu" printk
is missing from core_tmr_abort_task(). As there's a
transport_wait_for_tasks() call in between I _think_ it is stuck in
aborting this one task and none of the
complete(se_cmd->t_transport_stop_comp) callers is called. What
puzzels me a bit is that right after transport_wait_for_tasks() in
core_tmr_abort_task() there's a call to transport_cmd_finish_abort()
which in turn calls transport_cmd_check_stop_to_fabric() ->
transport_cmd_check_stop() ->
complete_all(&cmd->t_transport_stop_comp).

Doing 

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2739,7 +2739,7 @@ __transport_wait_for_tasks(struct se_cmd
 
        spin_unlock_irqrestore(&cmd->t_state_lock, *flags);
 
-       wait_for_completion(&cmd->t_transport_stop_comp);
+       wait_for_completion_interruptible(&cmd->t_transport_stop_comp, 5 * HZ);
 
        spin_lock_irqsave(&cmd->t_state_lock, *flags);
        cmd->transport_state &= ~(CMD_T_ACTIVE | CMD_T_STOP);

"resolves" the bug, but I don't think this is correct.

This is all easily reproducible with v4.8-rc4 in qemu (for instance).

Any advice is aprechiated.

Thanks in advance,
       Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
