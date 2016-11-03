From: Duc Dang <dhdang@apm.com>
Subject: Re: Question about latest PM80xx driver
Date: Thu, 3 Nov 2016 14:15:33 -0700
Message-ID: <CADaLNDmFSgq+v_KeaVdF3TiS7vn=Amb3OfDE+8AHfYNFmhGREQ@mail.gmail.com>
References: <CADaLNDn4KvyEiNwkjFrAkEmKo6tOPU4rb971ObgCFuYjiQPKFg@mail.gmail.com>
 <CAMGffE=kDD-FrfCQGofWMpEUVrWjDTnRYSeLa0sEG7+qHWmp1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:35084 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758853AbcKCVQE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2016 17:16:04 -0400
Received: by mail-vk0-f41.google.com with SMTP id w194so51252449vkw.2
        for <linux-scsi@vger.kernel.org>; Thu, 03 Nov 2016 14:16:04 -0700 (PDT)
In-Reply-To: <CAMGffE=kDD-FrfCQGofWMpEUVrWjDTnRYSeLa0sEG7+qHWmp1w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: lindar_liu <lindar_liu@usish.com>, pmchba@pmcs.com, linux-scsi@vger.kernel.org, patches <patches@apm.com>

On Thu, Nov 3, 2016 at 1:34 AM, Jinpu Wang <jinpu.wang@profitbricks.com> wr=
ote:
> Hi Duc,
>
> On Thu, Nov 3, 2016 at 2:02 AM, Duc Dang <dhdang@apm.com> wrote:
>> Hi Jack, Lindar and All,
>>
>> I was testing Adaptec PMC-Sierra PM8018 SAS HBA [Series 7H] card
>> [9005:8088] with our ARM64 server SoC and occasionally saw a hang in
>> pm8001_pci_probe. It looks like the driver was trying to read nvmd
>> information (using get_nvmd_req) and wait for completion but the
>> completion never happens, so I got a kernel timeout trace:
>>
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message=
.
>> swapper/0       D ffffffc000086ec0     0     1      0 0x00000000
>> Call trace:
>> [<ffffffc000086ec0>] __switch_to+0x90/0xb0
>> [<ffffffc0009e2214>] __schedule+0x204/0x670
>> [<ffffffc0009e26c0>] schedule+0x40/0xb0
>> [<ffffffc0009e549c>] schedule_timeout+0x15c/0x1b0
>> [<ffffffc0009e32e0>] wait_for_common+0xa0/0x150
>> [<ffffffc0009e33a4>] wait_for_completion+0x14/0x20
>> [<ffffffc00059a9cc>] pm8001_pci_probe+0xb7c/0xd10
>> [<ffffffc00046c7f0>] pci_device_probe+0xa0/0x120
>> [<ffffffc00053ff7c>] driver_probe_device+0x12c/0x2e0
>> [<ffffffc0005401cc>] __driver_attach+0x9c/0xa0
>> [<ffffffc00053e0ac>] bus_for_each_dev+0x5c/0xa0
>> [<ffffffc00053f8e0>] driver_attach+0x20/0x30
>> [<ffffffc00053f428>] bus_add_driver+0x108/0x230
>> [<ffffffc0005409e0>] driver_register+0x60/0x100
>> [<ffffffc00046b5a0>] __pci_register_driver+0x40/0x50
>> [<ffffffc000de3610>] pm8001_init+0x70/0xa8
>> [<ffffffc000082904>] do_one_initcall+0x94/0x1b0
>> [<ffffffc000dbcab8>] kernel_init_freeable+0x150/0x1f4
>> [<ffffffc0009df2c0>] kernel_init+0x10/0xf0
>>
>> The current driver in kernel.org is 0.1.38, is this already the latest o=
ne?
>>
>> I saw in the Readme file of BIOS package in Microsemi website
>> (http://storage.microsemi.com/en-us/downloads/bios_fw/bios_fw_ver/produc=
tid=3Dasa-71605h&dn=3Dadaptec+71605h.php)
>> mentions below issue. Is the hang symptom similar to the one that I
>> saw?
>>
>> 5.14 FreeBSD Hangs when No Devices on HBA
>>         On FreeBSD systems, the OS fails to boot when no devices are
>>         connected to the HBAs.
>>
>>         WORKAROUND: Connect at least one device to the HBA to complete
>>         the boot process.
>>
>>
>> Regards,
>> Duc Dang.
>
> Likely it related to your hardware, maybe you don't have NVM device to
> save VPD related info, you can tweak that part, eg comment out
> #define PM8001_READ_VPD.

Thanks, Jack.

I will do more tests with PM8001_READ_VPD disabled. Will let you know
if I run into any issue.

By the way, the 'NVM device' you mentioned is a separate external
device that can be connect to the card via some cables (I see a small
header in the card), not in the card itself?

>
>
>
> --
> Mit freundlichen Gr=C3=BC=C3=9Fen,
> Best Regards,
>
> Jack Wang
>
> Linux Kernel Developer Storage
> ProfitBricks GmbH  The IaaS-Company.
Regards,
Duc Dang.
