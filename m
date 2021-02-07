Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF69C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 02:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2166864E3D
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 02:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhBGCvX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 21:51:23 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:38316 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBGCvV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 21:51:21 -0500
Received: by mail-pg1-f169.google.com with SMTP id m2so1269384pgq.5;
        Sat, 06 Feb 2021 18:51:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rnLaQW7jn1tU44mIZoa/y5WEV3NcdRCQdqW5OmbPOS8=;
        b=WdzszSSyko9XaC1W3iGAGtdZmqCdNb0T6ZvBrcG7X6AtInbw0F0yGtuvcuY7WmmDa/
         ZalSG2QYdnzKMGjJO5myI5ZwwCkgVomMJxpXPNzyEdZkrBkwnDKz2LY96ej77mv/KrfC
         EQ/Leiua9ZZtFsBXxqouBF4J9W8tywvElSyjOo8xcIfkbP9GEd8ODjaOAbZ7p5mBqO/x
         p6OvvfZAi0xOV7ESSO4f10VK45r10Z3TW/Suho9O2iKpVe9VxChE/2HS6eDGgXmwPpcX
         HqSDq5aKLwABz2CYrRaS4DO/Zidu5Siht4ILEDfl0wou9JmOvGYQQgNiFBV/IqkJhyOq
         cdkQ==
X-Gm-Message-State: AOAM531fEyhg7ueSTiKXeZ2BSQ56n3nnLMM59iB4f8mnrruD1tfjS46g
        mWEO7J9L9+gyomW1AqsQbYiUnE9zzBQ=
X-Google-Smtp-Source: ABdhPJz8WRP5zFEHlKiaH+nmC6DWDj3S1DgBEVSfsTyqRGz4IAFCm52O28jwMUYcoztoEIrjSlPz7Q==
X-Received: by 2002:a05:6a00:1:b029:1c1:2d5f:dc16 with SMTP id h1-20020a056a000001b02901c12d5fdc16mr11841244pfk.55.1612666240825;
        Sat, 06 Feb 2021 18:50:40 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:7d2:d17b:df07:7747? ([2601:647:4000:d7:7d2:d17b:df07:7747])
        by smtp.gmail.com with ESMTPSA id i7sm14562240pfc.50.2021.02.06.18.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Feb 2021 18:50:40 -0800 (PST)
Subject: Re: [PATCH v3 3/3] scsi: ufs: Fix wrong Task Tag used in task
 management request UPIUs
To:     Can Guo <cang@codeaurora.org>
Cc:     jaegeuk@kernel.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
 <1611807365-35513-4-git-send-email-cang@codeaurora.org>
 <8351747f-0ec9-3c66-1bdf-b4b73fcee698@acm.org>
 <f0d1c6a196a044198647df6ca4b06efb@codeaurora.org>
 <cd83aa1d-444e-d4ba-c363-517dbf07891a@acm.org>
 <cf50ecf7a245674f8aee917455a7ccfa@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <00ae0fb0-4c35-686b-857c-b6cba40be83a@acm.org>
Date:   Sat, 6 Feb 2021 18:50:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <cf50ecf7a245674f8aee917455a7ccfa@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 10:09 PM, Can Guo wrote:
> That code is wrong. The Task Tag in Dword_0 should be the real tag we
> allocated for TMR. The transfer request Task Tag which we are trying to
> abort is given in Dword_5, which is the Input Parameter 3 of the TMR UPIU.
> I am not sure why the author gave hba->nutrs + req->tag as the Task Tag
> of one TMR, the commit msg abot this part is not quite informative....
> 
> Table 10.22 — Task Management Request UPIU
> TASK MANAGEMENT REQUEST UPIU
> ----------------------------------
> |0         |1      |2   |3       |
> ----------------------------------
> |xx00 0100b| Flags |LUN |Task Tag|
> ----------------------------------
> ...
> 16 (MSB)   |17     |18  |19 (LSB)|
> ----------------------------------
> Input Parameter 2
> ----------------------------------
> 
> Table 10.24 — Task Management Input Parameters
> Field Description
> Input Parameter 2 LSB: Task Tag of the task/command operated by the task
> management function.

Thanks for the clarification. Feel free to add the following to this patch:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
