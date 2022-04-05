Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5512C3527E
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392152AbiDFBIQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446293AbiDEPo0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 11:44:26 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07D838B7
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 07:13:36 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id m16so302143plx.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 Apr 2022 07:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vnYtZ2qJJRtr9wsVU523WFiVK+ZO9R7edAcgrMxWxe0=;
        b=B+MmAYCH4Bc51oq2aOrQ/6OV/tvM9dPDhrjDe6xw1aZEa8e7bvxzJJL090huJaUkHQ
         Y/YgPQET1pgnvteEYE5QYu19MGkrHhSsxbnmghsT3clNGuoMsWidvYY9pil0kvKCJ0sQ
         vN34jDJM4gi6LAG4tr6mlN5QBq1UttvYVveUIVOD2k6h534i9GRbmURyKW0wmKvN7tJ7
         rh6ZWgmHouHeYDqxImijzp3xwFGdpcKHbFwxXmNp/DdKdzkNAhY1E8IqDTj5HeRTTbzP
         VwIiJ9uOnm4G2FRxZ8evFRBVKPnxTg2QMbm7ynRtvx6yc1DeVzhYm6It2l+lud5TXXJa
         Y2JA==
X-Gm-Message-State: AOAM530RgcMFUlA/KQJ56iRzHEEWqlFiZtoYi+4bwKf0ssaOAmE9qk5A
        5CY8Ss6TseEQ9fzZq9ygxPY=
X-Google-Smtp-Source: ABdhPJzvAxpaDvwZmaE/Kt/+0C0JdsVmvx/wqO5/9A3PgEITH6d1LR6kUk0OHzhmnKny9siUwoCdow==
X-Received: by 2002:a17:90b:3a84:b0:1c7:bc91:a870 with SMTP id om4-20020a17090b3a8400b001c7bc91a870mr4355773pjb.155.1649168016289;
        Tue, 05 Apr 2022 07:13:36 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id i67-20020a636d46000000b00398344a27cfsm13703653pgc.8.2022.04.05.07.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:13:35 -0700 (PDT)
Message-ID: <e605b3dc-1421-62c9-fdf2-4476b456b539@acm.org>
Date:   Tue, 5 Apr 2022 07:13:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 28/29] scsi: ufs: Move the ufs_is_valid_unit_desc_lun()
 definition
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-29-bvanassche@acm.org>
 <DM6PR04MB6575F48E7D66AB4644CBD87EFCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575F48E7D66AB4644CBD87EFCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/4/22 23:53, Avri Altman wrote:
>>
>> Move the definition of this function from a public into a private header file
>> since it is only used inside the UFS core.
>
> Should be in patch 26/29?

Patch 26/29 splits the ufshcd.h header file. This patch moves a 
definition from ufs.h into ufshcd-priv.h. I do not have a strong opinion 
about whether that should happen in separate patches or in a single patch.

Thanks,

Bart.
