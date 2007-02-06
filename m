From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/scsi/aacraid/: cleanups
Date: Tue, 6 Feb 2007 23:12:43 +0100
Message-ID: <20070206221243.GI27397@stusta.de>
References: <20070129204528.eb8d695e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965574AbXBFWMl@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070129204528.eb8d695e.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 29, 2007 at 08:45:28PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm2:
>...
>  git-scsi-misc.patch
>...
>  git trees
>...


This patch contains the following cleanups:
- proper prototypes for global code in aacraid.h
- aac_rx_start_adapter() can now become static

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/aacraid/aacraid.h |    3 +++
 drivers/scsi/aacraid/linit.c   |    2 --
 drivers/scsi/aacraid/nark.c    |    3 ---
 drivers/scsi/aacraid/rkt.c     |    3 ---
 drivers/scsi/aacraid/rx.c      |    2 +-
 5 files changed, 4 insertions(+), 9 deletions(-)

--- linux-2.6.20-rc6-mm3/drivers/scsi/aacraid/aacraid.h.old	2007-02-06 08:22:50.000000000 +0100
+++ linux-2.6.20-rc6-mm3/drivers/scsi/aacraid/aacraid.h	2007-02-06 08:27:17.000000000 +0100
@@ -1840,8 +1840,11 @@
 int aac_get_adapter_info(struct aac_dev* dev);
 int aac_send_shutdown(struct aac_dev *dev);
 int aac_probe_container(struct aac_dev *dev, int cid);
+int _aac_rx_init(struct aac_dev *dev);
+int aac_rx_select_comm(struct aac_dev *dev, int comm);
 extern int numacb;
 extern int acbsize;
 extern char aac_driver_version[];
 extern int startup_timeout;
 extern int aif_timeout;
+extern int expose_physicals;
--- linux-2.6.20-rc6-mm3/drivers/scsi/aacraid/rx.c.old	2007-02-06 08:21:40.000000000 +0100
+++ linux-2.6.20-rc6-mm3/drivers/scsi/aacraid/rx.c	2007-02-06 08:21:50.000000000 +0100
@@ -294,7 +294,7 @@
  *	Start up processing on an i960 based AAC adapter
  */
 
-void aac_rx_start_adapter(struct aac_dev *dev)
+static void aac_rx_start_adapter(struct aac_dev *dev)
 {
 	struct aac_init *init;
 
--- linux-2.6.20-rc6-mm3/drivers/scsi/aacraid/linit.c.old	2007-02-06 08:23:20.000000000 +0100
+++ linux-2.6.20-rc6-mm3/drivers/scsi/aacraid/linit.c	2007-02-06 08:23:26.000000000 +0100
@@ -82,8 +82,6 @@
 static int aac_cfg_major = -1;
 char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
 
-extern int expose_physicals;
-
 /*
  * Because of the way Linux names scsi devices, the order in this table has
  * become important.  Check for on-board Raid first, add-in cards second.
--- linux-2.6.20-rc6-mm3/drivers/scsi/aacraid/nark.c.old	2007-02-06 08:24:47.000000000 +0100
+++ linux-2.6.20-rc6-mm3/drivers/scsi/aacraid/nark.c	2007-02-06 08:24:58.000000000 +0100
@@ -74,9 +74,6 @@
 
 int aac_nark_init(struct aac_dev * dev)
 {
-	extern int _aac_rx_init(struct aac_dev *dev);
-	extern int aac_rx_select_comm(struct aac_dev *dev, int comm);
-
 	/*
 	 *	Fill in the function dispatch table.
 	 */
--- linux-2.6.20-rc6-mm3/drivers/scsi/aacraid/rkt.c.old	2007-02-06 08:25:07.000000000 +0100
+++ linux-2.6.20-rc6-mm3/drivers/scsi/aacraid/rkt.c	2007-02-06 08:25:20.000000000 +0100
@@ -45,7 +45,6 @@
 static int aac_rkt_select_comm(struct aac_dev *dev, int comm)
 {
 	int retval;
-	extern int aac_rx_select_comm(struct aac_dev *dev, int comm);
 	retval = aac_rx_select_comm(dev, comm);
 	if (comm == AAC_COMM_MESSAGE) {
 		/*
@@ -97,8 +96,6 @@
 
 int aac_rkt_init(struct aac_dev *dev)
 {
-	extern int _aac_rx_init(struct aac_dev *dev);
-
 	/*
 	 *	Fill in the function dispatch table.
 	 */
