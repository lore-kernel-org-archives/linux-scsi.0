From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 05/11] message: Convert to host_lock less w/ interrupts disabled externally
Date: Thu, 11 Nov 2010 16:14:04 -0800
Message-ID: <1289520844-16530-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:24709 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752518Ab0KLAOJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 19:14:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the message/fusion mptsas, mptscsih and mptspi
to run in host_lock less mode with the new IRQ_DISABLE_SCSI_QCMD()
that disables interrupts while calling ->queuecommand() dispatch.

Note that mptfc.c is left out as it checks libfc rport state, which
for the moment still needs the host lock.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/message/fusion/mptsas.c   |    4 ++--
 drivers/message/fusion/mptscsih.c |    8 +++++---
 drivers/message/fusion/mptspi.c   |    4 ++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index d48c2c6..8076110 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1889,7 +1889,7 @@ mptsas_slave_alloc(struct scsi_device *sdev)
 }
 
 static int
-mptsas_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+mptsas_qcmd_irq_disable(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	MPT_SCSI_HOST	*hd;
 	MPT_ADAPTER	*ioc;
@@ -1913,7 +1913,7 @@ mptsas_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	return mptscsih_qcmd(SCpnt,done);
 }
 
-static DEF_SCSI_QCMD(mptsas_qcmd)
+static IRQ_DISABLE_SCSI_QCMD(mptsas_qcmd)
 
 /**
  *	mptsas_mptsas_eh_timed_out - resets the scsi_cmnd timeout
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 59b8f53..4ff996e 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1383,7 +1383,7 @@ mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t off
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_qcmd - Primary Fusion MPT SCSI initiator IO start routine.
+ *	mptscsih_qcmd_irq_disable - Primary Fusion MPT SCSI initiator IO start routine.
  *	@SCpnt: Pointer to scsi_cmnd structure
  *	@done: Pointer SCSI mid-layer IO completion function
  *
@@ -1393,8 +1393,8 @@ mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t off
  *
  *	Returns 0. (rtn value discarded by linux scsi mid-layer)
  */
-int
-mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+static int
+mptscsih_qcmd_irq_disable(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	MPT_SCSI_HOST		*hd;
 	MPT_FRAME_HDR		*mf;
@@ -1529,6 +1529,8 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
+IRQ_DISABLE_SCSI_QCMD(mptscsih_qcmd);
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	mptscsih_freeChainBuffers - Function to free chain buffers associated
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 6d9568d..8e80ce4 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -780,7 +780,7 @@ static int mptspi_slave_configure(struct scsi_device *sdev)
 }
 
 static int
-mptspi_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+mptspi_qcmd_irq_disable(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	struct _MPT_SCSI_HOST *hd = shost_priv(SCpnt->device->host);
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
@@ -805,7 +805,7 @@ mptspi_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	return mptscsih_qcmd(SCpnt,done);
 }
 
-static DEF_SCSI_QCMD(mptspi_qcmd)
+static IRQ_DISABLE_SCSI_QCMD(mptspi_qcmd)
 
 static void mptspi_slave_destroy(struct scsi_device *sdev)
 {
-- 
1.7.2.3

