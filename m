From: James.Smart@Emulex.Com
Subject: RE: [PATCH] [Update #2] suspending I/Os to a device
Date: Fri, 1 Oct 2004 12:21:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C086627@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50874 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264503AbUJAQVk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 12:21:40 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, patmans@us.ibm.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, hch@infradead.org, andmike@us.ibm.com, mort@wildopensource.com, andrew.vasquez@qlogic.com

I should expand a little further...

I view them as having a different use:

scsi_xxblock_requests - used for very short duration stalls where hardware/driver is in a short transitory state (request queues are temporarily full, etc).

fc_host_xxblock - used for long durations of I/O stoppage (on the order of 30 seconds ?). I/O is stopped while a link may be jittering, cable accidentally kicked out and reinserted, etc.

-- James


> -----Original Message-----
> From: Smart, James 
> Sent: Friday, October 01, 2004 12:15 PM
> To: 'Patrick Mansfield'
> Cc: James.Bottomley@SteelEye.com; linux-scsi@vger.kernel.org;
> hch@infradead.org; andmike@us.ibm.com; mort@wildopensource.com;
> andrew.vasquez@qlogic.com
> Subject: RE: [PATCH] [Update #2] suspending I/Os to a device
> 
> 
> The difference is, the fc functions:
> - Changes the actual sdev state to indicate a "blocked" state 
>  (you can see it in sysfs, etc)
> - Starts a timer that will automatically unblock the sdev w/o 
> lld intervention
> 
> -- james
> 
> > What is the difference between these new fc_host_block/unblock and
> > the current scsi_block/unblock_requests?
> 
