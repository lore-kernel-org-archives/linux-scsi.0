From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/5] firewire: fw-sbp2: implement nonexclusive login
Date: Sun, 17 Jun 2007 23:55:41 +0200 (CEST)
Message-ID: <tkrat.4c361607a17422f0@s5r6.in-berlin.de>
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

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -31,6 +31,7 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/mod_devicetable.h>
 #include <linux/device.h>
 #include <linux/scatterlist.h>
@@ -48,6 +49,18 @@
 #include "fw-topology.h"
 #include "fw-device.h"
 
+/*
+ * So far only bridges from Oxford Semiconductor are known to support
+ * concurrent logins. Depending on firmware, four or two concurrent logins
+ * are possible on OXFW911 and newer Oxsemi bridges.
+ *
+ * Concurrent logins are useful together with cluster filesystems.
+ */
+static int sbp2_param_exclusive_login = 1;
+module_param_named(exclusive_login, sbp2_param_exclusive_login, bool, 0644);
+MODULE_PARM_DESC(exclusive_login, "Exclusive login to sbp2 device "
+		 "(default = Y, use N for concurrent initiators)");
+
 /* I don't know why the SCSI stack doesn't define something like this... */
 typedef void (*scsi_done_fn_t)(struct scsi_cmnd *);
 
@@ -157,7 +170,7 @@ struct sbp2_orb {
 #define MANAGEMENT_ORB_LUN(v)			((v))
 #define MANAGEMENT_ORB_FUNCTION(v)		((v) << 16)
 #define MANAGEMENT_ORB_RECONNECT(v)		((v) << 20)
-#define MANAGEMENT_ORB_EXCLUSIVE		((1) << 28)
+#define MANAGEMENT_ORB_EXCLUSIVE(v)		((v) ? 1 << 28 : 0)
 #define MANAGEMENT_ORB_REQUEST_FORMAT(v)	((v) << 29)
 #define MANAGEMENT_ORB_NOTIFY			((1) << 31)
 
@@ -433,14 +446,9 @@ sbp2_send_management_orb(struct fw_unit 
 	orb->request.status_fifo.high = sd->address_handler.offset >> 32;
 	orb->request.status_fifo.low  = sd->address_handler.offset;
 
-	/*
-	 * FIXME: Yeah, ok this isn't elegant, we hardwire exclusive
-	 * login and 1 second reconnect time.  The reconnect setting
-	 * is probably fine, but the exclusive login should be an option.
-	 */
 	if (function == SBP2_LOGIN_REQUEST) {
 		orb->request.misc |=
-			MANAGEMENT_ORB_EXCLUSIVE |
+			MANAGEMENT_ORB_EXCLUSIVE(sbp2_param_exclusive_login) |
 			MANAGEMENT_ORB_RECONNECT(0);
 	}
 

-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
