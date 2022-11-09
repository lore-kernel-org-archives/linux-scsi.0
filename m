Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5654EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 17:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbiKIR3x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 12:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKIR3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 12:29:52 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174043B9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 09:29:52 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so2564045pjl.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 09:29:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OZdHDBt3f/t4WKgyZPUTOELIhP1yaxsH3Azx1f3R+YY=;
        b=ChoECLyvvu5K+0wC/yXamsQTDuXiNLAm6ISnNb5aW11Q3WOsPDpl8GV7Yi57JqRM81
         wapQNJ7QioT+3n3wmlW6jPwL19jcjSqJZEJehQIAR5qBbycMyDNf+66wWy9d3uhzvunC
         99UhUj39yl9ce0UX/x+qxWV4xp9TUCv97Bsw0m2HVpWxRkkdeKtJXXRyQSpP51gIka7W
         tISpxDwLmJrL4NYPA/kxpBPKG/0btV7OyRxFSo5VjCHGhvXQPFVaclvH6RBI+/DnA+Lr
         0UphSjF4FA3jIqeyxyx+/c9hCIX7dsQI7gOsQNHrNEKuK6ne3j3WNJSLExzE946fQIup
         6H2w==
X-Gm-Message-State: ACrzQf1uGI534uNc0xz5M+A1OLkGwyrxEgqVosDz8aEvD2p/O7PE8zDB
        5Y8qtbPJUq740rshoKrQkJo=
X-Google-Smtp-Source: AMsMyM7CbYE235Tu+frKZOia+tf5ew+ZHPCj/BPQ4rOdL2q3PvJl24VxMPLHFY3b49kaL0dIf0gyjQ==
X-Received: by 2002:a17:90a:1946:b0:212:f926:5382 with SMTP id 6-20020a17090a194600b00212f9265382mr62189684pjh.218.1668014991455;
        Wed, 09 Nov 2022 09:29:51 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709027e4900b00187022627d8sm9323361pln.62.2022.11.09.09.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 09:29:50 -0800 (PST)
Message-ID: <e343400f-2c87-8abf-5ebc-9c9a4a9030d4@acm.org>
Date:   Wed, 9 Nov 2022 09:29:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 5/5] scsi: ufs: Allow UFS host drivers to override the
 sg entry size
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20221108233339.412808-1-bvanassche@acm.org>
 <20221108233339.412808-6-bvanassche@acm.org> <Y2uechJH/4GFDs8h@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y2uechJH/4GFDs8h@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 04:34, Christoph Hellwig wrote:
> On Tue, Nov 08, 2022 at 03:33:39PM -0800, Bart Van Assche wrote:
>> From: Eric Biggers <ebiggers@google.com>
>>
>> Modify the UFSHCD core to allow 'struct ufshcd_sg_entry' to be
>> variable-length. The default is the standard length, but variants can
>> override ufs_hba::sg_entry_size with a larger value if there are
>> vendor-specific fields following the standard ones.
> 
> There is absolutely nothing 'vendor' in here, it is all implementation
> specifc.  I have no idea why no touching ufs can grasp this.

Hi Christoph,

I'm not sure how to interpret your reply. Anyway, this patch is required 
to use the encryption functionality of the UFS Exynos controller. The 
"vendor-specific fields" text in the patch description refers to the 
encryption fields since these follow the data buffer when using the 
Exynos controller. Although it makes me unhappy that the UFS Exynos 
controller is not compliant with the UFS specification, since it is 
being used widely I think we need support for this controller in the 
upstream kernel.

Thanks,

Bart.
