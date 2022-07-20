Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CEEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 03:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbiGTD06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 23:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbiGTD0c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 23:26:32 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095E342AD5
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 20:26:32 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id o18so2380835pjs.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 20:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DQLoJeRbLiy2WVg1y2FS1UCj9cJHe9l0sODCzXvU5f8=;
        b=fL10Sozdz0zyIOSU4+whVfMi9GoPxtQAyZlHlovwSYVucMRQiTPOWkIiF8xQrjHznA
         ppvc2JEdjUWfh4oOmZqTn1CuEnDEHDrKRfGyH/nUPrrqIaSrzbaz7kfRVqkfjOgDAoZn
         IypqG48d0pCxhZ2YI/+62r8KAJWAnclvym+I0OIzB9tg+nXUlWmbrOJtze4AcTSUt95Z
         vvVJPNC+dAJxyDcCSYRsbnUl+thI3lGjZJUNpCvuB1NtuQ6uiELUaNak+3dMyA4eF/ON
         dpJdSupPUH68QFu2Tf8a60cWv8x/jqxhsH+wDt3P3CHY/4kHdy4vfBJ8mRQBrmgjCVmD
         nWYQ==
X-Gm-Message-State: AJIora+HpkqeUBJoCFxXg7xRvI3fIvvB7P6qnLo5j0QIaQZVAk7mWRz1
        9IiOO+LqnLy2OAMIjompNYY=
X-Google-Smtp-Source: AGRyM1sL3ABJEpMeFRT3ruFb4/qQjdUjejTeud7tACQG02kkB23xDLRU2FT4MQNqKmJFfFmae47DsA==
X-Received: by 2002:a17:902:c64b:b0:16b:d51a:dc24 with SMTP id s11-20020a170902c64b00b0016bd51adc24mr36085401pls.48.1658287591290;
        Tue, 19 Jul 2022 20:26:31 -0700 (PDT)
Received: from [192.168.3.217] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id t9-20020aa79469000000b0052974b651b9sm9526885pfq.38.2022.07.19.20.26.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 20:26:30 -0700 (PDT)
Message-ID: <8b462cff-3dfb-8e81-1ccb-3862e7e02619@acm.org>
Date:   Tue, 19 Jul 2022 20:26:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20220715212515.347664-1-bvanassche@acm.org>
 <20220715212515.347664-6-bvanassche@acm.org>
 <DM6PR04MB6575E66298A6E29011FD9958FC8F9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575E66298A6E29011FD9958FC8F9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/19/22 04:15, Avri Altman wrote:
>> @@ -2778,11 +2779,11 @@ static void ufshcd_init_lrb(struct ufs_hba *hba,
>> struct ufshcd_lrb *lrb, int i)
>>          lrb->utr_descriptor_ptr = utrdlp + i;
>>          lrb->utrd_dma_addr = hba->utrdl_dma_addr +
>>                  i * sizeof(struct utp_transfer_req_desc);
>> -       lrb->ucd_req_ptr = (struct utp_upiu_req *)(cmd_descp + i);
>> +       lrb->ucd_req_ptr = (struct utp_upiu_req *)cmd_descp;
 >
> Maybe here cmd_descp->command_upiu ?

I like that idea. I will make this change.

Thanks,

Bart.
