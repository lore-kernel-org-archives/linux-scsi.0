From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: fix bnx2i build errors
Date: Wed, 05 May 2010 12:02:17 -0400
Message-ID: <1273075337.14287.81.camel@mulgrave.site>
References: <20100504103001.33fcbe88.randy.dunlap@oracle.com>
	 <1273067699.5227.56.camel@mulgrave.site>  <4BE19342.7010507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934370Ab0EEQCX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2010 12:02:23 -0400
In-Reply-To: <4BE19342.7010507@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Anil Veerabhadrappa <anilgv@broadcom.com>, akpm <akpm@linux-foundation.org>

On Wed, 2010-05-05 at 08:48 -0700, Randy Dunlap wrote:
> On 05/05/10 06:54, James Bottomley wrote:
> > On Tue, 2010-05-04 at 10:30 -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> bnx2i should depend on NET since it selects SCSI_ISCSI_ATTRS,
> >> which depends on NET.
> >>
> >> Also move the dependencies together.
> >>
> >> The "depends" change fixes multiple build errors when CONFIG_NET is
> >> not enabled:
> >> ERROR: "skb_trim" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> >> ERROR: "netlink_kernel_create" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> >> ERROR: "netlink_kernel_release" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> >> ERROR: "skb_pull" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> >> ERROR: "init_net" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> >> ERROR: "__alloc_skb" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> >> ERROR: "netlink_broadcast" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> >> ERROR: "kfree_skb" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> >> ERROR: "skb_put" [drivers/scsi/scsi_transport_iscsi.ko] undefined!
> >>
> >> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> >> Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
> >> ---
> >>  drivers/scsi/bnx2i/Kconfig |    3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> --- lnx-2634-rc6.orig/drivers/scsi/bnx2i/Kconfig
> >> +++ lnx-2634-rc6/drivers/scsi/bnx2i/Kconfig
> >> @@ -1,10 +1,11 @@
> >>  config SCSI_BNX2_ISCSI
> >>  	tristate "Broadcom NetXtreme II iSCSI support"
> >> +	depends on NET
> >> +	depends on PCI
> > 
> > Actually, let's not fix it this way.  While we still have this annoying
> > bug in the Kconfig system where it doesn't respect the dependencies of a
> > select, let's not build traps like this ... the rule has to be selected
> > attributes must select their dependencies, that way the selection just
> > works(tm).
> > 
> > Of course, fixing Kconfig would be the better option ...
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > index 75f2336..804ba3d 100644
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -308,7 +308,8 @@ config SCSI_FC_TGT_ATTRS
> >  
> >  config SCSI_ISCSI_ATTRS
> >  	tristate "iSCSI Transport Attributes"
> > -	depends on SCSI && NET
> > +	depends on SCSI
> > +	select NET
> >  	help
> >  	  If you wish to export transport-specific information about
> >  	  each attached iSCSI device to sysfs, say Y.
> > 
> > 
> 
> I would Nak that but it would probably do no good.
> Selecting NET just adds way too much code to be hidden like this.

I think it's a complete hack too.  But it's better than forcing people
who use select on hidden options (like the transport classes) to be
aware of the nebulous dependency diagram it's going to pull in.  It's
also what we've done to prevent hidden dependencies in other select
items.

> Yes, of course, kconfig should be fixed...

In the absence of volunteers, I suppose I could take a look at it on the
'plane home.  It seems to be a fairly simplistic parser.

James


