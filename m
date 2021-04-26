Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC682C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A083061249
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhDZDC4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:02:56 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:41951 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhDZDCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:02:55 -0400
Received: by mail-pj1-f44.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso4436659pjn.0;
        Sun, 25 Apr 2021 20:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=44tYBXpMJOj6uug4aHLosXVD7Ko43yBzkFNYGvgBtf4=;
        b=IdJraiW55fnR9U7joBUCLTuQHtt0s0koopvCpYfH2LvDB5rJ/UL2Ko2kvXButSmmB4
         l1UscOUFvBsyIQbuV31GrQCyAyqXskTgPtFZIHSY76/ny+LzaOegNGPVnIVbPR0x04HW
         DuG5NmZfmvrozDYv5zQgi5IF3s4sfGRIQMhWr4sWzAwxZ4QTaqTwfZxjGocRB9tLJHvi
         jR9mPoJKZyeszB8cf8B+9Gg/3PJ72+NzU4I+K2pSNlKI6H3gfajNOVI8ScF8/jEq60fp
         Pg7au3wlTvoIVntl5M1sRxJOB8VNHWxMs8KbVZi7pvfOm8vB+Hry0fJjrWKMVK+bOafv
         VbUQ==
X-Gm-Message-State: AOAM5308m2nz5bGqgUOzAakquMrf4wrXm+Z/+8XlJ0TKEDh+ZLPKwz/7
        D2I5YQy7o2udQ3j/nn00d6A=
X-Google-Smtp-Source: ABdhPJz+ysOlfkJtBfcRv+ndSFeTd+BoaeSmicszK2REp+u2UKtyTPccALK1rRxd/tcfmvishyQBnA==
X-Received: by 2002:a17:902:59cd:b029:e9:a757:fa3f with SMTP id d13-20020a17090259cdb02900e9a757fa3fmr15871007plj.46.1619406133400;
        Sun, 25 Apr 2021 20:02:13 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id a6sm10117111pfh.135.2021.04.25.20.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:02:12 -0700 (PDT)
Subject: Re: [PATCH 6/8] block: drivers: complete request locally from
 blk_mq_tagset_busy_iter
To:     Ming Lei <ming.lei@redhat.com>, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <20210425085753.2617424-7-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <bcdfc3a0-f5fa-dc06-8067-4349a133e531@acm.org>
Date:   Sun, 25 Apr 2021 20:02:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210425085753.2617424-7-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/25/21 1:57 AM, Ming Lei wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c289991ffaed..7cbaee282b6d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1568,7 +1568,11 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
>  	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
>  		return;
>  	trace_scsi_dispatch_cmd_done(cmd);
> -	blk_mq_complete_request(cmd->request);
> +
> +	if (unlikely(host_byte(cmd->result) != DID_OK))
> +		blk_mq_complete_request_locally(cmd->request);
> +	else
> +		blk_mq_complete_request(cmd->request);
>  }

This change is so tricky that it deserves a comment.

An even better approach would be *not* to export
blk_mq_complete_request_locally() from the block layer to block drivers
and instead modify the block layer such that it completes a request on
the same CPU if request completion happens from inside the context of a
tag iteration function. That would save driver writers the trouble of
learning yet another block layer API.

Bart.
