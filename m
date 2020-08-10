Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E77C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 385F6206B5
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 06:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgHJGUF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 02:20:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:38578 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgHJGUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Aug 2020 02:20:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AE427B1B1;
        Mon, 10 Aug 2020 06:20:22 +0000 (UTC)
Subject: Re: [PATCH 4/5] scsi: Added routine to set SCMD_NORETRIES_ABORT bit
 for outstanding io on scsi_dev
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1596595862-11075-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596595862-11075-5-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <419ea703-f404-e665-add8-0e6bf7382363@suse.de>
Date:   Mon, 10 Aug 2020 08:20:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596595862-11075-5-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/20 4:51 AM, Muneendra wrote:
> Added a new routine scsi_set_noretries_abort_io_device()to set
> SCMD_NORETRIES_ABORT for all the inflight/pending IO's on a particular
> scsi device at that particular instant.
> 
> Export the symbol so the routine can be called by scsi_transport_fc.c
> 
> Added new function declaration scsi_set_noretries_abort_io_device in
> scsi_priv.h
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> ---
>   drivers/scsi/scsi_error.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/scsi_priv.h  |  1 +
>   2 files changed, 54 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 3222496..938d770 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -271,6 +271,59 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
>   	call_rcu(&scmd->rcu, scsi_eh_inc_host_failed);
>   }
>   
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
> +static int
> +__scsi_set_noretries_abort_io_device(struct scsi_device *sdev)
> +{
> +
> +	if (sdev->sdev_state != SDEV_RUNNING)
> +		return -EINVAL;
> +
> +	if (blk_queue_init_done(sdev->request_queue)) {
> +
> +		blk_mq_quiesce_queue(sdev->request_queue);
> +		blk_mq_tagset_busy_iter(&sdev->host->tag_set,
> +				scsi_set_noretries_abort_io, sdev);
> +		blk_mq_unquiesce_queue(sdev->request_queue);
> +	}
> +	return 0;
> +}
> +
> +/*
> + * scsi_set_noretries_abort_io_device - set the SCMD_NORETRIES_ABORT
> + * bit for all the pending io's on a device
> + * @sdev:	scsi_device
> + */
> +int
> +scsi_set_noretries_abort_io_device(struct scsi_device *sdev)
> +{
> +	struct Scsi_Host *shost = sdev->host;
> +	int ret  = -EINVAL;
> +
> +	mutex_lock(&shost->scan_mutex);
> +	ret = __scsi_set_noretries_abort_io_device(sdev);
> +	mutex_unlock(&shost->scan_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL(scsi_set_noretries_abort_io_device);
> +
>   /**
>    * scsi_times_out - Timeout function for normal scsi commands.
>    * @req:	request that is timing out.
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index d12ada0..1bbffd3 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -81,6 +81,7 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
>   int scsi_eh_get_sense(struct list_head *work_q,
>   		      struct list_head *done_q);
>   int scsi_noretry_cmd(struct scsi_cmnd *scmd);
> +extern int scsi_set_noretries_abort_io_device(struct scsi_device *sdev);
>   
>   /* scsi_lib.c */
>   extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
