From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: SCSI API generics (was Re: [PATCH] add block/unblock to iscsi class)
Date: Wed, 23 Feb 2005 14:06:44 -0800
Message-ID: <20050223220644.GJ8694@plap.qlogic.org>
References: <421C3CA4.8070009@cs.wisc.edu> <20050223181705.GA8694@plap.qlogic.org> <421CDFAE.4090108@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:6876 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261626AbVBWWGT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 17:06:19 -0500
Content-Disposition: inline
In-Reply-To: <421CDFAE.4090108@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 23 Feb 2005, Mike Christie wrote:

> Andrew Vasquez wrote:
> >
> >Speaking of which, are there any major objections to the patches
> >proposed here:
> >
> >Add scsi_target_[un]block() and scsi_target_remove() generics
> >http://marc.theaimsgroup.com/?l=linux-scsi&m=110867050306738&w=2
> >
> >[RFC] adding per scsi-host workqueues for defered processing
> >http://marc.theaimsgroup.com/?l=linux-scsi&m=110903148407438&w=2
> >
> 
> When using single_threaded_workqueues do all single threaded ones
> in the system use the same cpu_workqueue_struct? Will this be
> a potential bottleneck if we end up using the workqueue for more
> operations in the future?

The kernel-thread that is created for a single-threaded workqueue is
not bound to any particular CPU:

	kthread.c:kthread()

	...	
        /* By default we can run anywhere, unlike keventd. */
        set_cpus_allowed(current, CPU_MASK_ALL);

-- 
Andrew Vasquez
