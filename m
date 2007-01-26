From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 0/7] Roll-up of libsas and aic94xx patches
Date: Fri, 26 Jan 2007 17:06:44 -0500
Message-ID: <200701262206.l0QM6iCb017066@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40051 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbXAZWGr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 17:06:47 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0QM7NGX000839
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:07:23 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0QM6jvD063588
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:45 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0QM6jLC017081
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>

Hi all,

This is a roll-up of all of my uncommitted patches against libsas
and aic94xx to date.  The first patch features an important fix for an
incorrect port deformation after a phy reset event.  The next two
patches in this set complete the reorganization of the
sas_rphy_{delete,free} calls after errors during discovery.  The next
two patches amend the SAS error handler to be able to handle scsi_cmnds
that have completed successfully but with a failure code, first by
trying START UNIT if the disk is not spinning, second by trying to
reset the device, and finally offlining the device if nothing works.
The last patch of the set enables auto-restart of SAS disks.

These patches should apply in number order cleanly against 2.6.20-rc6 +
scsi_misc + scsi-rc-fixes.  We've been running insmod/rmmod and pounder
tests on x260, x206m and x366 machines for a couple of days without
problems (albeit against 2.6.20-rc5).  Hopefully these patches are
ready for more widespread testing in scsi-misc, and thank you for any
comments or feedback that you provide.

(Apologies for any stgit mail misconfiguration on my part.)

--D
