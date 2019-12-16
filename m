Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C85C43603
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 17:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DBD120717
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 17:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfLPRWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 12:22:25 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37100 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLPRWY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 12:22:24 -0500
Received: by mail-pj1-f65.google.com with SMTP id ep17so3263065pjb.4;
        Mon, 16 Dec 2019 09:22:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v2qcov+FADvqNKCZLTTFv4XXmMDQ6mSro4B3OA7yDB4=;
        b=YLApVkzXcoH9sYQXo6mubykVkMquzm4hPnOO2VYMdFTpdtjkwLBqLxMy5aRo/fpYiw
         z199KvvkQzFkZxcukgOia5eV+SjGDcqP7CioizzE6UMFy6q/yrBwgqbZUasv8DeIAKnk
         +EsZYxdbsRZKe7F1x+AcoLBQMJrvhe3IgL7xvsA2m0XMctCMGuHl+IRFvic48fE3fFL4
         UJkKpttLNafXzX+/LYI48JaLKjhzlJWufz0ycibsaM86sHvaoPsYS1soW8GU5XZXEXyT
         qB/qKYKefZtDb+xtWhWwJLBpWWcZlI6duU00/RE014KUUM133nr4bZmvMNWV9x3Ilw2w
         qmPQ==
X-Gm-Message-State: APjAAAX4vy2EicBRyoO73LzQVVDQ89uGpHD/THtu/2gNFvdFrNEuB8+4
        qVxJ1TLoWuzU+q/9kmH2r0wkdhf4yYA=
X-Google-Smtp-Source: APXvYqxldVMknpdg/eYJWmUNo2cFG3KPf6KXVYwf96AKErLg1KEQQefR53J33LuhjIbPJ3XNpWpZ0A==
X-Received: by 2002:a17:90a:cc02:: with SMTP id b2mr66257pju.137.1576516943602;
        Mon, 16 Dec 2019 09:22:23 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c8sm23384328pfo.163.2019.12.16.09.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 09:22:22 -0800 (PST)
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <62933901-fcdf-b5ae-431d-e1fbfc897128@acm.org>
Date:   Mon, 16 Dec 2019 09:22:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <926dd55d8d0dc762b1f6461495fc747a@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/15/19 8:36 PM, cang@codeaurora.org wrote:
> On 2019-12-16 05:49, Bart Van Assche wrote:
>> On 2019-12-11 22:37, Bjorn Andersson wrote:
>>> It's the asymmetry that I don't like.
>>>
>>> Perhaps if you instead make ufshcd platform_device_register_data() the
>>> bsg device you would solve the probe ordering, the remove will be
>>> symmetric and module autoloading will work as well (although then you
>>> need a MODULE_ALIAS of platform:device-name).
>>
>> Hi Bjorn,
>>
>> From Documentation/driver-api/driver-model/platform.rst:
>> "Platform devices are devices that typically appear as autonomous
>> entities in the system. This includes legacy port-based devices and
>> host bridges to peripheral buses, and most controllers integrated
>> into system-on-chip platforms.  What they usually have in common
>> is direct addressing from a CPU bus.  Rarely, a platform_device will
>> be connected through a segment of some other kind of bus; but its
>> registers will still be directly addressable."
>>
>> Do you agree that the above description is not a good match for the
>> ufs-bsg kernel module?
>
> I missed this one.
> How about making it a plain device and add it from ufs driver?

Hi Can,

Since the ufs_bsg kernel module already creates one device node under 
/dev/bsg for each UFS host I don't think that we need to create any 
additional device nodes for ufs-bsg devices. My proposal is to modify 
the original patch 2/3 from this series as follows:
* Use module_init() instead of late_initcall_sync().
* Remove the ufshcd_get_hba_list_lock() and
   ufshcd_put_hba_list_unlock() functions.
* Implement a notification mechanism in the UFS core that invokes a
   callback function after an UFS host has been created and also after an
   UFS host has been removed.
* Register for these notifications from inside the ufs-bsg driver.
* During registration for notifications, invoke the UFS host creation
   callback function for all known UFS hosts.
* If the UFS core is unloaded, invoke the UFS host removal callback
   function for all known UFS hosts.

I think there are several examples of similar notification mechanisms in 
the Linux kernel, e.g. the probe and remove callback functions in struct 
pci_driver.

Bart.
