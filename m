From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] qla2xxx: Drop srb reference before waiting for completion
Date: Tue, 05 Oct 2010 13:18:11 -0500
Message-ID: <4CAB6BE3.3040001@cs.wisc.edu>
References: <C8D0955B.9DF5%giridhar.malavali@qlogic.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050204000800090301050407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36753 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab0JESL6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2010 14:11:58 -0400
In-Reply-To: <C8D0955B.9DF5%giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, LinuxSCSI <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050204000800090301050407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/05/2010 10:42 AM, Giridhar Malavali wrote:
>
>
>
> On 10/1/10 2:10 PM, "Mike Christie"<michaelc@cs.wisc.edu>  wrote:
>
>> On 10/01/2010 04:01 PM, Mike Christie wrote:
>>> On 10/01/2010 07:18 AM, Hannes Reinecke wrote:
>>>>
>>>> This patch fixes a regression introduced by commit
>>>> 083a469db4ecf3b286a96b5b722c37fc1affe0be
>>>>
>>>> qla2xxx_eh_wait_on_command() is waiting for an srb to
>>>> complete, which will never happen as the routine took
>>>> a reference to the srb previously and will only drop it
>>>> after this function. So every command abort will fail.
>>>>
>>>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>>>> Cc: Andrew Vasquez<andrew.vasquez@qlogic.com>
>>>>
>>>> diff --git a/drivers/scsi/qla2xxx/qla_os.c
>>>> b/drivers/scsi/qla2xxx/qla_os.c
>>>> index 1e4bff6..0af7549 100644
>>>> --- a/drivers/scsi/qla2xxx/qla_os.c
>>>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>>>> @@ -883,6 +883,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>>>> }
>>>> spin_unlock_irqrestore(&ha->hardware_lock, flags);
>>>>
>>>> + if (got_ref)
>>>> + qla2x00_sp_compl(ha, sp);
>>>> +
>>>
>>> You can just get rid of got_ref, because if you just move the compl call
>>> up a little more you know that in that code path we always get a ref.
>>> And there is no need to hold the ref to where it is above. See attached
>>> patch.
>>>
>>
>> Sorry. Last patch had some other iscsi dev loss stuff in there. See this
>> patch.
>
> Mike,
>
> The whole purpose of completing the command after the delay is to give
> sufficient time for firmware to complete the original command and abort
> command issued through interrupt. This makes sure that commands of concern
> are no longer with firmware/hardware before completing it to upper layers. I
> feel it is better to call qla2x00_sp_compl after waiting.


Note: When the command is aborted the normal completion path in the scsi 
layer is short circuited. If you try to do scsi_done on it, it will not 
get processed pass the blk_complete_request blk_mark_rq_complete check.


Note2: In that abort path don't we already have a refcount on the sp 
from when it was allocated and queued from the queuecommand? If we did 
not, then if you did do sp_get on it or any access on it to test it you 
would be accessing a freed sp.



For the initial problem Hannes was fixing..... If you wait until after 
qla2x00_eh_wait_on_command to call qla2x00_sp_compl then as Hannes 
pointed out the qla2x00_eh_wait_on_command is always going to fail. We 
agree on that, right?

Right here, before calling sp_get, the sp would have a refcount of 1 
from when the sp was created from the normal queuecommand path.

                 sp_get(sp);

Now after calling it here, sp will have a ref count of 2. This refcount 
is supposed to protect where if the lock is dropped below and the 
command completes, the sp is not freed, right?


                 got_ref++;

                 spin_unlock_irqrestore(&ha->hardware_lock, flags);
                 if (ha->isp_ops->abort_command(sp)) {
                         DEBUG2(printk("%s(%ld): abort_command "
                         "mbx failed.\n", __func__, vha->host_no));
                         ret = FAILED;
                 } else {
                         DEBUG3(printk("%s(%ld): abort_command "
                         "mbx success.\n", __func__, vha->host_no));
                         wait = 1;
                 }
                 spin_lock_irqsave(&ha->hardware_lock, flags);
                 break;
         }

So right now the refcount is 2.


         spin_unlock_irqrestore(&ha->hardware_lock, flags);

         /* Wait for the command to be returned. */
         if (wait) {

If the cmd does complete, then the normal/abort completion path will 
drop the refcount from the initial queue comamnd path, so the refcount 
is going to be stuck at 1, and so CMD_SP(cmd) is always going to be 
non-null (since it only gets cleared when the ref count goes to zero), 
and so we always time out from the wait.


                 if (qla2x00_eh_wait_on_command(cmd) != QLA_SUCCESS) {
                         qla_printk(KERN_ERR, ha,
                             "scsi(%ld:%d:%d): Abort handler timed out 
-- %lx "
                             "%x.\n", vha->host_no, id, lun, serial, ret);
                         ret = FAILED;
                 }
         }

         if (got_ref)
                 qla2x00_sp_compl(ha, sp);

Now, here the we release the ref count from the abort chunk, and so 
CMD_SP is now null.

But the wait failed so we returned FAILED.


-----------------------------------------------------------------------


