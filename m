Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB0CC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 18:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C249221E3
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 18:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgHFSjn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 14:39:43 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40144 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgHFSjR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 14:39:17 -0400
Received: by mail-pg1-f196.google.com with SMTP id h12so792020pgm.7;
        Thu, 06 Aug 2020 11:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AvhBChDNTPymYmm5n2siH1WepfqMKnpgUYkWosLF0Wo=;
        b=mn7vCvhSrlbvCGTNWAMydZ/L2dtQYuoiWHV1DfZGGXxz9eoXW6gJqACbnSuL4qpdnB
         SWkY6SH2lnJVWlIUWokITr5voXLAaBGzd3rQkUAfu3zVeF3C3FEQvkX7I7LKP0B1Z8ff
         QbrQDhQQk1WHk2wnCMK19RilxYfUyJ6yWMNvirlgKNzYbytiUvMFqt4WvtJaLsJlzSQv
         gdLehkcDzsc1EK5k1upEz2h/h3fwRIAzq/T0OBoMsgSUhqTSLl2kJaFJveTZaQPr2cQG
         eKndiePHArIfGO3QXnsCyuFcJ7cWXup6cs8+9hfPCCTuBn5ZpWHvzu0CuaYAMdOFUThF
         WPVA==
X-Gm-Message-State: AOAM530PNPPj5nKYKuFwMooD9j+c4KSEGokyWqr7zUS1LqHW7ov0gzam
        iDssrpW8vfZaJUaMDBQW98U=
X-Google-Smtp-Source: ABdhPJznYbebF/HhoXOXhYSsvhrUY3CyTTZgMhlaY1IgfxjNny6VU0KYLjHGlSS6n6rVM5Qi/GO7hw==
X-Received: by 2002:a65:5c4d:: with SMTP id v13mr8195277pgr.6.1596739156798;
        Thu, 06 Aug 2020 11:39:16 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y4sm7763803pgb.16.2020.08.06.11.39.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 11:39:15 -0700 (PDT)
Subject: Re: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        'Avri Altman' <Avri.Altman@wdc.com>,
        'Bean Huo' <huobean@gmail.com>, daejun7.park@samsung.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, beanhuo@micron.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        tomas.winkler@intel.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        'Sang-yoon Oh' <sangyoon.oh@samsung.com>,
        'Sung-Jun Park' <sungjun07.park@samsung.com>,
        'yongmyung lee' <ymhungry.lee@samsung.com>,
        'Jinyoung CHOI' <j-young.choi@samsung.com>,
        'Adel Choi' <adel.choi@samsung.com>,
        'BoRam Shin' <boram.shin@samsung.com>
References: <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
 <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
 <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
 <SN6PR04MB4640CE297AAB3CF4D37EE002FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
 <39c546268abead68f4c00f17dc47c1597f3e0273.camel@gmail.com>
 <SN6PR04MB4640210D586CBA053F56DCF0FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
 <e3aba7fba7c208ac58c638139bd615c871d2e52e.camel@gmail.com>
 <SN6PR04MB464069DD70022FC3C55265B6FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
 <000001d66c0f$ce9615a0$6bc240e0$@samsung.com>
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
Message-ID: <8a43e89b-f3b8-2a48-7cd2-36f659da21c2@acm.org>
Date:   Thu, 6 Aug 2020 11:39:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000001d66c0f$ce9615a0$6bc240e0$@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-06 09:36, Alim Akhtar wrote:
> V8 has removed the "UFS feature layer" which was  the main topic of discussion. What else we thing is blocking this to be in mainline?
> Bart / Martin, any thought?

Thank you for having posted a version with the UFS feature layer removed. I
will try to find some time this weekend to review version 8 of this patch
series.

Bart.
