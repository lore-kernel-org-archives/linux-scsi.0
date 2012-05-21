From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/4] SCSI: send KOBJ_CHANGE when device is set to running
 v2
Date: Mon, 21 May 2012 10:32:25 -0500
Message-ID: <4FBA6009.8040407@cs.wisc.edu>
References: <1337317019-12001-1-git-send-email-michaelc@cs.wisc.edu> <1337317019-12001-5-git-send-email-michaelc@cs.wisc.edu> <4FBA2AD8.3040909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48492 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab2EUPdP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2012 11:33:15 -0400
In-Reply-To: <4FBA2AD8.3040909@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On 05/21/2012 06:45 AM, Hannes Reinecke wrote:
> On 05/18/2012 06:56 AM, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> If a device goes offline while the device is opened then closed
>> while it is still offline, udev will remove the /dev/disk/by-id
>> link. If the device comes back and is set to running, userspace
>> is not notified, and the by-id link will not get remade.
>>
>> This patch has scsi-ml send a KOBJ_CHANGE event so tools like udev
>> will know that it can being to use the device again. With this patch
>> udev see the KOBJ_CHANGE event and will reprobe the device and recreate
>> a /dev/disk/by-id link.
>>
>> v2
>> - Added SDEV_EVT_STATE_RUNNING evt type.
>>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> ---
>>  drivers/scsi/scsi_lib.c    |    9 +++++++++
>>  include/scsi/scsi_device.h |    2 ++
>>  2 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index d15b243..b54030d 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -2061,6 +2061,7 @@ int
>>  scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
>>  {
>>  	enum scsi_device_state oldstate = sdev->sdev_state;
>> +	int change_evt = 0;
>>  
>>  	if (state == oldstate)
>>  		return 0;
>> @@ -2079,6 +2080,11 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
>>  		switch (oldstate) {
>>  		case SDEV_OFFLINE:
>>  		case SDEV_TRANSPORT_OFFLINE:
>> +			/*
>> +			 * Notify userspace we can accept IO by sending
>> +			 * change event.
>> +			 */
>> +			change_evt = 1;
>>  		case SDEV_QUIESCE:
>>  		case SDEV_BLOCK:
>>  		case SDEV_CREATED:
>> @@ -2160,6 +2166,8 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
>>  
>>  	}
>>  	sdev->sdev_state = state;
>> +	if (change_evt)
>> +		sdev_evt_send_simple(sdev, SDEV_EVT_STATE_RUNNING, GFP_ATOMIC);
>>  	return 0;
>>  
>>   illegal:
>> @@ -2283,6 +2291,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
>>  	/* evt_type-specific initialization, if any */
>>  	switch (evt_type) {
>>  	case SDEV_EVT_MEDIA_CHANGE:
>> +	case SDEV_EVT_STATE_RUNNING:
>>  	default:
>>  		/* do nothing */
>>  		break;
> Hmm. So we're only getting notified if the device switched to OFFLINE?

No from one of the offlines to running.

> Weird. We'll get notified about this eventually anyway (aborting
> I/Os etc).
> I'd be more interested to get notified if the device becomes
> _available_ again, ie when entering RUNNING state. That's really
> hard to figure out without polling.

That is what is happening.

> 
> Care to add the 'change_evt' thing to the SDEV_RUNNING case
> statement, too?
> 
> Or am I missing something?
> 

You are :)  I hope :)
