Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7845FC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 18:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59F7520733
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 18:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfLQSTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 13:19:54 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37952 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQSTy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 13:19:54 -0500
Received: by mail-pf1-f194.google.com with SMTP id x185so7993863pfc.5;
        Tue, 17 Dec 2019 10:19:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6YNl0Yd8NVMwMJOCBya0bHRM93tJ7VmBB94v+InASf4=;
        b=afuJ6vzXPSDkk0ySgCDT3GDaILuoE6AhEXM6FHyP0DcR4JC0mbsv4+DhNIv4mKLqBx
         45mXRHn3AgmcfRHOrqqLSWpbiQPN4Xz8kwzOQADjP3vk3xy6RwLhhTFAo5hUDXgEIcTg
         cGrcH6/RAJimDlfYZtRRiSZtfbquQfbD8XY6U/2nEN+zwnERn+DdvftD1C/VN1rdUPuZ
         Bz3qUR9/U0XPc+5TGLLerFI6RYHbFbzfIU7sfknc4u+5VOvsODi5PY0o9nYUHCJ6fsUv
         3A/GbUNJAt8Noq/LAjuJAn/7j+5ercAzSYVojxwr3s9zAtRLEvH80YCMQru8P/zMtSsT
         8Aeg==
X-Gm-Message-State: APjAAAXAWtcDl/ZPznGnobJW+5Kl/J3s2hHIhX5TmWEBx7Iur7LkLM0P
        w+ayZlLx2bGsRoD7/ezzstG1wnjxq2s=
X-Google-Smtp-Source: APXvYqwI5IyuEhS/9/hIW8BOOmbJbuuAiyqQJ1TOHcjSjQ4+aT28bwP2qvMM4+/VtdUCN0eZu/t/yw==
X-Received: by 2002:a63:d358:: with SMTP id u24mr26881689pgi.218.1576606792841;
        Tue, 17 Dec 2019 10:19:52 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id x8sm2257286pfd.76.2019.12.17.10.19.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 10:19:51 -0800 (PST)
Subject: Re: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
To:     cang@codeaurora.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
 <20191212045357.GA415177@yoga>
 <0101016ef8b2e2f8-72260b08-e6ad-42fc-bd4b-4a0a72c5c9b3-000000@us-west-2.amazonses.com>
 <20191212063703.GC415177@yoga> <5691bfa1-42e5-3c5f-2497-590bcc0cb2b1@acm.org>
 <926dd55d8d0dc762b1f6461495fc747a@codeaurora.org>
 <62933901-fcdf-b5ae-431d-e1fbfc897128@acm.org>
 <b3fee6ea02c4c3c46eeba81b0bdcf7c4@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f6e458e2-5be6-0bc0-a612-4a8bf9aae8bd@acm.org>
Date:   Tue, 17 Dec 2019 10:19:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <b3fee6ea02c4c3c46eeba81b0bdcf7c4@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/17/19 12:56 AM, cang@codeaurora.org wrote:
> Even in the current ufs_bsg.c, it creates two devices, one is ufs-bsg,
> one is the char dev node under /dev/bsg. Why this becomes a problem
> after make it a module?
> 
> I took a look into the pci_driver, it is no different than making ufs-bsg
> a plain device. The only special place about pci_driver is that it has its
> own probe() and remove(), and the probe() in its bus_type calls the
> probe() in pci_driver. Meaning the bus->probe() is an intermediate call
> used to pass whatever needed by pci_driver->probe().
> 
> Of course we can also do this, but isn't it too much for ufs-bsg?
> For our case, calling set_dev_drvdata(bsg_dev, hba) to pass hba to
> ufs_bsg.c would be enough.
> 
> If you take a look at the V3 patch, the change makes the ufs_bsg.c
> much conciser. platform_device_register_data() does everything for us,
> initialize the device, set device name, provide the match func,
> bus type and release func.
> 
> Since ufs-bsg is somewhat not a platform device, we can still add it
> as a plain device, just need a few more lines to get it initialized.
> This allows us leverage kernel's device driver model. Just like Greg
> commented, we don't need to re-implement the mechanism again.

Hi Can,

Since ufs-bsg is not a platform device I think it would be wrong to 
model ufs-bsg devices as platform devices.

Please have a look at the bus_register() and bus_unregister() functions 
as Greg KH asked. Using the bus abstraction is not that hard. An example 
is e.g. available in the scsi_debug driver, namely the pseudo_lld_bus.

Thanks,

Bart.
