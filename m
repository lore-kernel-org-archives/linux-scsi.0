From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: aacaid: Difference in `/sys` between 4.14.13 andout of tree driver
 55022 (was: Driver version for PMC Adaptec HBA in Linux and from vendor)
Date: Mon, 15 Jan 2018 21:22:32 +0100
Message-ID: <aa4c89d2-8e46-1a77-a90b-9d2bd4bfa9cd@molgen.mpg.de>
References: <f09c20d4-dd38-d619-3b31-7782f9b5c0de@molgen.mpg.de>
 <4D8E82A446BF54499747901DBDEB737A7B8C48D8@avsrvexchmbx2.microsemi.net>
 <71e28514-9832-5fae-ba69-1a6cbe5ae269@molgen.mpg.de>
 <759acea897474b7798476133896a29d5@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37043 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750716AbeAOUWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jan 2018 15:22:35 -0500
In-Reply-To: <759acea897474b7798476133896a29d5@microsemi.com>
Content-Language: de-DE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>
Cc: linux-scsi@vger.kernel.org, it+linux-scsi@molgen.mpg.de

Dear Raghava,


Am 18.12.2017 um 19:09 schrieb Raghava Aditya Renukunta:

>> -----Original Message----- From: Paul Menzel
>> [mailto:pmenzel@molgen.mpg.de] Sent: Saturday, December 16, 2017
>> 1:39 AM

[…]

>> Am 17.02.2017 um 20:29 schrieb Raghava Aditya Renukunta:

[…]

>>>> Searching the vendor Web site, there is *Linux Driver Source 
>>>> 1.2.1-53005* available for download [1].
>>> 
>>> The latest upstream driver version is 50740. We will be reaching
>>> version 53005 in couple of patch sets ( ~ 3).
>>> 
>> http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?id=96f6a6134766de0d42a98c7758736dde16e0add5
>> Thank you for the details. At our infrastructure we only want to
>> use LTS Linux kernels, and the latest in 4.14. So right now, Linux
>> 4.14.6 includes version 50834 [1], which is the same version
>> currently in Linus master branch (4.15-rc3). Is that save to use
>> with async mode, or are you aware of problems and we should always
>> use the latest out of tree driver, which is at version 55022 and
>> can be download from the Microsemi server [3].
> 
> Well at this point I am in the process of creating a patch set that
> solves a kdump regression issue(Should be out before the new year),
> other than that the upstream driver is pretty much up to date. If
> kdump support is a must  for you I would recommend that  55022 be
> used.
We tried Linux 4.14.13, and noticed a difference. My colleague commented 
as below [1].

> Here is the location info of the missing sys-fs parts
> short way, where as the `device` part is missing:
> ```
> #ls -la /sys/class/enclosure/7:0:80:0/Disk001
> drwxr-xr-x  3 root system    0 Jan 10 13:08 .
> drwxr-xr-x 19 root system    0 Jan 10 13:07 ..
> -rw-r--r--  1 root system 4096 Jan 11 12:56 active
> lrwxrwxrwx  1 root system    0 Jan 10 13:08 device -> ../../../../../../../port-7:1/end_device-7:1/target7:0:65/7:0:65:0
> -rw-r--r--  1 root system 4096 Jan 11 12:56 fault
> -rw-r--r--  1 root system 4096 Jan 11 12:56 locate
> drwxr-xr-x  2 root system    0 Jan 11 12:56 power
> -rw-r--r--  1 root system 4096 Jan 11 12:56 power_status
> -r--r--r--  1 root system 4096 Jan 11 12:56 slot
> -rw-r--r--  1 root system 4096 Jan 11 12:56 status
> -r--r--r--  1 root system 4096 Jan 11 12:56 type
> -rw-r--r--  1 root system 4096 Jan 11 12:56 uevent
> ```
> The true location would be:
> ```
> /sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/host7/port-7:16/end_device-7:16/target7:0:80/7:0:80:0/enclosure/7:0:80:0/Disk001
> ```
Could you point me to a commit bring the in tree driver on par with the 
out of tree driver?

[…]


Kind regards,

Paul


>>>> [1] https://storage.microsemi.com/en-us/speed/raid/aac/linux/aacraid-linux-src-1_2_1-53005_tgz.php >> [2] 
https://elixir.free-electrons.com/linux/v4.14.6/source/drivers/scsi/aacraid/aacraid.h#L100
>> [3] https://storage.microsemi.com/en-us/downloads/linux_source/linux_source_code/productid=aha-1000-8e&dn=microsemi+adaptec+hba+1000-8e.php
[4] 
https://github.molgen.mpg.de/mariux64/bee-files/pull/571#issuecomment-4468
