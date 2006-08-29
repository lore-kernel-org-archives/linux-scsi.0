From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi_transport_sas: remove local_attached flag
Date: Tue, 29 Aug 2006 09:24:26 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D702E282F@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50623 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964931AbWH2PY2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 11:24:28 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Friday, August 25, 2006 12:48 PM, James Bottomley wrote: 

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Friday, August 25, 2006 12:48 PM
> To: linux-scsi
> Cc: Moore, Eric
> Subject: [PATCH] scsi_transport_sas: remove local_attached flag
> 
> This flag denotes local attachment of the phy.  There are two problems
> with it:
> 
> 1) It's actually redundant ... you can get the same information simply
> by seeing whether a host is the phys parent
> 2) we condition a lot of phy parameters on it on the false assumption
> that we can only control local phys.  I'm wiring up phy resets in the
> aic94xx now, and it will be able to reset non-local phys as well.
> 
> I fixed 2) by moving the local check into the reset and stats function
> of the mptsas, since that seems to be the only HBA that can't
> (currently) control non-local phys.
> 

This makes sense to remove this flag.

Perhaps this is time to decide on how to handle this for expanders.
At the time this was being developed in transport via Christophs help, 
we couldn't decide if this should be done by userspace, smp_passthru, or

fusion internal implementation.  Currently you can get link errors or 
phy/link reset via Doug Gilberts smputils. For instance you can get link

errors using smp_rep_phy_err_log, and send link/phy reset via
smp_phy_control.

If the tools are fine with you. Then nothing needs to be done.  I could 
add support in fusion for sending internal smp passthru, or we can
export 
a smp portal for you.  The smp portal should still be in the future
plans 
for the bsg driver.

Eric
