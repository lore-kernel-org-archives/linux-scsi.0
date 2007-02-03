From: "Qi, Yanling" <Yanling.Qi@lsi.com>
Subject: RE: [PATCH 0/2] : definion, code, and use of new SCSI ML hoststatus DID_COND_REQUEUE
Date: Fri, 2 Feb 2007 17:54:22 -0700
Message-ID: <0F08E10B769EAF4EA2C43A573B8CC87F8BD311@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36313 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409AbXBCAyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 19:54:24 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id l130qmG0018558
	for <linux-scsi@vger.kernel.org>; Fri, 2 Feb 2007 16:52:48 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id l130sO9c000606
	for <linux-scsi@vger.kernel.org>; Fri, 2 Feb 2007 16:54:25 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>, Edward Goggin <egoggin@vmware.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


I agree with Eric. RDAC/MPP will survive with the straight SAM BUSY
status.
--yanling
> -----Original Message-----
> From: Moore, Eric
> Sent: Friday, February 02, 2007 5:59 PM
> To: Edward Goggin; James Bottomley; Qi, Yanling
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: [PATCH 0/2] : definion, code, and use of new SCSI ML
> hoststatus DID_COND_REQUEUE
> 
> On Friday, February 02, 2007 4:34 PM, Edward Goggin wrote:
> > On Fri, 2007-02-02 at 17:18 -0600, James Bottomley wrote:
> > > On Fri, 2007-02-02 at 18:11 -0500, Edward Goggin wrote:
> > > > That solution doesn't work for the RDAC/MPP driver as the
> > BUSY status
> > > > handler retries indefinitely.  We need a solution which
> > works for both a
> > > > bare metal host running RDAC/MPP which for this use case,
> > wants to get
> > > > control over the failed command ASAP and a VMware host
> > which may need to
> > > > retry longer than DID_BUS_BUSY currently allows for.
> > >
> > > No it doesn't, not any longer... the mid-layer retries for
> > the command
> > > up to its timeout before failing.  That's the point about
> > questioning
> > > the validity of the original problem.
> > >
> > > James
> > >
> > >
> >
> > I think I see your argument ... retries for BUSY and all
> > other scsi/host
> > status's are limited by the code in scsi_softirq_done which
> > filters the
> > disposition returned by scsi_decide_disposition, so no status
> > will yield
> > an indefinite retry.
> >
> > Not clear if that's soon enough for RDAC/MPP.  For the VMware case,
it
> > appears to allow an additional 30 seconds (beyond what DID_BUSY_BUSY
> > would allow) for a retry.
> >
> >
> 
> Yanling, comments?
> 
> IMO we can kill the code that interprets the BUSY sam status.
> 
> Eric
