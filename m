From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: SCSI API generics (was Re: [PATCH] add block/unblock to iscsi
 class)
Date: Wed, 23 Feb 2005 16:00:45 -0800
Message-ID: <421D192D.4060400@us.ibm.com>
References: <421C3CA4.8070009@cs.wisc.edu> <20050223181705.GA8694@plap.qlogic.org> <421CDFAE.4090108@us.ibm.com> <20050223220644.GJ8694@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from e32.co.us.ibm.com ([32.97.110.130]:58078 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261717AbVBXAAn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 19:00:43 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1O00b5j115618
	for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 19:00:37 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1O00bsh136150
	for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 17:00:37 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1O00baR019374
	for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 17:00:37 -0700
In-Reply-To: <20050223220644.GJ8694@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Andrew Vasquez wrote:
> On Wed, 23 Feb 2005, Mike Christie wrote:
> 
> 
>>Andrew Vasquez wrote:
>>
>>>Speaking of which, are there any major objections to the patches
>>>proposed here:
>>>
>>>Add scsi_target_[un]block() and scsi_target_remove() generics
>>>http://marc.theaimsgroup.com/?l=linux-scsi&m=110867050306738&w=2
>>>
>>>[RFC] adding per scsi-host workqueues for defered processing
>>>http://marc.theaimsgroup.com/?l=linux-scsi&m=110903148407438&w=2
>>>
>>
>>When using single_threaded_workqueues do all single threaded ones
>>in the system use the same cpu_workqueue_struct? Will this be
>>a potential bottleneck if we end up using the workqueue for more
>>operations in the future?
> 
> 
> The kernel-thread that is created for a single-threaded workqueue is
> not bound to any particular CPU:
> 
> 	kthread.c:kthread()
> 
> 	...	
>         /* By default we can run anywhere, unlike keventd. */
>         set_cpus_allowed(current, CPU_MASK_ALL);
> 

My question is not about which cpu it is run on.
I am asking about the cpu_workqueue_struct. In
create_workqueue_thread cpu always equals zero so
later when it is run it can be on any cpu but every
single threaded workqueue will access the same
cpu_workqueue_struct.
