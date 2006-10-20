From: akpm@osdl.org
Subject: [patch 25/45] fc4: Conversion to struct scsi_cmnd in fc4
Date: Fri, 20 Oct 2006 14:48:24 -0700
Message-ID: <200610202148.k9KLmObX004144@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:50822 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992785AbWJTVso (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Changes the obsolete Scsi_Cmnd to struct scsi_cmnd in the Fibre Channel
driver (fc4).

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/fc4/fc.c       |   28 +++++++++++++++-------------
 drivers/fc4/fcp_impl.h |   15 ++++++++-------
 2 files changed, 23 insertions(+), 20 deletions(-)

diff -puN drivers/fc4/fc.c~fc4-conversion-to-struct-scsi_cmnd-in-fc4 drivers/fc4/fc.c
--- a/drivers/fc4/fc.c~fc4-conversion-to-struct-scsi_cmnd-in-fc4
+++ a/drivers/fc4/fc.c
@@ -70,9 +70,9 @@
 
 #define FCP_CMND(SCpnt) ((fcp_cmnd *)&(SCpnt->SCp))
 #define FC_SCMND(SCpnt) ((fc_channel *)(SCpnt->device->host->hostdata[0]))
-#define SC_FCMND(fcmnd) ((Scsi_Cmnd *)((long)fcmnd - (long)&(((Scsi_Cmnd *)0)->SCp)))
+#define SC_FCMND(fcmnd)	((struct scsi_cmnd *)((long)fcmnd - (long)&(((struct scsi_cmnd *)0)->SCp)))
 
-static int fcp_scsi_queue_it(fc_channel *, Scsi_Cmnd *, fcp_cmnd *, int);
+static int fcp_scsi_queue_it(fc_channel *, struct scsi_cmnd *, fcp_cmnd *, int);
 void fcp_queue_empty(fc_channel *);
 
 static void fcp_scsi_insert_queue (fc_channel *fc, fcp_cmnd *fcmd)
@@ -378,14 +378,14 @@ void fcp_register(fc_channel *fc, u8 typ
 		printk ("FC: %segistering unknown type %02x\n", unregister ? "Unr" : "R", type);
 }
 
-static void fcp_scsi_done(Scsi_Cmnd *SCpnt);
+static void fcp_scsi_done(struct scsi_cmnd *SCpnt);
 
 static inline void fcp_scsi_receive(fc_channel *fc, int token, int status, fc_hdr *fch)
 {
 	fcp_cmnd *fcmd;
 	fcp_rsp  *rsp;
 	int host_status;
-	Scsi_Cmnd *SCpnt;
+	struct scsi_cmnd *SCpnt;
 	int sense_len;
 	int rsp_status;
 
@@ -757,13 +757,14 @@ void fcp_release(fc_channel *fcchain, in
 }
 
 
-static void fcp_scsi_done (Scsi_Cmnd *SCpnt)
+static void fcp_scsi_done(struct scsi_cmnd *SCpnt)
 {
 	if (FCP_CMND(SCpnt)->done)
 		FCP_CMND(SCpnt)->done(SCpnt);
 }
 
-static int fcp_scsi_queue_it(fc_channel *fc, Scsi_Cmnd *SCpnt, fcp_cmnd *fcmd, int prepare)
+static int fcp_scsi_queue_it(fc_channel *fc, struct scsi_cmnd *SCpnt,
+			     fcp_cmnd *fcmd, int prepare)
 {
 	long i;
 	fcp_cmd *cmd;
@@ -837,7 +838,8 @@ static int fcp_scsi_queue_it(fc_channel 
 	return 0;
 }
 
-int fcp_scsi_queuecommand(Scsi_Cmnd *SCpnt, void (* done)(Scsi_Cmnd *))
+int fcp_scsi_queuecommand(struct scsi_cmnd *SCpnt,
+			  void (* done)(struct scsi_cmnd *))
 {
 	fcp_cmnd *fcmd = FCP_CMND(SCpnt);
 	fc_channel *fc = FC_SCMND(SCpnt);
@@ -873,7 +875,7 @@ void fcp_queue_empty(fc_channel *fc)
 	}
 }
 
-int fcp_scsi_abort(Scsi_Cmnd *SCpnt)
+int fcp_scsi_abort(struct scsi_cmnd *SCpnt)
 {
 	/* Internal bookkeeping only. Lose 1 cmd_slots slot. */
 	fcp_cmnd *fcmd = FCP_CMND(SCpnt);
@@ -910,7 +912,7 @@ int fcp_scsi_abort(Scsi_Cmnd *SCpnt)
 }
 
 #if 0
-void fcp_scsi_reset_done(Scsi_Cmnd *SCpnt)
+void fcp_scsi_reset_done(struct scsi_cmnd *SCpnt)
 {
 	fc_channel *fc = FC_SCMND(SCpnt);
 
@@ -921,7 +923,7 @@ void fcp_scsi_reset_done(Scsi_Cmnd *SCpn
 
 #define FCP_RESET_TIMEOUT (2*HZ)
 
-int fcp_scsi_dev_reset(Scsi_Cmnd *SCpnt)
+int fcp_scsi_dev_reset(struct scsi_cmnd *SCpnt)
 {
 #if 0 /* broken junk, but if davem wants to compile this driver, let him.. */
 	unsigned long flags;
@@ -931,7 +933,7 @@ int fcp_scsi_dev_reset(Scsi_Cmnd *SCpnt)
         DECLARE_MUTEX_LOCKED(sem);
 
 	if (!fc->rst_pkt) {
-		fc->rst_pkt = (Scsi_Cmnd *) kmalloc(sizeof(SCpnt), GFP_KERNEL);
+		fc->rst_pkt = (struct scsi_cmnd *) kmalloc(sizeof(SCpnt), GFP_KERNEL);
 		if (!fc->rst_pkt) return FAILED;
 		
 		fcmd = FCP_CMND(fc->rst_pkt);
@@ -999,7 +1001,7 @@ int fcp_scsi_dev_reset(Scsi_Cmnd *SCpnt)
 	return SUCCESS;
 }
 
-static int __fcp_scsi_host_reset(Scsi_Cmnd *SCpnt)
+static int __fcp_scsi_host_reset(struct scsi_cmnd *SCpnt)
 {
 	fc_channel *fc = FC_SCMND(SCpnt);
 	fcp_cmnd *fcmd = FCP_CMND(SCpnt);
@@ -1020,7 +1022,7 @@ static int __fcp_scsi_host_reset(Scsi_Cm
 	else return FAILED;
 }
 
-int fcp_scsi_host_reset(Scsi_Cmnd *SCpnt)
+int fcp_scsi_host_reset(struct scsi_cmnd *SCpnt)
 {
 	unsigned long flags;
 	int rc;
diff -puN drivers/fc4/fcp_impl.h~fc4-conversion-to-struct-scsi_cmnd-in-fc4 drivers/fc4/fcp_impl.h
--- a/drivers/fc4/fcp_impl.h~fc4-conversion-to-struct-scsi_cmnd-in-fc4
+++ a/drivers/fc4/fcp_impl.h
@@ -39,7 +39,7 @@ struct _fc_channel; 
 typedef struct fcp_cmnd {
 	struct fcp_cmnd		*next;
 	struct fcp_cmnd		*prev;
-	void			(*done)(Scsi_Cmnd *);
+	void			(*done)(struct scsi_cmnd *);
 	unsigned short		proto;
 	unsigned short		token;
 	unsigned int		did;
@@ -94,14 +94,14 @@ typedef struct _fc_channel {
 	long			*scsi_bitmap;
 	long			scsi_bitmap_end;
 	int			scsi_free;
-	int			(*encode_addr)(Scsi_Cmnd *, u16 *, struct _fc_channel *, fcp_cmnd *);
+	int			(*encode_addr)(struct scsi_cmnd *, u16 *, struct _fc_channel *, fcp_cmnd *);
 	fcp_cmnd		*scsi_que;
 	char			scsi_name[4];
 	fcp_cmnd		**cmd_slots;
 	int			channels;
 	int			targets;
 	long			*ages;
-	Scsi_Cmnd		*rst_pkt;
+	struct scsi_cmnd	*rst_pkt;
 	fcp_posmap		*posmap;
 	/* LOGIN stuff */
 	fcp_cmnd		*login;
@@ -155,9 +155,10 @@ int fc_do_prli(fc_channel *, unsigned ch
 	for_each_fc_channel(fc)				\
 		if (fc->state == FC_STATE_ONLINE)
 
-int fcp_scsi_queuecommand(Scsi_Cmnd *, void (* done)(Scsi_Cmnd *));
-int fcp_scsi_abort(Scsi_Cmnd *);
-int fcp_scsi_dev_reset(Scsi_Cmnd *);
-int fcp_scsi_host_reset(Scsi_Cmnd *);
+int fcp_scsi_queuecommand(struct scsi_cmnd *,
+			  void (* done) (struct scsi_cmnd *));
+int fcp_scsi_abort(struct scsi_cmnd *);
+int fcp_scsi_dev_reset(struct scsi_cmnd *);
+int fcp_scsi_host_reset(struct scsi_cmnd *);
 
 #endif /* !(_FCP_SCSI_H) */
_
