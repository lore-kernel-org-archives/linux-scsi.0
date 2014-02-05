From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 33/51] scsi, fcoe: Fix CPU hotplug callback registration
Date: Thu, 06 Feb 2014 03:40:34 +0530
Message-ID: <20140205221034.19080.28417.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com, Robert Love <robert.w.love@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
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


Fix the fcoe code in scsi by using this latter form of callback registration.

Cc: Robert Love <robert.w.love@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: fcoe-devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/scsi/fcoe/fcoe.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index f317000..1c299de 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2633,14 +2633,18 @@ static int __init fcoe_init(void)
 		skb_queue_head_init(&p->fcoe_rx_list);
 	}
 
+	cpu_maps_update_begin();
+
 	for_each_online_cpu(cpu)
 		fcoe_percpu_thread_create(cpu);
 
 	/* Initialize per CPU interrupt thread */
-	rc = register_hotcpu_notifier(&fcoe_cpu_notifier);
+	rc = __register_hotcpu_notifier(&fcoe_cpu_notifier);
 	if (rc)
 		goto out_free;
 
+	cpu_maps_update_done();
+
 	/* Setup link change notification */
 	fcoe_dev_setup();
 
@@ -2655,6 +2659,9 @@ out_free:
 	for_each_online_cpu(cpu) {
 		fcoe_percpu_thread_destroy(cpu);
 	}
+
+	cpu_maps_update_done();
+
 	mutex_unlock(&fcoe_config_mutex);
 	destroy_workqueue(fcoe_wq);
 	return rc;
@@ -2687,11 +2694,15 @@ static void __exit fcoe_exit(void)
 	}
 	rtnl_unlock();
 
-	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
+	cpu_maps_update_begin();
 
 	for_each_online_cpu(cpu)
 		fcoe_percpu_thread_destroy(cpu);
 
+	__unregister_hotcpu_notifier(&fcoe_cpu_notifier);
+
+	cpu_maps_update_done();
+
 	mutex_unlock(&fcoe_config_mutex);
 
 	/*
