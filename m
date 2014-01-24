From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/5] ia64 simscsi: fix race condition and simplify the code
Date: Thu, 23 Jan 2014 20:53:09 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401232046500.16873@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401232043320.16873@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401232044180.16873@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401232045350.16873@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1401232045350.16873@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The simscsi driver processes the requests in the request routine and then
offloads the completion callback to a tasklet. This is buggy because there
is parallel unsynchronized access to the completion queue from the request
routine and from the tasklet.

With current SCSI architecture, requests can be completed directly from
the requets routine. So I removed the tasklet code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 arch/ia64/hp/sim/simscsi.c |   34 ++--------------------------------
 1 file changed, 2 insertions(+), 32 deletions(-)

Index: linux-2.6-ia64/arch/ia64/hp/sim/simscsi.c
===================================================================
--- linux-2.6-ia64.orig/arch/ia64/hp/sim/simscsi.c	2014-01-24 01:23:08.000000000 +0100
+++ linux-2.6-ia64/arch/ia64/hp/sim/simscsi.c	2014-01-24 01:26:16.000000000 +0100
@@ -47,9 +47,6 @@
 
 static struct Scsi_Host *host;
 
-static void simscsi_interrupt (unsigned long val);
-static DECLARE_TASKLET(simscsi_tasklet, simscsi_interrupt, 0);
-
 struct disk_req {
 	unsigned long addr;
 	unsigned len;
@@ -64,13 +61,6 @@ static int desc[16] = {
 	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
 };
 
-static struct queue_entry {
-	struct scsi_cmnd *sc;
-} queue[SIMSCSI_REQ_QUEUE_LEN];
-
-static int rd, wr;
-static atomic_t num_reqs = ATOMIC_INIT(0);
-
 /* base name for default disks */
 static char *simscsi_root = DEFAULT_SIMSCSI_ROOT;
 
@@ -95,21 +85,6 @@ simscsi_setup (char *s)
 
 __setup("simscsi=", simscsi_setup);
 
-static void
-simscsi_interrupt (unsigned long val)
-{
-	struct scsi_cmnd *sc;
-
-	while ((sc = queue[rd].sc) != NULL) {
-		atomic_dec(&num_reqs);
-		queue[rd].sc = NULL;
-		if (DBG)
-			printk("simscsi_interrupt: done with %ld\n", sc->serial_number);
-		(*sc->scsi_done)(sc);
-		rd = (rd + 1) % SIMSCSI_REQ_QUEUE_LEN;
-	}
-}
-
 static int
 simscsi_biosparam (struct scsi_device *sdev, struct block_device *n,
 		sector_t capacity, int ip[])
@@ -315,14 +290,9 @@ simscsi_queuecommand_lck (struct scsi_cm
 		sc->sense_buffer[0] = 0x70;
 		sc->sense_buffer[2] = 0x00;
 	}
-	if (atomic_read(&num_reqs) >= SIMSCSI_REQ_QUEUE_LEN) {
-		panic("Attempt to queue command while command is pending!!");
-	}
-	atomic_inc(&num_reqs);
-	queue[wr].sc = sc;
-	wr = (wr + 1) % SIMSCSI_REQ_QUEUE_LEN;
 
-	tasklet_schedule(&simscsi_tasklet);
+	(*sc->scsi_done)(sc);
+
 	return 0;
 }
 
