From: James Smart <James.Smart@Emulex.Com>
Subject: Re: queue_depth tracking from LLD
Date: Thu, 16 Apr 2009 10:40:37 -0400
Message-ID: <49E74365.3020302@emulex.com>
References: <20090416093604.GA7096@schmichrtp.de.ibm.com> <49E73D16.9030307@emulex.com> <20090416143350.GD1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63948 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZDPOlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 10:41:11 -0400
In-Reply-To: <20090416143350.GD1926@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Completely Agree.  The multi-initiator point is the one I try to hammer 
home. It's what the
current algorithm completely misses.

Even though I said its complex - it's really not that difficult. The 
pain is just figuring out
what to group and what the rates should be.

-- james s

Matthew Wilcox wrote:
> On Thu, Apr 16, 2009 at 10:13:42AM -0400, James Smart wrote:
>   
>> However, for arrays, with multiple luns, the queue depth is usually a 
>> target-level resource,
>> so the midlayer/block-layer's implementation falls on its face fairly 
>> quickly. I brought this
>>     
>
> If the problem were as simple as the resource being target-level instead
> of LUN-level, it would be fairly easy to fix (we could do accounting
> per-target instead of per-LUN).  The problem, AIUI, is multi-initiator
> where you can't know whether resources are in use or not.
>
>   
>> up 2 yrs ago at storage summit.  What needs to happen is the creation of 
>> queue ramp-down
>> and ramp-up policies that can be selected on a per-lun basis, and have 
>> these implemented
>> in the midlayer (why should the LLDD ever look at scsi command 
>> results).  What will make
>> this difficult is the ramp-up policies, as it can be very target 
>> device-specific or configuration/load
>> centric.
>>     
>
> While not disagreeing that it's complex, I don't think putting it in the
> driver makes it less complex.  I completely agree that LLDDs should not
> be snooping scsi commands or scsi command results.  It should all be in
> the midlayer so we all share the same bugs ;-)
>
>   
