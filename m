From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.3
Date: Wed, 31 Dec 2003 16:37:31 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03123116373105.21897@naveenb-lnx.cisco.com>
References: <03121719101402.28899@naveenb-lnx.cisco.com> <03122920412702.20911@naveenb-lnx.cisco.com> <3FF09B46.5070902@us.ibm.com>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:14709 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S264299AbTLaLGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 06:06:31 -0500
In-Reply-To: <3FF09B46.5070902@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, Mike Christie <mikenc@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday 30 December 2003 02:53 am, Mike Christie wrote:
> >>  - as Mike Christie you're doing multipathing in your driver.  We don't
> >>    want vendor-specific multipathing code in scsi-drivers but instead
> >>    encurage using md or dm multipathing.
> >
> > linux-iscsi driver 4.0.0.2 is not doing multipathing instead it provides
> > infrastructure to do multipathing and encourages other
> > applications/drivers like md  to do multipathing.
>
> I think Christoph may have meant to write "Failover" above.
>
> mike

Along with Multipath infrastructure iscsi driver provides a feature called 
"Portal Failover".  
Portal Failover means that if a network portal fails, through which session 
is established to a target then session can be established through another 
available network portal.
 
If a target can be reached through multiple network portals then following 
are the scenarios  which determines the usage of Multipathing and Portal 
Failover:

1. If session(path) is established to target through each portal then Portal 
failover is not possible only multipathing is possible. Multipath aware 
drivers can use these paths to do multipathing.

2. It is possible that multiples portals can be grouped together into portal 
groups. If a session(path) is established to target through each portal group 
i.e, at any instance of time one session(path) is establish using one portal 
of a portal group, then multiplathing can be done by  multipath aware driver 
through available paths to target through each portal group and portal 
failover can be done within the portal group.

Naveen.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
