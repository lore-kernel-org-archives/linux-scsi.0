From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH v2][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Thu, 7 Mar 2013 14:35:45 -0600
Message-ID: <5138FA21.8000000@tributary.com>
References: <1355214219-17343-1-git-send-email-hare@suse.de> <5138E84B.8030803@cs.wisc.edu> <5138F4DF.9010906@tributary.com> <5138F67D.3070703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:33785 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3CGUfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 15:35:48 -0500
In-Reply-To: <5138F67D.3070703@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Krishna C Gudipati <kgudipat@brocade.com>, James Bottomley <jbottomley@parallels.com>

On 3/7/2013 2:20 PM, Mike Christie wrote:
> On 03/07/2013 02:13 PM, Jeremy Linton wrote:
>> 	For lpfc, you never get to the code. Or rather when I was testing it, I
>> couldn't find any way to propagate an error beyond the initial
>> lpfc_reset_flush_io_context() call in lpfc_device_reset_handler().
>>
>> 	That call pretty much always returns success indpependent of the remote
>> device because the firmware acks the context clear aborts, resulting in the
>> outstanding iocb count being zero (independent of both the mid layer status
>> and the actual device state).
>> 	
> 
> Your lpfc patch fixes that right?


	Yes. It allows the device reset to fail if the device doesn't respond to the
task mgmt request, or rejects it, etc.

	It doesn't unjam the commands that get aborted by the flush_io_context() call.
Those have to depend on their timeouts. That is another patch...




	


