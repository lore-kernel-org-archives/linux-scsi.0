From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 4/6] hpsa: Inform controller we are using 32-bit tags.
Date: Tue, 15 Feb 2011 15:33:03 -0600
Message-ID: <20110215213303.5407.70802.stgit@beardog.cce.hp.com>
References: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mike.mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Controller will transfer only 32-bits on completion if it
knows we are only using 32-bit tags.  Also, some newer controllers
apparently (and erroneously) require that we only use 32-bit tags,
and that we inform the controller of this.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |   24 +++++++++++++-----------
 drivers/scsi/hpsa_cmd.h |    1 +
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 563d439..a778cb1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -326,7 +326,7 @@ static ssize_t host_show_transport_mode(struct device *dev,
 
 	h = shost_to_hba(shost);
 	return snprintf(buf, 20, "%s\n",
-		h->transMethod == CFGTBL_Trans_Performant ?
+		h->transMethod & CFGTBL_Trans_Performant ?
 			"performant" : "simple");
 }
 
@@ -340,7 +340,7 @@ static inline u32 next_command(struct ctlr_info *h)
 {
 	u32 a;
 
-	if (unlikely(h->transMethod != CFGTBL_Trans_Performant))
+	if (unlikely(!(h->transMethod & CFGTBL_Trans_Performant)))
 		return h->access.command_completed(h);
 
 	if ((*(h->reply_pool_head) & 1) == (h->reply_pool_wraparound)) {
@@ -364,7 +364,7 @@ static inline u32 next_command(struct ctlr_info *h)
  */
 static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
 {
-	if (likely(h->transMethod == CFGTBL_Trans_Performant))
+	if (likely(h->transMethod & CFGTBL_Trans_Performant))
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
 }
 
@@ -2924,7 +2924,7 @@ static inline u32 hpsa_tag_discard_error_bits(struct ctlr_info *h, u32 tag)
 {
 #define HPSA_PERF_ERROR_BITS ((1 << DIRECT_LOOKUP_SHIFT) - 1)
 #define HPSA_SIMPLE_ERROR_BITS 0x03
-	if (unlikely(h->transMethod != CFGTBL_Trans_Performant))
+	if (unlikely(!(h->transMethod & CFGTBL_Trans_Performant)))
 		return tag & ~HPSA_SIMPLE_ERROR_BITS;
 	return tag & ~HPSA_PERF_ERROR_BITS;
 }
@@ -3640,6 +3640,7 @@ static int __devinit hpsa_enter_simple_mode(struct ctlr_info *h)
 			"unable to get board into simple mode\n");
 		return -ENODEV;
 	}
+	h->transMethod = CFGTBL_Trans_Simple;
 	return 0;
 }
 
@@ -4025,7 +4026,8 @@ static void  calc_bucket_map(int bucket[], int num_buckets,
 	}
 }
 
-static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h)
+static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h,
+	u32 use_short_tags)
 {
 	int i;
 	unsigned long register_value;
@@ -4073,7 +4075,7 @@ static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h)
 	writel(0, &h->transtable->RepQCtrAddrHigh32);
 	writel(h->reply_pool_dhandle, &h->transtable->RepQAddr0Low32);
 	writel(0, &h->transtable->RepQAddr0High32);
-	writel(CFGTBL_Trans_Performant,
+	writel(CFGTBL_Trans_Performant | use_short_tags,
 		&(h->cfgtable->HostWrite.TransportRequest));
 	writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
 	hpsa_wait_for_mode_change_ack(h);
@@ -4083,6 +4085,9 @@ static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h)
 					" performant mode\n");
 		return;
 	}
+	/* Change the access methods to the performant access methods */
+	h->access = SA5_performant_access;
+	h->transMethod = CFGTBL_Trans_Performant;
 }
 
 static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
@@ -4111,11 +4116,8 @@ static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 		|| (h->blockFetchTable == NULL))
 		goto clean_up;
 
-	hpsa_enter_performant_mode(h);
-
-	/* Change the access methods to the performant access methods */
-	h->access = SA5_performant_access;
-	h->transMethod = CFGTBL_Trans_Performant;
+	hpsa_enter_performant_mode(h,
+		trans_support & CFGTBL_Trans_use_short_tags);
 
 	return;
 
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 785abdd..1846490 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -104,6 +104,7 @@
 
 #define CFGTBL_Trans_Simple     0x00000002l
 #define CFGTBL_Trans_Performant 0x00000004l
+#define CFGTBL_Trans_use_short_tags 0x20000000l
 
 #define CFGTBL_BusType_Ultra2   0x00000001l
 #define CFGTBL_BusType_Ultra3   0x00000002l
