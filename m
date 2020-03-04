Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EEBC3F2D1
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59EE62146E
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgCDFQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 00:16:36 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:56176 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgCDFQf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 00:16:35 -0500
Received: by mail-pj1-f66.google.com with SMTP id a18so366859pjs.5
        for <linux-scsi@vger.kernel.org>; Tue, 03 Mar 2020 21:16:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZlSKP20zABRXtP4u3qcQLF3qEUmoyIcVNquar/SRGws=;
        b=JHeLtym1/9XHn7tDiiSldAdKNnDgN5cZjHPBbu9nVaw5iB7Xj73iYQ+QovVV51lgOr
         guR7D4ssh1ZgK6/5eZj0JU1uBOK3FlS1pQDMINtUWaeRF8Yk0EI5ya+QRxKrS/V+AfLN
         7SV2YU6Zsx8F1xjCRQzFHLESKrOvPna1+B9oxMR3CszJB76hom7i5UPCfbGFss1zkhkc
         Cny26K8ok7OLJe3z/wS5nfulZs1WJhJnHLxCSdraZuuk9vIe3pyZgjxXwoLhwVO17qPu
         BIz3W6YCYugjppJUAlYoy9IMuVQkMn8Z8hAJlumEkuxkkVOysrpBJ7OTIcHYMf6msS0o
         JDUg==
X-Gm-Message-State: ANhLgQ163vQEtdGVGX0yN31m2PyVUYDBbg7iTFnLUw7ySGO/uC4PC7Ui
        o9pqXK2sqDvzWXVadFfI87w=
X-Google-Smtp-Source: ADFU+vvkTfde/OybSkIIkPZRm3kgFj+M8MtuESZvhW1F9OOP5AWYLILFvuZUud/j8X6rLfFZCkVTKw==
X-Received: by 2002:a17:902:264:: with SMTP id 91mr1471975plc.335.1583298994732;
        Tue, 03 Mar 2020 21:16:34 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:a86e:343d:2eff:fb40? ([2601:647:4000:d7:a86e:343d:2eff:fb40])
        by smtp.gmail.com with ESMTPSA id u7sm25946073pfh.128.2020.03.03.21.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 21:16:33 -0800 (PST)
Subject: Re: [PATCH 3/4] qla2xxx: Fix endianness annotations in source files
To:     Himanshu Madhani <hmadhani@marvell.com>,
        Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200302033023.27718-1-bvanassche@acm.org>
 <20200302033023.27718-4-bvanassche@acm.org>
 <20200302184055.dtjktj4sbsyysk5m@beryllium.lan>
 <08d14c58-d8bb-b0ff-d81b-91373ab6a09c@acm.org>
 <A9F44BB4-8DEF-48FC-BACF-B4AC2A493A54@marvell.com>
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
Message-ID: <73d765c7-4aa5-8dd5-2254-4f2fbcafb294@acm.org>
Date:   Tue, 3 Mar 2020 21:16:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <A9F44BB4-8DEF-48FC-BACF-B4AC2A493A54@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-03 06:10, Himanshu Madhani wrote:
> ﻿On 3/3/20, 12:36 AM, "linux-scsi-owner@vger.kernel.org on behalf of Bart Van Assche" <linux-scsi-owner@vger.kernel.org on behalf of bvanassche@acm.org> wrote:
>     On 2020-03-02 10:40, Daniel Wagner wrote:
>     > Isn't this assuming the host runs in little endian mode? Because later down...
>     
>     My goal was not to change the behavior of the code on x86. Bugs on big
>     endian systems can be fixed later on (my guess is that this driver does
>     not work reliably on big endian), and searching through the code for
>     __force casts probably provides some good starting points.
>     
> We had made sure driver works on big endian system and the reason these were not changed was to make sure it does not break big endian architecture.  It's been a few years since I verified big endian compatibility with the driver, but I am hesitant to go change things without making sure it works on big endian systems. We are taking big risk of blindly changing things. 
> 
> I'll ask our testing folks to test this out and see if we discover issue with these changes. Until then I'll hold off on Accepting changes.

Thanks Himanshu for having offered to test this series. Please use v2 of
this series as the basis for any tests.

Bart.

