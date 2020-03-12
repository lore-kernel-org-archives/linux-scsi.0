Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62167C10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 10:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45DE720716
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 10:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgCLK6r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 06:58:47 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2553 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbgCLK6q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 06:58:46 -0400
Received: from lhreml701-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 12875E41F06CB2DA1C75;
        Thu, 12 Mar 2020 10:58:43 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml701-cah.china.huawei.com (10.201.108.42) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 12 Mar 2020 10:58:42 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 12 Mar
 2020 10:58:42 +0000
Subject: Re: [PATCH V2 05/13] pm80xx : Support for char device.
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Deepak Ukey <deepak.ukey@microchip.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>, <yuuzheng@google.com>,
        Vikram Auradkar <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, Radha Ramachandran <radha@google.com>,
        <akshatzen@google.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-6-deepak.ukey@microchip.com>
 <CAMGffEnc1sWgOB7PENtbBQUzJ6iRORHrJe4Y5FV1+WkgrhAwOg@mail.gmail.com>
 <yq17e1lk666.fsf@oracle.com>
 <MN2PR11MB3550E72F0521F873F52AF671EF0D0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <68e52d06-1fd2-770d-627a-7e8c79067282@huawei.com>
 <MN2PR11MB35509B0042BEE7BFBB707CA8EF0C0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <3e76b6e1-9c3d-2e5c-896e-f1af9a785fe5@huawei.com>
 <MN2PR11MB35505927EB38FFD749E535CBEF0A0@MN2PR11MB3550.namprd11.prod.outlook.com>
 <CAMGffEnHim9GD2F+7ueyoMWuYpdqghGGYqfLrWcAcN3WfXm_Ng@mail.gmail.com>
 <92a5ed32-eecb-dc1b-c485-1b691573f5de@interlog.com>
 <CAMGffEnxq9HTFZ3htbXMQoO4DQr5L+rOS5_KYUh2-edqFNWO1w@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <647fdd73-d4f5-efc3-a496-e161aa48f70a@huawei.com>
Date:   Thu, 12 Mar 2020 10:58:41 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAMGffEnxq9HTFZ3htbXMQoO4DQr5L+rOS5_KYUh2-edqFNWO1w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml722-chm.china.huawei.com (10.201.108.73) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/03/2020 08:49, Jinpu Wang wrote:
> On Wed, Mar 11, 2020 at 11:13 PM Douglas Gilbert <dgilbert@interlog.com> wrote:
>>
>> On 2020-03-11 1:08 p.m., Jinpu Wang wrote:
>>> On Tue, Jan 28, 2020 at 10:43 AM <Deepak.Ukey@microchip.com> wrote:
>>>>
>>>>
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>>>
>>>> On 22/01/2020 08:50, Deepak.Ukey@microchip.com wrote:
>>>>> -r--r--r-- 1 root root 4096 Jan 21 12:05 running_disparity_error_count
>>>>> ***
>>>>> -r--r--r-- 1 root root 4096 Jan 21 12:05 sas_address
>>>>> lrwxrwxrwx 1 root root    0 Jan 21 11:45 subsystem ->
>>>>> ../../../../../../../class/sas_phy
>>>>> -r--r--r-- 1 root root 4096 Jan 21 12:05 target_port_protocols
>>>>> -rw-r--r-- 1 root root 4096 Jan 21 11:45 uevent
>>>>>
>>>>> Maybe the other stuff provided in the patches are useful, I don't know.
>>>>> But debugfs seems better for that.
>>>>>
>>>>>         - 0006-pm80xx-sysfs-attribute-for-number-of-phys
>>>>>         - 0007-pm80xx-IOCTL-functionality-to-get-phy-status gets things like Programmed Link Rate, Negotiated Link Rate, PHY Identifier
>>>>>         - 0008-pm80xx-IOCTL-functionality-to-get-phy-error provides other things like Invalid Dword Error Count, Disparity Error Count
>>>>>         - Thanks for addressing it. We can get this info from /sys/class/sas_phy and /sys/class/sas_port so we will drop these above mentioned three patches from the next              - patch series.
>>>>>
>>>
>>>>>
>>>>>         - 0009-pm80xx-IOCTL-functionality-for-GPIO
>>>>>         - 0013-pm80xx-IOCTL-functionality-for-TWI-device
>>>>>         - For the above patches management utility passes command specific information to driver through IOCTL structure, which used by driver to frame the command and         - send to FW.  We are using the IOCTL interface for the same. Please let us know your thought.
>>>>
>>>> So I specifically questioned the SGPIO patch and why it would have an IOCTL, as this function is supported in kernel libsas/SAS transport code as an SMP function.
>>>>>    Thank you for your suggestions. We will make use of function supported in libsas.
>>>
>>> So basically you only need IOCTL for GPIO and TWI devices, others can
>>> implement via libsas interface or from sysfs directly.
>>>
>>> I would like to suggest you do send out other changes without the
>>> IOCTL parts first, and consider again Is it really needed by the user
>>> to control GPIO and TWI, and if there is other way to do it?
>>>
>>> Sorry, I don't have a better suggestion!
>>
>> LSI SAS HBAs (LSI now owned by Broadcom) implement an internal ** SMP
>> target. It can be seen here:
>>
>> # ls /dev/bsg
>> 3:0:0:0  3:0:3:0  8:0:0:0  8:0:0:3           end_device-3:1    expander-3:0
>> 3:0:1:0  4:0:0:0  8:0:0:1  8:0:0:4           end_device-3:1:0  expander-3:1
>> 3:0:2:0  7:0:0:0  8:0:0:2  end_device-3:0:1  end_device-3:2    sas_host3
>>
>> It is the last device node: "sas_host3". How do I know it is a SMP target?
>> Because this works:
>>
>> # smp_read_gpio /dev/bsg/sas_host3
>> Read GPIO register response:
>>     GPIO_CFG[0]:
>>       version: 0
>>       GPIO enable: 1
>>       cfg register count: 2
>>       gp register count: 1
>>       supported drive count: 16
>>

JFYI, that specific command is not implemented for libsas SMP host 
handler (see 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/libsas/sas_host_smp.c?h=v5.6-rc5#n278), 
but the write command should be ok

>> When you work out what LSI are doing with this, perhaps you could write
>> an article about it and make it publicly available.

Firmware magic...

>> It is always a good idea to see how your competitors solve problems :-)
> This sounds indeed a better solution, thanks for the info, Doug
> 
> @Deepak Ukey can you check if you guys can also do it this way?
> 
> Regards,
> Jack Wang
> .
> 

