From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Wed, 10 Dec 2008 20:42:52 +0100
Message-ID: <20081210194252.GC25779@one.firstfloor.org>
References: <20081209231005.17830.92133.stgit@fritz> <20081209231016.17830.87180.stgit@fritz> <20081210000333.GC23556@one.firstfloor.org> <49400D94.5050301@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:60909 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbYLJTbO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 14:31:14 -0500
Content-Disposition: inline
In-Reply-To: <49400D94.5050301@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Love <robert.w.love@intel.com>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jgarzik@redhat.com, davem@davemloft.net, james.smart@emulex.com, michaelc@cs.wisc.edu, jeykholt@cisco.com, jeffrey.t.kirsher@intel.com

On Wed, Dec 10, 2008 at 10:42:28AM -0800, Vasu Dev wrote:
> 
> It had load balancing issue but now it is fixed, related latest 
> submitted code with its updated comment is:-
> 
> 	/*
> 	 * The incoming frame exchange id(oxid) is ANDed with num of online
> 	 * cpu bits to get cpu_idx and then this cpu_idx is used for 
> 	 selecting
> 	 * a per cpu kernel thread from fcoe_percpu. In case the cpu is
> 	 * offline or no kernel thread for derived cpu_idx then cpu_idx is
> 	 * initialize to first online cpu index.
> 	 */
> 	cpu_idx = oxid & (num_online_cpus() - 1);

First note that num_online_cpus() is not guaranteed to be a power of two,
- 1 is not guaranteed to give a suitable mask. So you might actually lose 
random bits. Also your load balancing scheme is unusual to say at least. 
e.g. when you're just talking to a single frame exchange you would always 
transfer data between CPUs instead of keeping it all on the CPU that 
processes the interrupt. Normally the rule of thumb is to use local
data as much as possible. Or when you distribute like this at least
stay in the same socket. But probably the scheme is too clever anyways.

-Andi
-- 
ak@linux.intel.com
