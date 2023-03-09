Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876ABC64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 17:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCIRVL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 12:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjCIRUv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 12:20:51 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6900CE776D
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 09:20:48 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id kb15so2771252pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 09:20:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678382448;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Yf82plxQRkYzl958tL7s3YBZ0jIbJ7dxewGO9/zsno=;
        b=kUnXJ2aq7wEpRLsdzh7ufS66CtoFP60iEn52f0NONt9CELtQIa2KeYSeCx15d8KWGl
         8ITS8wuBk7UeGW5/W3aBBpBi9/F4aAww1WNTzCBYrhj7L6GfMrS0JOadpoYPmaLLQ8xa
         2KYcaxHrDehjCQXRvfyAD9F92vkR++3cVloyy3cX0jmUhyykRYXdaVsMOvEm12E1jbID
         A77h+q+MgDZXZghtJKeWC7lx9Snu5INFD5wmo9HA7g+BxwHeZnwMvvdJnyE2ZcO1BkFu
         5bbH2/NJfr1bceS+xJhQQm4trLy9wzXqeoJs7A55CZXFpbwxbW9jWy4sZsTOFicdywiS
         Rc0w==
X-Gm-Message-State: AO0yUKUR2eBb0mXGqKfkFpiE3U5diK6XpQa8gGtVdAPBDhDJaypl4spy
        MZsz3dU/e4SSj5uzMb/nRXWPUvLoUQM=
X-Google-Smtp-Source: AK7set9haymCiPsnZT1uutmqNApGCK9lFC0ppfwXxYfYSfrG2T5d2alx/CQOpYY5hCYRVQ034E0elQ==
X-Received: by 2002:a17:90b:1a8b:b0:233:f365:1d0b with SMTP id ng11-20020a17090b1a8b00b00233f3651d0bmr23262148pjb.5.1678382447380;
        Thu, 09 Mar 2023 09:20:47 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id rj7-20020a17090b3e8700b00233cde36909sm194390pjb.21.2023.03.09.09.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 09:20:46 -0800 (PST)
Message-ID: <53e12a05-f485-f24c-0887-35900c2307c0@acm.org>
Date:   Thu, 9 Mar 2023 09:20:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: core: Simplify the code for waking up the error
 handler
Content-Language: en-US
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230307215151.3705164-1-bvanassche@acm.org>
 <20230309121328.GD620522@t480-pf1aa2c2.fritz.box>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230309121328.GD620522@t480-pf1aa2c2.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/9/23 04:13, Benjamin Block wrote:
> On Tue, Mar 07, 2023 at 01:51:51PM -0800, Bart Van Assche wrote:
>> scsi_dec_host_busy() is called from the hot path and hence must not
>> obtain the host lock if no commands have failed. scsi_dec_host_busy()
>> tests three different variables of which at least two are set if a
>> command failed. Commit 3bd6f43f5cb3 ("scsi: core: Ensure that the
>> SCSI error handler gets woken up") introduced a call_rcu() call to
>> ensure that all tasks observe the host state change before the
>> host_failed change. Simplify the approach for guaranteeing that the host
>> state and host_failed/host_eh_scheduled changes are observed in order by using
>> smp_store_release() to update host_failed or host_eh_scheduled after
>> having update the host state and smp_load_acquire() before reading the
>> host state.
> 
> It's probably just me, but "simplify" is a bit of a misnomer when you
> replace RCU by plain memory barriers. And I'm kind of wondering what we
> improve here? It seems to me that at least as far as the hot path is
> concerned, nothing really changes? The situation for
> `scsi_eh_scmd_add()` seems to improve, but that is already way off the
> hot path.

Hi Benjamin,

The advantages of the approach introduced by this patch are as follows:
* The size of struct scsi_cmnd is reduced. This may improve performance
   by reducing the number of cache misses.
* One call_rcu() call is eliminated. This reduces the error handler
   wake-up latency.

>>   	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
>>   	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
>> -		shost->host_eh_scheduled++;
>> +		smp_store_release(&shost->host_eh_scheduled,
>> +				  shost->host_eh_scheduled + 1);
> 
> Probably should be documented.

I will add a comment above each new store release / load acquire operation.

Thanks,

Bart.

