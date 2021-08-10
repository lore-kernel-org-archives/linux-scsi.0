Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B53C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4F1961075
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 06:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbhHJGYT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 02:24:19 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51660 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbhHJGYT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 02:24:19 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D793C2006A;
        Tue, 10 Aug 2021 06:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628576635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gp7vu1PKU5AruJJIlWmdwPIxRNwvKzZ9K8z4yiautGY=;
        b=zsRiKwUcY9WtVPnU8dJv165wy3sqPmdopqnFeWpSlyACTNF+wtHM+hH+It5sQ6rgp38Wp1
        6qvXf4R4VGRz1xSp6n8JFQF8R57tTeV78SLykebimSyiba2DCZZLwyBtUwl++PhEpGZ6wS
        qsQc/aIEjLpa4+BpU2pVK1QAz9oJmS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628576635;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gp7vu1PKU5AruJJIlWmdwPIxRNwvKzZ9K8z4yiautGY=;
        b=tX677Acxg48p5QMAQHd+8zwIGJuGXfdgNm/QqBfc22TpxeZet8CCfs3DvowtHmI9N3CDkt
        6e0pgaCSdInDmsBA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id C338D133D0;
        Tue, 10 Aug 2021 06:23:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id Fd0bL3sbEmHMOwAAGKfGzw
        (envelope-from <hare@suse.de>); Tue, 10 Aug 2021 06:23:55 +0000
Subject: Re: [PATCH v5 13/52] aacraid: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210809230355.8186-1-bvanassche@acm.org>
 <20210809230355.8186-14-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <78fc3a8f-bdb5-dc48-c4db-6b952787356d@suse.de>
Date:   Tue, 10 Aug 2021 08:23:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809230355.8186-14-bvanassche@acm.org>
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
>   drivers/scsi/aacraid/aachba.c  | 2 +-
>   drivers/scsi/aacraid/commsup.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 267934d2f14b..c2d6f0a9e0b1 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -1504,7 +1504,7 @@ static struct aac_srb * aac_scsi_common(struct fib * fib, struct scsi_cmnd * cmd
>   	srbcmd->id       = cpu_to_le32(scmd_id(cmd));
>   	srbcmd->lun      = cpu_to_le32(cmd->device->lun);
>   	srbcmd->flags    = cpu_to_le32(flag);
> -	timeout = cmd->request->timeout/HZ;
> +	timeout = scsi_cmd_to_rq(cmd)->timeout / HZ;
>   	if (timeout == 0)
>   		timeout = (dev->sa_firmware ? AAC_SA_TIMEOUT : AAC_ARC_TIMEOUT);
>   	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index 54eb4d41bc2c..deb32c9f4b3e 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -224,7 +224,7 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
>   {
>   	struct fib *fibptr;
>   
> -	fibptr = &dev->fibs[scmd->request->tag];
> +	fibptr = &dev->fibs[scsi_cmd_to_rq(scmd)->tag];
>   	/*
>   	 *	Null out fields that depend on being zero at the start of
>   	 *	each I/O
> 

The 'scsi_cmd_to_rq(scmd)->tag' pattern is becoming more and more 
visible; maybe one should introduce a helper for it?

Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
