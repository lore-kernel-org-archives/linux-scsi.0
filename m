From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 31/51] scsi, bnx2i: Fix CPU hotplug callback registration
Date: Thu, 06 Feb 2014 03:40:16 +0530
Message-ID: <20140205221015.19080.10981.stgit@srivatsabhat.in.ibm.com>
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


Fix the bnx2i code in scsi by using this latter form of callback registration.

Cc: Eddie Wai <eddie.wai@broadcom.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/scsi/bnx2i/bnx2i_init.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 34c294b..5c4e413 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -537,11 +537,15 @@ static int __init bnx2i_mod_init(void)
 		p->iothread = NULL;
 	}
 
+	cpu_maps_update_begin();
+
 	for_each_online_cpu(cpu)
 		bnx2i_percpu_thread_create(cpu);
 
 	/* Initialize per CPU interrupt thread */
-	register_hotcpu_notifier(&bnx2i_cpu_notifier);
+	__register_hotcpu_notifier(&bnx2i_cpu_notifier);
+
+	cpu_maps_update_done();
 
 	return 0;
 
@@ -581,11 +585,15 @@ static void __exit bnx2i_mod_exit(void)
 	}
 	mutex_unlock(&bnx2i_dev_lock);
 
-	unregister_hotcpu_notifier(&bnx2i_cpu_notifier);
+	cpu_maps_update_begin();
 
 	for_each_online_cpu(cpu)
 		bnx2i_percpu_thread_destroy(cpu);
 
+	__unregister_hotcpu_notifier(&bnx2i_cpu_notifier);
+
+	cpu_maps_update_done();
+
 	iscsi_unregister_transport(&bnx2i_iscsi_transport);
 	cnic_unregister_driver(CNIC_ULP_ISCSI);
 }
