From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/5] ieee1394: sbp2: change some module parameters from int to
	bool
Date: Sun, 17 Jun 2007 23:54:52 +0200 (CEST)
Message-ID: <tkrat.9092f99d37d86bbe@s5r6.in-berlin.de>
References: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is upwards compatible, except that integer values other than 0 or 1
are no longer accepted.  But values like "Y", "N", "no", "nnoooh!" work
now.

Also, improve a comment on the serialize_io parameter and make the
ORB_SET_EXCLUSIVE macro ultra-safe.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   15 +++++++--------
 drivers/ieee1394/sbp2.h |    2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -118,14 +118,13 @@ MODULE_PARM_DESC(max_speed, "Force max s
 		 "(3 = 800Mb/s, 2 = 400Mb/s, 1 = 200Mb/s, 0 = 100Mb/s)");
 
 /*
- * Set serialize_io to 1 if you'd like only one scsi command sent
- * down to us at a time (debugging). This might be necessary for very
- * badly behaved sbp2 devices.
+ * Set serialize_io to 0 or N to use dynamically appended lists of command ORBs.
+ * This is and always has been buggy in multiple subtle ways. See above TODOs.
  */
 static int sbp2_serialize_io = 1;
-module_param_named(serialize_io, sbp2_serialize_io, int, 0444);
-MODULE_PARM_DESC(serialize_io, "Serialize I/O coming from scsi drivers "
-		 "(default = 1, faster = 0)");
+module_param_named(serialize_io, sbp2_serialize_io, bool, 0444);
+MODULE_PARM_DESC(serialize_io, "Serialize requests coming from SCSI drivers "
+		 "(default = Y, faster but buggy = N)");
 
 /*
  * Bump up max_sectors if you'd like to support very large sized
@@ -154,9 +153,9 @@ MODULE_PARM_DESC(max_sectors, "Change ma
  * are possible on OXFW911 and newer Oxsemi bridges.
  */
 static int sbp2_exclusive_login = 1;
-module_param_named(exclusive_login, sbp2_exclusive_login, int, 0644);
+module_param_named(exclusive_login, sbp2_exclusive_login, bool, 0644);
 MODULE_PARM_DESC(exclusive_login, "Exclusive login to sbp2 device "
-		 "(default = 1)");
+		 "(default = Y, use N for concurrent initiators)");
 
 /*
  * If any of the following workarounds is required for your device to work,
Index: linux/drivers/ieee1394/sbp2.h
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.h
+++ linux/drivers/ieee1394/sbp2.h
@@ -67,7 +67,7 @@ struct sbp2_command_orb {
 #define ORB_SET_LUN(v)			((v) & 0xffff)
 #define ORB_SET_FUNCTION(v)		(((v) & 0xf) << 16)
 #define ORB_SET_RECONNECT(v)		(((v) & 0xf) << 20)
-#define ORB_SET_EXCLUSIVE(v)		(((v) & 0x1) << 28)
+#define ORB_SET_EXCLUSIVE(v)		((v) ? 1 << 28 : 0)
 #define ORB_SET_LOGIN_RESP_LENGTH(v)	((v) & 0xffff)
 #define ORB_SET_PASSWD_LENGTH(v)	(((v) & 0xffff) << 16)
 

-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
