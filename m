Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4CDC4CECC
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 17:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E36D206D9
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 17:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgD0Rhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:37:46 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42748 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgD0Rhp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 13:37:45 -0400
Received: by mail-pl1-f196.google.com with SMTP id v2so7243224plp.9
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2020 10:37:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mtJh8MzN173nPmR+JfgfK0KFEh2Sv9D0Hj1TjArQa7Q=;
        b=idEOsOde7Lt428J70GgnBhsEsmOVXYmfgko+HP8M4TDFU+2w/LQkDcr7NzqqOLAdoH
         hXaT/T6Ghjf+HRfuT+meA2zPiZWTrK+0Tf9PmrOqDn5CG576+zzryPQ0C9x206Jf+YLI
         4rgX/iAHItnQ19DxKMAlWs7fAxFtyLT65oBdt7rXyvS/K/Fj2FPp2RDwWBVtqrajT2KN
         tLNINkNYA1r8FICgIFc4yu0t3PV1mQYnXUS36k1xuiDWmvkb6q5bbl3D80MUkw4GTM5/
         dTtvkAYdeM25NOMk1+qzo2jN6hs5u+LomKe0arCoQFKSZvQnsNQtNjCA9qxNg+Ymqvo9
         6+1Q==
X-Gm-Message-State: AGi0PuaXLbYQ09j2/TeuPofNHOVe3cW8Se2oahYQ3c8a0CdnKe+os8EW
        gKfT/hxkfRd7kpVPkqPHJDE=
X-Google-Smtp-Source: APiQypLfb4Jze1d36lWlDeEht+WKNGITjkQAHXQ3Sn2EMWIv3XagjXKQntGRsV8ljc82oU93NXBNVA==
X-Received: by 2002:a17:90b:2385:: with SMTP id mr5mr24046564pjb.172.1588009064835;
        Mon, 27 Apr 2020 10:37:44 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:a598:4365:d06:a875? ([2601:647:4000:d7:a598:4365:d06:a875])
        by smtp.gmail.com with ESMTPSA id d126sm11206222pfc.81.2020.04.27.10.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 10:37:44 -0700 (PDT)
Subject: Re: [PATCH v4 02/11] qla2xxx: Suppress two recently introduced
 compiler warnings
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-3-bvanassche@acm.org>
 <20200427081548.skbi7pqysknamfv5@beryllium.lan>
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
Message-ID: <6ee88b11-4a44-beb7-4328-e53a0314377d@acm.org>
Date:   Mon, 27 Apr 2020 10:37:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427081548.skbi7pqysknamfv5@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-27 01:15, Daniel Wagner wrote:
> On Sun, Apr 26, 2020 at 08:03:01PM -0700, Bart Van Assche wrote:
>> +#pragma GCC diagnostic push
>> +#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
> 
> I would be really surprised if this is needed for every single
> DECLARE_EVENT_CLASS declaration. 

Hi Daniel,

My understanding is that this is only necessary if vsnprintf() is used
in the implementation of the event class.

Thanks,

Bart.
