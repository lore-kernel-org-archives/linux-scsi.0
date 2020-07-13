Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51196C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 01:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38EE22070B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 01:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgGMBI0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 21:08:26 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42302 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgGMBI0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jul 2020 21:08:26 -0400
Received: by mail-pl1-f195.google.com with SMTP id q17so4753473pls.9;
        Sun, 12 Jul 2020 18:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZSKvScJU+wbuSvVor07f0hETNMOnHQlWZsghH5yIHi4=;
        b=T5jqAsF61TG4b/FpbPk12Csb6JLPJF9C/FP8/PjiVbmlU58w9UM3XqB0RHSr/wqBWT
         EfMjpsT0Vhe/2qNY8MNZw3eoTxRlZ0AJEjj0iK0A7GbEpN28VGhwEexWVmz9vvkPlzU2
         Odq435722CgCKRsyr9wJ5aptPXlBioF3MoUPXD7oCTGU6Dr865hG97RNL1kbagbXuqu1
         H2aqsElPRD0lkGUrpCpjiIstTvQLVxLmfCzMXp1ndwfaISax7KyXZYvlRRL3JKpHfMtW
         gM15EYL0P7Y5P5fwrDJQo6jhLVFDW9oPupeIYV/3Ckke+AUjBkG+9ZLfQI4LWGv12yJz
         pyjA==
X-Gm-Message-State: AOAM532Y41Co3zFXFXTEF/+Bd798HOppvv8cfQO3f3NjumUM/VOS+bZ4
        wEAfefC0wozId52gKfeTfPI=
X-Google-Smtp-Source: ABdhPJwvzj8rQ8Y4AlJ4uAaleA/uPu73kNt5y61o1YMnm2fhpdMwIlLWQJSvX+ykqklyX2Bofq8ztw==
X-Received: by 2002:a17:90a:fd12:: with SMTP id cv18mr18217848pjb.66.1594602505362;
        Sun, 12 Jul 2020 18:08:25 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id ng12sm13090491pjb.15.2020.07.12.18.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 18:08:24 -0700 (PDT)
Subject: Re: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <SN6PR04MB464097E646395C000C2DCAC3FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
 <963815509.21593732182531.JavaMail.epsvc@epcpadp2>
 <231786897.01594251001808.JavaMail.epsvc@epcpadp1>
 <CGME20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4@epcms2p4>
 <336371513.41594280882718.JavaMail.epsvc@epcpadp2>
 <SN6PR04MB464021F98E8EDF7C79D6CB4FFC640@SN6PR04MB4640.namprd04.prod.outlook.com>
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
Message-ID: <91dcecde-dd0d-c930-7c45-56ba144e748c@acm.org>
Date:   Sun, 12 Jul 2020 18:08:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB464021F98E8EDF7C79D6CB4FFC640@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-09 01:40, Avri Altman wrote:
> Bart - how do you want to proceed?

Hi Avri and Daejun,

As far as I can see none of the five patches have Reviewed-by tags yet. I
think that Martin expects formal reviews for this patch series from one or
more reviewers who are not colleagues of the author of this patch series.

Note: recently I have been more busy than usual, hence the delayed reply.

Bart.
