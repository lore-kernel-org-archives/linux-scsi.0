Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1473AC4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF2C023A32
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgIVDWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:22:24 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40454 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbgIVDWY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:22:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id k133so6024372pgc.7
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2020 20:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PSx4VmaXEP9DcYca/MkWB4GZK6GHmnVHxAMgEWIEmes=;
        b=uZeBoOVcNdjEGeVYF5oZLReCSUEbZz8TaOC3OH8nArVOIimPh73JBhY1tMuZ5+2XJr
         rmtoJW53NAo8NOxlL48Ny+Yf2lq6M4vcVCMVaKAk38zMf13OlpTpJ5Uah3nJAzZeLIDx
         1zJb4J9Nv2YYmIcDB6dUwBVxqoaySJDguo+1BaGDtY4nFfed8Xf+7FeMNXBG+uYsWl1A
         3EVTegLyEcs8kKSFTzASwjaxIoIxboi4swRcCd4mwySOb/LN+sQ0YkmnlNKxtlQ3YEY1
         tlkGlD2luY6TGkUIg/ddpPVZSl6bXpUlo2aXzPPPppmPDtnBC/biMO6JiK7xJNL2hv6B
         lefQ==
X-Gm-Message-State: AOAM53358tk3xyiRF8997W17dmpOAuchdR2M6BgUPyB/Q0SasjwO5wpQ
        Be+YQ5ahpUqA4D1kOmTcr/E=
X-Google-Smtp-Source: ABdhPJzBLtGCylhLjUaUY09tm2B7SLUqTzwAe3XoiS0DDH7mMrn8ZU96HGZOya5qanIB3wGcCGBuKQ==
X-Received: by 2002:a17:902:aa4b:b029:d0:cbe1:e739 with SMTP id c11-20020a170902aa4bb02900d0cbe1e739mr2886984plr.20.1600744943187;
        Mon, 21 Sep 2020 20:22:23 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:5e05:892c:575b:24c7? ([2601:647:4000:d7:5e05:892c:575b:24c7])
        by smtp.gmail.com with ESMTPSA id j19sm13643097pfe.108.2020.09.21.20.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 20:22:22 -0700 (PDT)
Subject: Re: [PATCH 2/2] scsi sd: Allow user to config cmd retries
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1600714109-6178-1-git-send-email-michael.christie@oracle.com>
 <1600714109-6178-3-git-send-email-michael.christie@oracle.com>
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
Message-ID: <947733d3-b591-1bd7-e4e3-b215c1ad743f@acm.org>
Date:   Mon, 21 Sep 2020 20:22:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1600714109-6178-3-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-21 11:48, Mike Christie wrote:
> equivalent of a dm-mutlipath temp all paths down, or we just have to
                     ^^^^^^^^^
                     multipath?

> +static ssize_t
> +max_retries_store(struct device *dev, struct device_attribute *attr,
> +		  const char *buf, size_t count)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +	struct scsi_device *sdev = sdkp->device;
> +	int retries;
> +
> +	if (sscanf(buf, "%d\n", &retries) != 1)
> +		return -EINVAL;

Does the above code return 0 if a user uses echo -n to write into the
max_retries attribute? If so, how about supporting echo -n?

Isn't kstrtoint() recommended over sscanf() in sysfs store callbacks?

Thanks,

Bart.
