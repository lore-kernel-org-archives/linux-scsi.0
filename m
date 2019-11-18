Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9249C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 22:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8500F2230C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 22:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKRW5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 17:57:51 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36063 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfKRW5v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 17:57:51 -0500
Received: by mail-pg1-f194.google.com with SMTP id k13so10346494pgh.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 14:57:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aD/ZQL1h+7iYmC5iLRCh2bUIA+Etm7C+iPG/0dPXaXU=;
        b=cLP+5dAVyZDkQvDr1nM9qJ+vA7RUn+vrbZzeS1HZOOqrWifI585vMgTSoXhaZhDUXR
         xcq7to4ThRLLMbdKbeqI6seCa7Wul212/OFV6mX6zshxhj5Qf91MS/UC4+bkQlhpLNlO
         eiwCLHhItF1b7YqmXPQ96VGapfh9F+UHYrsqzF5aKs/ruqVq1QNS/3KAsGSEBBRdSSRP
         7tgfuACpGZUkF5WdnlHDP8qnJ0/4mSIaPeyYEXthGTyJop0+KyA1O8wK/kpfLObobZIv
         hmWAYSsd3sHUS3+GSiy7wSafQDFR1Ueb1eHbVwTLCQIZ5Pcb1Z3P+E2cg/M++VMD/Yk/
         S4Bg==
X-Gm-Message-State: APjAAAWzFMzsE9e2jlN3WxFLLf2oM6DmnEs+3mIcLZjuM1W/Tv9Zbksd
        h68RSxxIkxpRDNlbkamv0+K66FPK
X-Google-Smtp-Source: APXvYqwR+8bScLi8/AkDezHM+PSurPoQdwSuTyK5RGV8rg14TvSeNNs/Fc9BiMWJ/bXLoL8MjPHXJw==
X-Received: by 2002:a62:7a85:: with SMTP id v127mr1966306pfc.141.1574117869933;
        Mon, 18 Nov 2019 14:57:49 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id i71sm21787043pfe.103.2019.11.18.14.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 14:57:48 -0800 (PST)
Subject: Re: [PATCH 2/9] scsi: add scsi_host_flush_commands() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191118092208.54521-1-hare@suse.de>
 <20191118092208.54521-3-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ca868669-6939-ca53-43bc-8f45ea382d3d@acm.org>
Date:   Mon, 18 Nov 2019 14:57:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191118092208.54521-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 1:22 AM, Hannes Reinecke wrote:
> +/**
> + * scsi_host_flush_commands -- Terminate all running commands
> + * @shost:	Scsi Host on which commands should be terminated
> + * @status:	Status to be set for the terminated commands
> + */
> +static bool flush_cmds_iter(struct request *rq, void *data, bool reserved)
> +{
> +	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
> +	int status = *(int *)data;
> +
> +	if (reserved)
> +		return true;
> +	scmd->result = status << 16;
> +	scmd->scsi_done(scmd);
> +	return true;
> +}
> +
> +void scsi_host_flush_commands(struct Scsi_Host *shost, int status)
> +{
> +	blk_mq_tagset_busy_iter(&shost->tag_set, flush_cmds_iter, &status);
> +}

Should the kernel-doc comment be moved from the static function to the 
exported function? Please also add a comment that it is only safe to 
call scsi_host_flush_commands() from inside a LLD reset handler.

Thanks,

Bart.
