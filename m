From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Driver 'sd' needs updating
Date: Sun, 21 Jun 2009 11:41:56 +0300
Message-ID: <4A3DF254.6020108@panasas.com>
References: <20090618075718.A768ED381D@pentland.suse.de> <1245382874.11739.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:15287
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750996AbZFUIl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Jun 2009 04:41:58 -0400
In-Reply-To: <1245382874.11739.1.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On 06/19/2009 06:41 AM, James Bottomley wrote:
> On Thu, 2009-06-18 at 09:57 +0200, Hannes Reinecke wrote:
>> If a SCSI ULD driver sets blk_queue_prep_rq(), it should clean it
>> up itself on remove(), and not from the bus callbacks. This
>> removes the need to hook into bus->remove(), which should not
>> be used at the same time as driver->remove().
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>> ---
>>  drivers/scsi/scsi_lib.c    |    1 +
>>  drivers/scsi/scsi_priv.h   |    1 -
>>  drivers/scsi/scsi_sysfs.c  |   17 -----------------
>>  drivers/scsi/sd.c          |    1 +
>>  drivers/scsi/sr.c          |    1 +
>>  include/scsi/scsi_driver.h |    1 +
>>  6 files changed, 4 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 30f3275..f3c4089 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1207,6 +1207,7 @@ int scsi_prep_fn(struct request_queue *q, struct request *req)
>>  		ret = scsi_setup_blk_pc_cmnd(sdev, req);
>>  	return scsi_prep_return(q, req, ret);
>>  }
>> +EXPORT_SYMBOL(scsi_prep_fn);
>>  
>>  /*
>>   * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
>> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
>> index fbc83be..1ade801 100644
>> --- a/drivers/scsi/scsi_priv.h
>> +++ b/drivers/scsi/scsi_priv.h
>> @@ -71,7 +71,6 @@ extern int scsi_init_queue(void);
>>  extern void scsi_exit_queue(void);
>>  struct request_queue;
>>  struct request;
>> -extern int scsi_prep_fn(struct request_queue *, struct request *);
>>  extern struct kmem_cache *scsi_sdb_cache;
>>  
>>  /* scsi_proc.c */
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index fa4711d..91482f2 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -420,29 +420,12 @@ static int scsi_bus_resume(struct device * dev)
>>  	return err;
>>  }
>>  
>> -static int scsi_bus_remove(struct device *dev)
>> -{
>> -	struct device_driver *drv = dev->driver;
>> -	struct scsi_device *sdev = to_scsi_device(dev);
>> -	int err = 0;
>> -
>> -	/* reset the prep_fn back to the default since the
>> -	 * driver may have altered it and it's being removed */
>> -	blk_queue_prep_rq(sdev->request_queue, scsi_prep_fn);
>> -
>> -	if (drv && drv->remove)
>> -		err = drv->remove(dev);
>> -
>> -	return 0;
>> -}
>> -
>>  struct bus_type scsi_bus_type = {
>>          .name		= "scsi",
>>          .match		= scsi_bus_match,
>>  	.uevent		= scsi_bus_uevent,
>>  	.suspend	= scsi_bus_suspend,
>>  	.resume		= scsi_bus_resume,
>> -	.remove		= scsi_bus_remove,
>>  };
>>  EXPORT_SYMBOL_GPL(scsi_bus_type);
>>  
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 878b17a..93c4bed 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2053,6 +2053,7 @@ static int sd_remove(struct device *dev)
>>  	struct scsi_disk *sdkp;
>>  
>>  	async_synchronize_full();
>> +	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
>>  	sdkp = dev_get_drvdata(dev);
> 
> This isn't really going to work ... you're using sdkp before it gets
> initialised ... did this actually get tested?
> 

I have tested the previous iteration heavily. But yes this looks like an
uncareful rebase fallout. The last two lines should just be exchanged.

> James
> 

Thanks
Boaz
