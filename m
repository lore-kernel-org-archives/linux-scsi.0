Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B940FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 15:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhLNPK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 10:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbhLNPK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 10:10:28 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC83C061574;
        Tue, 14 Dec 2021 07:10:28 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so17363353pjc.4;
        Tue, 14 Dec 2021 07:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5LsH1waqw8lf+SoXbADAabkmN/ADSpKyyJbEXGWJEL8=;
        b=fU2wEAKHPuxZxhFtbASWPKU9FQq3ou7kEnNHZBLoq6y724COW08FeRchE3Huxz37Om
         CPXq6r6swOc/swqLjBdMJYbmxvBFtgiccMq9ooJomvA/hy0VH1H1EZ/eK2/wN1bdUsRq
         j7tTCOTtor2s3A6FPCSL2IiV3tkHZSARzlYJGmqass3vee1FqyfNHwjhXhg7u82AbELx
         LnFw5r9QTtdOFnz29DGMIMLgNxkUq6sXszY+X4Uyx5UyLipEWMPdpkDhg1Sp84eqDPrN
         U+eauFRM+4zIo/xVIqbzneHUy6rM+sOv4mTG0FOfd+5qo3qNN+TLaKO9v36Zys48CdOK
         7TRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5LsH1waqw8lf+SoXbADAabkmN/ADSpKyyJbEXGWJEL8=;
        b=VLPDnEfUPS1bpRzUvq4ILPICsqNl0rKLPCZnoUOkPJ0luQQ6p15GRMpqkAIE1fUiw/
         XaL/2V4ykqpKEp5tB3BO3q9CghzmYcaoDyAGAim7LXz67uZCHGZv6Zm/KncbcKnmIhW0
         gvqP8F7Pu7cGtXYiT4C6yPK+/3gG5xmABMWp0LA9yE8q1Mc5JOV7g8A4V5OAjXKCYFwR
         vhzNOMblYNTRrr0QzyC++OFrDn2Y3zTJpQUcnxOZvfbn+LQ+lYIu5XnQJLPwc/C97zI4
         FpslaQaXahCmAq7jTj1YyjEACaGmrNhZnI5BxIQrtJl6T7H0xmmE/+F/FmftjB8WU6Xg
         bUSA==
X-Gm-Message-State: AOAM533RFMht238D3t32LgC/lnvS8A5TWy3AkYABGmx86guY1QlMXFFg
        pLnFuWQZSe7Xneexmgi/IzM=
X-Google-Smtp-Source: ABdhPJxG9SXepBLOOP05pg7fGekyEizZJ8FSFvEkI1UpNGitO5QRVoZ2ECLIxt8yeQ43KT3baSEZdA==
X-Received: by 2002:a17:902:8d8a:b0:143:bb4a:d1a with SMTP id v10-20020a1709028d8a00b00143bb4a0d1amr6117720plo.1.1639494628194;
        Tue, 14 Dec 2021 07:10:28 -0800 (PST)
Received: from [192.168.1.26] (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id na15sm3138133pjb.31.2021.12.14.07.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 07:10:27 -0800 (PST)
Message-ID: <e8655acc-e21f-b876-9d0c-790a0ee809d7@gmail.com>
Date:   Tue, 14 Dec 2021 07:10:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] scsi: lpfc: Terminate string in
 lpfc_debugfs_nvmeio_trc_write()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20211214070527.GA27934@kili>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20211214070527.GA27934@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/13/2021 11:05 PM, Dan Carpenter wrote:
> The "mybuf" string comes from the user, so we need to ensure that it is
> NUL terminated.
> 
> Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/scsi/lpfc/lpfc_debugfs.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 

Thanks Dan. Looks Good.

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james
