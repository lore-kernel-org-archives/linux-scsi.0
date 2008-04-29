From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/2] scsi: Add helper code so transport classes/driver
 can control queueing
Date: Tue, 29 Apr 2008 09:48:10 -0400
Message-ID: <4817271A.8020708@emulex.com>
References: <1209442937-15130-1-git-send-email-michaelc@cs.wisc.edu> <1209442937-15130-2-git-send-email-michaelc@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:47921 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762020AbYD2NsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Apr 2008 09:48:21 -0400
In-Reply-To: <1209442937-15130-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org



michaelc@cs.wisc.edu wrote:
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index f6a9fe0..06b7b59 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -206,6 +206,16 @@ struct scsi_target {
>  						 * for the device at a time. */
>  	unsigned int		pdt_1f_for_no_lun;	/* PDT = 0x1f */
>  						/* means no lun present */
> +	/* commands actually active on LLD. protected by host lock. */
> +	unsigned int		target_busy;
> +	/*
> +	 * LLDs should set this in the slave_alloc host template callout.
> +	 * If set to zero then there is not limit.
> +	 */
> +	unsigned int		can_queue;
> +	unsigned int		target_blocked;
> +	unsigned int		max_target_blocked;
> +#define SCSI_DEFAULT_TARGET_BLOCKED	3
>  
>  	char			scsi_level;
>  	struct execute_work	ew;

Mike,

The starget->can_queue value should come from the targets device_list entry, not the LLD.

To complete this fully, if the LLD had a per-target resource restriction (which I doubt
would be target-specific), it should set a value within the shost template much along the
lines of the shost->can_queue. The starget->can_queue would then be the
min(shost->tgt_can_queue, device_list->tgt_can_queue) and would be set in the scsi_scan code.

-- james s

