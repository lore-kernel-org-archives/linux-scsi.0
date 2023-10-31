Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA9EC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 16:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbjJaQZl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 12:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbjJaQZk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 12:25:40 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9E4A6;
        Tue, 31 Oct 2023 09:25:38 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5b92b852390so4461448a12.2;
        Tue, 31 Oct 2023 09:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698769538; x=1699374338;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VBgjUgKae1a0h//lnisObAhDG9lQt7TcFKpNVClEfIY=;
        b=Mj+64buLXNMx/bxc43w+sWdAkRbcKr7TLCuFtrfmYEMTpDC2rJFD5AvO7pJQtfmDga
         D8/V9RganSyo3FO6pkVgEcflRlkzZytpPzr4pvoq4WaEGWLhydns64xpwZFM4BCBfsrr
         VwPNMp957s0vVzo5szMJC6uy8P93COZKEjI/T4pSQM9U6a3C972yjyPGh/kohK5XTLbB
         40fpNtL/pZs/v/HdA/d3ryibt5oYYvcScBBZe5p9jz02WmvWA0V97rqY8WBEV1sj9pCi
         dLbjjKjplOyjwqpkgNP+lbmecf+AEjM1U7hNGLBcDksOTvuwutvw4Rb/WB4Eu9BwZsAF
         VGOQ==
X-Gm-Message-State: AOJu0YwngIghgUcFUXbRCuDtKpOwKBTcUqIZ/r0CfwoquPgepuBY7fs1
        lKnWqJln2lEUM1mho1rYVf0=
X-Google-Smtp-Source: AGHT+IFN11EJSDfjZvwaMC07t7IaFbx87XiWEwhhMbdWTXPw5YYwLlizireBmI8v/vgArTiYkpCTVw==
X-Received: by 2002:a17:90a:ac09:b0:280:19b8:83a6 with SMTP id o9-20020a17090aac0900b0028019b883a6mr9985581pjq.13.1698769537879;
        Tue, 31 Oct 2023 09:25:37 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:3a79:8603:fbab:a9fd? ([2620:15c:211:201:3a79:8603:fbab:a9fd])
        by smtp.gmail.com with ESMTPSA id m2-20020a17090a34c200b00273744e6eccsm1430394pjf.12.2023.10.31.09.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 09:25:37 -0700 (PDT)
Message-ID: <99c47a2c-e9ff-4528-ad80-98dbcc4e67ed@acm.org>
Date:   Tue, 31 Oct 2023 09:25:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] Support disabling fair tag sharing
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>, Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231023203643.3209592-1-bvanassche@acm.org>
 <ZTcr3AHr9l4sHRO2@fedora> <5d37f5ed-130a-4e75-b9a7-f77aeb4c7c89@acm.org>
 <ZThwdPaeAFmhp58L@fedora> <faf6f9e4-e1fe-4934-8fdf-84383f51e740@acm.org>
 <ZTmm0kNdN2Eka6V6@fedora> <1e53e562-bec2-4261-a704-88d2a64111d3@acm.org>
 <a6575723-4903-d098-6be0-722635db1339@huaweicloud.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a6575723-4903-d098-6be0-722635db1339@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/23 19:01, Yu Kuai wrote:
> I'm afraid that is not correct, fairness can't be guranteed at all, not
> even with just one scsi disk. This is because there are 8 wait queues in
> sbitmap, and threads are waiting in roundrobin mode, and each time
> wake_batch tags are released, wake_batch threads of one wait queue will
> be woke up, regardless that some threads can't grab tag after woken up,
> what's worse, thoese thread will be added to the tail of waitqueue
> again.
> 
> In the case that high io pressure under a slow disk, this behaviour will
> cause that io tail latency will be quite bad compared to sq from old
> kernel.
> 
> AFAIC, disable tag sharing will definitely case some regresion, for
> example, one disk will high io pressure, and another disk only issure
> one IO at a time, disable tag sharing can improve brandwith of fist
> disk, however, for the latter disk, IO latency will definitely be much
> worse.

Hi Yu,

All UFS users I know prefer that fair tag sharing is disabled for UFS
devices. So I propose to proceed with this patch series and additionally
to improve fair tag sharing for devices and transport layers that need
an improved sharing algorithm.

Thanks,

Bart.

