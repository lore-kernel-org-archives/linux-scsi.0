From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCHv3 3/6] scsi: make eh_eflags persistent
Date: Tue, 14 Mar 2017 18:51:47 +0100
Message-ID: <20170314175147.GB19037@bblock-ThinkPad-W530>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
 <1488359720-130871-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36903 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750801AbdCNRvy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Mar 2017 13:51:54 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2EHoWYl124479
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 13:51:53 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 296jm2ggev-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 13:51:53 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Tue, 14 Mar 2017 17:51:51 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2EHpmxh28770388
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 17:51:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3EC24A4055
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 17:51:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25AF2A4051
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 17:51:37 +0000 (GMT)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.152])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 17:51:37 +0000 (GMT)
Content-Disposition: inline
In-Reply-To: <1488359720-130871-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

Hello Hannes,

sry that I only now reply to the other patches of the series.

On Wed, Mar 01, 2017 at 10:15:17AM +0100, Hannes Reinecke wrote:
> To detect if a failed command has been retried we must not
> clear scmd->eh_eflags when EH finishes.
> The flag should be persistent throughout the lifetime
> of the command.
>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  Documentation/scsi/scsi_eh.txt      | 14 +++++++-------
>  drivers/scsi/libsas/sas_scsi_host.c |  2 --
>  drivers/scsi/scsi_error.c           |  4 ++--
>  include/scsi/scsi_eh.h              |  1 +
>  4 files changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
> index 37eca00..4edb9c1c 100644
> --- a/Documentation/scsi/scsi_eh.txt
> +++ b/Documentation/scsi/scsi_eh.txt
> @@ -105,11 +105,14 @@ function
>
>   2. If the host supports asynchronous completion (as indicated by the
>      no_async_abort setting in the host template) scsi_abort_command()
> -    is invoked to schedule an asynchrous abort. If that fails
> -    Step #3 is taken.
> +    is invoked to schedule an asynchrous abort.
> +    Asynchronous abort are not invoked for commands which the
> +    SCSI_EH_ABORT_SCHEDULED flag is set (this indicates that the command
> +    already had been aborted once, and this is a retry which failed),
> +    or when the EH deadline is expired. In these case Step #3 is taken.
>
> - 2. scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD) is invoked for the
> -    command.  See [1-3] for more information.
> + 3. scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD) is invoked for the
> +    command.  See [1-4] for more information.
>
>  [1-3] Asynchronous command aborts
>
> @@ -263,7 +266,6 @@ scmd->allowed.
>
>   3. scmd recovered
>      ACTION: scsi_eh_finish_cmd() is invoked to EH-finish scmd
> -	- clear scmd->eh_eflags
>  	- scsi_setup_cmd_retry()
>  	- move from local eh_work_q to local eh_done_q
>      LOCKING: none
> @@ -456,8 +458,6 @@ except for #1 must be implemented by eh_strategy_handler().
>
>   - shost->host_failed is zero.
>
> - - Each scmd's eh_eflags field is cleared.
> -
>   - Each scmd is in such a state that scsi_setup_cmd_retry() on the
>     scmd doesn't make any difference.
>
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index ee6b39a..87e5079 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -613,8 +613,6 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
>  		SAS_DPRINTK("trying to find task 0x%p\n", task);
>  		res = sas_scsi_find_task(task);
>
> -		cmd->eh_eflags = 0;
> -
>  		switch (res) {
>  		case TASK_IS_DONE:
>  			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index cec439c..e1ca3b8 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -189,7 +189,6 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
>  		/*
>  		 * Retry after abort failed, escalate to next level.
>  		 */
> -		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
>  		SCSI_LOG_ERROR_RECOVERY(3,
>  			scmd_printk(KERN_INFO, scmd,
>  				    "previous abort failed\n"));
> @@ -933,6 +932,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
>  	ses->result = scmd->result;
>  	ses->underflow = scmd->underflow;
>  	ses->prot_op = scmd->prot_op;
> +	ses->eh_eflags = scmd->eh_eflags;
>
>  	scmd->prot_op = SCSI_PROT_NORMAL;
>  	scmd->eh_eflags = 0;
> @@ -996,6 +996,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
>  	scmd->result = ses->result;
>  	scmd->underflow = ses->underflow;
>  	scmd->prot_op = ses->prot_op;
> +	scmd->eh_eflags = ses->eh_eflags;
>  }
>  EXPORT_SYMBOL(scsi_eh_restore_cmnd);
>
> @@ -1140,7 +1141,6 @@ static int scsi_eh_reset(struct scsi_cmnd *scmd)
>   */
>  void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
>  {
> -	scmd->eh_eflags = 0;
>  	list_move_tail(&scmd->eh_entry, done_q);
>  }
>  EXPORT_SYMBOL(scsi_eh_finish_cmd);
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index 98d366b..a25b328 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -31,6 +31,7 @@ extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
>  struct scsi_eh_save {
>  	/* saved state */
>  	int result;
> +	int eh_eflags;
>  	enum dma_data_direction data_direction;
>  	unsigned underflow;
>  	unsigned char cmd_len;
> --
> 1.8.5.6
>

So I think the code is good. The only thing I am missing is a bit of
reasoning why we want to escalate immediately after an already retried
command fails again. Anyway, would not require code-changes.


Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
--
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
