Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F423C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Dec 2021 21:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244151AbhLJVn4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Dec 2021 16:43:56 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:34673 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbhLJVnz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Dec 2021 16:43:55 -0500
Received: by mail-pf1-f172.google.com with SMTP id r130so9630947pfc.1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Dec 2021 13:40:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YxCHG+ODsGfwlOgDz1jMHmJloiORdYbCyWnI2OT+WE8=;
        b=DABMPJM/Me0bq64+Le/0zt6vX+FWL/391phQq2rlmGaDpVruuVN2tBapu5vU6bxRZP
         95qqVHW5/9uTh1kR+lhBym+sRFF6gKpXyiRhAec1UgvzspmuyD2mVSprohd3gAivYGRn
         diqz8t4fyADN37p42DQ4SNLhLwlKB3heiVa93am57PjL+B6SmcBVTbEQJ2kz/fPwnnlz
         EXjb+JvvyC0Kt1dFy1nRInySVvl61sKQPS2GRFNY0OE34wmYPnUPb2xV+IqQ9pig5Olk
         e5UCvcwFp+umsqq8Q0RBSINnB6C3I82DTYvWwQAbcQhjQtf6X0L2W9ksFyKtq0FprxMt
         5BlQ==
X-Gm-Message-State: AOAM53126wHc0XeP1VFpHvblST73OdfC6Nd2p+50FIC8Tjja0BtuRp3X
        5mQ3337vnnsQ2dnxhi/DYBCUmdVHcjs=
X-Google-Smtp-Source: ABdhPJzJKpujKGeb0WY8vDAxYGGZR051lJ1LTkDQYGTvzbvWIIbzH2NVbLqibhYWHN5w1m06cSttXQ==
X-Received: by 2002:a05:6a00:23c4:b0:49f:e054:84cb with SMTP id g4-20020a056a0023c400b0049fe05484cbmr20365746pfc.63.1639172419702;
        Fri, 10 Dec 2021 13:40:19 -0800 (PST)
Received: from ?IPv6:2620:0:1000:2514:85ed:ea0b:339:7b11? ([2620:0:1000:2514:85ed:ea0b:339:7b11])
        by smtp.gmail.com with ESMTPSA id x1sm3297595pgh.1.2021.12.10.13.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 13:40:19 -0800 (PST)
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
To:     Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, yujiang@ramaxel.com
References: <20211126073310.87683-1-songyl@ramaxel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6207ff07-b64b-a147-ed49-f194c81bb9ac@acm.org>
Date:   Fri, 10 Dec 2021 13:40:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211126073310.87683-1-songyl@ramaxel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/21 11:33 PM, Yanling Song wrote:
> +/* bsg dispatch user command */
> +static int spraid_bsg_host_dispatch(struct bsg_job *job)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(job->dev);
> +	struct spraid_dev *hdev = shost_priv(shost);
> +	struct request *rq = blk_mq_rq_from_pdu(job);
> +	struct spraid_bsg_request *bsg_req = (struct spraid_bsg_request *)(job->request);

Since job->request has type 'void *', no cast is necessary when assigning job->request to
bsg_req. Hence please leave out the cast.

Thanks,

Bart.
