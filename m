Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8288C33CA9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 00:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79B9821556
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 00:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387535AbgAMAuK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 19:50:10 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36982 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387502AbgAMAuK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2020 19:50:10 -0500
Received: by mail-pl1-f194.google.com with SMTP id c23so3153866plz.4
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2020 16:50:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aeLwC8cl/F6Mq4Cq5wFCOiiRnYqOTEmemdNcxsnEy1E=;
        b=USHs9hcUAX3SxlBZ9tfOnahAexb0V4G8GTXoPavOfX7hHKL/WibcLO5erL85qyHrE/
         I1QItHpWWP6OfILVH+ALpFkNe1YeZJRTpUIUQpwBVsRNGEp55bh406AVIoxJJj3lm2Oj
         tRd+dM8z9UE2Yhry2rnEHg2csSok70s7xkdcSmdPIFIlq+2GKEkWU/ZXuIE80mM1cIa8
         KXvjeLhV9LN6u7Zw5gfRfr71p2GAK11NrRPQ3uCvYcINZYZRuTJ02XCSoDyvJRXBiWuc
         20OUkjTnobStdXOa0NTkYXP5tUNzS0VuS/o69gZZYpFd1sQEg+edhTJ2Euhh9M9jAr5a
         LvkQ==
X-Gm-Message-State: APjAAAWYHkRWZT+8dnKwdlo6fRo07FMPI5vZYkrRAEC/mdnOVhALby3I
        3Z5G8N8KgcF+qPX9KPdBuxI=
X-Google-Smtp-Source: APXvYqwKl3Q9Vs1WtWEuoTMAVmQsGw/jTf7VbMtBduySWTl+tdK5B9yZkwr5qo7B7/B6eSSAsMkRNw==
X-Received: by 2002:a17:902:12d:: with SMTP id 42mr11353739plb.246.1578876609006;
        Sun, 12 Jan 2020 16:50:09 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:68ce:22b2:7e75:c452? ([2601:647:4000:d7:68ce:22b2:7e75:c452])
        by smtp.gmail.com with ESMTPSA id t63sm11524963pfb.70.2020.01.12.16.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2020 16:50:08 -0800 (PST)
Subject: Re: [PATCH v6 31/37] sg: add sg_iosubmit_v3 and sg_ioreceive_v3
 ioctls
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Christoph Hellwig <hch@lst.de>
References: <20200112235755.14197-1-dgilbert@interlog.com>
 <20200112235755.14197-32-dgilbert@interlog.com>
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
Message-ID: <b17072fb-e8c3-6425-1876-5c2aa51a1641@acm.org>
Date:   Sun, 12 Jan 2020 16:50:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200112235755.14197-32-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-12 15:57, Douglas Gilbert wrote:
> Add ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3). These ioctls
> are meant to be (almost) drop-in replacements for the write()/read()
> async version 3 interface. They only accept the version 3 interface.
> 
> See the webpage at: http://sg.danny.cz/sg/sg_v40.html
> specifically the table in the section titled: "13 SG interface
> support changes".
> 
> If sgv3 is a struct sg_io_hdr object, suitably configured, then
>     res = write(sg_fd, &sgv3, sizeof(sgv3));
> and
>     res = ioctl(sg_fd, SG_IOSUBMIT_V3, &sgv3);
> are equivalent. Dito for read() and ioctl(SG_IORECEIVE_V3).

The Linux kernel already supports several interfaces for submitting I/O
requests asynchronously, e.g. libaio and io_uring. Do we really need yet
another interface for submitting I/O requests? Has it been considered to
add SG I/O support to one of the existing asynchronous I/O request
interfaces?

Thanks,

Bart.
