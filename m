Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10157C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 13:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbiDAN6Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 09:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346653AbiDAN6B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 09:58:01 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0669A1DC9B3
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 06:56:12 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so5377374pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 01 Apr 2022 06:56:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vQyvMWfzmMJR4zmnMTWkphOxkoX/A5Z/6W13agPxVZ4=;
        b=qkhj0EhP6PvizU4HVYtyty3M/RlF4vsXIIycngcqbJk92qd+oM8IOCYExzUOYYVYtI
         V2a07i9YcaQj14R7OUjcNnlVXf5l/TDzBxB5ByRieoULrzKugkR5OnxoLNs9ikr9iwAn
         ePzXTrsLerKqt9P5on5CJRcG4Rh6yuaM5+/msTapdf8Bk+wYE/h5HskYGzXMCwtfgg7m
         qW6sK4+QWLky4tP/2UevnLPcD3/yP0hM44WSYZPoGsHkJoXv9N5nxq5qf04bajUdbgQM
         SlRMvha8YPpnuduffqgPQO67Xjj1vPDWtc2aJ0xFIDIwTWr64kIGivjOQE+IM6NQy/Fb
         zO8w==
X-Gm-Message-State: AOAM5339Gni4hcYTZ4xFnykBeBH0wqyTclROHG+V8nK/jQeBX00jp3Sc
        J/M6v9Gz1LcKA84yUvJmFbE=
X-Google-Smtp-Source: ABdhPJyD/ISrd9GYbFeF6DU8IXTNCjJNR1iZE5Qd3ue1eV55xECMDioFpX+w+IJRTPnxR9+//hEGsg==
X-Received: by 2002:a17:903:2348:b0:154:dd0:aba8 with SMTP id c8-20020a170903234800b001540dd0aba8mr47377774plh.51.1648821369922;
        Fri, 01 Apr 2022 06:56:09 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y12-20020a17090a784c00b001c6bdafc995sm13659110pjl.3.2022.04.01.06.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 06:56:09 -0700 (PDT)
Message-ID: <3b8ec746-9684-b794-a9e6-b604c3cedb4f@acm.org>
Date:   Fri, 1 Apr 2022 06:56:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 29/29] scsi: ufs: Split the drivers/scsi/ufs directory
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
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
 <YkaJ2dapBN7XQgq/@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YkaJ2dapBN7XQgq/@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/22 22:12, Christoph Hellwig wrote:
> This lacks a changelog.  And making such a mess of the directory and
> creating annoyingly long paths better have a really good one.

I accidentally sent out a version of this patch series that is slightly 
older than the finalized patches - hence the build issue with patch 
26/29 and the missing description for this patch. Anyway, how about 
adding the following description to this patch:

"Split the drivers/scsi/ufs directory into a ufs-core and a ufs-drivers
directory. Move shared header files into the include/scsi directory.
This separation makes it clear which header files UFS drivers are
allowed to include (include/scsi/*.h) and which header files UFS drivers
are not allowed to include (drivers/scsi/ufs-core/*.h)."

Thanks,

Bart.
