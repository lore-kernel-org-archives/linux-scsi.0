Return-Path: <SRS0=73BN=CK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEC7C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 03:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D00882071B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Sep 2020 03:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgIADzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 23:55:12 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51575 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgIADzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 23:55:12 -0400
Received: by mail-pj1-f65.google.com with SMTP id ds1so46791pjb.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2020 20:55:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jN5rQwDxCPOk9gWw4YpedBM+g0Z3Gfq7GgDqoU3Zej8=;
        b=YqQpBMwGDJQvjD6jx2I3+YikjIz2Uw4ugr9e8cTnWcl+Fnl6ZCHOvSg56d88V8xr27
         AF/K1ye4+AYtt/CA4MT8aASMndL8pkWyYHtZ52yzv+vXGAXNq3h2mkqEYiedWY2Rj1LW
         N0sNV/zd0AvQLYEhRfIAAT29B94yO2gOOE1duOWPr5ExIhVG55epaWsyu9zVO3UVWhvA
         mszg9Pg1gEk8bPAgc3kx+lBY6WjIwZuRe3l28k2OcHtl9r66igDCsCoRzZ/3EuXc0j7O
         jOdtF+ItrOIJ4vQ0Kq16iaQL2+CZ/MY2kKDA+DkD6VFnPYxJZttyyEk7U/sGoYl7cacx
         l4qQ==
X-Gm-Message-State: AOAM533Qo8DsgaQpf8pguziLEdiUzRhHIfg/WqcA/s2Ob8K3kisEIwEX
        2rEcvZHdzDpZ+j0hwkF8xHD9vQMZVwE=
X-Google-Smtp-Source: ABdhPJyYl4rTLNs8eQ71T+3GAsM2X/FPWzbQ4A5VrWwLslZ2QnH0GXN1I9wuU52twIR9GehzZtHh5g==
X-Received: by 2002:a17:90b:4d0d:: with SMTP id mw13mr83669pjb.43.1598932509745;
        Mon, 31 Aug 2020 20:55:09 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z126sm9980274pfc.94.2020.08.31.20.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 20:55:08 -0700 (PDT)
Subject: Re: [PATCH RFC 0/6] Fix a deadlock in the SCSI power management code
To:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-scsi@vger.kernel.org, Can Guo <cang@codeaurora.org>
References: <20200831025357.32700-1-bvanassche@acm.org>
 <88d3c835-c2f9-6384-f448-8bd731db7a13@puri.sm>
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
Message-ID: <44777832-2e7e-b7c9-0668-9ee96d312b91@acm.org>
Date:   Mon, 31 Aug 2020 20:55:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <88d3c835-c2f9-6384-f448-8bd731db7a13@puri.sm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-31 02:09, Martin Kepplinger wrote:
> Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>

Thanks for having tested this patch series!

Bart.

