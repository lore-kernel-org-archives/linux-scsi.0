From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [7/15] qla2xxx:  Misc. updates with FO resync
Date: Sun, 14 Mar 2004 00:25:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082505.GA3430@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:12955 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263318AbUCNIWg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:22:36 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1663 04/03/01 14:21:11 andrew.vasquez@apc.qlogic.com +5 -0
  Misc. updates due to resync with non-embedded (failover-aware) driver.
  
   o Add ancillary support definitions.
   o Remove extraneous *_IOCTL #ifs.
   o Make qla2x00_cmd_timeout() and its support routines visible to the 
     non-embedded driver.

 drivers/scsi/qla2xxx/qla_def.h    |   24 +++++--
 drivers/scsi/qla2xxx/qla_gbl.h    |   10 ---
 drivers/scsi/qla2xxx/qla_init.c   |    9 +-
 drivers/scsi/qla2xxx/qla_inline.h |   49 +++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c     |  117 ++------------------------------------
 5 files changed, 82 insertions(+), 127 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/16_misc_updates.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:07:57 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:07:57 2004
@@ -1526,7 +1526,7 @@
 /*
  * Inquiry command structure.
  */
-#define INQ_DATA_SIZE	8
+#define INQ_DATA_SIZE	36
 
 /*
  * Inquiry mailbox IOCB packet definition.
@@ -1580,7 +1580,7 @@
 typedef struct os_tgt {
 	struct os_lun *olun[MAX_LUNS]; /* LUN context pointer. */
 	struct fc_port *fcport;
-	uint32_t flags;
+	unsigned long flags;
 	uint8_t port_down_retry_count;
     	uint32_t down_timer;
 	struct scsi_qla_host *ha;
@@ -1594,10 +1594,9 @@
 /*
  * SCSI Target Queue flags
  */
-#define TQF_QUEUE_SUSPENDED	BIT_0		/* Queue suspended. */
-#define TQF_BOOT_DEVICE		BIT_1		/* Boot device. */
-#define TQF_ONLINE		BIT_2		/* Device online to OS. */
-#define TQF_TGT_RST_NEEDED	BIT_3
+#define TQF_ONLINE		0		/* Device online to OS. */
+#define TQF_SUSPENDED		1
+#define TQF_RETRY_CMDS		2
 
 /*
  * SCSI LUN Queue structure
@@ -1723,6 +1722,12 @@
 #define FCF_RLC_SUPPORT		BIT_14
 #define FCF_CONFIG		BIT_15	/* Needed? */
 #define FCF_RESCAN_NEEDED	BIT_16
+#define FCF_XP_DEVICE		BIT_17
+#define FCF_MSA_DEVICE		BIT_18
+#define FCF_EVA_DEVICE		BIT_19
+#define FCF_MSA_PORT_ACTIVE	BIT_20
+#define FCF_FAILBACK_DISABLE	BIT_21
+#define FCF_FAILOVER_DISABLE	BIT_22
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
@@ -1738,9 +1743,13 @@
 	uint16_t lun;
 	atomic_t state;
 	uint8_t device_type;
+
 	uint8_t max_path_retries;
+	uint32_t flags;
 } fc_lun_t;
 
+#define	FLF_VISIBLE_LUN		BIT_0
+#define	FLF_ACTIVE_LUN		BIT_1
 
 /*
  * FC-CT interface
@@ -2079,6 +2088,7 @@
 #define ISP_ABORT_RETRY         20      /* ISP aborted. */
 #define FCPORT_RESCAN_NEEDED	21      /* IO descriptor processing needed */
 #define IODESC_PROCESS_NEEDED	22      /* IO descriptor processing needed */
+#define IOCTL_ERROR_RECOVERY	23      
 
 	uint32_t	device_flags;
 #define DFLG_LOCAL_DEVICES		BIT_0
@@ -2295,6 +2305,7 @@
 	uint32_t failback_delay;
 	unsigned long   cfg_flags;
 #define	CFG_ACTIVE	0	/* CFG during a failover, event update, or ioctl */
