From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/3] scsi dh alua: handle report luns data changed in
 check sense callout
Date: Fri, 06 Feb 2009 12:04:40 -0600
Message-ID: <498C7BB8.5020302@cs.wisc.edu>
References: <12333564114078-git-send-email-michaelc@cs.wisc.edu> <12333564124151-git-send-email-michaelc@cs.wisc.edu> <12333564123194-git-send-email-michaelc@cs.wisc.edu> <498AF0C4.7070701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49080 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbZBFSE6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:04:58 -0500
In-Reply-To: <498AF0C4.7070701@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Ilgu Hong <ilgu.hong@promise.com>

Hannes Reinecke wrote:
> Hi Mike,
> 
> michaelc@cs.wisc.edu wrote:
>> From: Ilgu Hong <ilgu.hong@promise.com>
>>
>> When we switch controllers the Intel Multi-Flex reports
>> REPORTED_LUNS_DATA_HAS_CHANGED. This patch just has us
>> retry the command.
>>
>> Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c 
>> b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index 31e1df5..dba154c 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -461,6 +461,15 @@ static int alua_check_sense(struct scsi_device 
>> *sdev,
>>               */
>>              return ADD_TO_MLQUEUE;
>>          }
>> +        if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e) {
>> +            /*
>> +             * REPORTED_LUNS_DATA_HAS_CHANGED is reported
>> +             * when switching controllers on targets like
>> +             * Intel Multi-Flex. We can just retry.
>> +             */
>> +            return ADD_TO_MLQUEUE;
>> +        }
>> +
>>          break;
>>      }
>>  
> Hmm. We could as well always retry for Unit Attention; it's meant to be
> a temporary condition anyway so no harm in retrying.
> 

Hey, do you mean you want me to just do

case UNIT_ATTENTION:
	return ADD_TO_MLQUEUE;


? In scsi_error.c:scsi_check_sense we fail for

                 /*
                  * if the device is not started, we need to wake
                  * the error handler to start the motor
                  */
                 if (scmd->device->allow_restart &&
                     (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
                         return FAILED;
and in scsi_lib.c:scsi_io_compeltion we fail for

                         if (cmd->device->removable) {
                                 /* Detected disc change.  Set a bit
                                  * and quietly refuse further access.
                                  */
                                 cmd->device->changed = 1;
                                 scsi_end_request(cmd, -EIO, this_count, 1);
                                 return;
