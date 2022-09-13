Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E157FC54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Sep 2022 19:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiIMTvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Sep 2022 15:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIMTvr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2022 15:51:47 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F7B6BCD5
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 12:51:42 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id q3so12367893pjg.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 12:51:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ncH9BAMgvvcks6DQLyxUwrGKAv7FJ4rdpxRhhAJBhpA=;
        b=HqMcf4QpCHa93riw4tPNDhfgTGcxb867GsDEJxT6KWLTYqNpbbY+tfe5WTojIs7sbK
         8SNoOJqqH3+5YJMekafxOKHfOQpQDXpUXlSlCX0tPWdjrJd/ZsMRQFNyI2FseoTvDUBK
         1CfREobt4FgAEYIQeO2p+HKlRCS4eFUxVEX4t/Zz8c8tZF4HaeWVuraiOE8Tkfvfn1AK
         xIGWKfSKSpmIW5aASBKHtlxhW34cqv9kUZzADj9M9XTt1oRwoE0opEJArML3r6Q+WATP
         P7+gvbrkmIHm7kVuqRzu7QqgXoRh1xpRew4jVfepK8QYssRzdIRkFwVRacfHQ5w5Ao4G
         U36g==
X-Gm-Message-State: ACgBeo0dNHnkd0WJwh6nXpca9q82cZy3mBeni2sOePspinj7obhQ36da
        CUT83GusUwh1YpjMM6AwG4A=
X-Google-Smtp-Source: AA6agR7lz4dDC/tzEwBXwYkL5BS4KY6UC57d2h0o+/x0XirQyXk6QIuacsr9A9oTF5RCMlSn0iGeJw==
X-Received: by 2002:a17:903:2406:b0:174:f1c8:76bc with SMTP id e6-20020a170903240600b00174f1c876bcmr33262865plo.168.1663098702280;
        Tue, 13 Sep 2022 12:51:42 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:515b:d33a:21be:45a? ([2620:15c:211:201:515b:d33a:21be:45a])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902ecca00b0016c574aa0fdsm8981158plh.76.2022.09.13.12.51.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 12:51:41 -0700 (PDT)
Message-ID: <5450db6f-d878-67f7-412d-aa3de522e068@acm.org>
Date:   Tue, 13 Sep 2022 12:51:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 1/3] scsi: esas2r: Introduce scsi_template_proc_dir()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220908233600.3043271-1-bvanassche@acm.org>
 <20220908233600.3043271-2-bvanassche@acm.org>
 <87148874-6fc4-2423-b442-3ccf3a53787b@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <87148874-6fc4-2423-b442-3ccf3a53787b@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/22 07:05, John Garry wrote:
> On 09/09/2022 00:35, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/esas2r/esas2r_main.c 
>> b/drivers/scsi/esas2r/esas2r_main.c
>> index 7a4eadad23d7..fbf7fdb3b52a 100644
>> --- a/drivers/scsi/esas2r/esas2r_main.c
>> +++ b/drivers/scsi/esas2r/esas2r_main.c
>> @@ -248,7 +248,6 @@ static struct scsi_host_template driver_template = {
>>       .sg_tablesize            = SG_CHUNK_SIZE,
>>       .cmd_per_lun            =
>>           ESAS2R_DEFAULT_CMD_PER_LUN,
>> -    .present            = 0,
> 
> nit: this really could be a separate change. It's not really strictly 
> related to introducing scsi_template_proc_dir()

I will move this change into a separate patch.

>> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
>> index 95aee1ad1383..eeb9261c93f7 100644
>> --- a/drivers/scsi/scsi_proc.c
>> +++ b/drivers/scsi/scsi_proc.c
> 
> Again, seems it should be a separate change - this is not esas2r code now

In the kernel community it is strongly recommended to introduce new 
functions in the same patch that adds a user. Hence the presence of 
scsi_proc.c changes in this patch.

>> +EXPORT_SYMBOL(scsi_template_proc_dir);
> 
> Don't we encourage EXPORT_SYMBOL_GPL? The core code seems a mishmash.

I will change this into EXPORT_SYMBOL_GPL().

>> +#if defined(CONFIG_SCSI_PROC_FS)
>> +struct proc_dir_entry *
> 
> I don't feel too strongly about this, but elsewhere we have extern and I 
> thought that consistency trumps coding standards.

Should I submit a separate patch that removes superfluous uses of the 
'extern' keyword?

Thanks,

Bart.
