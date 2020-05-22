Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E22C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 16:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3146120723
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 16:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbgEVQtt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 12:49:49 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34734 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbgEVQtt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2020 12:49:49 -0400
Received: by mail-pj1-f66.google.com with SMTP id l73so2372226pjb.1;
        Fri, 22 May 2020 09:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pe3U2Pc1R5aAAvHcpLLKtfeeYNZhxpfWB/nI2dXUKTo=;
        b=OMN21QpBu3Y+HgKC/8YrB7BqYvGfAfoWQWslGszGh2v/13AUUmpkYHAMGvmOI43xbY
         6CC5XOAknG9ZbCcK/J0Lj+zDmkMNnx3INvnxPSo43njOnPwS1gH3vxVvZodBQgS/EZD3
         yIygLFdnDEyWarxo3czQ66JBODKz8Beop/LHqFNuL51LtJYO9nsICmaVdPFFQMag8gBG
         E8h91HIVWD//HhUtxQXQXiLCJE26eAc2uZkFmRLrLWUu052SJodFWUHSjbrCRXjDMgL/
         xYVWbHnsJN9ouVIdkQwpG7Mhi1f4O3IKrx53l9lyb60ZSoBdsH/TwkZf3fUHIzUVr+hK
         46/A==
X-Gm-Message-State: AOAM532C1rVFdVK9VGkosvXsxyAA1PJuYsd9g5OPP0RKse4rl4N8pznm
        Y7DW1stAYRdVWuiYvO6qzkg=
X-Google-Smtp-Source: ABdhPJxVeW2HY3x3447XCgvX+Lp7tGkdpIlaSOHG8Pt7Eg0yxtQApkFapH1xSLqYoqhM2Gs2+Tw5Dg==
X-Received: by 2002:a17:902:d70f:: with SMTP id w15mr16286450ply.55.1590166187500;
        Fri, 22 May 2020 09:49:47 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:2d21:38e:755:9ae8? ([2601:647:4000:d7:2d21:38e:755:9ae8])
        by smtp.gmail.com with ESMTPSA id b5sm7268911pju.50.2020.05.22.09.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 09:49:46 -0700 (PDT)
Subject: Re: Another approach of UFSHPB
To:     ymhungry.lee@samsung.com, Avri Altman <Avri.Altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
References: <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
 <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
 <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <CGME20200516171420epcas2p108c570904c5117c3654d71e0a2842faa@epcms2p7>
 <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
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
Message-ID: <aaf130c2-27bd-977b-55df-e97859f4c097@acm.org>
Date:   Fri, 22 May 2020 09:49:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-19 15:31, yongmyung lee wrote:
> Currently, UFS driver (usually ufshcd.c) has become bulky and complex.
> So, I would like to split these codes into layers 
> like the works of Bean Huo and Avril Altman.
> Especially, I suggest the UFS-Feature Driver model based on Linux Bus-Driver Model,
> which is suitable to manage all Extended UFS-Feature drivers like the Figure as below:
> 
> 
> UFS Driver data structure (struct ufs_hba)
>    |
>    |    -----------------------    -- ufshpb driver -- <- attach ufshpb device driver (it can be loadable)
>    |---| ufs-ext feature layer |   -- ufs-wb driver -- <- attach ufswb device driver
>    |   |                       |   -- ...           -- <- ...
>    |    -----------------------    -- next ufs feature driver  -- <- attach ufs-next feature driver
> 
> * wb : write-booster

Splitting the UFS driver into multiple modules would be great if the
interface between these modules can be kept small and elegant. However,
I'm not sure that this approach should be based on Linux device driver
bus concept. Devices can be unbound at any time from their driver by
writing into the "unbind" sysfs attribute. I don't think we want the UFS
core functionality ever to be unbound while any other UFS functionality
is still active. Has it been considered to implement each feature as a
loadable module without relying on the bus model? The existing kernel
module infrastructure already prevents to unload modules (e.g. the UFS
core) that are in use by a kernel module that depends on it (e.g. UFS HPB).

> Furthermore, each ufs-ext feature driver will be written as a loadable kernel module.
> Vendors (e.g., Android Phone manufacturer) could optionally load and remove each module.

What will happen if a feature module is unloaded (e.g. HPB) while I/O is
ongoing that relies on HPB?

> Also they can customize the parameters of ufs-ext feature drivers
> while each module is being loaded.
> (For example, vendor would set the maximum memory size
>  that can be reclaimed in the Host Control mode in HPB)

Should these parameters be per module or per UFS device?

> In addition, we plan to provide QEMU with UFS-simulator
> for a test environment for UFS driver development.

A UFS simulator for QEMU support would definitely be welcome.

Thanks,

Bart.
