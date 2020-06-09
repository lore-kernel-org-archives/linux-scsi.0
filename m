Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B78C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 01:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC6520801
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 01:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgFIBPV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 21:15:21 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39638 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgFIBPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 21:15:18 -0400
Received: by mail-pj1-f67.google.com with SMTP id h95so626221pje.4;
        Mon, 08 Jun 2020 18:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VJx+ai5rJx6AVd1EhExoPYJWsUcdY4VOIKvvMPbs6xQ=;
        b=Ly03LunStsL5+TLmuQrlqDlzpULngjZdo/ppfvlptKaBNsAi3Q2cNUnkWqBHQI+VtE
         zKV1PrMMa0PEnw7dPOqcy3DmJla+lEP1dg9xFYCsMEaC4ADqnbtZjOsTYzRb/68yLVeo
         TeUrI37f6Uj4o0QTBDteE0SqmopKvgWktBPo5hQctSSXuF9SD2Fbn9Nb3m0EW5pYuhgo
         N2jLNaCn3C4ilpc5nKv4Dhl453jHnqwlNaW8cBkEVWClrLTjyJ6sxGtiD+gGbrQr/hSE
         oVEECfbLD5PLqbnsPDanLL2xKMXG2KvLK3vDg1JM3s3ug2mZkrOssrNr8M26kb8hJork
         8Uxg==
X-Gm-Message-State: AOAM530ShUSFWl6rmFQ4WH3FwM4Et3jBe+EKOmV6N2ofxC807EW1446E
        gyJh8YcjHys1GF8Zf3I+bC0=
X-Google-Smtp-Source: ABdhPJw5AgerJKnBy/yDFJwpbj2ST94fB9icYYME+5O2bN6M0Kca4s01Y2ISkgE5ynmbqScBSMAQuw==
X-Received: by 2002:a17:90a:3608:: with SMTP id s8mr1907958pjb.167.1591665317520;
        Mon, 08 Jun 2020 18:15:17 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id np5sm649345pjb.43.2020.06.08.18.15.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 18:15:16 -0700 (PDT)
Subject: Re: [RFC PATCH 4/5] scsi: ufs: L2P map management for HPB read
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
 <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
 <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
 <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
 <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p2>
 <963815509.21591323002276.JavaMail.epsvc@epcpadp1>
 <SN6PR04MB46409E16CCF95A0AA9FFE944FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
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
Message-ID: <03c44832-57e2-d4c4-ece2-06b59bec550f@acm.org>
Date:   Mon, 8 Jun 2020 18:15:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB46409E16CCF95A0AA9FFE944FC870@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-06 11:26, Avri Altman wrote:
>> +       data_seg_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2)
>> +               & MASK_RSP_UPIU_DATA_SEG_LEN;
> get_unaligned instead of be32_to_cpu ?

Since sparse checks that the argument of be32_to_cpu() has type __be32
and since no such check is performed for get_unaligned_*(), please keep
the be32_to_cpu().

Thanks,

Bart.
