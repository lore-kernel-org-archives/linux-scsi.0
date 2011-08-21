From: dann frazier <dann.frazier@canonical.com>
Subject: [PATCH] Add documentation to describe SCSI warm plug operations
Date: Sun, 21 Aug 2011 12:44:27 -0600
Message-ID: <1313952267-31572-1-git-send-email-dann.frazier@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from complete.lackof.org ([198.49.126.79]:45434 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1HUSuM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2011 14:50:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by complete.lackof.org (Postfix) with ESMTP id DBFDA33E0256
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2011 12:44:27 -0600 (MDT)
Received: from complete.lackof.org ([127.0.0.1])
	by localhost (complete.lackof.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r8yIiVQE3uaN for <linux-scsi@vger.kernel.org>;
	Sun, 21 Aug 2011 12:44:27 -0600 (MDT)
Received: from fluid.dannf (localhost [127.0.0.1])
	by complete.lackof.org (Postfix) with ESMTP id BB01833E0188
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2011 12:44:27 -0600 (MDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: dann frazier <dannf@debian.org>

There doesn't appear to be any canonical documentation for adding/removing
SCSI devices for Linux 2.6. We document this procedure for IDE in
Documentation/ide/warm-plug-howto.txt, so I propose we include a SCSI
counterpart doc as well.

The best online resource I found for this was Red Hat's Online Storage
Reconfiguration Guide, so I'm using the procedure described there
(but not their text).

Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 Documentation/scsi/warm-plug-howto.txt |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/scsi/warm-plug-howto.txt

diff --git a/Documentation/scsi/warm-plug-howto.txt b/Documentation/scsi/warm-plug-howto.txt
new file mode 100644
index 0000000..7907cc8
--- /dev/null
+++ b/Documentation/scsi/warm-plug-howto.txt
@@ -0,0 +1,20 @@
+
+SCSI warm-plug HOWTO
+====================
+
+To detect and enumerate any new devices that have been physically added to
+the system on host controller 'hostX':
+
+# echo '- - -' > /sys/class/scsi_host/hostX/scan
+
+To prepare the system to safely remove a device 'sdX':
+
+ 1) Make sure that partitions on sdX are unmounted and that there are
+    no other active references to devices.
+ 2) Flush any outstanding I/O on device sdX:
+     # blockdev --flushbufs /dev/sdX
+ 3) Deactivate the device:
+     # echo 1 > /sys/block/sdX/device/delete
+
+At this point it should be safe to remove the physical sdX device from the
+system.
-- 
1.7.5.4

