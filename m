From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] scsi: EH Start Unit timeout
Date: Thu, 19 Apr 2007 13:59:59 -0500
Message-ID: <39179.3614406653$1177009428@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:35832 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766924AbXDSTDY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Apr 2007 15:03:24 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3JJ01cO015771
	for <linux-scsi@vger.kernel.org>; Thu, 19 Apr 2007 15:00:01 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3JJ011L178244
	for <linux-scsi@vger.kernel.org>; Thu, 19 Apr 2007 13:00:01 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3JJ01gF012067
	for <linux-scsi@vger.kernel.org>; Thu, 19 Apr 2007 13:00:01 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Use the sysfs configurable timeout when issuing a START_UNIT
command from the scsi error handler. This is needed for devices which
take longer than thirty seconds to respond to the start
unit. The problem was observed when sending a start unit
to a disk array device in an ipr RAID adapter, which results
in the adapter firmware sending potentially multiple commands
to physical devices as a result of this command, which ended
up timing out sometimes. This patch does not change the default
value used for this command.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

James,

This patch applies on top of the start unit retry patch referenced
here:

http://marc.info/?l=linux-scsi&m=117544524204024&w=2

This patch isn't in scsi-misc yet, but I assume it is in your queue.

Thanks,

Brian
---

 linux-2.6-bjking1/drivers/scsi/scsi_error.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_error.c~scsi_eh_stu_timeout drivers/scsi/scsi_error.c
--- linux-2.6/drivers/scsi/scsi_error.c~scsi_eh_stu_timeout	2007-04-19 13:48:37.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/scsi_error.c	2007-04-19 13:48:37.000000000 -0500
@@ -38,7 +38,6 @@
 #include "scsi_logging.h"
 
 #define SENSE_TIMEOUT		(10*HZ)
-#define START_UNIT_TIMEOUT	(30*HZ)
 
 /*
  * These should *probably* be handled by the host itself.
@@ -927,7 +926,7 @@ static int scsi_eh_try_stu(struct scsi_c
 
 		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
 			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
-						START_UNIT_TIMEOUT, 0);
+						scmd->device->timeout, 0);
 
 		if (rtn == SUCCESS)
 			return 0;
_
