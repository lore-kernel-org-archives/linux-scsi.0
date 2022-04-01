Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FED4C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 13:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344797AbiDANyA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 09:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240712AbiDANx7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 09:53:59 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC66278C75
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 06:52:09 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id c11so2436951pgu.11
        for <linux-scsi@vger.kernel.org>; Fri, 01 Apr 2022 06:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QbYFieGzuhLMQqksqeJGczf3QEdIH0wugJyoIyx//tQ=;
        b=DTHGpSky7Zq0NZ4fsNJYdZ//UoYzPNfvMOW2djrOjkocOLUpLraGwZuD3UxnrcC8gj
         yiFLgVrhzg7Yvc7k0S3IuWTuC3v3tEILFKUtUyQ1FU0yJ5z6DLveWzvhjGWvpj56c+S/
         2O+U+xcam2SRSBTgnyqMpoqG/WmQPD7dkk279ah8jshlNx3LNWQOvOFNx8stbsOBkQQ8
         Nd8Z1O217Ud0epsncCluuNDbJZEl/7AW3YB0dgdJICx7Yk7oJZiS/DS6M3kpClo0avBh
         KI7KHBN9zqHwChUkoDmFuyKIIIffZlZ9QxhPI50dpnzaK+CgCbzjUHobT7ahhdKaHFR8
         iOfw==
X-Gm-Message-State: AOAM530jO7EWjegl/j8YrKdTfjN8wsps89ZL6wVXHkmDewc9BLxYvlq5
        oDyuk86jN5lOrRKjcrARxL/x1BJ9GbU=
X-Google-Smtp-Source: ABdhPJwB0R4lPpLorb98tJl+DN9hojU8GSPNgXv7CLN5+cmtHhHFGOwhBaPVT6ikCbHOtf1Ro7mvFw==
X-Received: by 2002:a62:8647:0:b0:4fa:dff3:4614 with SMTP id x68-20020a628647000000b004fadff34614mr11115023pfd.5.1648821128527;
        Fri, 01 Apr 2022 06:52:08 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j9-20020a056a00130900b004f73df40914sm3281208pfu.82.2022.04.01.06.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 06:52:07 -0700 (PDT)
Message-ID: <66458c8f-157e-f050-f520-e3ec01e75d69@acm.org>
Date:   Fri, 1 Apr 2022 06:52:05 -0700
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
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8e1a89f6-4195-c0a9-62f3-c1dcbbd4202f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/22 23:20, Adrian Hunter wrote:
> On 01/04/2022 1.34, Bart Van Assche wrote:
>> Quiescing LUNs falls outside the scope of a shutdown callback. The shutdown
>> callback is called from inside the reboot() system call and the reboot()
>> system call is called after user space has stopped accessing block devices.
>> Hence this patch that removes the quiescing calls from
>> ufshcd_wl_shutdown(). This patch makes shutdown faster since multiple
>> synchronize_rcu() calls are removed.
> 
> AFAIK there is nothing stopping shutdown being called during intense UFS I/O.
> What happens then?

Hmm ... how could this happen? Am I perhaps misunderstanding something 
about the Linux shutdown sequence?

The UFS driver is the only driver I know that tries to stop I/O from 
inside its shutdown callback. I'm not aware of any other Linux kernel 
driver that tries to pause I/O from inside its shutdown callback.

Thanks,

Bart.
