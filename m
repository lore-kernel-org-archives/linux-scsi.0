From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 4/5] scsi: make scsi_eh_scmd_add() always succeed
Date: Tue, 28 Feb 2017 13:16:37 +0100
Message-ID: <8f7296d4-e730-796b-4111-7c26fedb1d2b@suse.de>
References: <1487779650-1338-1-git-send-email-hare@suse.de>
 <1487779650-1338-5-git-send-email-hare@suse.de>
 <1488234448.2597.9.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35831 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751625AbdB1Mxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Feb 2017 07:53:44 -0500
In-Reply-To: <1488234448.2597.9.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jth@kernel.org" <jth@kernel.org>

On 02/27/2017 11:27 PM, Bart Van Assche wrote:
> On Wed, 2017-02-22 at 17:07 +0100, Hannes Reinecke wrote:
>>  	spin_lock_irqsave(shost->host_lock, flags);
>> +	WARN_ON(shost->shost_state != SHOST_RUNNING &&
>> +		shost->shost_state != SHOST_CANCEL &&
>> +		shost->shost_state != SHOST_RECOVERY &&
>> +		shost->shost_state != SHOST_CANCEL_RECOVERY);
>>  	if (scsi_host_set_state(shost, SHOST_RECOVERY))
>> -		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
>> -			goto out_unlock;
>> +		scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY);
> 
> Please issue a warning if the second scsi_host_set_state() fails. And once
> that failure triggers a warning, I don't think we need the newly added
> WARN_ON() statement anymore. Something else that surprised me is that you
> consistently use WARN_ON() instead of WARN_ON_ONCE() in this patch?
> 
Okay, will be fixing it up.

> Otherwise this patch looks fine to me.
> 
Thanks.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
