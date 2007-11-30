From: Joe Eykholt <fcoe@eykholt.com>
Subject: [OpenFCoE] [PATCH] (user-libfc) Change the default FCoE protocol
 version to the T11 (Aug. 2007) version.
Date: Fri, 30 Nov 2007 10:59:44 -0800
Message-ID: <47505DA0.5070702@eykholt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:45159 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757749AbXK3S7g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Nov 2007 13:59:36 -0500
Received: from 67.91.200.194 ([67.91.200.194]) by eykholt.com for <linux-scsi@vger.kernel.org>; Fri, 30 Nov 2007 10:59:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change the default FCoE protocol version to the T11 (Aug. 2007) version.

Use environment to override:  export FCOE_OLD_ALL=1 to use the old protocol
on all interfaces, or FCOE_OLD_eth0=1 to use it on eth0.
---
 usr/common/libfc/src/encaps/fcoe.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/usr/common/libfc/src/encaps/fcoe.c b/usr/common/libfc/src/encaps/fcoe.c
index 017e41e..4a0d9f0 100644
--- a/usr/common/libfc/src/encaps/fcoe.c
+++ b/usr/common/libfc/src/encaps/fcoe.c
@@ -60,8 +60,8 @@

 #define FCOE_ET_VAR     "FCOE_ETHERTYPE"    /* env. var. for ethertype */
 #define FCOE_OUI_VAR    "FCOE_OUI"          /* env. var. for OUI */
-#define FCOE_NEW_VAR    "FCOE_NEW_%s"       /* env. var. for new version */
-#define FCOE_NEW_ALL_VAR "FCOE_NEW_ALL"     /* env. var. for new version */
+#define FCOE_OLD_VAR    "FCOE_OLD_%s"       /* env. var. for old version */
+#define FCOE_OLD_ALL_VAR "FCOE_OLD_ALL"     /* env. var. for old version */

 #define FC_FCOE_BUFLEN  2200        /* buffer size for reads */
 #define FC_FCOE_SOCKBUF_LEN (512 * 1024) /* requested receive socket buf size */
@@ -158,11 +158,11 @@ fc_fcoe_create(const char *ifname, u_int vlan,
     char    buf[40];

     /*
-     * Test for presense of env. variables FCOE_NEW_<ifname> or FCOE_NEW.
-     * If these are not there, the older version is used.
+     * Test for presense of env. variables FCOE_OLD_<ifname> or FCOE_OLD_ALL.
+     * If any of these are there, the older protocol version is used.
      */
-    snprintf(buf, sizeof (buf), FCOE_NEW_VAR, ifname);
-    if ((getenv(buf) == NULL && getenv(FCOE_NEW_ALL_VAR) == NULL) ||
+    snprintf(buf, sizeof (buf), FCOE_OLD_VAR, ifname);
+    if (getenv(buf) != NULL || getenv(FCOE_OLD_ALL_VAR) != NULL ||
       (options & FC_OPT_FCOE_OLD) != 0) {
         return (fc_fcoe_create_old(ifname, vlan, src_mac, dest_mac, options));
     }
--
1.5.3.6

