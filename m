Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804B0C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 04:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6456920857
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 04:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgEAEiz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 00:38:55 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35848 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgEAEiy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 00:38:54 -0400
Received: by mail-pg1-f196.google.com with SMTP id o185so4087641pgo.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2020 21:38:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=afkKFlXi4Qsp2AmUrnWaOqqvjZ+f8MEjCPC/KELS274=;
        b=IvukC4od001/Z1QczqqJOD9VnFaZqX7BX10jyLO2Mid6DiaeWO+AEwnkpExG12KcZ0
         /uiFqXSsJAZRA4xRJb2SpS3tOacLXK3VM5Oe69PJEDTa/1q0YfgTQy9FuHQ1IF7RJC1t
         IUZ7wcEAwOPt9MxUzCq82Qsvqn35qhB9HavNOykgoENzN1hc+2kLc9XxdYwiAUvW/mjz
         1KDQ8HlZvSz83TV+aM1ZB20j1vn9Zu75YLuNT+o1ylimWQRyWFFprwNSOr4ZSAj+Pcyw
         Y6dTHrrQuOcIBBSCWdjlgwXeNwbxEZ5TYLZBqRcEvFPUHs/8pFmNObkY0PEHZ8lp6niQ
         A1LQ==
X-Gm-Message-State: AGi0PuYWouQHac6nqQ8gDH4Sug1gdU0ihGSqmCRTyR0E5glrr7BNRMWn
        tWR9gBl5kC5BNLCCnrt0les=
X-Google-Smtp-Source: APiQypLdfuZ0LtR9n3jgLi3Y+wanUvsdSHfihVfSncqCvEiBG/sax9vrGYuDGWNVd3HK2/HMRtVnbQ==
X-Received: by 2002:a63:b11:: with SMTP id 17mr2430268pgl.3.1588307932342;
        Thu, 30 Apr 2020 21:38:52 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6909:5f45:32d1:8e51? ([2601:647:4000:d7:6909:5f45:32d1:8e51])
        by smtp.gmail.com with ESMTPSA id b5sm1114351pfb.190.2020.04.30.21.38.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 21:38:51 -0700 (PDT)
Subject: Re: [PATCH RFC v3 03/41] scsi: Implement scsi_cmd_is_reserved()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-4-hare@suse.de>
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
Message-ID: <7ee63e35-0872-0c0c-118d-0b7a1d27f3c8@acm.org>
Date:   Thu, 30 Apr 2020 21:38:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430131904.5847-4-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-30 06:18, Hannes Reinecke wrote:
>  void scsi_put_reserved_cmd(struct scsi_cmnd *scmd)
>  {
> -	struct request *rq = blk_mq_rq_from_pdu(scmd);
> +	struct request *rq;
>  
> -	blk_mq_free_request(rq);
> +	if (scmd && scsi_cmd_is_reserved(scmd)) {
> +		rq = blk_mq_rq_from_pdu(scmd);
> +		blk_mq_free_request(rq);
> +	}
>  }

The above looks weird to me. Why to tolerate that a caller passes NULL
as argument to this function? Additionally, wouldn't a
WARN_ON_ONCE(!scsi_cmd_is_reserved(scmd)) be more appropriate instead of
the if (scsi_cmd_is_reserved(scmd)) { ... } ?

Thanks,

Bart.
