Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6D0C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 21:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbiDCVxC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 17:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiDCVxC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 17:53:02 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069BB396AD
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 14:51:04 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id u14so3230801pjj.0
        for <linux-scsi@vger.kernel.org>; Sun, 03 Apr 2022 14:51:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AKMS8doMOeBOR33NDSE7bHr9Kq4kyupalQp6ymfXvhw=;
        b=1bAktXAserVPsVmEQeIoVOXPlWMFET1MsQ7JRe/Ul33ob6FDlX+Qvkcws3OKYUrriB
         3R6/ohBmTEdEtLN7gQzbX6fHTMagiZUdeai1SXu7/VKuYEH6ZN9HIYY2wXm+l5qLr2tI
         xEs/xRKQNYNinTpX5dPyviPI29NeDEhZX87eClpjumSKvKcCWlZ/dGCZdfDRd2TCIqnx
         c/4s5yHBYXATeo30f41FfSM2RgH5w2en1FoTXbe50Pk69u0oKREkSwoYuLEQNavmFJVD
         xzLY0ctVtsM+O1AwF/FX9cDsblmCW2t7GdSqsWyUpAozzgyr/F9Ndq4nEpx4BHqBHMqk
         t+TQ==
X-Gm-Message-State: AOAM5306kOuUJDaHUpyOjtXuH92kzbKUkKpnCKk665b/MNGrdBsVrfO1
        MfP1RL0gwkOL4rVJ3JVaCig=
X-Google-Smtp-Source: ABdhPJxhKTmf3P888eN2OcNVEwJK8j3MNbvoMk3WXXjLca1TXJgHSB4RqkmQ6cwFMmjAZVochrOyaA==
X-Received: by 2002:a17:90a:af86:b0:1c7:db8e:8589 with SMTP id w6-20020a17090aaf8600b001c7db8e8589mr23115480pjq.94.1649022662780;
        Sun, 03 Apr 2022 14:51:02 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n18-20020a056a0007d200b004fdac35672fsm9275193pfu.68.2022.04.03.14.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 14:51:01 -0700 (PDT)
Message-ID: <a750afa8-6179-3b40-2feb-953d50e2b433@acm.org>
Date:   Sun, 3 Apr 2022 14:51:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 15/29] scsi: ufs: Remove the driver version
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Can Guo <cang@codeaurora.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-16-bvanassche@acm.org>
 <DM6PR04MB6575BCA70BAF3D87509AB923FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575BCA70BAF3D87509AB923FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/3/22 00:10, Avri Altman wrote:
>> Driver version numbers are not useful in upstream kernel code. Hence
> Yet still - very common across the stack, and particularly in many scsi low level drivers.
> Why the ufs drivers is any different?

Some authors of SCSI drivers use the version number to track which 
version of their driver ends up in Linux distributions like RHEL or 
SLES. I think that the driver version numbers are not useful in the UFS 
drivers because the current version number is 0.2 and that version 
number was assigned in 2013, more than nine years ago. See also commit
e0eca63e3421 ("[SCSI] ufs: Separate PCI code into glue driver").

Thanks,

Bart.
