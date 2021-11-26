Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD2DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 23:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245651AbhKZXRm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 18:17:42 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:38509 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343698AbhKZXPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 18:15:41 -0500
Received: by mail-pj1-f49.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so10746462pju.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 15:12:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jmHhhCP/q/9dJ6xVJ9IVQrFm3qn5FImx5N0OIfo/NDw=;
        b=CL6BKp2X5vVA7XFWzcQrw2ijdqEagchy6DISawBDWo7qAYMvlrU285EX3bzYSHpCqu
         iwGUh0CCMENM/4k4LBvQnkLZOHq1s/DAlQvlVbm/9MBOp0GnXAeHqZhsOH64tlqbeWnY
         unLhrDTyYRkp4cUSS8DGUFAQhKoNrcy/5bVi/b+RPA9onhRt2LNjiTwLQwmJomV4QNos
         AUMZCiqQJtJ1nQgRGOAyL7tNR9Jgl3rzk6rA89/GQg5lRwG+R0MW9DmysGnCL2VqlOWR
         bvNc4pid6+zSSYaDIZi+WgFz56X+ie+jeHnosK1IMsVyIGrBWBk1NFBWCyw9WKNFyaP1
         NIfA==
X-Gm-Message-State: AOAM531//i9ZtvuzKdgSrg2TbSrkPS95tzxq61AomPFGRvuEJuESLtQR
        /ebqfolYZebilu19DjyfEpV3WPSIlvQ=
X-Google-Smtp-Source: ABdhPJzwPw6b7TpyeyPStS5WsLMvTEs5084FNkbeh/wpSccVGH/lTGgiq4OKvBjbLidZiCZPbBC3LA==
X-Received: by 2002:a17:90a:c08a:: with SMTP id o10mr18911613pjs.44.1637968347494;
        Fri, 26 Nov 2021 15:12:27 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id p188sm7782498pfg.102.2021.11.26.15.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 15:12:26 -0800 (PST)
Message-ID: <1eb99f16-5b65-3150-48c6-353b088818ad@acm.org>
Date:   Fri, 26 Nov 2021 15:12:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211125151048.103910-3-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/21 07:10, Hannes Reinecke wrote:
> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
> +	int data_direction, bool nowait)

Please use enum dma_data_direction instead of 'int' for the data direction.
> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +	blk_mq_req_flags_t flags = 0;
> +	int op;

The name 'op' is confusing since that variable is a bitfield that 
includes the operation and operation flags. Consider one of the names 
'opf', 'op_and_flags' or 'cmd_and_flags'. Please also change the data 
type from 'int' into 'unsigned int' or 'u32'.

> +	op = (data_direction == DMA_TO_DEVICE) ?
> +		REQ_OP_DRV_OUT : REQ_OP_DRV_IN;

Please leave out the parentheses from the above assignment.

Thanks,

Bart.
