From: Edward Goggin <egoggin@vmware.com>
Subject: Re: [PATCH 0/2] : definion, code, and use of new SCSI ML host
	status DID_COND_REQUEUE
Date: Fri, 02 Feb 2007 18:11:11 -0500
Message-ID: <1170457871.14264.81.camel@egoggin-devd.eng.vmware.com>
References: <1170453887.14264.73.camel@egoggin-devd.eng.vmware.com>
	 <1170456892.3380.35.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.vmware.com ([65.113.40.130]:51994 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946152AbXBBXLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 18:11:32 -0500
In-Reply-To: <1170456892.3380.35.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Fri, 2007-02-02 at 16:54 -0600, James Bottomley wrote:
> On Fri, 2007-02-02 at 17:04 -0500, Edward Goggin wrote:
> > Patch Set Summary:
> > 
> > 1	Define new SCSI ML host status DID_COND_REQUEUE and
> > 	add its handling code to scsi_decide_disposition.
> > 	Scsi_decide_disposition returns ADD_TO_MLQUEUE IFF
> > 	not REQ_FAILFAST.
> > 
> > 2	Return DID_COND_REQUEUE instead of DID_BUS_BUSY host status
> > 	in MPT fusion driver when IOC status is SUCCESS and scsi
> > 	status is busy.
> 
> Please, no.
> 
> In the first place, as I already said on the previous thread, I don't
> think the driver should be interpreting the BUSY return.
> 
> Secondly, the original problem was with fibre devices which seemed to
> want FAILFAST on BUSY (which looks very bogus to me), but no-one asked
> for this behaviour to be preserved.  The original bug report:
> 
>         "When a target device responds with BUSY status, the MPT driver
>         was
>         sending DID_OK to the SCSI mid layer, which caused the IO to be
>         retried indefinitely betweenthe mid layer and the 
>         driver.  By changing the driver return status to DID_BUS_BUSY,
>         the target BUSY status can now flow through the mid layer to an
>         upper layer Failover driver, whichwill manage the I/O timeout."
>         
> is about behaviour which is now fixed (BUSY is retried for the command's
> maximum lifetime but no longer).
> 
> Thirdly, the VMware issue was that the fibre fix was causing your
> implementation to time out too fast.
> 
> The solution, then, as I said previously should simply be to pass the
> BUSY status up unmodified from the fusion driver.
> 

That solution doesn't work for the RDAC/MPP driver as the BUSY status
handler retries indefinitely.  We need a solution which works for both a
bare metal host running RDAC/MPP which for this use case, wants to get
control over the failed command ASAP and a VMware host which may need to
retry longer than DID_BUS_BUSY currently allows for.

I'll let the LSI/Engenio people comment further on their needs.

> James
> 
> 
> 
