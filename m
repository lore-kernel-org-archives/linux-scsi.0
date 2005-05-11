From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: sg driver and the error handler
Date: Wed, 11 May 2005 13:55:50 -0400
Message-ID: <42824726.3010503@adaptec.com>
References: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org> <20050510225831.GA4181@us.ibm.com> <4281F396.2030607@torque.net> <4282345B.4010102@adaptec.com> <20050511174549.GB9286@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:51430 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261224AbVEKRz5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 13:55:57 -0400
In-Reply-To: <20050511174549.GB9286@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: dougg@torque.net, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 05/11/05 13:45, Patrick Mansfield wrote:
> IMO, normal sg/SG_IO usage wants scsi core to requeue the request, they
> want the command to be processed by the LUN.
> 
> And user space does not have the information available in scsi core
> (status of other outstanding IO to the same LUN), and can't retry in a
> timely manner, possibly avoid starvation issues.
> 
> Maybe fast fail should be used to modify QUEUE FULL re-queue behaviours.

Yes, if this is controllable through sg, that would avoid
the problems Alan mentioned.
 
> It might be a bit odd in some cases and maybe hardware specific (for multi
> path io, does QUEUE FULL mean a storage port/controller is full, or the
> LUN is full? if port, then you want to send back to the upper level, but
> if LUN, you might want to let scsi core requeue it). 

If it is coming from SDS (TASK SET FULL) then it is the LUN.  If it
is coming from the LLDD, then it is the other (host queue full).

	Luben

