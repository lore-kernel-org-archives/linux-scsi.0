From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Wed, 10 Dec 2008 10:42:28 -0800
Message-ID: <49400D94.5050301@linux.intel.com>
References: <20081209231005.17830.92133.stgit@fritz> <20081209231016.17830.87180.stgit@fritz> <20081210000333.GC23556@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:30862 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753879AbYLJSmm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:42:42 -0500
In-Reply-To: <20081210000333.GC23556@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Robert Love <robert.w.love@intel.com>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jgarzik@redhat.com, davem@davemloft.net, james.smart@emulex.com, michaelc@cs.wisc.edu, jeykholt@cisco.com, jeffrey.t.kirsher@intel.com

Andi Kleen wrote:
> On Tue, Dec 09, 2008 at 03:10:17PM -0800, Robert Love wrote:
>   
>> libFC is composed of 4 blocks supported by an exchange manager
>> and a framing library. The upper 4 layers are fc_lport, fc_disc,
>> fc_rport and fc_fcp. A LLD that uses libfc could choose to
>> either use libfc's block, or using the transport template
>> defined in libfc.h, override one or more blocks with its own
>> implementation.
>>     
>
> Just some more stuff I noticed while looking briefly at libfcoe.c
> Not a complete review again.
>
>  230 #ifdef CONFIG_SMP
>  231         /*
>  232          * The exchange ID are ANDed with num of online CPUs,
>  233          * so that will have the least lock contention in
>  234          * handling the exchange. if there is no thread
>  235          * for a given idx then use first online cpu.
>  236          */
>  237         cpu_idx = oxid & (num_online_cpus() >> 1);
>  238         if (fcoe_percpu[cpu_idx] == NULL)
>  239                 cpu_idx = first_cpu(cpu_online_map);
>  240 #endif
>
> What is this supposed to do? It looks quite dubious.
>   

It had load balancing issue but now it is fixed, related latest 
submitted code with its updated comment is:-

	/*
	 * The incoming frame exchange id(oxid) is ANDed with num of online
	 * cpu bits to get cpu_idx and then this cpu_idx is used for selecting
	 * a per cpu kernel thread from fcoe_percpu. In case the cpu is
	 * offline or no kernel thread for derived cpu_idx then cpu_idx is
	 * initialize to first online cpu index.
	 */
	cpu_idx = oxid & (num_online_cpus() - 1);
	if (!fcoe_percpu[cpu_idx] || !cpu_online(cpu_idx))
		cpu_idx = first_cpu(cpu_online_map);


The incoming FC frame is distributed across all fcoe_percpu_receive_thread for better load balancing, these per CPU threads are created by fcoe module during fcoe_init. This should help in performance but not sure how much since performance tuning is yet to be done.


> Shouldn't this use the current CPU number?
>
>   

The current cpu could be used here with some other ingress FC frames 
distribution/hashing across all cpus instead this hash logic "oxid & 
(num_online_cpus() - 1)", possibly ingress FC frame distribution at soft 
irq level by oxid and then passing up to current cpu's kernel thread 
fcoe_percpu_receive_thread.
