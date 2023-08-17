Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACD3C531DC
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 19:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354510AbjHQTQb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 15:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354702AbjHQTQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 15:16:17 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFEC2135;
        Thu, 17 Aug 2023 12:16:13 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-26b67b38b61so119696a91.0;
        Thu, 17 Aug 2023 12:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692299772; x=1692904572;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HBFKzcgt9x0gW+/Vg3LRfffpAzCeEkGxlUBOey/6MhI=;
        b=JSdB4/chDt4rMlucMzLrwbJeug5zAMKxd7pPkH6s7z6U0jCDzt5LfmS6XbthYAUlLH
         YOM5i2S502HJyexrqOylfqgU1/4PIckFS8yYbDabBtYlgw4YPE++4VKfkAQ5dth5Ichh
         cq91dMikpWU5R6xso1lGquxx6PrZzqJTfQU2mPerrrCXWlRuj68FLvQI4dm+5cjWxRbX
         OWcrpleDFAu8A7MH+Vjivqt4tNfO68ERqdDd2OMFbBH9RJmWCHqmuaAokWqUqN3Judi1
         UMBIFQr5XLxBvkFMuVUWKr/mXk2vhx69TGw3Bab1zQoCE2pNSl8SeT1ET6zSIvYAFhuA
         UGUA==
X-Gm-Message-State: AOJu0YxavEo9cCvXkMJVOWhe2e7WhR8d1OsfnpAZqNvnplIRn893Nzit
        WW23l0mSdp2fODkKWDpx5l4=
X-Google-Smtp-Source: AGHT+IEGwqYI5QM1ZE1GqYpExZYCiu850x/9WyWgbAvO+CzqTL4xPcFzu5TZbFDA/4sZGGAnRQukxA==
X-Received: by 2002:a17:90a:be11:b0:26c:f6db:ad77 with SMTP id a17-20020a17090abe1100b0026cf6dbad77mr389730pjs.2.1692299771702;
        Thu, 17 Aug 2023 12:16:11 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dfd:6f25:f7be:a9ca? ([2620:15c:211:201:dfd:6f25:f7be:a9ca])
        by smtp.gmail.com with ESMTPSA id t27-20020a63955b000000b00563397f1624sm41670pgn.69.2023.08.17.12.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 12:16:11 -0700 (PDT)
Message-ID: <aba05e63-2023-c081-fbb7-07cadb0101ad@acm.org>
Date:   Thu, 17 Aug 2023 12:16:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v9 14/17] scsi: ufs: Rename ufshcd_auto_hibern8_enable()
 and make it static
Content-Language: en-US
To:     "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-15-bvanassche@acm.org>
 <40508869-7cda-77f6-de98-6e41fce82c6a@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <40508869-7cda-77f6-de98-6e41fce82c6a@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 11:49, Bao D. Nguyen wrote:
> On 8/16/2023 12:53 PM, Bart Van Assche wrote:
>> -    /* Enable Auto-Hibernate if configured */
>> -    ufshcd_auto_hibern8_enable(hba);
>> +    ufshcd_configure_auto_hibern8(hba);
>
> Is it possible to have a race between sysfs and syspend/resume trying to update the auto_hibern8?

Only user-space software should write into sysfs. Kernel code should
not do this. User-space code is paused before the block driver suspend
callbacks are invoked and resuming block devices completes before
user space software is resumed. I don't think that sysfs writes can
race with suspend or resume callbacks.

Thanks,

Bart.

