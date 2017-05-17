From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 07/22] scsi: hisi_sas: add the initialisation for
 pci-based controller
Date: Wed, 17 May 2017 14:03:20 +0100
Message-ID: <f613cd68-a0bd-8590-847f-6beee7516c55@huawei.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
 <1495018197-120535-8-git-send-email-john.garry@huawei.com>
 <CAK8P3a1ML8=3WerLt1GNRD+4k4RtRQgW1AfNZhkf2qm_hyLfZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:6771 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753280AbdEQNEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 09:04:30 -0400
In-Reply-To: <CAK8P3a1ML8=3WerLt1GNRD+4k4RtRQgW1AfNZhkf2qm_hyLfZw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Xiang Chen <chenxiang66@hisilicon.com>

On 17/05/2017 13:33, Arnd Bergmann wrote:
> On Wed, May 17, 2017 at 12:49 PM, John Garry <john.garry@huawei.com> wrote:
>> > Add the code to initialise controller which is based on pci device
>> > in hisi_sas_pci_init.c
>> >
>> > The main functionality added is for probing and initialisation of
>> > the controller based on pci device.
>> >
>> > The core controller routines are still in hisi_sas_main.c; some
>> > common initialisation functions and structures are also exported from
>> > hisi_sas_main.c for pci init.
>> >
>> > For platform device-based controller, controller properties - like
>> > phy count - were read from the firmware. For pci-based controller this
>> > information is hard-coded in the driver, in new struct hisi_sas_pci_hw.
>> >
> Do you plan to add further PCI based front-ends besides the v3 driver
> in the future? If not, you can save one level of indirection here and merge
> pci_init.c into the v3 implementation.
>
>      Arnd

Hi Arnd,

I think for now, any hw revisions will be very closely based on v3. And, 
for future revisions, the driver has been well abstracted so we can 
still support any updated features in another version of hisi_sas_hw in 
v3 driver.

I actually kept v3 driver and pci_init.c separate as initially I thought 
we could merge v2 and v3 driver eventually. But with different 
functionality, register format, interrupts, I am not 100% confident. Now 
my only concern is that layout differences between v1/2 and v3 driver, 
but this is not critical. Anyway, I think we can merge them for now.

Cheers,
John
