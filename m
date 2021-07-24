Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE96C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 20:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11DDF608FB
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 20:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhGXTh6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 15:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhGXTh6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 15:37:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197B8C061575;
        Sat, 24 Jul 2021 13:18:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso2582210pjf.4;
        Sat, 24 Jul 2021 13:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=j0Y5lg+CANEVDMJqiubmCGKpfDDcpR39r3NrRybVPUM=;
        b=rvgwdw+ST98gmlzef1I5Cwu9XSeP8jAl/SS5BZJUh6ezd1oyOoSuuwA901E7zqVwS1
         GU+DrvpmZDz4ZhqTgF54z52gBwDf14yS13bwwxVKmSqzDf8pSXEAAGio6+tyKQ9SHTAO
         k7H2K6MSAZ4Q8SXO1gUyy0YoLn+OI2oTnMiHuVlO1PP2pABoxfUchZrzeLomyVf7xB4M
         0xV7e5GdqG9/6CHB49/0Gvbds5w7tuB51WoFRUVo57NfWyU0ZwAIFpbyqC5c7IY2mb0n
         uu3DeYfLqS8WZcjaLXkCWRa97TR2pTyc2YpLv1n/gxgJGC3noZmv1Z0O6jZxgEcC4snD
         FTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j0Y5lg+CANEVDMJqiubmCGKpfDDcpR39r3NrRybVPUM=;
        b=JYveNn8M74EPoCBDXqgeqea6zJ61aC/FBHHGcvTIz4xTQpBFMK+lwrrjmfQQlMnNeS
         XwJALCMlNpdt9vfWlMV3zjqlZbA8z3HcNXW8y2zIe+0NjOKen3wkoOgYSF2lYkV0lZCM
         4QhBBaroUZuXWC86xOXQknQoIySg/WoMxkT5mgujQAre7sIqnUL5FzjOjDNM7BWje/y/
         611Oj8VEC2XuwAj03unfkQnZ7iMEdwK9Kz2yiQuOfLiOADlz9h1AABgA4b5TUjXcd2gf
         /zhzKq4AXlVMACgtBdnVnowLJTIss2XcBWTEZn+3kvytZE4FCvHzzPulkCEScGksRHlO
         1Skw==
X-Gm-Message-State: AOAM533jFwJqS5wxdF1FLVPp9UapWHeLQRxyaOy8FafGdE+Yn50WQQrD
        jJ7YO2u61g+6Yr3l88NT7zM4fmQf+Mc=
X-Google-Smtp-Source: ABdhPJyrebTop0PWuimFp3zvxLdJI34hoJcBS4irA/hDgJKx8uarXxZFl+b7CoHX9uHsGMU833TkfQ==
X-Received: by 2002:a17:90a:6b81:: with SMTP id w1mr10301549pjj.146.1627157908430;
        Sat, 24 Jul 2021 13:18:28 -0700 (PDT)
Received: from [192.168.1.40] (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id f15sm34919820pgv.92.2021.07.24.13.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jul 2021 13:18:28 -0700 (PDT)
Subject: Re: [BUG] scsi: lpfc: possible ABBA deadlock
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <652256c8-6fce-a506-76a9-e1502a5ff82e@gmail.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <5496b03b-49aa-88e3-e058-1d97c91b1b0b@gmail.com>
Date:   Sat, 24 Jul 2021 13:18:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <652256c8-6fce-a506-76a9-e1502a5ff82e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/15/2021 3:37 AM, Jia-Ju Bai wrote:
> Hello,
> 
> I find there is a possible ABBA deadlock in the lpfc driver in Linux 5.10:
> 
> In lpfc_nvmet_unsol_fcp_issue_abort():
> 3502:     spin_lock_irqsave(&ctxp->ctxlock, flags);
> 3504: spin_lock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
> 
> In lpfc_sli4_nvmet_xri_aborted():
> 1787: spin_lock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
> 1794:     spin_lock(&ctxp->ctxlock);
> 
> When lpfc_nvmet_unsol_fcp_issue_abort() and 
> lpfc_sli4_nvmet_xri_aborted() are concurrently executed, the deadlock 
> can occur.
> 
> I am not quite sure whether this possible deadlock is real and how to 
> fix it if it is real.
> Any feedback would be appreciated, thanks :)
> 
> 
> Best wishes,
> Jia-Ju Bai

Jia-Ju,

It's a valid issue, but rather difficult to actually occur. We've put 
together a fix and am testing it. Will post when ready.

-- james

