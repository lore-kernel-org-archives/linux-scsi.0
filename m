From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.3
Date: Wed, 31 Dec 2003 13:22:59 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10312311224140.32122-100000@master.linux-ide.org>
References: <03123116373105.21897@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:6150 "EHLO
	master.linux-ide.org") by vger.kernel.org with ESMTP
	id S265249AbTLaV0A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 16:26:00 -0500
In-Reply-To: <03123116373105.21897@naveenb-lnx.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: hch@infradead.org, Mike Christie <mikenc@us.ibm.com>, linux-scsi@vger.kernel.org


Naveen,

Please clarify that TPGT's do not always represent the same physical
target, but must represent the same storage content regardless.

N targets can represent the same TPGT yet have totally different ip
address and can exist on different physical networks.

You appear to be addressing "active-active" for multi-connection-session
over N-dataports mapping the same TPGT.  This is simple to explain, yet
not as simple to demo beyond a single box with multiple NICs.  This does
not exclude N FC-iSCSI storage routers attached to a director.

Just trying to clarify where "multipathing" and "failover" potentially
resides and not within the bounds of the kernel's scsi mid-layer.  Also
any initiator should be viewed as an effective HBA.  Just as Qlogic has
internal multi-path, any other real or virtual HBA should be permitted
such features.  This should be limited to the HBA and not generally
global.

Channel failings and recoveries should also be permitted if not already.
This could include lun device migration if needed.  The object of hanging
onto failed channels is to preserve some recovery issues with TPGT
failover and returns.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Wed, 31 Dec 2003, Naveen Burmi wrote:

> On Tuesday 30 December 2003 02:53 am, Mike Christie wrote:
> > >>  - as Mike Christie you're doing multipathing in your driver.  We don't
> > >>    want vendor-specific multipathing code in scsi-drivers but instead
> > >>    encurage using md or dm multipathing.
> > >
> > > linux-iscsi driver 4.0.0.2 is not doing multipathing instead it provides
> > > infrastructure to do multipathing and encourages other
> > > applications/drivers like md  to do multipathing.
> >
> > I think Christoph may have meant to write "Failover" above.
> >
> > mike
> 
> Along with Multipath infrastructure iscsi driver provides a feature called 
> "Portal Failover".  
> Portal Failover means that if a network portal fails, through which session 
> is established to a target then session can be established through another 
> available network portal.
>  
> If a target can be reached through multiple network portals then following 
> are the scenarios  which determines the usage of Multipathing and Portal 
> Failover:
> 
> 1. If session(path) is established to target through each portal then Portal 
> failover is not possible only multipathing is possible. Multipath aware 
> drivers can use these paths to do multipathing.
> 
> 2. It is possible that multiples portals can be grouped together into portal 
> groups. If a session(path) is established to target through each portal group 
> i.e, at any instance of time one session(path) is establish using one portal 
> of a portal group, then multiplathing can be done by  multipath aware driver 
> through available paths to target through each portal group and portal 
> failover can be done within the portal group.
> 
> Naveen.
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

