Return-Path: <SRS0=cDh3=35=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5CDC352A4
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Feb 2020 05:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 283E3214DB
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Feb 2020 05:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgBIFOW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Feb 2020 00:14:22 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36356 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgBIFOW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Feb 2020 00:14:22 -0500
Received: by mail-pf1-f194.google.com with SMTP id 185so1956760pfv.3;
        Sat, 08 Feb 2020 21:14:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QSSDIxXJOtrm87mRVxM9M1DtFNd4mrS+RkoQsTsZZUI=;
        b=GxXC+k4wuvjd44jLsHoNwiQJE6v9D1o/nARBwfIf+4cdx1ISn17+Ji0DZ4WyJ4ZJsp
         CRoAV7B1PlvDd9PV7yRB66Rf6MzDdEHVlNhJPgrSyFooHbj4ZD5naEALhZ/Fe8x8+t7y
         DB84rsexFXleB8OPCvIPvBtZTNwCx/wJ9pBEOMILDb1blwxmUx5DdP4deT+0lKMXoY3z
         +vaUvGPonfIa0uuG2ciHvcLt9eP+qn52sqoowqzmFknwCCnNOh0/Vjdxf63ziYDt01z2
         IpgqX/Nomoe22oSZ+l7+aJ8B21l4en5tiiY6xukiwKmieKb+yefMkMtbX0WEKtrUh3NG
         vRiw==
X-Gm-Message-State: APjAAAWM9x9FRYQDl9rOlgpzELDAWNA1DRQkTBYsjGgCkoKgMAXesmta
        OMUqoNqp5fjw/DhYfFI3g6oCrd33xug=
X-Google-Smtp-Source: APXvYqyTqO0CuKH66sOs0Gs/iFlI/HDjDdarGHwHQJuY9NQNP7Ntb4atcou2BwYRE1FVVPFGWHUSrw==
X-Received: by 2002:a63:9251:: with SMTP id s17mr7603481pgn.127.1581225261130;
        Sat, 08 Feb 2020 21:14:21 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:9861:6885:e623:b9b? ([2601:647:4000:d7:9861:6885:e623:b9b])
        by smtp.gmail.com with ESMTPSA id b5sm7718407pfb.179.2020.02.08.21.14.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 21:14:20 -0800 (PST)
Subject: Re: [LIO-target] BUG: Deleting a LUN hangs in transport_clear_lun_ref
To:     Pavel Zakharov <pavel.zakharov@delphix.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <9A92D656-A796-4858-85CD-3750BDACFA28@delphix.com>
 <a1291c13-628f-edf3-3778-56b25f02edaf@acm.org>
 <2B6C1870-457C-4754-8E1A-ECBBDFD07083@delphix.com>
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
Message-ID: <c8f4816c-8cb5-04ab-f992-e137ea9b4a56@acm.org>
Date:   Sat, 8 Feb 2020 21:14:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2B6C1870-457C-4754-8E1A-ECBBDFD07083@delphix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-08 18:43, Pavel Zakharov wrote:
> Hi Bart,
> 
> I’ve built linux-stable, commit f757165705e92db62f85a1ad287e9251d1f2cd82 and could easily reproduce the issue.
> I’ve rebuilt the kernel with patch 83f85b8ec305be9d65284de2921d8eeb6c7fcf12 reverted and that seems to fix the issue.

Hi Pavel,

Thanks for having run these tests. I will post a revert of commit
83f85b8ec305.

Bart.
