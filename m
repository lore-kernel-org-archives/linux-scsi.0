Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6BCC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB996613A9
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhDOKiG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:38:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231251AbhDOKiG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 06:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618483063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dmT2zVCaupdd3mnFC7E9fqYZdcNDgWpt4LFSuosrIcs=;
        b=PYGdSlXBdTiwegNjkL3cWj5Bof10SNzCJCSkZJ+1f8AUUmYgthxrVuP+5A46qW+wshguJc
        MGI6wDrvMSafWeBnp3tYmDWnodIqJknAc0dBtILpd4HsID3p7Nb/6FMAWaTP8XFo7WrrHX
        L97K+wX8IuKS53TxSeeKUbf+Oindk0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-AuofxZyvNfKZC3uQvmRfsw-1; Thu, 15 Apr 2021 06:37:41 -0400
X-MC-Unique: AuofxZyvNfKZC3uQvmRfsw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5AC710054F6;
        Thu, 15 Apr 2021 10:37:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA6235C1B4;
        Thu, 15 Apr 2021 10:37:39 +0000 (UTC)
Subject: Re: [PATCH v2 05/24] mpi3mr: add support of internal watchdog thread
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-6-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <a44019ac-6632-6403-8098-1a5202dab1bb@redhat.com>
Date:   Thu, 15 Apr 2021 12:37:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-6-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> Watchdog thread is driver's internal thread which does few things like
> detecting FW fault and reset the controller, Timestamp sync etc.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h    |  11 +++
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 125 ++++++++++++++++++++++++++++++++
>  drivers/scsi/mpi3mr/mpi3mr_os.c |   3 +
>  3 files changed, 139 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 00a1b63a6e16..7769ba16c9bc 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -478,6 +478,10 @@ struct scmd_priv {
>   * @sense_buf_q_dma: Sense buffer queue DMA address
>   * @sbq_lock: Sense buffer queue lock
>   * @sbq_host_index: Sense buffer queuehost index
> + * @watchdog_work_q_name: Fault watchdog worker thread name
> + * @watchdog_work_q: Fault watchdog worker thread
> + * @watchdog_work: Fault watchdog work
> + * @watchdog_lock: Fault watchdog lock
>   * @is_driver_loading: Is driver still loading
>   * @scan_started: Async scan started
>   * @scan_failed: Asycn scan failed
> @@ -491,6 +495,7 @@ struct scmd_priv {
>   * @chain_buf_lock: Chain buffer list lock
>   * @reset_in_progress: Reset in progress flag
>   * @unrecoverable: Controller unrecoverable flag
> + * @diagsave_timeout: Diagnostic information save timeout
>   * @logging_level: Controller debug logging level
>   * @current_event: Firmware event currently in process
>   * @driver_info: Driver, Kernel, OS information to firmware
> @@ -572,6 +577,11 @@ struct mpi3mr_ioc {
>  	spinlock_t sbq_lock;
>  	u32 sbq_host_index;
>  
> +	char watchdog_work_q_name[20];
> +	struct workqueue_struct *watchdog_work_q;
> +	struct delayed_work watchdog_work;
> +	spinlock_t watchdog_lock;
> +
>  	u8 is_driver_loading;
>  	u8 scan_started;
>  	u16 scan_failed;
> @@ -589,6 +599,7 @@ struct mpi3mr_ioc {
>  	u8 reset_in_progress;
>  	u8 unrecoverable;
>  
> +	u16 diagsave_timeout;
>  	int logging_level;
>  
>  	struct mpi3mr_fwevt *current_event;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index a87a3edde2e7..ef238091523b 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1478,6 +1478,129 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
>  	return retval;
>  }
>  
> +/**
> + * mpi3mr_watchdog_work - watchdog thread to monitor faults
> + * @work: work struct
> + *
> + * Watch dog work periodically executed (1 second interval) to
> + * monitor firmware fault and to issue periodic timer sync to
> + * the firmware.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_watchdog_work(struct work_struct *work)
> +{
> +	struct mpi3mr_ioc *mrioc =
> +	    container_of(work, struct mpi3mr_ioc, watchdog_work.work);
> +	unsigned long flags;
> +	enum mpi3mr_iocstate ioc_state;
> +	u32 fault, host_diagnostic;
> +
> +	/*Check for fault state every one second and issue Soft reset*/
> +	ioc_state = mpi3mr_get_iocstate(mrioc);
> +	if (ioc_state == MRIOC_STATE_FAULT) {
> +		fault = readl(&mrioc->sysif_regs->Fault) &
> +		    MPI3_SYSIF_FAULT_CODE_MASK;
> +		host_diagnostic = readl(&mrioc->sysif_regs->HostDiagnostic);
> +		if (host_diagnostic & MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS) {
> +			if (!mrioc->diagsave_timeout) {
> +				mpi3mr_print_fault_info(mrioc);
> +				ioc_warn(mrioc, "Diag save in progress\n");
> +			}
> +			if ((mrioc->diagsave_timeout++) <=
> +			    MPI3_SYSIF_DIAG_SAVE_TIMEOUT)
> +				goto schedule_work;
> +		} else
> +			mpi3mr_print_fault_info(mrioc);
> +		mrioc->diagsave_timeout = 0;
> +
> +		if (fault == MPI3_SYSIF_FAULT_CODE_FACTORY_RESET) {
> +			ioc_info(mrioc,
> +			    "Factory Reset Fault occurred marking controller as unrecoverable"
> +			    );
> +			mrioc->unrecoverable = 1;
> +			goto out;
> +		}
> +
> +		if ((fault == MPI3_SYSIF_FAULT_CODE_DIAG_FAULT_RESET)
> +		    || (fault == MPI3_SYSIF_FAULT_CODE_SOFT_RESET_IN_PROGRESS)
> +		    || (mrioc->reset_in_progress))
> +			goto out;
> +		if (fault == MPI3_SYSIF_FAULT_CODE_CI_ACTIVATION_RESET)
> +			mpi3mr_soft_reset_handler(mrioc,
> +			    MPI3MR_RESET_FROM_CIACTIV_FAULT, 0);
> +		else
> +			mpi3mr_soft_reset_handler(mrioc,
> +			    MPI3MR_RESET_FROM_FAULT_WATCH, 0);
> +	}
> +
> +schedule_work:
> +	spin_lock_irqsave(&mrioc->watchdog_lock, flags);
> +	if (mrioc->watchdog_work_q)
> +		queue_delayed_work(mrioc->watchdog_work_q,
> +		    &mrioc->watchdog_work,
> +		    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
> +	spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
> +out:
> +	return;
> +}
> +
> +/**
> + * mpi3mr_start_watchdog - Start watchdog
> + * @mrioc: Adapter instance reference
> + *
> + * Create and start the watchdog thread to monitor controller
> + * faults.
> + *
> + * Return: Nothing.
> + */
> +void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc)
> +{
> +	if (mrioc->watchdog_work_q)
> +		return;
> +
> +	INIT_DELAYED_WORK(&mrioc->watchdog_work, mpi3mr_watchdog_work);
> +	snprintf(mrioc->watchdog_work_q_name,
> +	    sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
> +	    mrioc->id);
> +	mrioc->watchdog_work_q =
> +	    create_singlethread_workqueue(mrioc->watchdog_work_q_name);
> +	if (!mrioc->watchdog_work_q) {
> +		ioc_err(mrioc, "%s: failed (line=%d)\n", __func__, __LINE__);
> +		return;
> +	}
> +
> +	if (mrioc->watchdog_work_q)
> +		queue_delayed_work(mrioc->watchdog_work_q,
> +		    &mrioc->watchdog_work,
> +		    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
> +}
> +
> +/**
> + * mpi3mr_stop_watchdog - Stop watchdog
> + * @mrioc: Adapter instance reference
> + *
> + * Stop the watchdog thread created to monitor controller
> + * faults.
> + *
> + * Return: Nothing.
> + */
> +void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc)
> +{
> +	unsigned long flags;
> +	struct workqueue_struct *wq;
> +
> +	spin_lock_irqsave(&mrioc->watchdog_lock, flags);
> +	wq = mrioc->watchdog_work_q;
> +	mrioc->watchdog_work_q = NULL;
> +	spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
> +	if (wq) {
> +		if (!cancel_delayed_work_sync(&mrioc->watchdog_work))
> +			flush_workqueue(wq);
> +		destroy_workqueue(wq);
> +	}
> +}
> +
>  
>  /**
>   * mpi3mr_setup_admin_qpair - Setup admin queue pair
> @@ -2632,6 +2755,8 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
>  {
>  	enum mpi3mr_iocstate ioc_state;
>  
> +	mpi3mr_stop_watchdog(mrioc);
> +
>  	mpi3mr_ioc_disable_intr(mrioc);
>  
>  	ioc_state = mpi3mr_get_iocstate(mrioc);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 01be5f337826..7b0d52481929 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -570,6 +570,7 @@ static int mpi3mr_scan_finished(struct Scsi_Host *shost,
>  	if (mrioc->scan_started)
>  		return 0;
>  	ioc_info(mrioc, "%s :port enable: SUCCESS\n", __func__);
> +	mpi3mr_start_watchdog(mrioc);
>  	mrioc->is_driver_loading = 0;
>  
>  	return 1;
> @@ -856,9 +857,11 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	spin_lock_init(&mrioc->admin_req_lock);
>  	spin_lock_init(&mrioc->reply_free_queue_lock);
>  	spin_lock_init(&mrioc->sbq_lock);
> +	spin_lock_init(&mrioc->watchdog_lock);
>  	spin_lock_init(&mrioc->chain_buf_lock);
>  
>  	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
> +
>  	if (pdev->revision)
>  		mrioc->enable_segqueue = true;
>  
> 
Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>


