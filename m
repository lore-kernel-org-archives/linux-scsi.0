Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABE5C432BE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 16:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 055B1610E8
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 16:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhHRQgX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbhHRQgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 12:36:23 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941D3C061764
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 09:35:48 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k24so2818242pgh.8
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 09:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MZZzoB1L/BtZLzFAG1c2efe9Ft5/CHxuX1QDZvvvooQ=;
        b=M9kGW9L1950x1GNodQPHWAXNEdw/3NFXDnVnUQef6uwcAUQmGIZJT2sD9mHQ1LrDRG
         Fqydzm//MW7FWQRS0mPjPXqIa2Ti1T/vXI/SkX9LSet0/WhdSDNNSB9ml8yChmEJk2cH
         /miWBgGgpHYraYxVfIIa3xg1xOEvjHNT7fBf+JQTJw5qupB56HO+241ZihRCkl32qUf6
         6cwaKo/Qh/Rk0laJwgjSQ9Z0RmNx/VhdP9JzWnuBv/kZojnyoPi1E4OThWIE5pLgV7wE
         JFI+boM9muLpURoke2X6zipejpvedHds8ZcW0z3kUT4uWTZ8YpbyUi0w4kMcJBcMVGE8
         Jp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MZZzoB1L/BtZLzFAG1c2efe9Ft5/CHxuX1QDZvvvooQ=;
        b=FSjO1FHUNJTDCx64Db0mhMgrSudbd4bQeZ1Bv8bWec1Fy/xJhDu3aHMl1VPGsEOrqW
         biYIBBUJqYbTR2ZHCOH+UlanvBSCXuMK9TmSBszX9fejvuR1y7HSD4oMcjEP19RcnB9l
         gobhzlwqP3uJiD9Z4gHHmJddR3CGLXdq+EzW9Nx9PTrZ5ieNznscEMVUc3ZTPgHps5r1
         OnCm94dBJdI1wnLPrCs41aOUGPDCM7PgnpYn4cLu0G+a9xPVQPGMoi15OD0oCfI1i4fd
         zeJSCdXWLsv5FTbVul+VNG7KOg0qyIPMUb9EvuKyew8bNxvH6Ct5vnwbeWeJeF3Vnlzg
         MhQA==
X-Gm-Message-State: AOAM532GBl10N54iZ9jny+y66TR0lbM0bqwMY3Srr8DARy0ikGt/llV6
        ohp8kxZkVqss+ja27oJ2yU0=
X-Google-Smtp-Source: ABdhPJzye5RT+QGhqca5pASvHiiqV6FnZwnKWjZXl6sUwvZ1UYUx6cLJ3VZKcpoBNPi3rt5b0DDMiQ==
X-Received: by 2002:a63:5604:: with SMTP id k4mr9807679pgb.363.1629304548185;
        Wed, 18 Aug 2021 09:35:48 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm241140pfg.216.2021.08.18.09.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 09:35:47 -0700 (PDT)
Subject: Re: [PATCH 25/51] lpfc: use fc_block_rport()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-26-hare@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <bae85322-9422-af29-305d-31aa69e04530@gmail.com>
Date:   Wed, 18 Aug 2021 09:35:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817091456.73342-26-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/2021 2:14 AM, Hannes Reinecke wrote:
> Use fc_block_rport() instead of fc_block_scsi_eh() as the SCSI command
> will be removed as argument for SCSI EH functions.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: James Smart <james.smart@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
> 

looks good

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

