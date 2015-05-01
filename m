From: Martin George <marting@netapp.com>
Subject: Re: [PATCH] sd: always retry READ CAPACITY for ALUA state transition
Date: Fri, 1 May 2015 18:09:35 +0530
Message-ID: <55437407.7060702@netapp.com>
References: <1430127309-90412-1-git-send-email-hare@suse.de> <1430255925.2181.16.camel@HansenPartnership.com> <55421F70.80102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx143.netapp.com ([216.240.21.24]:51670 "EHLO mx143.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbbEAMtH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 May 2015 08:49:07 -0400
In-Reply-To: <55421F70.80102@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 4/30/2015 5:56 PM, Hannes Reinecke wrote:
> On 04/28/2015 11:18 PM, James Bottomley wrote:
>> On Mon, 2015-04-27 at 11:35 +0200, Hannes Reinecke wrote:
>>> During ALUA state transitions the device might return
>>> a sense code 02/04/0a (Logical unit not accessible, asymmetric
>>> access state transition). As this is a transient error
>>> we should just retry the READ CAPACITY call until
>>> the state transition finishes and the correct
>>> capacity can be returned.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>   drivers/scsi/sd.c | 10 ++++++++++
>>>   1 file changed, 10 insertions(+)
>>>
>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>> index 79beebf..7178b05 100644
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -1987,6 +1987,11 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>>>   				 * give it one more chance */
>>>   				if (--reset_retries > 0)
>>>   					continue;
>>> +			if (sense_valid &&
>>> +			    sshdr.sense_key == NOT_READY &&
>>> +			    sshdr.asc == 0x04 && sshdr.ascq == 0x0A)
>>> +				/* ALUA state transition; always retry */
>>> +				continue;
>>>   		}
>>>   		retries--;
>>>
>>> @@ -2069,6 +2074,11 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>>>   				 * give it one more chance */
>>>   				if (--reset_retries > 0)
>>>   					continue;
>>> +			if (sense_valid &&
>>> +			    sshdr.sense_key == NOT_READY &&
>>> +			    sshdr.asc == 0x04 && sshdr.ascq == 0x0A)
>>> +				/* ALUA state transition; always retry */
>>> +				continue;
>>>   		}
>>>   		retries--;
>>>
>>
>> Got to say I really don't like this infinite retry possibility.  How
>> long does the ALUA transition take?  Would increasing retries work (or
>> even hijacking reset_retries)?
>>
> Well ... transitioning could be quite long (NetApp FAS has a
> transition timeout of 30 _minutes_ ...).

Well, actually NetApp FAS has a transition timeout of 2 minutes, and not 
30 minutes - as reported in the IMPLICIT TRANSITION TIMEOUT value in the 
extended RTPG data.

-Martin
