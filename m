Return-Path: <SRS0=xzXz=2F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A7FC43603
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 00:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E59BE214AF
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 00:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfLOAO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 19:14:28 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41624 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfLOAO2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Dec 2019 19:14:28 -0500
Received: by mail-pl1-f195.google.com with SMTP id bd4so2843983plb.8
        for <linux-scsi@vger.kernel.org>; Sat, 14 Dec 2019 16:14:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tvYfcNKiZzvEGNmD06c1az847Fq8RcgkRyfmtu5eoos=;
        b=ZVJgyEvOYWtx8E7boOwDnxo2vxaJN7y0wp8SKvN5E7czyp60PkSr4CbxgwDIVJkcRh
         npL0acTBqRaPSo/EEMlMazhOLhIPr6VCqtqwqGXH+o5qVUm2auHpEwi7a6/HyXLY5+RO
         xkQDBUeeqqaKNnGeqV+RglN3RJNuFp5btNhQSVyIt5Xs2H7pJFTz9NrvCnBruMJA/itF
         m8LSGR4BaIN1oL4Ahj8tLmjxaHxsk9l9QnS8iSPWdTu9OflioU0o2Vzp8w2clXTxIri3
         TGhQkC5k7QfZEE9wz2fM+5KmgMNqbnRba8cXck2ZHFV3roiaaRQ73EvoplFQi8AoU0Kz
         jwFg==
X-Gm-Message-State: APjAAAU4zl+OyYQOhS06e34PVXJuDrzkS27To1wk0XHFYAzi/pJByVpK
        xHhqcRafrMODGacn5geNZfE=
X-Google-Smtp-Source: APXvYqytqKK7ltbcUv+/MQzVZbrblTp1Jhl4MOZ7v12MIPqHVf0HNIIsn5AQUE3jutfv2iE78tpgZQ==
X-Received: by 2002:a17:90a:20aa:: with SMTP id f39mr9053963pjg.35.1576368867362;
        Sat, 14 Dec 2019 16:14:27 -0800 (PST)
Received: from ?IPv6:2601:647:4000:110a:ccaa:fdec:8bf4:a5a? ([2601:647:4000:110a:ccaa:fdec:8bf4:a5a])
        by smtp.gmail.com with ESMTPSA id b21sm17378791pfp.0.2019.12.14.16.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 16:14:26 -0800 (PST)
Subject: Re: [PATCH 4/4] qla2xxx: Micro-optimize
 qla2x00_configure_local_loop()
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-5-bvanassche@acm.org>
 <20191214123325.q6mvmke5htwit3l7@SPB-NB-133.local>
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
Message-ID: <c8dd462b-8c3c-fc76-2db7-28a0e37ac540@acm.org>
Date:   Sat, 14 Dec 2019 16:14:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191214123325.q6mvmke5htwit3l7@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-14 04:33, Roman Bolshakov wrote:
> How about cpu_to_be32_array() instead of the hand-written loop?

Hi Roman,

That sounds like a good idea to me. I will look into this.

Bart.
