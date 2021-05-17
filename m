Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEB1C43618
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 15:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60306610CB
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 15:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242576AbhEQPPr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 11:15:47 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:39536 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243318AbhEQPNb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 11:13:31 -0400
Received: by mail-pg1-f173.google.com with SMTP id v14so2116509pgi.6
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 08:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z8ACqzs3Ue5yJXJEc5rV7VXbVOU5xBFKsKrhGuoomFw=;
        b=BNmcFCFDJqTERsJR1bucu5/jj/yCfDmzgyP81pMTzMPLuSyyXUaj6wpe2oTULRCH12
         mNhy8TrODc0BGEAQiQByxFifehF+vw++3ln9xnZOsO1Mco0W8+gTRdXOgkcPbH/yljID
         F/NasS/pClvC92fs5CXDs/gWtkBR2kvJ7yJH034o/JWJxo8m8uK10ZklMwrYigt2x2pS
         9uE6qVrpmg4ylooF081g1j5yPRp4AVJcuJECfRquLqXjctG3sSBqUz0FUYJ5xpNW5oWX
         4X+Us4GoXZCmfXUlezvxiYii7jaeU2k1Zdh6nMjG8p5Eq0+FWrA7aO2jcMxd9tUiE2N7
         3/qQ==
X-Gm-Message-State: AOAM531NIG1fxLKGw2a2ZMU7Nc2m0H40Nbek7O3hy5P3eq1kiBj7BvXn
        Qe6rs91hpMaJhj4prf8fMShkhRjCOW4=
X-Google-Smtp-Source: ABdhPJyTKTVGG1Q8BlRRucHaXMWRI0P3LeSkddOzUVgeWxt3CxVhIzd2cSBTzF8KN7yY3lekc5iUgA==
X-Received: by 2002:aa7:828f:0:b029:200:6e27:8c8f with SMTP id s15-20020aa7828f0000b02902006e278c8fmr57754pfm.44.1621264332526;
        Mon, 17 May 2021 08:12:12 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8224:c0d6:d9dd:57b3? ([2601:647:4000:d7:8224:c0d6:d9dd:57b3])
        by smtp.gmail.com with ESMTPSA id i9sm18045990pjh.9.2021.05.17.08.12.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 08:12:11 -0700 (PDT)
Subject: Re: [PATCH 2/3] Introduce enums for the SAM, message, host and driver
 status codes
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>
References: <20210514232308.7826-1-bvanassche@acm.org>
 <20210514232308.7826-3-bvanassche@acm.org>
 <178da9e9-7946-e0e1-1ab7-593fa94c17c9@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <91b3f885-dbda-c6c7-ccfe-36349afa65a3@acm.org>
Date:   Mon, 17 May 2021 08:12:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <178da9e9-7946-e0e1-1ab7-593fa94c17c9@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/21 3:38 AM, John Garry wrote:
> On 15/05/2021 00:23, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 84d73f57292b..d8774998ec6d 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -413,7 +413,7 @@ static const char * const driverbyte_table[]={
>>   const char *scsi_hostbyte_string(int result)
>>   {
>>       const char *hb_string = NULL;
>> -    int hb = host_byte(result);
>> +    enum host_status hb = host_byte(result);
>>   
> nit: I figure that this code had been consciously written to use
> reverse-Christmas tree style, so maybe we can maintain it

Ah, that's something I was not aware of. I will fix this.

>> --- a/drivers/target/target_core_pscsi.c
>> +++ b/drivers/target/target_core_pscsi.c
>> @@ -1044,7 +1044,7 @@ static void pscsi_req_done(struct request *req,
>> blk_status_t status)
>>       struct se_cmd *cmd = req->end_io_data;
>>       struct pscsi_plugin_task *pt = cmd->priv;
>>       int result = scsi_req(req)->result;
>> -    u8 scsi_status = status_byte(result) << 1;
>> +    enum sam_status scsi_status = status_byte(result) << 1;
> 
> Is someone going to be fixing up drivers elsewhere to use these enums?

I plan to repost the patch series that fixes up the SCSI LLDs after this
patch series has been accepted.

>> +/* Host byte codes. */
>> +enum host_status {
> 
> Just wondered is it intentional that we don't prefix "scsi_" to the enum
> name? Would it be because none of the symbols, below, don't?

I will add the prefix "scsi_" to these enumeration type names.

Thanks,

Bart.
