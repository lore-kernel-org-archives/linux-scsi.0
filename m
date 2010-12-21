From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 01/12] libiscsi: Convert to host_lock less w/ interrupts
 disabled internally
Date: Tue, 21 Dec 2010 17:43:49 -0600
Message-ID: <4D113BB5.2020802@cs.wisc.edu>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org> <1292793727-31957-2-git-send-email-nab@linux-iscsi.org> <4D0FF7E6.2060104@cs.wisc.edu> <4D108726.2080003@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46201 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab0LUXpe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 18:45:34 -0500
In-Reply-To: <4D108726.2080003@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, adam radford <aradford@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On 12/21/2010 04:53 AM, Boaz Harrosh wrote:
> On 12/21/2010 02:42 AM, Mike Christie wrote:
>> On 12/19/2010 03:21 PM, Nicholas A. Bellinger wrote:
>>>    prepd_fault:
>>> @@ -1732,12 +1728,10 @@ fault:
>>>    		scsi_out(sc)->resid = scsi_out(sc)->length;
>>>    		scsi_in(sc)->resid = scsi_in(sc)->length;
>>>    	}
>>> -	done(sc);
>>> -	spin_lock(host->host_lock);
>>> +	sc->scsi_done(sc);
>>>    	return 0;
>>
>>
>> Did you mean to send this patch or a different one? I think you sent a
>> patch with this before and I said it was wrong. Did you disagree with
>> that comment or did you change something else so it now works?
>
> Mike hi
>
> I think Nick is gone for the holidays. What I understood is that he's
> waiting for you to fix it. Because he's not sure what the proper solution
> is. Do you have time to look into it? (It will take you much faster then me)
>

I am still working on it for the 2.6.38 feature window.
