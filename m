Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748E7C83006
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 03:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54EFA20728
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 03:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgD1Dgt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 23:36:49 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37461 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgD1Dgs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 23:36:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id c21so6984320plz.4;
        Mon, 27 Apr 2020 20:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0k4zhB5J5wwLzqFT2DnrRY/M6LsNiYrm/fFkE6tCH68=;
        b=GbED2WYjdIgFYUELu6oVoclro2qxrKHETrOjAxU5k+cGhLS5cD6FTLeS0rTrmTMmiZ
         gE9VletMnkNGyWKHcXk84GKGjBi1O4Rf96G5w1l9HuZsazHsANhBMgd4SBIt48TZiVyM
         YkXr6wsJw894UYK2kX1fQE9N5gbGV6WO9NHt8ht7UCH+/7RPZPirWqVRJyJf6nUldO+5
         lfTIeuWbDnEerioClxIvu7eoVM9UPqlpxtfVMR4jqlLWPO5Mo8IYUE47peQcS7/7pxb0
         XcnrtK6EnpX+t2r18NdTjecwx4zqEPtVu3N4CuOrnRg57zQoFS5AMoe0n8KRQNrw8i+D
         DzQQ==
X-Gm-Message-State: AGi0PuZup21vbVoGKg20rC+1WTWGYEaLKF+OwL30bVpZR+vvwQczlygk
        uembfTQvANwh+p8m9407g6iyPMw4kpI=
X-Google-Smtp-Source: APiQypLBjwGkoYX5A2DL0Om93X70ZzI6LGiFnErQvH/83kJhcQsVAibV8dVTc5zFs1tTnd6rH7H8Kw==
X-Received: by 2002:a17:90b:110d:: with SMTP id gi13mr2356522pjb.131.1588045005734;
        Mon, 27 Apr 2020 20:36:45 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:a598:4365:d06:a875? ([2601:647:4000:d7:a598:4365:d06:a875])
        by smtp.gmail.com with ESMTPSA id k24sm13427424pfk.164.2020.04.27.20.36.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 20:36:44 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
To:     Avri Altman <Avri.Altman@wdc.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
 <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
 <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
 <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
 <12e8ad61-caa4-3d28-c1d7-febe99a488fb@acm.org>
 <SN6PR04MB4640A33BBE0CD58107D7FC69FCAF0@SN6PR04MB4640.namprd04.prod.outlook.com>
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
Message-ID: <b2584ba8-3542-1aae-5802-e59d218e1553@acm.org>
Date:   Mon, 27 Apr 2020 20:36:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <SN6PR04MB4640A33BBE0CD58107D7FC69FCAF0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-26 23:13, Avri Altman wrote:
>> On 2020-04-25 01:59, Avri Altman wrote:
> HPB support is comprised of 4 main duties:
> 1) Read the device HPB configuration
> 2) Attend the device's recommendations that are embedded in the sense buffer
> 3) L2P cache management - This entails sending 2 new scsi commands (opcodes were taken from the vendor pool):
> 	a. HPB-READ-BUFFER - read L2P physical addresses for a subregion
> 	b. HPB-WRITE-BUFFER - notify the device that a region is inactive (in host-managed mode)
> 4) Use HPB-READ: a 3rd new scsi command (again - uses the vendor pool) to perform read operation instead of READ10.  HPB-READ carries both the logical and the physical addresses.
> 
> I will let Bean defend the Samsung approach of using a single LLD to attend all 4 duties.
> 
> Another approach might be to split those duties between 2 modules:
>  - A LLD that will perform the first 2 - those can be done only using ufs privet stuff, and 
>  - another module in scsi mid-layer that will be responsible of L2P cache management,
>   and HPB-READ command setup.
> A framework to host the scsi mid-layer module can be the scsi device handler.
> 
> The scsi-device-handler infrastructure was added to the kernel mainly to facilitate multiple paths for storage devices.
> The HPB framework, although far from the original intention of the authors, might as well fit in.
> In that sense, using READs and HPB_READs intermittently, can be perceived as a multi-path.
> 
> Scsi device handlers are also attached to a specific scsi_device (lun).
> This can serve as the glue linking between the ufs LLD and the device handler which resides in the scsi level.
> 
> Device handlers comes with a rich and handy set of APIs & ops, which we can use to support HPB.
> Specifically we can use it to attach & activate the device handler,
> only after the ufs driver verified that HPB is supported by both the platform and the device. 
> 
> The 2 modules can communicate using the handler_data opaque pointer,
> and the handler’s set_params op-mode: which is an open protocol essentially,
> and we can use it to pass the sense buffer in its full or just a parsed version.
> 
> Being a scsi mid-layer module, it will not break anything while sending
> HPB-READ-BUFFER and HPB-WRITE-BUFFER as part of the L2P cache management duties.
> 
> Last but not least, the device handler is already hooked in the scsi command setup flow - scsi_setup_fs_cmnd(),
> So we get the hook into HPB-READ prep_fn for free.   
>  
> Later on, we might want to export the L2P cache management logic to user-space.
> Locating the L2P cache management in scsi mid-layer will enable us to do so, using the scsi-netlink or some other means.

Hi Avri,

I'm not sure that I agree that HPB can be perceived as multi-path.
Anyway, the above approach sounds interesting to me. A few questions though:
- The only in-tree caller of scsi_dh_attach() I am aware of exists in
  the dm-mpath driver. I think that call is triggered by multipathd.
  I don't think that it is acceptable to require that multipathd is
  running to use the UFS HPB functionality. What is the plan for
  attaching the UFS device handler to UFS devices?
- Will preparing a SCSI command involve executing a SCSI command? If so,
  how will it be prevented that execution of that internally submitted
  SCSI command triggers a deadlock due to tag exhaustion?

Thanks,

Bart.
