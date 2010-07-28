From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: dev_loss_tmo behavior question
Date: Wed, 28 Jul 2010 09:57:07 -0700
Message-ID: <20100728165707.GA9844@plapp.qlogic.org>
References: <4C4F4B94.1070009@cs.wisc.edu>
 <4C5055AA.7080703@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:51837 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0G1Q5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 12:57:08 -0400
Content-Disposition: inline
In-Reply-To: <4C5055AA.7080703@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@Emulex.Com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, "Love, Robert W" <robert.w.love@intel.com>, Jing Huang <huangj@Brocade.COM>

On Wed, 28 Jul 2010, James Smart wrote:

> Mike Christie wrote:
> > Hi FC driver developers,
> > 
> > I am trying to figure out what is the correct behavior when setting 
> > dev_loss_tmo.
> > 
> > With lpfc, qla2xx, and ibmfc if I set dev_loss_tmo using 
> > /sys/class/fc_remote_port/rport-xx/dev_loss_tmo, and then we add devices 
> > the slave_configure functions for these drivers reset the dev_loss_tmo 
> > to a driver value.
> > 
> > The addition of devs could be from something like a user rescan, or from 
> > a scan started by a remote port addition.
> 
> Looking at lpfc - this is a totally insane thing to do, and definitely a bug. 
> Addition or removal of sdevs should not change a rport setting.

Completely agree...

> > With fcoe, fnic, mptfc, bfa and zfcp the dev_loss_tmo value set from 
> > sysfs will not be reset by a driver value on rescans.
> > 
> > Which drivers should be changed?
> 
> lpfc, qla2xx, and ibmfc.

I'm curious though, each driver would still need to seed the rport's
dev_loss_tmo value (in the case of qla2xxx,
ha->port_down_retry_count), but, by doing so after rport-addition
(fc_remote_port_add()), the driver could still overwrite a previous
sysfs setting.  Internally, upon rport creation, the dev_loss_tmo
value is seeding with fc_dev_loss_tmo (a module parameter -- 60
seconds).  Should we extend the transport so the the 'default seeding
value' can be specified once at fc_host creation-time?

BTW: fnic looks to be doing the same 'bad' behaviour in their
slave_alloc() call too...

-- av
