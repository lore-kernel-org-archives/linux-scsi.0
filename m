Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A35C001B0
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 16:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjHNQXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 12:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjHNQXW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 12:23:22 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880A4A8;
        Mon, 14 Aug 2023 09:23:21 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-686b879f605so3158986b3a.1;
        Mon, 14 Aug 2023 09:23:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692030201; x=1692635001;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p6rTH3VEN4aQVjZOQqXaUyTzfaUzeywii2A7vIXKnAI=;
        b=ChL/XXS8kX+Vyrokk+nXknRH//rgzMKbhJusq6xSWjsvxqst53avmDAxSRzyt9s0n/
         6UnZFpXTeWgorThNQzUQyfeQgmWuVbS3n6SKKN/u7L85wC3f5ASWv4f8el65SB9Qfy0O
         Qe1BIk5ikr9ozljHRy9w7KLPXcsX+4GaAZuEG+7zkGpKGBjJKGJBXoRyw6K7HJL+CW9n
         VRM5vegZF87NHEv05OAaqDx7UXYcfavwNdkytOiDYqbTWKW7wnrklOXT9GIOBbUqZxKg
         cJr1jbKVlYj1QXCfGn2TAkLeepP3yS9+EeE8BTXgQqKJ1+mmwydwmYPeXx4UIl+Lud6O
         5cPg==
X-Gm-Message-State: AOJu0YyNeZXzB1HKQJ5LGpJEP8KQKEOoz7ot6TT5kdpT3z0n7v6+u2Wt
        LimCyLwbrHBkOO0xB3/S0/IhRa4MZfk=
X-Google-Smtp-Source: AGHT+IF/ybsIo53K2MssxVJ8kRPVw+qwWyqA3LJ2G1/NUhiiDyPi/ApPlxioqflr0bdhHcs9WhdEZA==
X-Received: by 2002:a05:6a00:804:b0:675:ef91:7922 with SMTP id m4-20020a056a00080400b00675ef917922mr12459254pfk.4.1692030200836;
        Mon, 14 Aug 2023 09:23:20 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e105:59a6:229c:65de? ([2620:15c:211:201:e105:59a6:229c:65de])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79145000000b00679b7d2bd57sm8130993pfi.192.2023.08.14.09.23.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 09:23:20 -0700 (PDT)
Message-ID: <4b3d0fa7-cccb-b206-e48a-c5ee48560ea4@acm.org>
Date:   Mon, 14 Aug 2023 09:23:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v8 9/9] scsi: ufs: Inform the block layer about write
 ordering
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-10-bvanassche@acm.org>
 <668f296c-48f3-02ef-5ac1-30131579ea8d@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <668f296c-48f3-02ef-5ac1-30131579ea8d@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/23 10:09, Bao D. Nguyen wrote:
> I am not reviewing other patches in this series, so I don't know the 
> whole context. Here is my comment on this patch alone.
> 
> Looks like you rely on ufshcd_auto_hibern8_update() being invoked so 
> that you can update the driver_preserves_write_order. However, the 
> hba->ahit value can be updated by the vendor's driver, and 
> ufshcd_auto_hibern8_enable() can be invoked without 
> ufshcd_auto_hibern8_update(). Therefore, you may have a situation where 
> the driver_preserves_write_order is true by default, but 
> Auto-hibernation is enabled by default.

Hi Bao,

Other than setting a default value for auto-hibernation, vendor drivers
must not modify the auto-hibernation settings.

ufshcd_auto_hibern8_enable() calls from outside 
ufshcd_auto_hibern8_update() are used to reapply auto-hibernation
settings and not to modify auto-hibernation settings.

So I think that integrating the following change on top of this patch is
sufficient:

@@ -5172,7 +5172,9 @@ static int ufshcd_slave_configure(struct 
scsi_device *sdev)

  	ufshcd_hpb_configure(hba, sdev);

-	q->limits.driver_preserves_write_order = true;
+	q->limits.driver_preserves_write_order =
+		!ufshcd_is_auto_hibern8_supported(hba) ||
+		FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) == 0;
  	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
  	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
  		blk_queue_update_dma_alignment(q, SZ_4K - 1);

Thanks,

Bart.

