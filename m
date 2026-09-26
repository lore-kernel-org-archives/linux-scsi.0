Received: from outbound.easymail.ca (outbound.easymail.ca [64.68.200.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2FD256C87
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 20:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.68.200.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790453463; cv=none; b=sE4vsLEby2N336Gr/fl2cDx+kASN8KRu3xhOOczuu/mIX63Smf4PboYktEtMQCfLl6mDX3p1VtPX3k/uZUEbDXi/KIR7UviLNmqudQxniYdrHdDrTrH9iDw4J9w+k5VDSOJKc1x6H+G2+xOnRCw7eo27Q7QaU44PAt6hea4f1gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790453463; c=relaxed/simple;
	bh=K3R6d07wjw7x1Ai2thzEDSDYXK9yy1KWYIYMSDYWhxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KnvVRj12bKTadS5rtZRZwDHj9dH/5rNuMYUraI9mjIGR8JI1AIBhQxnc2nOmrZtg+LytmQtfCb2p3Zn4MpP/H5oMrT9Q2bf2Fl2W27yVFF0/FyvmFoGiG6nQ47TtzDoCgM7WLflG6JouqOF0DgTHlJFqC/GYHqs1ArB5HLO5Oio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org; spf=pass smtp.mailfrom=gonehiking.org; dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b=AAdwDORT; dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b=mMARH68n; arc=none smtp.client-ip=64.68.200.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b="AAdwDORT";
	dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b="mMARH68n"
Received: from mailout.easymail.ca (pco.easydns.net [64.68.203.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by outbound.easymail.ca (Postfix) with ESMTPS id 4412D20BAD;
	Sat, 26 Sep 2026 20:02:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mailout.easymail.ca (Postfix) with ESMTP id 3049861048;
	Sat, 26 Sep 2026 20:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gonehiking.org;
	s=easymail; t=1790452959;
	bh=B6lIHc5mw1C+4unqP42VKEQvtWxLSqeaUS+W/+l84ZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AAdwDORTp+bAQb9EI3tmmC407SvL2fcpsmOqWRfO2MMs8TA/GHeC+hoAcjv2zBHJh
	 ZknDie51Z0wohBEI90l5tSg24Zg8t3sNsPzCmK1C3HixRKV7woI0iXhwtCkboF4s44
	 jVOBDjsO1C6yQ91DmSJlw4Z/lpZ3zdhUC0RGFRV/qprN9UaCPg+3DThO1mXQx9+Dan
	 2YlSi2T/fOWWGRFXxMSKKqXYfqOTGjyGZAG2mkMyT0dSdtGW+cTaLIxWTZiqwB8Ain
	 T8+kx3AzHgAmAQ76cYqrYlEE9aCOuO2C8KRAuWmSF29QHbsH7NGauP8LqUP41szCer
	 JJRR8qNHPIHRQ==
X-Virus-Scanned: Debian amavisd-new at emo09-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
	by localhost (emo09-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eI5m10kyBMLo; Sat, 26 Sep 2026 20:02:38 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by mailout.easymail.ca (Postfix) with ESMTPSA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gonehiking.org;
	s=easymail; t=1790452958;
	bh=B6lIHc5mw1C+4unqP42VKEQvtWxLSqeaUS+W/+l84ZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mMARH68nLiPkT3Jn6PG+KoM62sXHIfWm62oUwWg+vdQhStDE73dEyfsWH/XO3ph0I
	 aNwxLk0jbaWK0ZaOk74qbnzTSds6Mkv6YJ3/t1nxuhTzT6RzWiQZSzDWVg5s2Nd59g
	 LZGhkAuDzB2lqIAtYrbu9d++I8pu+Rbi3gkjyK25TzXi+xaY3qfke/nX2iyMRNDrM0
	 Lc+/VPsYszSQWEChBTFUSP2ncc5EcIzQidraH8rn8miXHv32+51dOIHis3Ed7jjU0h
	 iNZiI62CPfuUOEakuYN8bQLPdHYRAOVyJ51nSyBzargTujtAJyyrydcJwVlV0pkeZ3
	 95X+lu3XY2tDw==
Received: from [127.0.0.1] (localhost [127.0.0.1]) by mailout.easymail.ca (Postfix) with ESMTPSA
Received: by rhapsody (Postfix, from userid 1000)
	id 058EC1E043D; Sat, 26 Sep 2026 14:02:37 -0600 (MDT)
Date: Sat, 26 Sep 2026 14:02:36 -0600
From: Khalid Aziz <khalid@gonehiking.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: Re: [PATCH v4 04/54] scsi: BusLogic: Pass the host pointer directly
 to several functions
Message-ID: <argk3DLMl_YSDOsV@gonehiking.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>

On Fri, Sep 25, 2026 at 11:25:42AM -0700, Bart Van Assche wrote:
> Pass the struct Scsi_Host pointer directly to multiple functions. This
> prepares the BusLogic driver for enabling compiler-based lock context
> analysis. No functionality has been changed.
> 
> Cc: Khalid Aziz <khalid@gonehiking.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/BusLogic.c | 93 +++++++++++++++++++++++------------------
>  drivers/scsi/BusLogic.h |  2 +-
>  2 files changed, 54 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 27b446c0c5d0..75aaf35383a9 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
..... snip.....
>  
> @@ -2878,11 +2883,11 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt)
>    Outgoing Mailbox for execution by the associated Host Adapter.
>  */
>  
> -static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
> +static enum scsi_qc_status blogic_qcmd_lck(struct Scsi_Host *shost, struct scsi_cmnd *command)

Buslogic.c defines blogic_qcmd() usind "DEF_SCSI_QCMD(blogic_qcmd)" which in turn will call
blogic_qcmd_lck() with just struct *scsi_cmd as a single parameter as defined in 
include/scsi/scsi_host.h. I did not see an update to DEF_SCSI_QCMD in patches 1-3. With this
change, callers are not being updated and that will not work. Can you double check this?

Thanks,
Khalid

>  {
>  	void (*comp_cb)(struct scsi_cmnd *) = scsi_done;
>  	struct blogic_adapter *adapter =
> -		(struct blogic_adapter *) command->device->host->hostdata;
> +		(struct blogic_adapter *) shost->hostdata;
>  	struct blogic_tgt_flags *tgt_flags =
>  		&adapter->tgt_flags[command->device->id];
>  	struct blogic_tgt_stats *tgt_stats = adapter->tgt_stats;
> @@ -2913,12 +2918,12 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
>  	   probably hung so signal an error as a Host Adapter Hard Reset
>  	   should be initiated soon.
>  	 */
> -	ccb = blogic_alloc_ccb(adapter);
> +	ccb = blogic_alloc_ccb(shost);
>  	if (ccb == NULL) {
> -		spin_unlock_irq(&adapter->scsi_host->host_lock);
> +		spin_unlock_irq(&shost->host_lock);
>  		blogic_delay(1);
> -		spin_lock_irq(&adapter->scsi_host->host_lock);
> -		ccb = blogic_alloc_ccb(adapter);
> +		spin_lock_irq(&shost->host_lock);
> +		ccb = blogic_alloc_ccb(shost);
>  		if (ccb == NULL) {
>  			command->result = DID_ERROR << 16;
>  			comp_cb(command);
> @@ -3046,7 +3051,7 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
>  	if (dma_mapping_error(&adapter->pci_device->dev, sense_buf)) {
>  		blogic_err("DMA mapping for sense data buffer failed\n",
>  				adapter);
> -		blogic_dealloc_ccb(ccb, 0);
> +		blogic_dealloc_ccb(shost, ccb, 0);
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	}
>  	ccb->sensedata = sense_buf;
> @@ -3061,15 +3066,15 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
>  		   so signal an error as a Host Adapter Hard Reset should
>  		   be initiated soon.
>  		 */
> -		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
> -			spin_unlock_irq(&adapter->scsi_host->host_lock);
> +		if (!blogic_write_outbox(shost, BLOGIC_MBOX_START, ccb)) {
> +			spin_unlock_irq(&shost->host_lock);
>  			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\n", adapter);
>  			blogic_delay(1);
> -			spin_lock_irq(&adapter->scsi_host->host_lock);
> -			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
> +			spin_lock_irq(&shost->host_lock);
> +			if (!blogic_write_outbox(shost, BLOGIC_MBOX_START,
>  						ccb)) {
>  				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter Dead?\n", adapter);
> -				blogic_dealloc_ccb(ccb, 1);
> +				blogic_dealloc_ccb(shost, ccb, 1);
>  				command->result = DID_ERROR << 16;
>  				scsi_done(command);
>  			}
> @@ -3089,12 +3094,20 @@ static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
>  		   pending.
>  		 */
>  		if (ccb->status == BLOGIC_CCB_COMPLETE)
> -			blogic_process_ccbs(adapter);
> +			blogic_process_ccbs(shost);
>  	}
>  	return 0;
>  }
>  
> -static DEF_SCSI_QCMD(blogic_qcmd)
> +static enum scsi_qc_status blogic_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> +{
> +	enum scsi_qc_status rc;
> +
> +	spin_lock_irq(&shost->host_lock);
> +	rc = blogic_qcmd_lck(shost, cmd);
> +	spin_unlock_irq(&shost->host_lock);
> +	return rc;
> +}
>  
>  #if 0
>  /*
> @@ -3103,9 +3116,8 @@ static DEF_SCSI_QCMD(blogic_qcmd)
>  
>  static int blogic_abort(struct scsi_cmnd *command)
>  {
> -	struct blogic_adapter *adapter =
> -		(struct blogic_adapter *) command->device->host->hostdata;
> -
> +	struct Scsi_Host *const shost = command->device->host;
> +	struct blogic_adapter *adapter = (void *) shost->hostdata;
>  	int tgt_id = command->device->id;
>  	struct blogic_ccb *ccb;
>  	blogic_inc_count(&adapter->tgt_stats[tgt_id].aborts_request);
> @@ -3144,7 +3156,7 @@ static int blogic_abort(struct scsi_cmnd *command)
>  				adapter->fw_ver[0] < '5') {
>  			blogic_warn("Unable to Abort CCB #%ld to Target %d - Abort Tag Not Supported\n", adapter, ccb->serial, tgt_id);
>  			return FAILURE;
> -		} else if (blogic_write_outbox(adapter, BLOGIC_MBOX_ABORT,
> +		} else if (blogic_write_outbox(shost, BLOGIC_MBOX_ABORT,
>  					ccb)) {
>  			blogic_warn("Aborting CCB #%ld to Target %d\n",
>  					adapter, ccb->serial, tgt_id);
> @@ -3169,7 +3181,7 @@ static int blogic_abort(struct scsi_cmnd *command)
>  		   may still be pending.
>  		 */
>  		if (ccb->status == BLOGIC_CCB_COMPLETE)
> -			blogic_process_ccbs(adapter);
> +			blogic_process_ccbs(shost);
>  		return SUCCESS;
>  	}
>  	return SUCCESS;
> @@ -3181,8 +3193,9 @@ static int blogic_abort(struct scsi_cmnd *command)
>    currently executing SCSI Commands as having been Reset.
>  */
>  
> -static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_reset)
> +static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset)
>  {
> +	struct blogic_adapter *adapter = (void *)host->hostdata;
>  	struct blogic_ccb *ccb;
>  	int tgt_id;
>  
> @@ -3203,7 +3216,7 @@ static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_reset)
>  
>  	for (ccb = adapter->all_ccbs; ccb != NULL; ccb = ccb->next_all)
>  		if (ccb->status == BLOGIC_CCB_ACTIVE)
> -			blogic_dealloc_ccb(ccb, 1);
> +			blogic_dealloc_ccb(host, ccb, 1);
>  	/*
>  	 * Wait a few seconds between the Host Adapter Hard Reset which
>  	 * initiates a SCSI Bus Reset and issuing any SCSI Commands.  Some
> @@ -3212,9 +3225,9 @@ static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_reset)
>  	 */
>  
>  	if (hard_reset) {
> -		spin_unlock_irq(&adapter->scsi_host->host_lock);
> +		spin_unlock_irq(&host->host_lock);
>  		blogic_delay(adapter->bus_settle_time);
> -		spin_lock_irq(&adapter->scsi_host->host_lock);
> +		spin_lock_irq(&host->host_lock);
>  	}
>  
>  	for (tgt_id = 0; tgt_id < adapter->maxdev; tgt_id++) {
> diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
> index 24697a5bedc8..6ace3c307a90 100644
> --- a/drivers/scsi/BusLogic.h
> +++ b/drivers/scsi/BusLogic.h
> @@ -1279,7 +1279,7 @@ static int blogic_sdev_configure(struct scsi_device *,
>  				 struct queue_limits *lim);
>  static void blogic_qcompleted_ccb(struct blogic_ccb *);
>  static irqreturn_t blogic_inthandler(int, void *);
> -static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset);
> +static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset);
>  static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapter *, ...);
>  static int __init blogic_setup(char *);
>  
