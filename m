Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1931BC001E0
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 21:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjGZVRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 17:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjGZVRX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 17:17:23 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C9C1FF2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 14:17:22 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-686bea20652so313085b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 14:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690406241; x=1691011041;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2mwS7CAu+OrTN6eHnCzNR5+RvxyWwnWjvM9T5EZ6rIs=;
        b=FpLDMOOI0a9ej7n0vLKDdH1x+/tisVDGun8NgXv2pDGO5JhHp7UVZZdmvNYcFhEXna
         unZeOlDULVMqPhmEoL4t9yVdN7G1uF4xGkt2r8IcLftypaOJCUjKnB9zzsAmEFg02Rhj
         POW5UYIIVpoveZ4Bmv9nnOFb1Y35OLqgUfkXqtwdrmcIXY33EtGwvZIbpYhjuXKQ5A3S
         vyLTpmSKd5nETL82Lnq+cQJhqA6QaE+mqlmWXutDU44NaIUt417rUX43ypLLgEEj7Rfz
         uM6CRaNYNXY7dJXJXqqcSgNp4ZuDpqJ9Ayt12swhWvfv1kTsibUAIeZXcJwsrLcI36n3
         T3Zg==
X-Gm-Message-State: ABy/qLYr3D4nzkCMfjGqRbiVXYerNEerjb8EB1We7t86vkdcJE2uCeAo
        onwnEejHksUmdwhcnHoIJAs=
X-Google-Smtp-Source: APBJJlG/OgMVSQiappEvmNSm9UBDFSdLcN8VIa8g9p0iIb0+NtMq5fM83lKEZF1wVEjbTaEVk5ps1A==
X-Received: by 2002:a05:6a00:3a1f:b0:681:c372:5aa4 with SMTP id fj31-20020a056a003a1f00b00681c3725aa4mr3844568pfb.27.1690406241414;
        Wed, 26 Jul 2023 14:17:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:32d2:d535:b137:7ba3? ([2620:15c:211:201:32d2:d535:b137:7ba3])
        by smtp.gmail.com with ESMTPSA id t2-20020a63b702000000b00563a565e5fbsm7201099pgf.9.2023.07.26.14.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 14:17:20 -0700 (PDT)
Message-ID: <03bbf309-84bc-2af2-a247-f9e88f911b7e@acm.org>
Date:   Wed, 26 Jul 2023 14:17:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 11/12] scsi: ufs: Simplify transfer request header
 initialization
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Eric Biggers <ebiggers@google.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Alice Chao <alice.chao@mediatek.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20230724202024.3379114-1-bvanassche@acm.org>
 <20230724202024.3379114-12-bvanassche@acm.org>
 <DM6PR04MB65753C9475B5D27FF7AB2FDEFC00A@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65753C9475B5D27FF7AB2FDEFC00A@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/26/23 14:07, Avri Altman wrote:
> 
>>   /**
>> @@ -2587,10 +2587,10 @@ static void ufshcd_prepare_req_desc_hdr(struct
>> ufshcd_lrb *lrbp, u8 *upiu_flags,
>>                                          enum dma_data_direction cmd_dir, int ehs_length)
>>   {
>>          struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
>> +       struct request_desc_header *h = &req_desc->header;
>>          u32 data_direction;
> Maybe use the enum type as its strange to assign u32 to a nibble

Hi Avri,

I will make this change.

>> +       h->command_type = lrbp->command_type;
> AFAIK the CT is always 1 in UFSHCI3.0?

That's also my understanding. I kept the existing logic since I think 
that it's too early to drop UFSHCI 2 support?

>> +static void ufshcd_check_header_layout(void)
>> +{
>> +       BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
>> +                               .cci = 3})[0] != 3);
>> +
>> +       BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
>> +                               .ehs_length = 2})[1] != 2);
>> +
>> +       BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
>> +                               .enable_crypto = 1})[2]
>> +                    != 0x80);
>> +
>> +       BUILD_BUG_ON((((u8 *)&(struct request_desc_header){
>> +                                       .command_type = 5,
>> +                                       .data_direction = 3,
>> +                                       .interrupt = 1,
>> +                               })[3]) != ((5 << 4) | (3 << 1) | 1));
> Isn't this checker assumes endianness hence requires the applicable #ifdef?

The above code builds fine on big endian and little endian systems 
because of the #ifdefs that are present in the definition of struct 
request_desc_header.

The script I use for compile testing of SCSI code is available here: 
https://github.com/bvanassche/build-scsi-drivers/

Thanks,

Bart.
