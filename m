From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 0/1] scsi_debug: delay stress fix
Date: Wed, 10 Jan 2018 16:57:30 -0500
Message-ID: <20180110215731.4805-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44677 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751607AbeAJV5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jan 2018 16:57:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, bart.vanassche@sandisk.com, hare@suse.de

Bart Van Assche reported that when the scsi_debug driver was being
stress tested with fio, changing the delay paremeter via sysfs
caused a cascade of oops-es. The fix presented reads the driver
wide delay values (jiffies or nanoseconds) once and remembers in
the sdebug_defer object which defer method is used and which 
method has been initialized. This simplifies handling when command
aborts occur.

This causes a minor changes in semantic: a SCSI command "in
flight" is no longer impacted by changing the delay option
after it has been scheduled (i.e. while it is waiting for a work
queue or a hr timer to exhaust).

Douglas Gilbert (1):
  scsi_debug: delay fix

 drivers/scsi/scsi_debug.c | 72 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 26 deletions(-)

-- 
2.14.1
