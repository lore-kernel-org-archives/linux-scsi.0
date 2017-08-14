From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/6] hpsa: disable volume status check for older
 controller
Date: Mon, 14 Aug 2017 12:45:26 +0200
Message-ID: <80a0b409-63f0-5bce-6ce3-dd4367ba72fb@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
 <1502181315-102499-4-git-send-email-hare@suse.de>
 <c7e61ea8-696b-b00d-c804-c2297eee5d14@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752666AbdHNKpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Aug 2017 06:45:30 -0400
In-Reply-To: <c7e61ea8-696b-b00d-c804-c2297eee5d14@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 08/11/2017 03:23 PM, Tomas Henzl wrote:
> On 8.8.2017 10:35, Hannes Reinecke wrote:
>> Older Controller might not support volume status, so assume
>> the volume is online here.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/hpsa.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
>> index 7ca6078..4ebf5d4 100644
>> --- a/drivers/scsi/hpsa.c
>> +++ b/drivers/scsi/hpsa.c
>> @@ -3832,6 +3832,17 @@ static int hpsa_update_device_info(struct ctlr_info *h,
>>  		if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
>>  			hpsa_get_ioaccel_status(h, scsi3addr, this_device);
>>  		volume_offline = hpsa_volume_offline(h, scsi3addr);
>> +		if (volume_offline == HPSA_VPD_LV_STATUS_UNSUPPORTED &&
>> +		    !h->supported) {
>> +			/*
>> +			 * Older / unsupported controllers might not support
>> +			 * volume status
>> +			 */
>> +			dev_info(&h->pdev->dev,
>> +				 "C0:T%d:L%d Volume status not available, assuming online.\n",
>> +				 this_device->target, this_device->lun);
>> +			volume_offline = 0;
> 
> Hi,
> could we have here
> volume_offline = HPSA_LV_OK;
> instead ?

Hmm; rather not (for now).
At several places we're just checking for (!h->volume_offline); before
changing that toe HPSA_LV_OK we'd need to change all of them to
(h->volume_offline == HPSA_LV_OK) to avoid any issues here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
