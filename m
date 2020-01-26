Return-Path: <SRS0=GUYw=3P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7620BC4741C
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 03:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D34920702
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 03:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgAZDiL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jan 2020 22:38:11 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45152 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbgAZDiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jan 2020 22:38:11 -0500
Received: by mail-pl1-f194.google.com with SMTP id b22so2447313pls.12;
        Sat, 25 Jan 2020 19:38:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=C6J2vyrfwsbzKsETG3LdMn6/JpdelGe+VlbRl2W8eUc=;
        b=Xg7hh0RhCvIGfL2RmSH/tYrI7acX3PNOxbFCBJyuKKy4yualskEtJZdaqqmAuR/eSA
         p65cxS9Wejh4tmxxdv7JGPYvc8ZGkMeJ8oqyBXZ79/fEogzeywuFxX5w4I/DnhlFp23u
         /TqCXWXOve64MxPqJAlWa84NluwSxbOTt79gmP21TIZ+GmOTfD2Udeel8N2asfS5um46
         QS5i+KGnFGjLF4r5mwANHzXN8sKc/ev41cLEYlRqUn21Iqdpt2xBBjyJ9kc1ph35sc69
         0oC7U9T0KW5cuAcL0mNXU4NYtBvj3C43zg158Qu4uGXwkBs88ixNKYZQbBB/01EOMUkg
         iYhQ==
X-Gm-Message-State: APjAAAXJYCvEND9jhiZtLuUwyXkUGsreidGrW2nWtFV29FSkd6527OA7
        izH03w/bwo0eOXJUAX6PMlEW2xcJtjE=
X-Google-Smtp-Source: APXvYqxI6mkRQt/PbIcKWf14pVYB4bykJ7v6vJj2WBirNIJqdo0ruqI/t84mjnUzzLLppZGKEAWhUQ==
X-Received: by 2002:a17:902:bb8d:: with SMTP id m13mr11340594pls.157.1580009890548;
        Sat, 25 Jan 2020 19:38:10 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:a876:9802:4659:f0bd? ([2601:647:4000:d7:a876:9802:4659:f0bd])
        by smtp.gmail.com with ESMTPSA id b8sm11221149pff.114.2020.01.25.19.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 19:38:09 -0800 (PST)
Subject: Re: [PATCH v4 8/8] scsi: ufs: Select INITIAL adapt for HS Gear4
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        open list <linux-kernel@vger.kernel.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-9-git-send-email-cang@codeaurora.org>
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
Message-ID: <0b782a25-a9a3-f6bc-6e2e-4ec0403b62a1@acm.org>
Date:   Sat, 25 Jan 2020 19:38:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579764349-15578-9-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-22 23:25, Can Guo wrote:
> @@ -8422,7 +8433,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	if ((hba->ufs_version != UFSHCI_VERSION_10) &&
>  	    (hba->ufs_version != UFSHCI_VERSION_11) &&
>  	    (hba->ufs_version != UFSHCI_VERSION_20) &&
> -	    (hba->ufs_version != UFSHCI_VERSION_21))
> +	    (hba->ufs_version != UFSHCI_VERSION_21) &&
> +	    (hba->ufs_version != UFSHCI_VERSION_30))
>  		dev_err(hba->dev, "invalid UFS version 0x%x\n",
>  			hba->ufs_version);

Is the UFS specification backwards compatible? Or in other words, does
the existing driver work fine for devices with a controller that
supports a newer version of the spec? I'm asking this because in Linux
kernel driver a version check that excludes newer controller versions is
very unusual. Can the above version check be removed in its entirety?

Thanks,

Bart.
