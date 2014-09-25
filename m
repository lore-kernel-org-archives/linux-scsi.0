From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 31/35] qla2xxx: Disable PCI device in shutdown handler.
Date: Wed, 24 Sep 2014 20:09:57 -0400
Message-ID: <alpine.OSX.2.00.1409242009220.310@administrators-macbook-pro.local>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com> <1411542518-2477-32-git-send-email-saurav.kashyap@qlogic.com> <20140924094858.1c51718d@jlaw-desktop.mno.stratus.com> <alpine.OSX.2.00.1409241134050.1504@administrators-macbook-pro.local>
 <20140924142325.2354188c@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:13978 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028AbaIYAK7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 20:10:59 -0400
In-Reply-To: <20140924142325.2354188c@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>, andrew.vasquez@qlogic.com, jbottomley@parallels.com, hch@lst.de, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org



On Wed, 24 Sep 2014, Joe Lawrence wrote:

> On Wed, 24 Sep 2014 11:37:55 -0400
> Chad Dupuis <chad.dupuis@qlogic.com> wrote:
>
>>
>>
>> On Wed, 24 Sep 2014, Joe Lawrence wrote:
>>
>>> On Wed, 24 Sep 2014 03:08:34 -0400
>>> Saurav Kashyap <saurav.kashyap@qlogic.com> wrote:
>>>
>>>> From: Chad Dupuis <chad.dupuis@qlogic.com>
>>>>
>>>> Disable the PCI device during shutdown to prevent any races with
>>>> other PCI code such as the AER handling code.
>>>>
>>>> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
>>>> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>>>> ---
>>>>  drivers/scsi/qla2xxx/qla_os.c |    3 +++
>>>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>>>> index 08c8e9c..70445bc 100644
>>>> --- a/drivers/scsi/qla2xxx/qla_os.c
>>>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>>>> @@ -3037,6 +3037,9 @@ qla2x00_shutdown(struct pci_dev *pdev)
>>>>  	qla2x00_free_irqs(vha);
>>>>
>>>>  	qla2x00_free_fw_dump(ha);
>>>> +
>>>> +	pci_disable_pcie_error_reporting(pdev);
>>>> +	pci_disable_device(pdev);
>>>>  }
>>>>
>>>>  /* Deletes all the virtual ports for a given ha */
>>>
>>> Hi Saurav,
>>>
>>> Just curious if there were any bug report instances to go along with
>>> this patch?  (Or a short explanation of the race.)
>>
>> Joe,
>>
>> The race here was during reboot after taking a crash dump.  We hit an AER
>> condition so the driver's AER handler is called after we've already
>> shutdown the adapter which causes us to try to free some already freed
>> structs.  To prevent this we disable the PCI function from the shutdown
>> handler.
>
> Hi Chad,
>
> Could the driver's AER handler get invoked after qla2x00_free_fw_dump,
> but before pci_disable_pcie_error_reporting (ie, is there anything to
> hold off .shutdown from running at the same time as the AER callbacks)?

No, not that I'm aware of.

>
> Thanks,
>
> -- Joe
>
