From: Joe Eykholt <fcoe@eykholt.com>
Subject: [OpenFCoE usr PATCH] Change the default FCoE protocol version to the
	T11 standard-track one.
Date: Tue, 04 Dec 2007 17:49:14 -0800
Message-ID: <20071205014914.13219.66282.stgit@mink.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eykholt.com ([72.52.117.41]:57023 "HELO eykholt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751331AbXLEBtR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 20:49:17 -0500
Received: from mink.he.net ([127.0.0.1]) by eykholt.com for <linux-scsi@vger.kernel.org>; Tue, 4 Dec 2007 17:49:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change the default FCoE protocol version to the T11 standard-track one.

The old version can still be selected using 'fcconf ethX fcoe_version old'.

Signed-off-by: Joe Eykholt <fcoe@eykholt.com>

---
 usr/ofc/tools/fcconf/src/fcc_adapt.c |    1 +
 usr/ofc/tools/fcconf/src/fcc_eth.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/usr/ofc/tools/fcconf/src/fcc_adapt.c b/usr/ofc/tools/fcconf/src/fcc_adapt.c
index eca2d1d..e0fae76 100644
--- a/usr/ofc/tools/fcconf/src/fcc_adapt.c
+++ b/usr/ofc/tools/fcconf/src/fcc_adapt.c
@@ -335,6 +335,7 @@ fcc_adapt_hba_get(void)
                 snprintf(pp->fp_name, sizeof (pp->fp_name), "%s",
                   pp->fp_attr.OSDeviceName);
                 pp->fp_fcoe = 1;
+                pp->fp_fcoe_t11 = 1;
             } else {
                 if (strstr(ap->fa_attr.Manufacturer, "QLogic") != NULL) {
                     pp->fp_fid_alt_format = 1;
diff --git a/usr/ofc/tools/fcconf/src/fcc_eth.c b/usr/ofc/tools/fcconf/src/fcc_eth.c
index f1d4bf9..863a4ba 100644
--- a/usr/ofc/tools/fcconf/src/fcc_eth.c
+++ b/usr/ofc/tools/fcconf/src/fcc_eth.c
@@ -231,6 +231,7 @@ fcc_eth_init_dev(struct dirent *dp, void *arg)
     }
 
     pp->fp_fcoe = 1;
+    pp->fp_fcoe_t11 = 1;
     snprintf(ap->fa_attr.Model, sizeof (ap->fa_attr.Model),
       "%s", FCC_FCOE_ADAPT_MODEL);
     ap->fa_attr.NodeWWN = pp->fp_attr.NodeWWN;


