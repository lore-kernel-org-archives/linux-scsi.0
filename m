From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 07/11] qla4xxx: Avoid relogin on device marked missing
Date: Mon, 01 Feb 2010 12:41:12 -0600
Message-ID: <4B672048.4090600@cs.wisc.edu>
References: <20100130062900.GH10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38232 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab0BASla (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2010 13:41:30 -0500
In-Reply-To: <20100130062900.GH10274@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>

On 01/30/2010 12:29 AM, Ravi Anand wrote:
>
> From: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
>
> Signed-off-by: Nilesh Javali<nilesh.javali@qlogic.com>
> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
> ---
>   drivers/scsi/qla4xxx/ql4_os.c |   27 ++++++++++++++++++++++++---
>   1 files changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 9057860..e5c9b85 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -370,6 +370,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
>   		      ddb_entry->fw_ddb_index));
>   	iscsi_block_session(ddb_entry->sess);
>   	iscsi_conn_error_event(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
> +	set_bit(DF_NO_RELOGIN,&ddb_entry->flags);
>   }
>
>   /***
> @@ -642,6 +643,24 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
>
>   	/* Search for relogin's to time-out and port down retry. */
>   	list_for_each_entry_safe(ddb_entry, dtemp,&ha->ddb_list, list) {
> +		/* First check to see if the device has exhausted the
> +		 * port down retry count */
> +		if (atomic_read(&ddb_entry->state) == DDB_STATE_MISSING) {
> +			if (atomic_read(&ddb_entry->port_down_timer) == 0)
> +				continue;
> +


How does the relogin work in this case?

- If you pull a cable and we mark devices missing, then when link up is 
detected will qla4xxx_isr_decode_mailbox set the AF_LINK_UP bit and then 
the driver will start to try and relogin? Or would you get a 
MBOX_ASTS_DATABASE_CHANGED aen, and then that notifies you that that the 
firmware detected link up and logged back in (so the state would then be 
DDB_DS_SESSION_ACTIVE?)?


- What cases do you get a databased change aen where the new device 
state indicates the session is non active so qla4xxx_process_ddb_changed 
calls qla4xxx_mark_device_missing? Would it be where the target logs us 
out, or when the firmware detects a problem with the session/connection 
and drop the session, what about if the firmware detects a link down?

In the case qla4xxx_process_ddb_changed calls 
qla4xxx_mark_device_missing will we get some sort of databased change 
aen indicating that the state is again DDB_DS_SESSION_ACTIVE?

- What cases do we now use the relogin code now? Do we always call 
qla4xxx_mark_device_missing in cases where a relogin is needed, so can 
we just remove the relogin code? Or is the relogin code still used for 
the initial driver initialization or something else?

