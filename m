From: "ojab //" <ojab@ojab.ru>
Subject: Re: `rmmod mpt3sas` leads to backtraces 'fs/sysfs/group.c:237 sysfs_remove_group+0xa0/0xb0'
Date: Thu, 20 Oct 2016 10:57:19 +0000
Message-ID: <CAKzrAgSuTzHNgHpqjG1c8-0joiuMdBSWHmxJk7sFPoyejq8MZg@mail.gmail.com>
References: <71t90w18vb6cwdir7ikw2uj1.1476745939770@email.android.com> <607afd326622dac95727c5f55ee18f29@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:33581 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752843AbcJTK5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 06:57:21 -0400
Received: by mail-vk0-f65.google.com with SMTP id 83so2684997vkd.0
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2016 03:57:20 -0700 (PDT)
In-Reply-To: <607afd326622dac95727c5f55ee18f29@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra Basappa <chaitra.basappa@broadcom.com>
Cc: Laurence Oberman <loberman@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org

Hi,

ses module was not built/loaded in my tests (ENCLOSURE_SERVICES was
not set in the kernel config), so it's not the case.
Also Oracle bug is private, so I can't tell if it's really related.

//wbr ojab


On Thu, Oct 20, 2016 at 10:08 AM, Chaitra Basappa
<chaitra.basappa@broadcom.com> wrote:
> Hi Ojab,
>
> I would like to clarify that issue is not because of the below mentioned
> patch/ mpt3sas driver, its due to some SES module patch which we have see=
n
> earlier without merged/combined (mpt2sas & mpt3sas) driver too.
>
>
>
> So before unloading driver try unloading ses module(`rmmod ses`) and then
> unload driver, driver unloads successfully.
>
>
>
> This confirms issue is not because of driver , so ses module patches need=
s
> to be checked to identify the patch causing this issue.
>
>
>
> Also we have reported below Bug with oracle , which we observed on
> OEL6.8_UEK(4.1.12-37.4.1_x86_64)
>
> https://bugzilla.oracle.com/bugzilla/show_bug.cgi?id=3D15521
>
>
>
> Thanks,
>
> Chaitra
>
>
>
>
>
> From: mpt-fusionlinux.pdl@broadcom.com
> [mailto:mpt-fusionlinux.pdl@broadcom.com] On Behalf Of Laurence Oberman
> Sent: Tuesday, October 18, 2016 4:42 AM
> To: ojab; Johannes Thumshirn
> Cc: MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
> Subject: RE: `rmmod mpt3sas` leads to backtraces 'fs/sysfs/group.c:237
> sysfs_remove_group+0xa0/0xb0'
>
>
>
>
>
>
>
>
>
>
>
> Sent on the new Sprint Network from my Samsung Galaxy S=C2=AE4
>
>
>
> -------- Original message --------
> From: ojab <ojab@ojab.ru>
> Date: 10/17/2016 17:11 (GMT-05:00)
> To: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
> Subject: Re: `rmmod mpt3sas` leads to backtraces 'fs/sysfs/group.c:237
> sysfs_remove_group+0xa0/0xb0'
>
> On 2016/10/17 14:42, Johannes Thumshirn wrote:
>> On Sun, Oct 16, 2016 at 02:33:28PM +0000, ojab wrote:
>>
>> Hi Ojab,
>>
>> Do you have a known good kernel? If yes can you do a git bisect to see
>> which
>> commit introduces this?
>>
>> Thanks,
>> Johannes
>>
>
> The issue is reproducible from the start, i. e. from commit
>
> c84b06a48c4d8ac8270624453132f3fa1a4a0f9d mpt3sas: Single driver module
> which supports both SAS 2.0 & SAS 3.0 HBAs
>
> in which support for my HBA was added.
> Before that the same issue can be reproduced using mpt2sas module in
> kernels >=3D 4.1.
>
> Unfortunately earlier kernels fail to boot on my HW, so I can't
> investigate further.
>
> //wbr ojab
>
> I have one of these in my lab. I will investigate and try reproduce and
> track it down as soon as I get a chance.
>
>
>
> Thanks
>
>
