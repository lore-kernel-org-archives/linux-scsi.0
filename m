From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 00/21] Roll-up of libsas and aic94xx patches
Date: Thu, 11 Jan 2007 17:13:09 -0500
Message-ID: <200701112213.l0BMD9gk013581@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56820 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbXAKWNN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:13:13 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMDAcP025981
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:13:10 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMD9cZ297722
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:13:09 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMD9KP013599
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:13:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>

Hi all,

This is a roll-up of all of my uncommitted patches against libsas
and aic94xx to date.  There is only one new patch since last month,
which makes aic94xx work with the async SCSI scanning code.

[excerpt from last month's message]

It has been a while since I posted the last batch of patches against
libsas and aic94xx.  In that time, we've been working with Adaptec
engineers to stabilize the driver under disk stress workloads and reboot
tests, and these patches represent the results of this work and a few
other cleanups that have been made along the way.  Each patch has its
own preamble description, but I'd like to call attention to two of the
larger shifts.

Adaptec's sequencer engineers pointed out that a few of the assumptions
that I made about SCB return were invalid, which forced me to rewrite
much of the REQ_TASK_ABORT and REQ_DEVICE RESET code to move all of the
ABORT TASK code into the SAS EH.  By concentrating all error handling in
the EH, the REQ_TASK_ABORT case is less efficient, but the race
conditions and other strange nits that I'd been seeing went away.  In
particular, libsas now handles the case where a sas_task causes the
controller to send both a REQ_TASK_ABORT ESCB and a CHECK CONDITION SCB
response.  These changes are in patches 10-13.

The second major set of changes (14-16) fix the insmod/rmmod and pounder
stability problems by performing correct device memory initialization
and locking device descriptor updates to avoid corrupting the controller
memory.

These patches should apply in number order cleanly against 2.6.20-rc4 +
scsi_misc + scsi-rc-fixes.  We've been running insmod/rmmod and pounder
tests on x260, x206m and x366 machines for several days without problems.
Hopefully these patches are ready for more widespread testing.

(Apologies for any stgit mail misconfiguration on my part.)

--D
