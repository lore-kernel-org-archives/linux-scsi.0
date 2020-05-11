Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D41C54E8D
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 15:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF4DF206D7
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 15:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbgEKPzh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 11:55:37 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34163 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgEKPzh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 11:55:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id x15so4339350pfa.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 08:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DP0sKd/2EJmC4Ml1rgJpamPd3rxwoBsv1lAesgQp6aI=;
        b=eFwtqjYX3fkduW4/nvRLY12l9rV4DchgXBe2iQwxVlqsY0ohxVIxXy7W8+cbkBHNa7
         b8PsuNdJngc15OLnvFWYChaY+5f+uDtfEdVXsxzeBv1ezpud2/SnZX2K5N7/DqDMPgrF
         SdP0AwXQTCeyl/pm6wByy3iqGGy8qdj5JQtkRU716YmFbUELLBLsYLRB15wsta458T9J
         wHWa+EdQH6b9dMh73RC5sodE9LrvEVltjfsVkfzcWnaJO0PbbpToB6i+HV0BqSnaLoPd
         t7kHsBfI01F5CVVvNrAa2kQpOmCllTIo451gEykA/WEjzWdMOFMP/JR5pmBoR//2kw5G
         KgMA==
X-Gm-Message-State: AGi0PuatbhCjIbU+rtz8jQ/Lbz1B+Bs7IPMcAkLh3VyJYTNCjg8mSBPI
        G8XiVSY0KrZvSSEWaNja+QE=
X-Google-Smtp-Source: APiQypJ387LXAq4DtaDREbSBu4Ogg/ilodq8Q0CYdQZo97JObOlY4Yy/pyIKG+Qvqsli9dV6x/ew0w==
X-Received: by 2002:a63:6747:: with SMTP id b68mr15437629pgc.142.1589212535969;
        Mon, 11 May 2020 08:55:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:c4e5:b27b:830d:5d6e? ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id y29sm9810339pfq.162.2020.05.11.08.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 08:55:35 -0700 (PDT)
Subject: Re: [PATCH v4 04/11] qla2xxx: Add more BUILD_BUG_ON() statements
To:     Arun Easi <aeasi@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-5-bvanassche@acm.org>
 <alpine.LRH.2.21.9999.2005110032540.23618@irv1user01.caveonetworks.com>
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
Message-ID: <27074fb3-b237-4a53-9667-7550b5bb5249@acm.org>
Date:   Mon, 11 May 2020 08:55:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.9999.2005110032540.23618@irv1user01.caveonetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-11 00:34, Arun Easi wrote:
> How did you pick the list of structures for this one? IOCB
> structures make sense, but why "ct_sns_req", for e.g.? Adding
> support for a different request may alter the structure size.
> 
> Wondering what made you add all these checks? Anything tripped
> while making some changes?

Hi Arun,

For this patch I selected all data structures that have one or more
little endian or big endian members. Such data structures either are
used to interface with the firmware or represent FC frame information. I
agree that struct ct_sns_req is special. I will leave the size check for
that data structure out when I repost this patch series.

Bart.


