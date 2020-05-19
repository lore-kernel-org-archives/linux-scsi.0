Return-Path: <SRS0=JQ6K=7B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B041C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 16:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FAA72075F
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 16:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgESQRP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 12:17:15 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54940 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgESQRO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 12:17:14 -0400
Received: by mail-pj1-f67.google.com with SMTP id s69so1590061pjb.4
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2020 09:17:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5SkbYNxREuBr8T0lplzWfPJE4TZ07I4+R9g1Rw+1Vy0=;
        b=tbRGGK970jgUabJWVGWEtFfX38BpsznQRSSelCjnQs3BKPvX7lWh7wiPd0WE7pMZH4
         Jz4g0AdgF79XZLYPeIWlZNOG69J4t+vzDPgUpCBy9VzkSmeV7QHzZab0qjKcO1Lk8u1T
         PCl3mhJgNkSxT7jENnlUn7Qfa4UpfTP1n5I3LyIyZ+Kp2pTwuHeAe9THomSRWsOhF1GM
         uZn/7oKwT0BhAga3+Ya0cJpHTaz2LwozZsjoLDTa7JhkcOJeUYEgwvAFa2TK8A7yaORg
         iJ9fXAAGG9W8FbIql0Hz3R4HQfvQmyVa1qheOHuSd4fz8aEHJWbtJpeWCewPQJZqMFSz
         vLOw==
X-Gm-Message-State: AOAM531jOEG8Q251ZMJW0PUrxb6e/qu/RfSnL5HhMFREQcZ4U00pbd0t
        YYtR9x61n6jsKHD0I50Lq00=
X-Google-Smtp-Source: ABdhPJw2T3JvMRzRLeQnPyz87/RDX6fGiijFiQMbEJk6YZZ6NoJeEVYl6bCBy3bqSy4eIJ5uPx8RYA==
X-Received: by 2002:a17:90b:1081:: with SMTP id gj1mr368727pjb.6.1589905034070;
        Tue, 19 May 2020 09:17:14 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:a402:5dc4:a04b:e81f? ([2601:647:4000:d7:a402:5dc4:a04b:e81f])
        by smtp.gmail.com with ESMTPSA id e13sm6775pfh.19.2020.05.19.09.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 09:17:13 -0700 (PDT)
Subject: Re: [PATCH v6 15/15] qla2xxx: Fix endianness annotations in source
 files
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-16-bvanassche@acm.org>
 <20200515094401.lvdsr7q4m7j26ze6@beryllium.lan>
 <4dbf62ef-b7ce-f602-629a-c422cc89005d@acm.org>
 <20200519152756.swpazvzbtrrrzsgc@beryllium.lan>
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
Message-ID: <ddc0d726-f182-96a5-35bd-a3a90c74c393@acm.org>
Date:   Tue, 19 May 2020 09:17:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200519152756.swpazvzbtrrrzsgc@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-19 08:27, Daniel Wagner wrote:
> On Mon, May 18, 2020 at 02:13:53PM -0700, Bart Van Assche wrote:
>> On 2020-05-15 02:44, Daniel Wagner wrote:
>>> I try to give the whole series a spin on our system next week.
>>
>> That would be welcome. v7 of this patch series is available at
>> https://github.com/bvanassche/linux/tree/qla2xxx-for-next.
> 
> I gave this a spin on one of our machines with a QLE2742. Seems to
> work fine and there was not obvious problem.

Thank you for having done this testing work!

Bart.
