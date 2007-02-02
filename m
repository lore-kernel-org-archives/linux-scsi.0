From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 0/2] : definion, code, and use of new SCSI ML hoststatus DID_COND_REQUEUE
Date: Fri, 2 Feb 2007 16:58:33 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70585704@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34778 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946167AbXBBX6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 18:58:41 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Edward Goggin <egoggin@vmware.com>, James Bottomley <James.Bottomley@SteelEye.com>, "Qi, Yanling" <Yanling.Qi@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Friday, February 02, 2007 4:34 PM, Edward Goggin wrote:
> On Fri, 2007-02-02 at 17:18 -0600, James Bottomley wrote:
> > On Fri, 2007-02-02 at 18:11 -0500, Edward Goggin wrote:
> > > That solution doesn't work for the RDAC/MPP driver as the 
> BUSY status
> > > handler retries indefinitely.  We need a solution which 
> works for both a
> > > bare metal host running RDAC/MPP which for this use case, 
> wants to get
> > > control over the failed command ASAP and a VMware host 
> which may need to
> > > retry longer than DID_BUS_BUSY currently allows for.
> > 
> > No it doesn't, not any longer... the mid-layer retries for 
> the command
> > up to its timeout before failing.  That's the point about 
> questioning
> > the validity of the original problem.
> > 
> > James
> > 
> > 
> 
> I think I see your argument ... retries for BUSY and all 
> other scsi/host
> status's are limited by the code in scsi_softirq_done which 
> filters the
> disposition returned by scsi_decide_disposition, so no status 
> will yield
> an indefinite retry.
> 
> Not clear if that's soon enough for RDAC/MPP.  For the VMware case, it
> appears to allow an additional 30 seconds (beyond what DID_BUSY_BUSY
> would allow) for a retry. 
> 
> 

Yanling, comments?

IMO we can kill the code that interprets the BUSY sam status.

Eric
