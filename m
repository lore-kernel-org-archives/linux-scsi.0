Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1873C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 04:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CAE321744
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 04:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgGaEGq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 00:06:46 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40725 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgGaEGp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 00:06:45 -0400
Received: by mail-pj1-f68.google.com with SMTP id t15so6556585pjq.5;
        Thu, 30 Jul 2020 21:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QQ35CE9yJFKcx/uvB2EsoL6aQNmrJJ39h4x1UksSOeI=;
        b=oCx+OmtDmgcsKf4YV1IAtnHqhz2Y2qhro0Yby9520SONIWBEE4vGbr/7AEmTzsHiaC
         ENPpUWZbkekLE0dIoQ2AMdn4UfxLEDJujY7rHCZGZiPXokRNbo7z2o98NSAidR2AmgQ7
         Ev0s4tZJe85EkW5GeA5nZ2vvC8qa7Ik1jx26X6pNvlgDHab5ALPNAKkj+WxA6PfBMDy+
         4pUAl3GnLEmAq92Jl+ERBx7zpGTO/s2hu/LKEsnpCf2hXEHhkyzaKYsqy9F0FJkmscj9
         +o4ShmPav8WOVhuLbG8RiLpE+uwVVvF25ry4cyuhP0lmp7xwHEGtdyoTSYdZWHwMrfuK
         8UAw==
X-Gm-Message-State: AOAM530q1ohsa0E8RzsK4H2iDp3RM6SIZBb12aBcnuwXbxsTwXq4nCeS
        7DMnmlmfnuvDlHvwaL0aCro=
X-Google-Smtp-Source: ABdhPJzXnGsmXXgO8qRrgHFnZCn5E/++s0JbD0mUM5v850qtfGXGD2zI4A5vvBBtJhqa9flYfth/vQ==
X-Received: by 2002:a17:902:ff13:: with SMTP id f19mr2147996plj.326.1596168404804;
        Thu, 30 Jul 2020 21:06:44 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r8sm8054046pfg.147.2020.07.30.21.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 21:06:43 -0700 (PDT)
Subject: Re: [PATCH v4] scsi: ufs: Cleanup completed request without interrupt
 notification
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <Avri.Altman@wdc.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
References: <20200724140246.19434-1-stanley.chu@mediatek.com>
 <SN6PR04MB4640B5FC06968244DDACB8BEFC720@SN6PR04MB4640.namprd04.prod.outlook.com>
 <1596159018.17247.53.camel@mtkswgap22>
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
Message-ID: <97f1dfb0-41b6-0249-3e82-cae480b0efb6@acm.org>
Date:   Thu, 30 Jul 2020 21:06:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596159018.17247.53.camel@mtkswgap22>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-30 18:30, Stanley Chu wrote:
> On Mon, 2020-07-27 at 11:18 +0000, Avri Altman wrote:
>> Looks good to me.
>> But better wait and see if Bart have any further reservations.
> 
> Would you have any further suggestions?

Today is the first time that I took a look at ufshcd_abort(). The
approach of that function looks wrong to me. This is how I think that a
SCSI LLD abort handler should work:
(1) Serialize against the completion path
(__ufshcd_transfer_req_compl()) such that it cannot happen that the
abort handler and the regular completion path both call
cmd->scsi_done(cmd) at the same time. I'm not sure whether an existing
synchronization object can be used for this purpose or whether a new
synchronization object has to be introduced to serialize scsi_done()
calls from __ufshcd_transfer_req_compl() and ufshcd_abort().
(2) While holding that synchronization object, check whether the SCSI
command is still outstanding. If so, submit a SCSI abort TMR to the device.
(3) If the command has been aborted, call scsi_done() and return
SUCCESS. If aborting failed and the command is still in progress, return
FAILED.

An example is available in srp_abort() in
drivers/infiniband/ulp/srp/ib_srp.c.

Bart.
