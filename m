Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BD6C4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 06:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A65AB60241
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 06:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhEaGdm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 02:33:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47720 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhEaGdl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 02:33:41 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 53EF31FD2E;
        Mon, 31 May 2021 06:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622442721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ckSIUtCAW5WdVQvQRy9M3j5jWlh0K4Uzkr1LlkRSLl0=;
        b=H+BXZHf7NirGnh3Qjx2JS1Zum0NWDkYXBbjb0goUgf7wjRTCCGflyV5569WyERSWFmanBb
        VcnOLTIsMubX7G+ZeTdo2MIuh0DqaGjqfb9rvzy7osBJ1O0VZMqiNZ/jJDaoEfH5SuCPB8
        PyJGLCxMwPzQS54VvXKH27nDqKmiZfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622442721;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ckSIUtCAW5WdVQvQRy9M3j5jWlh0K4Uzkr1LlkRSLl0=;
        b=OEKN3ld6pfrlGb5ESigRedTc8zYS9GYIiHrZboWvchzm+X57LFrCuOBGDbPwxk4NyMFvI/
        +9Xy+oeTQNrnJYBA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 11EB6118DD;
        Mon, 31 May 2021 06:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622442721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ckSIUtCAW5WdVQvQRy9M3j5jWlh0K4Uzkr1LlkRSLl0=;
        b=H+BXZHf7NirGnh3Qjx2JS1Zum0NWDkYXBbjb0goUgf7wjRTCCGflyV5569WyERSWFmanBb
        VcnOLTIsMubX7G+ZeTdo2MIuh0DqaGjqfb9rvzy7osBJ1O0VZMqiNZ/jJDaoEfH5SuCPB8
        PyJGLCxMwPzQS54VvXKH27nDqKmiZfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622442721;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ckSIUtCAW5WdVQvQRy9M3j5jWlh0K4Uzkr1LlkRSLl0=;
        b=OEKN3ld6pfrlGb5ESigRedTc8zYS9GYIiHrZboWvchzm+X57LFrCuOBGDbPwxk4NyMFvI/
        +9Xy+oeTQNrnJYBA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id StoJA+GCtGAcfQAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 31 May 2021 06:32:01 +0000
Subject: Re: [PATCH V3 2/3] scsi: core: fix failure handling of
 scsi_add_host_with_dma
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
 <20210531050727.2353973-3-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bb3479ee-b7ca-bfdf-92a7-b2cef90bbf59@suse.de>
Date:   Mon, 31 May 2021 08:31:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210531050727.2353973-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Authentication-Results: imap.suse.de;
        none
X-Spamd-Result: default: False [0.00 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         RCPT_COUNT_FIVE(0.00)[5];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/21 7:07 AM, Ming Lei wrote:
> When scsi_add_host_with_dma() return failure, the caller will call
> scsi_host_put(shost) to release everything allocated for this host
> instance. So we can't free allocated stuff in scsi_add_host_with_dma(),
> otherwise double free will be caused.
> 
> Strictly speaking, these host resources allocation should have been
> moved to scsi_host_alloc(), but the allocation may need driver's
> info which can be built between calling scsi_host_alloc() and
> scsi_add_host(), so just keep the allocations in
> scsi_add_host_with_dma().
> 
> Fixes the problem by relying on host device's release handler to
> release everything.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/hosts.c | 14 ++++++--------
>   1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index ada11e3ae577..6cbc3eb16525 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -279,23 +279,22 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   
>   		if (!shost->work_q) {
>   			error = -EINVAL;
> -			goto out_free_shost_data;
> +			goto out_del_dev;
>   		}
>   	}
>   
>   	error = scsi_sysfs_add_host(shost);
>   	if (error)
> -		goto out_destroy_host;
> +		goto out_del_dev;
>   
>   	scsi_proc_host_add(shost);
>   	scsi_autopm_put_host(shost);
>   	return error;
>   
> - out_destroy_host:
> -	if (shost->work_q)
> -		destroy_workqueue(shost->work_q);
> - out_free_shost_data:
> -	kfree(shost->shost_data);
> +	/*
> +	 * any host allocation in this function will be freed in
> +	 * scsi_host_dev_release, so don't free them in the failure path
> +	 */
>    out_del_dev:
>   	device_del(&shost->shost_dev);
>    out_del_gendev:
> @@ -305,7 +304,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	pm_runtime_disable(&shost->shost_gendev);
>   	pm_runtime_set_suspended(&shost->shost_gendev);
>   	pm_runtime_put_noidle(&shost->shost_gendev);
> -	scsi_mq_destroy_tags(shost);
>    fail:
>   	return error;
>   }
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
