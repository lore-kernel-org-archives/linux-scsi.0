From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: queue_depth tracking from LLD
Date: Thu, 16 Apr 2009 09:27:36 -0500
Message-ID: <49E74058.5010401@cs.wisc.edu>
References: <20090416093604.GA7096@schmichrtp.de.ibm.com> <49E73D16.9030307@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46726 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbZDPO2T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2009 10:28:19 -0400
In-Reply-To: <49E73D16.9030307@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Smart wrote:
> The mid-layer queue depth handling is really designed/optimized around 
> behavior for
> a JBOD. This, if it's a single-lun device, the LLDD could largely ignore 
> doing anything
> with adjusting the queue depth.
> 
> However, for arrays, with multiple luns, the queue depth is usually a 
> target-level resource,
> so the midlayer/block-layer's implementation falls on its face fairly 
> quickly. I brought this
> up 2 yrs ago at storage summit.  What needs to happen is the creation of 
> queue ramp-down
> and ramp-up policies that can be selected on a per-lun basis, and have 
> these implemented
> in the midlayer (why should the LLDD ever look at scsi command 
> results).  What will make
> this difficult is the ramp-up policies, as it can be very target 
> device-specific or configuration/load
> centric.

For the rampup are you referring to code like lpfc_rampup_queue_depth? 
Were were just talking about this on the fcoe list. Why did lpfc and 
qla2xxx end up implememting their own code? We started to look into 
moving this into the scsi layer. It does not seem like there was a major 
reason why it should not have been more common. Was it just one of those 
things where it got added in one driver then added in another?

If we moved code like that to the scsi layer, then is all the is needed 
is a interface to config this?
