From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: RE: [Open-FCoE] [RFC PATCH] scsi, fcoe, libfc: drop scsi host_lock
 use from fc_queuecommand
Date: Fri, 03 Sep 2010 15:38:45 -0700
Message-ID: <1283553525.30431.192.camel@vi2.jf.intel.com>
References: <20100831225338.25102.59500.stgit@localhost.localdomain>
	 <1283298985.32007.530.camel@haakon2.linux-iscsi.org>
	 <4C7DD3E8.9050700@cs.wisc.edu>
	 <7C88852EF6F99F4EB538472FCFEBE222013AF95EB2@orsmsx509.amr.corp.intel.com>
	 <1283371821.32007.636.camel@haakon2.linux-iscsi.org>
	 <1283375187.30431.71.camel@vi2.jf.intel.com>
	 <1283377121.5598.23.camel@haakon2.linux-iscsi.org>
	 <1283448262.30431.172.camel@vi2.jf.intel.com>
	 <1283456928.5598.117.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57094 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0ICW6I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:58:08 -0400
In-Reply-To: <1283456928.5598.117.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Matthew Wilcox <matthew@wil.cx>, "Zou, Yi" <yi.zou@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Christoph Hellwig <hch@lst.de>, Joe Eykholt <jeykholt@cisco.com>, Hannes Reinecke <hare@suse.de>

On Thu, 2010-09-02 at 12:48 -0700, Nicholas A. Bellinger wrote:
> > Yeah but direct use makes things more obvious at first look. However
> > neatness is worthy using wrapper(macros) if there are several such
> > places. Anycase this is very minor code style thing here and I'm
> fine
> > with wrapper if you want.
> 
> Sure, I am thinking about these simple host_lock wrappers as more of a
> transitional look for LLDs more than anything..
> 
> Btw, I would be happy to include your forthcoming v2 patch into a
> lio-core-2.6.git branch, and give it some testing in the next week.
> 

Awesome, Thanks for your all help Nab,

	I tried to have wrapper instead of checks to drop host_lock before
fc_queuecommand using wrapper something like this :-

+static inline void scsi_qcmd_host_unlock(struct Scsi_Host *shost,
unsigned long irq_flags)
+{
+       if (shost->host_lock_pending) {
+               shost->host_lock_pending = 0;
+               spin_unlock_irqrestore(shost->host_lock, irq_flags);
+       } else if (shost->unlocked_qcmds)
+               spin_unlock_irqrestore(shost->host_lock, irq_flags);
+       else
+               shost->host_lock_pending = 1;
+}
+

This didn't work well beside required lot more checks to track host lock
so that this wrapper can be called w/o checks as:-

	scsi_qcmd_host_unlock(host, flags);
	rtn = host->hostt->queuecommand(cmd, scsi_done);
	scsi_qcmd_host_unlock(host, flags);

I think it is better of with simple checks for now as I posted in my
patch, may be a wrapper can be added in case more places neeeds such
checks as we talked before.

	Thanks
	Vasu 





