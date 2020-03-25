Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282C3C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 21:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 056D72076A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 21:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgCYVpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 17:45:52 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41199 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgCYVpw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 17:45:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id z65so1712335pfz.8
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2020 14:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Mrb68AsDC5Y3REFPmFQ//CFUeI4klCwnFm4RhDjoYc=;
        b=AbUwTP838BxwNZtKKDHElak5+7i3MYkp58dQICnnifLSNlTBDi2ha+93vDnU22ygt8
         b+0Gxrevt2eu7sxnvFp5zPB1uYZiYe5+PPaazT45NQ7qPwKzhrCRmrk6DzY9//srr0Zp
         YMcCkbiLIy4V7q1gSZ9cbw5iQUfNW5OMXVRfgs3D+GeE/8GMu6ZSw214Sl3eRcLFVGy1
         afiXxvbyF1os8SRof+DfSMdBmwnNvUatwcTnrXTlpr0jNLGXFxaTg4Taln9h7T7dRqmb
         FdUlf/swRzAPiebVDSvS5Gvbyqmv35dWgjsrgs3u7UVbwbEFruaBDSZQl6MeDzjqpl3n
         r8Lg==
X-Gm-Message-State: ANhLgQ38Puldkdrf9QDWBn14zfz8XwSm72yxM2yPbF7BpWCzgHL9wUe6
        /1HDeF5w+CLRqXWXsdJQ7zxF6hP9rZU=
X-Google-Smtp-Source: ADFU+vuI8XZDBVJSo9Qii6qLeBzDRmLctf3Z495ubYVFfgWy7o20pi7CAGARFsPaS2EWaKsG2r8UDQ==
X-Received: by 2002:a65:67c7:: with SMTP id b7mr5152564pgs.345.1585172750533;
        Wed, 25 Mar 2020 14:45:50 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:2855:6197:3dfe:ba2? ([2601:647:4000:d7:2855:6197:3dfe:ba2])
        by smtp.gmail.com with ESMTPSA id e4sm88185pgc.60.2020.03.25.14.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 14:45:49 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: Make MODE SENSE DBD a boolean
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20200325213608.6843-1-martin.petersen@oracle.com>
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
Message-ID: <116e8e24-d442-6239-b401-dd3145f4e8e8@acm.org>
Date:   Wed, 25 Mar 2020 14:45:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325213608.6843-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-25 14:36, Martin K. Petersen wrote:
>  	} else {
>  		modepage = 8;
> -		dbd = 0;
> +		dbd = true;
>  	}

Is this change on purpose? If so, please mention this as an intended
behavior change in the commit message.

Thanks,

Bart.
