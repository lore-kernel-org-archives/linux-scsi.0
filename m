From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 2/4] scsi error: have scsi-ml call	change_queue_depth
 to handle QUEUE_FULL
Date: Mon, 15 Jun 2009 12:34:49 -0500
Message-ID: <4A368639.20701@cs.wisc.edu>
References: <12427123671020-git-send-email-michaelc@cs.wisc.edu> <12427123683166-git-send-email-michaelc@cs.wisc.edu> <1242712369913-git-send-email-michaelc@cs.wisc.edu> <12427123692457-git-send-email-michaelc@cs.wisc.edu> <20090612124849.GA8017@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56351 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404AbZFORe6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2009 13:34:58 -0400
In-Reply-To: <20090612124849.GA8017@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Smart <James.Smart@Emulex.Com>, Andrew Vasquez <linux-driver@qlogic.com>

On 06/12/2009 07:48 AM, Christof Schmitt wrote:
> On Tue, May 19, 2009 at 12:52:45AM -0500, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie<michaelc@cs.wisc.edu>
>>
>> This has scsi-ml call the change_queue_depth functions when
>> we get a QUEUE_FULL. It will only change the queue depth if
>> change_queue_depth is set because the LLD may have to
>> modify some internal resources, so I thought this would
>> be the safest route.
>>
>>
>> Signed-off-by: Mike Christie<michaelc@cs.wisc.edu>
>> ---
>>   drivers/scsi/scsi_error.c |   26 +++++++++++++++++++++++++-
>>   1 files changed, 25 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 0c2c73b..792644e 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -331,6 +331,27 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
>>   	}
>>   }
>>
>> +static void scsi_handle_queue_full(struct scsi_device *sdev)
>> +{
>> +	struct scsi_host_template *sht = sdev->host->hostt;
>> +	struct scsi_device *tmp_sdev;
>> +
>> +	if (!sht->change_queue_depth)
>> +		return;
>> +
>> +	shost_for_each_device(tmp_sdev, sdev->host) {
>> +		if (tmp_sdev->id != sdev->id)
>> +			continue;
>> +		/*
>> +		 * We do not know the number of commands that were at
>> +		 * the device when we got the queue full so we start
>> +		 * from the highest possible value and work our way down.
>> +		 */
>> +		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth - 1,
>> +					SCSI_QDEPTH_QFULL);
>> +	}
>> +}
>> +
>
> This was called because of a "queue full" for one SCSI device. Why do
> you decrement the queue depth for all SCSI devices on the same host
> and not only for one device?

It should actually do it for only the devices on the same target where 
the problem occurred. I copied the code from lpfc and qla2xxx and cannot 
remember the reason why this is done now.  I am ccing AndrewV and JamesS.
