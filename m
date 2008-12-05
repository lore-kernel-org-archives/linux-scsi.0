From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc transport: pre-emptively terminate i/o upon	dev_loss_tmo
 timeout
Date: Fri, 5 Dec 2008 17:41:26 -0500
Message-ID: <4939AE16.5060506@emulex.com>
References: <1228497483.8775.1.camel@ogier> <4939AB67.5010509@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55577 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbYLEWkW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 17:40:22 -0500
In-Reply-To: <4939AB67.5010509@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Agreed - thanks Mike.

-- james s

Mike Christie wrote:
> James Smart wrote:
>> diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
>> --- a/drivers/scsi/scsi_transport_fc.c        2008-10-18 10:32:52.000000000 -0400
>> +++ b/drivers/scsi/scsi_transport_fc.c        2008-12-05 12:13:54.000000000 -0500
>> @@ -3012,6 +3012,16 @@ fc_timeout_deleted_rport(struct work_str
>> @@ -3035,7 +3045,6 @@ fc_timeout_deleted_rport(struct work_str
>>        * went away and didn't come back - we'll remove
>>        * all attached scsi devices.
>>        */
>> -     spin_unlock_irqrestore(shost->host_lock, flags);
>>
>>       scsi_target_unblock(&rport->dev);
>>       fc_queue_work(shost, &rport->stgt_delete_work);
>>
> 
> We do not need this unblock call anymore. The added
> fc_terminate_rport_io will do this. I attached a patch that removes it
> for you.
> 
