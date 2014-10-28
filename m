From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 25/27] scsi: check for correct return code in
 scsi_eh_abort_cmds()
Date: Tue, 28 Oct 2014 19:04:56 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959345AB7@G9W0745.americas.hpqcorp.net>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
 <1414153627-2863-26-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:24628 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJ1THA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2014 15:07:00 -0400
In-Reply-To: <1414153627-2863-26-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, 24 October, 2014 7:27 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Elliott, Robert (Server Storage); linux-
> scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 25/27] scsi: check for correct return code in
> scsi_eh_abort_cmds()
> 
> scsi_try_to_abort_cmd() might return SUCCESS, FAILED, or
> FAST_IO_FAIL. So just checking for FAILED will treat
> FAST_IO_FAIL as SUCCESS, which is wrong.
> 
> Cc: Robert Elliott <elliott@hp.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index fa7b5ec..e94baf1 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1345,7 +1345,7 @@ static int scsi_eh_abort_cmds(struct list_head
> *work_q,
>  			scmd_printk(KERN_INFO, scmd,
>  				     "%s: aborting cmd\n", current->comm));
>  		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
> -		if (rtn == FAILED) {
> +		if (rtn != SUCCESS) {
>  			SCSI_LOG_ERROR_RECOVERY(3,
>  				scmd_printk(KERN_INFO, scmd,
>  					    "%s: aborting cmd failed\n",

The rest of the code in that function is:
						current->comm));
			list_splice_init(&check_list, work_q);
			 return list_empty(work_q);
		}	[closing the rtn != SUCCESS block]
		scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
		if (rtn == FAST_IO_FAIL)
			scsi_eh_finish_cmd(scmd, done_q);
		else
			list_move_tail(&scmd->eh_entry, &check_list);
	}

	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
}

With this change, if rtn is FAST_IO_FAIL, the 
	return list_empty(work_q);
will be taken and it'll never get to
	if (rtn == FAST_IO_FAIL)

---
Rob Elliott    HP Server Storage




