Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CEDC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 17:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39E3E222B9
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 17:34:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BYY5LLG6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfKSReh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 12:34:37 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44611 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfKSReg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 12:34:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id f2so24880860wrs.11
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2019 09:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=V0w7AByvr0YjnjYNwyK4ehSd9MfxyvpJ/lyxI+ZQtOQ=;
        b=BYY5LLG6i/HPzLjBtGrtlmb6wdj/ToRs5NzkonqjBTsn7TqjEXjuyaS0vOj30xxC4h
         KPgOcDTNjnpCusB4D3Uqeh9DXMSjgz6yv8blN++Ns6j+dzdqJ/whQ8A0+Z7SgTKrj2jm
         1G+0LFB1mXgmaRYLlsINU9tQ0yq+fYUTNu2qM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=V0w7AByvr0YjnjYNwyK4ehSd9MfxyvpJ/lyxI+ZQtOQ=;
        b=dg+RRauZa58doYvoG2ZY61fTf+mtn9OVbzCIny30ZMIb1f3fK4RTspVyIh4yL/g0wm
         nrVH94Aj0ctojf4O0aoCeJyN88GKaRXpsd8Cv0lJXqoyGmbYcdNI0Son6M6dchNzrJED
         nQ+t3aTEk3nZ26kRQiYi9OlGl4wQHY/VBQ82A8O1hJEgVl8Km9BD/AOJmqOUoEFbFSZn
         3z4lQbCefrWbad0ua+0z8VZQ6Pzm0n4j/g40vMGjV/apPcWWA7HnasVYgOAGV3brgczM
         tBwr0hU/6vTVYh4OKLVEWvjL3bELXoQtLaNpdmwJfXJTZLNGZk4x5MnpNVbJFAV11HgW
         +Y1g==
X-Gm-Message-State: APjAAAWAozv4EqPQoUHcWgWLfn7UrEcW6VgeTBnpXzb7Ca9NX0kEuNQe
        P+VNHYwQTDf/bUaDD20PQU4WIA==
X-Google-Smtp-Source: APXvYqz2zUydfK5YW3RL15j8tZvHPsX6fsGfxzN44opL/bgh12LotZ9on/PLeS9GzhxkXt8xii4W5A==
X-Received: by 2002:a5d:49cf:: with SMTP id t15mr38674950wrs.183.1574184875261;
        Tue, 19 Nov 2019 09:34:35 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y6sm27920122wrw.6.2019.11.19.09.34.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 09:34:34 -0800 (PST)
Subject: Re: [PATCH] lpfc: fixup out-of-bounds access during CPU hotplug
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        linux-scsi@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        James Smart <james.smart@broadcom.com>
References: <20191118123012.99664-1-hare@suse.de>
 <5c61c1ce-d4fc-23b8-621a-897febb89b67@broadcom.com>
 <1713444f-2788-ca07-3452-efc9457215d9@suse.de>
 <1dca4247-5d02-5232-cd73-a5519f1bbb94@broadcom.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <bf84585e-76e6-1a87-8b72-090b5063b981@broadcom.com>
Date:   Tue, 19 Nov 2019 09:34:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1dca4247-5d02-5232-cd73-a5519f1bbb94@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/2019 9:17 AM, James Smart wrote:
>
>
> On 11/18/2019 12:21 PM, Hannes Reinecke wrote:
>> On 11/18/19 8:28 PM, James Smart wrote:
>>> On 11/18/2019 4:30 AM, Hannes Reinecke wrote:
>>>> The lpfc driver allocates a cpu_map based on the number of possible
>>>> cpus during startup. If a CPU hotplug occurs the number of CPUs
>>>> might change, causing an out-of-bounds access when trying to lookup
>>>> the hardware index for a given CPU.
>>>>
>>>> Suggested-by: Daniel Wagner <daniel.wagner@suse.com>
>>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>>> ---
>>>>   drivers/scsi/lpfc/lpfc_scsi.c | 3 ++-
>>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c 
>>>> b/drivers/scsi/lpfc/lpfc_scsi.c
>>>> index ba26df90a36a..2380452a8efd 100644
>>>> --- a/drivers/scsi/lpfc/lpfc_scsi.c
>>>> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
>>>> @@ -642,7 +642,8 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, 
>>>> struct lpfc_nodelist *ndlp,
>>>>       int tag;
>>>>       struct fcp_cmd_rsp_buf *tmp = NULL;
>>>> -    cpu = raw_smp_processor_id();
>>>> +    cpu = min_t(u32, raw_smp_processor_id(),
>>>> +            phba->sli4_hba.num_possible_cpu);
>>>>       if (cmnd && phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ) {
>>>>           tag = blk_mq_unique_tag(cmnd->request);
>>>>           idx = blk_mq_unique_tag_to_hwq(tag);
>>>
>>> This should be unnecessary with the lpfc 12.6.0.1 and 12.6.0.2 
>>> patches that tie into cpu onling/offlining and cpu hot add.
>>>
>>> I am curious, how if a cpu is hot removed - how num_possible 
>>> dynamically changes (to a lower value ?) such that a thread can be 
>>> running on a cpu that returns a higher cpu number than num_possible ?
>>>
>> Actually, the behaviour of num_possible_cpus() under cpu hotplug 
>> seems to be implementation-specific.
>> One might want to set it to the max value at all times, which has the 
>> drawback that you'd need to scale per-cpu values with that number, 
>> leading to a massive memory overhead as only very few installation 
>> will ever reach that number.
>> Others might want to set to the max value at the current 
>> configuration, implying that it might change under CPU hotplug.
>> Which seems to be the case for PowerPC, which was the case which 
>> triggered the issue at hand.
>> But maybe it was a plain bug in the CPU hotplug implementation; one 
>> should be asking BenH for details here.
>>
>> Cheers,
>>
>> Hannes
>
> That sure seems to be at odds with this comment from 
> include/linux/cpumask.h:
>
>  *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
>  *  that it is possible might ever be plugged in at anytime during the
>  *  life of that system boot.  The cpu_present_mask is dynamic(*),
>  *  representing which CPUs are currently plugged in.  And
>  *  cpu_online_mask is the dynamic subset of cpu_present_mask,
>  *  indicating those CPUs available for scheduling.
>
> and
> #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)
>
>
> -- james
>

Although... num_possible_cpus() shouldn't change, but I guess a cpu id 
can be greater than the possible cpu count.

But there is this as well - also from include/linux/cpumask.h:
  *  If HOTPLUG is enabled, then cpu_possible_mask is forced to have
  *  all NR_CPUS bits set, otherwise it is just the set of CPUs that
  *  ACPI reports present at boot.

-- james

