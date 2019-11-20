Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09912C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 16:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7DF20731
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 16:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbfKTQT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:19:27 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42920 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbfKTQT1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 11:19:27 -0500
Received: by mail-pf1-f196.google.com with SMTP id s5so14449183pfh.9
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2019 08:19:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uM8C8JcHEDku/B9X122TAsRvE3LLQ+KLNCtPnrP9j2s=;
        b=foZ4w7TbEde8Mh5HdWr25oQja8UE4c4d/jraV3uwz91WK9thEJHFPPcoWiCLhf9Hfk
         o0b/+JsKAi+anr+5UZ3QhA/ko89tHnrYg/n1F1Pu53tNe/+fZ9EZvwXfV2OmCt/JHugX
         OKUuFPZ7ajO5y5fOY5G4xg9tWaouhYM39LSQB9jnRC6gcdPhv9qS+i98HMN/NaLrI0rr
         /G40zo8ALq0VbzNwZusKkiMazL1f3OsG3rA2xk4+/YNW2BzuL2Q69eNQ1v+3zIOISgeZ
         CNCe844GLDMTvYMkcj5Jr139++KeWsqN1dUVgiFNxpTXXBH9lC0snWfg4vBU4aVf/kqJ
         XXnw==
X-Gm-Message-State: APjAAAWSw3hcsy55GOBb57iyVmbEYyy5vmiHJ6qdtcZc64AQe4PMVL4I
        zE/ddVKNl9pRWFIjqSajS/6hoFCLlb4=
X-Google-Smtp-Source: APXvYqx1F1rLOPpoVRssW4qh8Sm3a4GVr9LSv37J3nz76xDmoy9mE47u2saeQL2JX9kqkjPNZJNYRg==
X-Received: by 2002:aa7:8b47:: with SMTP id i7mr5114929pfd.226.1574266766197;
        Wed, 20 Nov 2019 08:19:26 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id g7sm28983519pgr.52.2019.11.20.08.19.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 08:19:25 -0800 (PST)
Subject: Re: [PATCH 02/11] scsi: add scsi_host_flush_commands() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191120103114.24723-1-hare@suse.de>
 <20191120103114.24723-3-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <841676ff-3d41-1dd4-a220-6b2ee84d7320@acm.org>
Date:   Wed, 20 Nov 2019 08:19:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120103114.24723-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/20/19 2:31 AM, Hannes Reinecke wrote:
> +static bool flush_cmds_iter(struct request *rq, void *data, bool reserved)
> +{
> +	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
> +	int status = *(int *)data;
> +
> +	if (reserved)
> +		return true;

Since the SCSI core does not support reserving tags, this early return 
is dead code. Additionally, I'm not sure this early return would be 
correct if reserved tag support would be added to the SCSI core. How 
about leaving out this early return?

> +	scsi_dma_unmap(scmd);
> +	scmd->result = status << 16;
> +	scmd->scsi_done(scmd);
> +	return true;
> +}
> +
> +/**
> + * scsi_host_flush_commands -- Terminate all running commands
                                ^^
Should this have been a single hyphen?

Thanks,

Bart.
