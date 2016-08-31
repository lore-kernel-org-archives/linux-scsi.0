From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 03/17] smartpqi: simplify spanning
Date: Wed, 31 Aug 2016 15:30:08 +0200
Message-ID: <8ebaea6d-4cf7-2374-840c-60497ff2d957@redhat.com>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222986403.31214.11170219064850871397.stgit@brunhilda>
 <b620ec4f-9163-7c0f-a85b-7665dd811abc@redhat.com>
 <20160831131049.m24oxxz6jsjumxsh@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32830 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760221AbcHaNaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 09:30:13 -0400
In-Reply-To: <20160831131049.m24oxxz6jsjumxsh@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On 31.8.2016 15:10, Johannes Thumshirn wrote:
> On Wed, Aug 31, 2016 at 02:59:16PM +0200, Tomas Henzl wrote:
>> On 26.8.2016 18:44, Don Brace wrote:
>>> From: Kevin Barnett <kevin.barnett@microsemi.com>
>>>
>>> Removed the workaround for the transition to spanning.
>>>
>>> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
>>> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
>>> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
>>> Signed-off-by: Don Brace <don.brace@microsemi.com>
>>> ---
>>>  drivers/scsi/smartpqi/smartpqi_init.c |   38 +++++++++++++++++----------------
>>>  1 file changed, 20 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
>>> index 6eab38e..9922e31 100644
>>> --- a/drivers/scsi/smartpqi/smartpqi_init.c
>>> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
>>> @@ -3663,6 +3663,18 @@ static int pqi_validate_device_capability(struct pqi_ctrl_info *ctrl_info)
>>>  		return -EINVAL;
>>>  	}
>>>  
>>> +	if (!ctrl_info->inbound_spanning_supported) {
>>> +		dev_err(&ctrl_info->pci_dev->dev,
>>> +			"the controller does not support inbound spanning\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (ctrl_info->outbound_spanning_supported) {
>>> +		dev_err(&ctrl_info->pci_dev->dev,
>>> +			"the controller supports outbound spanning but this driver does not\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>>  	return 0;
>>>  }
>> This looks like you are dropping support for a probably older firmware devices,
>> is that necessary - can't you continue a keep the support with something similar to that
>> 'TEMPHACk' below ?
> The question is, if any of these older firmware devices ever left the
> Microsemi buildings. If not I _think_ it's save to drop it, as no real
> users are harmed.

Well yes, likely it was used only during development - in that case also
if all devices support inbound_spanning it is not needed to test at all and
that bit could have been used for anything else (it's too late now for this though.)
Also if Microsemi doesn't want support future devices with this driver
a better option is to not use PCI_ANY_ID in pci_device_id instead of testing
the outbound_spanning_supported.

All that is minor, so -

Reviewed-by: Tomas Henzl <thenzl@redhat.com>


>
> Byte,
>       Johannes


