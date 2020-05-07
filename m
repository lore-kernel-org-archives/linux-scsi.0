Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29839C38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 15:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EF742082E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 15:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgEGP0J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 11:26:09 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:42422 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgEGP0J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 11:26:09 -0400
Received: by mail-pg1-f173.google.com with SMTP id n11so2637725pgl.9
        for <linux-scsi@vger.kernel.org>; Thu, 07 May 2020 08:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AEETiEBUw4pUXT7g/pwmwKpSZoy+QrekaScjtjsdDNs=;
        b=uSINnphWtG8z5AQc7240hM0lGyuHp5c8LU9jAkEe2cf40aw8ggBH2IW2UZJscp4GvI
         RocW9rgMPJO5X5l6BxWDUGovua5Fs3eB+L7Ohkv6HZhLphuKnoDFc5bNK6nDYjsSRiKw
         vbDKcRiw5aYjfmY5lc0UsMSxo3AW2rkSO697hJWC+9/HOUtWiOylQcu81ACch5y+x662
         liCzUOnJnYD9N4RTLzXwkKdN5aAGfnfeLdNdeIZmZ5Uc2aVSYUh3S+id1M2VZWBX2XvA
         B5b3WhenaB0Ij3HOk81vwCHmsQkK7Vplm91+6Iu64I1Matfd+m9wTCHho+MPw3faCxH0
         MIPw==
X-Gm-Message-State: AGi0PuYUVv7qlYGJETr4BXnejskXIF8ki2YjLqD7t8xzV3OwKmTVdRf+
        XRlbS48ObBezgSXbJt3RHFdIw3oaUhY=
X-Google-Smtp-Source: APiQypLaw0AM7GujdDOSoUHfuFF44GI21JgwiT1gRaiuAieGUoPhCU8/qlzJwqmTXXnGYj2xCresXg==
X-Received: by 2002:a05:6a00:d:: with SMTP id h13mr14715724pfk.254.1588865166718;
        Thu, 07 May 2020 08:26:06 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8ce8:d4c:1f4f:21e0? ([2601:647:4000:d7:8ce8:d4c:1f4f:21e0])
        by smtp.gmail.com with ESMTPSA id i25sm5068709pfo.196.2020.05.07.08.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 08:26:05 -0700 (PDT)
Subject: Re: [PATCH] scsi: remove 'list' entry from struct scsi_cmnd
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200507062642.100612-1-hare@suse.de>
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
Message-ID: <1ca6052e-10c7-cb7b-968e-26289ddb4e59@acm.org>
Date:   Thu, 7 May 2020 08:26:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507062642.100612-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-06 23:26, Hannes Reinecke wrote:
> Leftover from commandlist removal.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
