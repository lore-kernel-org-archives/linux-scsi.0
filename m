From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] [PATCH REGRESSION] alua: fix bus detach oops
Date: Thu, 29 Jan 2015 02:59:12 -0600
Message-ID: <54C9F660.8030704@cs.wisc.edu>
References: <1422438413-10273-1-git-send-email-michaelc@cs.wisc.edu> <54C9F324.1020102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40144 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbbA2I7V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:21 -0500
In-Reply-To: <54C9F324.1020102@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On 01/29/2015 02:45 AM, Hannes Reinecke wrote:
> On 01/28/2015 10:46 AM, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> This fixes a regression caused by commit
>> 1d5203284d8acbdfdf9b478d434450b34f338f28
>>
>> The bug is that the alua detach() callout will try to access the
>> sddev->scsi_dh_data, but we have already set it to NULL. This patch
>> moves the clearing of that field to after detach() is called.
>>
>> It looks like the regression was added during 3.19 development,
>> so it has not been in a released kernel, and so I did not cc
>> stable.
>>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>>
>> ---
>>  drivers/scsi/device_handler/scsi_dh.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
>> index 1dba62c..1efebc9 100644
>> --- a/drivers/scsi/device_handler/scsi_dh.c
>> +++ b/drivers/scsi/device_handler/scsi_dh.c
>> @@ -136,11 +136,12 @@ static void __detach_handler (struct kref *kref)
>>  	struct scsi_device_handler *scsi_dh = scsi_dh_data->scsi_dh;
>>  	struct scsi_device *sdev = scsi_dh_data->sdev;
>>  
>> +	scsi_dh->detach(sdev);
>> +
>>  	spin_lock_irq(sdev->request_queue->queue_lock);
>>  	sdev->scsi_dh_data = NULL;
>>  	spin_unlock_irq(sdev->request_queue->queue_lock);
>>  
>> -	scsi_dh->detach(sdev);
>>  	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", scsi_dh->name);
>>  	module_put(scsi_dh->module);
>>  }
>>
> Errm.
> 
> We save the contents first:
> 
>>  	struct scsi_device_handler *scsi_dh = scsi_dh_data->scsi_dh;
> 
> Then set the pointer to NULL:
> 
>>  	sdev->scsi_dh_data = NULL;
> 
> and then call 'detach':
> 
>> 	scsi_dh->detach(sdev);
> 
> So scsi_dh is _not_ NULL, hence it shouldn't oops.
> 

The problem is the actual detach() functions are the ones that are
accessing the NULL'd scsi_dh_data->scsi_dh pointer.

So above we have set sdev->scsi_dh_data to NULL and then are calling
detach(). In scsi_dh_alua.c, get_alua_data() we will then access the
NULL'd pointer.

static void alua_bus_detach(struct scsi_device *sdev)
{
        struct alua_dh_data *h = get_alua_data(sdev);

	if (h->buff && h->inq != h->buff)
                kfree(h->buff);
        kfree(h);

