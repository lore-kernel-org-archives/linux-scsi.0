From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] warning cleanup for drivers_scsi_qla1280.c
Date: Wed, 07 Aug 2002 13:59:13 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020807043057.395C74BD6@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

[ Removes the unused warning, and since qla1280_do_dpc is only called when
  version < 2.1.95 anyway, makes the whole thing conditional ]

From:  Eric Sandeen <sandeen@sgi.com>


--- trivial-2.4.20-pre1/drivers/scsi/qla1280.c.orig	2002-08-07 10:57:25.000000000 +1000
+++ trivial-2.4.20-pre1/drivers/scsi/qla1280.c	2002-08-07 10:57:25.000000000 +1000
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
