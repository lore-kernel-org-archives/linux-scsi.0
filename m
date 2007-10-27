From: Rob Landley <rob@landley.net>
Subject: [PATCH 4/15] Update kerneldoc comments in drivers/scsi/scsi_devinfo.c
Date: Fri, 26 Oct 2007 23:10:10 -0500
Message-ID: <200710262310.10304.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47481
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751042AbXJ0DK0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:10:26 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id BE81C73938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:13:09 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_devinfo.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_devinfo.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff -r a868e8217782 drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_devinfo.c	Fri Oct 26 22:44:42 2007 -0500
@@ -276,11 +276,12 @@ static void scsi_strcpy_devinfo(char *na
 }
 
 /**
- * scsi_dev_info_list_add: add one dev_info list entry.
+ * scsi_dev_info_list_add - add one dev_info list entry.
+ * @compatible: if true, null terminate short strings.  Otherwise space pad.
  * @vendor:	vendor string
  * @model:	model (product) string
  * @strflags:	integer string
- * @flag:	if strflags NULL, use this flag value
+ * @flags:	if strflags NULL, use this flag value
  *
  * Description:
  * 	Create and add one dev_info entry for @vendor, @model, @strflags or
@@ -322,8 +323,7 @@ static int scsi_dev_info_list_add(int co
 }
 
 /**
- * scsi_dev_info_list_add_str: parse dev_list and add to the
- * scsi_dev_info_list.
+ * scsi_dev_info_list_add_str - parse dev_list and add to the scsi_dev_info_list.
  * @dev_list:	string of device flags to add
  *
  * Description:
@@ -374,15 +374,15 @@ static int scsi_dev_info_list_add_str(ch
 }
 
 /**
- * get_device_flags - get device specific flags from the dynamic device
- * list. Called during scan time.
+ * get_device_flags - get device specific flags from the dynamic device list.
+ * @sdev:       &scsi_device to get flags for
  * @vendor:	vendor name
  * @model:	model name
  *
  * Description:
  *     Search the scsi_dev_info_list for an entry matching @vendor and
  *     @model, if found, return the matching flags value, else return
- *     the host or global default settings.
+ *     the host or global default settings.  Called during scan time.
  **/
 int scsi_get_device_flags(struct scsi_device *sdev,
 			  const unsigned char *vendor,
@@ -483,13 +483,11 @@ stop_output:
 }
 
 /* 
- * proc_scsi_dev_info_write: allow additions to the scsi_dev_info_list via
- * /proc.
- *
- * Use: echo "vendor:model:flag" > /proc/scsi/device_info
- *
- * To add a black/white list entry for vendor and model with an integer
- * value of flag to the scsi device info list.
+ * proc_scsi_dev_info_write - allow additions to scsi_dev_info_list via /proc.
+ *
+ * Description: Adds a black/white list entry for vendor and model with an
+ * integer value of flag to the scsi device info list.
+ * To use, echo "vendor:model:flag" > /proc/scsi/device_info
  */
 static int proc_scsi_devinfo_write(struct file *file, const char __user *buf,
 				   unsigned long length, void *data)
@@ -532,8 +530,7 @@ MODULE_PARM_DESC(default_dev_flags,
 		 "scsi default device flag integer value");
 
 /**
- * scsi_dev_info_list_delete: called from scsi.c:exit_scsi to remove
- * 	the scsi_dev_info_list.
+ * scsi_dev_info_list_delete - called from scsi.c:exit_scsi to remove the scsi_dev_info_list.
  **/
 void scsi_exit_devinfo(void)
 {
@@ -552,11 +549,10 @@ void scsi_exit_devinfo(void)
 }
 
 /**
- * scsi_dev_list_init: set up the dynamic device list.
- * @dev_list:	string of device flags to add
+ * scsi_dev_list_init - set up the dynamic device list.
  *
  * Description:
- * 	Add command line @dev_list entries, then add
+ * 	Add command line entries from scsi_dev_flags, then add
  * 	scsi_static_device_list entries to the scsi device info list.
  **/
 int __init scsi_init_devinfo(void)

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
