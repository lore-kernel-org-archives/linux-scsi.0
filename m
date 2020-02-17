Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF57C34021
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 16:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDEB520801
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 16:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgBQQRU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 11:17:20 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:43943 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbgBQQRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2020 11:17:20 -0500
Received: by mail-pl1-f181.google.com with SMTP id p11so6898021plq.10;
        Mon, 17 Feb 2020 08:17:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DhtAN8Z1lq+smog5hx8tnmyToocbQyCvpNHXj+TDxUI=;
        b=X5h6J5+j/Yl0g84xS0FpBrfhtAb688x6//ncCQ1ThTFLwHGdEi+7S8evrL2Vy2M4LU
         tRUFubqpJnQNKfd2+G22Q6idbZm0vyiR8t2Dd9LbU59jX+Hj4QE0L3tRCub+78t5wAB1
         kDrGFtPzKeDp7lBxhGOUpANm8He44eOBezlBZVt/SvUVEahIMuryp5pgt/pXVacxQ6Kt
         06KZ/dGymI/BZ1z+IH0wCmix5AgtcbN+Ow8NogCnp7HNlvd9shlZkDS0mZk9r6yHM/9P
         73vzHshITVo2HgB+q6K593A581PBFWzuXE/m2iEP86D+ui9xDKKpGxNB3Si+Iw71K5XJ
         4/wg==
X-Gm-Message-State: APjAAAULOmrDaRdtfZi+EZfUpLUUF21qMKJXmL+IpISlT5goJAYiSskn
        AMt7WK7R/7iewDxETtOiSSw=
X-Google-Smtp-Source: APXvYqyUGmGotOQnonxrVSNJHOnl6B9x5PFX1abnD5SGe8SeBqp456IotnkFNe/oXDoMuKeEr2m6JA==
X-Received: by 2002:a17:902:694b:: with SMTP id k11mr16630726plt.334.1581956239464;
        Mon, 17 Feb 2020 08:17:19 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:2474:e036:5bee:ca5b? ([2601:647:4000:d7:2474:e036:5bee:ca5b])
        by smtp.gmail.com with ESMTPSA id o11sm1148585pjs.6.2020.02.17.08.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 08:17:18 -0800 (PST)
Subject: Re: [PATCH v1 1/2] scsi: ufs: add required delay after gating
 reference clock
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
 <20200217093559.16830-2-stanley.chu@mediatek.com>
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
Message-ID: <87f03ff5-445b-25c2-308d-5c9e18942a0f@acm.org>
Date:   Mon, 17 Feb 2020 08:17:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200217093559.16830-2-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-17 01:35, Stanley Chu wrote:
> -			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
> +			ref_clk = !strcmp(clki->name, "ref_clk") ? true : false;
> +			if (skip_ref_clk && ref_clk)

Since the " ? true : false" part is superfluous, please leave it out.

Thanks,

Bart.
