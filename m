Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EABDC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 20:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D16E64F80
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 20:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbhCPUgs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 16:36:48 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:46728 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhCPUgh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 16:36:37 -0400
Received: by mail-pg1-f177.google.com with SMTP id 16so16989932pgo.13
        for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2021 13:36:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QWVZhxSxrkDJ3zmPzIUln25TPSv2tvtivGg2hKcONGA=;
        b=dO6rf9gTEhWbpXf9eTS1yUCHrL1RaHQc7XuVnYYjxarQ8AgLBW9mJzdqJkaDI5s8Mt
         kB6YyhGyJ4yA+9E1CwxdnIF/6jAKoJE5u/AlnL51rz8fmVDcivF78HUo8X+j92u9B0Bx
         kQ93ZF5EKxeMgZxzTnSUJ5JpA4AVDPnN71XjECVKbMFWxLj9RHc7Jv/v9V7wqSe7pG/0
         j9lB6X2jUBdftd3UfNPXagLGyBmjP06AyW+WC5OGw0+V4UDz61kNfjvcI9QQhWhHMd1N
         mFcqg2xFXN5PXZHhSZukBppXGn4xJPAxFdvvhQ3gbMR+eW+iHzIaWh6tbEaDH2bC/2/R
         TKnA==
X-Gm-Message-State: AOAM531m5g3DckwzCFzar/3dPNaQcMVcORNc2va/P3pTiRrikgCv52yI
        Y9aoPAGSEPijsbO2Vwc+rEQQ9wWaWxk=
X-Google-Smtp-Source: ABdhPJzN/FdoinUr7Hp552vAZmnTyzFsKNuACPEfTfAc9oDtODbF0Y80bbil6z7e7hf4L4Cadgg0DQ==
X-Received: by 2002:a65:6a4b:: with SMTP id o11mr1346110pgu.138.1615926997019;
        Tue, 16 Mar 2021 13:36:37 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b6b5:afbd:6ae4:8f83? ([2601:647:4000:d7:b6b5:afbd:6ae4:8f83])
        by smtp.gmail.com with ESMTPSA id b17sm17264184pfp.136.2021.03.16.13.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 13:36:36 -0700 (PDT)
Subject: Re: [PATCH 1/7] Revert "qla2xxx: Make sure that aborted commands are
 freed"
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-2-bvanassche@acm.org>
 <20210316082529.h3veoudiptaxcdwg@beryllium.lan>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <13f744a1-8c91-1c33-d53b-06f2b7ccecb9@acm.org>
Date:   Tue, 16 Mar 2021 13:36:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210316082529.h3veoudiptaxcdwg@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/21 1:25 AM, Daniel Wagner wrote:
> On Mon, Mar 15, 2021 at 08:56:49PM -0700, Bart Van Assche wrote:
>> Calling vha->hw->tgt.tgt_ops->free_cmd() from qlt_xmit_response() is wrong
>> since the command for which a response is sent must remain valid until the
>> SCSI target core calls .release_cmd().
> 
> The commit message from 0dcec41acb85 ("scsi: qla2xxx: Make sure that
> aborted commands are freed") says 'avoids that the code for removing a
> session hangs due to commands that do not make progress'.
> 
> As this patch reverts the change, is the problem mentioned gone? Did
> some other change fix it? Just wondering.

Hi Daniel,

Commit 0dcec41acb85 was the result of source reading. The changes made
by this patch in qlt_xmit_response() are wrong and may lead to a kernel
crash. Since triggering the other code paths that are modified by that
patch, I'd like to revert that patch in its entirety.

Thanks,

Bart.

