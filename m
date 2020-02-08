Return-Path: <SRS0=yjur=34=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4672C2BA83
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 03:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B67402082E
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 03:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgBHDRV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 22:17:21 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55462 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgBHDRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 22:17:21 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so1712920pjz.5
        for <linux-scsi@vger.kernel.org>; Fri, 07 Feb 2020 19:17:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=byhBZzoWFfwGTDH0WFpdeqjyck11jKKD2PxRgiJNnoE=;
        b=Ne4OaxdQeRQLMWVzzP0EYYpnzh24217TdELc/zSpmb7/IlTpQV5OsRKnX/rFjyERT2
         p2B6L2NMhIIw3oaWLjxLNFJwS43Gw3dZcN8j2EWKoq1yPNVO9ts4d8yBOzMe9FT33XMW
         11I1yH3yzv1FJFsivctmeaTdRzJZtLVQAa2bUzd2IVywkj+uH/lKn8kF4POC8mCpWXcD
         3m1oiFqrXHLfcf+1Hl+OIG0Coa2BUqOdZ5QnWzHaa7DKKMl8VL4Hfd5SKXaYMYPcruPJ
         DbygtXgWOczaQJfLh9mVYsOLm0doDl0albgVOzySb4Cc76vp+1dMuTtmKfCbNsk+hdTO
         J9kQ==
X-Gm-Message-State: APjAAAUWtEFffMAeYOSAlp0W2ecOiCVAut1xciXcSXJUPJxtCAClZXtI
        hOlCqnc+YNdjAU0o2S591cg=
X-Google-Smtp-Source: APXvYqwpR5KdV3lzHF64cKOBqmMn45+YfXkfgrtjqxEcHlkd8D8v+PPAKBnS0ulmmZBcR5N2L4qxTA==
X-Received: by 2002:a17:90a:858a:: with SMTP id m10mr7530448pjn.117.1581131840376;
        Fri, 07 Feb 2020 19:17:20 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:81e7:2f8f:8d7f:e4b7? ([2601:647:4000:d7:81e7:2f8f:8d7f:e4b7])
        by smtp.gmail.com with ESMTPSA id j8sm4009836pjb.4.2020.02.07.19.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 19:17:19 -0800 (PST)
Subject: Re: [PATCH 0/4] qla2xxx patches for kernel v5.6
To:     Martin Wilck <mwilck@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>
Cc:     linux-scsi@vger.kernel.org, "dwagner@suse.de" <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <bb273446a0f294e37dc0afb2c450fb761e345260.camel@suse.com>
 <559ee60f-43e8-b228-f14b-7453d62e7780@acm.org>
 <cb2ad8b48a412ad164ebbe809bc80b238b16a0b4.camel@suse.com>
 <4478372c-7e34-c35f-6ccc-dff1422b6256@acm.org>
 <44e8e2cad35ea91f4b4a8fceb2e12930c62760b1.camel@suse.com>
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
Message-ID: <f4c4a95d-7d93-9989-2bf7-097102618e01@acm.org>
Date:   Fri, 7 Feb 2020 19:17:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <44e8e2cad35ea91f4b4a8fceb2e12930c62760b1.camel@suse.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-07 01:09, Martin Wilck wrote:
> Sorry for insisting - in your original submission "Revert "qla2xxx: Fix
> Nport ID display value" from 11/09/2019, you'd identified this as a
> regression caused by 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display
> value"). Are you saying that that wasn't the whole truth? Had N2N been
> broken before already? Did N2N with "old" adapters ever work with
> previous versions of the driver? Which ones?

Hi Martin,

My conclusion is indeed that N2N is broken since a long time for at
least the 8 Gb/s QLogic FC adapter. The test I run is to set the
qlini_mode kernel module parameter to dual, to connect two ports of a
dual port adapter to each other and to make both ports log in to each
other. If I run this test against a 32 Gb/s dual port adapter then I
always see that both ports log in to each other. If I run this test
against an 8 Gb/s dual port adapter then I see that most of the time
only one port logs in to another port. Sometimes no login happens at all.

Bart.
