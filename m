From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] zfcp: convert zfcp to use target reset and device reset handler
Date: Mon, 3 Mar 2008 12:18:10 +0100
Message-ID: <20080303111810.GC20838@schmichrtp.de.ibm.com>
References: <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-6-git-send-email-michaelc@cs.wisc.edu> <20080301133632.GB5098@schmichrtp.de.ibm.com> <20080303093924.GA8698@osiris.boeblingen.de.ibm.com> <20080303101231.GA20838@schmichrtp.de.ibm.com> <20080303101946.GB20838@schmichrtp.de.ibm.com> <20080303104010.GA18398@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:58458 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYCCLSN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 06:18:13 -0500
Received: from d12nrmr1507.megacenter.de.ibm.com (d12nrmr1507.megacenter.de.ibm.com [9.149.167.1])
	by mtagate8.de.ibm.com (8.13.8/8.13.8) with ESMTP id m23BICn3195598
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 11:18:12 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1507.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23BICDD2027684
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 12:18:12 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23BIBro023727
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 11:18:12 GMT
Content-Disposition: inline
In-Reply-To: <20080303104010.GA18398@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, mp3@de.ibm.com, matthew@wil.cx

On Mon, Mar 03, 2008 at 10:40:10AM +0000, Russell King wrote:
> On Mon, Mar 03, 2008 at 11:19:46AM +0100, Christof Schmitt wrote:
> > +static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
> > +{
> > +	int retval;
> > +	struct zfcp_unit *unit = (struct zfcp_unit *) scpnt->device->hostdata;
> 
> Randomly spotted item.  Isn't hostdata of type void *?
> 
>         void *hostdata;         /* available to low-level driver */
> 
> in which case, isn't that cast, which is being added, redundant?

True. The cast was there before, but only in the device_reset_handler.
When touching the code now, we can as well remove it.

--
Christof Schmitt
