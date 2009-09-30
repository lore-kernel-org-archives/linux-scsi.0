From: yukta eswar <yukta.eswar@gmail.com>
Subject: Re: Question about invoking of "Task management" functions in USB
	driver (from newbie)
Date: Wed, 30 Sep 2009 14:49:52 +0530
Message-ID: <ac9fc6790909300219k27ecaf2xf41d1938866ecf66@mail.gmail.com>
References: <ac9fc6790909290721y6b046793rd28357595be2f3a9@mail.gmail.com>
	 <4AC25F81.3070105@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f191.google.com ([209.85.222.191]:63444 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZI3JTs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2009 05:19:48 -0400
In-Reply-To: <4AC25F81.3070105@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

>one way to trip that for
> your testing is to send a SCSI command that is going
> to take some time (e.g. a READ of thousands of blocks
> should take some time, even on flash) and setup the
> command timeout to zero seconds and or close as you can to
> zero.

Actually I am registering my task management functions to
scsi_transport_template. I am handling all my task management
functions in eh_strategy_handler. Whare as in eh_timed_out I am just
completing the request.

Here I am pasting the the code I have with me.

struct scsi_transport_template *
uas_domain_attach_transport(struct uas_domain_function_template *dft)
{
	struct scsi_transport_template *stt = uas_attach_transport();
	struct uas_internal *i;

	PRINTK("<%s> <%s> Entry!\n",__FILE__, __FUNCTION__);

	if (!stt)
		return stt;

	i = to_uas_internal(stt);
	i->dft = dft;
	stt->create_work_queue = 1;
	stt->eh_timed_out = uas_scsi_timed_out;
	stt->eh_strategy_handler = uas_scsi_recover_host;

	PRINTK("<%s> <%s> Exit!\n",__FILE__, __FUNCTION__);
	return stt;
}

void uas_scsi_recover_host(struct Scsi_Host *shost)
{
	struct us_data *us = host_to_us(shost);
	unsigned long flags;
	LIST_HEAD(eh_work_q);

	spin_lock_irqsave(shost->host_lock, flags);
	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
	spin_unlock_irqrestore(shost->host_lock, flags);

	PRINTK("<%s> <%s> Entry!\n",__FILE__, __FUNCTION__);
	
	if (uas_eh_handle_uas_errors(shost, &eh_work_q, &us->eh_done_q))
		goto out;

	
	if (!scsi_eh_get_sense(&eh_work_q, &us->eh_done_q))
		scsi_eh_ready_devs(shost, &eh_work_q, &us->eh_done_q);

out:
	scsi_eh_flush_done_q(&us->eh_done_q);
	PRINTK("<%s> <%s> Exit!\n",__FILE__, __FUNCTION__);
	return;
}



static int uas_eh_handle_uas_errors(struct Scsi_Host *shost,
				    struct list_head *work_q,
				    struct list_head *done_q)
{
	struct scsi_cmnd *cmd, *n;
	enum task_disposition res = TASK_IS_DONE;
	int tmf_resp, need_reset;	
	unsigned long flags;
	struct us_data *us = host_to_us(shost);

	PRINTK("<%s> <%s> Entry!\n",__FILE__, __FUNCTION__);

Again:
	list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
		struct uas_task *task = TO_UAS_TASK(cmd);

		if (!task)
			continue;

		list_del_init(&cmd->eh_entry);

		spin_lock_irqsave(&task->task_state_lock, flags);
		need_reset = task->task_state_flags & UAS_TASK_NEED_DEV_RESET;
		spin_unlock_irqrestore(&task->task_state_lock, flags);

		if (need_reset) {
			PRINTK("%s: task 0x%p requests reset\n",
				    __func__, task);
			goto reset;
		}

		PRINTK("trying to find task 0x%p\n", task);
		res = uas_scsi_find_task(task, us);

		cmd->eh_eflags = 0;

		switch (res) {
		case TASK_IS_DONE:
			PRINTK("%s: task 0x%p is done\n", __func__,
				    task);
			uas_eh_finish_cmd(cmd);
			continue;
		case TASK_IS_ABORTED:
			PRINTK("%s: task 0x%p is aborted\n",
				    __func__, task);
			uas_eh_finish_cmd(cmd);
			continue;
		case TASK_IS_AT_LU:
			PRINTK("task 0x%p is at LU: lu recover\n", task);
 reset:
			tmf_resp = uas_recover_lu(us, cmd);
			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
				PRINTK("LU %x is "
					    "recovered\n",
					    cmd->device->lun);
				uas_eh_finish_cmd(cmd);
				uas_scsi_clear_queue_lu(work_q, cmd);
				goto Again;
			}
			/* fallthrough */
		case TASK_IS_NOT_AT_LU:
		case TASK_ABORT_FAILED:
			PRINTK("task 0x%p is not at LU: I_T recover\n",
				    task);
			tmf_resp = uas_recover_I_T(us);
			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
				uas_eh_finish_cmd(cmd);
				uas_scsi_clear_queue_I_T(work_q, us);
				goto Again;
			}
			/* Hammer time :-) */
			try_to_reset_cmd_device(cmd);
					
			/* If we are here -- this means that no amount
			 * of effort could recover from errors.  Quite
			 * possibly the HA just disappeared.
			 */
			PRINTK("error from  device LUN %x "
				    "couldn't be recovered in any way\n",
				    cmd->device->lun);

			uas_eh_finish_cmd(cmd);
			goto clear_q;
		}
	}
	return list_empty(work_q);
