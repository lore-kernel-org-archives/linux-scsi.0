Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0EDC38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 05:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4624D20747
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 05:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgDVFJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 01:09:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41620 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgDVFJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 01:09:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id h69so501357pgc.8
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 22:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qJdKKGEHiO9dr6YLXdbVvbEznikhrwGIIA0yJKlU/UY=;
        b=o3d1XuYURvB/sVxWe9B2TewP9rVjdIqqHCJepAHVau9NT7F7NlqXIp5qmIWT9dlztd
         wuauTfn80wtc2GEVTHK6NNBXNGO41l2hzxP3BmiYcInrkFvcCgFRmuU5CoblCDeDOQKe
         PiUBi33gLpmfdoQ1qDzmO99IXwNn/ZmDBIkX8yS9dl6+hPVTVze9okHvGqXzUo2DzW1k
         zRVA+gsf0UWSTmaEkHe5kz+TZRM+4kSh45s73uVn1JAb0MjqejqkhFb5eko4017VofqN
         mz64EMQ6IqGdQshbWcHFN3hurZM6Yi9c7IZYxNgVmCRO8VxZCF1KVIHeTb/563/XG8T6
         sJxg==
X-Gm-Message-State: AGi0PuY99vZBY2jbC9GF5ZND2OLK1u6gbGJplKDa+KvDPGvAIL/Ph9x1
        OLWFZL+zXCqWEMgkPvIqxcE=
X-Google-Smtp-Source: APiQypIn58WvA7/wylbZmmuUbvHI65sjzc42WpR/3pDrMbvf11mpsMfSGElib0nhdFfC+HitPpgruw==
X-Received: by 2002:a63:575f:: with SMTP id h31mr21661326pgm.200.1587532166535;
        Tue, 21 Apr 2020 22:09:26 -0700 (PDT)
Received: from [100.124.11.187] ([104.129.198.219])
        by smtp.gmail.com with ESMTPSA id k24sm4027235pfk.164.2020.04.21.22.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 22:09:25 -0700 (PDT)
Subject: Re: [PATCH v3 24/31] elx: efct: LIO backend interface routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, herbszt@gmx.de,
        natechancellor@gmail.com, rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-25-jsmart2021@gmail.com>
 <dc132a7c-0d82-7439-dad0-c35a6acab1f7@acm.org>
 <cc3a75d6-3208-f450-dfd5-eaa218b0975b@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cb3e17a5-7005-5e04-89a9-40c0a16b2dfa@acm.org>
Date:   Tue, 21 Apr 2020 22:09:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <cc3a75d6-3208-f450-dfd5-eaa218b0975b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/20 9:20 PM, James Smart wrote:
> On 4/11/2020 9:57 PM, Bart Van Assche wrote:
>> On 2020-04-11 20:32, James Smart wrote:
>>> +
>>> +    lio_wq = create_singlethread_workqueue("efct_lio_worker");
>>> +    if (!lio_wq) {
>>> +        efc_log_err(efct, "workqueue create failed\n");
>>> +        return -ENOMEM;
>>> +    }
>>
>> Is any work queued onto lio_wq that needs to be serialized against other
>> work queued onto the same queue? If not, can one of the system
>> workqueues be used, e.g. system_wq?
>>
> 
> We are using "lio_wq" here to call the LIO backed during creation or 
> deletion of sessions. LIO api's target_remove_session/ 
> target_setup_session are blocking calls so we don't want to process them 
> in the interrupt thread. "lio_wq" is used for these two events only and 
> this brings the serialization to session management as we create single 
> threaded work queue.

Hi James,

I think the above is very useful information. How about adding that 
information as a comment above the definition of "lio_wq"?

Thanks,

Bart.

