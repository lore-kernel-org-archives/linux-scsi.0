From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 22/24] scsi: fixup logging messages in scsi_error.c
Date: Fri, 3 Oct 2014 02:39:30 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBF0A@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-23-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:53530 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaJCClV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 22:41:21 -0400
In-Reply-To: <1412144580-72880-23-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
...
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 554f885..7e1e190 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1156,9 +1156,10 @@ int scsi_eh_get_sense(struct list_head *work_q,
>  		shost = scmd->device->host;
>  		if (scsi_host_eh_past_deadline(shost)) {
>  			SCSI_LOG_ERROR_RECOVERY(3,
> -				shost_printk(KERN_INFO, shost,
> -					    "skip %s, past eh deadline\n",
> -					     __func__));
> +				scmd_printk(KERN_INFO, scmd,
> +					    "%s: skip request sense, "
> +					     "past eh deadline\n",

checkpatch lets you keep strings on one line.

> +					     current->comm));
>  			break;
>  		}
>  		if (status_byte(scmd->result) != CHECK_CONDITION)
> @@ -1265,9 +1266,10 @@ static int scsi_eh_test_devices(struct list_head
> *cmd_list,
>  				/* Push items back onto work_q */
>  				list_splice_init(cmd_list, work_q);
>  				SCSI_LOG_ERROR_RECOVERY(3,
> -					shost_printk(KERN_INFO, sdev->host,
> -						     "skip %s, past eh deadline",
> -						     __func__));
> +					sdev_printk(KERN_INFO, sdev,
> +						    "%s: skip test device, "
> +						    "past eh deadline",

checkpatch lets you keep strings on one line.

> +						    current->comm));
>  				break;
>  			}
>  		}
> @@ -1318,21 +1320,22 @@ static int scsi_eh_abort_cmds(struct list_head
> *work_q,
>  		if (scsi_host_eh_past_deadline(shost)) {
>  			list_splice_init(&check_list, work_q);
>  			SCSI_LOG_ERROR_RECOVERY(3,
> -				shost_printk(KERN_INFO, shost,
> -					    "skip %s, past eh deadline\n",
> -					     __func__));
> +				scmd_printk(KERN_INFO, scmd,
> +					    "%s: skip aborting cmd, "
> +					    "past eh deadline\n",

checkpatch lets you keep strings on one line.

> +					    current->comm));
>  			return list_empty(work_q);
>  		}
>  		SCSI_LOG_ERROR_RECOVERY(3,
> -			shost_printk(KERN_INFO, shost,
> -				     "%s: aborting cmd: 0x%p\n",
> +			scmd_printk(KERN_INFO, scmd,
> +				     "%s: aborting cmd\n",
>  				     current->comm, scmd));

As noted by Ewan, the extra scmd argument causes compiler
warnings.

...
> @@ -1390,9 +1393,10 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
>  	shost_for_each_device(sdev, shost) {
>  		if (scsi_host_eh_past_deadline(shost)) {
>  			SCSI_LOG_ERROR_RECOVERY(3,
> -				shost_printk(KERN_INFO, shost,
> -					    "skip %s, past eh deadline\n",
> -					     __func__));
> +				sdev_printk(KERN_INFO, sdev,
> +					    "%s: skip START_UNIT, "
> +					    "past eh deadline\n",

checkpatch lets you keep strings on one line.

> +					    current->comm));
>  			break;
>  		}
>  		stu_scmd = NULL;
...
> @@ -1528,8 +1530,9 @@ static int scsi_eh_target_reset(struct Scsi_Host
> *shost,
>  			list_splice_init(&tmp_list, work_q);
>  			SCSI_LOG_ERROR_RECOVERY(3,
>  				shost_printk(KERN_INFO, shost,
> -					    "skip %s, past eh deadline\n",
> -					     __func__));
> +					    "%s: Skip target reset, "
> +					     "past eh deadline\n",

checkpatch lets you keep strings on one line.

...
> @@ -2191,9 +2194,10 @@ int scsi_error_handler(void *data)
>  		 */
>  		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
>  			SCSI_LOG_ERROR_RECOVERY(1,
> -				printk(KERN_ERR "Error handler scsi_eh_%d "
> -						"unable to autoresume\n",
> -						shost->host_no));
> +				shost_printk(KERN_ERR, shost,
> +					     "scsi_eh_%d: "
> +					     "unable to autoresume\n",

checkpatch lets you keep strings on one line.


---
Rob Elliott    HP Server Storage



