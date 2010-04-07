From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 01/12] qla4xxx: wait for device to come online in reset_lun
Date: Tue, 06 Apr 2010 22:35:41 -0500
Message-ID: <4BBBFD8D.2000003@cs.wisc.edu>
References: <20100406101333.GH22922@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43064 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0DGDb1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2010 23:31:27 -0400
In-Reply-To: <20100406101333.GH22922@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 04/06/2010 05:13 AM, Ravi Anand wrote:
>
> From: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
>
> wait upto 10s for device to come online otherwise indicating
> an error condition.
>
> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
> ---
>   drivers/scsi/qla4xxx/ql4_def.h |    1 +
>   drivers/scsi/qla4xxx/ql4_mbx.c |   22 ++++++++++++++++++++++
>   2 files changed, 23 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
> index 81b5f29..38e261d 100644
> --- a/drivers/scsi/qla4xxx/ql4_def.h
> +++ b/drivers/scsi/qla4xxx/ql4_def.h
> @@ -146,6 +146,7 @@
>   #define ISNS_DEREG_TOV			5
>
>   #define MAX_RESET_HA_RETRIES		2
> +#define DEVICE_ONLINE_TOV		10
>
>   /*
>    * SCSI Request Block structure	 (srb)	that is placed
> diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
> index 09d6d4b..4d8b3cb 100644
> --- a/drivers/scsi/qla4xxx/ql4_mbx.c
> +++ b/drivers/scsi/qla4xxx/ql4_mbx.c
> @@ -679,11 +679,33 @@ int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
>   	uint32_t mbox_cmd[MBOX_REG_COUNT];
>   	uint32_t mbox_sts[MBOX_REG_COUNT];
>   	int status = QLA_SUCCESS;
> +	unsigned long wait_online;
>
>   	DEBUG2(printk("scsi%ld:%d:%d: lun reset issued\n", ha->host_no,
>   		      ddb_entry->os_target_id, lun));
>
>   	/*
> +	 * If device is not online wait for 10 sec for device to come online.
> +	 * else return error
> +	 */
> +	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
> +		wait_online = jiffies + (DEVICE_ONLINE_TOV * HZ);
> +		while (time_before(jiffies, wait_online)) {
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			schedule_timeout(HZ);
> +			if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
> +				break;
> +		}
> +
> +		if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
> +			DEBUG2(printk(KERN_WARNING "scsi%ld: %s: Unable to "
> +					"reset lun. Device is not online.\n",
> +					ha->host_no, __func__));
> +			return QLA_ERROR;
> +		}
> +	}
> +


This looks similar to what you sent back in Feb. I said to wait in the 
target reset handler for the session to come back or for 
qla4xxx_recovery_timedout to be called
