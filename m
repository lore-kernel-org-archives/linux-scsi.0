From: "S, Venkatraman" <svenkatr@ti.com>
Subject: Re: [PATCH V3 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Thu, 26 Jul 2012 17:05:02 +0530
Message-ID: <CANfBPZ97FvXnx0JtsDtDhYRxB=f38NsxcvvO4UOqN_sOYe_Rcg@mail.gmail.com>
References: <1343292170-2599-1-git-send-email-vinholikatti@gmail.com>
 <CANfBPZ-amdTBXMbj0E2SrMHBjHFnd8cuC4ASoygkbXC+5oeAGg@mail.gmail.com> <CAKVbJB96Y87=a1dOskYX472Um3w=_orQWN19_Yj+iRp7js9Anw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:45231 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab2GZLfX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2012 07:35:23 -0400
Received: by obbeh20 with SMTP id eh20so2304661obb.10
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jul 2012 04:35:22 -0700 (PDT)
In-Reply-To: <CAKVbJB96Y87=a1dOskYX472Um3w=_orQWN19_Yj+iRp7js9Anw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinayak holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com

On Thu, Jul 26, 2012 at 4:42 PM, vinayak holikatti
<vinholikatti@gmail.com> wrote:
> On Thu, Jul 26, 2012 at 4:02 PM, S, Venkatraman <svenkatr@ti.com> wrote:
>> On Thu, Jul 26, 2012 at 2:12 PM, Vinayak Holikatti
>> <vinholikatti@gmail.com> wrote:
>>> This patch set adds following features
>>>  - Seggregate PCI specific code in ufshcd.c
>>>  - Adds PCI glue driver ufshcd-pci.c and ufshcd.c become core module
>>>  - Adds Platform glue driver ufshcd-pltfrm.c
>>>  - Update correct transfer size in Command UPIU
>>>
>>> Vinayak Holikatti (4):
>>>   [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
>>>   [SCSI] drivers/scsi/ufs: Separate PCI code into glue driver
>>>   [SCSI] ufs: Add Platform glue driver for ufshcd
>>>   [SCSI] ufs: Correct the expected data transfer size
>>>
>>>  drivers/scsi/ufs/Kconfig         |   37 +++-
>>>  drivers/scsi/ufs/Makefile        |    2 +
>>>  drivers/scsi/ufs/ufshcd-pci.c    |  228 ++++++++++++++++++++
>>>  drivers/scsi/ufs/ufshcd-pltfrm.c |  222 ++++++++++++++++++++
>>>  drivers/scsi/ufs/ufshcd.c        |  422 ++++++--------------------------------
>>>  drivers/scsi/ufs/ufshcd.h        |  206 +++++++++++++++++++
>>>  drivers/scsi/ufs/ufshcd_common.h |   53 +++++
>>>  7 files changed, 813 insertions(+), 357 deletions(-)
>>
>> Two minor observations..
>> 1) If both pci and platform have to do the exact same thing in their
>> _suspend() and _resume() routines, perhaps there is scope for making
>> them as common (the steps outlined in them should be done in core
>> ufshcd) ?
> Both will not have to do the exact same thing. We have plan to implement
> ufshcd_suspend and ufshcd_resume which will be generic and will be part
> of ufshcd core, as you said.

Thanks. The comments in the driver files don't reflect this; it'd be
wise to create
the placeholder for core_suspend()/resume() in ufshcd.c, instead of
the platform drivers.

>>
>> 2) Need to include ufshcd_common.h in ufshcd.c so that the prototypes
>> are supplied for the exported functions.
> Thank you, I will make necessary changes in next version of patches.
>
