Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FF3C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Apr 2022 03:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbiDBDXg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 23:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiDBDXf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 23:23:35 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40151AD83
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 20:21:44 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id k14so3808144pga.0
        for <linux-scsi@vger.kernel.org>; Fri, 01 Apr 2022 20:21:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=l7PAfNdg4NFs4C5ozjuO0K2BAbraG5PLoY1ycv+WeaI=;
        b=wGIxAkucs3clxQ+9M6t3lY5kizCejFdj8fJsy5aPuF9cBUx98wGCDhDqTVxKU939FX
         2/Q/ektzGT7FFC44dAmVorxlxw+/KdeDTO2N1Vx6q4fzcT+tHE4QUu5AeOJcxjp8uats
         rwIQ1ZPb1rcOLzYYKBJVAwflcz9xmcjGXzO0EvrQPS3PRV52q2+N35pRRXhmpCVnOz3I
         wfKTjBddIHYBcrT0bcq5j8EooTOwcqvx79D/kbjJvojR1P5dSjfgbfZD25wRYrHAUctL
         QtHM2MdExktm5BBNZSad58DZn+DoAte5AUtWuvjGYFJ7p1B2xbBt4AeMb4xEQ5rX4gH5
         HTRw==
X-Gm-Message-State: AOAM532V5JrzI3zIiXeT/tBTP2Q9t5dNa5o1GTPNUqA7IXS6Ana4Dk1b
        nCvv/JRWlvEQIpgqrDKRChg=
X-Google-Smtp-Source: ABdhPJxilP8I6+FDykhuFVtkuv5BCkHkEEKtyBGCeZQUMiQOfJwZBz5ZDrh4pwqH51sWj9qYo2CsTg==
X-Received: by 2002:a63:6fc4:0:b0:393:9567:16dc with SMTP id k187-20020a636fc4000000b00393956716dcmr17226331pgc.593.1648869703931;
        Fri, 01 Apr 2022 20:21:43 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id f15-20020a056a001acf00b004fb2ad05521sm4641836pfv.215.2022.04.01.20.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 20:21:42 -0700 (PDT)
Message-ID: <0074eae7-b645-d074-616f-6424540950e1@acm.org>
Date:   Fri, 1 Apr 2022 20:21:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 29/29] scsi: ufs: Split the drivers/scsi/ufs directory
Content-Language: en-US
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        'Adrian Hunter' <adrian.hunter@intel.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     'Jaegeuk Kim' <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        'Krzysztof Kozlowski' <krzk@kernel.org>,
        'Stanley Chu' <stanley.chu@mediatek.com>,
        'Andy Gross' <agross@kernel.org>,
        'Bjorn Andersson' <bjorn.andersson@linaro.org>,
        'Matthias Brugger' <matthias.bgg@gmail.com>,
        'Avri Altman' <Avri.Altman@wdc.com>,
        'Can Guo' <cang@codeaurora.org>,
        'Asutosh Das' <asutoshd@codeaurora.org>,
        'Bean Huo' <beanhuo@micron.com>,
        'Guenter Roeck' <linux@roeck-us.net>,
        'Daejun Park' <daejun7.park@samsung.com>,
        'Keoseong Park' <keosung.park@samsung.com>,
        'Eric Biggers' <ebiggers@google.com>,
        'Ulf Hansson' <ulf.hansson@linaro.org>,
        'Mike Snitzer' <snitzer@redhat.com>,
        'Jens Axboe' <axboe@kernel.dk>,
        'Geert Uytterhoeven' <geert@linux-m68k.org>,
        'Anders Roxell' <anders.roxell@linaro.org>,
        'Peter Wang' <peter.wang@mediatek.com>,
        'Chanho Park' <chanho61.park@samsung.com>,
        'Inki Dae' <inki.dae@samsung.com>,
        'Phillip Potter' <phil@philpotter.co.uk>,
        'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
        'Ye Bin' <yebin10@huawei.com>,
        'ChanWoo Lee' <cw9316.lee@samsung.com>,
        'Sergey Shtylyov' <s.shtylyov@omprussia.ru>,
        'Srinivas Kandagatla' <srinivas.kandagatla@linaro.org>,
        'Xiaoke Wang' <xkernel.wang@foxmail.com>,
        'Jinyoung Choi' <j-young.choi@samsung.com>,
        "'Gustavo A. R. Silva'" <gustavoars@kernel.org>,
        'Kiwoong Kim' <kwmad.kim@samsung.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-30-bvanassche@acm.org>
 <c4b47162-1f98-c03b-d041-dc7ac8bd9ae2@intel.com>
 <CGME20220401135856epcas5p38d9e7721c1c0981928b38edcbb2c530f@epcas5p3.samsung.com>
 <47e847a9-d4b6-6fc9-d89f-9911c6510226@acm.org>
 <009301d845ea$707e5160$517af420$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <009301d845ea$707e5160$517af420$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/1/22 10:03, Alim Akhtar wrote:
> Having said that, looking at mmc sub-system directory structure, it is simply
> drivers/mmc/core and drivers/mmc/host

Let's follow Adrian's proposal and use the drivers/ufs/core and 
drivers/ufs/host directory names.

Thanks,

Bart.
