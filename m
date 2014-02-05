From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 32/51] scsi, bnx2fc: Fix CPU hotplug callback registration
Date: Thu, 06 Feb 2014 03:40:25 +0530
Message-ID: <20140205221024.19080.30665.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com, Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Subsystems that want to register CPU hotplug callbacks, as well as perform
initialization for the CPUs that are already online, often do it as shown
below:

	get_online_cpus();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	register_cpu_notifier(&foobar_cpu_notifier);

	put_online_cpus();

This is wrong, since it is prone to ABBA deadlocks involving the
cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
with CPU hotplug operations).

Instead, the correct and race-free way of performing the callback
registration is:

	cpu_maps_update_begin();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	/* Note the use of the double underscored version of the API */
	__register_cpu_notifier(&foobar_cpu_notifier);

	cpu_maps_update_done();


Fix the bnx2fc code in scsi by using this latter form of callback
registration.

Cc: Eddie Wai <eddie.wai@broadcom.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 9b94850..f6c10c5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2586,12 +2586,16 @@ static int __init bnx2fc_mod_init(void)
 		spin_lock_init(&p->fp_work_lock);
 	}
 
+	cpu_maps_update_begin();
+
 	for_each_online_cpu(cpu) {
 		bnx2fc_percpu_thread_create(cpu);
 	}
 
 	/* Initialize per CPU interrupt thread */
-	register_hotcpu_notifier(&bnx2fc_cpu_notifier);
+	__register_hotcpu_notifier(&bnx2fc_cpu_notifier);
+
+	cpu_maps_update_done();
 
 	cnic_register_driver(CNIC_ULP_FCOE, &bnx2fc_cnic_cb);
 
@@ -2656,13 +2660,17 @@ static void __exit bnx2fc_mod_exit(void)
 	if (l2_thread)
 		kthread_stop(l2_thread);
 
-	unregister_hotcpu_notifier(&bnx2fc_cpu_notifier);
+	cpu_maps_update_begin();
 
 	/* Destroy per cpu threads */
 	for_each_online_cpu(cpu) {
 		bnx2fc_percpu_thread_destroy(cpu);
 	}
 
+	__unregister_hotcpu_notifier(&bnx2fc_cpu_notifier);
+
+	cpu_maps_update_done();
+
 	destroy_workqueue(bnx2fc_wq);
 	/*
 	 * detach from scsi transport
