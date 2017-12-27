From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/28] aacraid: Refactor for sas transport and bug fixes
Date: Wed, 27 Dec 2017 10:24:37 -0200
Message-ID: <9fbf3f17-3ead-301c-57be-e16945e34fb8@linux.vnet.ibm.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
 <c9163914-672f-29d5-d297-ff1f823a9dac@linux.vnet.ibm.com>
 <600c7bdfa91e48db83a886d56b2628c9@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750919AbdL0MYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Dec 2017 07:24:46 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vBRCO9sa002326
        for <linux-scsi@vger.kernel.org>; Wed, 27 Dec 2017 07:24:45 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2f4a6km70q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 27 Dec 2017 07:24:45 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Wed, 27 Dec 2017 07:24:44 -0500
In-Reply-To: <600c7bdfa91e48db83a886d56b2628c9@microsemi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Scott Benesh <scott.benesh@microsemi.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Tom White <tom.white@microsemi.com>

On 12/26/2017 11:27 PM, Raghava Aditya Renukunta wrote:
> [...]
>> I was thinking...if possible, and just in case you plan to send a V2
>> after Bart's comments (or any other future reviews this patchset gets),
>> how about splitting in 2 patchsets, one for bug fixes and the other for
>> improvements/foundation of sas support?
>>
>> It could help to speed-up the merge of bug fixes.
> 
> Hi Guilherme,
> It did cross my mind, but I wanted to get the sas transport and bug fixes in by 4.16. I thought
> that breaking the patches into 3 patch sets might not help with it.
> 

Yeah, makes sense in this case! Thanks for considering it :)
Cheers,


Guilherme

> Regards,
> Raghava Aditya
> 
>  
>> Thanks,
>>
>>
>> Guilherme
>>>
>>>  - Fixed a udev inquiry race condition
>>>  - Fixed a kdump hang issue which occurs in case of error recovery in kdump
>>>  - Made improvements to ioctl reset and reset_host sysfs reset paths
>>>  - Changed the code to retrieve lun information into stand alone functions.
>>>  - Merged container and hba hotplug event processing (device addition and
>>>    and removal into single function)
>>>  - Removed scsi_scan_host for safw devices and now explicitly add devices
>>>    retrieved from the fw.
>>>  - Reschedule scan in driver fails to retrieve lun information from fw.
>>>    (usually works in a few attempts)
>>>  - Rescan worker waits for any pending EH recovery before rescanning
>>>  - Do not trigger rescan worker in kdump kernel
>>>
>>> Raghava Aditya Renukunta (29):
>>>   scsi: aacraid: Fix udev inquiry race condition
>>>   scsi: aacraid: Do not attempt abort when Fw panicked
>>>   scsi: aacraid: Fix hang in kdump
>>>   scsi: aacraid: Do not remove offlined devices
>>>   scsi: aacraid: Fix ioctl reset hang
>>>   scsi: aacraid: Allow reset_host sysfs var to recover Panicked Fw
>>>   scsi: aacraid: Refactor reset_host store function
>>>   scsi: aacraid: Move code to wait for IO completion to shutdown func
>>>   scsi: aacraid: Create bmic submission function from bmic identify
>>>   scsi: aacraid: Change phy luns function to use common bmic function
>>>   scsi: aacraid: Refactor and rename to make mirror existing changes
>>>   scsi: aacraid: Add target setup helper function
>>>   scsi: aacraid: Untangle targets setup from report phy luns
>>>   scsi: aacraid: Move function around to match existing code
>>>   scsi: aacraid: Create helper functions to get lun info
>>>   scsi: aacraid: Save bmic phy information for each phy
>>>   scsi: aacraid: Add helper function to set queue depth
>>>   scsi: aacraid: Merge func to get container information
>>>   scsi: aacraid: Process hba and container hot plug events in single
>>>               function
>>>   scsi: aacraid: Added macros to help loop through known buses and targets
>>>   scsi: aacraid: Refactor resolve luns code and scsi functions
>>>   scsi: aacraid: Merge adapter setup with resolve luns
>>>   scsi: aacraid: Block concurrent hotplug event handling
>>>   scsi: aacraid: Use hotplug handling function in place of scsi_scan_host
>>>   scsi: aacraid: Reschedule host scan in case of failure
>>>   scsi: aacraid: Fix hang while scanning in eh recovery
>>>   scsi: aacraid: Skip schedule rescan in case of kdump
>>>   scsi: aacraid: Remove unused rescan variable
>>>   scsi: aacraid: Remove AAC_HIDE_DISK check in queue command
>>>
>>>  drivers/scsi/aacraid/aachba.c   | 479 +++++++++++++++++++++++++++----
>> ---------
>>>  drivers/scsi/aacraid/aacraid.h  |  52 ++++-
>>>  drivers/scsi/aacraid/commctrl.c |   6 +-
>>>  drivers/scsi/aacraid/comminit.c |  49 +++-
>>>  drivers/scsi/aacraid/commsup.c  | 224 ++++++++++---------
>>>  drivers/scsi/aacraid/linit.c    |  23 +-
>>>  6 files changed, 561 insertions(+), 272 deletions(-)
>>>
> 
