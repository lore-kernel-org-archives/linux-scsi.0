From: Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: [PATCH] scsi_error: ensure EH wakes up on error to prevent host
 getting stuck
Date: Mon, 20 Nov 2017 13:11:50 -0600
Message-ID: <f771349c-e391-3d67-4b22-86674fcc7647@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Joshua_Giles@Dell.com
List-Id: linux-scsi@vger.kernel.org

When a command is added to the host's error handler command queue, there is a chance that the error handler will not be woken up.  This can happen when one CPU is running scsi_eh_scmd_add() at the same time as another CPU is running scsi_device_unbusy() for a different command on the same host.  Each function changes one value, and then looks at the value of a variable that the other function has just changed, but if they both see stale data, neither will actually wake up the error handler.

In scsi_eh_scmd_add, host_failed is incremented, then scsi_eh_wakeup() is called, which sees that host_busy is still 2, so it doesn't actually wake up the handler.  Meanwhile, in scsi_device_unbusy(), host_busy is decremented, and then it sees that host_failed is 0, so it doesn't even call scsi_eh_wakeup().

Signed-off-by: Stuart Hyaes <stuart.w.hayes@gmail.com>

---
diff -pur linux-4.14/drivers/scsi/scsi_error.c linux-4.14-stu/drivers/scsi/scsi_error.c
--- linux-4.14/drivers/scsi/scsi_error.c	2017-11-12 12:46:13.000000000 -0600
+++ linux-4.14-stu/drivers/scsi/scsi_error.c	2017-11-17 14:22:19.230867923 -0600
@@ -243,6 +243,10 @@ void scsi_eh_scmd_add(struct scsi_cmnd *
 	scsi_eh_reset(scmd);
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	shost->host_failed++;
+	/*
+	 * See scsi_device_unbusy() for explanation of smp_mb().
+	 */
+	smp_mb();
 	scsi_eh_wakeup(shost);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
diff -pur linux-4.14/drivers/scsi/scsi_lib.c linux-4.14-stu/drivers/scsi/scsi_lib.c
--- linux-4.14/drivers/scsi/scsi_lib.c	2017-11-12 12:46:13.000000000 -0600
+++ linux-4.14-stu/drivers/scsi/scsi_lib.c	2017-11-17 14:22:15.814867833 -0600
@@ -325,6 +325,15 @@ void scsi_device_unbusy(struct scsi_devi
 	unsigned long flags;
 
 	atomic_dec(&shost->host_busy);
+	
+	/* This function changes host_busy and looks at host_failed, while
+	 * scsi_eh_scmd_add() updates host_failed and looks at host_busy (in
+	 * scsi_eh_wakeup())... if these happen simultaneously without the smp
+	 * memory barrier, each can see the old value, such that neither will
+	 * wake up the error handler, which can cause the host controller to
+	 * be hung forever.
+	 */
+	smp_mb();
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
 


---
This email has been checked for viruses by Avast antivirus software.
https://www.avast.com/antivirus
