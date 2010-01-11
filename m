From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: [PATCH] [CVE-2009-3939] megaraid_sas: remove sysfs poll_mode_io
 world writable permissions
Date: Mon, 11 Jan 2010 15:26:39 +0000
Message-ID: <1263223599.1847.158.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-SgIFMRxIRsxwF3+OjGMH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab0AKPXp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jan 2010 10:23:45 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0BFNiui008907
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2010 10:23:45 -0500
Received: from [10.33.0.40] (breeves.fab.redhat.com [10.33.0.40])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o0BFNhEv011571
	for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2010 10:23:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-SgIFMRxIRsxwF3+OjGMH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Linus,

Posted twice to linux-scsi and once to lkml - doesn't seem to have been
picked up yet.

Similar to the problem with dbg_lvl fixed in commit
66dca9b8c50b5e59d3bea8b21cee5c6dae6c9c46 last year.

/sys/bus/pci/drivers/megaraid_sas/poll_mode_io defaults to being
world-writable, which seems bad (letting any user affect kernel driver
behavior).

This turns off group and user write permissions, so that on typical
production systems only root can write to it.

Signed-off-by: Bryn M. Reeves <bmr@redhat.com>

Cheers,
Bryn.


--=-SgIFMRxIRsxwF3+OjGMH
Content-Disposition: attachment; filename=megaraid_sas-restrict-poll_mode_io-write-perms.patch
Content-Type: text/x-patch; name=megaraid_sas-restrict-poll_mode_io-write-perms.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Author: Bryn M. Reeves <bmr@redhat.com>
Date:   Thu Nov 12 18:31:54 2009 +0000

    [SCSI] megaraid_sas: remove sysfs poll_mode_io world writeable permissions
    
    /sys/bus/pci/drivers/megaraid_sas/poll_mode_io defaults to being
    world-writable, which seems bad (letting any user affect kernel driver
    behavior).
    
    This turns off group and user write permissions, so that on typical
    production systems only root can write to it.
    
    Signed-off-by: Bryn M. Reeves <bmr@redhat.com>

diff -up linux-2.6.18.noarch/drivers/scsi/megaraid/megaraid_sas.c.bmr0 linux-2.6.18.noarch/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.18.noarch/drivers/scsi/megaraid/megaraid_sas.c.bmr0	2009-09-28 17:37:47.000000000 +0100
+++ linux-2.6.18.noarch/drivers/scsi/megaraid/megaraid_sas.c	2009-09-28 17:38:16.000000000 +0100
@@ -3548,7 +3548,7 @@ out:
 	return retval;
 }
 
-static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUGO,
+static DRIVER_ATTR(poll_mode_io, S_IRUGO|S_IWUSR,
 			megasas_sysfs_show_poll_mode_io,
 			megasas_sysfs_set_poll_mode_io);
 

--=-SgIFMRxIRsxwF3+OjGMH--

