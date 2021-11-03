Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE50EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B02E561053
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhKCRJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:09:24 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:43597 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbhKCRJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:09:23 -0400
Received: by mail-pg1-f174.google.com with SMTP id b4so2899378pgh.10
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 10:06:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U2WhGsQTwxW7tS0hTAu0M8xlz3is/bV7hYwfb7I6y1U=;
        b=rLOwOHOZ4gkh7JkeAuF8wF2husyumyqJpIndctSqiEZSnYndjswZmDIhkV6ohXiH0j
         LL2NApnKXcMoWFz0gq+Czt8qQ2lkdbmVHraWAHbK4bSYBKf0wCkb9FYIdLYfGp5ZE7pH
         3mbf9TyxZZkg5hUwS19ZR//tsbsNJzVbOpnoAjriCUhdp2nhRMWVPmuL9CMsLSJDFSW2
         kTRgqBdjzF2+k99lgj0sJN+wFnINJrStb67CNl4GGw5rWJYFwa9gNrh8eYWkFFmIGEmx
         wtqz/Yo+pFcLRXZssP4aULNUikjM0T63K2qOxugpFBuM6+/xBJhxkYakIOnqWwr58UKT
         ldxA==
X-Gm-Message-State: AOAM530voHTbdq52TeBtAuwe1TF+p+lNtn2FnnBuDDD7wvMAiBFo+TZe
        FPKEtVSV79/qyrmBNezEZKhoaDWx2FOdww==
X-Google-Smtp-Source: ABdhPJzndGvBHGHVbggNeDKxMttTuHEMd3qap4tlM1rBuZnuzNasboPEzI3Zl3hSkptsABVWrisCUQ==
X-Received: by 2002:a62:5250:0:b0:480:ffbe:9e9b with SMTP id g77-20020a625250000000b00480ffbe9e9bmr25840518pfb.54.1635959206191;
        Wed, 03 Nov 2021 10:06:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9416:5327:a40e:e300])
        by smtp.gmail.com with ESMTPSA id n11sm2296947pgm.74.2021.11.03.10.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 10:06:45 -0700 (PDT)
Subject: Re: [PATCH RFC] scsi: ufs-core: Do not use clk_scaling_lock in
 ufshcd_queuecommand()
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1a6fef86-9917-ddad-1845-d0406150ecb8@acm.org>
Date:   Wed, 3 Nov 2021 10:06:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <24399ee4-4feb-4670-ce9c-0872795c03ea@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/21 12:46 AM, Adrian Hunter wrote:
> On 02/11/2021 22:49, Bart Van Assche wrote:
>>   static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>>   {
>> -    #define DOORBELL_CLR_TOUT_US        (1000 * 1000) /* 1 sec */
>>       int ret = 0;
>> +
>>       /*
>> -     * make sure that there are no outstanding requests when
>> -     * clock scaling is in progress
>> +     * Make sure that there are no outstanding requests while clock scaling
>> +     * is in progress. Since the error handler may submit TMFs, limit the
>> +     * time during which to block hba->tmf_queue in order not to block the
>> +     * UFS error handler.
>> +     *
>> +     * Since ufshcd_exec_dev_cmd() and ufshcd_issue_devman_upiu_cmd() lock
>> +     * the clk_scaling_lock before calling blk_get_request(), lock
>> +     * clk_scaling_lock before freezing the request queues to prevent a
>> +     * deadlock.
>>        */
>> -    ufshcd_scsi_block_requests(hba);
> 
> How are requests from LUN queues blocked?

I will add blk_freeze_queue() calls for the LUNs.

Thanks,

Bart.
