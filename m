Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C51C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C11552053B
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbgGCEaI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:30:08 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:42009 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGCEaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 00:30:07 -0400
Received: by mail-pg1-f171.google.com with SMTP id m22so4146265pgv.9
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2020 21:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pXYzord71xECArYfRBfm1ppn24FwBpvItv67FFrR6sE=;
        b=MIdOUtv2RZaAP8YeyT+DnaOh+EbAghpzeDRvwYr9Ajxmp4ybMiC4dPlX1BQ2JpdfQ6
         l+mH4GocWieQJuf79cU9YOIq7YMIpNKxob34w0Dn5uM3dBVrvxuMfjUDentcaGlvkrSr
         JwgkP+GH/1SMajFSGpMrmKTQQNQ8EYXq3wF+AQbpeOjvOF6MR6rYFcs0Din45ZMqTFpz
         HqNlyhrCIscV/XAGqRMlsJExcDX0GVcTXROuN0qxSM0vYJGVvK+h+NB8jseGwLYglYpF
         W0BOBtqs5UGHrM6X11TrINqQMoqC8vSaUyo7E6FwELKoC4pE2fxEWbnplceLV/l9k+Hx
         UWow==
X-Gm-Message-State: AOAM530ycSc8ir8FB8Ur43WoBsfDsSwc7AE7pLZM6dhN+tOL+3VDwnkX
        gw4AT+4AKu1ixCYLLBBkEsE=
X-Google-Smtp-Source: ABdhPJznGu9WoX4KBSqq7M8HLUUoXEY987vJ3ymfND2Pp/BAWgtTAaNL5D2ogQab1blzLMc0pbt2uw==
X-Received: by 2002:a62:2c07:: with SMTP id s7mr16779938pfs.191.1593750606708;
        Thu, 02 Jul 2020 21:30:06 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id nh14sm3331397pjb.4.2020.07.02.21.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 21:30:05 -0700 (PDT)
Subject: Re: [PATCH v4 2/2] qla2xxx: SAN congestion management(SCM)
 implementation.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200630102229.29660-1-njavali@marvell.com>
 <20200630102229.29660-3-njavali@marvell.com>
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
Message-ID: <eceec220-f9ac-5854-0377-a4d2293ba35c@acm.org>
Date:   Thu, 2 Jul 2020 21:30:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200630102229.29660-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-30 03:22, Nilesh Javali wrote:
> +	total_bytes = le16_to_cpu(purex->frame_size & 0x0FFF)
> +	    - PURX_ELS_HEADER_SIZE;

This assignment triggers two new sparse warnings:

drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: restricted __le16 degrades to integer
drivers/scsi/qla2xxx/qla_isr.c:881:23: warning: cast to restricted __le16

Please fix these.

Thanks,

Bart.
