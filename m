From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Thu, 26 Aug 2004 09:29:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B347A14C-F774-11D8-B3DA-00039398BB5E@ieee.org>
References: <99D30EDE-F773-11D8-B3DA-00039398BB5E@ieee.org>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:1426 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S269052AbUHZP3V
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 11:29:21 -0400
In-Reply-To: <99D30EDE-F773-11D8-B3DA-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org

P.S.

> > > 02/04/01 should be treated like a Busy status.
> > ...
> > a) the spin-up implied by insert or power on,
>
> Many devices use x 2 04 01 to mean a spin-up implied by insert or 
> power on.
>
> I hear x 2 04 01 had a pre-Windows history of meaning please rapidly 
> retry, but Windows support was so poor - including rapidly counted 
> retries - that those other uses of x 2 04 01 have migrate out of PC 
> peripheral device designs.

I should also mention a practice I remember seeing and deprecating.

I've seen devices use x 2 04 01 to mean the host rudely sent a second 
command while a device with no command queue was still completing an 
"immediate" command or a disconnected command.  That's x 2 04 01 
meaning "busy" in the sense of resource conflict: hello, the heads are 
busy elsewhere, hello, there is only one arm.

Me, I argue that the host half of x 2 04 01 is such an ad hoc mess 
across platforms that any PC peripheral device should instead choose to 
delay its response to such a command.  Wait for the conflicting command 
to complete, only then begin the new command, and let the host worry 
about the worst case of the second command taking as long to complete 
as two commands in sequence.

Pat LaVarre

