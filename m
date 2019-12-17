Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CBBC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 18:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C3EC20733
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 18:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="nI3U8DK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbfLQSrn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 13:47:43 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:57472 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726887AbfLQSrn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 13:47:43 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576608463; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7tr+0eWTIFsfDOZs6HQbFrliTffvsYr/ED6xJGRQVJ4=;
 b=nI3U8DK6iX86gTlVgd1nwv/mRaX3hvJIYJ4s6V6bmKiOBzqxnu1IYJLmcFuo52prp6H9g7n1
 6yUT0B/g7MyNnP4igdBNULQRTLPr5KenORFf50vYs76zjA9Y/iEy/dVtl70WSYTh9IKeOqMD
 XHUIbFsRqFw1gTakl0DuZP+uaVQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df922c8.7fe3f2712b90-smtp-out-n03;
 Tue, 17 Dec 2019 18:47:36 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7F61CC447AD; Tue, 17 Dec 2019 18:47:34 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 49523C43383;
        Tue, 17 Dec 2019 18:47:33 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Dec 2019 02:47:33 +0800
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
In-Reply-To: <f6e458e2-5be6-0bc0-a612-4a8bf9aae8bd@acm.org>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
 <20191212045357.GA415177@yoga>
 <0101016ef8b2e2f8-72260b08-e6ad-42fc-bd4b-4a0a72c5c9b3-000000@us-west-2.amazonses.com>
 <20191212063703.GC415177@yoga>
 <5691bfa1-42e5-3c5f-2497-590bcc0cb2b1@acm.org>
 <926dd55d8d0dc762b1f6461495fc747a@codeaurora.org>
 <62933901-fcdf-b5ae-431d-e1fbfc897128@acm.org>
 <b3fee6ea02c4c3c46eeba81b0bdcf7c4@codeaurora.org>
 <f6e458e2-5be6-0bc0-a612-4a8bf9aae8bd@acm.org>
Message-ID: <04309f46208b6aa26c989a2cfcfa38b6@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-18 02:19, Bart Van Assche wrote:
> On 12/17/19 12:56 AM, cang@codeaurora.org wrote:
>> Even in the current ufs_bsg.c, it creates two devices, one is ufs-bsg,
>> one is the char dev node under /dev/bsg. Why this becomes a problem
>> after make it a module?
>> 
>> I took a look into the pci_driver, it is no different than making 
>> ufs-bsg
>> a plain device. The only special place about pci_driver is that it has 
>> its
>> own probe() and remove(), and the probe() in its bus_type calls the
>> probe() in pci_driver. Meaning the bus->probe() is an intermediate 
>> call
>> used to pass whatever needed by pci_driver->probe().
>> 
>> Of course we can also do this, but isn't it too much for ufs-bsg?
>> For our case, calling set_dev_drvdata(bsg_dev, hba) to pass hba to
>> ufs_bsg.c would be enough.
>> 
>> If you take a look at the V3 patch, the change makes the ufs_bsg.c
>> much conciser. platform_device_register_data() does everything for us,
>> initialize the device, set device name, provide the match func,
>> bus type and release func.
>> 
>> Since ufs-bsg is somewhat not a platform device, we can still add it
>> as a plain device, just need a few more lines to get it initialized.
>> This allows us leverage kernel's device driver model. Just like Greg
>> commented, we don't need to re-implement the mechanism again.
> 
> Hi Can,
> 
> Since ufs-bsg is not a platform device I think it would be wrong to
> model ufs-bsg devices as platform devices.
> 
> Please have a look at the bus_register() and bus_unregister()
> functions as Greg KH asked. Using the bus abstraction is not that
> hard. An example is e.g. available in the scsi_debug driver, namely
> the pseudo_lld_bus.
> 
> Thanks,
> 
> Bart.

Hi Bart,

Yes, I am talking the same here. Since platform device is not an option
for ufs-bsg, to make it a plain device we would need to do 
bus_register()
and bus_unregister(). And also do device_initialize() and device_add().

Thanks,
Can Guo.
