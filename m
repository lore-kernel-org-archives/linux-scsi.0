From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] scsi_dh_alua: suppress errors from unsupported devices
Date: Thu, 10 Aug 2017 08:35:46 +0200
Message-ID: <53294f32-2cc8-c579-6c01-88a50c31879f@suse.de>
References: <1502182413-23560-1-git-send-email-hare@suse.de>
 <20170809160803.GB3365@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752467AbdHJGfs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 02:35:48 -0400
In-Reply-To: <20170809160803.GB3365@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/09/2017 06:08 PM, Christoph Hellwig wrote:
>> index 0962fd5..c3aea06 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -1100,6 +1100,8 @@ static int alua_bus_attach(struct scsi_device *sdev)
>>  	err = alua_initialize(sdev, h);
>>  	if (err == SCSI_DH_NOMEM)
>>  		ret = -ENOMEM;
>> +	if (err == SCSI_DH_DEV_UNSUPP)
>> +		ret = -ENODEV;
>>  	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
>>  		goto failed;
> 
> This screams for a switch statement..
> 
>> --- a/drivers/scsi/scsi_dh.c
>> +++ b/drivers/scsi/scsi_dh.c
>> @@ -133,8 +133,9 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
>>  
>>  	error = scsi_dh->attach(sdev);
>>  	if (error) {
>> -		sdev_printk(KERN_ERR, sdev, "%s: Attach failed (%d)\n",
>> -			    scsi_dh->name, error);
>> +		if (error != -ENODEV)
>> +			sdev_printk(KERN_ERR, sdev, "%s: Attach failed (%d)\n",
>> +				    scsi_dh->name, error);
>>  		module_put(scsi_dh->module);
> 
> OTOH why don't we just return the SCSI_DH_ values from ->attach?
> 
Hmm. Not a bad idea. Let's see how it turns out.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
