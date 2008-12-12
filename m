From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Thu, 11 Dec 2008 17:55:58 -0800
Message-ID: <4941C4AE.2000403@linux.intel.com>
References: <20081209231005.17830.92133.stgit@fritz> <20081209231016.17830.87180.stgit@fritz> <20081210000333.GC23556@one.firstfloor.org> <49400D94.5050301@linux.intel.com> <20081210194252.GC25779@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:15427 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756786AbYLLB4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2008 20:56:00 -0500
In-Reply-To: <20081210194252.GC25779@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Robert Love <robert.w.love@intel.com>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jgarzik@redhat.com, davem@davemloft.net, james.smart@emulex.com, michaelc@cs.wisc.edu, jeykholt@cisco.com, jeffrey.t.kirsher@intel.com

Andi Kleen wrote:
> On Wed, Dec 10, 2008 at 10:42:28AM -0800, Vasu Dev wrote:
>   
>> It had load balancing issue but now it is fixed, related latest 
>> submitted code with its updated comment is:-
>>
>> 	/*
>> 	 * The incoming frame exchange id(oxid) is ANDed with num of online
>> 	 * cpu bits to get cpu_idx and then this cpu_idx is used for 
>> 	 selecting
>> 	 * a per cpu kernel thread from fcoe_percpu. In case the cpu is
>> 	 * offline or no kernel thread for derived cpu_idx then cpu_idx is
>> 	 * initialize to first online cpu index.
>> 	 */
>> 	cpu_idx = oxid & (num_online_cpus() - 1);
>>     
>
> First note that num_online_cpus() is not guaranteed to be a power of two,
> - 1 is not guaranteed to give a suitable mask. So you might actually lose 
> random bits.

Correct, this will work best for only power of 2 online cpus and that 
would be the most common typical use case. I agree it won't load balance 
better in non power of 2 cpus case.

>  Also your load balancing scheme is unusual to say at least. 
> e.g. when you're just talking to a single frame exchange you would always 
> transfer data between CPUs instead of keeping it all on the CPU that 
> processes the interrupt.  
>   
> Normally the rule of thumb is to use local
> data as much as possible. Or when you distribute like this at least
> stay in the same socket. 
>   

We cannot control what cpu to get interrupted for a FC frame in a 
typical generic NIC, so we may end up receiving mostly all FC frames on 
a single same cpu though system might have several other cpus available. 
In this scenario if frame are passed up to same cpu as suggested above 
then that won't do any load balancing, therefore some sort of load 
balancing is required based on some FC frame attributes here.

As I said in my last response that "performance tuning is yet to be 
done" but you bring up some good related points now of cross socket 
frame migration and balancing on non power of 2 cpus system. These 
should be considered during pending performance tuning but for now I can 
add additional check to select cpu within same socket but not sure how 
to do that, any kernel call for this ? This might cause more locking 
contentions on libfc structs so really we have to experiment these thing 
during performance tuning. Thanks Andi for these hints on performance 
consideration.

Vasu
