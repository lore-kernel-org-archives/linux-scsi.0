From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] [RFC PATCH] scsi, fcoe, libfc: drop scsi host_lock
 use from fc_queuecommand
Date: Tue, 31 Aug 2010 23:17:44 -0500
Message-ID: <4C7DD3E8.9050700@cs.wisc.edu>
References: <20100831225338.25102.59500.stgit@localhost.localdomain> <1283298985.32007.530.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51972 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab0IAEM6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2010 00:12:58 -0400
In-Reply-To: <1283298985.32007.530.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vasu Dev <vasu.dev@intel.com>, devel@open-fcoe.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>

On 08/31/2010 06:56 PM, Nicholas A. Bellinger wrote:
>> +	if (host->unlocked_qcmds)
>> +		spin_unlock_irqrestore(host->host_lock, flags);
>> +
>>   	if (unlikely(host->shost_state == SHOST_DEL)) {
>>   		cmd->result = (DID_NO_CONNECT<<  16);
>>   		scsi_done(cmd);
>
> I don't think it's safe to call scsi_done() for the SHOST_DEL case here
> with host->unlocked_qcmds=1 w/o holding host_lock, nor would it be safe
> for the SCSI LLD itself using host->unlocked_qcmds=1 to call the
> (*scsi_done)() being passed into sht->queuecommand() without
> host->host_lock being held by either the SCSI ML or the SCSI LLD.

The host state should be checked under the host lock, but I do not think 
it needs to be held with calling scsi_done. scsi_done just queues up the 
request to be completed in the block softirq, and the block layer 
protects against something like the command getting completed by 
multiple code paths/threads.
