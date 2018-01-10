From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: scsi: Always retry internal target error
Date: Wed, 10 Jan 2018 17:54:57 +0100
Message-ID: <7ddfeb16-cdbd-704a-2968-753ca1a74fb5@gmail.com>
References: <1508224263-130302-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38551 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965666AbeAJQzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 11:55:02 -0500
Received: by mail-wr0-f195.google.com with SMTP id 60so8958450wrl.5
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2018 08:55:01 -0800 (PST)
In-Reply-To: <1508224263-130302-1-git-send-email-hare@suse.de>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

> On 10/17/2017 09:11 AM, Hannes Reinecke wrote:
>> EMC Symmetrix is returning 'internal target error' for a variety
>> of conditions, most of which will be transient.
>> So we should always retry it, even with failfast set.
>> Otherwise we'd get spurious path flaps with multipath.
>> 
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/scsi_error.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>> 
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 5086489..5722c2e 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -497,6 +497,16 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
>>  		if (sshdr.asc == 0x10) /* DIF */
>>  			return SUCCESS;
>>  
>> +		if (!strncmp(scmd->device->vendor, "EMC", 3) &&
>> +		    !strncmp(scmd->device->model, "SYMMETRIX", 9) &&
>> +		    (sshdr.asc == 0x44) && (sshdr.ascq == 0x0)) {
>> +			/*
>> +			 * EMC Symmetrix returns 'Internal target failure'
>> +			 * for a variety of internal issues, all of which
>> +			 * can be recovered by retry.
>> +			 */
>> +			return ADD_TO_MLQUEUE;
>> +		}
>>  		return NEEDS_RETRY;
>>  	case NOT_READY:
>>  	case UNIT_ATTENTION:
>> @@ -1846,6 +1856,9 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
>>  		rtn = scsi_check_sense(scmd);
>>  		if (rtn == NEEDS_RETRY)
>>  			goto maybe_retry;
>> +		else if (rtn == ADD_TO_MLQUEUE)
>> +			/* Always enforce a retry for ADD_TO_MLQUEUE */
>> +			rtn = NEEDS_RETRY;
>>  		/* if rtn == FAILED, we have no sense information;
>>  		 * returning FAILED will wake the error handler thread
>>  		 * to collect the sense and redo the decide
>> 

On 10/18/2017 07:27 AM, Hannes Reinecke wrote:
>> Yeah, you are right.
>> Will be adding a blacklist entry for this.


Is there a new patch ongoing?
