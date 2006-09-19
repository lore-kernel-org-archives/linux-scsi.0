From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptspi : Bug fix to prevent infinite nested domainvalidation
Date: Tue, 19 Sep 2006 17:21:43 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032CE68@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34180 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750778AbWISXVv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 19:21:51 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday, September 19, 2006 2:50 PM, Mark Haverkamp wrote: 

> 
> It does take quite a while.  It has been going for over 8 minutes and
> isn't done yet.  Here is the log so far:
> 

Yes, this is recursive domain validation.


I'm going to create another patch that I think will address this.
I will pass the sleepFlag to mptspi_ioc_reset, and to all the 
MptResetHandlers.  And that way during eh host_reset, I can issue
dv in the same context as the eh handlers, instead of a delayed
work queue.  However if the sleepFlag is NO_SLEEP, it will be
done from work queue, however that should effect this bug, as
the NO_SLEEP cases are internal timeouts.

Eric

 
