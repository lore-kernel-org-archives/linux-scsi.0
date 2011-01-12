From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC/PATCH] Deferred disk spinup during system resume
Date: Wed, 12 Jan 2011 13:35:07 -0500
Message-ID: <4D2DF45B.5010101@pobox.com>
References: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com> <20110112112142.GA9610@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52416 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1ALSfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jan 2011 13:35:13 -0500
Received: by vws16 with SMTP id 16so305163vws.19
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2011 10:35:12 -0800 (PST)
In-Reply-To: <20110112112142.GA9610@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: maksim.rayskiy@gmail.com, linux-scsi@vger.kernel.org

On 01/12/2011 06:21 AM, Tejun Heo wrote:
> Hello, Maksim, Jeff.
>
> On Tue, Jan 11, 2011 at 05:24:17PM -0800, maksim.rayskiy@gmail.com wrote:
>> @@ -4978,6 +4978,13 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
>>   	struct ata_link *link = qc->dev->link;
>>   	u8 prot = qc->tf.protocol;
>>
>> +	if (unlikely(qc->flags&  ATA_QCFLAG_VERIFY)) {
>> +		ata_port_schedule_eh(ap);
>> +		qc->scsidone(qc->scsicmd);
>> +		ata_qc_free(qc);
>> +		return;
>
> I still prefer the original patch where EH is scheduled from the
> translation layer.  This seems unnecessarily intrusive to me.  As I
> wrote before, it's not like we have a clean translation anyway and I
> think this better fits as impedance matching code in the translation
> layer anyway.  But, that said, this is a rather ugly piece of code
> which is necessary just to work around the fact that we live under
> scsi, so as long as it works, one way or the other probably doesn't
> matter all that much (the reason why I prefer the previous one, as it
> doens't try to be pretty and just gets it done), so it's Jeff's call.

The previous patch breaks READ VERIFY translation for all cases -except- 
this one.

The bottom line is that this patch simply wants to trigger an ATA 
command, and return immediately, discarding the command results.  I'm 
not even sure a "run this command in background, and discard results" 
facility requires the EH.

	Jeff



