Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD19C87FCB
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 16:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E08F61244
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 16:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346045AbhIBQNN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 12:13:13 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:41884 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbhIBQNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 12:13:10 -0400
Received: by mail-pj1-f46.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so1851894pjt.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Sep 2021 09:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8aZ7sjFiAOKAasHVV/PLlyomdmsYx8oban63UtdAF38=;
        b=I5C+7kMbCyyIoBbXY7GZrowiY4zOLWywJPlsEB0Vsyr8GBTJqa9scldmg31TO/Zmbs
         cMUF/LFJOjbv2RAQVml+PIO9e4LuwrvcbTfcp8dVQKOKh62Cyq2gCElrfm22LHJ2Ov5/
         FoilV19aHNbSVccPjYVlm7wfrWlm3VWOckErhKZFKyuti2OqAG5Qwlg3TRsZOzhahO+0
         pj87tmo16ASYc3Jh3QOcJ5uIPWwQaoKbCiXKkHROOo+KC25YIbH+wjdJRQ6SACb2nuvE
         vXhphqWA0q17enNDiK2mBaEltZtbIflIqjKQ3TQkMf2mcpslGpwPUNcMqw86Pw2QEhFA
         j/hw==
X-Gm-Message-State: AOAM530ITRMcy5FSBmbhcv5NjDxXkT8aMhapF79q8nsyfNbMCAl4FzD9
        eM8Bf/XgDWcRF03dV55eKHg=
X-Google-Smtp-Source: ABdhPJyD6AHwzv2pr8uSBfeKhYbQUbOh+bNQyKZRz16AFyvJTP8snT/KU7IGAxf8d6ATvIT7se3xyQ==
X-Received: by 2002:a17:902:a70e:b0:12d:9eff:23be with SMTP id w14-20020a170902a70e00b0012d9eff23bemr3602423plq.34.1630599131128;
        Thu, 02 Sep 2021 09:12:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6bc5:40ad:f737:3cc2])
        by smtp.gmail.com with ESMTPSA id a21sm2822304pjo.14.2021.09.02.09.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 09:12:10 -0700 (PDT)
Subject: Re: [PATCH] mpt3sas: Call cpu_relax() before calling udelay()
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20210901152542.27866-1-sreekanth.reddy@broadcom.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d02b91a0-7afe-9d23-5d6b-bc9297e6060c@acm.org>
Date:   Thu, 2 Sep 2021 09:12:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210901152542.27866-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/21 8:25 AM, Sreekanth Reddy wrote:
> Call cpu_relax() API while waiting for the current blk-mq polling
> instance to complete.
Thanks!

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