+#define	CFG_FAILOVER	1	/* CFG during path change */
 
 	uint32_t	binding_type;
 #define BIND_BY_PORT_NAME	0
@@ -2327,7 +2338,6 @@
 #define BINZERO		"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
 	char		*model_desc;
 
-/* following are new and needed for IOCTL support */
 	uint8_t     node_name[WWN_SIZE];
 	uint8_t     nvram_version; 
 	uint8_t     optrom_major; 
diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	Fri Mar 12 17:07:57 2004
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	Fri Mar 12 17:07:57 2004
@@ -78,6 +78,8 @@
 
 extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
+extern void qla2x00_cmd_timeout(srb_t *);
+
 extern int qla2x00_queuecommand(struct scsi_cmnd *,
     void (*)(struct scsi_cmnd *));
 
@@ -295,16 +297,8 @@
 /*
  * Global Function Prototypes in qla_xioctl.c source file.
  */
-#ifdef CONFIG_SCSI_QLA2XXX_IOCTL
-extern void qla2x00_enqueue_aen(scsi_qla_host_t *, uint16_t, void *);
-extern int qla2x00_alloc_ioctl_mem(scsi_qla_host_t *);
-extern void qla2x00_free_ioctl_mem(scsi_qla_host_t *);
-extern int qla2x00_get_ioctl_scrap_mem(scsi_qla_host_t *, void **, uint32_t);
-extern void qla2x00_free_ioctl_scrap_mem(scsi_qla_host_t *);
-#else
 #define qla2x00_enqueue_aen(ha, cmd, mode)	do { } while (0)
 #define qla2x00_alloc_ioctl_mem(ha)		(0)
 #define qla2x00_free_ioctl_mem(ha)		do { } while (0)
-#endif
 
 #endif /* _QLA_GBL_H */
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:07:57 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:07:57 2004
@@ -2103,6 +2103,7 @@
 	case TYPE_MEDIUM_CHANGER:
 	case TYPE_ENCLOSURE:
 	case 0x20:
+	case 0x0C:
 		break;
 	case TYPE_TAPE:
 		fcport->flags |= FCF_TAPE_PRESENT;
@@ -3175,7 +3176,6 @@
 		qla2x00_done(ha);
 }
 
-//FIXME - Document
 void
 qla2x00_rescan_fcports(scsi_qla_host_t *ha)
 {
@@ -3194,8 +3194,9 @@
 	}
 
 	/* Update OS target and lun structures if necessary. */
-	if (rescan_done)
+	if (rescan_done) {
 		qla2x00_config_os(ha);
+	}
 }
 
 
@@ -3222,7 +3223,7 @@
 		if ((tq = TGT_Q(ha, tgt)) == NULL)
 			continue;
 
-		tq->flags &= ~TQF_ONLINE;
+		clear_bit(TQF_ONLINE, &tq->flags);
 	}
 
 	list_for_each_entry(fcport, &ha->fcports, list) {
@@ -3324,7 +3325,7 @@
 		fcport->tgt_queue = tq;
 		fcport->flags |= FCF_PERSISTENT_BOUND;
 		tq->fcport = fcport;
-		tq->flags |= TQF_ONLINE;
+		set_bit(TQF_ONLINE, &tq->flags);
 		tq->port_down_retry_count = ha->port_down_retry_count;
 
 #if 0
diff -Nru a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h	Fri Mar 12 17:07:57 2004
+++ b/drivers/scsi/qla2xxx/qla_inline.h	Fri Mar 12 17:07:57 2004
@@ -240,3 +240,52 @@
 	}
 	return (QLA_SUCCESS);
 }
