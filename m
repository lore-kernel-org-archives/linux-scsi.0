Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC00AC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 03:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3D5D2076C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 03:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHMDWx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 23:22:53 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40896 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMDWx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 23:22:53 -0400
Received: by mail-pj1-f66.google.com with SMTP id d4so2094859pjx.5;
        Wed, 12 Aug 2020 20:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gOeWB/fFQX8TFgcsqSgEvvRAYNi8MuzmPzQBJ7DPQtM=;
        b=atGvLhvb8+pb6ts7fJk8/5M+d5zYXf0xSnsClWDsA+84HEnhTGWkS5oZuErOUR+FAT
         GkCtsIXIbdQ/G03fGabhn2PrliLbvvpkUT43IzbKPUNrDMNIbUbnuGMsuNdFDwVibBbf
         R7DzjqfTsuTEZ4ZPksDtWiA1/6tvS1OOx+rziS/K6P9ookrinNgZUBuS+EIJ/2yXzRCT
         lujZh/ZqzECXL75fVbxhiMhALY2fgBFlbOHSQgs1b0dACvAquIr+SK/lMJBXrzeecu54
         zKXOHwjSBbtMpMRhRDhWclZRPlh9mxIC7ljLGRU34zRU9iGhYfV6J2KIMB3r1xCKA/SQ
         VrLg==
X-Gm-Message-State: AOAM532swuwwn79XvHfzdxf3Xt1kwgjOwCNXAWwrEgK64FBz0tBF8MKu
        7hLh0qR5NgDpH+fVdfXKglk=
X-Google-Smtp-Source: ABdhPJw0Vet94i2VnEo4BrDlHg25TtG0an+p9xK5Pb7L/vDiGeB0J9UbTAbtkPdJsX73UwDwQIJvHQ==
X-Received: by 2002:a17:90b:138a:: with SMTP id hr10mr2918610pjb.161.1597288971581;
        Wed, 12 Aug 2020 20:22:51 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id h18sm3900116pfo.21.2020.08.12.20.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 20:22:50 -0700 (PDT)
Subject: Re: [PATCH v8 2/4] scsi: ufs: Introduce HPB feature
To:     daejun7.park@samsung.com,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <2154d9c6-4b29-7d24-0261-26d2aa05caef@acm.org>
 <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
 <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
 <231786897.01596705302142.JavaMail.epsvc@epcpadp1>
 <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p3>
 <231786897.01597287781957.JavaMail.epsvc@epcpadp2>
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
Message-ID: <842c51c6-320f-a096-d9ea-b9d411ac6e3a@acm.org>
Date:   Wed, 12 Aug 2020 20:22:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <231786897.01597287781957.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-12 20:00, Daejun Park wrote:
> On 2020-08-06 02:11, Daejun Park wrote:
>>> +static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb)
>>> +{
>>> +    int ret;
>>> +
>>> +    ufshpb_stat_init(hpb);
>>> +
>>> +    kobject_init(&hpb->kobj, &ufshpb_ktype);
>>> +    mutex_init(&hpb->sysfs_lock);
>>> +
>>> +    ret = kobject_add(&hpb->kobj, kobject_get(&hba->dev->kobj),
>>> +              "ufshpb_lu%d", hpb->lun);
>>> +
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    ret = sysfs_create_group(&hpb->kobj, &ufshpb_sysfs_group);
>>> +
>>> +    if (ret) {
>>> +        dev_err(hba->dev, "ufshpb_lu%d create file error\n", hpb->lun);
>>> +        return ret;
>>> +    }
>>> +
>>> +    dev_info(hba->dev, "ufshpb_lu%d sysfs adds uevent", hpb->lun);
>>> +    kobject_uevent(&hpb->kobj, KOBJ_ADD);
>>> +
>>> +    return 0;
>>> +}
>>
>> Please attach these sysfs attributes to /sys/class/scsi_device/*/device
>> instead of creating a new kobject. Consider using the following
>> scsi_host_template member to define LUN sysfs attributes:
> 
> I am not rejecting your comment. But I added kobject for distinguishing 
> between other attributes and attributes related to HPB feature.
> If you think it's pointless, I'll fix it.

Hi Daejun,

I see two reasons to add these sysfs attributes under
/sys/class/scsi_device/*/device:
- This makes the behavior of the UFS driver similar to that of other Linux
  SCSI LLD drivers.
- This makes it easier for people who want to write udev rules that read
  from these attributes. Since ufshpb_lu%d is attached to the UFS controller
  it is not clear to me which attributes will appear first in sysfs - the
  SCSI device attributes or the ufshpb_lu%d attributes. If there are only
  SCSI device attributes there is no such ambiguity and hence authors of
  udev rules won't have to worry about this race condition.

>>> +void ufshpb_remove(struct ufs_hba *hba)
>>> +{
>>> +    struct ufshpb_lu *hpb, *n_hpb;
>>> +    struct ufsf_feature_info *ufsf;
>>> +    struct scsi_device *sdev;
>>> +
>>> +    ufsf = &hba->ufsf;
>>> +
>>> +    list_for_each_entry_safe(hpb, n_hpb, &lh_hpb_lu, list_hpb_lu) {
>>> +        ufshpb_set_state(hpb, HPB_FAILED);
>>> +
>>> +        sdev = hpb->sdev_ufs_lu;
>>> +        sdev->hostdata = NULL;
>>> +
>>> +        ufshpb_destroy_region_tbl(hpb);
>>> +
>>> +        list_del_init(&hpb->list_hpb_lu);
>>> +        ufshpb_remove_sysfs(hpb);
>>> +
>>> +        kfree(hpb);
>>> +    }
>>> +
>>> +    dev_info(hba->dev, "ufshpb: remove success\n");
>>> +}
>>
>> Should the code in the body of the above loop perhaps be called from inside
>> ufshcd_slave_destroy()?
> 
> Moving other stuffs in the loop is good idea, but removing attributes is problem.
> To avoid adding new kobject, I will try to use sysfs_merge_group() 
> for adding attributes. To delete merged attributes, sysfs_unmerge_group() 
> should be called. But sysfs_remove_groups() is called before calling ufshcd_slave_destroy().

Hmm ... I don't see why the sdev_groups host template attribute can't be used?

Please don't use sysfs_merge_group() and sysfs_unmerge_group() because that
would create a race condition against udev rules if these functions are called
after the device core has emitted a KOBJ_ADD event.

Thanks,

Bart.
