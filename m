Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A0BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 17:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD9156103B
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 17:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhKDRNX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:13:23 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:34669 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbhKDRNW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 13:13:22 -0400
Received: by mail-pg1-f174.google.com with SMTP id j9so5994482pgh.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Nov 2021 10:10:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4iRxl3VsVmXXN1hwrgiL/SEYw+Z4WiKafuVe2MYejHc=;
        b=W6iWJxocpoSm4Sx7YTt70BWiqifPJerPPYubucrbjQC3v76uEmMkBhCwjsVGA993CX
         LAUQv6VB8jJ0tmIF0gnqZI28yWXjMV2jhwkvCm7NrAYwrFcfVSk/rq6y6FZCkWvWURYU
         CRzHTIrEymT+Gsr/MER6gNTbgpE9ZsCo73/A8oXaZ4Ppttl2qfgaCrjrdsYQaZTnUEc1
         rXMsXoqMwEHZfVzhOzaHsC3xt8OhOvkzcQP3KmQqR4dAHDzgUC74JZ00c9IHBs9HMeA9
         bN4Moqm/tpAvrwIynRK7g/WBtHUK44+x08VcdHBS5qclZUngW72fO9dz8XLlvAJ1rpng
         6n6A==
X-Gm-Message-State: AOAM533tp2Sw+AXC58lBQ0ORFpqz+a779V/Uwt/b2sFsW6WfFMNYPXS2
        rf5kbJImwObxkZpAa6NP6Phc+K9g6eT6Rw==
X-Google-Smtp-Source: ABdhPJyILykgaLhUSstlaWzZ8dCpLoRyMnwVuW2xhkTb0tNcS7kIQD4J9ZJ3lWhz3S7PWbO4KaHH/w==
X-Received: by 2002:a63:88c2:: with SMTP id l185mr23643714pgd.168.1636045843530;
        Thu, 04 Nov 2021 10:10:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6f63:8570:36af:9b56])
        by smtp.gmail.com with ESMTPSA id j19sm5508259pfj.127.2021.11.04.10.10.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 10:10:42 -0700 (PDT)
Subject: Re: [PATCH RFC] scsi: ufs-core: Do not use clk_scaling_lock in
 ufshcd_queuecommand()
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org
References: <20211029133751.420015-1-adrian.hunter@intel.com>
 <24e21ff3-c992-c71e-70e3-e0c3926fbcda@acm.org>
 <c2d76154-b2ef-2e66-0a56-cd22ac8c652f@intel.com>
 <d3d70c8e-f260-ca2d-f4c1-2c9dd1a08c5d@acm.org>
 <3f4ef5e8-38e8-2e90-6da4-abc67aac9e4d@intel.com>
 <263538ad-51b5-4594-9951-8bcc2373da19@acm.org>
 <24399ee4-4feb-4670-ce9c-0872795c03ea@intel.com>
 <1a6fef86-9917-ddad-1845-d0406150ecb8@acm.org>
 <4895a54b-6d49-9204-e7b2-336854c83ed4@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c06be499-fc66-1260-400c-0458eb6de7cf@acm.org>
Date:   Thu, 4 Nov 2021 10:10:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4895a54b-6d49-9204-e7b2-336854c83ed4@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/21 7:23 AM, Asutosh Das (asd) wrote:
> In the current clock scaling code, the expectation is to scale up as 
> soon as possible.
> 
> For e.g. say, the current gear is G1 and there're pending requests in 
> the queue but the DBR is empty and there's a decision to scale up. 
> During scale-up, if the queues are frozen, wouldn't those requests be 
> issued to the driver and executed in G1 instead of G4?
> I think this would lead to higher run to run variance in performance.

Hi Asutosh,

My understanding of the current clock scaling implementation is as 
follows (please correct me if I got anything wrong):
* ufshcd_clock_scaling_prepare() is called before clock scaling happens
   and ufshcd_clock_scaling_unprepare() is called after clock scaling has
   finished.
* ufshcd_clock_scaling_prepare() calls ufshcd_scsi_block_requests() and
   ufshcd_wait_for_doorbell_clr().
* ufshcd_wait_for_doorbell_clr() waits until both the UTP Transfer
   Request List Doorbell Register and UTP Task Management Request List
   DoorBell Register are zero. Hence, it waits until all pending SCSI
   commands, task management commands and device commands have finished.

As far as I can see from a conceptual viewpoint there is no difference
between calling ufshcd_wait_for_doorbell_clr() or freezing the request
queues. There is an implementation difference however: 
blk_mq_freeze_queue() waits for an RCU grace period. This can introduce
an additional delay of several milliseconds compared to 
ufshcd_wait_for_doorbell_clr(). If this is a concern I can look into 
expediting the RCU grace period during clock scaling.

Thanks,

Bart.
