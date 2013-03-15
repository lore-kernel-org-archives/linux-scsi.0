From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Fri, 15 Mar 2013 12:01:29 +0000
Message-ID: <51430D99.4010604@redhat.com>
References: <1358262138-13378-1-git-send-email-hare@suse.de> <51421272.2000706@linux.vnet.ibm.com> <51430C4A.7090308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab3COMER (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Mar 2013 08:04:17 -0400
In-Reply-To: <51430C4A.7090308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>

On 03/15/2013 11:55 AM, Hannes Reinecke wrote:
> Rationale for this patch is a weird test case with brocade switches;
> there you can actually disable a _target_ port. So the port isn't
> reachable anymore but no RSCN is send.

I think it's more than a pure test-case; using the rscnsupr feature on 
the Brocades is just a handy way to trigger it.

I've seen numerous cases in the last few years of fabric failures that 
had this characteristic - either because of hardware failures in the 
switches or due to bugs that caused FC traffic to be blackholed without 
an RSCN or other indication (beyond commands timing out).

This (and the I_T nexus reset you proposed in December which is very 
effective at short-ciruiting the eh escalation in the same situation) 
both make the kernel more robust in the face of this kind of problem.

Regards,
Bryn.


