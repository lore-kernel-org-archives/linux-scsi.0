From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 17/35] NCR5380: Move bus reset to host reset
Date: Sun, 25 Jun 2017 10:57:24 +0200
Message-ID: <2da97431-7d28-cbca-bc96-8eaa97df2b60@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
 <1498222975-71858-18-git-send-email-hare@suse.de>
 <alpine.LNX.2.00.1706241659120.25140@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37026 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751037AbdFYI51 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Jun 2017 04:57:27 -0400
In-Reply-To: <alpine.LNX.2.00.1706241659120.25140@nippy.intranet>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 06/24/2017 09:24 AM, Finn Thain wrote:
> On Fri, 23 Jun 2017, Hannes Reinecke wrote:
> 
>> The bus reset handler really is a host reset, so move it to
>> eh_bus_reset_handler.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/NCR5380.c      | 13 ++++++++-----
>>  drivers/scsi/arm/cumana_1.c |  2 +-
>>  drivers/scsi/arm/oak.c      |  2 +-
>>  drivers/scsi/atari_scsi.c   |  6 +++---
>>  drivers/scsi/dmx3191d.c     |  2 +-
>>  drivers/scsi/g_NCR5380.c    |  4 ++--
>>  drivers/scsi/mac_scsi.c     |  4 ++--
>>  drivers/scsi/sun3_scsi.c    |  4 ++--
>>  8 files changed, 20 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
>> index acc3344..e877fb9 100644
>> --- a/drivers/scsi/NCR5380.c
>> +++ b/drivers/scsi/NCR5380.c
>> @@ -2296,24 +2296,24 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
>>  
>>  
>>  /**
>> - * NCR5380_bus_reset - reset the SCSI bus
>> + * NCR5380_host_reset - reset the SCSI host
>>   * @cmd: SCSI command undergoing EH
>>   *
>>   * Returns SUCCESS
>>   */
>>  
>> -static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
>> +static int NCR5380_host_reset(struct scsi_cmnd *cmd)
>>  {
>>  	struct Scsi_Host *instance = cmd->device->host;
>>  	struct NCR5380_hostdata *hostdata = shost_priv(instance);
>>  	int i;
>>  	unsigned long flags;
>> -	struct NCR5380_cmd *ncmd;
>> +	struct NCR5380_cmd *ncmd, *tmp;
>>  
> 
> Do you need to introduce another temporary command pointer for this?
> 
>>  	spin_lock_irqsave(&hostdata->lock, flags);
>>  
>>  #if (NDEBUG & NDEBUG_ANY)
>> -	scmd_printk(KERN_INFO, cmd, __func__);
>> +	shost_printk(KERN_INFO, instance, __func__);
>>  #endif
>>  	NCR5380_dprint(NDEBUG_ANY, instance);
>>  	NCR5380_dprint_phase(NDEBUG_ANY, instance);
>> @@ -2331,7 +2331,10 @@ static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
>>  	 * commands!
>>  	 */
>>  
>> -	if (list_del_cmd(&hostdata->unissued, cmd)) {
>> +	list_for_each_entry_safe(ncmd, tmp, &hostdata->unissued, list) {
>> +		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
>> +
>> +		list_del_init(&ncmd->list);
>>  		cmd->result = DID_RESET << 16;
>>  		cmd->scsi_done(cmd);
>>  	}
> 
> For the sake of consistency, why didn't you use the same style that is 
> used later in this routine? I.e.
> 
> 	list_for_each_entry(ncmd, &hostdata->unissued, list) {
> 		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
> 
> 		cmd->result = DID_RESET << 16;
> 		cmd->scsi_done(cmd);
> 	}
> 	INIT_LIST_HEAD(&hostdata->unissued);
> 
> Either way,
> 
> Acked-by: Finn Thain <fthain@telegraphics.com.au>
> 
> Thanks.
> 
As the driver was switch to using embedded private data area we need to
ensure that we're not touching the data area anymore once we call
->done(); the command might be reused after that.
Once the command is reused the 'list' structure in the embedded data
area will be reset, resulting in a list corruption for the 'unissued' list.

But as we're running under EH here where we don't have asynchronous I/O
submissions I guess we should be fine with your suggestion.
Will be updating the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
