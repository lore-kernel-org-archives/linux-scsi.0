Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2126EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 13:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346601AbiDAOAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiDAOAo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 10:00:44 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE7B21E0E
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 06:58:54 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so2663154pjm.0
        for <linux-scsi@vger.kernel.org>; Fri, 01 Apr 2022 06:58:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JfN3oWbWZUELW9WIMrf5M+7WM4Vj2EnsYXwVB60Rp8s=;
        b=tcyxepH2G59TDxy7OYDGYveZfyT8XHm+fXZkKY1StAodiCkv281RInCOReLp2fe+LH
         pgNuBWYKLuvEcc1S53kwAUKLIknMXBe/Xj23avVFhvg/OaNHFYgh/F9K1+mFUZqeZoKx
         D6V3YKMmEYfPirAK2p4ApVGxI8zUz+hkmKx43RDYJeFTAxI28dg71SZSnTWgZEWuhOXR
         uEEwPXFuK9knFt/GAuZ5+6mhbDB/H55Ff2Z6oR7MZ7/okk67338Ei7tt1Eb59zifwMji
         Bd8VDxx0+UUorhR5mldLZDkdKKt/gCO0th7VPCcBhyGFIQv+6DmZikXrq3MPjwKtHcHU
         rJJw==
X-Gm-Message-State: AOAM532p7DlMpxi8KOq1BP3GOeI385CjtL3machkFg41cB5iLvGFGDXL
        +haxTq21wMYTRP+p8Riehgo=
X-Google-Smtp-Source: ABdhPJxE25wkiL52vrNWuD33sY+xISxmZZKxH8ZEtxkCq8hwxTV45S/pi0o7SJPdgEZWpd/pjMAalQ==
X-Received: by 2002:a17:90a:f691:b0:1c9:c81d:9953 with SMTP id cl17-20020a17090af69100b001c9c81d9953mr11865602pjb.111.1648821533758;
        Fri, 01 Apr 2022 06:58:53 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id a11-20020a056a000c8b00b004fade889fb3sm3542655pfv.18.2022.04.01.06.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 06:58:53 -0700 (PDT)
Message-ID: <47e847a9-d4b6-6fc9-d89f-9911c6510226@acm.org>
Date:   Fri, 1 Apr 2022 06:58:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 29/29] scsi: ufs: Split the drivers/scsi/ufs directory
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ye Bin <yebin10@huawei.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-30-bvanassche@acm.org>
 <c4b47162-1f98-c03b-d041-dc7ac8bd9ae2@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c4b47162-1f98-c03b-d041-dc7ac8bd9ae2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/22 23:38, Adrian Hunter wrote:
> In particular drivers/ufs/core and drivers/ufs/host would seem a
> more typical arrangement.

Hi Adrian,

Thanks for having taken a look at this patch series. I'm open to 
changing the directory names. Moving the ufs directory one level up 
sounds like a good idea to me. However, I'm not sure that 
drivers/ufs/host would be a better name than drivers/ufs/drivers since 
all files in drivers/ufs/core also implement UFS host controller support.

Thanks,

Bart.
