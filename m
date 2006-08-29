From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: timeout during sas discovery (aic94xx)
Date: Tue, 29 Aug 2006 09:03:07 -0700
Message-ID: <20060829160307.GA11028@us.ibm.com>
References: <20060828231832.GA1037@us.ibm.com> <44F3D428.60705@us.ibm.com> <1156859623.3458.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48337 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751124AbWH2QFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 12:05:43 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k7TG5ftC000608
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 12:05:41 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7TG5esG268316
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 12:05:40 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7TG5eH5024018
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 12:05:40 -0400
Content-Disposition: inline
In-Reply-To: <1156859623.3458.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi@vger.kernel.org, alexisb@us.ibm.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Mon, 2006-08-28 at 22:44 -0700, Darrick J. Wong wrote:
> > Uh... I don't think that phy_reset function ever gets called.  My
> > ten-second grep of the libsas/aic94xx code doesn't yield and takers.
> > Maybe one of those functions that gets called after time index 575.791
> > should be doing that?
> 
> I see the same thing occasionally in my sata on expanders setup.
> 
> The problem is that the error handling in the SMP functions isn't
> robust.  Try this patch; it works for me(tm), but it's obviously wrong
> since it simply blasts a reset.
> 

"Aug 27 23:32:02 elm3a176 kernel: [  575.791927] sas: command
0xffff8100674d9c80, task
0xffff8100727ede00, timed out: EH_NOT_HANDLED
Aug 27 23:32:02 elm3a176 kernel: [  575.801352] sas: Enter
sas_scsi_recover_host
Aug 27 23:32:02 elm3a176 kernel: [  575.806022] sas: going over list...
Aug 27 23:32:02 elm3a176 kernel: [  575.809894] sas: trying to find task
0xffff8100727ede00
Aug 27 23:32:02 elm3a176 kernel: [  575.815513] sas: sas_scsi_find_task:
aborting task
0xffff8100727ede00
Aug 27 23:32:07 elm3a176 kernel: [  580.818573] aic94xx: tmf timed out
Aug 27 23:32:07 elm3a176 kernel: [  580.822369] aic94xx: tmf came back
"

I think this failure mode is a different path than what your patch tries to
address. We sending a inquiry to the device and coming through the
standard IO path and not through sas_execute_task.

I still think for these cases that we need to be running the patch I
previous sent to the list to try and get the abort to work (this patch is
not in the git tree so one needs to add this on top of the git source).
This will not solve the timeout, but would at least address the tmf time
out.

We need to also address the first issue of the inquiry timeout. Previous
runs showed that we where hitting this error a lot on the inquiry to the
Vitesse SES device which the adp driver has created a work around (unclear
if the work around solves the issue or not).

-andmike
--
Michael Anderson
andmike@us.ibm.com
