From: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Subject: RE: Need help with another aic94xx sequencer problem
Date: Tue, 22 Aug 2006 13:44:52 -0700
Message-ID: <89FD792A883D4B47AD469FEA2E5D1F9B0121582D@aime2k302.adaptec.com>
References: <1156278519.19615.31.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:25523 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S932154AbWHVUo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2006 16:44:57 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1156278519.19615.31.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi James,

Jack will be helping these issues in the future.  I doubt there is a
problem with the sequencer, it is shared with many other drivers.  I
think that you are probably correct that either the abort is probably
not being formulated or (more likely?) the response code from the abort
is not being interpreted correctly.  We will get back to you.

p.s. For some reason this email ended up in both my and Jack's spam
folders.  I'll have to be careful about dumping my spam :-)

Rob

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Tuesday, August 22, 2006 1:29 PM
> To: Tarte, Robert; Hammer, Jack
> Cc: linux-scsi
> Subject: Need help with another aic94xx sequencer problem
> 
> While abusing my sas topology (to try to get it to give me errors) I
> came across this one with STP tasks:
> 
> When the aic94xx loses a task in sas_execute_tasks(), the timeout
fires
> and wakes the waiter (this leaves the task set pending and aborted).
In
> response, sas_execute_task() tries to call lldd_abort_task()
> (asd_abort_task()) on it.  Here we panic failing the
BUG_ON(!list_empty)
> check in aic94xx_hwi.h:asd_ascb_free().
> 
> What happens is that the abort comes back with TF_TMF_NO_CTX + 0xFF00
> from the sequencer, which asd_abort_task() treats as success and then
> panics because the original task is still active.
> 
> Either the abort function or the sequencer code is clearly wrong, but
> not having access to the sequencer to look, I can't tell.  What should
> this return mean from the sequencer?  My suspicion is that it means
the
> STP task abort isn't actually formulated properly.
> 
> James
> 

