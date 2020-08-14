Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9BFC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 02:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA8920768
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 02:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHNCw0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Aug 2020 22:52:26 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33455 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgHNCw0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2020 22:52:26 -0400
Received: by mail-pf1-f196.google.com with SMTP id u20so3858096pfn.0;
        Thu, 13 Aug 2020 19:52:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GLLgq3atnPSXi/im1cF44k0QoKLgpkLLSUPTSmQdJ4c=;
        b=Qxv6T6+2OQwuY4y8O1q2pEF7VvG/+0GluJGX0I9ztllbCh6cJizdglIqVI3ZihlvyZ
         vSpBSSlIKFIy2KNpcpGdXxAIMwPYuDAa7abV/t1OqSEWPRltd7vt0LzpSMsrjb3h2uOY
         WUPs8zcQOSE/9xAuYYLHZKvdYDpyYRUdNzBWyb88F0h7UHbQd12vSun8ZvNcNztjYdfP
         sNeWlinAvExzEPV+INrzzREIU3nsGWqRSXGHdOB7p4CUJzQwwRDf/rWlZDsG9sbbxLTf
         s/QwCQHAwC7PSbWTl/2roVtD/Syz3Z8Yo3jhMQBH617P0VJSiPk94OdSQ8cC2+G3olvy
         m58Q==
X-Gm-Message-State: AOAM532oOSLKFROWVCYqSDF6uPiXmoKhLftislMjMa1SxR2sFuA0cTJ6
        pMEIuTW3sxEb+809FVQm0L0=
X-Google-Smtp-Source: ABdhPJyt3LOZ8ZUi6nhoA86/62mZK/ncV7w8jvUcLWwIYItDeLk7VhagMjJVWYW68xmEwtowsx0wvQ==
X-Received: by 2002:aa7:9636:: with SMTP id r22mr291747pfg.304.1597373545097;
        Thu, 13 Aug 2020 19:52:25 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y19sm7152325pfn.77.2020.08.13.19.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 19:52:24 -0700 (PDT)
Subject: Re: [PATCH v7] scsi: ufs: Quiesce all scsi devices before shutdown
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?S3VvaG9uZyBXYW5nICjnjovlnIvptLsp?= 
        <kuohong.wang@mediatek.com>,
        =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>,
        =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        =?UTF-8?B?QW5keSBUZW5nICjphKflpoLlro8p?= <Andy.Teng@mediatek.com>,
        =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>
References: <20200803100448.2738-1-stanley.chu@mediatek.com>
 <f40ad9e1-2e45-f21c-d067-eff579982cc7@acm.org>
 <1597308950.26065.25.camel@mtkswgap22>
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
Message-ID: <68eb8e35-9619-ec78-3583-f4501ef200f8@acm.org>
Date:   Thu, 13 Aug 2020 19:52:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1597308950.26065.25.camel@mtkswgap22>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-13 01:55, Stanley Chu wrote:
> I tried many ways to come out the final solution. Currently two options
> are considered,
> 
> == Option 1 ==
> 	pm_runtime_get_sync(hba->dev);
> 
> 	shost_for_each_device(sdev, hba->host) {
> 		scsi_autopm_get_device(sdev);
> 		if (sdev == hba->sdev_ufs_device)
> 			scsi_device_quiesce(sdev);
> 		else
> 			scsi_remove_device(sdev);
> 	}
> 
> 	ret = ufshcd_suspend(hba, UFS_SHUTDOWN_PM);
> 
> 	scsi_remove_device(hba->sdev_ufs_device);
> 
> Note. Using scsi_autopm_get_device() instead of pm_runtime_disable()
> is to prevent noisy message by below checking,
> 
> 	WARN_ON_ONCE(sdev->quiesced_by && sdev->quiesced_by != current);
> 
> in
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/scsi/scsi_lib.c#n2515
> 
> This warning shows up if we try to quiesce a runtime-suspended SCSI
> device. This is possible during our new shutdown flow. Using
> scsi_autopm_get_device() to resume all SCSI devices first can prevent
> it.
> 
> In addition, normally sd_shutdown() would be executed prior than
> ufshcd_shutdown(). If scsi_remove_device() is invoked by
> ufshcd_shutdown(), sd_shutdown() will be executed again for a SCSI disk
> by
> 
> [  131.398977]  sd_shutdown+0x44/0x118
> [  131.399416]  sd_remove+0x5c/0xc4
> [  131.399824]  device_release_driver_internal+0x1c4/0x2e4
> [  131.400481]  device_release_driver+0x18/0x24
> [  131.401018]  bus_remove_device+0x108/0x134
> [  131.401533]  device_del+0x2dc/0x630
> [  131.401973]  __scsi_remove_device+0xc0/0x174
> [  131.402510]  scsi_remove_device+0x30/0x48
> [  131.403014]  ufshcd_shutdown+0xc8/0x138
> 
> In this case, we could see SYNCHRONIZE_CACHE command will be sent to the
> same SCSI device twice. This is kind of wired during shutdown flow.
> 
> Moreover, in consideration of performance of ufshcd_shutdown(), Option 1
> obviously degrades the latency a lot by scsi_remove_device(). Please see
> the "Performance Measurement" data below.
> 
> Compared Option 2, this way is simpler and also effective. This way may
> be a better compromise.
> 
> == Option 2  ==
> 	pm_runtime_get_sync(hba->dev);
> 
> 	shost_for_each_device(sdev, hba->host) {
> 		scsi_autopm_get_device(sdev);
> 		scsi_device_quiesce(sdev);
> 	}
> 
> == Performance Measurement ==
> As-Is: < 5 ms
> Option 1: 850 ms
> Option 2: 60 ms
> 
> What would you prefer? Or would you have any further suggestions?

Hi Stanley,

Thanks for the detailed report and also for having shared timing information.

The approach of option 2 seems wrong to me because the SCSI devices are not
removed. My concern is that option (2) could cause the sd driver to send SYNC
and/or STOP commands to the device after its PCIe resources have been freed,
resulting in a crash.

Please take a look at the output of the following command:

$ git grep -nHA10 'struct pci_driver.* = {$' */scsi |
  sed -e 's/-/:/' -e 's/-/:/' |
  grep ':[[:blank:]]*\.remove'

It seems to me that other SCSI LLDs do at least the following in their PCIe
removal callback:

1. Call scsi_remove_host()
2. Call scsi_host_put()
3. Call pci_disable_device()

Would that approach work for UFS? Would offlining the UFS LUNs (SDEV_OFFLINE)
before calling the above functions make SCSI host removal faster? See also
scsi_prep_state_check().

Thanks,

Bart.
