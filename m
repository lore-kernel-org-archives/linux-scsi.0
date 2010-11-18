From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 01/11] libiscsi: Convert to host_lock less w/ interrupts
 disabled internally
Date: Thu, 18 Nov 2010 11:59:34 +0200
Message-ID: <4CE4F906.3080506@panasas.com>
References: <1290032304-4859-1-git-send-email-nab@linux-iscsi.org> <4CE47C12.80804@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:38589 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab0KRJ7i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 04:59:38 -0500
In-Reply-To: <4CE47C12.80804@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On 11/18/2010 03:06 AM, Mike Christie wrote:
> On 11/17/2010 04:18 PM, Nicholas A. Bellinger wrote:
>>   prepd_fault:
>>   	sc->scsi_done = NULL;
> 
>> -	done(sc);
>> -	spin_lock(host->host_lock);
>> +	sc->scsi_done(sc);
>>   	return 0;
> 
> This will NULL pointer. See a couple lines above where we NULL it. 
> iscsi_free_task checks if the scsi_done pointer is set and if it is it 
> will call scsi_done.
> 
> It is a hack to prevent the normal completion path from calling 
> scsi_done. For the case where we return SCSI_MLQUEUE_TARGET_BUSY (the 
> prepd_reject case) we need something to prevent scsi_done from getting 
> called.
> 
> For the return 0/prepd_fault case we can just call sc->scsi_done, but we 
> have to move some code around.
> 
> I do not like how the code does the NULLing and testing. Let me work on 
> this and send a tested patch.

Mike if you are on this. Do you think we need the _irqsave locking.
I always thought that the network receive is not on the HW interrupt
but on a completion thread. Could you verify?

Thanks
Boaz
