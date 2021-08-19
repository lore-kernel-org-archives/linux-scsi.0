Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136D3C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 10:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B5961152
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 10:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238230AbhHSKjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 06:39:16 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45662 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237863AbhHSKjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 06:39:15 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CF4EA1FD85;
        Thu, 19 Aug 2021 10:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629369518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQ314Q+QCL12ETPydoLFWdP+05FNyqvEHiwnzBEk8Vw=;
        b=J1e8XzvNxKOaapM/HajZ5PLkxkYPYFiCPb5mWlTmLUHQj5pdCtcZ8Xfj63xqb3Kob6KlSc
        WUPDQCL4aO63iY8ltB/0GdRLC42ent99pix8IpDO21VtmBd9ZNZt+kKkUY8bgK6ggnWdPl
        RjYYKzRiZG1zsr5tUmimRKaUrd1oDww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629369518;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQ314Q+QCL12ETPydoLFWdP+05FNyqvEHiwnzBEk8Vw=;
        b=6rlv+ijVWkV8pTKURhN8KJkgK+i3Fwxc86cR1s6tg6oiGhuamTUPyw7vqXmoTTxXuRVUoI
        WNnOfKkpRvnU8JAA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id C4623139BA;
        Thu, 19 Aug 2021 10:38:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id RyOHLqw0HmGgQgAAGKfGzw
        (envelope-from <hare@suse.de>); Thu, 19 Aug 2021 10:38:36 +0000
Subject: Re: [PATCH v2 1/2] scsi: qla1280: Stop using scsi_cmnd.tag
To:     John Garry <john.garry@huawei.com>, mdr@sgi.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
References: <1629365549-190391-1-git-send-email-john.garry@huawei.com>
 <1629365549-190391-2-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c94d7311-f127-d8c0-6f4d-ba1b14f7e0bf@suse.de>
Date:   Thu, 19 Aug 2021 12:38:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1629365549-190391-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/19/21 11:32 AM, John Garry wrote:
> Use scsi_cmd_to_rq(cmd)->tag instead of scsi_cmnd.tag as preference.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/qla1280.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index aec92471c5f2..b4f7d8d7a01c 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -3980,7 +3980,7 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
>   	   qla1280_dump_buffer(1, (char *)sg, (cmd->use_sg*sizeof(struct scatterlist)));
>   	   } */
>   	printk("  tag=%d, transfersize=0x%x \n",
> -	       cmd->tag, cmd->transfersize);
> +	       scsi_cmd_to_rq(cmd)->tag, cmd->transfersize);
>   	printk("  SP=0x%p\n", CMD_SP(cmd));
>   	printk(" underflow size = 0x%x, direction=0x%x\n",
>   	       cmd->underflow, cmd->sc_data_direction);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
