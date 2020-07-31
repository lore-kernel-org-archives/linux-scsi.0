Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B4EC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 16:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6942722B40
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 16:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732693AbgGaQwA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 12:52:00 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:47036 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732474AbgGaQwA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 12:52:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id 74so6501039pfx.13;
        Fri, 31 Jul 2020 09:52:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=oLGYhoUWlZqZmJCTlVuU9mouFujuKTKpwuXuSMKojnI=;
        b=BBG/xB/DMyV3FaYTWXz8oaJa602pAMYrGJ0SgzGhGCFQIilGJhoR29kp7DtFYfoRJC
         UvcTheAFVyiqWybSV2BfXLLat+85nlrYunuXx8VF0/tjBDOs9Tg67SuxsSGE3I9qWZDG
         3kO/61aCK5+eDR+FDAW1h63N7wIiI3rzAsL33rBlbbPxAPz4Mde04/Y1k1cXSAKNjDqD
         owDD2WNCiR2+iATEsV3igGeN/KZ4jka1lwHr+FRmwYij7NkdmpGpfQC64z5dO+zIoGwQ
         pyVlYhrPZvOE6HGGMnpsx9l4uoQFWa+dAuXWY5jwmxdss2Nzq3pE6s+yfaDX4tvcYfx+
         KFTg==
X-Gm-Message-State: AOAM533IDj88B53JA+E0rWb7s9bwDp5qaSbrtje54h4YE3Wb8QeJpuYl
        5iLXFwDXPKeggwJ7d60yvKdwugeD
X-Google-Smtp-Source: ABdhPJw/GlPhqI9UPgRqOyeeiqcSnBJM5M+mvxD3mXOcyoZbqwUDiLDZrVecwx0Ue40ds8Pdm8f1LQ==
X-Received: by 2002:a63:5b5d:: with SMTP id l29mr4578617pgm.206.1596214319572;
        Fri, 31 Jul 2020 09:51:59 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w82sm10344378pff.7.2020.07.31.09.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 09:51:57 -0700 (PDT)
Subject: Re: [PATCH v4] scsi: ufs: Cleanup completed request without interrupt
 notification
To:     Can Guo <cang@codeaurora.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <Avri.Altman@wdc.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com
References: <20200724140246.19434-1-stanley.chu@mediatek.com>
 <SN6PR04MB4640B5FC06968244DDACB8BEFC720@SN6PR04MB4640.namprd04.prod.outlook.com>
 <1596159018.17247.53.camel@mtkswgap22>
 <97f1dfb0-41b6-0249-3e82-cae480b0efb6@acm.org>
 <8b0a158a7c3ee2165e09290996521ffc@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <f45c6c47-ffc5-3f8e-3234-9e5989dbf996@acm.org>
Date:   Fri, 31 Jul 2020 09:51:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8b0a158a7c3ee2165e09290996521ffc@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-31 01:00, Can Guo wrote:
> AFAIK, sychronization of scsi_done is not a problem here, because scsi
> layer
> use the atomic state, namely SCMD_STATE_COMPLETE, of a scsi cmd to prevent
> the concurrency of abort and real completion of it.
> 
> Check func scsi_times_out(), hope it helps.
> 
> enum blk_eh_timer_return scsi_times_out(struct request *req)
> {
> ...
>         if (rtn == BLK_EH_DONE) {
>                 /*
>                  * Set the command to complete first in order to prevent
> a real
>                  * completion from releasing the command while error
> handling
>                  * is using it. If the command was already completed,
> then the
>                  * lower level driver beat the timeout handler, and it
> is safe
>                  * to return without escalating error recovery.
>                  *
>                  * If timeout handling lost the race to a real
> completion, the
>                  * block layer may ignore that due to a fake timeout
> injection,
>                  * so return RESET_TIMER to allow error handling another
> shot
>                  * at this command.
>                  */
>                 if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
>                         return BLK_EH_RESET_TIMER;
>                 if (scsi_abort_command(scmd) != SUCCESS) {
>                         set_host_byte(scmd, DID_TIME_OUT);
>                         scsi_eh_scmd_add(scmd);
>                 }
>         }
> }

I am familiar with this mechanism. My concern is that both the regular
completion path and the abort handler must call scsi_dma_unmap() before
calling cmd->scsi_done(cmd). I don't see how
test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state) could prevent that
the regular completion path and the abort handler call scsi_dma_unmap()
concurrently since both calls happen before the SCMD_STATE_COMPLETE bit
is set?

Thanks,

Bart.
