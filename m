From: James Smart <james.smart@emulex.com>
Subject: Re: dev_loss_tmo behavior question
Date: Wed, 28 Jul 2010 12:07:06 -0400
Message-ID: <4C5055AA.7080703@emulex.com>
References: <4C4F4B94.1070009@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:46938 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752075Ab0G1QHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 12:07:31 -0400
In-Reply-To: <4C4F4B94.1070009@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, "Love, Robert W" <robert.w.love@intel.com>, Jing Huang <huangj@Brocade.COM>, "Smart, James" <James.Smart@Emulex.Com>



Mike Christie wrote:
> Hi FC driver developers,
> 
> I am trying to figure out what is the correct behavior when setting 
> dev_loss_tmo.
> 
> With lpfc, qla2xx, and ibmfc if I set dev_loss_tmo using 
> /sys/class/fc_remote_port/rport-xx/dev_loss_tmo, and then we add devices 
> the slave_configure functions for these drivers reset the dev_loss_tmo 
> to a driver value.
> 
> The addition of devs could be from something like a user rescan, or from 
> a scan started by a remote port addition.

Looking at lpfc - this is a totally insane thing to do, and definitely a bug. 
Addition or removal of sdevs should not change a rport setting.

> 
> With fcoe, fnic, mptfc, bfa and zfcp the dev_loss_tmo value set from 
> sysfs will not be reset by a driver value on rescans.
> 
> Which drivers should be changed?

lpfc, qla2xx, and ibmfc.

-- james s
