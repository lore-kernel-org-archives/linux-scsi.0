Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E27C33C9E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA5E42077B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 03:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgAQD6M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 22:58:12 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36259 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgAQD6M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 22:58:12 -0500
Received: by mail-pg1-f195.google.com with SMTP id k3so10998146pgc.3;
        Thu, 16 Jan 2020 19:58:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=IQYyvzvzRQkSaQNfvWEHNndX1z10qWwtcZRb9h5hrUc=;
        b=CkN7ZELVNL0AwVHo08T/UaF3l/WGJQsQo4B8w+TJ9Fwom4eM6OBBIKERVYLvgB6qD9
         LomLpc95jocBGThy0UIbTqZ3RO2vkUQB62mlb9yOK8LCBpDaQuRxrj+GIUDSfvNVsIzo
         O78cozU3LZROmb8Y7B7WvrE7GY6NbtLt5O/A5Rr/pzM0GpED1uTLh2yG1vlHk29kgIy1
         fxhc4NVHtviJNuFNoLv6/TDcptHGYIvFua/B10STR/T5AunzqQYdhx5esK8kdQODX7wL
         nDUkTtfGGgz7TXWQCjINr4CQOOfpMrElFGsw9/FiDhvdmH3x1w/bE878/bgnrL0pv4wX
         pWcg==
X-Gm-Message-State: APjAAAWAjGFcqtvF/CwrefNMsP8t8BNcWYM8+PrlElNbFXJnGCTDFsnf
        qqtRtqDvMD8wjxYwWJVxArad5coy/e8=
X-Google-Smtp-Source: APXvYqzqczS8KRGkfKjpRgZi/bwjo0QJHfrV0jyD9U7wsF6fPeJLKUEI6StnitAdB7eUGpx8dK3WhQ==
X-Received: by 2002:a63:5056:: with SMTP id q22mr42301342pgl.20.1579233490890;
        Thu, 16 Jan 2020 19:58:10 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:8dfb:7edd:e01b:b201? ([2601:647:4000:d7:8dfb:7edd:e01b:b201])
        by smtp.gmail.com with ESMTPSA id j94sm13505pje.8.2020.01.16.19.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 19:58:10 -0800 (PST)
Subject: Re: [PATCH v2 5/9] scsi: ufs: Delete two unnecessary functions
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-6-huobean@gmail.com>
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
Message-ID: <b315bf53-6b64-0e1f-ffd4-823dce99954e@acm.org>
Date:   Thu, 16 Jan 2020 19:58:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200116215914.16015-6-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-16 13:59, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Delete ufshcd_read_power_desc() and ufshcd_read_device_desc(), directly
> inline ufshcd_read_desc() into its callers.

How about changing the subject into "Inline two functions into their
callers"? Otherwise this patch looks fine to me.

Thanks,

Bart.
