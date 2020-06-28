Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C4DC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 03:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA0C20782
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 03:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgF1Di1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 23:38:27 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46851 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgF1Di0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 23:38:26 -0400
Received: by mail-pl1-f193.google.com with SMTP id u9so2163128pls.13
        for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2020 20:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Wd9vc4VWXYQGkLGoi0NfA2Jy3myaAK67U8g7JAkE8UE=;
        b=A+H8Zx4GvfPlgpyCi2bFdY0eKlp1kbqPumqLdWJgYQrFmHCTL2616fvefjWPQTvRSr
         A+DQ0nZYTcW1o7iO3g6g3KZcLwXk9kAC8Hjj0GpzjY9FK8S1z6lPHsInAJtji/5+8Bta
         D5xwj/CpCXf2lI/1faR3deFEiK331xaUaj0ZEGgC4/2PJKn2h1TQzI2x1ohxy2k+Nxne
         grVaJwMWcLaVyNPb49BsH6PIisNF0xeOU7+7yoBdIftbzgEjEGSFfhxBu/I6wSQKZEKy
         eO1XZ+sO91ghZkrQQQ8aD7im/8wWDO6q+buHVmTAeOKhxjeho3jtanr4aEDjI0FjpL+5
         84GA==
X-Gm-Message-State: AOAM530Ax132Gom8BuM64r3Y+qA2r0Ug8jJtUVj6wZF2bxFIsEr8ZFbI
        ETb53aSpFTppcnllUuhNXmqsnSvp
X-Google-Smtp-Source: ABdhPJwFGhADikDbYYr9fS8logR/56K2zrgl4FgV63y2vaVrtBCBsaqueMi2VF7nRkORMJ+qP4xm4A==
X-Received: by 2002:a17:902:7c94:: with SMTP id y20mr8748601pll.38.1593315504655;
        Sat, 27 Jun 2020 20:38:24 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id h9sm14915039pjs.50.2020.06.27.20.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2020 20:38:23 -0700 (PDT)
Subject: Re: [PATCH 01/22] scsi: drop gdth driver
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microchip.de>, linux-scsi@vger.kernel.org
References: <20200625140124.17201-1-hare@suse.de>
 <20200625140124.17201-2-hare@suse.de>
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
Message-ID: <b14a0af1-fafc-5452-f915-46af92a86aed@acm.org>
Date:   Sat, 27 Jun 2020 20:38:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200625140124.17201-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-25 07:01, Hannes Reinecke wrote:
> The gdth driver refers to a SCSI parallel, PCI-only HBA RAID adapter
> which was manufactured by the now-defunct ICP Vortex company, later
> acquired by Adaptec and superseded by the aacraid series of controllers.
> The driver itself would require a major overhaul before any modifications
> can be attempted, but seeing that it's unlikely to have any users left
> it should rather be removed completely.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