clear_q:
	PRINTK("--- Exit %s -- clear_q\n", __func__);
	list_for_each_entry_safe(cmd, n, work_q, eh_entry)
		uas_eh_finish_cmd(cmd);

	PRINTK("<%s> <%s> Exit!\n",__FILE__, __FUNCTION__);

	return list_empty(work_q);
}

enum blk_eh_timer_return uas_scsi_timed_out(struct scsi_cmnd *cmd)
{
	struct uas_task *task = TO_UAS_TASK(cmd);
	unsigned long flags;

	if (!task) {
		cmd->request->timeout /= 2;
		PRINTK("command 0x%p, task 0x%p, gone: %s\n",
			    cmd, task, (cmd->request->timeout ?
			    "BLK_EH_RESET_TIMER" : "BLK_EH_NOT_HANDLED"));
		if (!cmd->request->timeout)
			return BLK_EH_NOT_HANDLED;
		return BLK_EH_RESET_TIMER;
	}

	spin_lock_irqsave(&task->task_state_lock, flags);
	BUG_ON(task->task_state_flags & UAS_TASK_STATE_ABORTED);
	if (task->task_state_flags & UAS_TASK_STATE_DONE) {
		spin_unlock_irqrestore(&task->task_state_lock, flags);
		PRINTK("command 0x%p, task 0x%p, timed out: "
			    "BLK_EH_HANDLED\n", cmd, task);
		return BLK_EH_HANDLED;
	}
	if (!(task->task_state_flags & UAS_TASK_AT_INITIATOR)) {
		spin_unlock_irqrestore(&task->task_state_lock, flags);
		PRINTK("command 0x%p, task 0x%p, not at initiator: "
			    "BLK_EH_RESET_TIMER\n",
			    cmd, task);
		return BLK_EH_RESET_TIMER;
	}
	task->task_state_flags |= UAS_TASK_STATE_ABORTED;
	spin_unlock_irqrestore(&task->task_state_lock, flags);

	PRINTK("command 0x%p, task 0x%p, timed out: BLK_EH_NOT_HANDLED\n",
		    cmd, task);

	PRINTK("<%s> <%s> Exit!\n",__FILE__, __FUNCTION__);

	return BLK_EH_NOT_HANDLED;
}
