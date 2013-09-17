From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/22] be2iscsi: Fix soft lock up issue during UE or if
 FW taking time to respond
Date: Mon, 16 Sep 2013 22:18:51 -0500
Message-ID: <5237CA1B.2090907@cs.wisc.edu>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com> <1379049014-32716-6-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45428 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab3IQDT1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Sep 2013 23:19:27 -0400
In-Reply-To: <1379049014-32716-6-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@gmail.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 09/13/2013 12:09 AM, Jayamohan Kallickal wrote:
>  The timeout set in MBX_CMD is 100sec and the ready bit checking in BMBX
>  mode is done for 4sec. After 4sec the task is scheduled out for 5 secs
>  to avoid kernel soft lockup stack trace. The loop of 4sec ready bit check
>  and then schedule out is done until the following conditon occur
>   - The Ready Bit is Set
>   - The timeout set in MBX_CMD expires
> 
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be.h      |    2 +-
>  drivers/scsi/be2iscsi/be_cmds.c |   47 +++++++++++++++++++++++++--------------
>  drivers/scsi/be2iscsi/be_main.c |    5 ++---
>  3 files changed, 33 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
> index 777e7c0..2e28f6c 100644
> --- a/drivers/scsi/be2iscsi/be.h
> +++ b/drivers/scsi/be2iscsi/be.h
> @@ -128,7 +128,7 @@ struct be_ctrl_info {
>  
>  #define PAGE_SHIFT_4K 12
>  #define PAGE_SIZE_4K (1 << PAGE_SHIFT_4K)
> -#define mcc_timeout		120000 /* 5s timeout */
> +#define mcc_timeout		120000 /* 12s timeout */
>  
>  /* Returns number of pages spanned by the data starting at the given addr */
>  #define PAGES_4K_SPANNED(_address, size)				\
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
> index f7788e5..01e1915 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -490,33 +490,46 @@ int be_mcc_notify_wait(struct beiscsi_hba *phba)
>   **/
>  static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
>  {
> +#define BEISCSI_MBX_RDY_BIT_TIMEOUT	4000	/* 4sec */
>  	void __iomem *db = ctrl->db + MPU_MAILBOX_DB_OFFSET;
>  	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
> -	uint32_t wait = 0;
> +	unsigned long timeout;
> +	bool read_flag = false;
> +	int ret = 0, i;
>  	u32 ready;
>  
> -	do {
> +	if (beiscsi_error(phba))
> +		return -EIO;
>  
> -		if (beiscsi_error(phba))
> -			return -EIO;
> +	timeout = jiffies + (HZ * 110);
>  
> -		ready = ioread32(db) & MPU_MAILBOX_DB_RDY_MASK;
> -		if (ready)
> -			break;
> +	do {
> +		for (i = 0; i < BEISCSI_MBX_RDY_BIT_TIMEOUT; i++) {
> +			ready = ioread32(db) & MPU_MAILBOX_DB_RDY_MASK;
> +			if (ready) {
> +				read_flag = true;
> +				break;
> +			}
> +			mdelay(1);
> +		}
>  
> -		if (wait > BEISCSI_HOST_MBX_TIMEOUT) {
> -			beiscsi_log(phba, KERN_ERR,
> -				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> -				    "BC_%d : FW Timed Out\n");
> +		if (!read_flag) {
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			schedule_timeout(HZ * 5);
> +			set_current_state(TASK_RUNNING);
> +		}
> +	} while ((time_before(jiffies, timeout)) && !read_flag);
> +

I think you can use wait_event_timeout instead of all this.

