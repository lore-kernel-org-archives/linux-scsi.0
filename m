From: Edward Goggin <egoggin@vmware.com>
Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Wed, 10 Jan 2007 11:44:23 -0500
Message-ID: <1168447463.8850.110.camel@egoggin-devd.eng.vmware.com>
References: <65B5F504434AD3469DC12E5564E3794D01EAB81D@PA-EXCH02.vmware.com>
	 <45A4014F.7070203@vmware.com>
	 <1168378357.8850.51.camel@egoggin-devd.eng.vmware.com>
	 <1168445431.10693.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.vmware.com ([65.113.40.130]:32843 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964950AbXAJQpJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2007 11:45:09 -0500
In-Reply-To: <1168445431.10693.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Adam Zimman <azimman@vmware.com>, Petr Vandrovec <petr@vmware.com>, dgreen@vmware.com, Manon Goo <manon@manon.de>, Michael Reed <mdr@sgi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, David Berghoff <david@dg-i.net>, Vicky Xu <vgxu@vmware.com>, "Shirron, Stephen" <Stephen.Shirron@lsi.com>

On Wed, 2007-01-10 at 08:10 -0800, James Bottomley wrote:
> On Tue, 2007-01-09 at 16:32 -0500, Edward Goggin wrote:
> > The attached (untested) patch shows a VMware and scsi transport agnostic
> > approach which introduces a new host status (DID_QUALIFIED_REQUEUE) to
> > be used by mptscsih.c (and other LLDs) instead of DID_BUS_BUSY.  A host
> > status of DID_QUALIFIED_REQUEUE will return ADD_TO_MLQUEUE from
> > scsi_decide_disposition IFF the REQ_FAILFAST bit is not set in the
> > cmd_flags field of the SCSI command's request structure.
> > 
> > The approach depends on both VMware Linux guests not setting
> > REQ_FAILFAST and non-VMware Linux hosts with an IBM RDAC/MPP multi-
> > pathing driver doing so.  This requirement is not a problem for VMware
> > since its guest operating systems have no need to configure block device
> > multi-pathing.  This requirement shouldn't be a problem for the IBM
> > RDAC/MPP driver either since it should already be setting the
> > REQ_FAILFAST attribute of I/Os for which it is providing multi-pathing,
> > similar to what the Linux dm-multipath driver already does.
> 
> Not in the driver, please ...
> 
> the SAM status BUSY is a well known one for array controllers to return
> while contemplating a failover.  Thus, if we think this is the issue,
> the mid-layer should be the entity to pass the status through on
> REQ_FAILFAST not the driver (i.e. pass SAM_STAT_BUSY through unmodified
> and alter the mid-layer).  However, I'd be unhappy about doing this:
> BUSY is a standard return for a lot of controllers for transient
> resource conditions, which wouldn't necessarily be alleviated on path
> failover.
> 
> James
> 

I share your concern about affecting the semantics of SAM_STAT_BUSY.
This is why the patch introduces a new host status instead of simply
changing the code for BUSY in scsi_decide_disposition to requeue only if
not REQ_FAILFAST.

The new host status is meant to provide the option for LLDs to enact
conditional requeuing of the cmd (conditional based on the REQ_FAILFAST
setting) which is not throttled by the cmd's retry count -- a capability
which is not there currently.

> 
