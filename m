From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH] scsi: Set the minimum valid value of 'eh_deadline' as
 0
Date: Thu, 10 Oct 2013 16:46:19 +0800
Message-ID: <5256695B.9030007@cn.fujitsu.com>
References: <524C48AC.2010901@suse.de>  <1381304600-7862-1-git-send-email-renmx@cn.fujitsu.com> <1381321707.27183.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39069 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab3JJIpy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Oct 2013 04:45:54 -0400
In-Reply-To: <1381321707.27183.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, hare@suse.de
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, joern@logfs.org, james.smart@emulex.com, bvanassche@acm.org, roland@purestorage.com

Hi, Ewan, Hannes:

On 10/09/2013 08:28 PM, Ewan Milne wrote:
> On Wed, 2013-10-09 at 15:43 +0800, Ren Mingxin wrote:
>> The former minimum valid value of 'eh_deadline' is 1s, which means
>> the earliest occasion to shorten EH is 1 second later since a
>> command is failed or timed out. But if we want to skip EH steps
>> ASAP, we have to wait until the first EH step is finished. If the
>> duration of the first EH step is long, this waiting time is
>> excruciating. So, it is necessary to accept 0 as the minimum valid
>> value for 'eh_deadline'.
>>
>> According to my test, with Hannes' patchset 'New EH command timeout
>> handler' as well, the minimum IO time is improved from 73s
>> (eh_deadline = 1) to 43s(eh_deadline = 0) when commands are timed
>> out by disabling RSCN and target port.
>>
>> Another thing: scsi_finish_command() should be invoked if
>> scsi_eh_scmd_add() is returned on failure - let EH finish those
>> commands.
>>
>> Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
>> ---
>>   drivers/scsi/hosts.c      |   14 +++++++++++---
>>   drivers/scsi/scsi_error.c |   40 +++++++++++++++++++++++++++-------------
>>   drivers/scsi/scsi_sysfs.c |   36 +++++++++++++++++++++++++-----------
>>   include/scsi/scsi_host.h  |    2 +-
>>   4 files changed, 64 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index f334859..e84123a 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -316,11 +316,11 @@ static void scsi_host_dev_release(struct device *dev)
>>   	kfree(shost);
>>   }
>>
>> -static unsigned int shost_eh_deadline;
>> +static unsigned int shost_eh_deadline = -1;
>
> This should probably be "static int shost_eh_deadline = -1;".
> And the range tests in scsi_host_alloc() and store_shost_eh_deadline()
> below should probably use INT_MAX rather than UINT_MAX.

The maximum value is decreased then.
Hannes, agree?

>>
>>   module_param_named(eh_deadline, shost_eh_deadline, uint, S_IRUGO|S_IWUSR);
>>   MODULE_PARM_DESC(eh_deadline,
>> -		 "SCSI EH timeout in seconds (should be between 1 and 2^32-1)");
>> +		 "SCSI EH timeout in seconds (should be between 0 and 2^32-1)");

And the description above should be modified as:

+		"SCSI EH timeout in seconds (should be between 0 and (2^31-1)/HZ)");


>>
>>
>>   static struct device_type scsi_host_type = {
>>   	.name =		"scsi_host",
>> @@ -394,7 +394,15 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>>   	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
>>   	shost->use_clustering = sht->use_clustering;
>>   	shost->ordered_tag = sht->ordered_tag;
>> -	shost->eh_deadline = shost_eh_deadline * HZ;
>> +	if (shost_eh_deadline == -1)
>> +		shost->eh_deadline = -1;
>> +	else if ((ulong) shost_eh_deadline * HZ>  UINT_MAX) {
>> +		printk(KERN_WARNING "scsi%d: eh_deadline %u exceeds the "
>> +		       "maximum, setting to %u\n",
>> +		       shost->host_no, shost_eh_deadline, UINT_MAX / HZ);
>> +		shost->eh_deadline = UINT_MAX / HZ * HZ;
>
> Just use "shost->eh_deadline = INT_MAX" here, leave off the "/ HZ * HZ".

Nod.

Thanks,
Ren
