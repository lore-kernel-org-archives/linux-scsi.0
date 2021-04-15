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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE0BC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE2A610EA
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhDOMdZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhDOMdY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 08:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618489981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O+PpMl3Auyr8/71RqMpErMVeRjLOE3C4fJjrJ7UTOiQ=;
        b=HfwkgX8K1eRIT6dt0H86i2g5WV843ZDAzhZBaCu87UEvJ023DyByF1/1y2V9lDJu6oEZ4O
        Ie8qenWh0XxZU/nPPfj+SxxqYp7Nnq1KGpmdgepjls6J2i97Vye6RZoFCboybAfvRfReMh
        IGO3efLxlpVrHQgYtx9SKui6WdeDel4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-77nRXFMTMhCydubNoud-ew-1; Thu, 15 Apr 2021 08:32:59 -0400
X-MC-Unique: 77nRXFMTMhCydubNoud-ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3415E84E20A;
        Thu, 15 Apr 2021 12:32:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BFE162462;
        Thu, 15 Apr 2021 12:32:57 +0000 (UTC)
Subject: Re: [PATCH v2 18/24] mpi3mr: add complete support of soft reset
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-19-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <bad1d1d9-2e8f-949b-ab95-7bb3038149b5@redhat.com>
Date:   Thu, 15 Apr 2021 14:32:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-19-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> Unlock the host diagnostic registers and write the specific
> reset type to that, wait for reset acknowledgment from the
> controller, if the reset is not successful retry for the
> predefined number of times
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h    |   3 +
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 245 +++++++++++++++++++++++++++++++-
>  2 files changed, 246 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 3ac7b0f119bb..ff3e68a6d0b5 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -189,6 +189,9 @@ enum mpi3mr_reset_reason {
>  	MPI3MR_RESET_FROM_EVTACK_TIMEOUT = 19,
>  	MPI3MR_RESET_FROM_CIACTVRST_TIMER = 20,
>  	MPI3MR_RESET_FROM_GETPKGVER_TIMEOUT = 21,
> +	MPI3MR_RESET_FROM_PELABORT_TIMEOUT = 22,
> +	MPI3MR_RESET_FROM_SYSFS = 23,
> +	MPI3MR_RESET_FROM_SYSFS_TIMEOUT = 24
>  };
>  
>  /**
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 32b79876f0d2..79a9f98c736e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -642,6 +642,100 @@ static const char *mpi3mr_iocstate_name(enum mpi3mr_iocstate mrioc_state)
>  	return name;
>  }
>  
> +/* Reset reason to name mapper structure*/
> +static const struct {
> +	enum mpi3mr_reset_reason value;
> +	char *name;
> +} mpi3mr_reset_reason_codes[] = {
> +	{ MPI3MR_RESET_FROM_BRINGUP, "timeout in bringup" },
> +	{ MPI3MR_RESET_FROM_FAULT_WATCH, "fault" },
> +	{ MPI3MR_RESET_FROM_IOCTL, "application invocation" },
> +	{ MPI3MR_RESET_FROM_EH_HOS, "error handling" },
> +	{ MPI3MR_RESET_FROM_TM_TIMEOUT, "TM timeout" },
> +	{ MPI3MR_RESET_FROM_IOCTL_TIMEOUT, "IOCTL timeout" },
> +	{ MPI3MR_RESET_FROM_MUR_FAILURE, "MUR failure" },
> +	{ MPI3MR_RESET_FROM_CTLR_CLEANUP, "timeout in controller cleanup" },
> +	{ MPI3MR_RESET_FROM_CIACTIV_FAULT, "component image activation fault" },
> +	{ MPI3MR_RESET_FROM_PE_TIMEOUT, "port enable timeout" },
> +	{ MPI3MR_RESET_FROM_TSU_TIMEOUT, "time stamp update timeout" },
> +	{ MPI3MR_RESET_FROM_DELREQQ_TIMEOUT, "delete request queue timeout" },
> +	{ MPI3MR_RESET_FROM_DELREPQ_TIMEOUT, "delete reply queue timeout" },
> +	{
> +		MPI3MR_RESET_FROM_CREATEREPQ_TIMEOUT,
> +		"create request queue timeout"
> +	},
> +	{
> +		MPI3MR_RESET_FROM_CREATEREQQ_TIMEOUT,
> +		"create reply queue timeout"
> +	},
> +	{ MPI3MR_RESET_FROM_IOCFACTS_TIMEOUT, "IOC facts timeout" },
> +	{ MPI3MR_RESET_FROM_IOCINIT_TIMEOUT, "IOC init timeout" },
> +	{ MPI3MR_RESET_FROM_EVTNOTIFY_TIMEOUT, "event notify timeout" },
> +	{ MPI3MR_RESET_FROM_EVTACK_TIMEOUT, "event acknowledgment timeout" },
> +	{
> +		MPI3MR_RESET_FROM_CIACTVRST_TIMER,
> +		"component image activation timeout"
> +	},
> +	{
> +		MPI3MR_RESET_FROM_GETPKGVER_TIMEOUT,
> +		"get package version timeout"
> +	},
> +	{ MPI3MR_RESET_FROM_SYSFS, "sysfs invocation" },
> +	{ MPI3MR_RESET_FROM_SYSFS_TIMEOUT, "sysfs TM timeout" },
> +};
> +
> +/**
> + * mpi3mr_reset_rc_name - get reset reason code name
> + * @reason_code: reset reason code value
> + *
> + * Map reset reason to an NULL terminated ASCII string
> + *
> + * Return: Name corresponding to reset reason value or NULL.
> + */
> +static const char *mpi3mr_reset_rc_name(enum mpi3mr_reset_reason reason_code)
> +{
> +	int i;
> +	char *name = NULL;
> +
> +	for (i = 0; i < ARRAY_SIZE(mpi3mr_reset_reason_codes); i++) {
> +		if (mpi3mr_reset_reason_codes[i].value == reason_code) {
> +			name = mpi3mr_reset_reason_codes[i].name;
> +			break;
> +		}
> +	}
> +	return name;
> +}
> +
> +/* Reset type to name mapper structure*/
> +static const struct {
> +	u16 reset_type;
> +	char *name;
> +} mpi3mr_reset_types[] = {
> +	{ MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET, "soft" },
> +	{ MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, "diag fault" },
> +};
> +
> +/**
> + * mpi3mr_reset_type_name - get reset type name
> + * reset_type: reset type value
> + *
> + * Map reset type to an NULL terminated ASCII string
> + *
> + * Return: Name corresponding to reset type value or NULL.
> + */
> +static const char *mpi3mr_reset_type_name(u16 reset_type)
> +{
> +	int i;
> +	char *name = NULL;
> +
> +	for (i = 0; i < ARRAY_SIZE(mpi3mr_reset_types); i++) {
> +		if (mpi3mr_reset_types[i].reset_type == reset_type) {
> +			name = mpi3mr_reset_types[i].name;
> +			break;
> +		}
> +	}
> +	return name;
> +}
>  
>  /**
>   * mpi3mr_print_fault_info - Display fault information
> @@ -805,6 +899,48 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
>  	return -1;
>  }
>  
> +/**
> + * mpi3mr_soft_reset_success - Check softreset is success or not
> + * @ioc_status: IOC status register value
> + * @ioc_config: IOC config register value
> + *
> + * Check whether the soft reset is successful or not based on
> + * IOC status and IOC config register values.
> + *
> + * Return: True when the soft reset is success, false otherwise.
> + */
> +static inline bool
> +mpi3mr_soft_reset_success(u32 ioc_status, u32 ioc_config)
> +{
> +	if (!((ioc_status & MPI3_SYSIF_IOC_STATUS_READY) ||
> +	    (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT) ||
> +	    (ioc_config & MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC)))
> +		return true;
> +	return false;
> +}
> +
> +/**
> + * mpi3mr_diagfault_success - Check diag fault is success or not
> + * @mrioc: Adapter reference
> + * @ioc_status: IOC status register value
> + *
> + * Check whether the controller hit diag reset fault code.
> + *
> + * Return: True when there is diag fault, false otherwise.
> + */
> +static inline bool mpi3mr_diagfault_success(struct mpi3mr_ioc *mrioc,
> +	u32 ioc_status)
> +{
> +	u32 fault;
> +
> +	if (!(ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT))
> +		return false;
> +	fault = readl(&mrioc->sysif_regs->Fault) & MPI3_SYSIF_FAULT_CODE_MASK;
> +	if (fault == MPI3_SYSIF_FAULT_CODE_DIAG_FAULT_RESET)
> +		return true;
> +	return false;
> +}
> +
>  /**
>   * mpi3mr_set_diagsave - Set diag save bit for snapdump
>   * @mrioc: Adapter reference
> @@ -829,14 +965,117 @@ static inline void mpi3mr_set_diagsave(struct mpi3mr_ioc *mrioc)
>   * @reset_type: Reset type
>   * @reset_reason: Reset reason code
>   *
> - * TBD
> + * Unlock the host diagnostic registers and write the specific
> + * reset type to that, wait for reset acknowledgment from the
> + * controller, if the reset is not successful retry for the
> + * predefined number of times.
>   *
>   * Return: 0 on success, non-zero on failure.
>   */
>  static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
>  	u32 reset_reason)
>  {
> -	return 0;
> +	int retval = -1;
> +	u8 unlock_retry_count, reset_retry_count = 0;
> +	u32 host_diagnostic, timeout, ioc_status, ioc_config;
> +
> +	pci_cfg_access_lock(mrioc->pdev);
> +	if ((reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET) &&
> +	    (reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT))
> +		goto out;
> +	if (mrioc->unrecoverable)
> +		goto out;
> +retry_reset:
> +	unlock_retry_count = 0;
> +	mpi3mr_clear_reset_history(mrioc);
> +	do {
> +		ioc_info(mrioc,
> +		    "Write magic sequence to unlock host diag register (retry=%d)\n",
> +		    ++unlock_retry_count);
> +		if (unlock_retry_count >= MPI3MR_HOSTDIAG_UNLOCK_RETRY_COUNT) {
> +			writel(reset_reason, &mrioc->sysif_regs->Scratchpad[0]);
> +			mrioc->unrecoverable = 1;
> +			goto out;
> +		}
> +
> +		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_FLUSH,
> +		    &mrioc->sysif_regs->WriteSequence);
> +		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_1ST,
> +		    &mrioc->sysif_regs->WriteSequence);
> +		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
> +		    &mrioc->sysif_regs->WriteSequence);
> +		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_3RD,
> +		    &mrioc->sysif_regs->WriteSequence);
> +		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_4TH,
> +		    &mrioc->sysif_regs->WriteSequence);
> +		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_5TH,
> +		    &mrioc->sysif_regs->WriteSequence);
> +		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_6TH,
> +		    &mrioc->sysif_regs->WriteSequence);
> +		usleep_range(1000, 1100);
> +		host_diagnostic = readl(&mrioc->sysif_regs->HostDiagnostic);
> +		ioc_info(mrioc,
> +		    "wrote magic sequence: retry_count(%d), host_diagnostic(0x%08x)\n",
> +		    unlock_retry_count, host_diagnostic);
> +	} while (!(host_diagnostic & MPI3_SYSIF_HOST_DIAG_DIAG_WRITE_ENABLE));
> +
> +	writel(reset_reason, &mrioc->sysif_regs->Scratchpad[0]);
> +	ioc_info(mrioc, "%s reset due to %s(0x%x)\n",
> +	    mpi3mr_reset_type_name(reset_type),
> +	    mpi3mr_reset_rc_name(reset_reason), reset_reason);
> +	writel(host_diagnostic | reset_type,
> +	    &mrioc->sysif_regs->HostDiagnostic);
> +	timeout = mrioc->ready_timeout * 10;
> +	if (reset_type == MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET) {
> +		do {
> +			ioc_status = readl(&mrioc->sysif_regs->IOCStatus);
> +			if (ioc_status &
> +			    MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) {
> +				mpi3mr_clear_reset_history(mrioc);
> +				ioc_config =
> +				    readl(&mrioc->sysif_regs->IOCConfiguration);
> +				if (mpi3mr_soft_reset_success(ioc_status,
> +				    ioc_config)) {
> +					retval = 0;
> +					break;
> +				}
> +			}
> +			msleep(100);
> +		} while (--timeout);
> +		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
> +		    &mrioc->sysif_regs->WriteSequence);
> +	} else if (reset_type == MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT) {
> +		do {
> +			ioc_status = readl(&mrioc->sysif_regs->IOCStatus);
> +			if (mpi3mr_diagfault_success(mrioc, ioc_status)) {
> +				retval = 0;
> +				break;
> +			}
> +			msleep(100);
> +		} while (--timeout);
> +		mpi3mr_clear_reset_history(mrioc);
> +		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
> +		    &mrioc->sysif_regs->WriteSequence);
> +	}
> +	if (retval && ((++reset_retry_count) < MPI3MR_MAX_RESET_RETRY_COUNT)) {
> +		ioc_status = readl(&mrioc->sysif_regs->IOCStatus);
> +		ioc_config = readl(&mrioc->sysif_regs->IOCConfiguration);
> +		ioc_info(mrioc,
> +		    "Base IOC Sts/Config after reset try %d is (0x%x)/(0x%x)\n",
> +		    reset_retry_count, ioc_status, ioc_config);
> +		goto retry_reset;
> +	}
> +
> +out:
> +	pci_cfg_access_unlock(mrioc->pdev);
> +	ioc_status = readl(&mrioc->sysif_regs->IOCStatus);
> +	ioc_config = readl(&mrioc->sysif_regs->IOCConfiguration);
> +
> +	ioc_info(mrioc,
> +	    "Base IOC Sts/Config after %s reset is (0x%x)/(0x%x)\n",
> +	    (!retval)?"successful":"failed", ioc_status,
> +	    ioc_config);
> +	return retval;
>  }
>  
>  /**
> @@ -3458,6 +3697,8 @@ int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
>  {
>  	int retval = 0;
>  
> +	ioc_info(mrioc, "Entry: reason code: %s\n",
> +	    mpi3mr_reset_rc_name(reset_reason));
>  	mrioc->reset_in_progress = 1;
>  
>  	mpi3mr_ioc_disable_intr(mrioc);
> 

Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

