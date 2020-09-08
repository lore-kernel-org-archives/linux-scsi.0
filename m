Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5197BC43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 14:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BD3122B49
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 14:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbgIHOqv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 10:46:51 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729057AbgIHO0J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Sep 2020 10:26:09 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 35D81842F1FA0CAFAAA7;
        Tue,  8 Sep 2020 15:06:44 +0100 (IST)
Received: from [127.0.0.1] (10.47.6.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 8 Sep 2020
 15:06:43 +0100
Subject: Re: [PATCH] scsi: take module reference during async scan
To:     <dgilbert@interlog.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tomas Henzl <thenzl@redhat.com>, <linux-scsi@vger.kernel.org>
References: <20200907154745.20145-1-thenzl@redhat.com>
 <1599500808.4232.19.camel@HansenPartnership.com>
 <a31b8640-307f-a14f-7cf8-7673fa8a4ff1@interlog.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <73166a16-1655-4cfd-6939-2878b357e422@huawei.com>
Date:   Tue, 8 Sep 2020 15:04:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <a31b8640-307f-a14f-7cf8-7673fa8a4ff1@interlog.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.6.45]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/09/2020 22:32, Douglas Gilbert wrote:

Hi Doug,

>   # insmod scsi_debug.ko
> 
> Gave errors like this:
> 
> [  140.115244] debugfs: Directory 'sde' with parent 'block' already 
> present!

As an aside, I thought that this issue was fixed...

> [  140.376426] debugfs: Directory 'sde' with parent 'block' already 
> present!
> [  140.420613] sd 3:0:0:0: [sde] tag#40 access beyond end of device
> [  140.426655] blk_update_request: I/O error, dev sde, sector 15984 op 
> 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
> [  140.437319] sd 3:0:0:0: [sde] tag#41 access beyond end of device
> [  140.443368] blk_update_request: I/O error, dev sde, sector 15984 op 
> 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> ...
> 
> Which wasn't the scsi_debug driver directly as it doesn't use debugfs. So
> I suspect something is rotten in the mid-level.
> 
> When I tried to replicate John's config I couldn't even boot my Ubuntu
> 20.04 based system (with a MKP kernel). Seemed to fail/lockup before any
> kernel prints came out to the serial port (yes, still useful), perhaps in
> initrd. I'm guessing another, non-SCSI module caused the lockup. So I
> gave up and turned off that config setting.

You can also try this hack locally (without enabling that config), if 
you like:

--->8---

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -496,6 +496,12 @@ static int really_probe(struct device *dev, struct 
device_driver *drv)
         int local_trigger_count = atomic_read(&deferred_trigger_count);
         bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
                            !drv->suppress_bind_attrs;

+       if (strcmp(drv->name, "sd") == 0)
+               test_remove = 1;
+       else if (strcmp(drv->name, "scsi_debug") == 0)
+               test_remove = 1;

---8<---

Cheers,
john

