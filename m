Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71C0C0044D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 02:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D06D920736
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 02:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387673AbgCLCVX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 22:21:23 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35092 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387655AbgCLCVX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 22:21:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id g6so2014781plt.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2020 19:21:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mSlICFhkvzyQ5lD5pXNsufCeoK5PEmzAj0Kgy3b71B4=;
        b=f8QRbVu76Z1eHZs9oQo0Am/JQ7gFdp/nTDBtJtRLzUS5MDx8LQfh8zN8MS7st666lu
         xiCcIKBPeYmTuhuyxNGb9CYW6+Z5KHNPnFVOkU/x4AaJQ5R8krzXitZUQ8UiQ80uMu/8
         wcpuLtHmaghu1Ah/9+hT5GAKYdOWsaK6XtoCa+uJEKI6iVOklkX4yPNRfbleFSFucsEk
         h0dbqiD9KL8Xbsz4uOU0xhLIe1lWNe8ggZhmdthfWLI6eO1ORnwcfH2OzbArwIcB0StH
         MCCQDtGvKveFQuOxnWnRiZnynal/vxq2510Qlsrqb9T1m5u2jWAvMrfq2darwvnvXLs+
         kXrQ==
X-Gm-Message-State: ANhLgQ3lN3nk5F589t7wnd/IHjVoAcLPpnuMcGIil5zp1a1nipqSPV5y
        Z9XMxXtFhgrgAj3R5HwxhgpmmbpDth4=
X-Google-Smtp-Source: ADFU+vv6uGzxUR63CekUWTtidxWXi1BtJKCiN7Wdbg3iLJai10xurXPLflBaWvlb5Bz9ruDaWOjIxw==
X-Received: by 2002:a17:90a:2330:: with SMTP id f45mr1666979pje.169.1583979679652;
        Wed, 11 Mar 2020 19:21:19 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:3408:a640:bb6c:f632? ([2601:647:4000:d7:3408:a640:bb6c:f632])
        by smtp.gmail.com with ESMTPSA id n14sm7221626pjt.36.2020.03.11.19.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 19:21:18 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: avoid repetitive logging of device offline
 messages
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
References: <20200311143930.20674-1-emilne@redhat.com>
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
Message-ID: <99454400-cc4c-3431-ed48-e62bf39bba76@acm.org>
Date:   Wed, 11 Mar 2020 19:21:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200311143930.20674-1-emilne@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-11 07:39, Ewan D. Milne wrote:
> Large queues of I/O to offline devices that are eventually
> submitted when devices are unblocked result in a many repeated
> "rejecting I/O to offline device" messages.  These messages
> can fill up the dmesg buffer in crash dumps so no useful
> prior messages remain.  In addition, if a serial console
> is used, the flood of messages can cause a hard lockup in
> the console code.
> 
> Introduce a flag indicating the message has already been logged
> for the device, and reset the flag when scsi_device_set_state()
> changes the device state.
> 
> v2:
> 	Changed flag type from bitfield to bool by request

Thanks!

Reviewed-by: Bart van Assche <bvanassche@acm.org>
