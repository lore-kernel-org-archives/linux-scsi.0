From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] Call release on scsi legacy LLDD
Date: Thu, 15 May 2003 22:48:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516054838.GA1736@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:1450 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S264293AbTEPFdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 01:33:19 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e32.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h4G5k5kc251356
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2003 01:46:05 -0400
Received: from hmsbounty (sig-9-65-47-206.mts.ibm.com [9.65.47.206])
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h4G5k4ld013982
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2003 23:46:05 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
In the sysfs scsi host reference counting merge the call to a legacy hosts
release function was removed.

This patch adds the call back in.

This patch was tested with insmod / rmmod on LLDDs using the legacy interface
and LLDDs using the new interface:

Legacy Interface:
qla2xxx-v8.00.00b1
qlogicisp
aic7xxx_old (Does not call scsi_unregister in release, but unloaded)

New Interface:
scsi_debug
aic7xxx (Many illegal context warnings caused by mid vs LLDD primitive
         mixing, but appears to unload clean).

EDESC


 drivers/scsi/hosts.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/scsi/hosts.c~scsi-legacy-release-call drivers/scsi/hosts.c
--- sysfs-bleed-2.5/drivers/scsi/hosts.c~scsi-legacy-release-call	Thu May 15 13:05:07 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/hosts.c	Thu May 15 13:08:47 2003
@@ -215,6 +215,10 @@ int scsi_remove_host(struct Scsi_Host *s
 	scsi_proc_host_rm(shost);
 	scsi_forget_host(shost);
 	scsi_sysfs_remove_host(shost);
+
+	if (shost->hostt->release)
+		(*shost->hostt->release)(shost);
+
 	return 0;
 }
 

_

