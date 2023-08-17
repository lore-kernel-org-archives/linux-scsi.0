Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03549C678DD
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 22:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355634AbjHQWHj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355659AbjHQWHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 18:07:13 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD4735A6;
        Thu, 17 Aug 2023 15:06:29 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1bee82fad0fso2329415ad.2;
        Thu, 17 Aug 2023 15:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692309916; x=1692914716;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5CtQTS6PlV+OQPKXXROgy3jUDT0g/iOgbnSQRG0XtgQ=;
        b=FH+pAlUV8hfXYnotGJ6yj/2EYRFUuRGprLcJY81QH7VqHhvzdaGPC6xHrYo9Zfjjj6
         ZhGtpf1oL6DWGNXVjCkQ0YBQSMVW0tdLWsmBjPl0B/1y6w53tJmnPMe0naPIfxlH6iO1
         R2g+rG2aipeipXRyT4ZP1GfCKeDJz8pSgdCEwOwgxSGz2/L5WZaQlWDvxgA8S0goC4sq
         w+TjjDS5Xillr8TGtvt1hddZI5gRELk+vzFoGuzQNCXQLQMw5C78CxMD0bqf1yLE+Abt
         QLaaxvN+OJS7YiHd+wDAP8eJdWYPze62KmX/RgzXLRBu9HDdSHX6Rm0cKx2Xqg0/cYv+
         GGRA==
X-Gm-Message-State: AOJu0Yy2U0L1ycpDv2b2TUOtL4oNQAPGHRNs4a63+WV0/kSzMZ2HN72M
        fwhuOnrr9oQxsyBHPo+fn8w=
X-Google-Smtp-Source: AGHT+IHYMJfiX1PizJbrtSzNtfRmRTH1X5sZz3V4mozH/58NGRqvPvdU8A2Ematc4X7NV4dPA3MOKA==
X-Received: by 2002:a17:902:ced0:b0:1b9:e9b2:124b with SMTP id d16-20020a170902ced000b001b9e9b2124bmr698558plg.64.1692309915707;
        Thu, 17 Aug 2023 15:05:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dfd:6f25:f7be:a9ca? ([2620:15c:211:201:dfd:6f25:f7be:a9ca])
        by smtp.gmail.com with ESMTPSA id g6-20020a170902c38600b001bb7a736b4csm257239plg.77.2023.08.17.15.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 15:05:15 -0700 (PDT)
Message-ID: <5d8e90b9-34c8-5cab-2653-6f28e68eda94@acm.org>
Date:   Thu, 17 Aug 2023 15:05:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v9 17/17] scsi: ufs: Inform the block layer about write
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
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-18-bvanassche@acm.org>
 <666c6d78-d975-c9f9-4ad2-c9fa86497b47@quicinc.com>
 <4f332520-329c-6355-3aa3-cd5e29716a06@acm.org>
 <97100392-0c17-e950-1dd4-c52b97aecbe8@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <97100392-0c17-e950-1dd4-c52b97aecbe8@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 14:47, Bao D. Nguyen wrote:
> During initialization, ufshcd_auto_hibern8_update() is not called. Therefore,
> you may have SDB mode with auto hibernate enabled -> preserves_write_order = false, [ ... ]

Hi Bao,

ufshcd_slave_configure() is called before any SCSI commands are submitted to a
logical unit. ufshcd_slave_configure() sets 'preserves_write_order' depending on
the value of hba->ahit. Does this answer your question?

Thanks,

Bart.
