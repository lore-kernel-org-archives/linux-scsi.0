From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: requeuing a Scsi_Cmnd?
Date: 12 May 2003 09:44:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052750688.1769.27.camel@mulgrave>
References: <3EBEB1D5.3040300@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:5892 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262033AbTELOcL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 10:32:11 -0400
In-Reply-To: <3EBEB1D5.3040300@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2003-05-11 at 15:25, Jeff Garzik wrote:
> This question applies to 2.4 as well as 2.5 (I believe the strategies 
> are different for the two?)
> 
> Suppose I am passed several Scsi_Cmnd structures via ->queuecommand. 
> TCQ depth is >1.  An event causes the entire queue to be aborted, but I 
> know that the majority of the queue was actually ok.  So, my LLD would 
> need to requeue and resend most of the recently-aborted Scsi_Cmnds.

You keep finding these unhandled condidions, sigh.  The correct thing to
do (since this is a situation identical to QErr set) is to return a
check condition to the failing command and to return a status of TASK
ABORTED for all the others (SPC3).  Of course, the SCSI-2 behaviour was
just to expect all tasks to be silently aborted on QErr=1.  Neither of
these, of course, is coded into the mid-layer.

> How do I tell the SCSI layer to requeue and resend a Scsi_Cmnd [almost] 
> immediately?

Probably the best thing to do is to return DID_BUS_BUSY which will force
a fast retry.  Note, that's the driver return, *not* the status BUSY,
which will force a requeue and take longer---DID_BUS_BUSY will retry
immediately from the SCSI tasklet.

James


