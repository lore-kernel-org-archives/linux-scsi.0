From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH V1 16/24] qla4xxx: Fix failure of mbox 0x31
Date: Fri, 17 Jan 2014 12:19:44 -0600
Message-ID: <52D97440.6080807@cs.wisc.edu>
References: <1389951808-4130-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48547 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaAQSUA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 13:20:00 -0500
In-Reply-To: <1389951808-4130-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com

On 01/17/2014 03:43 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> Issue:
> While unloading driver MBOX 0x31 fail as DDB logout (MBOX 0x56)
> operation is not completed.
> 
> Fix:
> Wait for DDB Logout completion before MBOX 0x31
> 
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 56 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index a27da31..7807a13 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -8886,10 +8886,56 @@ static void qla4xxx_prevent_other_port_reinit(struct scsi_qla_host *ha)
>  	}
>  }
>  
> +static void qla4xxx_destroy_ddb(struct scsi_qla_host *ha,
> +		struct ddb_entry *ddb_entry)
> +{
> +	struct dev_db_entry *fw_ddb_entry = NULL;
> +	dma_addr_t fw_ddb_entry_dma;
> +	unsigned long wtime;
> +	uint32_t ddb_state;
> +	int options;
> +	int status;
> +
> +	options = LOGOUT_OPTION_CLOSE_SESSION;
> +	if (qla4xxx_session_logout_ddb(ha, ddb_entry, options) == QLA_ERROR) {
> +		ql4_printk(KERN_ERR, ha, "%s: Logout failed\n", __func__);
> +		goto clear_ddb;
> +	}
> +
> +	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
> +					  &fw_ddb_entry_dma, GFP_KERNEL);
> +	if (!fw_ddb_entry) {
> +		ql4_printk(KERN_ERR, ha,
> +			   "%s: Unable to allocate dma buffer\n", __func__);
> +		goto clear_ddb;
> +	}
> +
> +	wtime = jiffies + (HZ * LOGOUT_TOV);
> +	do {
> +		status = qla4xxx_get_fwddb_entry(ha, ddb_entry->fw_ddb_index,
> +						 fw_ddb_entry, fw_ddb_entry_dma,
> +						 NULL, NULL, &ddb_state, NULL,
> +						 NULL, NULL);
> +		if (status == QLA_ERROR)
> +			goto free_ddb;
> +
> +		if ((ddb_state == DDB_DS_NO_CONNECTION_ACTIVE) ||
> +		    (ddb_state == DDB_DS_SESSION_FAILED))
> +			goto free_ddb;
> +
> +		schedule_timeout_uninterruptible(HZ);
> +	} while ((time_after(wtime, jiffies)));
> +
> +free_ddb:
> +	dma_free_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
> +			  fw_ddb_entry, fw_ddb_entry_dma);
> +clear_ddb:
> +	qla4xxx_clear_ddb_entry(ha, ddb_entry->fw_ddb_index);
> +}


Looks ok now.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

