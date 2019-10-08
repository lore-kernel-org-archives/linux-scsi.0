Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B30C47404
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 03:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C3920867
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 03:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfJHDUX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 23:20:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33738 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729823AbfJHDUX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 23:20:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so9985148pfl.0
        for <linux-scsi@vger.kernel.org>; Mon, 07 Oct 2019 20:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=cIN3UN48iusGEAVBSNXXUO3i8R7B4XHnoOgXGVjgdvA=;
        b=l8FVD9ou+qZbOCqaLZEryaMO2myJtHyiAiw7B5Wmd2i3gqZ/EC//TeZ1oCI1HpyJrJ
         xdCtULYzmZ2mLY0zSjt0pcqgMmpcTylJl9zccjBGTUpWSBy3YGl8jSoWqPFc5sabPOWO
         WBpiAB7Zy1cDqWS7nAmN3GI1OJ2qgJ0Y4HFmMRhOlOHAJu5UjflUWkbraPuOrDQ+upX6
         zbmu0yE0lKoacDbcwxI8MbZMp1+NxOz8+FtZrmRMA5ptitLMKS/Zc7sbN6n6FysE7Cyc
         Q03HBUoA8Jf3rBZfbPN2f7CqFkNVy586fMoLFVqOO4AqN+hdK87IDP45mspPogNHcS+2
         olUw==
X-Gm-Message-State: APjAAAUNPssFYtaoEbwWmtKI7utMdQTCUnhHIwl03IHxJYF0TSnNcToD
        JHK9Fts+RQvZCVLgU2kgWO2ZJZzzDZ8=
X-Google-Smtp-Source: APXvYqxC8q535pBFU7Gnwusk1YeGbg3EX6jyuzKuFZ1NA/l/1cJWPIibrunlsXlK9YRECE+E2vcTUQ==
X-Received: by 2002:a17:90a:9f94:: with SMTP id o20mr3054607pjp.76.1570504822584;
        Mon, 07 Oct 2019 20:20:22 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d1:6d68:3c1e:fadd:4da7])
        by smtp.gmail.com with ESMTPSA id f128sm20395616pfg.143.2019.10.07.20.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 20:20:21 -0700 (PDT)
Subject: Re: [PATCH V2] scsi: core: avoid host-wide host_busy counter for
 scsi_mq
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191006074432.23993-1-ming.lei@redhat.com>
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
Message-ID: <ae46a16c-3289-dc5c-9e7d-570d4b1de8e0@acm.org>
Date:   Mon, 7 Oct 2019 20:20:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20191006074432.23993-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-06 00:44, Ming Lei wrote:
> +struct scsi_host_mq_in_flight {
> +	int cnt;
> +};

Is this structure useful? Have you considered to use the 'int' datatype
directly and to leave out struct scsi_host_mq_in_flight?

>  /**
>   * scsi_host_busy - Return the host busy counter
>   * @shost:	Pointer to Scsi_Host to inc.
>   **/
>  int scsi_host_busy(struct Scsi_Host *shost)
>  {
> -	return atomic_read(&shost->host_busy);
> +	struct scsi_host_mq_in_flight in_flight = {
> +		.cnt = 0,
> +	};

In case struct scsi_host_mq_in_flight would be retained, have you
considered to use "{ }" to initialize "in_flight"?

> -static void scsi_dec_host_busy(struct Scsi_Host *shost)
> +static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>  {
>  	unsigned long flags;
>  
>  	rcu_read_lock();
> -	atomic_dec(&shost->host_busy);
> +	clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);

If a new state variable would be introduced for SCSI commands, would it
be possible to use non-atomic operations to set and clear
SCMD_STATE_INFLIGHT? In other words, are any of the functions that
modify this bit ever called concurrently?

Thanks,

Bart.
