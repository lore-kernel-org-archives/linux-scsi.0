From: Luben Tuikov <tluben@rogers.com>
Subject: Re: requeuing a Scsi_Cmnd?
Date: Mon, 12 May 2003 14:12:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EBFE408.4010607@rogers.com>
References: <3EBEB1D5.3040300@pobox.com> <1052750688.1769.27.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:56275
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262485AbTELR7z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2003 13:59:55 -0400
In-Reply-To: <1052750688.1769.27.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2003-05-11 at 15:25, Jeff Garzik wrote:
> 
>>This question applies to 2.4 as well as 2.5 (I believe the strategies 
>>are different for the two?)
>>
>>Suppose I am passed several Scsi_Cmnd structures via ->queuecommand. 
>>TCQ depth is >1.  An event causes the entire queue to be aborted, but I 
>>know that the majority of the queue was actually ok.  So, my LLD would 
>>need to requeue and resend most of the recently-aborted Scsi_Cmnds.
> 
> 
> You keep finding these unhandled condidions, sigh.  The correct thing to
> do (since this is a situation identical to QErr set) is to return a
> check condition to the failing command and to return a status of TASK
> ABORTED for all the others (SPC3).  Of course, the SCSI-2 behaviour was
> just to expect all tasks to be silently aborted on QErr=1.  Neither of
> these, of course, is coded into the mid-layer.

Iff TAS is set and if TST is 001, and there is more than one initiator
whose task are being nuked, then this is correct.

Jeff didn't give much information, but it sounds like ABORT/CLEAR TASK SET.
Anyway, no point in speculating.

>>How do I tell the SCSI layer to requeue and resend a Scsi_Cmnd [almost] 
>>immediately?
> 
> 
> Probably the best thing to do is to return DID_BUS_BUSY which will force
> a fast retry.  Note, that's the driver return, *not* the status BUSY,
> which will force a requeue and take longer---DID_BUS_BUSY will retry
> immediately from the SCSI tasklet.

Uuuuh... Shouldn't this be fixed?

The problem with this is that on BUSY, the LLDD _may_ get the task
which got this condition out of order...  Furthermore, there's no
such thing as BUS BUSY anymore, it's an SPI left over.  In case
where the transport is unavailable, a service response of
SERVICE DELIVERY OR TARGET FAILURE should be returned*.
Currently SCSI Core has no facility to return a ``service response''.

* The LLDD should try to reconnect/reestablish before returning
this, of course.

I want newer LLDD to return the (task) status codes, so
that we have less problems later.  They are actually req'd to
return (task) status codes by newer versions of their transport
protocols.

-- 
Luben


