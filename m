From: Edward Goggin <egoggin@vmware.com>
Subject: Re: [PATCH 0/2] : definion, code, and use of new SCSI ML host
	status DID_COND_REQUEUE
Date: Fri, 02 Feb 2007 18:33:38 -0500
Message-ID: <1170459219.14264.91.camel@egoggin-devd.eng.vmware.com>
References: <1170453887.14264.73.camel@egoggin-devd.eng.vmware.com>
	 <1170456892.3380.35.camel@mulgrave.il.steeleye.com>
	 <1170457871.14264.81.camel@egoggin-devd.eng.vmware.com>
	 <1170458287.3380.39.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.vmware.com ([65.113.40.130]:1085 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946166AbXBBXd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 18:33:59 -0500
In-Reply-To: <1170458287.3380.39.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Fri, 2007-02-02 at 17:18 -0600, James Bottomley wrote:
> On Fri, 2007-02-02 at 18:11 -0500, Edward Goggin wrote:
> > That solution doesn't work for the RDAC/MPP driver as the BUSY status
> > handler retries indefinitely.  We need a solution which works for both a
> > bare metal host running RDAC/MPP which for this use case, wants to get
> > control over the failed command ASAP and a VMware host which may need to
> > retry longer than DID_BUS_BUSY currently allows for.
> 
> No it doesn't, not any longer... the mid-layer retries for the command
> up to its timeout before failing.  That's the point about questioning
> the validity of the original problem.
> 
> James
> 
> 

I think I see your argument ... retries for BUSY and all other scsi/host
status's are limited by the code in scsi_softirq_done which filters the
disposition returned by scsi_decide_disposition, so no status will yield
an indefinite retry.

Not clear if that's soon enough for RDAC/MPP.  For the VMware case, it
appears to allow an additional 30 seconds (beyond what DID_BUSY_BUSY
would allow) for a retry. 

