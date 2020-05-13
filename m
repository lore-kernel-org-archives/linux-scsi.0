Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214F0C2D0F8
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 01:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01409206A3
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 01:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbgEMBaA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 21:30:00 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53648 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgEMBaA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2020 21:30:00 -0400
Received: by mail-pj1-f65.google.com with SMTP id hi11so10386115pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2020 18:29:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gwy+lLNoD6gj3sXBHbZwUYAzRLtq9D30HpDSknUytOk=;
        b=FTp1SBhxCqDZoC8cUihvIm4KceYiDuor3r3cFDMSBVxU/2+Fl2L5kqODx2ru+6qyMS
         CcI6H7CdtcJaTQzMhKIARjYW4IBoOF/hREH9WMgLVC7JtnkGbW8z4bg9GF/fqq8dJK3s
         TKYcMjdMRbcvTh1L2HDy1+L3Aae3nQny/TZIZNVVttWEzwzcZQDZb6oRAs+OEv2XEKe/
         6hKQcy1duk6xtw/jb9C6Ni0YFQzw8Bg4BHRj8ed6DiWclI02KmG7OWdpktPIz3+PIEiz
         MkYxEZQE/94y3D2DWjbOoZxXY0d1RIEaxkvYLE2F3hsB1gcmnM/gPLMQrbpTAbVxourG
         5ToA==
X-Gm-Message-State: AOAM530lGfOa2EvVmfkjbadFNpZbkp0FYLKskYvHR99aLCcCiq7F6lS8
        GV3T6ont6RQOA8d8/OeMZtjxijay
X-Google-Smtp-Source: ABdhPJwPY/66PDF/MX9T0jVjg9P9ywKHNz4Z/wRkMroW/6LS11PRhHCDE2ll5u1RAoq0yLR5t3rvoQ==
X-Received: by 2002:a17:902:fe09:: with SMTP id g9mr3829187plj.301.1589333399089;
        Tue, 12 May 2020 18:29:59 -0700 (PDT)
Received: from [192.168.2.13] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j2sm13428661pfb.73.2020.05.12.18.29.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 18:29:58 -0700 (PDT)
Subject: Re: [PATCH v5 00/15] Fix qla2xxx endianness annotations
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
References: <20200511200946.7675-1-bvanassche@acm.org>
 <yq1mu6d14s7.fsf@oracle.com>
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
Message-ID: <091a394c-6ad4-ad72-f1e5-ed6519f81951@acm.org>
Date:   Tue, 12 May 2020 18:29:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <yq1mu6d14s7.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-12 09:44, Martin K. Petersen wrote:
> I in reading v5 I noticed that Arun's reviews were missing from patches
> 1, (2), 3, 5, 7, and 9. Not sure if other v4 review tags were missed.
> Please verify when you repost.

That happened unintentionally. Thanks Martin for having caught this. I
will add Arun's reviewed-by tags when I repost.

Bart.
