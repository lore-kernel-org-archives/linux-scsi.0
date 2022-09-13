Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC3AC54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Sep 2022 18:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbiIMSxL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Sep 2022 14:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbiIMSwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2022 14:52:32 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155F3B39
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 11:38:35 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id b21so12713692plz.7
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 11:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=btl+MY5ALJhiZ/peFx7FmUskDDUuRc6Zo47jLvuCKaw=;
        b=uFtt4dph32SffHWl8NRYrJoGuWhu4p8mj6j674EdyLHkLoVaJ2E39mt2d7rpi5T6W9
         REjkhjKM6SotznI7/2GfiuxNgAJKI4D4uLphW9I0cIPUvopm6RYpjOqM8byf/RxU6kQf
         opNVCS5whUxjRdmLHd6F18m3zJwDmlmw5ImNsJImsdl9XtRpECM1dqJVrb6VKOOAvaUm
         J4FVjQXIETZFqCUxfwgX0ReC5wKd3FopxxibOwCE8fBXTo9hfkKTM0kufCIyvTiXDuPz
         0u3xf/9Xfarcyed1wJUh1Y5XbrcYZHPK21z6hcsVxNagsbQbyBYwm8lZ2PbRtpzm6Tl2
         1PFA==
X-Gm-Message-State: ACrzQf2b8qnPlXSbxIkbKza1hHCrq9SARKoM2dbm4ngpwTkrryuuCA69
        9yA7iBlVZFiQqQx+NSvHE7M=
X-Google-Smtp-Source: AMsMyM5xxoEkL3uWSQfb8wDj++wIiARy7jMeTHImiiWJFP4CXqmGvxK3vZ310aZ9yl2JPMql5g5DYQ==
X-Received: by 2002:a17:90b:1d8a:b0:203:6db:ed6f with SMTP id pf10-20020a17090b1d8a00b0020306dbed6fmr612850pjb.228.1663094314450;
        Tue, 13 Sep 2022 11:38:34 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b206:445a:9717:79df? ([2620:15c:211:201:b206:445a:9717:79df])
        by smtp.gmail.com with ESMTPSA id h9-20020a056a00000900b0053e5daf1a25sm8288227pfk.45.2022.09.13.11.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 11:38:33 -0700 (PDT)
Message-ID: <bf551369-5a0c-cbe9-7175-525bfb3c4e47@acm.org>
Date:   Tue, 13 Sep 2022 11:38:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 2/3] scsi: core: Introduce a new list for SCSI proc
 directory entries
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220908233600.3043271-1-bvanassche@acm.org>
 <20220908233600.3043271-3-bvanassche@acm.org>
 <4dc1a0ba-75f3-d7f6-16c3-daddfaa05cf4@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4dc1a0ba-75f3-d7f6-16c3-daddfaa05cf4@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/22 07:26, John Garry wrote:
> On 09/09/2022 00:35, Bart Van Assche wrote:
>> +struct scsi_proc_entry {
>> +    struct list_head    entry;
>> +    const struct scsi_host_template *sht;
>> +    struct proc_dir_entry    *proc_dir;
>> +    unsigned char        present;
> 
> is there really a hard limit of 255 hosts?

Apparently that limit exists today. I can use a wider data type for the 
'present' member if you want.

>> +static struct scsi_proc_entry *
>> +__scsi_lookup_proc_entry(const struct scsi_host_template *sht)
>> +{
>> +    struct scsi_proc_entry *e;
>> +
>> +    lockdep_assert_held(&global_host_template_mutex);
> 
> I'm not sure we really need this - maybe a comment would be better. I 
> don't care too much either way.

lockdep_assert_held() statements get verified at runtime if lockdep is 
enabled but comments not. This is why I prefer lockdep_assert_held() 
over a comment.

>> +    if (e->present++) {
>> +        e = NULL;
>> +        goto unlock;
>> +    }
>> +    e->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
>> +    if (!e->proc_dir) {
>> +        printk(KERN_ERR "%s: proc_mkdir failed for %s\n", __func__,
>> +               sht->proc_name);
>> +        goto unlock;
> 
> hmmm... in this case we don't add e to the list. As unlikely as it 
> seems, if a subsequent attempt to create the proc dir passes for another 
> host with the same sht, then e->present would be incorrect, right?

Right, this needs to be fixed.

Thanks,

Bart.
