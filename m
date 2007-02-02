From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/2] : definion, code, and use of new SCSI ML host
	status DID_COND_REQUEUE
Date: Fri, 02 Feb 2007 16:54:52 -0600
Message-ID: <1170456892.3380.35.camel@mulgrave.il.steeleye.com>
References: <1170453887.14264.73.camel@egoggin-devd.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37255 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946141AbXBBWy5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 17:54:57 -0500
In-Reply-To: <1170453887.14264.73.camel@egoggin-devd.eng.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Edward Goggin <egoggin@vmware.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Fri, 2007-02-02 at 17:04 -0500, Edward Goggin wrote:
> Patch Set Summary:
> 
> 1	Define new SCSI ML host status DID_COND_REQUEUE and
> 	add its handling code to scsi_decide_disposition.
> 	Scsi_decide_disposition returns ADD_TO_MLQUEUE IFF
> 	not REQ_FAILFAST.
> 
> 2	Return DID_COND_REQUEUE instead of DID_BUS_BUSY host status
> 	in MPT fusion driver when IOC status is SUCCESS and scsi
> 	status is busy.

Please, no.

In the first place, as I already said on the previous thread, I don't
think the driver should be interpreting the BUSY return.

Secondly, the original problem was with fibre devices which seemed to
want FAILFAST on BUSY (which looks very bogus to me), but no-one asked
for this behaviour to be preserved.  The original bug report:

        "When a target device responds with BUSY status, the MPT driver
        was
        sending DID_OK to the SCSI mid layer, which caused the IO to be
        retried indefinitely betweenthe mid layer and the 
        driver.  By changing the driver return status to DID_BUS_BUSY,
        the target BUSY status can now flow through the mid layer to an
        upper layer Failover driver, whichwill manage the I/O timeout."
        
is about behaviour which is now fixed (BUSY is retried for the command's
maximum lifetime but no longer).

Thirdly, the VMware issue was that the fibre fix was causing your
implementation to time out too fast.

The solution, then, as I said previously should simply be to pass the
BUSY status up unmodified from the fusion driver.

James



