From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: [PATCH] ibmvscsi driver - sixth version
Date: Wed, 31 Mar 2004 22:03:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040401060300.GA13819@praka.local.home>
References: <opr3u0ffo7l6e53g@us.ibm.com> <20040225134518.A4238@infradead.org> <opr3xta6gbl6e53g@us.ibm.com> <1079027038.2820.57.camel@mulgrave> <opr5qwiyw4l6e53g@us.ibm.com> <406B3FDA.9010507@pobox.com> <opr5q1enb6l6e53g@us.ibm.com> <406B5F4C.10000@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:42728 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S262730AbUDAG2R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 01:28:17 -0500
Received: from praka.san.rr.com (66-75-130-8.san.rr.com [66.75.130.8])
	by ms-smtp-03-eri0.socal.rr.com (8.12.10/8.12.7) with ESMTP id i316SEUL023921
	for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2004 22:28:14 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <406B5F4C.10000@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, 31 Mar 2004, Jeff Garzik wrote:

> >>12) in ibmvscsi_probe(), you want to use TASK_UNINTERRUPTIBLE here:
> >>
> >>+            set_current_state(TASK_INTERRUPTIBLE);
> >>+            schedule_timeout(5);
> >>
> >>13) in the code pasted in #12, you should pass a value calculated 
> >>using the 'HZ' constant.
> >Hmmm...above code copied from the qlogic driver...and it looked reasonable
> >to me, but I'll tweak it.
> 
> Well, qlogic is wrong too.  Do you want to submit a patch fixing qlogic 
> while you're at it?  ;-)
> 

Fair enough - the driver isn't checking the return value of
schedule_timeout() in many cases.  How about the attached patch
against scsi-misc-2.6.

Thanks,
Andrew Vasquez

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="set_current_state_fixups_1.diff"

===== drivers/scsi/qla2xxx/qla_init.c 1.11 vs edited =====
--- 1.11/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 09:09:24 2004
+++ edited/drivers/scsi/qla2xxx/qla_init.c	Wed Mar 31 21:48:53 2004
@@ -946,7 +946,7 @@
 			break;
 
 		/* Delay for a while */
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(HZ / 2);
 
 		DEBUG3(printk("scsi(%ld): fw_state=%x curr time=%lx.\n",
===== drivers/scsi/qla2xxx/qla_os.c 1.15 vs edited =====
--- 1.15/drivers/scsi/qla2xxx/qla_os.c	Mon Mar 22 01:13:23 2004
+++ edited/drivers/scsi/qla2xxx/qla_os.c	Wed Mar 31 21:56:30 2004
@@ -912,7 +912,7 @@
 
 		spin_unlock_irq(ha->host->host_lock);
 
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(2*HZ);
 
 		spin_lock_irq(ha->host->host_lock);
@@ -960,7 +960,7 @@
 	    test_bit(ISP_ABORT_RETRY, &ha->dpc_flags)) &&
 		time_before(jiffies, wait_online)) {
 
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(HZ);
 	}
 	if (ha->flags.online == TRUE) 
@@ -1003,7 +1003,7 @@
 	    atomic_read(&ha->loop_state) == LOOP_DOWN) ||
 	    test_bit(CFG_ACTIVE, &ha->cfg_flags) ||
 	    atomic_read(&ha->loop_state) != LOOP_READY) {
-		set_current_state(TASK_INTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(HZ);
 		if (time_after_eq(jiffies, loop_timeout)) {
 			return_status = QLA_FUNCTION_FAILED;
@@ -2123,8 +2123,8 @@
 
 		qla2x00_check_fabric_devices(ha);
 
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(5);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule_timeout(HZ/100);
 	}
 
 	pci_set_drvdata(pdev, ha);
@@ -2866,7 +2866,7 @@
 			    "Memory Allocation failed - request_ring\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_INTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout(HZ/10);
 
 			continue;
@@ -2880,7 +2880,7 @@
 			    "Memory Allocation failed - response_ring\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_INTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout(HZ/10);
 
 			continue;
@@ -2894,7 +2894,7 @@
 			    "Memory Allocation failed - init_cb\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_INTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout(HZ/10);
 
 			continue;
@@ -2907,7 +2907,7 @@
 			    "Memory Allocation failed - ioctl_mem\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_INTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout(HZ/10);
 
 			continue;
@@ -2919,7 +2919,7 @@
 			    "qla2x00_allocate_sp_pool()\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_INTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout(HZ/10);
 
 			continue;
@@ -2936,7 +2936,7 @@
 				    "Memory Allocation failed - sns_cmd\n");
 
 				qla2x00_mem_free(ha);
-				set_current_state(TASK_INTERRUPTIBLE);
+				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(HZ/10);
 
 				continue;
@@ -2952,7 +2952,7 @@
 				    "Memory Allocation failed - ms_iocb\n");
 
 				qla2x00_mem_free(ha);
-				set_current_state(TASK_INTERRUPTIBLE);
+				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(HZ/10);
 
 				continue;
@@ -2971,7 +2971,7 @@
 				    "Memory Allocation failed - ct_sns\n");
 
 				qla2x00_mem_free(ha);
-				set_current_state(TASK_INTERRUPTIBLE);
+				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(HZ/10);
 
 				continue;
@@ -2988,7 +2988,7 @@
 			    "Memory Allocation failed - iodesc_pd\n");
 
 			qla2x00_mem_free(ha);
-			set_current_state(TASK_INTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout(HZ/10);
 
 			continue;

--lrZ03NoBR/3+SXJZ--
