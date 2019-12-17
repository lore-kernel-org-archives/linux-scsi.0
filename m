Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DBDC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 08:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 710212176D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 08:56:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="bPoj1k7J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfLQI4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 03:56:31 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:43294 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727096AbfLQI4b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 03:56:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576572990; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ZJq7Qp3bn1KsgMY+MZCRUXUmBAGCDF5Rh8QzjkblaaY=;
 b=bPoj1k7Je11sJPa9xjm5pwnhuZmpKhA2yLSgx/L4AMvuguhtTbVan2EiUZDzZDFASJLqD1Is
 Vonxa8BFtaZcY6ly2gJ+foXq6VW27SoYPgcH+5x8LZmrg/2TiVbpJYQzqN/FGuBn0pu112I+
 n87MFONvYhGGMRhzm8rj2UhiuMM=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df8983b.7f2a43eacbc8-smtp-out-n02;
 Tue, 17 Dec 2019 08:56:27 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 703BFC447AE; Tue, 17 Dec 2019 08:56:25 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B16BC433CB;
        Tue, 17 Dec 2019 08:56:23 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 17 Dec 2019 16:56:23 +0800
From:   cang@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
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
Subject: Re: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
In-Reply-To: <62933901-fcdf-b5ae-431d-e1fbfc897128@acm.org>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
 <20191212045357.GA415177@yoga>
 <0101016ef8b2e2f8-72260b08-e6ad-42fc-bd4b-4a0a72c5c9b3-000000@us-west-2.amazonses.com>
 <20191212063703.GC415177@yoga>
 <5691bfa1-42e5-3c5f-2497-590bcc0cb2b1@acm.org>
 <926dd55d8d0dc762b1f6461495fc747a@codeaurora.org>
 <62933901-fcdf-b5ae-431d-e1fbfc897128@acm.org>
Message-ID: <b3fee6ea02c4c3c46eeba81b0bdcf7c4@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-17 01:22, Bart Van Assche wrote:
> On 12/15/19 8:36 PM, cang@codeaurora.org wrote:
>> On 2019-12-16 05:49, Bart Van Assche wrote:
>>> On 2019-12-11 22:37, Bjorn Andersson wrote:
>>>> It's the asymmetry that I don't like.
>>>> 
>>>> Perhaps if you instead make ufshcd platform_device_register_data() 
>>>> the
>>>> bsg device you would solve the probe ordering, the remove will be
>>>> symmetric and module autoloading will work as well (although then 
>>>> you
>>>> need a MODULE_ALIAS of platform:device-name).
>>> 
>>> Hi Bjorn,
>>> 
>>> From Documentation/driver-api/driver-model/platform.rst:
>>> "Platform devices are devices that typically appear as autonomous
>>> entities in the system. This includes legacy port-based devices and
>>> host bridges to peripheral buses, and most controllers integrated
>>> into system-on-chip platforms.  What they usually have in common
>>> is direct addressing from a CPU bus.  Rarely, a platform_device will
>>> be connected through a segment of some other kind of bus; but its
>>> registers will still be directly addressable."
>>> 
>>> Do you agree that the above description is not a good match for the
>>> ufs-bsg kernel module?
>> 
>> I missed this one.
>> How about making it a plain device and add it from ufs driver?
> 
> Hi Can,
> 
> Since the ufs_bsg kernel module already creates one device node under
> /dev/bsg for each UFS host I don't think that we need to create any
> additional device nodes for ufs-bsg devices. My proposal is to modify
> the original patch 2/3 from this series as follows:
> * Use module_init() instead of late_initcall_sync().
> * Remove the ufshcd_get_hba_list_lock() and
>   ufshcd_put_hba_list_unlock() functions.
> * Implement a notification mechanism in the UFS core that invokes a
>   callback function after an UFS host has been created and also after 
> an
>   UFS host has been removed.
> * Register for these notifications from inside the ufs-bsg driver.
> * During registration for notifications, invoke the UFS host creation
>   callback function for all known UFS hosts.
> * If the UFS core is unloaded, invoke the UFS host removal callback
>   function for all known UFS hosts.
> 
> I think there are several examples of similar notification mechanisms
> in the Linux kernel, e.g. the probe and remove callback functions in
> struct pci_driver.
> 
> Bart.

Hi Bart,

Even in the current ufs_bsg.c, it creates two devices, one is ufs-bsg,
one is the char dev node under /dev/bsg. Why this becomes a problem
after make it a module?

I took a look into the pci_driver, it is no different than making 
ufs-bsg
a plain device. The only special place about pci_driver is that it has 
its
own probe() and remove(), and the probe() in its bus_type calls the
probe() in pci_driver. Meaning the bus->probe() is an intermediate call
used to pass whatever needed by pci_driver->probe().

Of course we can also do this, but isn't it too much for ufs-bsg?
For our case, calling set_dev_drvdata(bsg_dev, hba) to pass hba to
ufs_bsg.c would be enough.

If you take a look at the V3 patch, the change makes the ufs_bsg.c
much conciser. platform_device_register_data() does everything for us,
initialize the device, set device name, provide the match func,
bus type and release func.

Since ufs-bsg is somewhat not a platform device, we can still add it
as a plain device, just need a few more lines to get it initialized.
This allows us leverage kernel's device driver model. Just like Greg
commented, we don't need to re-implement the mechanism again.

Thanks,
Can Guo.
