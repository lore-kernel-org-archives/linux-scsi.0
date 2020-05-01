Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5E5C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 04:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3205C208CA
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 04:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgEAEtH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 00:49:07 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53016 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbgEAEtH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 00:49:07 -0400
Received: by mail-pj1-f65.google.com with SMTP id a5so1911634pjh.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2020 21:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/bdPUZDycEkQ7pzVjUY0XHefCzfgRSw4vWWSmFPQ54Q=;
        b=C2r6yA0EtpsxiTy5it+JUSGnGuOsPNMO3m/7wRFqP0lt+eTVvBSDTAE1Gp55REtSgB
         nyOpKfj4fJPBd8OxS3tZEDzHlp8/toxml4QyJfULk48r5/5WqTXk5vTxSgkbbA2H7qTB
         JNfMoxCKh3LDgaS1eaEusUeltfrn5hIdMxkdkWuYEC8YwmuqTcaI7comVF2sLKJmOHVq
         u1B1KNgJMzHy+PBT9m1mI8O0HbSF2PQOHgPwQY1PWsIs8GrTCWZZ/mimqTI6o7YR4OHK
         sZv8Gx0clF8wNTOybST88aCHYzOFMpePVplw9zNkY/wUkLGGOSeerOWGiy4y9INa5tqa
         iNQg==
X-Gm-Message-State: AGi0PubbmlvYrAOGXIAu+KPxfTgVooN6W4H44YNyezLYigm9OhtkTf6B
        Zc7UI50w5EPqZoOxAAzpiX8s3OBoyP4=
X-Google-Smtp-Source: APiQypL/wflykaVP69QsGX/eltr+Qm9khPyLs5WFcYGZvh/cWry2USUoj5pElwkiwuXQPpVhd751JQ==
X-Received: by 2002:a17:90a:246e:: with SMTP id h101mr2671259pje.83.1588308546087;
        Thu, 30 Apr 2020 21:49:06 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6909:5f45:32d1:8e51? ([2601:647:4000:d7:6909:5f45:32d1:8e51])
        by smtp.gmail.com with ESMTPSA id f70sm1171958pfa.17.2020.04.30.21.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 21:49:05 -0700 (PDT)
Subject: Re: [PATCH RFC v3 10/41] scsi: make host device a first-class citizen
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-11-hare@suse.de>
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
Message-ID: <e0f8cf98-62d0-02ee-4585-5159a48764ce@acm.org>
Date:   Thu, 30 Apr 2020 21:49:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430131904.5847-11-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-30 06:18, Hannes Reinecke wrote:
> Rather than having the device created by scsi_get_host_dev() as
> a weird semi-initialized device make it a first class citizen by
> implementing a minimal command emulation and provide (static)
> inquiry data.

It may be worth mentioning in the commit message that gdth and sierra_ms
are the only two drivers that create a "host device".

Thanks,

Bart.
