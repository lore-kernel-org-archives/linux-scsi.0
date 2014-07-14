From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: mpt2sas stuck installing
Date: Mon, 14 Jul 2014 14:10:00 -0400
Message-ID: <20140714141000.232d5e14@jlaw-desktop.mno.stratus.com>
References: <20140704013250.088477de@jlaw-desktop.mno.stratus.com>
	<53B649A6.60501@julianfamily.org>
	<alpine.DEB.2.02.1407072149190.10980@jlaw-desktop.mno.stratus.com>
	<53BDBB3A.5060906@julianfamily.org>
	<20140711225306.3ce78324@jlaw-desktop.mno.stratus.com>
	<94D0CD8314A33A4D9D801C0FE68B402958B9907B@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o141.mxlogic.net ([208.65.145.74]:33637 "EHLO
	p02c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaGNSKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2014 14:10:08 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B9907B@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Joe Julian <joe@julianfamily.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Joe Maloy <joe.maloy@avagotech.com>

On Sat, 12 Jul 2014 03:13:07 +0000
"Elliott, Robert (Server Storage)" <Elliott@hp.com> wrote:

> 
> 
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Joe Lawrence
> ...
> > In your crash stack trace, the scsi error handler has issued a host
> > reset, but then crashed in mpt2sas_base_get_iocstate.  Reading through
> > _scsih_shutdown, I don't believe that the mpt2sas .shutdown path takes
> > any precaution before heading down mpt2sas_base_detach to free adapter
> > resources.  The ordinary .remove path looks similar, though it does
> > call sas_remove_host before freeing resources, *then* scsi_remove_host
> > and scsi_host_put.
> > 
> > I wonder if this ordering needs to be reversed (and added to
> > _scsih_shutdown) to properly de-register from the SCSI midlayer prior
> > to removing the controller instance.
> > 
> > Regards,
> > 
> > -- Joe
> 
> Nagalakshmi was working on an mpt3sas patch for the scsi-mq tree 
> to do just that.  I don't recall if the patch has made it into the 
> scsi-mq tree yet. Apparently it's also needed for non-mq and mpt2sas.
> 
> It is making this change:
> >  	sas_remove_host(shost);
> > +	scsi_remove_host(shost);
> >  	mpt3sas_base_detach(ioc);
> >  	list_del(&ioc->list);
> > -	scsi_remove_host(shost);
> >  	scsi_host_put(shost);
> 
> We are making a similar change in hpsa.  Doing so led to a general 
> protection fault, which unveiled that we also needed to change 
> cancel_delayed_work() calls to cancel_delayed_work_sync() to 
> ensure there are no worker functions still active after the 
> scsi_host structure is unregistered.

It looks like Sreekanth posted those patches today -- the new ordering
seems correct, but is there any reason why _scsih_shutdown skips
{sas,scsi}_remove_host calls?

Regards,

-- Joe
