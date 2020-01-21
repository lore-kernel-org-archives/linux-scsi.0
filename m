Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03B2C2D0CE
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 12:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ADC224654
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 12:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgAUMjl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 07:39:41 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2290 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbgAUMjl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jan 2020 07:39:41 -0500
Received: from LHREML714-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 6B2EC5E283A5FBA13620;
        Tue, 21 Jan 2020 12:39:39 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML714-CAH.china.huawei.com (10.201.108.37) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 21 Jan 2020 12:39:38 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 21 Jan
 2020 12:39:38 +0000
Subject: Re: [PATCH V2 05/13] pm80xx : Support for char device.
To:     <Deepak.Ukey@microchip.com>, <martin.petersen@oracle.com>,
        <jinpu.wang@cloud.ionos.com>
CC:     <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-6-deepak.ukey@microchip.com>
 <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
 <yq17e1lk666.fsf@oracle.com>
 <MN2PR11MB3550E72F0521F873F52AF671EF0D0@MN2PR11MB3550.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <68e52d06-1fd2-770d-627a-7e8c79067282@huawei.com>
Date:   Tue, 21 Jan 2020 12:39:38 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <MN2PR11MB3550E72F0521F873F52AF671EF0D0@MN2PR11MB3550.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml741-chm.china.huawei.com (10.201.108.191) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/01/2020 05:33, Deepak.Ukey@microchip.com wrote:
> 
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Martin,
> 
>> Thanks for the commit message, looks much better. In the past, people
>> are against IOCTL, suggesting netlink, have you considered that?
> 
> Not so keen on adding more ioctls. It's 2020 and all...
> 
> Given the nature of the exported information, what's wrong with putting it in sysfs?
> -- We have some upcoming patches which uses this IOCTL interface and that cannot be supported through sysfs.
> Below are the patches in this patchset which requires IOCTL interface.
> 0007-pm80xx-IOCTL-functionality-to-get-phy-status
> 0008-pm80xx-IOCTL-functionality-to-get-phy-error

Please note that there definitely seems to be replication of what sysfs 
already provides in some of these patches:

- 0007-pm80xx-IOCTL-functionality-to-get-phy-status gets things like
Programmed Link Rate, Negotiated Link Rate, PHY Identifier

- 0008-pm80xx-IOCTL-functionality-to-get-phy-error provides other things 
like Invalid Dword Error Count, Disparity Error Count

See ***:

root@ubuntu:/sys/class/sas_phy/phy-0:0# ls -l
total 0
lrwxrwxrwx 1 root root    0 Jan 21 12:05 device -> ../../../phy-0:0
-r--r--r-- 1 root root 4096 Jan 21 12:05 device_type
-rw-r--r-- 1 root root 4096 Jan 21 12:05 enable ***
--w------- 1 root root 4096 Jan 21 12:05 hard_reset
-r--r--r-- 1 root root 4096 Jan 21 12:05 initiator_port_protocols
-r--r--r-- 1 root root 4096 Jan 21 12:05 invalid_dword_count ***
--w------- 1 root root 4096 Jan 21 12:05 link_reset
-r--r--r-- 1 root root 4096 Jan 21 12:05 loss_of_dword_sync_count ***
-rw-r--r-- 1 root root 4096 Jan 21 12:05 maximum_linkrate ***
-r--r--r-- 1 root root 4096 Jan 21 12:05 maximum_linkrate_hw ***
-rw-r--r-- 1 root root 4096 Jan 21 12:05 minimum_linkrate ***
-r--r--r-- 1 root root 4096 Jan 21 12:05 minimum_linkrate_hw ***
-r--r--r-- 1 root root 4096 Jan 21 12:05 negotiated_linkrate ***
-r--r--r-- 1 root root 4096 Jan 21 11:58 phy_identifier ***
-r--r--r-- 1 root root 4096 Jan 21 12:05 phy_reset_problem_count ***
drwxr-xr-x 2 root root    0 Jan 21 12:05 power
-r--r--r-- 1 root root 4096 Jan 21 12:05 running_disparity_error_count ***
-r--r--r-- 1 root root 4096 Jan 21 12:05 sas_address
lrwxrwxrwx 1 root root    0 Jan 21 11:45 subsystem -> 
../../../../../../../class/sas_phy
-r--r--r-- 1 root root 4096 Jan 21 12:05 target_port_protocols
-rw-r--r-- 1 root root 4096 Jan 21 11:45 uevent

Maybe the other stuff provided in the patches are useful, I don't know. 
But debugfs seems better for that.

 > 0009-pm80xx-IOCTL-functionality-for-GPIO
 > 0010-pm80xx-IOCTL-functionality-for-SGPIO

I don't know why an ioctl is required here.

 > 0013-pm80xx-IOCTL-functionality-for-TWI-device

Thanks,
John
