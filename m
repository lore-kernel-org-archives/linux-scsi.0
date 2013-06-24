From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 6/9] Make scsi_remove_host() wait until error handling
 finished
Date: Mon, 24 Jun 2013 12:53:34 +0200
Message-ID: <51C8252E.3090007@acm.org>
References: <51C81CBD.5070709@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:43059 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3FXKxi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 06:53:38 -0400
In-Reply-To: <51C81CBD.5070709@profitbricks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>

On 06/24/13 12:17, Jack Wang wrote:
>> @@ -646,14 +703,20 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
>>   static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
>>   {
>>          int rtn;
>> -       struct scsi_host_template *hostt = scmd->device->host->hostt;
>> +       struct Scsi_Host *host = scmd->device->host;
>> +       struct scsi_host_template *hostt = host->hostt;
>>
>>          if (!hostt->eh_device_reset_handler)
>>                  return FAILED;
>>
>> +       if (scsi_begin_eh(host))
>> +               return FAST_IO_FAIL;
>> +
>>          rtn = hostt->eh_device_reset_handler(scmd);
>>          if (rtn == SUCCESS)
>>                  __scsi_report_device_reset(scmd->device, NULL);
>> +       scsi_end_eh(host);
>> +
>>          return rtn;
>>   }
>
> As the new eh from Hannes haven't make it into mainline, maybe we still
> need also check scsi_try_to_abort_cmd?

I don't think such checks are necessary in scsi_try_to_abort_cmd(). 
scsi_remove_host() already waits until outstanding SCSI commands have 
finished. scsi_try_to_abort_cmd() only gets invoked if there are still 
one or more unfinished commands so scsi_try_to_abort_cmd() won't be 
invoked anymore after scsi_remove_host() has finished.

Bart.

