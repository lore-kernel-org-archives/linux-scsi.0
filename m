From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: Suspending SCSI devices and buses
Date: Wed, 18 Aug 2004 16:49:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4123C0E4.6010906@optonline.net>
References: <Pine.LNX.4.44L0.0408181632410.1138-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from odin.allegientsystems.com ([208.251.178.227]:65286 "EHLO
	pegasus.lawaudit.com") by vger.kernel.org with ESMTP
	id S267705AbUHRUtn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2004 16:49:43 -0400
In-Reply-To: <Pine.LNX.4.44L0.0408181632410.1138-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> How does a host driver tell the SCSI core that an adapter is being 
> suspended (and hence the core needs to suspend all the devices attached to 
> that adapter)?  Ditto for resume.

For devices, this should be handled by the applicable scsi_driver - 
sd.c, etc. I posted a patch for this to the mailing list a week or two 
ago, check the list archives.

> 
> There doesn't appear to be any way to do it.  The scsi_bus_type and 
> various driver structures don't contain a "suspend" entry.

Correct, the midlayer doesn't quite support this yet, but my patch 
should do the most important bits if somebody would be kind enough to 
merge it... As a quick summary, first we need to quiesce the child 
devices and synchronize their caches, then the LLD just needs to handle 
flushing any remaining in-flight DMA transactions.

I also have an example patch to do this for the aic7xxx LLD. Which you 
can also grab from the list archives.

Nathan

> 
> Alan Stern
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

