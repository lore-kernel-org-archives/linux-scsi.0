Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD60C3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 04:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A8D6246B6
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 04:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgCBEc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Mar 2020 23:32:56 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40232 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgCBEc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Mar 2020 23:32:56 -0500
Received: by mail-pg1-f194.google.com with SMTP id t24so4766825pgj.7
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2020 20:32:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7HWLsd1mfXSob5XJkWHd47yl4ghJ0sYkMyHI9pOV8fs=;
        b=TBCPmlhHNsvLqblchXPvuf3Pxnm05u6A7tkUo6whLnEF8i9XXV9ArTJcFMLnBO9lKU
         1YiaU8MuJd6bRcUgTWeITp43/sP+lH0CKOo/TG0rp8M2Jt7ANolGJi0UeMKBrFsGxVpz
         6Ww0l4nigLJbKIx0PDzd+rsjXcAA59JKfC/Z4WpgluZyBUT6tg2oYqhXuqhs/gDNzs/P
         HNQ518p3pylx0T4Doh44nAAX4QdpxwA89NtCVKP5f58BmR7t9ZfFEQ6VosQHmqUevy5R
         4lOVHhjayb2HQzlKDPCBv0jPMMli8CAbm7E2nxeGUTI9UnjUCi+dUEJQqFxYN88+2pE9
         8sEQ==
X-Gm-Message-State: APjAAAWyLBtmX1rjSQZyRzE7H56LCzmZXQMqj5Dk1VhOPUcIobEeKmKr
        mx9349ofdkB6K5kDllBB6sg=
X-Google-Smtp-Source: APXvYqwelXXjYkgfzr/dCyA2z9OKqL1JEh6TKuORyr3BlZmGHxQpbJtJUgV2VV9V3dZujcYifNM0hg==
X-Received: by 2002:a63:be48:: with SMTP id g8mr18049799pgo.23.1583123574487;
        Sun, 01 Mar 2020 20:32:54 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:7869:cc6e:b1f7:9f7d? ([2601:647:4000:d7:7869:cc6e:b1f7:9f7d])
        by smtp.gmail.com with ESMTPSA id x18sm6917256pfo.148.2020.03.01.20.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 20:32:53 -0800 (PST)
Subject: Re: [PATCH] scsi: avoid to fetch scsi host template instance in IO
 path
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200228093346.31213-1-ming.lei@redhat.com>
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
Message-ID: <9c78c7f3-d9eb-a2d4-c155-82d8f0228880@acm.org>
Date:   Sun, 1 Mar 2020 20:32:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200228093346.31213-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-28 01:33, Ming Lei wrote:
> scsi host template struct is quite big, and the following three
> fields are needed in SCSI IO path:
> 
> - queuecommand
> - commit_rqs
> - cmd_size
> 
> Cache them into scsi host intance, so that we can avoid to fetch
> big scsi host template instance in IO path.
> 
> 40% IOPS boost can be observed in my scsi_debug performance test after
> applying this change.
> 
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Cc: Ewan D . Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>

Please use my current email address instead of the above old and no
longer valid email address. See also the .mailmap file. I think I have
asked this before.

> @@ -1148,7 +1148,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>  	in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>  	/* zero out the cmd, except for the embedded scsi_request */
>  	memset((char *)cmd + sizeof(cmd->req), 0,
> -		sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
> +		sizeof(*cmd) - sizeof(cmd->req) + dev->host->cmd_size);
>  
>  	cmd->device = dev;
>  	cmd->sense_buffer = buf;

This patch does not apply on Martin's 5.7/scsi-queue branch. Please rebase.

Thanks,

Bart.
