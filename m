Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E275C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 14:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D67202077D
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 14:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390683AbgDCOQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Apr 2020 10:16:23 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36993 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390477AbgDCOQX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2020 10:16:23 -0400
Received: by mail-pf1-f195.google.com with SMTP id u65so3545573pfb.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Apr 2020 07:16:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aclbB5Vrw2xNZ/TSD6x+LSKO2sxnCbDH7t6ZN231r0A=;
        b=Ish3kKFyDZYdKZgcX25qzvFr/Z8ZzWyXfprN7Qbe0QHNq5z83rDKdgo2OYe9e2mhn1
         MiIKHyamwzlbIvLxy7EaK4bhIMNpAr8/aBiK8UoCUxf2batEHQZmt9P8qd9IboZ8qGbR
         k91uOv96dzPiVc+nJRAa0oNt3CW0JNEzKxqRozBQ82a4GNifsogx1z9Pdr4XftZMXljJ
         JZ0mo9SlVT9fYcTdv8hcvu1H3UdaUFklP/MX0uQcqSNc9tDbxxf9Ey6Je1S2xEmeY5cl
         niRSgWrz8t7sdKW8gRkp0w2SNzqsR+aGNZ6gg2d9SHqHOozdchpbgz9nuZK2B48RP1K5
         9/tQ==
X-Gm-Message-State: AGi0PuZqR9bHnDHmsi8IMcnQ0e2BhrbrusrGGJ18rYJDee4Ss90IKZUV
        gihdDN5VRnN3WFXgX522HBo=
X-Google-Smtp-Source: APiQypLRyFXVCJbCL6sdzKk4ikB4U/dsOYaDKoxbNaJWtFSGEZjejhnfrLIEOJ6ix4IteC7rLKLFWg==
X-Received: by 2002:a62:e107:: with SMTP id q7mr8591503pfh.190.1585923382250;
        Fri, 03 Apr 2020 07:16:22 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f1be:827e:b9e9:8d94? ([2601:647:4000:d7:f1be:827e:b9e9:8d94])
        by smtp.gmail.com with ESMTPSA id v26sm5855481pfn.51.2020.04.03.07.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 07:16:21 -0700 (PDT)
Subject: Re: [PATCH 1/2] qla2xxx: Fix regression warnings
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200403084018.30766-1-njavali@marvell.com>
 <20200403084018.30766-2-njavali@marvell.com>
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
Message-ID: <701a1483-bd97-3088-2d08-57d1795bd95a@acm.org>
Date:   Fri, 3 Apr 2020 07:16:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200403084018.30766-2-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-03 01:40, Nilesh Javali wrote:
> @@ -2547,6 +2546,7 @@ ql_dbg(uint level, scsi_qla_host_t *vha, uint id, const char *fmt, ...)
>  	vaf.va = &va;
>  
>  	if (!ql_mask_match(level)) {
> +		char pbuf[64];
>  		if (vha != NULL) {
>  			const struct pci_dev *pdev = vha->hw->pdev;
>  			/* <module-name> <msg-id>:<host> Message */

Has this patch been verified witch checkpatch? Did checkpatch report
"Missing a blank line after declarations"?

Thanks,

Bart.
