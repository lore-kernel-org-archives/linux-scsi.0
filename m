Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53A1C77B6F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 17:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDKRbZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 13:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDKRbY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 13:31:24 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6855B81
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 10:31:22 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id j8so7127084pjy.4
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 10:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681234282; x=1683826282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DoMemKZVopLmI/OLnpELfMdf6JqXuCRfYsTdsuU7oqM=;
        b=tXd77jQ7sJT4tF35r9Sz3t1b/FLyzpLlCREVxKLjoE7+E8O/BhmivToWZ5mvLHC5Z0
         6RxlmqqciyZNOvo1u21PgrYvUktupYTncrCfwKOG+HIfM2YWDIsXkZ9aXJb6YiEax8hM
         51LUneg2aHQW3t4jrI+9itkdYXv+cbWPwEPGwQdIHIv8mllPdYFcXcXHUjPGnp6vpGBX
         BkG1Xd8tIIUzjs4U7THQ8Jtro13fx8GIIsqKsoZYJ1j9Q2iEufSI0FcVoQYdMLoTdayg
         /8XDIVHUsPJUtqA5GSWY3DEzSxYoIyjNMmyK4+VdiIzt3GgYqinP25pV+XZHNXndhxjI
         D48Q==
X-Gm-Message-State: AAQBX9dYi5CUK0HQvs22W3MMBbWck/jqPWSB0H2ZLfAX4qyx/yxdk1y8
        wbIyruSZc96x2x10z2M9EPY=
X-Google-Smtp-Source: AKy350YzCX091sROMhMFEuXLZsBLUp93UCcB0DEaN2/7oGF2eMfsVgCx52J9MndHZr+mRSMhvEjfNQ==
X-Received: by 2002:a17:90b:4b0a:b0:23f:10ee:feef with SMTP id lx10-20020a17090b4b0a00b0023f10eefeefmr19635106pjb.19.1681234282333;
        Tue, 11 Apr 2023 10:31:22 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:646f:c9f7:828a:8b03? ([2620:15c:211:201:646f:c9f7:828a:8b03])
        by smtp.gmail.com with ESMTPSA id jd2-20020a170903260200b001a527761c31sm6653440plb.79.2023.04.11.10.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 10:31:21 -0700 (PDT)
Message-ID: <0c8b4904-31f4-d21a-7554-6525a264293b@acm.org>
Date:   Tue, 11 Apr 2023 10:31:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: ufs: Increase the START STOP UNIT timeout from 1 s
 to 10 s
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230411001132.1239225-1-bvanassche@acm.org>
 <17217146-9c07-3963-fd32-02704632330d@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <17217146-9c07-3963-fd32-02704632330d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/23 01:39, Adrian Hunter wrote:
> On 11/04/23 03:11, Bart Van Assche wrote:
>> One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
>> Another UFS vendor asked to increase the UFS timeout from 1 s to 10 s.
>> Hence this patch that increases the UFS timeout to 10 s. This patch can
>> cause the total timeout to exceed 20 s, the Android shutdown timeout.
>> This is fine since the loop around ufshcd_execute_start_stop() exists to
>> deal with unit attentions and because unit attentions are reported
>> quickly.
>>
>> Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
> 
> Did that commit (shown below) actually increase the timeout
> because the previous commit (8f2c96420c6e) had put
> "remaining / HZ" when it should have been just "remaining"?
> Or am I misreading?
> 
> So maybe it also needs a fixes tag for 8f2c96420c6e.

Commit 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change 
timeout") changed the START STOP UNIT timeout from START_STOP_TIMEOUT 
into "remaining / HZ" (should have been "remaining") and hence passed a 
smaller value than intended to scsi_execute(). Commit dcd5b7637c6d 
changed the timeout from remaining / HZ into one second. Both values are 
too small. I'm not sure a second Fixes: tag would help since the above 
Fixes: tag should be sufficient to make this patch land in all relevant 
stable trees.

Thanks,

Bart.
