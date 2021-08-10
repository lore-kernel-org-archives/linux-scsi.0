Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7E5C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A14676105A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237880AbhHJG1C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 02:27:02 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48688 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237808AbhHJG05 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 02:26:57 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2AFF821FCA;
        Tue, 10 Aug 2021 06:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628576795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lUkSJZrP5NJwmzIbIMTNJUSf7p4yGOpHvUU7pzJCyTU=;
        b=esLII4jf1KEcLOih29KXck1OGCFTpf2lw/FidjBXVtyhE/ZcqEXQ+sc6f4FX73ZZqvlFud
        8NJHQFQgOqcQHw1vahw3A8J/gtdiBefHMWAS1UETHQt5nebufx/IVx8xC30vMEjsqxufx2
        LFwbGYqkqstyZHQDa/v4fhndNEGmzZI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628576795;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lUkSJZrP5NJwmzIbIMTNJUSf7p4yGOpHvUU7pzJCyTU=;
        b=rsfDGsUgvWMZPXnWzmP2OCJrN7m5lSLlfdgp8WT4XD+LXwfPty2YnVUZPcaysjgE1IRt+E
        vHggji39avhxviDQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id F3685133D0;
        Tue, 10 Aug 2021 06:26:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 2fD8ORocEmFJPAAAGKfGzw
        (envelope-from <hare@suse.de>); Tue, 10 Aug 2021 06:26:34 +0000
Subject: Re: [PATCH v5 17/52] csiostor: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-18-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <90f50664-db6e-c17d-4b2c-4dfdbb52b6af@suse.de>
Date:   Tue, 10 Aug 2021 08:26:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809230355.8186-18-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/21 1:03 AM, Bart Van Assche wrote:
> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
> instead. This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/csiostor/csio_scsi.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
> index 56b9ad0a1ca0..3b2eb6ce1fcf 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -1786,7 +1786,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
>   	struct csio_scsi_qset *sqset;
>   	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
>   
> -	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(cmnd->request)];
> +	sqset = &hw->sqset[ln->portid][blk_mq_rq_cpu(scsi_cmd_to_rq(cmnd))];
>   
>   	nr = fc_remote_port_chkready(rport);
>   	if (nr) {
> @@ -1989,13 +1989,13 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
>   		csio_info(hw,
>   			"Aborted SCSI command to (%d:%llu) tag %u\n",
>   			cmnd->device->id, cmnd->device->lun,
> -			cmnd->request->tag);
> +			scsi_cmd_to_rq(cmnd)->tag);
>   		return SUCCESS;
>   	} else {
>   		csio_info(hw,
>   			"Failed to abort SCSI command, (%d:%llu) tag %u\n",
>   			cmnd->device->id, cmnd->device->lun,
> -			cmnd->request->tag);
> +			scsi_cmd_to_rq(cmnd)->tag);
>   		return FAILED;
>   	}
>   }
> 
The 'tag' thing again ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
