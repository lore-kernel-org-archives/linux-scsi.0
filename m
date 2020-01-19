Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE2F8C33CB7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 20:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EA832072B
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 20:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgASU2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 15:28:20 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:56106 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbgASU2T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 15:28:19 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so5711240pjz.5;
        Sun, 19 Jan 2020 12:28:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ScV8TT0psX6XqKz+WSfUevTG8vITLJzq/ItAqBlsDcQ=;
        b=r6zzeyq9Xj91on+T/JBzTCy32x7pLCB/YqNTjalCNI0hfo0ASmAdM6wQjhwww2qo+8
         0oOe5Q3i4zRlhhhghpZyWoQ5ILT3lpbthLuMPEiNgTSx3Zhoh/P4AOPkHHKrnuKIj5Ag
         74Nmfrx0LWLYbonSWX2fc+nkbyjoEdxi0VC4I3XijqHtNAaiiU201v8+FQw3qkny6rND
         L57/T0xFQKcZLSSzL3eY5fymleOhHeM0tiZCEb3mB7uo5Y2GKHO08OGl0ezrxx/5Qcda
         5Fn1Ylu0nuVeYSI2R3j65OZu4oC/u4ZNnIgMIXWAp6BDznzZj5Vo7BSbNfaJhKUKS3Uy
         hirw==
X-Gm-Message-State: APjAAAWUgvVvjST7R/V5ojEFDK2aqHqSwYQMHTucawr6FBT47qpxNmLj
        lox/zpOy5/8e5w/U6SmkWbU=
X-Google-Smtp-Source: APXvYqzgxdFgl/hLWIjdcBLn5skfTcha2TGtV+PJrjYoed5scybfpAx568yx2RcT1rToIuB49v7IhQ==
X-Received: by 2002:a17:902:34d:: with SMTP id 71mr11229916pld.140.1579465699096;
        Sun, 19 Jan 2020 12:28:19 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:781f:ca33:6085:f83a? ([2601:647:4000:d7:781f:ca33:6085:f83a])
        by smtp.gmail.com with ESMTPSA id u11sm305557pjn.2.2020.01.19.12.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 12:28:18 -0800 (PST)
Subject: Re: [PATCH 1/6] scsi: mpt3sas: don't use .device_busy in device reset
 routine
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20200119071432.18558-1-ming.lei@redhat.com>
 <20200119071432.18558-2-ming.lei@redhat.com>
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
Message-ID: <05bf3d98-6c40-0bb2-4bf7-721d98f6c7dc@acm.org>
Date:   Sun, 19 Jan 2020 12:28:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200119071432.18558-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-18 23:14, Ming Lei wrote:
> Cc: Bart Van Assche <bart.vanassche@wdc.com>

As one can see in the .mailmap file in the kernel tree I use my @acm.org
email address for kernel contributions. The above email address is no
longer valid since I left WDC more than a year ago. This is something I
have mentioned before. See also
https://lore.kernel.org/linux-scsi/55c68a97-4393-fa63-e2da-d41a48237f96@acm.org/

> +static bool scsi_device_check_in_flight(struct request *rq, void *data,
> +				      bool reserved)
> +{
> +	struct device_busy *busy = data;
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
> +
> +	if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state) && cmd->device ==
> +			busy->dev)
> +		(busy->cnt)++;
> +
> +	return true;
> +}

scsi_host_check_in_flight() is almost identical to the above function.
Has it been considered to merge these two functions into a single
function? Same comment for scsi_host_busy() and scsih_dev_busy().

Thanks,

Bart.
