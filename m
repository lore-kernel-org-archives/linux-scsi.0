From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptsas: eliminate ghost devices
Date: Fri, 30 Jun 2006 16:38:22 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701BE45B@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41377 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751452AbWF3WiZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 18:38:25 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Friday, June 30, 2006 3:25 PM, James Bottomley wrote: 
> 
> On Fri, 2006-06-30 at 15:07 -0600, Eric Moore wrote:
> > +               if (scsi_is_host_device(parent)) {
> > +                       if (!identify.target_port_protocols &&
> > +                               (identify.device_type ==
> > SAS_END_DEVICE))
> > +                               goto out;
> 
> Won't this happen for any initiator, rather than just the parent (i.e.
> in a multi-initiator environment we won't see anything even for remote
> initiators)?
> 

I believe my code is correct.  The scsi_is_host_device(parent) condition
will only be entered from an expander one level down from the host hba,
and this case
will remove for all rphys that would of been reported pointing back to
the 
host hba.  So in the case you have two initiators connected to the same
expander,
I think it would be expected that all ghost rphys need not be reported
for all host
host hba's connected to the same expander, right?  

If the remote initiator is located beyond the 1st leve expander, or
direct
connected to each other, this condition will not entered.

Eric
