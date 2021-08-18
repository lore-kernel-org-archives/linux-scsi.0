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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E4B1C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 16:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 658BE6104F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 16:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhHRQhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhHRQgz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 12:36:55 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE18C061764
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 09:36:20 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id o10so2203239plg.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 09:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eoz/FQb/kUQ+vgkT7HkZ+7+djdMHuhGYPr13Ss0QUgc=;
        b=jK/MRpx2IpDufXuSN3kTqWhIFPoWYo0BDZ8z7kuhKC72mdFhGqtBGewHez8dxIwW9B
         +ori9ljw01DT4u1ExockpjJ8+1EQageN1XOcscCGP8NEnwVlGXfmw8ENiRS78Jye0Lzb
         e4UnRVGji+VtIVs6x+3NDwRB/AtfhUbYRxAEUsbQulBQHK4o063D2GMX31ooAyLGWzON
         /KPUIv/+SFwFy87RtHwYj8CwjMc3iCOX8WhJzZYQEDr5nEvhrTSOHcaAOtbyMcnv4mLJ
         Yh2nQhhQjRr4ozKXTUyw6sg31SzCgQ1OcTMAUcAiEQCHCv+K1Z1n7gdDhflyXxguVcR4
         qKog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eoz/FQb/kUQ+vgkT7HkZ+7+djdMHuhGYPr13Ss0QUgc=;
        b=JpGrS1ucc2W4tODEVKDuTidJFF+BEiJ3yXdKB+A+v2yaEgz1btz775pe0PW5tgbC58
         Ep+FXHBVb9aDcENa4WNCIr684CsbmnR1IoVu05WXLH+Jj4oDobwvpgbmIglmxmrDNuVn
         iQdgX4kBaAR3CULqgIRLMvtcgYAEGQmoiiSiVoF8ywiAD1gESZVDq3MfXsSjzjj+G9Dn
         dPtQksGRViWpr0lsaJ2f4OI4KUMAJZBS60jXS0VNsb40mRaO+1JHS8MiRFIhFj5I6o2J
         WyycdJInplfqFzKx4gRa1QqBraM3qw6wU9jr9GEQONstuohimKwdB9lDCEdxR2185sez
         sePA==
X-Gm-Message-State: AOAM532qe5GVVOvwnEmiv0pK5L04hHwccHIcR/uYb0/zse5gimdYgDvb
        7O342DJynFNNZhz2u8wiTfQ=
X-Google-Smtp-Source: ABdhPJz99xZCZFStRAlPrCZmZfxxs2MBICqXLiqDx0PYxfpNtdSXKUIXblVWhFK2Wk2Y6JCCIg28BA==
X-Received: by 2002:a17:90a:c705:: with SMTP id o5mr10275324pjt.55.1629304579836;
        Wed, 18 Aug 2021 09:36:19 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm268340pfn.94.2021.08.18.09.36.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 09:36:19 -0700 (PDT)
Subject: Re: [PATCH 27/51] lpfc: use rport as argument for
 lpfc_chk_tgt_mapped()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        James Smart <james.smart@broadcom.com>
References: <20210817091456.73342-1-hare@suse.de>
 <20210817091456.73342-28-hare@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <5dddd910-88cd-f4b2-646a-cb3ed13a0998@gmail.com>
Date:   Wed, 18 Aug 2021 09:36:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817091456.73342-28-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/2021 2:14 AM, Hannes Reinecke wrote:
> We only need the rport structure for lpfc_chk_tgt_mapped().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Cc: James Smart <james.smart@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
> 

looks good

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james



