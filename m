From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] Deferred disk spinup during system resume
Date: Fri, 07 Jan 2011 14:29:13 -0500
Message-ID: <4D276989.1000501@pobox.com>
References: <1294363626-28901-1-git-send-email-maksim.rayskiy@gmail.com> <20110107190644.GB7355@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60740 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1AGT3S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 14:29:18 -0500
Received: by vws16 with SMTP id 16so7255116vws.19
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jan 2011 11:29:17 -0800 (PST)
In-Reply-To: <20110107190644.GB7355@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: maksim.rayskiy@gmail.com, linux-scsi@vger.kernel.org

On 01/07/2011 02:06 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Jan 06, 2011 at 05:27:06PM -0800, maksim.rayskiy@gmail.com wrote:
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 7f77c67..0a9d400 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -4978,6 +4978,14 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
>>   	struct ata_link *link = qc->dev->link;
>>   	u8 prot = qc->tf.protocol;
>>
>> +	if (unlikely(link->eh_info.dev_action[qc->dev->devno]&
>> +			ATA_EH_VERIFY)) {
>> +		ata_port_schedule_eh(ap);
>> +		qc->scsidone(qc->scsicmd);
>> +		ata_qc_free(qc);
>> +		return;
>
> Hmm... this is weird.  You'll probably want to define a qc flag to
> indicate that the command is for verify and then schedule EH from
> ata_qc_issue().  That said, I'm not quite sure whether that's any
> better than scheduling EH from libata-scsi.  It's not like the
> boundary is clearly defined.  We already play with EH for other stuff
> from libata-scsi.  Jeff, do you think going through QCFLAG is
> important?

The boundary is clearly defined.  It's just not a file boundary :) 
libata-scsi contains EH callouts, but all of those are (a) sysfs 
attribute handling, (b) for callers located outside libata-scsi, or (c) 
the SCSI host scan.

The command translation and execution hot path is notably not in that list.

It is a clear laying violation to call out from the middle of a command 
translation, to directly execute some EH actions.  Remember, this is the 
stage at which we are QUEUEING commands.  There may be other commands in 
the queue, or currently executing.  If someone sends a READ VERIFY, we 
do not want to IMMEDIATELY schedule EH, we want to execute an EH action 
when the READ VERIFY command is ready to be executed.

It is quite incorrect to assume that READ VERIFY will only be sent to 
libata for execution during system resume.  The removal of READ VERIFY 
translation from ata_scsi_start_stop_xlat() is clearly wrong.

	Jeff