+
+static __inline__ void qla2x00_add_timer_to_cmd(srb_t *, int);
+static __inline__ void qla2x00_delete_timer_from_cmd(srb_t *);
+
+/**************************************************************************
+*   qla2x00_add_timer_to_cmd
+*
+* Description:
+*       Creates a timer for the specified command. The timeout is usually
+*       the command time from kernel minus 2 secs.
+*
+* Input:
+*     sp - pointer to validate
+*
+* Returns:
+*     None.
+**************************************************************************/
+static inline void
+qla2x00_add_timer_to_cmd(srb_t *sp, int timeout)
+{
+	init_timer(&sp->timer);
+	sp->timer.expires = jiffies + timeout * HZ;
+	sp->timer.data = (unsigned long) sp;
+	sp->timer.function = (void (*) (unsigned long))qla2x00_cmd_timeout;
+	add_timer(&sp->timer);
+}
+
+/**************************************************************************
+*   qla2x00_delete_timer_from_cmd
+*
+* Description:
+*       Delete the timer for the specified command.
+*
+* Input:
+*     sp - pointer to validate
+*
+* Returns:
+*     None.
+**************************************************************************/
+static inline void 
+qla2x00_delete_timer_from_cmd(srb_t *sp)
+{
+	if (sp->timer.function != NULL) {
+		del_timer(&sp->timer);
+		sp->timer.function =  NULL;
+		sp->timer.data = (unsigned long) NULL;
+	}
+}
+
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:07:57 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:07:57 2004
@@ -216,55 +216,7 @@
 	ha->timer_active = 0;
 }
 
-
-static void qla2x00_cmd_timeout(srb_t *sp);
-static __inline__ void qla2x00_add_timer_to_cmd(srb_t *sp, int timeout);
-static __inline__ void qla2x00_delete_timer_from_cmd(srb_t *sp);
-
-/**************************************************************************
-*   qla2x00_add_timer_to_cmd
-*
-* Description:
-*       Creates a timer for the specified command. The timeout is usually
-*       the command time from kernel minus 2 secs.
-*
-* Input:
-*     sp - pointer to validate
-*
-* Returns:
-*     None.
-**************************************************************************/
-static inline void
-qla2x00_add_timer_to_cmd(srb_t *sp, int timeout)
-{
-	init_timer(&sp->timer);
-	sp->timer.expires = jiffies + timeout * HZ;
-	sp->timer.data = (unsigned long) sp;
-	sp->timer.function = (void (*) (unsigned long))qla2x00_cmd_timeout;
-	add_timer(&sp->timer);
-}
-
-/**************************************************************************
-*   qla2x00_delete_timer_from_cmd
-*
-* Description:
-*       Delete the timer for the specified command.
-*
-* Input:
-*     sp - pointer to validate
-*
-* Returns:
-*     None.
-**************************************************************************/
-static inline void 
-qla2x00_delete_timer_from_cmd(srb_t *sp)
-{
-	if (sp->timer.function != NULL) {
-		del_timer(&sp->timer);
-		sp->timer.function =  NULL;
-		sp->timer.data = (unsigned long) NULL;
-	}
-}
+void qla2x00_cmd_timeout(srb_t *);
 
 static __inline__ void qla2x00_callback(scsi_qla_host_t *, struct scsi_cmnd *);
 static __inline__ void sp_put(struct scsi_qla_host * ha, srb_t *sp);
@@ -3592,7 +3544,7 @@
 
 
 /*
- * This routine will alloacte SP from the free queue
+ * This routine will allocate SP from the free queue
  * input:
  *        scsi_qla_host_t *
  * output:
@@ -3908,7 +3860,7 @@
 * None.
 * Note:Need to add the support for if( sp->state == SRB_FAILOVER_STATE).
 **************************************************************************/
-static void
+void
 qla2x00_cmd_timeout(srb_t *sp)
 {
 	int t, l;
@@ -3916,9 +3868,6 @@
 	scsi_qla_host_t *vis_ha, *dest_ha;
 	struct scsi_cmnd *cmd;
 	ulong      flags;
-#if defined(QL_DEBUG_LEVEL_3)
-	ulong      cpu_flags;
-#endif
 	fc_port_t	*fcport;
 
 	cmd = sp->cmd;
@@ -4013,55 +3962,7 @@
 
 		 return;
 	}
