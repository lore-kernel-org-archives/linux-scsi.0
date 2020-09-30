Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4319C4741F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 664A220739
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 09:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgI3J0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:26:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:57886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgI3J0l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 05:26:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CEB5BAD1B;
        Wed, 30 Sep 2020 09:26:39 +0000 (UTC)
Subject: Re: [PATCH v2 5/8] scsi: Added routine to set/clear
 SCMD_NORETRIES_ABORT bit for outstanding io on scsi_dev
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <1601268657-940-6-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9a146c88-a903-b545-34b6-04ec713d1e4a@suse.de>
Date:   Wed, 30 Sep 2020 11:26:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601268657-940-6-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 6:50 AM, Muneendra wrote:
> Added a new routine scsi_chg_noretries_abort_io_device().
> This functions accepts two arguments Scsi_device and an integer(set).
> 
> When set is passed as 1
> this routine will set SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
> 
> When set is passed as 0
> This routine  will clear SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
> 
> Export the symbol so the routine can be called by scsi_transport_fc.c
> 
> Added new function declaration scsi_chg_noretries_abort_io_device in
> scsi_priv.h
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v2:
> Renamed the below functions as
> scsi_set_noretries_abort_io_device ->scsi_chg_noretries_abort_io_device
> __scsi_set_noretries_abort_io_device->__scsi_set_noretries_abort_io_device
> which accepts the value as an arg to set/clear the SCMD_NORETRIES_ABORT bit
> ---
>   drivers/scsi/scsi_error.c | 76 +++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/scsi_priv.h  |  2 ++
>   2 files changed, 78 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 3f14ea10d5da..c0943f08b469 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -271,6 +271,82 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
>   	call_rcu(&scmd->rcu, scsi_eh_inc_host_failed);
>   }
>   
> +static bool
> +scsi_clear_noretries_abort_io(struct request *rq, void *priv, bool reserved)
> +{
> +	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
> +	struct scsi_device *sdev = scmd->device;
> +
> +	/* only clear SCMD_NORETRIES_ABORT on ios on a specific sdev */
> +	if (sdev != priv)
> +		return true;
> +
> +	/*Clear the SCMD_NORETRIES_ABORT bit*/
> +	if (READ_ONCE(rq->state) == MQ_RQ_IN_FLIGHT)
> +		clear_bit(SCMD_NORETRIES_ABORT, &scmd->state);
> +	return true;
> +}
> +
> +static bool
> +scsi_set_noretries_abort_io(struct request *rq, void *priv, bool reserved)
> +{
> +	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
> +	struct scsi_device *sdev = scmd->device;
> +
> +	/* only set SCMD_NORETRIES_ABORT on ios on a specific sdev */
> +	if (sdev != priv)
> +		return true;
> +	/* we don't want this command reissued on abort success
> +	 * so set SCMD_NORETRIES_ABORT bit to ensure it
> +	 * won't get reissued
> +	 */
> +	if (READ_ONCE(rq->state) == MQ_RQ_IN_FLIGHT)
> +		set_bit(SCMD_NORETRIES_ABORT, &scmd->state);
> +	return true;
> +}
> +

Do we really care about the 'in flight' parameter?
Why not set it on every command?

And meanwhile we do have scsi command iterators (scsi_host_busy_iter);
maybe one should be using them here.

> +static int
> +__scsi_chg_noretries_abort_io_device(struct scsi_device *sdev, int set)
> +{
> +
> +	if (sdev->sdev_state != SDEV_RUNNING)
> +		return -EINVAL;
> +
> +	if (blk_queue_init_done(sdev->request_queue)) {
> +
> +		blk_mq_quiesce_queue(sdev->request_queue);
> +
> +		if (set)
> +			blk_mq_tagset_busy_iter(&sdev->host->tag_set,
> +					scsi_set_noretries_abort_io, sdev);
> +		else
> +			blk_mq_tagset_busy_iter(&sdev->host->tag_set,
> +				scsi_clear_noretries_abort_io, sdev);
> +
> +		blk_mq_unquiesce_queue(sdev->request_queue);
> +	}
> +	return 0;
> +}

'set' is a boolean, so why not use the 'boolean' type here?
And I'm not sure if we need to check for 'blk_queue_init_done()'; surely 
that's always the case for SDEV_RUNNING?

> +
> +/*
> + * scsi_chg_noretries_abort_io_device - set/clear the SCMD_NORETRIES_ABORT
> + * bit for all the pending io's on a device
> + * @sdev:	scsi_device
> + * @set: indicates to clear (0) or set (1) the SCMD_NORETRIES_ABORT flag
> + */
> +int
> +scsi_chg_noretries_abort_io_device(struct scsi_device *sdev, int set)
> +{
> +	struct Scsi_Host *shost = sdev->host;
> +	int ret  = -EINVAL;
> +
> +	mutex_lock(&shost->scan_mutex);
> +	ret = __scsi_chg_noretries_abort_io_device(sdev, set);
> +	mutex_unlock(&shost->scan_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL(scsi_chg_noretries_abort_io_device);
> +
>   /**
>    * scsi_times_out - Timeout function for normal scsi commands.
>    * @req:	request that is timing out.
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index d12ada035961..aba98a3294ce 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -81,6 +81,8 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
>   int scsi_eh_get_sense(struct list_head *work_q,
>   		      struct list_head *done_q);
>   int scsi_noretry_cmd(struct scsi_cmnd *scmd);
> +extern int scsi_chg_noretries_abort_io_device(struct scsi_device *sdev,
> +			int set);
>   
>   /* scsi_lib.c */
>   extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
