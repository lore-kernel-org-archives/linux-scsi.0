From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] warning cleanup for drivers_scsi_qla1280.c
Date: Mon, 16 Dec 2002 17:43:02 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021216064636.D06F32C2A1@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

[ Indeed, the only call to qla1280_do_dpc is already inside 
  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,1,95), so this changes nothing ]

From:  Eric Sandeen <sandeen@sgi.com>


--- trivial-2.4.21-pre1/drivers/scsi/qla1280.c.orig	2002-12-16 17:22:08.000000000 +1100
+++ trivial-2.4.21-pre1/drivers/scsi/qla1280.c	2002-12-16 17:22:08.000000000 +1100
@@ -312,7 +312,9 @@
 STATIC int qla1280_return_status( sts_entry_t *sts, Scsi_Cmnd       *cp);
 STATIC void qla1280_removeq(scsi_lu_t *q, srb_t *sp);
 STATIC void qla1280_mem_free(scsi_qla_host_t *ha);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,1,95)
 static void qla1280_do_dpc(void *p);
+#endif
 #ifdef  QLA1280_UNUSED 
 static void qla1280_set_flags(char * s);
 #endif
@@ -1611,17 +1613,12 @@
  * "host->can_queue". This can cause a panic if we were in our interrupt
  * code .
  **************************************************************************/
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,1,95)
 static void qla1280_do_dpc(void *p)
 {
     scsi_qla_host_t *ha = (scsi_qla_host_t *) p;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,1,95)
-    unsigned long cpu_flags = 0;
-#endif
 
     COMTRACE('p')  
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,1,95)
-    spin_lock_irqsave(&io_request_lock, cpu_flags);
-#endif
     if (ha->flags.isp_abort_needed)
         qla1280_abort_isp(ha);
 
@@ -1631,10 +1628,8 @@
     if (ha->done_q_first)
         qla1280_done(ha, (srb_t **)&ha->done_q_first, (srb_t **)&ha->done_q_last);
     ha->flags.dpc_sched = FALSE;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,1,95)
-    spin_unlock_irqrestore(&io_request_lock, cpu_flags);
-#endif
 }
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,1,95) */
 
 /**************************************************************************
  *   qla1280_device_queue_depth
-- 
  Don't blame me: the Monkey is driving
  File: Eric Sandeen <sandeen@sgi.com>: warning cleanup for drivers_scsi_qla1280.c
