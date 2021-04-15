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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6443CC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 11:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3946A610E8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 11:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhDOLXJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 07:23:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230202AbhDOLXI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 07:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618485765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qIqLvuDwyTiW4nY3bPS8p4tSdHqBSPx6LRmZ8yzNE4w=;
        b=eEHH0D1vn5yatCRBbzNv88j7xShkF/0xGnTJDmHESo3wopyUNYcL9juKEepY4FNSpk+C+O
        bDgpGmKIxsMSVri0kzJPuKXu1nhQv7IHpefXmhGqG+HFsY2ZBnebazWGAPJAJnNcIeVSEh
        HIo5n0CKDYOQsLmxnjUka7TzBmlNMtw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-lVbmABf6NKKkYqW7YKkwpw-1; Thu, 15 Apr 2021 07:22:44 -0400
X-MC-Unique: lVbmABf6NKKkYqW7YKkwpw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED41C801814;
        Thu, 15 Apr 2021 11:22:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DF6C437F;
        Thu, 15 Apr 2021 11:22:41 +0000 (UTC)
Subject: Re: [PATCH v2 10/24] mpi3mr: add support of timestamp sync with
 firmware
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-11-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <56b1742d-7513-8679-4030-093e97ed40ae@redhat.com>
Date:   Thu, 15 Apr 2021 13:22:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-11-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> This operation requests that the IOC update the TimeStamp.
> 
> When the I/O Unit is powered on, it sets the TimeStamp field value to
> 0x0000_0000_0000_0000 and increments the current value every millisecond.
> A host driver sets the TimeStamp field to the current time by using an
> IOCInit request. The TimeStamp field is periodically updated by host driver.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h    |  3 ++
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 74 +++++++++++++++++++++++++++++++++
>  2 files changed, 77 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index d18bfb954bc4..801612c9eb2a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -99,6 +99,7 @@ extern struct list_head mrioc_list;
>  #define MPI3MR_PORTENABLE_TIMEOUT		300
>  #define MPI3MR_RESETTM_TIMEOUT			30
>  #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
> +#define MPI3MR_TSUPDATE_INTERVAL		900
>  #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
>  
>  #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
> @@ -631,6 +632,7 @@ struct scmd_priv {
>   * @dev_handle_bitmap_sz: Device handle bitmap size
>   * @removepend_bitmap: Remove pending bitmap
>   * @delayed_rmhs_list: Delayed device removal list
> + * @ts_update_counter: Timestamp update counter
>   * @fault_dbg: Fault debug flag
>   * @reset_in_progress: Reset in progress flag
>   * @unrecoverable: Controller unrecoverable flag
> @@ -753,6 +755,7 @@ struct mpi3mr_ioc {
>  	void *removepend_bitmap;
>  	struct list_head delayed_rmhs_list;
>  
> +	u32 ts_update_counter;
>  	u8 fault_dbg;
>  	u8 reset_in_progress;
>  	u8 unrecoverable;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index b8e9c87ea677..d47031d05322 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1485,6 +1485,74 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
>  	return retval;
>  }
>  
> +/**
> + * mpi3mr_sync_timestamp - Issue time stamp sync request
> + * @mrioc: Adapter reference
> + *
> + * Issue IO unit control MPI request to synchornize firmware
> + * timestamp with host time.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +static int mpi3mr_sync_timestamp(struct mpi3mr_ioc *mrioc)
> +{
> +	ktime_t current_time;
> +	Mpi3IoUnitControlRequest_t iou_ctrl;
> +	int retval = 0;
> +
> +	memset(&iou_ctrl, 0, sizeof(iou_ctrl));
> +	mutex_lock(&mrioc->init_cmds.mutex);
> +	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
> +		retval = -1;
> +		ioc_err(mrioc, "Issue IOUCTL TimeStamp: command is in use\n");
> +		mutex_unlock(&mrioc->init_cmds.mutex);
> +		goto out;
> +	}
> +	mrioc->init_cmds.state = MPI3MR_CMD_PENDING;
> +	mrioc->init_cmds.is_waiting = 1;
> +	mrioc->init_cmds.callback = NULL;
> +	iou_ctrl.HostTag = cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
> +	iou_ctrl.Function = MPI3_FUNCTION_IO_UNIT_CONTROL;
> +	iou_ctrl.Operation = MPI3_CTRL_OP_UPDATE_TIMESTAMP;
> +	current_time = ktime_get_real();
> +	iou_ctrl.Param64[0] = cpu_to_le64(ktime_to_ms(current_time));
> +
> +	init_completion(&mrioc->init_cmds.done);
> +	retval = mpi3mr_admin_request_post(mrioc, &iou_ctrl,
> +	    sizeof(iou_ctrl), 0);
> +	if (retval) {
> +		ioc_err(mrioc, "Issue IOUCTL TimeStamp: Admin Post failed\n");
> +		goto out_unlock;
> +	}
> +
> +	wait_for_completion_timeout(&mrioc->init_cmds.done,
> +	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
> +	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
> +		ioc_err(mrioc, "Issue IOUCTL TimeStamp: command timed out\n");
> +		mrioc->init_cmds.is_waiting = 0;
> +		mpi3mr_soft_reset_handler(mrioc,
> +		    MPI3MR_RESET_FROM_TSU_TIMEOUT, 1);
> +		retval = -1;
> +		goto out_unlock;
> +	}
> +	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
> +	    != MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc,
> +		    "Issue IOUCTL TimeStamp: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
> +		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
> +		    mrioc->init_cmds.ioc_loginfo);
> +		retval = -1;
> +		goto out_unlock;
> +	}
> +
> +out_unlock:
> +	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
> +	mutex_unlock(&mrioc->init_cmds.mutex);
> +
> +out:
> +	return retval;
> +}
> +
>  /**
>   * mpi3mr_watchdog_work - watchdog thread to monitor faults
>   * @work: work struct
> @@ -1503,6 +1571,11 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
>  	enum mpi3mr_iocstate ioc_state;
>  	u32 fault, host_diagnostic;
>  
> +	if (mrioc->ts_update_counter++ >= MPI3MR_TSUPDATE_INTERVAL) {
> +		mrioc->ts_update_counter = 0;
> +		mpi3mr_sync_timestamp(mrioc);
> +	}
> +
>  	/*Check for fault state every one second and issue Soft reset*/
>  	ioc_state = mpi3mr_get_iocstate(mrioc);
>  	if (ioc_state == MRIOC_STATE_FAULT) {
> @@ -3313,6 +3386,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
>  		mrioc->reset_in_progress = 0;
>  		scsi_unblock_requests(mrioc->shost);
>  		mpi3mr_rfresh_tgtdevs(mrioc);
> +		mrioc->ts_update_counter = 0;
>  		spin_lock_irqsave(&mrioc->watchdog_lock, flags);
>  		if (mrioc->watchdog_work_q)
>  			queue_delayed_work(mrioc->watchdog_work_q,
> 

Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

