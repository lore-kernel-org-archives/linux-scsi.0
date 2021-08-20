Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D09C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 22:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D701610E6
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 22:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhHTWd3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 18:33:29 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:33318 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhHTWd2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 18:33:28 -0400
Received: by mail-pf1-f177.google.com with SMTP id w68so9842520pfd.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Aug 2021 15:32:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wzhI5u1Gfxbv0YPQuQpfAkUURKs6Tmq49WvqAdXhtdI=;
        b=UjpwmIboxElfdf7k2MYRvrTFK429JzzlLQN069ZgpvfV6xx6PqVpf2uEz//X/Cwsnz
         grlGmQcptCEr6y1R1aH7N47TAL8iDRjvx51bfLuwrA7lLmCnLxsJxQoDPU3t7RNt1d+Z
         0oErppeObkBaOU1QxQBtpaCIGhgV8coodbanhRDDYw9k/7ItFxp9bTzljiBixC0mVodn
         oslOuCH6428WKdkH3mr2lEHaqqc98XnwullKG2IRO6I83Zt5v4eSKuRnuVsq6IHzcmiN
         UtkQg2qosju52j9zyxxW7t6mh3g8mDXBrfyiiK81JI1xIUPFoWqfqhNTnh8R78MCP8b7
         irpQ==
X-Gm-Message-State: AOAM533wv2wyr7z14Ks+zAhzGrMCP4CGdLinbTH4wb/nAPir4V4jos8W
        pv1UYuJrGV0zoIotBIVg22yBddrhccs=
X-Google-Smtp-Source: ABdhPJxssh3wFGUn7VJK3Gb2ThatE6HlyOqTuWo+wRdRuPQNCLwCgaXQ9Of0doaB+jUZqYBa02LsBA==
X-Received: by 2002:a63:1914:: with SMTP id z20mr20420129pgl.87.1629498769257;
        Fri, 20 Aug 2021 15:32:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ddfe:8579:6783:9ed8])
        by smtp.gmail.com with ESMTPSA id p34sm7775875pfh.172.2021.08.20.15.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 15:32:48 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Fix ufshcd_request_sense_async() for Samsung
 KLUFG8RHDA-B2D1
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20210819093534.17507-1-adrian.hunter@intel.com>
 <e495acd6-ab2c-dc07-5515-08316ac8a22d@acm.org>
 <80969e85-40e9-7cff-02fc-304774f3061b@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a6bca21a-c4d2-f6ee-d41a-836a8fd7290f@acm.org>
Date:   Fri, 20 Aug 2021 15:32:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <80969e85-40e9-7cff-02fc-304774f3061b@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/19/21 10:37 PM, Adrian Hunter wrote:
> On 19/08/21 9:14 pm, Bart Van Assche wrote:
>> On 8/19/21 2:35 AM, Adrian Hunter wrote:
>>>         * From SPC-6: the REQUEST SENSE command with any allocation length
>>> -     * clears the sense data.
>>> +     * clears the sense data, but not all UFS devices behave that way.
>>>         */
>>
>> How about removing the comment entirely? Comprehending the above comment is not possible without reviewing the git history so I think it's better to remove it.
> 
> Perhaps a comment might stop someone tempted to remove the sense size in the future.  What about:
> 
> 	/*
> 	 * Some UFS devices clear unit attention condition only if the sense
> 	 * size used (UFS_SENSE_SIZE in this case) is non-zero.
> 	 */

That sounds good to me.

PS: we are working with the team that depends on this behavior (clearing 
the unit attention condition) to implement a retry loop on top of 
ioctl(SG_IO). Once that loop has been added it will be possible to drop 
the code that clears the unit attention condition after a resume.

Thanks,

Bart.
