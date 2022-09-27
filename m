Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C92C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 17:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiI0Ryh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 13:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiI0Ryb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 13:54:31 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B581F10DD
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 10:54:30 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id 129so8637467pgc.5
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 10:54:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HrMCxlx63zxY9oUod/uSTIzJmnqEsaze1hPSNewoMw0=;
        b=oVjidJBlRTeI4ZmQcWj9fEJZQ+ErNhK8Td6x5Kug/n6owfMx9TzS/90N4O/QhAENtT
         K+WntP4nUB+P4VCuKuhlV4Rycs3v4KpFuGplxVlRv0gKqACRd6Xk1JBMHJys1mMHoA27
         vlTeQu2wWL8PC98SL87ecjGkwhKX9OFOhtP47jQL0ojwdpxT0NhEBJn3M0QLDvlw2B0R
         q9+TM/TDy7ihSyiR6UTB1D1I8lbAHz8EHoZzRPlnZXKz7vei3L896lU6XbQXcIoFSn0x
         Bi1Gu96zfOttuI5WxDCNGanrMnj4V5hGy4yUrVRixMWlnW9g+burnVaqULU2MzItdan0
         vKig==
X-Gm-Message-State: ACrzQf3nR2nkLG6KxW2KH1t6JWTNC0PFTjuZUWuJ3QQgOu2IzmitH54x
        h6sf6zEKpMOhxa+IKquxsIYmA2JNQjQ=
X-Google-Smtp-Source: AMsMyM4qGcD9QM0LFVUueqKiVmMGeW3c5cL+M48K7x74am7QitRifsVHHndlp5lX8QMvQ+kpnzIXfw==
X-Received: by 2002:a05:6a00:1f05:b0:540:6552:dfbf with SMTP id be5-20020a056a001f0500b005406552dfbfmr30621592pfb.65.1664301270059;
        Tue, 27 Sep 2022 10:54:30 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:457b:8ecb:16d:677? ([2620:15c:211:201:457b:8ecb:16d:677])
        by smtp.gmail.com with ESMTPSA id p184-20020a62d0c1000000b0053e78769470sm2094908pfg.88.2022.09.27.10.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 10:54:29 -0700 (PDT)
Message-ID: <7d8e58b0-7b64-f9f0-5231-98eb1974419a@acm.org>
Date:   Tue, 27 Sep 2022 10:54:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 8/8] scsi: ufs: Fix deadlock between power management and
 error handler
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220923201138.2113123-1-bvanassche@acm.org>
 <20220923201138.2113123-9-bvanassche@acm.org>
 <a39f76f2-1415-1cc4-9de6-d9a4aaf93d9b@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a39f76f2-1415-1cc4-9de6-d9a4aaf93d9b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 10:06, Adrian Hunter wrote:
>> +	/*
>> +	 * Serialize suspend/resume and error handling because a deadlock
>> +	 * occurs if the error handler runs concurrently with
>> +	 * ufshcd_set_dev_pwr_mode().
>> +	 */
>> +	if (mutex_trylock(&system_transition_mutex)) {
> 
> This is effectively disabling the UFS driver's error handler work.
> It would be better to add the ability to do that explicitly within
> the UFS driver and avoid using system_transition_mutex.

I will modify this patch such that system_transition_mutex is not used.

>> +static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
>> +{
>> +	struct ufs_hba *hba = shost_priv(scmd->device->host);
>> +
>> +	if (!hba->system_suspending) {
> 
> Is a PM notifier needed - couldn't hba->system_suspending
> have been set in ufshcd_wl_suspend() ?

I will look into this.

> Doesn't resume have the same issue ?

The member variable "system_suspending" covers both suspending and 
resuming. Do you perhaps want me to rename it into 
system_suspending_or_resuming?

>> +		/*
>> +		 * Calling the error handler directly when suspending or
>> +		 * resuming the system since the callers of this function hold
>> +		 * hba->host_sem in that case.
> 
> Runtime PM doesn't hold host_sem

I will look into whether the deadlock avoidance mechanism needs to be 
extended to runtime PM.

Thanks,

Bart.
