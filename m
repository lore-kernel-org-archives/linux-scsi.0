Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B70EC76195
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 15:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjCOP4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 11:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjCOP43 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 11:56:29 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FEB86173
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 08:55:47 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso146103pjb.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 08:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678895691;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31tsdFxQ1OrbQyTrPqZ2t57o3ti/+KY6VqYoMIINrTk=;
        b=sXUcl/UUPL5bJ14AUZcJlfGDAKSJ30HUdAP3vsv7J1VZnJ9442vfIOPjTS6SxuNZ3o
         GKMrD/J+ZkiSKBt/PZatWW+LtzxxnIJj9vMv407HIocRXXOAYZBYkdrHP+zFddROFqyu
         V19faNMfa66nVvkKQRBuui/4m5KPPO5OjuO7CjfZDQnM59pjU94c1HFeYaiHa1aZfj0X
         /DFMFCfqyVLpZOWaSGB64sWSn3+ti8YeSCAnong+27Z6Txa29M/MtadblGNz49k6Mo/9
         h7YGoNjoty4pUpcNVw7bMeDiSk6liin3S9un24+UhlgQMX9nbKsuNpYbtgb73eyEO0Ng
         kqAg==
X-Gm-Message-State: AO0yUKUH0yv+3gmAPA6QT6fDF53lMFWhnyBsIjjDjbSrl82yQMI2PhZI
        oDgPYWyaDv96eA+GZuq4TVs=
X-Google-Smtp-Source: AK7set8CvyMBYNpsVQ1ulwm1slqg9wBeLboZini2A7ps4GwZ7dCWre4A6l+CMSlKRkQEFtOxHfNB+w==
X-Received: by 2002:a17:902:e353:b0:19c:a9b8:58eb with SMTP id p19-20020a170902e35300b0019ca9b858ebmr36780plc.12.1678895691173;
        Wed, 15 Mar 2023 08:54:51 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:558a:e74:a7b9:2212? ([2620:15c:211:201:558a:e74:a7b9:2212])
        by smtp.gmail.com with ESMTPSA id kr11-20020a170903080b00b00198f36a8941sm3267245plb.221.2023.03.15.08.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 08:54:50 -0700 (PDT)
Message-ID: <cd4e5d83-8cbb-ee3c-09ed-7e69b2298b8c@acm.org>
Date:   Wed, 15 Mar 2023 08:54:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/2] scsi: ufs: core: Set the residual byte count
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230314205844.313519-1-bvanassche@acm.org>
 <c93b751f-1300-bb85-bf33-42147f0b3353@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c93b751f-1300-bb85-bf33-42147f0b3353@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/23 05:59, Adrian Hunter wrote:
> On 14/03/23 22:58, Bart Van Assche wrote:
>> It is important for the SCSI core to know the residual byte count.
>> Hence, extract the residual byte count from the UFS response and pass it to
>> the SCSI core. A few examples of the output of a debugging patch that has
>> been applied on top of this patch:
>>
>> [    1.937750] cmd 0x12: len = 255; resid = 241
>> [ ... ]
>> [    1.993400] cmd 0xa0: len = 4096; resid = 4048
>> [ ... ]
> 
> Should this be a fix for stable?

Hi Adrian,

I have considered to add "Cc: stable" to this patch. I have not done 
this because I'm not sure that all UFS devices implement the residual 
count correctly.

Thanks,

Bart.

