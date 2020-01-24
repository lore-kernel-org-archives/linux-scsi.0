Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F20DC35240
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 02:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15B8021835
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 02:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbgAXCsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 21:48:23 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36833 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730335AbgAXCsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 21:48:23 -0500
Received: by mail-pl1-f196.google.com with SMTP id a6so168796plm.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jan 2020 18:48:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IwZ74+F4dtT+JDK6t0X1dIFdTFZoh9bv26C/bW3XBEU=;
        b=Deb49o94ISCF6qAcApQh2DzLdRa+1FfMxUAJcx1ZQvXF9rGnxwcKgzzNWzKI1MkEgd
         E2pyeBoNmySqgTHwb4WHBw+0I+SyzHJ2ArABzGkfurg7sclmqFkmsOwgV2VxnllQ5stt
         l7tOZmTEvDpoI4Frd3tQfBirtcGsJpow2yiwi6XgpW1KfZit0AlWXRZoE6te0ZGhSBvf
         qE/FHc1FhdzhSbAlXRUVNMOwc5IhTRVPOctGoTADl4uTw/5TfkXlMCEgxYVoOwzlRvZF
         7tXHdGRKp+LVM6WE+N2JRKqaDPFsfXKwl6wkJm+hcIC4Krat0kdB7u/yXeTnoHAB4anl
         On3Q==
X-Gm-Message-State: APjAAAXIZiI4Y+TFYzMjDnA8CrdTfooSk3SZXCsDBL3oo0wy7IBsGpHV
        pBeB9ztZCYpXAiDoIeWydDYuT7Q5
X-Google-Smtp-Source: APXvYqylicPKNCHYgQMuw6iFq+L9vkGUq69M/DGt8T0NELZSzFlTNj0v1wYPOQRepzQVb91KB++d8A==
X-Received: by 2002:a17:902:fe8d:: with SMTP id x13mr1327216plm.232.1579834102155;
        Thu, 23 Jan 2020 18:48:22 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:3d7d:713:61bd:ca2a? ([2601:647:4000:d7:3d7d:713:61bd:ca2a])
        by smtp.gmail.com with ESMTPSA id a6sm4208327pgg.25.2020.01.23.18.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 18:48:21 -0800 (PST)
Subject: Re: [PATCH v2 1/3] scsi: refactor sdev lun queue depth setting via
 sysfs
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
References: <20200123222102.23383-1-jsmart2021@gmail.com>
 <20200123222102.23383-2-jsmart2021@gmail.com>
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
Message-ID: <09b51d25-06d3-9f43-72ab-04229ff4934a@acm.org>
Date:   Thu, 23 Jan 2020 18:48:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200123222102.23383-2-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-23 14:21, James Smart wrote:
> In preparation for allowing other attributes and routines to change
> the current and max lun queue depth on an sdev, refactor the sysfs
> sdev attribute change routine. The refactoring creates a new scsi-internal
> routine, scsi_change_max_queue_depth(), which changes a devices current
> and max queue value.
> 
> The new routine is placed next to the routine, scsi_change_queue_depth(),
> which is used by most lldds to implement a queue depth change.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
