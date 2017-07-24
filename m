From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 2/5] scsi/bnx2fc: Prevent recursive cpuhotplug locking
Date: Mon, 24 Jul 2017 12:52:57 +0200
Message-ID: <20170724105341.384083666@linutronix.de>
References: <20170724105255.715647116@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline;
 filename=scsi-bnx2fc--Prevent-recursive-cpuhotplug-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: QLogic-Storage-Upstream@qlogic.com, martin.petersen@oracle.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, kernel test robot <fengguang.wu@intel.com>
List-Id: linux-scsi@vger.kernel.org

The BNX2FC module init/exit code installs/removes the hotplug callbacks with
the cpu hotplug lock held. This worked with the old CPU locking
implementation which allowed recursive locking, but with the new percpu
rwsem based mechanism this is not longer allowed.

Use the _cpuslocked() variants to fix this.

Reported-by: kernel test robot <fengguang.wu@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2766,15 +2766,16 @@ static int __init bnx2fc_mod_init(void)
 	for_each_online_cpu(cpu)
 		bnx2fc_percpu_thread_create(cpu);
 
-	rc = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
-				       "scsi/bnx2fc:online",
-				       bnx2fc_cpu_online, NULL);
+	rc = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ONLINE_DYN,
+						  "scsi/bnx2fc:online",
+						  bnx2fc_cpu_online, NULL);
 	if (rc < 0)
 		goto stop_threads;
 	bnx2fc_online_state = rc;
 
-	cpuhp_setup_state_nocalls(CPUHP_SCSI_BNX2FC_DEAD, "scsi/bnx2fc:dead",
-				  NULL, bnx2fc_cpu_dead);
+	cpuhp_setup_state_nocalls_cpuslocked(CPUHP_SCSI_BNX2FC_DEAD,
+					     "scsi/bnx2fc:dead",
+					     NULL, bnx2fc_cpu_dead);
 	put_online_cpus();
 
 	cnic_register_driver(CNIC_ULP_FCOE, &bnx2fc_cnic_cb);
@@ -2850,8 +2851,8 @@ static void __exit bnx2fc_mod_exit(void)
 		bnx2fc_percpu_thread_destroy(cpu);
 	}
 
-	cpuhp_remove_state_nocalls(bnx2fc_online_state);
-	cpuhp_remove_state_nocalls(CPUHP_SCSI_BNX2FC_DEAD);
+	cpuhp_remove_state_nocalls_cpuslocked(bnx2fc_online_state);
+	cpuhp_remove_state_nocalls_cpuslocked(CPUHP_SCSI_BNX2FC_DEAD);
 
 	put_online_cpus();
 
