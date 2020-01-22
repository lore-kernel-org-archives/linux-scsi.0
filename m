Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F36BC2D0DB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 12:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CD7F24688
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 12:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAVMjC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 07:39:02 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2294 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbgAVMjB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jan 2020 07:39:01 -0500
Received: from lhreml705-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 228F321DC0A0462B96CE;
        Wed, 22 Jan 2020 12:39:00 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml705-cah.china.huawei.com (10.201.108.46) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 22 Jan 2020 12:38:59 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 22 Jan
 2020 12:38:59 +0000
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
 <68e52d06-1fd2-770d-627a-7e8c79067282@huawei.com>
 <MN2PR11MB35509B0042BEE7BFBB707CA8EF0C0@MN2PR11MB3550.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <3e76b6e1-9c3d-2e5c-896e-f1af9a785fe5@huawei.com>
Date:   Wed, 22 Jan 2020 12:38:58 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <MN2PR11MB35509B0042BEE7BFBB707CA8EF0C0@MN2PR11MB3550.namprd11.prod.outlook.com>
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

On 22/01/2020 08:50, Deepak.Ukey@microchip.com wrote:
> -r--r--r-- 1 root root 4096 Jan 21 12:05 running_disparity_error_count ***
> -r--r--r-- 1 root root 4096 Jan 21 12:05 sas_address
> lrwxrwxrwx 1 root root    0 Jan 21 11:45 subsystem ->
> ../../../../../../../class/sas_phy
> -r--r--r-- 1 root root 4096 Jan 21 12:05 target_port_protocols
> -rw-r--r-- 1 root root 4096 Jan 21 11:45 uevent
> 
> Maybe the other stuff provided in the patches are useful, I don't know.
> But debugfs seems better for that.
> 
> 	- 0006-pm80xx-sysfs-attribute-for-number-of-phys
> 	- 0007-pm80xx-IOCTL-functionality-to-get-phy-status gets things like Programmed Link Rate, Negotiated Link Rate, PHY Identifier
> 	- 0008-pm80xx-IOCTL-functionality-to-get-phy-error provides other things like Invalid Dword Error Count, Disparity Error Count
> 	- Thanks for addressing it. We can get this info from /sys/class/sas_phy and /sys/class/sas_port so we will drop these above mentioned three patches from the next 		- patch series.
> 
>   > 0009-pm80xx-IOCTL-functionality-for-GPIO
>   > 0010-pm80xx-IOCTL-functionality-for-SGPIO
> 
> I don't know why an ioctl is required here.
> 
>   > 0013-pm80xx-IOCTL-functionality-for-TWI-device
> 
> 	- 0009-pm80xx-IOCTL-functionality-for-GPIO
> 	- 0010-pm80xx-IOCTL-functionality-for-SGPIO
> 	- 0013-pm80xx-IOCTL-functionality-for-TWI-device
> 	- For the above patches management utility passes command specific information to driver through IOCTL structure, which used by driver to frame the command and 	- send to FW.  We are using the IOCTL interface for the same. Please let us know your thought.

So I specifically questioned the SGPIO patch and why it would have an 
IOCTL, as this function is supported in kernel libsas/SAS transport code 
as an SMP function.

For the GPIO IOCTL, could you use register a gpio driver to provide a 
gpiolib sysfs?

As for TWI, it seems to be for serial EEPROM, so you could ask these 
experts about how to handle it properly in the kernel for standard sysfs 
interfaces:

:~/linux$ ./scripts/get_maintainer.pl -f drivers/misc/eeprom/eeprom.c
Jean Delvare <jdelvare@suse.com> (maintainer:LEGACY EEPROM DRIVER)
Arnd Bergmann <arnd@arndb.de> (supporter:CHAR and MISC DRIVERS)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:CHAR and MISC 
DRIVERS)

Thanks,
John
