From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [RFC PATCH 0/4] Add support for pci/non-pci probing for UFS
Date: Tue, 15 May 2012 14:29:52 +0900
Message-ID: <CAKYAXd804PFf4=uUboVWUz5+oNb93KbKj7k1SUm5T=yzes2aHA@mail.gmail.com>
References: <1336993712-9111-1-git-send-email-girish.shivananjappa@linaro.org>
	<CAKYAXd-bng9OzQUVgrWXTkvdAMPXgHK6copKaAYwMCXFokhEWA@mail.gmail.com>
	<CAGxe1ZFbkRRuz93v5qfU7Am1N3briUMOxzxFybmv7k79cVp21Q@mail.gmail.com>
	<CAKYAXd-B1ejaY_NX+hPwiC9s5yC-0zvsbcAzuVnxNNt6m2UUsQ@mail.gmail.com>
	<CAGxe1ZENHPdEgx_XEQWkbG1MePAa-rT7esEcG-COtOk8+tT0WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62922 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2EOF3y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 01:29:54 -0400
Received: by wibhm6 with SMTP id hm6so2095017wib.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 May 2012 22:29:53 -0700 (PDT)
In-Reply-To: <CAGxe1ZENHPdEgx_XEQWkbG1MePAa-rT7esEcG-COtOk8+tT0WQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org

2012/5/15, Girish K S <girish.shivananjappa@linaro.org>:
> On 15 May 2012 09:02, Namjae Jeon <linkinjeon@gmail.com> wrote:
>> 2012/5/15, Girish K S <girish.shivananjappa@linaro.org>:
>>> Sorry ,
>>> I will rebase them to James' for-next treee. and resend
>>>
>>> thanks and regards
>>> Girish K S
>> There is one more thing.
>> You add your module author name.
>> But module author name should be only one per one module.
>> Your author name will be comflicted with origianl author(santosh,
>> vinayak).
>> plz try to check like this. maybe you can see your name instread
>> original author.
>> /sbin/modinfo ufshcd.ko
> If i build ufshcd.ko ufshcd-pci.ko ufshcd-pltfm.ko, then i can see
> only my name in the ufshcd-*.ko which is added by me. But not in
> ufshcd.ko
> Is it a problem?
ufsdhcd(interface core driver), ufshcd-pci and ufshcd-pltm drivers can
be divided as your suggestion.
And I think that it looks proper to me if you add original author to
ufschd.ko and ufschd-pci.ko.
And you can add your name to ufshcd-pltm.ko.
Because this driver is made by your idea.
Thanks.

>>
>> Thanks.
>>>
>>> On 15 May 2012 07:08, Namjae Jeon <linkinjeon@gmail.com> wrote:
>>>> Hi. Girish.
>>>>
>>>> There are hunks when I try to patch.
>>>> have you created patches on linux-next ?
>>>>
>>>> patching file drivers/scsi/ufs/ufs.h
>>>> patching file drivers/scsi/ufs/ufshcd.c
>>>> Hunk #10 FAILED at 826.
>>>> Hunk #13 FAILED at 929.
>>>> Hunk #15 succeeded at 1050 with fuzz 1 (offset 2 lines).
>>>> Hunk #17 succeeded at 1193 (offset 2 lines).
>>>> Hunk #19 succeeded at 1392 (offset 2 lines).
>>>> Hunk #21 succeeded at 1571 (offset 2 lines).
>>>> Hunk #23 succeeded at 1644 (offset 2 lines).
>>>> Hunk #25 FAILED at 1724.
>>>> 3 out of 25 hunks FAILED -- saving rejects to file
>>>> drivers/scsi/ufs/ufshcd.c.rej
>>>>
>>>> And after testing, have you sent this patch ?
>>>>
>>>> Thanks.
>>>>
>>>> 2012/5/14, Girish K S <girish.shivananjappa@linaro.org>:
>>>>> The existing UFS driver is tightly bound to only pci specific devices.
>>>>> It cannot work for non-pci devices.
>>>>>
>>>>> "SCSI: UFS: remove all pci code from core driver" patch removes all
>>>>> the
>>>>> pci specific code from the core driver to make it generic
>>>>>
>>>>> "SCSI: UFS: Add support for pci probe" patch adds a new file to
>>>>> support
>>>>> pci probing.
>>>>>
>>>>> "SCSI: UFS: Add platform support for ufs host controller" patch adds a
>>>>> new
>>>>> file to support platform device probe
>>>>>
>>>>> "SCSI: UFS: Added support of PCI/PLTFM for UFS" patch adds the menu
>>>>> option
>>>>> in Kconfig and Makefile to enable/disable the specific option
>>>>>
>>>>> Girish K S (4):
>>>>>   SCSI: UFS: remove all pci code from core driver
>>>>>   SCSI: UFS: Add support for pci probe
>>>>>   SCSI: UFS: Add platform support for ufs host controller
>>>>>   SCSI: UFS: Added support of PCI/PLTFM for UFS
>>>>>
>>>>>  drivers/scsi/ufs/Kconfig        |   32 +++-
>>>>>  drivers/scsi/ufs/Makefile       |    2 +
>>>>>  drivers/scsi/ufs/ufs.h          |  103 +++++++++++
>>>>>  drivers/scsi/ufs/ufshcd-pci.c   |  217 ++++++++++++++++++++++
>>>>>  drivers/scsi/ufs/ufshcd-pltfm.c |  191 ++++++++++++++++++++
>>>>>  drivers/scsi/ufs/ufshcd.c       |  377
>>>>> +++++++++------------------------------
>>>>>  6 files changed, 623 insertions(+), 299 deletions(-)
>>>>>  create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
>>>>>  create mode 100644 drivers/scsi/ufs/ufshcd-pltfm.c
>>>>>
>>>>> --
>>>>> 1.7.4.1
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>
>
