From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: dev_loss_tmo behavior question
Date: Wed, 28 Jul 2010 10:45:10 +0200
Message-ID: <20100728084509.GB3668@schmichrtp.mainz.de.ibm.com>
References: <4C4F4B94.1070009@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:40708 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0G1IpM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 04:45:12 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.1/8.13.1) with ESMTP id o6S8jBVE015678
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2010 08:45:11 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o6S8jB8v1720326
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2010 10:45:11 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o6S8jAFq005471
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2010 10:45:11 +0200
Content-Disposition: inline
In-Reply-To: <4C4F4B94.1070009@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <James.Smart@Emulex.Com>, brking@linux.vnet.ibm.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, "Love, Robert W" <robert.w.love@intel.com>, Jing Huang <huangj@Brocade.COM>

On Tue, Jul 27, 2010 at 04:11:48PM -0500, Mike Christie wrote:
> Hi FC driver developers,
> 
> I am trying to figure out what is the correct behavior when setting
> dev_loss_tmo.
> 
> With lpfc, qla2xx, and ibmfc if I set dev_loss_tmo using
> /sys/class/fc_remote_port/rport-xx/dev_loss_tmo, and then we add
> devices the slave_configure functions for these drivers reset the
> dev_loss_tmo to a driver value.
> 
> The addition of devs could be from something like a user rescan, or
> from a scan started by a remote port addition.
> 
> With fcoe, fnic, mptfc, bfa and zfcp the dev_loss_tmo value set from
> sysfs will not be reset by a driver value on rescans.
> 
> Which drivers should be changed?

At least for zfcp, i don't see a reason for the driver to change the
value for dev_loss_tmo. A user could delete the SCSI device at any
time from userspace (echo 1 > /sys/.../delete), so the driver has to
be able to handle the device removal at any time. And then it should
not matter if the removal is triggered from userspace or from the FC
transport's dev_loss_tmo.

Christof
