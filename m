From: Michael Reed <mdr@sgi.com>
Subject: Re: qla2xxx: Conditionally disable automatic queue full tracking
Date: Thu, 24 Sep 2009 09:42:58 -0500
Message-ID: <4ABB8572.5050902@sgi.com>
References: <5355D915-9CAE-41CD-846B-F816FE914E1B@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:57691 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753546AbZIXOmz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 10:42:55 -0400
In-Reply-To: <5355D915-9CAE-41CD-846B-F816FE914E1B@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, LinuxSCSI <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, vasu.dev@intel.com

Hello,

The purpose of the queue full tracking patch in qla2xxx is to
keep the driver from changing a user space override of the queue
depth back to what the driver believes is the "correct" value.

The raid devices that we use have per raid controller queue depth
limits and have at times demonstrated, uh, bad behavior when
their queues are full for sustained periods of time.  SGI needs
to be able to set queue depth for a lun based upon access patterns
and performance requirements of the entire cluster and know that
it will be honored as an upper bound.

Might you provide a pointer to the recently submitted patches?
I haven't followed linux-scsi in a while....  I'll be quite
happy to take a look.

Thanks,
 Mike


Giridhar Malavali wrote:
> Hi Michael/James,
> 
> 	Patches were submitted to move queue ramp up/down code recently to  
> scsi mid layer. With this change, I don't see a need for a module  
> parameter to disable queuefull tracking  in qla2xxx driver. Andrew,  
> mentioned that this got introduced to avoid wobbling behavior on the  
> wire due to queue depth modifications. Just wanted to check whether  
> the same need to be done in scsi mid layer too.
> 
> 
> Thanks,
> Giridhar.M.B
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
