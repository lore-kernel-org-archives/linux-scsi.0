Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2587CC47254
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 04:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08F7920857
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 04:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgEAEfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 00:35:51 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35766 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgEAEfv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 00:35:51 -0400
Received: by mail-pj1-f66.google.com with SMTP id ms17so1952294pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2020 21:35:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=To43UBG1e+g8aG6khNbixY4ZfPcP8/r1ESfS+GHESdw=;
        b=UTIMa5x7F/v+G2YzZUFKTr6rufs9051HtKZ/Xfp7lLUApryAx6ga5IbptUS2E5ZN02
         hO35ZAWsaN5hex6l9VnuyN/H7w7G48Ann9lEOAsQSRq5ANbZC2gY3LFHqb4X6Ih2nJ56
         wOmNJRkt8X5g1LXpPLC02xSQiSVG/rTb4WmXt2VPYd2IgILzhaMyrFge4HNaiMQO/sxh
         0vTUaQAZIQ834Fk8c94vMkV7bJrZ2EhcY3FbMa5Git7oVcSVpgZvn8pCQIeiQFjcn5jU
         hI70kFR+p80OznErkHXi7UNoYsvvlAqj3+tqzcefDFUd5MeB+fq5l+6u9EBA9wOZhbq8
         rrHA==
X-Gm-Message-State: AGi0PubV71/hZuZmwGWleMA87BwgqB1fUt9FbooerEMc5QYOKorD3546
        X1FgksImCcf8IoVvUX8oFUw=
X-Google-Smtp-Source: APiQypIw/qn+Lx3WEF4OLo5rnARjH523c2av94Xvc4ZOv22MucXzR1t8G6QYzgJd2NZaLlS/AQxc6g==
X-Received: by 2002:a17:902:8e8b:: with SMTP id bg11mr2479431plb.139.1588307750113;
        Thu, 30 Apr 2020 21:35:50 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6909:5f45:32d1:8e51? ([2601:647:4000:d7:6909:5f45:32d1:8e51])
        by smtp.gmail.com with ESMTPSA id p8sm1039804pjd.10.2020.04.30.21.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 21:35:48 -0700 (PDT)
Subject: Re: [PATCH RFC v3 02/41] scsi: add scsi_{get,put}_reserved_cmd()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-3-hare@suse.de>
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
Message-ID: <831819aa-07b6-ab79-ce08-c6b942510454@acm.org>
Date:   Thu, 30 Apr 2020 21:35:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430131904.5847-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-30 06:18, Hannes Reinecke wrote:
> +/**
> + * scsi_get_reserved_cmd - allocate a SCSI command from reserved tags
> + * @sdev: SCSI device from which to allocate the command
> + * @data_direction: Data direction for the allocated command
> + */
> +struct scsi_cmnd *scsi_get_reserved_cmd(struct scsi_device *sdev,
> +					int data_direction)
> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +
> +	rq = blk_mq_alloc_request(sdev->request_queue,
> +				  data_direction == DMA_TO_DEVICE ?
> +				  REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN | REQ_NOWAIT,
> +				  BLK_MQ_REQ_RESERVED);
> +	if (IS_ERR(rq))
> +		return NULL;
> +	scmd = blk_mq_rq_to_pdu(rq);
> +	scmd->request = rq;
> +	return scmd;
> +}

Isn't REQ_NOWAIT something the caller should decide about instead of
always setting that flag? Additionally, I think some parentheses are
missing. I think the compiler will interpret the blk_mq_alloc_request()
call as follows, which is probably not what was intended:

rq = blk_mq_alloc_request(sdev->request_queue,
		  data_direction == DMA_TO_DEVICE ?
		  REQ_OP_SCSI_OUT : (REQ_OP_SCSI_IN | REQ_NOWAIT),
		  BLK_MQ_REQ_RESERVED);

Thanks,

Bart.
