Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43F0C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 02:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA731206B7
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 02:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbfI0Co7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 22:44:59 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:35339 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfI0Co7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2019 22:44:59 -0400
Received: by mail-pg1-f177.google.com with SMTP id a24so2637279pgj.2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2019 19:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Hfo84XzIQoP0EAgxuE2MtWmGGnencn8H3vrC8tnFv8=;
        b=aGCH4cqy2tprXh58Z3uVAEq3+uUU6HO/NKfKhUbnvDT/NzRczAV4M6fmvdjbdHFE8z
         mxFHZqX51P1GMJuATFmM6llIKBihVdB6OpUqixhAv7tVMgqoYaob4xhDWIlOkfyDlatK
         aSVjIBjZ/4zX3avJCgT2jzE8FnIkfGNvYAnLJ7E2ZXFU8aGPD+CKIDBgX442PPlKz/AP
         Ee2AXT04liFHhR6d+wRNJAU1xu29HgktyK/L5JPeL/dWWEgSB/hcOnOWG5t5VJNq6WQH
         4W/DA2g/BB3W/TCu8wxOLvjZKYbT96Ln+HJPTBxKk6QpVOv9zekJLSSkJp2+P/pP69GC
         FV0Q==
X-Gm-Message-State: APjAAAVe6MzqN0hT3X3ZDxrtvupiG57Hm5sda9BumqzQVXNreJ1Colw4
        g++tSnXRVAjf9w8QEFISF/dM0fU2KO4=
X-Google-Smtp-Source: APXvYqykyby9ONwYV3mgfKW7WfuRqwHiiqT/GdUw456zWrlQVd2veeQN1k0MMZXVoaBwbxY8fj5M8A==
X-Received: by 2002:a17:90a:3748:: with SMTP id u66mr7259577pjb.4.1569552297809;
        Thu, 26 Sep 2019 19:44:57 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:a9:2083:a241:50c7:8f37])
        by smtp.gmail.com with ESMTPSA id m19sm3075434pjl.28.2019.09.26.19.44.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 19:44:56 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: Add sysfs attributes for VPD pages 0h and 89h
To:     Ryan Attard <ryanattard@ryanattard.info>, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20190926162216.56591-1-ryanattard@ryanattard.info>
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
Message-ID: <8b20b48f-8a6c-e24e-4c7d-440dcaa732c0@acm.org>
Date:   Thu, 26 Sep 2019 19:44:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190926162216.56591-1-ryanattard@ryanattard.info>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-09-26 09:22, Ryan Attard wrote:
> Add sysfs attributes for the ATA information page and
> Supported VPD Pages page.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
