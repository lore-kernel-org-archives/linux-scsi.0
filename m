From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/5] hpsa: remove unused busy_initializing and busy_scanning
Date: Wed, 26 Oct 2011 16:20:58 -0500
Message-ID: <20111026212058.15570.34638.stgit@beardog.cce.hp.com>
References: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 ---
 drivers/scsi/hpsa.h |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9b12aea..d59515d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4123,7 +4123,6 @@ reinit_after_soft_reset:
 		return -ENOMEM;
 
 	h->pdev = pdev;
-	h->busy_initializing = 1;
 	h->intr_mode = hpsa_simple_mode ? SIMPLE_MODE_INT : PERF_MODE_INT;
 	INIT_LIST_HEAD(&h->cmpQ);
 	INIT_LIST_HEAD(&h->reqQ);
@@ -4232,7 +4231,6 @@ reinit_after_soft_reset:
 
 	hpsa_hba_inquiry(h);
 	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
-	h->busy_initializing = 0;
 	return 1;
 
 clean4:
@@ -4241,7 +4239,6 @@ clean4:
 	free_irq(h->intr[h->intr_mode], h);
 clean2:
 clean1:
-	h->busy_initializing = 0;
 	kfree(h);
 	return rc;
 }
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 7f53cea..111b79e 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -95,8 +95,6 @@ struct ctlr_info {
 	unsigned long  		*cmd_pool_bits;
 	int			nr_allocs;
 	int			nr_frees;
-	int			busy_initializing;
-	int			busy_scanning;
 	int			scan_finished;
 	spinlock_t		scan_lock;
 	wait_queue_head_t	scan_wait_queue;
