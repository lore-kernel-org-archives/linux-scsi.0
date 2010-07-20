From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/28] libfc: add discovery-private pointer for LLD
Date: Tue, 20 Jul 2010 15:19:53 -0700
Message-ID: <20100720221953.17116.43443.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1487 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761870Ab0GTWTx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:53 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

For VN_port to VN_port mode, FIP will do discovery and needs a
way to find its state from the local port or discovery structure.
It seems that any other LLD that implements its own discovery
would also need something like this.

Replace disc->lport with disc->priv, and use container_of to
find the lport.  We could use disc->priv for that, but
container_of is smaller and faster.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_disc.c  |   14 +++++++-------
 drivers/scsi/libfc/fc_libfc.h |    2 +-
 include/scsi/libfc.h          |    9 +++++++--
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index d0fa9a0..0447455 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -65,7 +65,7 @@ void fc_disc_stop_rports(struct fc_disc *disc)
 	struct fc_lport *lport;
 	struct fc_rport_priv *rdata;
 
-	lport = disc->lport;
+	lport = fc_disc_lport(disc);
 
 	mutex_lock(&disc->disc_mutex);
 	list_for_each_entry_rcu(rdata, &disc->rports, peers)
@@ -96,7 +96,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 	LIST_HEAD(disc_ports);
 	struct fc_disc_port *dp, *next;
 
-	lport = disc->lport;
+	lport = fc_disc_lport(disc);
 
 	FC_DISC_DBG(disc, "Received an RSCN event\n");
 
@@ -275,7 +275,7 @@ static void fc_disc_start(void (*disc_callback)(struct fc_lport *,
  */
 static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
 {
-	struct fc_lport *lport = disc->lport;
+	struct fc_lport *lport = fc_disc_lport(disc);
 	struct fc_rport_priv *rdata;
 
 	FC_DISC_DBG(disc, "Discovery complete\n");
@@ -313,7 +313,7 @@ static void fc_disc_done(struct fc_disc *disc, enum fc_disc_event event)
  */
 static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 {
-	struct fc_lport *lport = disc->lport;
+	struct fc_lport *lport = fc_disc_lport(disc);
 	unsigned long delay = 0;
 
 	FC_DISC_DBG(disc, "Error %ld, retries %d/%d\n",
@@ -353,7 +353,7 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 static void fc_disc_gpn_ft_req(struct fc_disc *disc)
 {
 	struct fc_frame *fp;
-	struct fc_lport *lport = disc->lport;
+	struct fc_lport *lport = fc_disc_lport(disc);
 
 	WARN_ON(!fc_lport_test_ready(lport));
 
@@ -396,7 +396,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	struct fc_rport_identifiers ids;
 	struct fc_rport_priv *rdata;
 
-	lport = disc->lport;
+	lport = fc_disc_lport(disc);
 	disc->seq_count++;
 
 	/*
@@ -733,7 +733,7 @@ int fc_disc_init(struct fc_lport *lport)
 	mutex_init(&disc->disc_mutex);
 	INIT_LIST_HEAD(&disc->rports);
 
-	disc->lport = lport;
+	disc->priv = lport;
 
 	return 0;
 }
diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index f5c0ca4..16d2162 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -52,7 +52,7 @@ extern unsigned int fc_debug_logging;
 #define FC_DISC_DBG(disc, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_DISC_LOGGING,			\
 			 printk(KERN_INFO "host%u: disc: " fmt,	\
-				(disc)->lport->host->host_no,	\
+				fc_disc_lport(disc)->host->host_no,	\
 				##args))
 
 #define FC_RPORT_ID_DBG(lport, port_id, fmt, args...)			\
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index fcbee8c..5f64e59 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -739,7 +739,7 @@ struct libfc_function_template {
  * @buf_len:       Length of the discovery buffer
  * @disc_id:       Discovery ID
  * @rports:        List of discovered remote ports
- * @lport:         The local port that discovery is for
+ * @priv:          Private pointer for use by discovery code
  * @disc_mutex:    Mutex that protects the discovery context
  * @partial_buf:   Partial name buffer (if names are returned
  *                 in multiple frames)
@@ -755,7 +755,7 @@ struct fc_disc {
 	u16                   disc_id;
 
 	struct list_head      rports;
-	struct fc_lport	      *lport;
+	void		      *priv;
 	struct mutex	      disc_mutex;
 	struct fc_gpn_ft_resp partial_buf;
 	struct delayed_work   disc_work;
@@ -1003,6 +1003,11 @@ void fc_rport_terminate_io(struct fc_rport *);
  *****************************/
 int fc_disc_init(struct fc_lport *);
 
+static inline struct fc_lport *fc_disc_lport(struct fc_disc *disc)
+{
+	return container_of(disc, struct fc_lport, disc);
+}
+
 /*
  * FCP LAYER
  *****************************/

