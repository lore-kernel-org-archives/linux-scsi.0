Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65563C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 00:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE556105A
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 00:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbhIGAln (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 20:41:43 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:34588 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhIGAln (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 20:41:43 -0400
Received: by mail-pg1-f182.google.com with SMTP id f129so8245274pgc.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Sep 2021 17:40:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=64VMd8Gpz4C+FMW1a2d2MBkCirMzzRcnAHVVfMU7JWg=;
        b=COGvrLgoy1VnfwHg98sr4Hh1s/OR+QQ6c1/HFMzELguvm5SjvU53ByAVJs53EDCuDu
         FR9IR06C8CaIAekXuMFHx/zMuoHyvng/rE+ox33vK8l3/ADLRDqFQsc+MIH3EYsjr4gV
         ibNxqMkrTjCpn+ojoeIGohixFDqDjxXr+DdKCUhTvNQtTdrXWIYoqVAsGEKVeiaD9fJS
         znlCKu5UnbGV4j8UkRRCwOrQ7MX8/98iKkhM01tlxsjdUQzJy+HM0eDrKMxa022/DsKj
         ZVBrmTpmxPX8p7jce1EqG8AD48G1Rutyu/AhrdZxAAl3zpZLbWuS3ICilAh7EfL4QsIE
         9+0Q==
X-Gm-Message-State: AOAM533pZr7ddjBLMWyz5DlnlhFnvoUyEm/ygfrXZbv7e/Jkai7CgvKJ
        8eLvwuEDxG9LeSoaH1z9OmR+MOgw/n8=
X-Google-Smtp-Source: ABdhPJwAEbunTItY0s8v6InsOQBghD7KSfALncP6NByDksNImvdFYrB4t25/8mO/ZnGNwaJ0FLdamg==
X-Received: by 2002:a62:8c8c:0:b0:413:d67b:d22a with SMTP id m134-20020a628c8c000000b00413d67bd22amr12433550pfd.30.1630975237677;
        Mon, 06 Sep 2021 17:40:37 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:6d38:bd0e:234b:803? ([2601:647:4000:d7:6d38:bd0e:234b:803])
        by smtp.gmail.com with UTF8SMTPSA id b17sm10442163pgl.61.2021.09.06.17.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 17:40:37 -0700 (PDT)
Message-ID: <1b056b0b-fd96-03db-b19a-8bff6c40f8f0@acm.org>
Date:   Mon, 6 Sep 2021 17:40:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH -next] [SCSI] Fix NULL pointer dereference in handling for
 passthrough commands
Content-Language: en-US
To:     Laibin Qiu <qiulaibin@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hare@suse.de
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210904064534.1919476-1-qiulaibin@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20210904064534.1919476-1-qiulaibin@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/3/21 23:45, Laibin Qiu wrote:
>   	cmd->cmd_len = scsi_req(req)->cmd_len;
> +	cmd->cmnd = scsi_req(req)->cmd;
>   	if (cmd->cmd_len == 0)
>   		cmd->cmd_len = scsi_command_size(cmd->cmnd);
> -	cmd->cmnd = scsi_req(req)->cmd;
>   	cmd->transfersize = blk_rq_bytes(req);

Thinking further about this: is there any code left that depends on 
scsi_setup_scsi_cmnd() setting cmd->cmd_len? Can the cmd->cmd_len 
assignment be removed from scsi_setup_scsi_cmnd()?

Thanks,

Bart.
