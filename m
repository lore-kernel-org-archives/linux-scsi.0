From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] hotplug: scsi.agent update for Linux 2.6.13
Date: Thu, 14 Jul 2005 01:44:53 +0200 (CEST)
Message-ID: <200507132344.j6DNisFG022740@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:29358 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S262341AbVGMXpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 19:45:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-hotplug-devel@lists.sourceforge.net
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Linux 2.6.13-rc2 treats RBC devices differently than before. (RBC: Reduced
Block Command set for logical block devices, commonly seen implemented by
SBP-2 harddisks.) Among else, the hotplug helpers now get to read type 14
from sysfs for RBC devices instead of type 0.

The patch updates scsi.agent's device types and re-enables autoloading of
sd_mod for SBP-2 devices under Linux 2.6.13-rc2.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Index: etc/hotplug/scsi.agent
===================================================================
RCS file: /cvsroot/linux-hotplug/admin/etc/hotplug/scsi.agent,v
retrieving revision 1.9
diff -u -r1.9 scsi.agent
--- etc/hotplug/scsi.agent	19 Jan 2005 17:42:46 -0000	1.9
+++ etc/hotplug/scsi.agent	13 Jul 2005 23:41:59 -0000
@@ -50,7 +50,9 @@
     7)		TYPE=mod ; MODULE=sd_mod ;;
     8)		TYPE=changer ;;
     9)		TYPE=comm ;;
-    14)		TYPE=enclosure ;;
+    12)		TYPE=raid ;;
+    13)		TYPE=enclosure ;;
+    14)		TYPE=rbc-disk ;  MODULE=sd_mod ;;
     esac
     if [ "$MODULE" != "" ]; then
 	mesg "$TYPE at $DEVPATH"

