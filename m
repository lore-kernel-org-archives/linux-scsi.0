From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 3/9] drivers: convert drivers setting the change_queue_depth
 callback
Date: Wed, 26 Aug 2009 16:55:58 -0500
Message-ID: <4A95AF6E.4010400@cs.wisc.edu>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>	 <20090826180331.23396.77062.stgit@vi1.jf.intel.com>	 <4A957CC3.6080605@garzik.org> <1251323413.9966.81.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46993 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbZHZV47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 17:56:59 -0400
In-Reply-To: <1251323413.9966.81.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Vasu Dev <vasu.dev@intel.com>, linux-scsi@vger.kernel.org

Vasu Dev wrote:
> On Wed, 2009-08-26 at 14:19 -0400, Jeff Garzik wrote:
>> On 08/26/2009 02:03 PM, Vasu Dev wrote:
>>> From: Mike Christie<michaelc@cs.wisc.edu>
>>>
>>> This is a simple port of the drivers setting a change_queue_depth
>>> callback but were not tracking queue fulls. In the patch I just have
>>> these LLDs adjust the queue depth if the user was requesting it.
>> Where is the doc describing how, and why, queue-full tracking occurs?
>>
> 
> The FCP-3 sec 4.2 states "If command queueing resources are unavailable
> in the logical unit when a command is received, the device server
> returns TASK SET FULL status or BUSY status in the FCP_RSP IU as
> specified by SAM-3". 
> 
> But this patch series is to move the QUEUE_FULL and then the ramp up
> code from libfc, qla2xxx and lpfc drives to scsi-ml, the libfc had
> QUEUE_FULL code to move up. This series is not to change how and why
> part in current queue_full tracking and that was better described in
> first RFC cover by Mike at
> http://www.spinics.net/lists/linux-scsi/msg35959.html .
> 
>>> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
>>> index 86a4058..fb28be9 100644
>>> --- a/drivers/ata/sata_nv.c
>>> +++ b/drivers/ata/sata_nv.c
>>> @@ -1963,7 +1963,7 @@ static int nv_swncq_slave_config(struct scsi_device *sdev)
>>>   	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
>>>
>>>   	if (strncmp(model_num, "Maxtor", 6) == 0) {
>>> -		ata_scsi_change_queue_depth(sdev, 1);
>>> +		ata_scsi_change_queue_depth(sdev, 1, SCSI_QDEPTH_SYSFS_REQ);
>>>   		ata_dev_printk(dev, KERN_NOTICE,
>>>   			"Disabling SWNCQ mode (depth %x)\n", sdev->queue_depth);
>>>   	}
>> This queue depth change was clearly not requested via sysfs...
>>
> 
> Can be renamed as SCSI_QDEPTH_DEFAULT or SCSI_QDEPTH_NONE reason. What
> do you think Mike ?

Yes. That is better.
