Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AB6C41535
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451009AbiDFBJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573507AbiDETNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 15:13:41 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46C6E885A
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 12:11:42 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id s72so211852pgc.5
        for <linux-scsi@vger.kernel.org>; Tue, 05 Apr 2022 12:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bS2UTw6nFtOIUMJtSdFkWzBa/YtBAD6tRF6qeBhFUG4=;
        b=SYquMb+IGplWfoVeAuprimL+17bwsiLlcx0OtYUAl17H17jBKQTwyXrU5QHq9GolSf
         GfG3xeA/hYQDUH7irtPg5c73ZDTV81EiB33giGysByq51AmXlTxOX+9NGTV4wHNx+Hzl
         quj8mUDAg/7pEJub5OqbPX0sozxxg65QNNkTD27tBLE33+V6mrr18qR3Vl2sHhwhdSjX
         82/GKqvYTjs+VHpSdEKK79rkd5jPkEiD7M3z0IPACqWKSzNNMOjgza0He/zrjkiAvDaB
         8kh6jmQzXwNJBtCZzENlCS1s9eWgcJrRYfShyn48noAPzNfLZSlMeJ1x8ZJsBqUALi02
         6jUw==
X-Gm-Message-State: AOAM530ILKTUVOb5y8QCYj8j0/Q++g3cZonok/lt5CPKulywl8s7PKvT
        406hvJmb0uRohydsBKv8KJmSlQVdVjw=
X-Google-Smtp-Source: ABdhPJy9/LEFv2qrOSt54pjKzBL6JPT0/UzHJdg3/LYiEDp7YCdE4IsBbPhwRHkf2ZCyMQKB3OLosQ==
X-Received: by 2002:a63:2058:0:b0:399:24bb:77d3 with SMTP id r24-20020a632058000000b0039924bb77d3mr4050879pgm.412.1649185901903;
        Tue, 05 Apr 2022 12:11:41 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id l185-20020a6388c2000000b0038614ed80c0sm14871476pgd.41.2022.04.05.12.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 12:11:41 -0700 (PDT)
Message-ID: <7c17a0a8-4c69-258c-764c-6508032bf3ae@acm.org>
Date:   Tue, 5 Apr 2022 12:11:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 13/29] scsi: ufs: Remove the LUN quiescing code from
 ufshcd_wl_shutdown()
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-14-bvanassche@acm.org>
 <8e1a89f6-4195-c0a9-62f3-c1dcbbd4202f@intel.com>
 <66458c8f-157e-f050-f520-e3ec01e75d69@acm.org>
 <17c360e7-ea35-de7a-6f38-f1818826312a@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <17c360e7-ea35-de7a-6f38-f1818826312a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/22 07:35, Adrian Hunter wrote:
> On 01/04/2022 16.52, Bart Van Assche wrote:
>> On 3/31/22 23:20, Adrian Hunter wrote:
>>> On 01/04/2022 1.34, Bart Van Assche wrote:
>>>> Quiescing LUNs falls outside the scope of a shutdown callback.
>>>> The shutdown callback is called from inside the reboot() system
>>>> call and the reboot() system call is called after user space
>>>> has stopped accessing block devices. Hence this patch that
>>>> removes the quiescing calls from ufshcd_wl_shutdown(). This
>>>> patch makes shutdown faster since multiple synchronize_rcu()
>>>> calls are removed.
>>> 
>>> AFAIK there is nothing stopping shutdown being called during
>>> intense UFS I/O. What happens then?
>> 
>> Hmm ... how could this happen? Am I perhaps misunderstanding
>> something about the Linux shutdown sequence?
>> 
>> The UFS driver is the only driver I know that tries to stop I/O
>> from inside its shutdown callback. I'm not aware of any other Linux
>> kernel driver that tries to pause I/O from inside its shutdown
>> callback.
> 
> We are putting the UFS device into powerdown mode.  I am not sure
> what will happen if the device is processing requests at the same
> time.

I will remove this patch from this patch series such that it does not
block adoption of the other patches in this patch series.

Thanks,

Bart.


