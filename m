Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0851C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 18:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343828AbiFNSAo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 14:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237431AbiFNSAn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 14:00:43 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98C52A24F;
        Tue, 14 Jun 2022 11:00:42 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id 187so9224788pfu.9;
        Tue, 14 Jun 2022 11:00:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9WKPI79Gjph2WfiqwNvS+zcjQJjDViwq87Qamyz2DXk=;
        b=KjsuvBWDonPyN7jrDJropfLzF+q9XTDK0sSiecl+hB+u3ceBBdwd1+GdAC2wrpJ1ZK
         yPVNBmXmUIupt1cEALtKMrkbnm7ahdKUpZB4v317OduDBMU/dlCVcsYmU6sKeRh6unBW
         I4Uo2bdtVehxxrtu62i+fycf0g6YybPHqcVO8Ur4sG7WQiepbAsC9LT3VY1hCrtyfEM9
         4wRMfB+Qp4Ik/dIANzPTc8RHk9E5qbZxj8NEeW6SqS1W5u9WeoYo+feDPmStTOri2BVg
         /NDa9vlOoMyZ7+u0uknqI3A/GYiwOklRYLheEwIbk82hJ5xse+J0zjOgtNki2WC9ONvZ
         ieZA==
X-Gm-Message-State: AOAM532gpzlvC4oBVhcQzrnWuW9cioHjLGTQlxDlVIKN5SokYPCdOAJo
        /P2meB5mUNHp/VPnBVqCLeo=
X-Google-Smtp-Source: ABdhPJyeLEADYZlXGQ6fcr2O2NZgYjSFxVUQw7IEtpwqZAiMRkvSNcDi5EBIoIpVpSmrvmXuGWFljQ==
X-Received: by 2002:a63:155:0:b0:3fd:1b8e:16ca with SMTP id 82-20020a630155000000b003fd1b8e16camr5514696pgb.407.1655229642302;
        Tue, 14 Jun 2022 11:00:42 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ab60:e1ea:e2eb:c1b6? ([2620:15c:211:201:ab60:e1ea:e2eb:c1b6])
        by smtp.gmail.com with ESMTPSA id jf21-20020a170903269500b0015e8d4eb1d1sm7552726plb.27.2022.06.14.11.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 11:00:41 -0700 (PDT)
Message-ID: <1f8e7891-a557-bd8e-221a-6cb14770ea8b@acm.org>
Date:   Tue, 14 Jun 2022 11:00:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RFC v2 01/18] blk-mq: Add a flag for reserved requests
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, brking@us.ibm.com, hare@suse.de,
        hch@lst.de
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        chenxiang66@hisilicon.com
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
 <1654770559-101375-2-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1654770559-101375-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/22 03:29, John Garry wrote:
> Add a flag for reserved requests so that drivers may know this for any
> special handling.
> 
> The 'reserved' argument in blk_mq_ops.timeout callback could now be
> replaced by using this flag.

Why not to combine that change into this patch?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
