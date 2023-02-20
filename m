Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983F4C6379F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Feb 2023 11:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjBTLYi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Feb 2023 06:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjBTLYe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2023 06:24:34 -0500
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A681ABFB;
        Mon, 20 Feb 2023 03:24:26 -0800 (PST)
Received: by mail-wm1-f42.google.com with SMTP id bg25-20020a05600c3c9900b003e21af96703so134766wmb.2;
        Mon, 20 Feb 2023 03:24:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676892265;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=orZM8Nvs7jWh84k6Sgfl/Z5A9qbthR5Jz7WN21ZXfmA=;
        b=YBQxTncI0VukmEdlZl7vM/GrxYR/dwNizF2yYY6BPEvN6ZZT2hSQR0GjcJNeIka8DV
         Vfq4VxdiSyA6zngPKxcppRihDljTs2b15f6cTA6Ks6KYDi4eQm35EnZnaa9AQ1ZJekXQ
         Mry9FAJ4D+wz6ROQZt8mSflrx7/6N8knDiGMOcvbf+vwE3+YIF+prkw+sq2hEOyBGBW/
         mlrg4aFOFxJIhnpe6islgWIiXSvB4Jd8126sT2CPVfklWQ4/0N0CAL49mFbkoqm6QpxM
         6+LZTkgVY8R693bto85B25snxrwj6yzwAONZiPfQuum3W7JOSldbeK5hb26a1WtBmDBI
         R7Gw==
X-Gm-Message-State: AO0yUKWp23VXExMOyAsX8IZrfVqGJ/yA7H1dq6jJUnV5//WRU8NPINUr
        ZTzD1oPOqbtt/3h4tWcMrxWkQQ5fiPQ=
X-Google-Smtp-Source: AK7set8pQ+BZnrr2+JhbY4ZPMILoc8gV4un+K1D4JYAGBAK2LUsn8tPAHo4akjUu2CZgieU/9HeLLA==
X-Received: by 2002:a7b:c842:0:b0:3db:2063:425e with SMTP id c2-20020a7bc842000000b003db2063425emr883467wml.1.1676892264834;
        Mon, 20 Feb 2023 03:24:24 -0800 (PST)
Received: from [192.168.64.80] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id f17-20020a7bc8d1000000b003e2066a6339sm13863450wml.5.2023.02.20.03.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 03:24:24 -0800 (PST)
Message-ID: <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
Date:   Mon, 20 Feb 2023 13:24:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
To:     Keith Busch <kbusch@kernel.org>, Hannes Reinecke <hare@suse.de>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        lsf-pc@lists.linuxfoundation.org
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
Content-Language: en-US
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <Y+5cjPBE6h/IW9VH@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> Hi all,
>>
>> it has come up in other threads, so it might be worthwhile to have its own
>> topic:
>>
>> Userspace command aborts
>>
>> As it stands we cannot abort I/O commands from userspace.
>> This is hitting us when running in a virtual machine:
>> The VM sets a timeout when submitting a command, but that
>> information can't be transmitted to the VM host. The VM host
>> then issues a different command (with another timeout), and
>> again that timeout can't be transmitted to the attached devices.
>> So when the VM detects a timeout, it will try to issue an abort,
>> but that goes nowhere as the VM host has no way to abort commands
>> from userspace.
>> So in the end the VM has to wait for the command to complete, causing
>> stalls in the VM if the host had to undergo error recovery or something.
> 
> Aborts are racy. A lot of hardware implements these as a no-op, too.

Indeed.

>> With io_uring or CDL we now have some mechanism which look as if they
>> would allow us to implement command aborts.
> 
> CDL on the other hand sounds more promising.
> 
>> So this BoF will be around discussions on how aborts from userspace could be
>> implemented, whether any of the above methods are suitable, or whether there
>> are other ideas on how that could be done.

I did not understand what is the relationship between aborts and CDL.
Sounds to me that this would tie in to something like Time Limited Error
Recovery (TLER) and LR bit set based on ioprio?

I am unclear where do aborts come into play here.
