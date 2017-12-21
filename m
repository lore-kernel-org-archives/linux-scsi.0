From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] ses: Retry Power-on-reset check condition
Date: Thu, 21 Dec 2017 16:39:06 +0100
Message-ID: <6cf23b03-6552-c2b8-e29a-b887bd6517c9@suse.de>
References: <1513855354-86603-1-git-send-email-hare@suse.de>
 <1513855354-86603-4-git-send-email-hare@suse.de>
 <1513870157.3132.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40145 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752118AbdLUPjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 10:39:08 -0500
In-Reply-To: <1513870157.3132.5.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 12/21/2017 04:29 PM, James Bottomley wrote:
> On Thu, 2017-12-21 at 12:22 +0100, Hannes Reinecke wrote:
>> During startup any SCSI request might encounter a 'Power-on/reset'
>> sense code, which just can be retried.
>> In the case of ses it needs to be retried, otherwise ses will
>> errorneously detect this as a failure and not attach the driver.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/ses.c | 14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
>> index c1f96b0..9c8b3db 100644
>> --- a/drivers/scsi/ses.c
>> +++ b/drivers/scsi/ses.c
>> @@ -110,14 +110,20 @@ static int ses_recv_diag(struct scsi_device
>> *sdev, int page_code,
>>  		0
>>  	};
>>  	unsigned char recv_page_code;
>> +	int retries = SES_RETRIES;
>>  	struct scsi_sense_hdr sshdr;
>>  
>> +retry:
>>  	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
>> bufflen,
>> -				&sshdr, SES_TIMEOUT, SES_RETRIES,
>> NULL);
>> +				&sshdr, SES_TIMEOUT, retries, NULL);
>>  	if (unlikely(ret)) {
>> -		if (status_byte(ret) == CHECK_CONDITION &&
>> -		    sshdr.asc == 0x25 && sshdr.ascq == 0x00) {
>> -			ret = -ENODEV;
>> +		if (status_byte(ret) == CHECK_CONDITION) {
>> +			if (sshdr.asc == 0x29) {
>> +				retries--;
> 
> Nothing ever checks this, meaning the loop potentially never
> terminates.
> 
> We already have two templates for how to do this in sd.c ... on the
> other hand I can't see any use of scsi_execute/scsi_execute_req that
> actually want to see the ASC 29 conditions, so it might be better to
> integrate it into scsi_execute().
> 
I was wondering about the same, as the POR conditions are pretty
pointless (ATM; my friends from NetApp tend to disagree here :-)
So ok, I'll be moving it into scsi_execute_req().

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
