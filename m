Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E4FC41604
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 15:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D420420709
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 15:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbgJCPR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Oct 2020 11:17:28 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:37154 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgJCPR2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Oct 2020 11:17:28 -0400
Received: by mail-pj1-f68.google.com with SMTP id kk9so2732624pjb.2;
        Sat, 03 Oct 2020 08:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xuUhZ/LRuv86ivtj20txG1lkMVzxNZTrGMBEgcwEiTU=;
        b=skC6JIKLZAYf71BSZFdJTFpdFs3eMGm2QzIh21rDds4qzxdpUqPjcd74EbENBnFjp3
         kXFXN9NVaMDCbl35+6wXyClrsAIeRm4MQQxiJmxg96ANrmL3j/913L63B7300XVZP3sc
         0WCyfK0f/NzauvjeTcU+eI9y1cJJ+1YAOdjwOOPqGe9Lto34s8Np1KI1iOzAbUPPBjhs
         h6WNcu2rHKQCUUybXa6Knrz6TMjDxC4JmnkKEM2pAx10DOySDWwD4JEU1H9K3gCI2AFN
         Or1fkWpVF35C32DQD7ZBP3bG7PCYiTtVbY1FeCoRBqReAwYDMYvADBYK+6gao9WqYNtU
         HRJQ==
X-Gm-Message-State: AOAM532HQotPQEwp+IVQ2J3sM4k34l37LUStcoIFpPZyaWDaExBdg7/P
        vx89tQWICS4WXohgAly2Jha35gsiA9o=
X-Google-Smtp-Source: ABdhPJxiSUUGqEvfF73vQFFnHvsjeUfzX3Te2KlBczXudNZG8caQbA4Wu870g2ngzX+VOMiB7YbgHg==
X-Received: by 2002:a17:90b:d8f:: with SMTP id bg15mr7899916pjb.90.1601738245117;
        Sat, 03 Oct 2020 08:17:25 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6c06:9bb3:6b2f:ea63? ([2601:647:4000:d7:6c06:9bb3:6b2f:ea63])
        by smtp.gmail.com with ESMTPSA id e27sm6191051pfj.62.2020.10.03.08.17.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2020 08:17:23 -0700 (PDT)
Subject: Re: [PATCH] Revert "scsi: target/iscsi: Detect conn_cmd_list
 corruption early"
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20201002073341.12470-1-mlombard@redhat.com>
 <ce44115e-f8ac-0307-88bd-f6a2e9d7f7f3@acm.org>
 <fea1f8a6-615e-6d44-ec20-b4f46da10d55@redhat.com>
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
Message-ID: <49bcd5f9-a528-f52d-3093-494e76eaac10@acm.org>
Date:   Sat, 3 Oct 2020 08:17:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <fea1f8a6-615e-6d44-ec20-b4f46da10d55@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-03 00:46, Maurizio Lombardi wrote:
> Dne 03. 10. 20 v 2:23 Bart Van Assche napsal(a):
>> I agree that the same WARN_ON() occurs inside __iscsit_free_cmd(). What is not
>> clear to me is how removing the WARN_ON() statement from iscsit_free_cmd() can
>> help since an identical statement occurs inside __iscsit_free_cmd()?
> 
> It doesn't help indeed, this patch just removes one duplicate warning but doesn't
> really change anything.
> 
> The bug I am trying to fix will need a different patch to prevent the race condition.

How about addressing both issues with a single patch?

Thanks,

Bart.