-/* TODO: Remove this code!!! */
-#if defined(QL_DEBUG_LEVEL_3)
-	spin_lock_irqsave(&dest_ha->list_lock, cpu_flags);
-	if (sp->state == SRB_DONE_STATE) {
-		/* IO in done_q  -- leave it */
-		DEBUG(printk("scsi(%ld): Found in Done queue pid %ld sp=%p.\n",
-		    dest_ha->host_no, cmd->serial_number, sp));
-	} else if (sp->state == SRB_SUSPENDED_STATE) {
-		DEBUG(printk("scsi(%ld): Found SP %p in suspended state  "
-		    "- pid %ld:\n",
-		    dest_ha->host_no, sp, cmd->serial_number));
-		DEBUG(qla2x00_dump_buffer((uint8_t *)sp, sizeof(srb_t));)
-	} else if (sp->state == SRB_ACTIVE_STATE) {
-		/*
-		 * IO is with ISP find the command in our active list.
-		 */
-		spin_unlock_irqrestore(&dest_ha->list_lock, cpu_flags);
-		spin_lock_irqsave(&dest_ha->hardware_lock, flags);
-		if (sp ==
-		    dest_ha->outstanding_cmds[(u_long)sp->cmd->host_scribble]) {
 
-			DEBUG(printk("cmd_timeout: Found in ISP \n");)
-
-			sp->state = SRB_ACTIVE_TIMEOUT_STATE;
-			spin_unlock_irqrestore(&dest_ha->hardware_lock, flags);
-		} else {
-			spin_unlock_irqrestore(&dest_ha->hardware_lock, flags);
-			printk(KERN_INFO 
-				"qla_cmd_timeout: State indicates it is with "
-				"ISP, But not in active array\n");
-		}
-		spin_lock_irqsave(&dest_ha->list_lock, cpu_flags); 	/* 01/03 */
-	} else if (sp->state == SRB_ACTIVE_TIMEOUT_STATE) {
-		DEBUG(printk("qla2100%ld: Found in Active timeout state"
-				"pid %ld, State = %x., \n",
-				dest_ha->host_no,
-				sp->cmd->serial_number, sp->state);)
-	} else {
-		/* EMPTY */
-		DEBUG2(printk("cmd_timeout%ld: LOST command state = "
-				"0x%x, sp=%p\n",
-				vis_ha->host_no, sp->state,sp);)
-
-		qla_printk(KERN_INFO, vis_ha,
-			"cmd_timeout: LOST command state = 0x%x\n", sp->state);
-	}
-	spin_unlock_irqrestore(&dest_ha->list_lock, cpu_flags);
-#endif
-	
 	DEBUG3(printk("cmd_timeout: Leaving\n");)
 }
 
@@ -4472,12 +4373,6 @@
 static int __init
 qla2x00_module_init(void)
 {
-	/* Derive version string. */
-	strcpy(qla2x00_version_str, QLA2XXX_VERSION);
-#if DEBUG_QLA2100
-	strcat(qla2x00_version_str, "-debug");
-#endif
-
 	/* Allocate cache for SRBs. */
 	sprintf(srb_cachep_name, "qla2xxx_srbs");
 	srb_cachep = kmem_cache_create(srb_cachep_name, sizeof(srb_t), 0,
@@ -4487,6 +4382,12 @@
 		    "qla2xxx: Unable to allocate SRB cache...Failing load!\n");
 		return -ENOMEM;
 	}
+
+	/* Derive version string. */
+	strcpy(qla2x00_version_str, QLA2XXX_VERSION);
+#if DEBUG_QLA2100
+	strcat(qla2x00_version_str, "-debug");
+#endif
 
 	printk(KERN_INFO
 	    "QLogic Fibre Channel HBA Driver (%p)\n", qla2x00_set_info);
