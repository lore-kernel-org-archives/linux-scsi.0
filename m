Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D44C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 17:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiI2Rve (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 13:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiI2Rvd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 13:51:33 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6D413B001
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 10:51:32 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id g130so1504659pfb.8
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 10:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YLTDvXZeg7A6My2q0HgKmN1OU756fbtX0Hf/V9XrJTU=;
        b=w0382kg8B7Id604YUOmVmBCfYy8lQg6eW22OGHNPGEFH/7yOWqNr1TRbNaKFaQzQi/
         IhlMdWUkV7bCrNSWdxGFez9lEKOSrUZ1keXiWgcKDigPa2ERS8fXIwgP+1av5sd784uu
         BkOVDObT8+zEOsMWytCqKxlJoRVfurDWWPLBWo0OWXkRsYVRaCiQgA1STSmnH/Pe82CQ
         vTzkDtMdQ3DKDcgr8/eBDVQyGVAL1ifv/TxVQSjQ8sEdyYpLXjNZMZIPZnj8Ppr5hYbP
         3jjBF4TTHsb0Mg9X26erFxdhbolR6VkNNKFJAAkuW6KQBWA5Fy8Bfk2mWZI1mkbO3Z35
         7xgA==
X-Gm-Message-State: ACrzQf24dr9B1p344g8GvfrMzdxO8Ic3pybn5kW6pX6WZg24M+zgAmr8
        3KKmf9f4IxVQ7KxdqY6890M=
X-Google-Smtp-Source: AMsMyM7Iic4kMJ/RorJ11rQBgnObYVTQbVCCq1MDz/sIkk5b0n2vPjPrfhrokxNnxaIaoMgf7wE0rA==
X-Received: by 2002:a63:d70a:0:b0:43c:e223:c85e with SMTP id d10-20020a63d70a000000b0043ce223c85emr3819136pgg.208.1664473891678;
        Thu, 29 Sep 2022 10:51:31 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:2e63:ed10:2841:950e? ([2620:15c:211:201:2e63:ed10:2841:950e])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090322c400b00176d6ad3cd4sm171697plg.100.2022.09.29.10.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 10:51:30 -0700 (PDT)
Message-ID: <970dc24c-9c72-71be-0609-cfd4bfd43d5a@acm.org>
Date:   Thu, 29 Sep 2022 10:51:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v5 4/7] scsi: core: Introduce a new list for SCSI proc
 directory entries
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220914225621.415631-1-bvanassche@acm.org>
 <20220914225621.415631-5-bvanassche@acm.org>
 <1c7dade7-c821-e851-4b94-1c27ccd1fac6@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1c7dade7-c821-e851-4b94-1c27ccd1fac6@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/22 03:34, John Garry wrote:
> On 14/09/2022 23:56, Bart Van Assche wrote:
>> -int scsi_proc_hostdir_add(struct scsi_host_template *sht)
>> +int scsi_proc_hostdir_add(const struct scsi_host_template *sht)
>>   {
>> -    int ret = 0;
>> +    struct scsi_proc_entry *e;
>> +    int ret = -ENOMEM;
>>       if (!sht->show_info)
>>           return 0;
>>       mutex_lock(&global_host_template_mutex);
>> -    if (!sht->present++) {
>> -        sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
>> -            if (!sht->proc_dir) {
>> -            printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
>> -                   __func__, sht->proc_name);
>> -            ret = -ENOMEM;
>> -        }
>> +    e = __scsi_lookup_proc_entry(sht);
>> +    if (!e) {
>> +        e = kzalloc(sizeof(*e), GFP_KERNEL);
>> +        if (!e)
>> +            goto unlock;
> 
> maybe it's better to set ret = -ENOMEM here (and not initialize ret), as every other path it is set, AFAICS

I will make this change and also set ret if proc_mkdir() fails.

>>   void scsi_proc_host_add(struct Scsi_Host *shost)
>>   {
>> -    struct scsi_host_template *sht = shost->hostt;
>> +    const struct scsi_host_template *sht = shost->hostt;
>> +    struct scsi_proc_entry *e;
>>       struct proc_dir_entry *p;
>>       char name[10];
>> -    if (!sht->proc_dir)
>> +    if (!sht->show_info)
>> +        return;
>> +
>> +    e = scsi_lookup_proc_entry(sht);
> 
> hmm... this really should not fail, right?. Maybe an error message would be appropiate here (for failure).

If scsi_proc_hostdir_add() failed scsi_lookup_proc_entry() will return NULL.
I will add an error message.

>> +    if (!e)
>>           return;
>>       sprintf(name,"%d", shost->host_no);
>> -    p = proc_create_data(name, S_IRUGO | S_IWUSR,
>> -        sht->proc_dir, &proc_scsi_ops, shost);
>> +    p = proc_create_data(name, S_IRUGO | S_IWUSR, e->proc_dir,
>> +                 &proc_scsi_ops, shost);
>>       if (!p)
>>           printk(KERN_ERR "%s: Failed to register host %d in"
>>                  "%s\n", __func__, shost->host_no,
>> @@ -175,13 +241,19 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
>>    */
>>   void scsi_proc_host_rm(struct Scsi_Host *shost)
>>   {
>> +    const struct scsi_host_template *sht = shost->hostt;
>> +    struct scsi_proc_entry *e;
>>       char name[10];
>> -    if (!shost->hostt->proc_dir)
>> +    if (!sht->show_info)
>> +        return;
>> +
>> +    e = scsi_lookup_proc_entry(sht);
> 
> Same comment as scsi_proc_host_add

If scsi_proc_hostdir_add() failed scsi_lookup_proc_entry() will return NULL.

Thanks,

Bart.
