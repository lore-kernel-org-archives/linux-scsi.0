Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D7AC07E95
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Jul 2021 08:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F46F613D2
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Jul 2021 08:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhGJIU0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Jul 2021 04:20:26 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56434 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbhGJIU0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jul 2021 04:20:26 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7CD73221DA;
        Sat, 10 Jul 2021 08:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625905060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XlCJsVkeheOEKSyl+Piw4umEyiBxk5Vn0AEGvCPIyps=;
        b=mJCCcLw7AfAY+2JCBkivhh0QEehheIdPTd9Q26fS8ZAkLGy4xnlH3eLFmX6nJTf5ROqBqr
        nQ48O8WD3JSe2YkkhZTDw1pL1bt+Hr6/0z9ybCBlqvnxzoH9YrOHkvKXdhr0nvIAgs6Qxq
        L62WclkV2zA/JxDYRMUEC1qc8SBQt9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625905060;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XlCJsVkeheOEKSyl+Piw4umEyiBxk5Vn0AEGvCPIyps=;
        b=984auJNWZjCf/giCK6BOh5FpYUPmJ1nOJpzkBxIjVYx76HIObOLd0PHK3RYVOnM3FmDVC3
        26tSsNtXUVycCjDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 490491340F;
        Sat, 10 Jul 2021 08:17:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id FZI4EKRX6WC0bAAAGKfGzw
        (envelope-from <hare@suse.de>); Sat, 10 Jul 2021 08:17:40 +0000
Subject: Re: [PATCH v2 01/19] scsi: Fix the documentation of the
 scsi_execute() time parameter
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-3-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <98927496-419c-3676-ec13-23e4b593cb9e@suse.de>
Date:   Sat, 10 Jul 2021 10:17:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709202638.9480-3-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/9/21 10:26 PM, Bart Van Assche wrote:
> The unit of the scsi_execute() timeout parameter is 1/HZ seconds instead of
> one second, just like the timeouts used in the block layer. Fix the
> documentation header above the definition of the scsi_execute() macro.
> 
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.garry@huawei.com>
> Fixes: "[SCSI] use scatter lists for all block pc requests and simplify hw handlers" # v2.6.16.28
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_lib.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7184f93dfe15..4b56e06faa5e 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -194,7 +194,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
>    * @bufflen:	len of buffer
>    * @sense:	optional sense buffer
>    * @sshdr:	optional decoded sense header
> - * @timeout:	request timeout in seconds
> + * @timeout:	request timeout in HZ
>    * @retries:	number of times to retry request
>    * @flags:	flags for ->cmd_flags
>    * @rq_flags:	flags for ->rq_flags
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
