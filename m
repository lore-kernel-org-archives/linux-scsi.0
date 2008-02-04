From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 6/24][RFC] gdth: Use of scsi_eh API and sense accessors
Date: Mon,  4 Feb 2008 18:07:16 +0200
Message-ID: <1202141236-4722-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:46245 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbYBDQM6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:12:58 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  Use of new scsi_eh API for setting sense information into
  the scsi command.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   47 ++++++++++++++++++++++++++---------------------
 drivers/scsi/gdth.h |    1 +
 2 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index c825239..9fdd5ef 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2098,6 +2098,16 @@ static void gdth_putq(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar priority)
 #endif
 }
 
+static void gdth_set_4byte_sense(struct scsi_cmnd *scp, u8 sense_code)
+{
+	u8 sense[4];
+
+	memset(sense, 0, sizeof(sense));
+	sense[0] = 0x70;
+	sense[2] = sense_code;
+	scsi_eh_cpy_sense(scp, sense, sizeof(sense));
+}
+
 static void gdth_next(gdth_ha_str *ha)
 {
     register Scsi_Cmnd *pscp;
@@ -2199,9 +2209,7 @@ static void gdth_next(gdth_ha_str *ha)
                     this_cmd = FALSE;
                 next_cmd = FALSE;
             } else {
-                memset((char*)nscp->sense_buffer,0,16);
-                nscp->sense_buffer[0] = 0x70;
-                nscp->sense_buffer[2] = NOT_READY;
+		gdth_set_4byte_sense(nscp, NOT_READY);
                 nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
                 if (!nscp_cmndinfo->wait_for_completion)
                     nscp_cmndinfo->wait_for_completion++;
@@ -2244,9 +2252,7 @@ static void gdth_next(gdth_ha_str *ha)
                     TRACE2(("cmd 0x%x target %d: UNIT_ATTENTION\n",
                              nscp->cmnd[0], t));
                     ha->hdr[t].media_changed = FALSE;
-                    memset((char*)nscp->sense_buffer,0,16);
-                    nscp->sense_buffer[0] = 0x70;
-                    nscp->sense_buffer[2] = UNIT_ATTENTION;
+                    gdth_set_4byte_sense(nscp, UNIT_ATTENTION);
                     nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
                     if (!nscp_cmndinfo->wait_for_completion)
                         nscp_cmndinfo->wait_for_completion++;
@@ -2263,7 +2269,7 @@ static void gdth_next(gdth_ha_str *ha)
                 if ( (nscp->cmnd[4]&1) && !(ha->hdr[t].devtype&1) ) {
                     TRACE(("Prevent r. nonremov. drive->do nothing\n"));
                     nscp->result = DID_OK << 16;
-                    nscp->sense_buffer[0] = 0;
+                    scsi_eh_reset_sense(nscp);
                     if (!nscp_cmndinfo->wait_for_completion)
                         nscp_cmndinfo->wait_for_completion++;
                     else
@@ -2296,9 +2302,7 @@ static void gdth_next(gdth_ha_str *ha)
                     TRACE2(("cmd 0x%x target %d: UNIT_ATTENTION\n",
                              nscp->cmnd[0], t));
                     ha->hdr[t].media_changed = FALSE;
-                    memset((char*)nscp->sense_buffer,0,16);
-                    nscp->sense_buffer[0] = 0x70;
-                    nscp->sense_buffer[2] = UNIT_ATTENTION;
+                    gdth_set_4byte_sense(nscp, UNIT_ATTENTION);
                     nscp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
                     if (!nscp_cmndinfo->wait_for_completion)
                         nscp_cmndinfo->wait_for_completion++;
@@ -2410,7 +2414,6 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
            scp->cmnd[0],t));
 
     scp->result = DID_OK << 16;
-    scp->sense_buffer[0] = 0;
 
     switch (scp->cmnd[0]) {
       case TEST_UNIT_READY:
@@ -2726,8 +2729,8 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
         }
 
     } else {
-        page = virt_to_page(scp->sense_buffer);
-        offset = (ulong)scp->sense_buffer & ~PAGE_MASK;
+        page = virt_to_page(cmndinfo->sense);
+        offset = (ulong)cmndinfo->sense & ~PAGE_MASK;
         sense_paddr = pci_map_page(ha->pdev,page,offset,
                                    16,PCI_DMA_FROMDEVICE);
 
@@ -3395,9 +3398,14 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
             pci_unmap_sg(ha->pdev, gdth_sglist(scp), gdth_sg_count(scp),
                          cmndinfo->dma_dir);
 
-        if (cmndinfo->sense_paddr)
+        if (cmndinfo->sense_paddr) {
             pci_unmap_page(ha->pdev, cmndinfo->sense_paddr, 16,
                                                            PCI_DMA_FROMDEVICE);
+            /* this here is called before gdth_next so it will not
+             * overwrite fake sense returned there.
+             */
+            scsi_eh_cpy_sense(scp, cmndinfo->sense, 16);
+	}
 
         if (ha->status == S_OK) {
             cmndinfo->status = S_OK;
@@ -3441,7 +3449,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                     ha->hdr[t].cluster_type &= ~CLUSTER_RESERVED;
                 }           
                 scp->result = DID_OK << 16;
-                scp->sense_buffer[0] = 0;
+                scsi_eh_reset_sense(scp);
             }
         } else {
             cmndinfo->status = ha->status;
@@ -3457,9 +3465,7 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                     cmndinfo->priority = HIGH_PRI;
                     return 2;
                 }
-                memset((char*)scp->sense_buffer,0,16);
-                scp->sense_buffer[0] = 0x70;
-                scp->sense_buffer[2] = NOT_READY;
+                gdth_set_4byte_sense(scp, NOT_READY);
                 scp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
             } else if (service == CACHESERVICE) {
                 if (ha->status == S_CACHE_UNKNOWN &&
@@ -3468,12 +3474,11 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                     /* bus reset -> force GDT_CLUST_INFO */
                     ha->hdr[t].cluster_type &= ~CLUSTER_RESERVED;
                 }
-                memset((char*)scp->sense_buffer,0,16);
+                scsi_eh_reset_sense(scp);
                 if (ha->status == (ushort)S_CACHE_RESERV) {
                     scp->result = (DID_OK << 16) | (RESERVATION_CONFLICT << 1);
                 } else {
-                    scp->sense_buffer[0] = 0x70;
-                    scp->sense_buffer[2] = NOT_READY;
+                    gdth_set_4byte_sense(scp, NOT_READY);
                     scp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
                 }
                 if (!cmndinfo->internal_command) {
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 1434c6b..5501388 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -915,6 +915,7 @@ typedef struct {
     struct gdth_cmndinfo {                      /* per-command private info */
         int index;
         int internal_command;                   /* don't call scsi_done */
+        u8 sense[16];                           /* 16 is used allover */
         dma_addr_t sense_paddr;                 /* sense dma-addr */
         unchar priority;
         int timeout;
-- 
1.5.3.3

