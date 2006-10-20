From: akpm@osdl.org
Subject: [patch 28/45] scsi: Scsi_Cmnd conversion in qlogicfas408 driver
Date: Fri, 20 Oct 2006 14:48:27 -0700
Message-ID: <200610202148.k9KLmRLQ004158@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:63110 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992786AbWJTVsx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Change obsolete Scsi_Cmnd to struct scsi_cmnd in the Qlocic FAS408 driver.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qlogicfas408.c |   18 +++++++++---------
 drivers/scsi/qlogicfas408.h |   30 +++++++++++++++---------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff -puN drivers/scsi/qlogicfas408.c~scsi-scsi_cmnd-conversion-in-qlogicfas408-driver drivers/scsi/qlogicfas408.c
--- a/drivers/scsi/qlogicfas408.c~scsi-scsi_cmnd-conversion-in-qlogicfas408-driver
+++ a/drivers/scsi/qlogicfas408.c
@@ -209,7 +209,7 @@ static int ql_wai(struct qlogicfas408_pr
  *	caller must hold host lock
  */
 
-static void ql_icmd(Scsi_Cmnd * cmd)
+static void ql_icmd(struct scsi_cmnd *cmd)
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
 	int 	qbase = priv->qbase;
@@ -256,7 +256,7 @@ static void ql_icmd(Scsi_Cmnd * cmd)
  *	Process scsi command - usually after interrupt 
  */
 
-static unsigned int ql_pcmd(Scsi_Cmnd * cmd)
+static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 {
 	unsigned int i, j;
 	unsigned long k;
@@ -407,7 +407,7 @@ static unsigned int ql_pcmd(Scsi_Cmnd * 
 
 static void ql_ihandl(void *dev_id)
 {
-	Scsi_Cmnd *icmd;
+	struct scsi_cmnd *icmd;
 	struct Scsi_Host *host = dev_id;
 	struct qlogicfas408_priv *priv = get_priv_by_host(host);
 	int qbase = priv->qbase;
@@ -447,7 +447,8 @@ irqreturn_t qlogicfas408_ihandl(int irq,
  *	Queued command
  */
 
-int qlogicfas408_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
+int qlogicfas408_queuecommand(struct scsi_cmnd *cmd,
+			      void (*done) (struct scsi_cmnd *))
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
 	if (scmd_id(cmd) == priv->qinitid) {
@@ -470,9 +471,8 @@ int qlogicfas408_queuecommand(Scsi_Cmnd 
  *	Return bios parameters 
  */
 
-int qlogicfas408_biosparam(struct scsi_device * disk,
-		        struct block_device *dev,
-			sector_t capacity, int ip[])
+int qlogicfas408_biosparam(struct scsi_device *disk, struct block_device *dev,
+			   sector_t capacity, int ip[])
 {
 /* This should mimic the DOS Qlogic driver's behavior exactly */
 	ip[0] = 0x40;
@@ -494,7 +494,7 @@ int qlogicfas408_biosparam(struct scsi_d
  *	Abort a command in progress
  */
  
-int qlogicfas408_abort(Scsi_Cmnd * cmd)
+int qlogicfas408_abort(struct scsi_cmnd *cmd)
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
 	priv->qabort = 1;
@@ -508,7 +508,7 @@ int qlogicfas408_abort(Scsi_Cmnd * cmd)
  *	the PCMCIA qlogic_stub code. This wants fixing
  */
 
-int qlogicfas408_bus_reset(Scsi_Cmnd * cmd)
+int qlogicfas408_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
 	unsigned long flags;
diff -puN drivers/scsi/qlogicfas408.h~scsi-scsi_cmnd-conversion-in-qlogicfas408-driver drivers/scsi/qlogicfas408.h
--- a/drivers/scsi/qlogicfas408.h~scsi-scsi_cmnd-conversion-in-qlogicfas408-driver
+++ a/drivers/scsi/qlogicfas408.h
@@ -75,15 +75,15 @@
 /*----------------------------------------------------------------*/
 
 struct qlogicfas408_priv {
-	 int		qbase;		/* Port */
-	 int		qinitid;	/* initiator ID */
-	 int		qabort;		/* Flag to cause an abort */
-	 int		qlirq;		/* IRQ being used */
-	 int		int_type;	/* type of irq, 2 for ISA board, 0 for PCMCIA */
-	 char		qinfo[80];	/* description */
-	 Scsi_Cmnd 	*qlcmd;		/* current command being processed */
-	 struct Scsi_Host *shost;	/* pointer back to host */
-	 struct qlogicfas408_priv *next; /* next private struct */
+	int qbase;		/* Port */
+	int qinitid;		/* initiator ID */
+	int qabort;		/* Flag to cause an abort */
+	int qlirq;		/* IRQ being used */
+	int int_type;		/* type of irq, 2 for ISA board, 0 for PCMCIA */
+	char qinfo[80];		/* description */
+	struct scsi_cmnd *qlcmd;	/* current command being processed */
+	struct Scsi_Host *shost;	/* pointer back to host */
+	struct qlogicfas408_priv *next; /* next private struct */
 };
 
 /* The qlogic card uses two register maps - These macros select which one */
@@ -103,12 +103,12 @@ struct qlogicfas408_priv {
 #define get_priv_by_host(x) (struct qlogicfas408_priv *)&((x)->hostdata[0])
 
 irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id);
-int qlogicfas408_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
-int qlogicfas408_biosparam(struct scsi_device * disk,
-		        struct block_device *dev,
-			sector_t capacity, int ip[]);
-int qlogicfas408_abort(Scsi_Cmnd * cmd);
-int qlogicfas408_bus_reset(Scsi_Cmnd * cmd);
+int qlogicfas408_queuecommand(struct scsi_cmnd *cmd,
+			      void (*done) (struct scsi_cmnd *));
+int qlogicfas408_biosparam(struct scsi_device * disk, struct block_device *dev,
+			   sector_t capacity, int ip[]);
+int qlogicfas408_abort(struct scsi_cmnd *cmd);
+int qlogicfas408_bus_reset(struct scsi_cmnd *cmd);
 const char *qlogicfas408_info(struct Scsi_Host *host);
 int qlogicfas408_get_chip_type(int qbase, int int_type);
 void qlogicfas408_setup(int qbase, int id, int int_type);
_
