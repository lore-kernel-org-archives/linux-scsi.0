From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] first cut at fixing unable to requeue with no outstanding
 commands
Date: Tue, 01 Oct 2002 12:30:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210011630.g91GUx204378@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA05384
	for <linux-scsi@vger.kernel.org>; Tue, 1 Oct 2002 09:31:04 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id JAA05295
	for <linux-scsi@vger.kernel.org>; Tue, 1 Oct 2002 09:31:01 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g91GUx204378
	for <linux-scsi@vger.kernel.org>; Tue, 1 Oct 2002 12:30:59 -0400
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Tue, 01 Oct 2002 09:23:48 PDT." <20021001162347.GA1242@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

andmike@us.ibm.com said:
> 	- Is the call to scsi_delete_timer really necessary. All callers
> 	  have already deleted the timer. The del_timer function takes a
> 	  lock which would be nice to avoid if we do not need to call
> 	  it.  If we want to protect the code we could do a quick check
> 	  on SCset->eh_timeout.function prior to calling. 

That's a belt and braces thing.  I suppose we could change it to BUG_ON timer 
active and see what pops out of the woodwork.

andmike@us.ibm.com said:
> 	- Patrick pointed out a while ago that the "if (host->host_busy
> 	  == 0)" check and the similar one for the device will never be
> 	  called because to be in this function the values of these
> 	  variables need to be at least 1. I believe this direct call to
> 	  scsi_retry_command should be removed instead of adjusting the
> 	  check to "== 1" as this seems counter to how you are trying to
> 	  handle busy. 

Yes, I plan on slowly removing all automatic reissues of commands. I've 
already removed the checks in my local tree (and the corresponding reissues).

James


