From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [0/3]   qla2xxx: new experimental changes...
Date: Fri, 04 Feb 2005 11:21:48 -0800
Message-ID: <1107544908.14183.11.camel@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from avexch02.qlogic.com ([198.70.193.200]:33594 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S265202AbVBDTVh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 14:21:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: andrew.vasquez@qlogic.com

All,

Here's a set of patches which begin to strip legacy features from the
qla2xxx driver.  These 'features' have been superceded in functionality
and simplicity by additions present (for some time) in the SCSI
mid-layer.

Here's the breakdown of patches being submitted:

     1. Remove internal command queuing.  This entails removal of the
        driver's *_queue lists as well as modifications and removal of
        routines which used them.  With the queuing removed -- the
        driver will be unable to tolerate cable-pulls.  Thus we depend
        on the next patch for support.
     2. Add initial support for FC remote port infrastructure.  This
        patch is based off the proposal submitted by James Smart:
        ([Patch RFC ] Update FC transport for FC Remote Ports)
        http://marc.theaimsgroup.com/?l=linux-scsi&m=110187926413504&w=2
     3. Remove internal lun discovery routines and support structures.
        The mid-layer has a more exhaustive and fully capable set of
        functions for lun discovery.

Other patches in the queue:

     A. Complete fc_host attributes support.  This patch is mostly
        complete, I'd just like to let the dust settle with the recent
        transport_template changes.
     B. Additional dusting and scrubbing: /proc removal, unused
        functions and structures left over from the cleanup.
     C. lock simplification and consolidation -- we're still reviewing
        the implications of removing the driver's 'hardware_lock' and
        begin using the host->host_lock exclusively.
     D. additional hardware (ISP) support.
     E. firmware loading via request_firmware() infrastructure.


Regards,
Andrew Vasquez
QLogic Corporation
