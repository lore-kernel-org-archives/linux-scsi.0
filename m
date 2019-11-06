Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015E1C5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB6882075C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731027AbfKFEpE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:45:04 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38448 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729303AbfKFEpE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 23:45:04 -0500
Received: by mail-pl1-f196.google.com with SMTP id w8so10826907plq.5
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 20:45:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VysNGy0l57FLnFmconh8GUd5jTgkVePfjTshUj5TtUs=;
        b=jf+BTCvx6lfUtGpyMMT5IV6H8W02tcH78UiEO+kTQYdB3HhuLcBlve0LvHwqOTfwVb
         Ku/1DgYbT4VCEScDTGR6/5aZtizIC41AdxkKcJz0Y6IlfadxIbJv9TJ/nPlQ2yVsllv9
         cB3Sw2L0zW2Tjd16OWmjS+YGBiLdZPbriTobS2hTVgLldW3QakVrf75gyXSYo+YgcNhM
         P1fwgBVXVE9/cN0bkufGkjEVrKk2TX5LIxJYlHwHqj8ecf6H5/Bvw2ZUizOZZQimmBWt
         7IPGdR4Kec84IvXH8WgY3lvR86CLQsPiDMRnOJsTXKrnpGjS/+CYHuaqinQUf23CKbU0
         +kow==
X-Gm-Message-State: APjAAAXB/3kdjP363emrWIRKMur0/PUZ8oF1riplZMpVu0hri+J30wk+
        A3ASZjr51UtRhYYwwSDmUG1LNr7G
X-Google-Smtp-Source: APXvYqxXJKPGKsJ+F3NGT+q3N1t+O8noEZy7efDDpkaY+A6s54q1qdjW7jfcqBkLcrBDqAWEWkmOIA==
X-Received: by 2002:a17:902:a70f:: with SMTP id w15mr510311plq.263.1573015503611;
        Tue, 05 Nov 2019 20:45:03 -0800 (PST)
Received: from localhost.localdomain ([2601:647:4000:1075:a0dc:7f54:c925:d679])
        by smtp.gmail.com with ESMTPSA id q22sm10508968pgb.81.2019.11.05.20.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 20:45:02 -0800 (PST)
Subject: Re: [PATCH 3/3] ufs: Remove .setup_xfer_req()
To:     Alim Akhtar <alim.akhtar@gmail.com>,
        Avri Altman <Avri.Altman@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
References: <20191029230710.211926-1-bvanassche@acm.org>
 <20191029230710.211926-4-bvanassche@acm.org>
 <MN2PR04MB69914B9FA252E1B0A05493BAFC600@MN2PR04MB6991.namprd04.prod.outlook.com>
 <MN2PR04MB6991FD5665C0C1E7DEF7854BFC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <CAGOxZ51AHByBFsMiKG_-pGjVe4=1ijQnUipS=Gjq1pYPsCKQGA@mail.gmail.com>
 <CAGOxZ53xoaFrs09KfPFHfR69-n9SnRrZ0uESE65e+Wgwe3Pr7A@mail.gmail.com>
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
Message-ID: <5dd9deb7-77c7-332c-6001-c6d232fa7f0d@acm.org>
Date:   Tue, 5 Nov 2019 20:45:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <CAGOxZ53xoaFrs09KfPFHfR69-n9SnRrZ0uESE65e+Wgwe3Pr7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-05 20:09, Alim Akhtar wrote:
> I checked the brief history of this adding  "setup_xfer_req" to
> support Samsung UFSHCI (this was the ground work done)
> We need this to support vendor specific NEXUS_TYPE settings.
> The Samsung UFSHCI driver will be up for review in near future
> For usecase of the function pointer please see an older version of the
> patch https://patchwork.kernel.org/patch/7306321/

Thanks Alim for having looked up this information. Let's drop this patch.

Bart.

