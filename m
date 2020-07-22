Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01430C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 14:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5AAB20729
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 14:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732289AbgGVOeX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 10:34:23 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33763 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729126AbgGVOeW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 10:34:22 -0400
Received: by mail-pl1-f194.google.com with SMTP id 72so1092733ple.0;
        Wed, 22 Jul 2020 07:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=olKrLD3FRwtkZ/Dw4Hqpm4+UQBoh/02eyIlTjeJF1dk=;
        b=JiKlmLn/jf91zoAaIxr7JSN0DmiU9gc9gwZMnHxACgLfXv0vth3umAqU5cE4ecAroP
         3svfz4QTdLE/rqMYwa/Xcuxz9TDWfSEHg17lIQHNDsUNj+OwJ1Rd4sac+tIlHiFalBW+
         zdp6P5dxNtV2MEPTmedCIe8b/+FEVS93otiKia7mNLHyTVSo46vK+97/HxTrsRuNk81q
         tgte3eaU7ehi8oc+jnO/Q47UGjCJckvn1yPzl2zIJOIqpiCXnJQL+jWcIjzFvMWil69a
         QJ1+iXLueVWKHkIlF2UAPExDhbMc92vylU/mrIy3EMEWe76aGMEkQf5Lz3R4wBFyl0bc
         1h3w==
X-Gm-Message-State: AOAM533XdZnQYKqVP6Ap+PwahJ/GQd+A+dV1HcY854LeZl6Dvel4xxvH
        K0x9WOYFEf0FLv/01asxJ6y3Pgvy
X-Google-Smtp-Source: ABdhPJydE/TJasl0eqOP5U2VciAInRMFITo2w5Ae7PmE+wtbdFvdQ+tc3UvyUPr5zBqjY+EhT8Y77A==
X-Received: by 2002:a17:902:6947:: with SMTP id k7mr27691748plt.64.1595428461122;
        Wed, 22 Jul 2020 07:34:21 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n18sm65855pfd.99.2020.07.22.07.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 07:34:19 -0700 (PDT)
Subject: Re: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
 <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
 <20200722063937.GA21117@infradead.org> <yq1blk7g1jd.fsf@ca-mkp.ca.oracle.com>
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
Message-ID: <182631f8-5821-ae50-142b-fbe224d5066a@acm.org>
Date:   Wed, 22 Jul 2020 07:34:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <yq1blk7g1jd.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-22 06:27, Martin K. Petersen wrote:
> Christoph Hellwig wrote:
>> As this monster seems to come back again and again let me re-iterate
>> my statement:
>>
>> I do not think Linux should support a broken standards extensions that
>> creates a huge share state between the Linux initiator and the target
>> device like this with all its associated problems.
> 
> I spent a couple of hours looking at this series again last night. And
> while the code has improved, I do remain concerned about the general
> concept.
> 
> I understand how caching the FTL in host memory can improve performance
> from a theoretical perspective. However, I am not sure how much a
> difference this is going to make outside of synthetic benchmarks. What
> are the workloads that keep reading the same blocks from media? Or does
> the performance improvement exclusively come from the second order
> pre-fetching effect for larger I/Os? If so, why is the device's internal
> L2P SRAM cache ineffective at handling that case?

Hi Martin,

These are great questions. The size of the L2P table is proportional to
the device capacity and device capacities keep increasing. My
understanding is that on-device SRAM is much more expensive than (host)
DRAM. Caching the L2P table in host memory allows to keep the (UFS)
device cost low. The Samsung HPB paper explains this as follows: "Mobile
storage devices typically have RAM with constrained size, thus lack in
memory to keep the whole mapping table."

This is not an entirely new approach. The L2P table of the Fusion-io
PCIe SSD adapters that were introduced more than ten years ago was
entirely kept in host DRAM. The manual of that device documented how
much memory the Fusion-io driver needed for the L2P table.

This issue is not unique to UFS devices. My understanding is that DRAM
cost is a significant part of the cost of enterprise and consumer SSD
devices. SSD manufacturers are also interested in solutions to reduce
the amount of DRAM inside SSDs. One possible solution, namely paging the
L2P table, has a significant disadvantage, namely that it doubles the
number of media accesses for random I/O with a small transfer size.

The performance benefit of HPB comes from significantly reducing the
number of media accesses in case of random I/O.

I am not claiming that HPB is a perfect solution. But I wouldn't be
surprised if enterprise SSD vendors would start looking into a similar
solution sooner or later.

Bart.
