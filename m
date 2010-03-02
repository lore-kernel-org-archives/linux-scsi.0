From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Don't change direction flags in struct request.
Date: Tue, 02 Mar 2010 01:54:37 -0600
Message-ID: <4B8CC43D.9000108@cs.wisc.edu>
References: <1268976690-3386-1-git-send-email-hdasch@broadcom.com>	 <1268976690-3386-2-git-send-email-hdasch@broadcom.com> <1267507618.7936.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1267507618.7936.11.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hugh Daschbach <hdasch@broadcom.com>, Chandra Seetharaman <sekharan@us.ibm.com>, Eddie Williams <Eddie.Williams@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 03/01/2010 11:26 PM, James Bottomley wrote:
> On Thu, 2010-03-18 at 22:31 -0700, Hugh Daschbach wrote:
>> The EMC multipath device handler should not change the I/O direction
>> flags of its trespass command request.
>>
>> The CFQ elevator may BUG if the direction flags on an I/O request are
>> changed after allocation.  cfq_set_request() and cfq_put_request()
>> count READ and WRITE requests separately.  Changing the I/O request
>> direction after blk_get_request() allocates the request throws off
>> this CFQ accounting.
>
> This description doesn't really match what the problem seems to be
> below:
>
>> Signed-off-by: Hugh Daschbach<hdasch@broadcom.com>
>> ---
>>   drivers/scsi/device_handler/scsi_dh_emc.c |    8 ++++----
>>   1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
>> index 6196675..3709342 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
>> @@ -269,10 +269,12 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
>>   				unsigned char *buffer)
>>   {
>>   	struct request *rq;
>> +	int mode = READ;
>>   	int len = 0;
>>
>> -	rq = blk_get_request(sdev->request_queue,
>> -			(cmd == MODE_SELECT) ? WRITE : READ, GFP_NOIO);
>> +	if (cmd == MODE_SELECT || cmd == MODE_SELECT_10)
>> +		mode = WRITE;
>> +	rq = blk_get_request(sdev->request_queue, mode, GFP_NOIO);
>
> So the actual bug is failure to set WRITE for MODE_SELECT_10.
>

I think we have a fix for this and some len issues in that module that 
was sent here:
http://marc.info/?l=linux-scsi&m=125978574800618&w=2
