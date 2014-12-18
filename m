From: Charles Chiou <ch1102chiou@gmail.com>
Subject: Re: [PATCH 4/4 v4] scsi:stex.c Add S3/S4 support
Date: Thu, 18 Dec 2014 11:09:02 +0800
Message-ID: <5492454E.8030203@gmail.com>
References: <548FCDC8.1010900@gmail.com> <1418722450.2448.3.camel@linux-0dmf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1418722450.2448.3.camel@linux-0dmf.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, ed.lin@promise.com, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 12/16/2014 05:34 PM, Oliver Neukum wrote:
> On Tue, 2014-12-16 at 14:14 +0800, Charles Chiou wrote:
>>   From f9d84df080c16097218092630db9b5df31d487b5 Mon Sep 17 00:00:00 2001
>> From: Charles Chiou <charles.chiou@tw.promise.com>
>> Date: Fri, 7 Nov 2014 10:15:18 +0800
>> Subject: [PATCH 4/4] scsi:stex.c Add S3/S4 support
>>
>> Add S3/S4 support, add .suspend and .resume function in pci_driver.
>>
>> Pegasus need 30~40 seconds to boot up. We don't want to OS wait
>> in .resume function. Create a thread to handle device boot up.
>
> I am sorry to be obnoxious, but this patch raises another
> question. What happens if the the system is suspended again
> while the work scheduled in resume is still running?
>
> Furthermore, what happens in the case of a PCI hotunplug while
> the work is still scheduled?
>
> 	Regards
> 		Oliver
>
>

Hi Oliver,
1. When OS is going to suspend again, .suspend function is active,
    and driver prepare a command send to device, while firmware is
    not ready. Firmware might loss this command and host can't go
    to sleep. I'll fix this issue by add while loop to wait device
    ready (polling hba->mu_status) and return -EBUSY if timeout.
    I'll fix this issue in the next version. Thanks for your help.

2. When hotplug, .remove function is active. Return all commands to OS
    with DID_NO_CONNECT status. And OS can remove the driver. After
    experiment, it works well.

BRS
Charles
