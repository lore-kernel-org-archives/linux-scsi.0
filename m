From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] configfs: change depends -> select SYSFS
Date: Sat, 15 Jan 2011 13:10:51 -0800
Message-ID: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Linus,

The following patch should be included for 38-rc1 to fix a rdd
reported linux-next kbuild warning introduced by TARGET_CORE
using 'select CONFIGFS_FS' from over the holidays, that was not
included with the initial target merge yesterday.

Thanks!

----------------------------------------------------------------

This patch changes configfs to select SYSFS to fix the following:

warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)

This patch also fixes whitespace breakage in the 'help' section.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 fs/configfs/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/configfs/Kconfig b/fs/configfs/Kconfig
index 13587cc..0e4bd23 100644
--- a/fs/configfs/Kconfig
+++ b/fs/configfs/Kconfig
@@ -1,11 +1,11 @@
 config CONFIGFS_FS
 	tristate "Userspace-driven configuration filesystem"
-	depends on SYSFS
+	select SYSFS
 	help
-	  configfs is a ram-based filesystem that provides the converse
-	  of sysfs's functionality. Where sysfs is a filesystem-based
-	  view of kernel objects, configfs is a filesystem-based manager
-	  of kernel objects, or config_items.
+	configfs is a RAM-based filesystem that provides the converse
+	of sysfs's functionality. Where sysfs is a filesystem-based
+	view of kernel objects, configfs is a filesystem-based manager
+	of kernel objects, or config_items.
 
-	  Both sysfs and configfs can and should exist together on the
-	  same system. One is not a replacement for the other.
+	Both sysfs and configfs can and should exist together on the
+	same system. One is not a replacement for the other.
-- 
1.7.3.5
