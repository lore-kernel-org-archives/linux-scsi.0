From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Driver 'sd' needs updating
Date: Thu, 25 Jun 2009 20:20:19 +0300
Message-ID: <4A43B1D3.2030602@panasas.com>
References: <20090618075718.A768ED381D@pentland.suse.de> <1245382874.11739.1.camel@mulgrave.site> <4A3DF254.6020108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:26088
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752242AbZFYRUY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jun 2009 13:20:24 -0400
In-Reply-To: <4A3DF254.6020108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>

On 06/21/2009 11:41 AM, Boaz Harrosh wrote:
> On 06/19/2009 06:41 AM, James Bottomley wrote:
>> On Thu, 2009-06-18 at 09:57 +0200, Hannes Reinecke wrote:
>>> If a SCSI ULD driver sets blk_queue_prep_rq(), it should clean it
>>> up itself on remove(), and not from the bus callbacks. This
>>> removes the need to hook into bus->remove(), which should not
>>> be used at the same time as driver->remove().
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>>> ---
<snip>

>>> @@ -2053,6 +2053,7 @@ static int sd_remove(struct device *dev)
>>>  	struct scsi_disk *sdkp;
>>>  
>>>  	async_synchronize_full();
>>> +	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
>>>  	sdkp = dev_get_drvdata(dev);
>> This isn't really going to work ... you're using sdkp before it gets
>> initialised ... did this actually get tested?
>>
> 
> I have tested the previous iteration heavily. But yes this looks like an
> uncareful rebase fallout. The last two lines should just be exchanged.
> 

I have now *tested* with the above blk_queue_prep_rq() call just after the
"sdkp = dev_get_drvdata(dev);" 

Thanks
Boaz
---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 93c4bed..a6bb147 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2053,8 +2053,8 @@ static int sd_remove(struct device *dev)
 	struct scsi_disk *sdkp;
 
 	async_synchronize_full();
-	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
 	sdkp = dev_get_drvdata(dev);
+	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
