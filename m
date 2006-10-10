From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH 7/8] qla2xxx: Stall mid-layer error handlers while rport is blocked.
Date: Tue, 10 Oct 2006 08:11:58 -0700
Message-ID: <20061010151158.GA14909@us.ibm.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156511007-git-send-email-andrew.vasquez@qlogic.com> <452167C8.3010401@emulex.com> <45252E1C.3000403@cs.wisc.edu> <452674E7.9080606@emulex.com> <45268BF9.10007@cs.wisc.edu> <4526934F.1020207@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:20919 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750808AbWJJPNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 11:13:35 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9AFDYET032694
	for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2006 11:13:34 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9AFCjbm097166
	for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2006 11:12:45 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9AFCi1G016520
	for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2006 11:12:45 -0400
Content-Disposition: inline
In-Reply-To: <4526934F.1020207@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

On Fri, Oct 06, 2006 at 01:33:03PM -0400, James Smart wrote:

> I'm not seeing a win in offlining the device.
> 
> >Maybe we need to fix up the SDEV_QUIESCE so we can do diagnostic IOs
> >with SG_IO. Userspace can at least set the device to this state and do
> >some tests but all other IO will not get through and the upper layers do
> >not have to do special things like set the device in READ only or set
> >the path state as failed.
> >
> >Or are you saying that even if we are able to relogin then there will be
> >problems that cannot be handled with the current tools? Something like
> >that one sense bug I was asking you about at OLS right? I am not sure
> >what to do with that?
> 
> I'm questioning offlining, and wouldn't want to make a complicated
> recovery path.

I always thought the offlining was to protect *other* devices attached to
the HBA, so we don't repeatedly quiesce the entire HBA, and possibly reset
the target or HBA attached to the same LU that had a timed out command.

Then onlining in user space is not a problem as far as the given LU is
concerned.

Otherwise, I also can't think of a reason to offline the device.

-- Patrick Mansfield