So that is the reason why we must move the ref count release upwards. 
Now, for the answer why we it is ok to release where I did it.


                 /* Get a reference to the sp and drop the lock.*/
                 sp_get(sp);


Here we have the hardware lock and another ref to the sp (refcount = 2).

                got_ref++;

                 spin_unlock_irqrestore(&ha->hardware_lock, flags);
                 if (ha->isp_ops->abort_command(sp)) {
                         DEBUG2(printk("%s(%ld): abort_command "
                         "mbx failed.\n", __func__, vha->host_no));
                         ret = FAILED;
                 } else {
                         DEBUG3(printk("%s(%ld): abort_command "
                         "mbx success.\n", __func__, vha->host_no));
                         wait = 1;
                 }
                 spin_lock_irqsave(&ha->hardware_lock, flags);

right here if the command completed from the abort or normal completion 
the the refcount would be 1. If we release the ref that we took above, 
it would free the sp and call scsi_done on the command. However, the 
scsi eh has made sure that if you did this, it will not complete the IO 
upwards. The scsi eh basically owns the command. It has to prevent races 
like this for us (for example the scsi_done function could get called 
while scsi_error.c is setting up the abort and now it would be accessing 
freed/reallcoated memory if it did not handle this problem).


                 break;
         }
         spin_unlock_irqrestore(&ha->hardware_lock, flags);


So from here on we never touch the sp, so there is no need to keep its 
memory around for qla2xxx's use. We are accessing the scsi command 
though, but we are relying on the scsi eh doing the right thing since it 
owns the command.


         /* Wait for the command to be returned. */
         if (wait) {
                 if (qla2x00_eh_wait_on_command(cmd) != QLA_SUCCESS) {
                         qla_printk(KERN_ERR, ha,
                             "scsi(%ld:%d:%d): Abort handler timed out 
-- %lx "
                             "%x.\n", vha->host_no, id, lun, serial, ret);
                         ret = FAILED;
                 }
         }



Also, why do you do that loop in qla2xxx_eh_abort? Is the hardware lock 
held while calling the compl function. If so it seems like if you know 
the CMD_SP is not null then there is still a refcount on it so there 
must be a valid sp. In the attached patch, I removed the loop. It 
assumes that when the hardware lock is held when calling 
qla2x00_sp_compl. Patch is only compile tested.



--------------050204000800090301050407
Content-Type: text/plain;
 name="qla2xxx-rm-got-ref3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="qla2xxx-rm-got-ref3.patch"

qla2xxx: Drop srb reference before waiting for completion

This patch fixes a regression introduced by commit
083a469db4ecf3b286a96b5b722c37fc1affe0be

qla2xxx_eh_wait_on_command() is waiting for an srb to
complete, which will never happen as the routine took
a reference to the srb previously and will only drop it
after this function. So every command abort will fail.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bdd53f0..a5b9af2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -824,15 +824,12 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
-	int ret, i;
+	int ret;
 	unsigned int id, lun;
 	unsigned long serial;
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = vha->req;
-	srb_t *spt;
-	int got_ref = 0;
 
 	fc_block_scsi_eh(cmd);
 
@@ -844,43 +841,32 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 	serial = cmd->serial_number;
-	spt = (srb_t *) CMD_SP(cmd);
-	if (!spt)
-		return SUCCESS;
 
-	/* Check active list for command command. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
-		sp = req->outstanding_cmds[i];
-
-		if (sp == NULL)
-			continue;
-		if ((sp->ctx) && !(sp->flags & SRB_FCP_CMND_DMA_VALID) &&
-		    !IS_PROT_IO(sp))
-			continue;
-		if (sp->cmd != cmd)
-			continue;
+	sp = (srb_t *) CMD_SP(cmd);
+	if (!sp) {
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		return SUCCESS;
+	}
 
-		DEBUG2(printk("%s(%ld): aborting sp %p from RISC."
+	DEBUG2(printk("%s(%ld): aborting sp %p from RISC."
 		" pid=%ld.\n", __func__, vha->host_no, sp, serial));
 
-		/* Get a reference to the sp and drop the lock.*/
-		sp_get(sp);
-		got_ref++;
+	/* Get a reference to the sp and drop the lock.*/
+	sp_get(sp);
 
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		if (ha->isp_ops->abort_command(sp)) {
-			DEBUG2(printk("%s(%ld): abort_command "
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	if (ha->isp_ops->abort_command(sp)) {
+		DEBUG2(printk("%s(%ld): abort_command "
 			"mbx failed.\n", __func__, vha->host_no));
-			ret = FAILED;
-		} else {
-			DEBUG3(printk("%s(%ld): abort_command "
+		ret = FAILED;
+	} else {
+		DEBUG3(printk("%s(%ld): abort_command "
 			"mbx success.\n", __func__, vha->host_no));
-			wait = 1;
-		}
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		break;
+		wait = 1;
 	}
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	qla2x00_sp_compl(ha, sp);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for the command to be returned. */
@@ -893,9 +879,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		}
 	}
 
-	if (got_ref)
-		qla2x00_sp_compl(ha, sp);
-
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): Abort command issued -- %d %lx %x.\n",
 	    vha->host_no, id, lun, wait, serial, ret);

--------------050204000800090301050407--
