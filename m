Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F39DC7EE22
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 21:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjEQVdL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 17:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjEQVdK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 17:33:10 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422D15580
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 14:33:08 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2535edae73cso27029a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 14:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684359188; x=1686951188;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZMQnwZVYG2jGsz6VexgSojqTax2sOF1hDpsJtAE3N/A=;
        b=K2Z7LNJeVxy4kx8a2iFkOxKOlzj0qu0bgbs3IbZzWp8V/nrpFcIjvtg7wFI2vNoJqa
         gH8oDDA/ByUepygcFpjgcvNlGtOEqlWQGVsuhqzA2efK86g0HfJIwdyAz+j93GYdRFwD
         t6E8y5RwL/Y1d6zGFpsUtF89JXB7cD52VBbDOT7jBIV5sdwkP7wHLl8JZkW7Ms1fHBAI
         G24mvJYgAWo1c2VUzIjdxe7Wip2+uhLaj6M8Zd5V/rIIbSK6PjRZBMJxcAoBwIdZZB1W
         zvNV4TV84BmrFZgvzmhPt40/ESsG8xL1s65/ffzA8ef/LXakhqLO4ukD9dcm92yjSbWy
         ctMQ==
X-Gm-Message-State: AC+VfDxNSlA5HV/CbMKCj5cpeLK0jf4Wb0ENU4faaIutqILoJUmXX2Gf
        tKOu+U9/v39OnBtCpDqekKB2ZxX4XO0=
X-Google-Smtp-Source: ACHHUZ4SLLTC4k9SxtRvRauG5R5sfaFuPfPo1la0WYQQone+qDPS0EoSwoH+z18XdoEdiKPmx3UKkw==
X-Received: by 2002:a17:90b:10c:b0:24e:1f14:991e with SMTP id p12-20020a17090b010c00b0024e1f14991emr227452pjz.36.1684359187531;
        Wed, 17 May 2023 14:33:07 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id n5-20020a17090a670500b0024e33c69ee5sm29059pjj.5.2023.05.17.14.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 14:33:06 -0700 (PDT)
Message-ID: <d740a40b-5794-6e82-c171-1e18cf4e4d50@acm.org>
Date:   Wed, 17 May 2023 14:33:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5/5] scsi: ufs: Ungate the clock synchronously
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20230504235052.4423-1-bvanassche@acm.org>
 <20230504235052.4423-6-bvanassche@acm.org>
 <DM6PR04MB657581B1396166C81E77A963FC709@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657581B1396166C81E77A963FC709@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/7/23 00:08, Avri Altman wrote:
>> -int ufshcd_hold(struct ufs_hba *hba, bool async)
>> +void ufshcd_hold(struct ufs_hba *hba)
>>   {
> How about switching to the block quiescing API as well - blk_mq_{un}quiesce_tagset,
> Instead of scsi_{un}block_requests?

Hi Avri,

Did you perhaps want to refer to blk_mq_freeze_queue()? 
ufshcd_scsi_block_requests() may be called from inside 
ufshcd_queuecommand(). Calling blk_mq_freeze_queue() from inside 
ufshcd_queuecommand() would cause a deadlock.

Thanks,

Bart.
