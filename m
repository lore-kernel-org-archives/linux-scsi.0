From: Rob Landley <rob@landley.net>
Subject: [PATCH 5/16] Update kerneldoc comments in drivers/scsi/scsi_error.c
Date: Fri, 26 Oct 2007 23:10:41 -0500
Message-ID: <200710262310.41136.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47484
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751241AbXJ0DK4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:10:56 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id C02C373938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:13:40 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_error.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_error.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff -r a868e8217782 drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_error.c	Fri Oct 26 22:44:42 2007 -0500
@@ -795,7 +795,7 @@ EXPORT_SYMBOL(scsi_eh_finish_cmd);
 /**
  * scsi_eh_get_sense - Get device sense data.
  * @work_q:	Queue of commands to process.
- * @done_q:	Queue of proccessed commands..
+ * @done_q:	Queue of proccessed commands.
  *
  * Description:
  *    See if we need to request sense information.  if so, then get it
@@ -859,7 +859,7 @@ EXPORT_SYMBOL_GPL(scsi_eh_get_sense);
 
 /**
  * scsi_eh_tur - Send TUR to device.
- * @scmd:	Scsi cmd to send TUR
+ * @scmd:	&scsi_cmnd to send TUR
  *
  * Return value:
  *    0 - Device is ready. 1 - Device NOT ready.
@@ -888,14 +888,14 @@ retry_tur:
 }
 
 /**
- * scsi_eh_abort_cmds - abort canceled commands.
- * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * scsi_eh_abort_cmds - abort pending commands.
+ * @work_q:	&list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  * Decription:
  *    Try and see whether or not it makes sense to try and abort the
- *    running command.  this only works out to be the case if we have one
- *    command that has timed out.  if the command simply failed, it makes
+ *    running command.  This only works out to be the case if we have one
+ *    command that has timed out.  If the command simply failed, it makes
  *    no sense to try and abort the command, since as far as the shost
  *    adapter is concerned, it isn't running.
  **/
@@ -932,7 +932,7 @@ static int scsi_eh_abort_cmds(struct lis
 
 /**
  * scsi_eh_try_stu - Send START_UNIT to device.
- * @scmd:	Scsi cmd to send START_UNIT
+ * @scmd:	&scsi_cmnd to send START_UNIT
  *
  * Return value:
  *    0 - Device is ready. 1 - Device NOT ready.
@@ -957,8 +957,9 @@ static int scsi_eh_try_stu(struct scsi_c
 
  /**
  * scsi_eh_stu - send START_UNIT if needed
- * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @shost:	&scsi host being recovered.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  * Notes:
  *    If commands are failing due to not ready, initializing command required,
@@ -1009,10 +1010,11 @@ static int scsi_eh_stu(struct Scsi_Host 
 /**
  * scsi_eh_bus_device_reset - send bdr if needed
  * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  * Notes:
- *    Try a bus device reset.  still, look to see whether we have multiple
+ *    Try a bus device reset.  Still, look to see whether we have multiple
  *    devices that are jammed or not - if we have multiple devices, it
  *    makes no sense to try bus_device_reset - we really would need to try
  *    a bus_reset instead. 
@@ -1064,8 +1066,9 @@ static int scsi_eh_bus_device_reset(stru
 
 /**
  * scsi_eh_bus_reset - send a bus reset 
- * @shost:	scsi host being recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @shost:	&scsi host being recovered.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  **/
 static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			     struct list_head *work_q,
@@ -1441,7 +1444,8 @@ static void scsi_restart_operations(stru
 /**
  * scsi_eh_ready_devs - check device ready state and recover if not.
  * @shost: 	host to be recovered.
- * @eh_done_q:	list_head for processed commands.
+ * @work_q:     &list_head for pending commands.
+ * @done_q:	&list_head for processed commands.
  *
  **/
 void scsi_eh_ready_devs(struct Scsi_Host *shost,

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
