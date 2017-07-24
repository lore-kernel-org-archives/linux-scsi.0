From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 3/5] scsi/bnx2i: Prevent recursive cpuhotplug locking
Date: Mon, 24 Jul 2017 12:52:58 +0200
Message-ID: <20170724105341.468351363@linutronix.de>
References: <20170724105255.715647116@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline;
 filename=scsu-bnx2i--Prevent-recursive-cpuhotplug-locking.patch
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: QLogic-Storage-Upstream@qlogic.com, martin.petersen@oracle.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
List-Id: linux-scsi@vger.kernel.org

The BNX2I module init/exit code installs/removes the hotplug callbacks with
the cpu hotplug lock held. This worked with the old CPU locking
implementation which allowed recursive locking, but with the new percpu
rwsem based mechanism this is not longer allowed.

Use the _cpuslocked() variants to fix this.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/scsi/bnx2i/bnx2i_init.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -516,15 +516,16 @@ static int __init bnx2i_mod_init(void)
 	for_each_online_cpu(cpu)
 		bnx2i_percpu_thread_create(cpu);
 
-	err = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
-				       "scsi/bnx2i:online",
-				       bnx2i_cpu_online, NULL);
+	err = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ONLINE_DYN,
+						   "scsi/bnx2i:online",
+						   bnx2i_cpu_online, NULL);
 	if (err < 0)
 		goto remove_threads;
 	bnx2i_online_state = err;
 
-	cpuhp_setup_state_nocalls(CPUHP_SCSI_BNX2I_DEAD, "scsi/bnx2i:dead",
-				  NULL, bnx2i_cpu_dead);
+	cpuhp_setup_state_nocalls_cpuslocked(CPUHP_SCSI_BNX2I_DEAD,
+					     "scsi/bnx2i:dead",
+					     NULL, bnx2i_cpu_dead);
 	put_online_cpus();
 	return 0;
 
@@ -574,8 +575,8 @@ static void __exit bnx2i_mod_exit(void)
 	for_each_online_cpu(cpu)
 		bnx2i_percpu_thread_destroy(cpu);
 
-	cpuhp_remove_state_nocalls(bnx2i_online_state);
-	cpuhp_remove_state_nocalls(CPUHP_SCSI_BNX2I_DEAD);
+	cpuhp_remove_state_nocalls_cpuslocked(bnx2i_online_state);
+	cpuhp_remove_state_nocalls_cpuslocked(CPUHP_SCSI_BNX2I_DEAD);
 	put_online_cpus();
 
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
