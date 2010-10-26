From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH v2 08/11] qla4xxx: Remove host_lock unlock() + lock()
 from qla4xxx_queuecommand()
Date: Mon, 25 Oct 2010 18:57:00 -0700
Message-ID: <alpine.OSX.1.10.1010251821000.5418@ranands-computer-2.local>
References: <1284747775-20995-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:32514 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0JZB44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2010 21:56:56 -0400
In-Reply-To: <1284747775-20995-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>



On Fri, 17 Sep 2010, Nicholas A. Bellinger wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch removes the now legacy host_lock unlock() + lock() optimization
> from ql4_os.c:qla4xxx_queuecommand()
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 370d40f..cfbe8b5 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -511,26 +511,20 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
>  	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))
>  		goto qc_host_busy;
>  
> -	spin_unlock_irq(ha->host->host_lock);
> -
>  	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
>  	if (!srb)
> -		goto qc_host_busy_lock;
> +		goto qc_host_busy;
>  
>  	rval = qla4xxx_send_command_to_isp(ha, srb);
>  	if (rval != QLA_SUCCESS)
>  		goto qc_host_busy_free_sp;
>  
> -	spin_lock_irq(ha->host->host_lock);
>  	return 0;
>  
>  qc_host_busy_free_sp:
>  	qla4xxx_srb_free_dma(ha, srb);
>  	mempool_free(srb, ha->srb_mempool);
>  
> -qc_host_busy_lock:
> -	spin_lock_irq(ha->host->host_lock);
> -
>  qc_host_busy:
>  	return SCSI_MLQUEUE_HOST_BUSY;
>  

Let us know if you want us to send it to James
as part of our patch posting. Thanks.

Acked-by: Ravi Anand <ravi.anand@qlogic.com>
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
