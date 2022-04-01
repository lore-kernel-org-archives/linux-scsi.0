Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDFFC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 04:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiDAEK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 00:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbiDAEKZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 00:10:25 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BEB11A0A
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 21:08:34 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id i11so1445564plr.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 21:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mY47RKhCVXOJ81O6Nn5Qbk5HSsLOD1K54EnWCbDBKSg=;
        b=4ygKnxfy3/+1OJQCH8XjzzMshWPBNt9CgqcYqBEg+cJFISRl0ByeUL8ENy1yV8fSAP
         corYoVmi3cyA/+iTnMV8XVwxd2p58KyUFnwTeepBbP+1QHlMLYsjl0EqBUDdarQ2JCM8
         uRTrJ/I5vnFfsYUB3yNI1K1F//oZnP1weB4LZw5WfO3KcfhwckHieUcO/MeGXSgyF8MC
         h12KMwCC4px13jfNWfcatXVOlSzWpBitq16n9+xgTD+9WHowT1tEki7Aq2R+q3k5Lglc
         1nF3KRRCVw0n+IHXwPclM8zUUSNRCGZ+v4MlWMe7SaWLdU30ZMMNmsKSWKJL7eI+wLve
         E94Q==
X-Gm-Message-State: AOAM533A5IAxODs65uDoCLX2HJpEz58DMzo9Ndcb8igm50xpA8jVxgK3
        9Wxy543AbNpD1YO7or57HqA=
X-Google-Smtp-Source: ABdhPJxDaw1Y1t/euG98WnvGfAF6WQlgQSqQAbBy0dFCPDUjWp6SmojKe4W6slOFZN4zVTbVHxNIXA==
X-Received: by 2002:a17:902:d64e:b0:154:bc8f:b6c5 with SMTP id y14-20020a170902d64e00b00154bc8fb6c5mr8566340plh.157.1648786113920;
        Thu, 31 Mar 2022 21:08:33 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s10-20020a056a00178a00b004fda49fb25dsm1055320pfg.9.2022.03.31.21.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 21:08:32 -0700 (PDT)
Message-ID: <68a7497b-2eaf-2326-1e9a-ecf5546e006e@acm.org>
Date:   Thu, 31 Mar 2022 21:08:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 14/29] scsi: ufs: Make the config_scaling_param calls type
 safe
Content-Language: en-US
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Andy Gross <agross@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-15-bvanassche@acm.org> <YkY9yRNJkuQtoHo1@ripper>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YkY9yRNJkuQtoHo1@ripper>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/22 16:48, Bjorn Andersson wrote:
> On Thu 31 Mar 15:34 PDT 2022, Bart Van Assche wrote:
>>   #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
>>   static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
>> -					  struct devfreq_dev_profile *p,
>> -					  void *data)
>> +		struct devfreq_dev_profile *p,
>> +		struct devfreq_simple_ondemand_data *d)
> 
> This doesn't look to be properly indended to match the '('?
> What does ./scripts/checkpatch.pl --strict say about the patch?
> 
> 
> Other than that, the change looks good, so feel free to add my r-b once
> you've double checked the indentation.
> 
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Checkpatch doesn't verify this kind of indentation as far as I know.
Anyway, I will fix up the indentation when I repost this patch. Thanks
for having taken a look.

Bart.
