Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2CBC0044D
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 22:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D265206E7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 22:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgCKWNP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 18:13:15 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43790 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729518AbgCKWNP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 18:13:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C839D20424C;
        Wed, 11 Mar 2020 23:13:12 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LAjpja14CHev; Wed, 11 Mar 2020 23:13:05 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 60185204153;
        Wed, 11 Mar 2020 23:13:02 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH V2 05/13] pm80xx : Support for char device.
To:     Jinpu Wang <jinpu.wang@cloud.ionos.com>,
        Deepak Ukey <Deepak.Ukey@microchip.com>
Cc:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>, yuuzheng@google.com,
        Vikram Auradkar <auradkar@google.com>, vishakhavc@google.com,
        bjashnani@google.com, Radha Ramachandran <radha@google.com>,
        akshatzen@google.com
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
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <92a5ed32-eecb-dc1b-c485-1b691573f5de@interlog.com>
Date:   Wed, 11 Mar 2020 18:13:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAMGffEnHim9GD2F+7ueyoMWuYpdqghGGYqfLrWcAcN3WfXm_Ng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-11 1:08 p.m., Jinpu Wang wrote:
> On Tue, Jan 28, 2020 at 10:43 AM <Deepak.Ukey@microchip.com> wrote:
>>
>>
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On 22/01/2020 08:50, Deepak.Ukey@microchip.com wrote:
>>> -r--r--r-- 1 root root 4096 Jan 21 12:05 running_disparity_error_count
>>> ***
>>> -r--r--r-- 1 root root 4096 Jan 21 12:05 sas_address
>>> lrwxrwxrwx 1 root root    0 Jan 21 11:45 subsystem ->
>>> ../../../../../../../class/sas_phy
>>> -r--r--r-- 1 root root 4096 Jan 21 12:05 target_port_protocols
>>> -rw-r--r-- 1 root root 4096 Jan 21 11:45 uevent
>>>
>>> Maybe the other stuff provided in the patches are useful, I don't know.
>>> But debugfs seems better for that.
>>>
>>>        - 0006-pm80xx-sysfs-attribute-for-number-of-phys
>>>        - 0007-pm80xx-IOCTL-functionality-to-get-phy-status gets things like Programmed Link Rate, Negotiated Link Rate, PHY Identifier
>>>        - 0008-pm80xx-IOCTL-functionality-to-get-phy-error provides other things like Invalid Dword Error Count, Disparity Error Count
>>>        - Thanks for addressing it. We can get this info from /sys/class/sas_phy and /sys/class/sas_port so we will drop these above mentioned three patches from the next              - patch series.
>>>
> 
>>>
>>>        - 0009-pm80xx-IOCTL-functionality-for-GPIO
>>>        - 0013-pm80xx-IOCTL-functionality-for-TWI-device
>>>        - For the above patches management utility passes command specific information to driver through IOCTL structure, which used by driver to frame the command and         - send to FW.  We are using the IOCTL interface for the same. Please let us know your thought.
>>
>> So I specifically questioned the SGPIO patch and why it would have an IOCTL, as this function is supported in kernel libsas/SAS transport code as an SMP function.
>>>   Thank you for your suggestions. We will make use of function supported in libsas.
> 
> So basically you only need IOCTL for GPIO and TWI devices, others can
> implement via libsas interface or from sysfs directly.
> 
> I would like to suggest you do send out other changes without the
> IOCTL parts first, and consider again Is it really needed by the user
> to control GPIO and TWI, and if there is other way to do it?
> 
> Sorry, I don't have a better suggestion!

LSI SAS HBAs (LSI now owned by Broadcom) implement an internal ** SMP
target. It can be seen here:

# ls /dev/bsg
3:0:0:0  3:0:3:0  8:0:0:0  8:0:0:3	     end_device-3:1    expander-3:0
3:0:1:0  4:0:0:0  8:0:0:1  8:0:0:4	     end_device-3:1:0  expander-3:1
3:0:2:0  7:0:0:0  8:0:0:2  end_device-3:0:1  end_device-3:2    sas_host3

It is the last device node: "sas_host3". How do I know it is a SMP target?
Because this works:

# smp_read_gpio /dev/bsg/sas_host3
Read GPIO register response:
   GPIO_CFG[0]:
     version: 0
     GPIO enable: 1
     cfg register count: 2
     gp register count: 1
     supported drive count: 16

When you work out what LSI are doing with this, perhaps you could write
an article about it and make it publicly available.
It is always a good idea to see how your competitors solve problems :-)

Doug Gilbert


** I call it "internal" because it is not seen when doing a SMP DISCOVER
    on a SAS expander to which that SAS HBA is connected.
