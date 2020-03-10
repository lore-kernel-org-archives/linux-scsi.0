Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BA4C10F25
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 01:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9417B24649
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 01:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgCJB6R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 21:58:17 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40915 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgCJB6R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 21:58:17 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so1584064plk.7;
        Mon, 09 Mar 2020 18:58:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qyOPcviTsbfhQO/ypGIatzcQW1kAEltFF4Vqey2P0bg=;
        b=aeEntUjxGHpxhYs1XpiPMjMYsgANMakFborTO9EJO1tPc6ym2zySzrwmjdC3AVcYPH
         U6Eo92U9nynWOap9haRqL5tJNyIOahJUkmMG7mVSsfB8JPIl3Xghu9at12178xJTIfHj
         vDRb0pOXDdBdqAXNvw3CRQQiXZpGVoo7aVS/7HJDKTGnJXjbJIUOJZkB2H81lphU78cI
         bT7ZMrgPxeR3SnrKHrOGuLQimAuuJjges+kOu8ddWTmW6TCY6IMelnrlF5wycU4Jbsjr
         BrTab00F3ESPNWFKT+ysHHnOK9QmQ/++pmeEXDL1MvY1tUE8vUF3xrCsvNPJ4WR6rcCj
         UzJg==
X-Gm-Message-State: ANhLgQ3P/c4j2XozQTBKd78uHaHoUQcjzchUPzznl4AUUhNHPCDivuUv
        ng2c00X706R3pocYOEL8xhnsXvts
X-Google-Smtp-Source: ADFU+vuzWuOCJtoLOOSx428DH3AEJzg/4yPkxNbaruhxw9/Mi4eYWCI4hq1L/gO7jIXpRrhGcfXzsw==
X-Received: by 2002:a17:90b:3885:: with SMTP id mu5mr2189336pjb.25.1583805493868;
        Mon, 09 Mar 2020 18:58:13 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:c0e4:71da:7a83:2357? ([2601:647:4000:d7:c0e4:71da:7a83:2357])
        by smtp.gmail.com with ESMTPSA id r64sm748524pjb.15.2020.03.09.18.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 18:58:13 -0700 (PDT)
Subject: Re: [PATCH v3 1/1] scsi: ufs: fix LRB pointer incorrect
 initialization issue
To:     huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200309161057.9897-1-beanhuo@micron.com>
 <20200309161057.9897-2-beanhuo@micron.com>
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
Message-ID: <ede4addf-73c7-e5f8-5143-91eb0cd3eb9b@acm.org>
Date:   Mon, 9 Mar 2020 18:58:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309161057.9897-2-beanhuo@micron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-09 09:10, huobean@gmail.com wrote:
> @@ -4834,6 +4829,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>  			continue;
>  		cmd = blk_mq_rq_to_pdu(req);
>  		lrbp = scsi_cmd_priv(cmd);
> +		ufshcd_init_lrb(hba, lrbp, index);
>  		if (ufshcd_is_scsi(req)) {
>  			ufshcd_add_command_trace(hba, req, "complete");
>  			result = ufshcd_transfer_rsp_status(hba, lrbp);

This ufshcd_init_lrb() call looks incorrect to me. I think that
ufshcd_init_lrb() should only be called before a request is submitted to
the UFS controller and also that ufshcd_init_lrb() should not be called
from the completion path.

Thanks,

Bart.
