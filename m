From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v12 6/6] Avoid re-enabling I/O after the transport became
 offline
Date: Mon, 01 Jul 2013 14:05:58 +0200
Message-ID: <51D170A6.7060005@acm.org>
References: <51CC5176.90609@acm.org> <51CC52EB.9040900@acm.org> <51D13D8C.9070407@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:41782 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3GAMGC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jul 2013 08:06:02 -0400
In-Reply-To: <51D13D8C.9070407@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On 07/01/13 10:27, Hannes Reinecke wrote:
> On 06/27/2013 04:57 PM, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index dfbaa34..666b741 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -959,14 +959,16 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>   {
>>   	struct Scsi_Host *shost = sdev->host;
>>   	struct device *dev = &sdev->sdev_gendev;
>> +	enum scsi_device_state sdev_state;
>>   	int res;
>>   
>>   	if (sdev->is_visible) {
>>   		spin_lock_irq(shost->host_lock);
>> +		sdev_state = sdev->sdev_state;
>>   		res = scsi_device_set_state(sdev, SDEV_CANCEL);
>>   		spin_unlock_irq(shost->host_lock);
>>   
>> -		if (res != 0)
>> +		if (res != 0 && sdev_state != SDEV_TRANSPORT_OFFLINE)
>>   			return;
>>   
>>   		bsg_unregister_queue(sdev->request_queue);
>>
> Hmm. This is really subtle. Do you mind adding inserting a comment
> here on why this is required?

How about inserting the following comment just above the last if-statement
in the code cited above ?

		/*
		 * The transition from SDEV_TRANSPORT_OFFLINE into SDEV_CANCEL
		 * is not allowed since this transition would re-enable I/O. If
		 * the device state was already SDEV_TRANSPORT_OFFLINE,
		 * proceed with device removal.
		 */

Bart.
