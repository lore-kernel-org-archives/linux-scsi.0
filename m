From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/5] gdth: fix to internal commands execution
Date: Thu, 14 Feb 2008 20:55:05 +0200
Message-ID: <47B48E89.4080405@panasas.com>
References: <47B48CAE.2020705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:12916 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757603AbYBNS5G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 13:57:06 -0500
In-Reply-To: <47B48CAE.2020705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@HansenPartn>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Milter <davemilter@gmail.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>


The recent patch named:
  [SCSI] gdth: !use_sg cleanup and use of scsi accessors

has done a bad job in handling internal commands issued by gdth_execute().

Internal commands are issued with device gdth_cmd_str ready made directly
to the card, without any mapping or translations of scsi commands. So here
I added a gdth_cmd_str pointer to the gdth_cmndinfo private structure which
is then copied directly to host.

following this patch is a cleanup that removes the home cooked accessors
and reverts them to regular scsi_cmnd accessors. Since they are not used
anymore. After review maybe the 2 patches should be squashed together.

FIXME: There is still a problem with gdth_get_info(). as reported there
   is a WARN_ON trigerd in dma_free_coherent() when doing:
   $ cat /proc/sys/gdth/0

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   30 ++++++++++++------------------
 drivers/scsi/gdth.h |    1 +
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 0979553..077f972 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -160,7 +160,7 @@ static void gdth_readapp_event(gdth_ha_str *ha, unchar application,
 static void gdth_clear_events(void);
 
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
-                                    char *buffer, ushort count, int to_buffer);
+                                    char *buffer, ushort count);
 static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
 static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
 
@@ -439,8 +439,8 @@ static struct gdth_cmndinfo *gdth_get_cmndinfo(gdth_ha_str *ha)
 	for (i=0; i<GDTH_MAXCMDS; ++i) {
 		if (ha->cmndinfo[i].index == 0) {
 			priv = &ha->cmndinfo[i];
-			priv->index = i+1;
 			memset(priv, 0, sizeof(*priv));
+			priv->index = i+1;
 			break;
 		}
 	}
@@ -487,7 +487,6 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     gdth_ha_str *ha = shost_priv(sdev->host);
     Scsi_Cmnd *scp;
     struct gdth_cmndinfo cmndinfo;
-    struct scatterlist one_sg;
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
@@ -501,13 +500,10 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
     scp->timeout_per_command = timeout*HZ;
-    sg_init_one(&one_sg, gdtcmd, sizeof(*gdtcmd));
-    gdth_set_sglist(scp, &one_sg);
-    gdth_set_sg_count(scp, 1);
-    gdth_set_bufflen(scp, sizeof(*gdtcmd));
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
     cmndinfo.priority = IOCTL_PRI;
+    cmndinfo.internal_cmd_str = gdtcmd;
     cmndinfo.internal_command = 1;
 
     TRACE(("__gdth_execute() cmd 0x%x\n", scp->cmnd[0]));
@@ -2351,7 +2347,7 @@ static void gdth_next(gdth_ha_str *ha)
  * buffers, kmap_atomic() as needed.
  */
 static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
-                                    char *buffer, ushort count, int to_buffer)
+                                    char *buffer, ushort count)
 {
     ushort cpcount,i, max_sg = gdth_sg_count(scp);
     ushort cpsum,cpnow;
@@ -2377,10 +2373,7 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
             }
             local_irq_save(flags);
             address = kmap_atomic(sg_page(sl), KM_BIO_SRC_IRQ) + sl->offset;
-            if (to_buffer)
-                memcpy(buffer, address, cpnow);
-            else
-                memcpy(address, buffer, cpnow);
+            memcpy(address, buffer, cpnow);
             flush_dcache_page(sg_page(sl));
             kunmap_atomic(address, KM_BIO_SRC_IRQ);
             local_irq_restore(flags);
@@ -2434,7 +2427,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
         strcpy(inq.vendor,ha->oem_name);
         sprintf(inq.product,"Host Drive  #%02d",t);
         strcpy(inq.revision,"   ");
-        gdth_copy_internal_data(ha, scp, (char*)&inq, sizeof(gdth_inq_data), 0);
+        gdth_copy_internal_data(ha, scp, (char*)&inq, sizeof(gdth_inq_data));
         break;
 
       case REQUEST_SENSE:
@@ -2444,7 +2437,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
         sd.key       = NO_SENSE;
         sd.info      = 0;
         sd.add_length= 0;
-        gdth_copy_internal_data(ha, scp, (char*)&sd, sizeof(gdth_sense_data), 0);
+        gdth_copy_internal_data(ha, scp, (char*)&sd, sizeof(gdth_sense_data));
         break;
 
       case MODE_SENSE:
@@ -2456,7 +2449,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
         mpd.bd.block_length[0] = (SECTOR_SIZE & 0x00ff0000) >> 16;
         mpd.bd.block_length[1] = (SECTOR_SIZE & 0x0000ff00) >> 8;
         mpd.bd.block_length[2] = (SECTOR_SIZE & 0x000000ff);
-        gdth_copy_internal_data(ha, scp, (char*)&mpd, sizeof(gdth_modep_data), 0);
+        gdth_copy_internal_data(ha, scp, (char*)&mpd, sizeof(gdth_modep_data));
         break;
 
       case READ_CAPACITY:
@@ -2466,7 +2459,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
         else
             rdc.last_block_no = cpu_to_be32(ha->hdr[t].size-1);
         rdc.block_length  = cpu_to_be32(SECTOR_SIZE);
-        gdth_copy_internal_data(ha, scp, (char*)&rdc, sizeof(gdth_rdcap_data), 0);
+        gdth_copy_internal_data(ha, scp, (char*)&rdc, sizeof(gdth_rdcap_data));
         break;
 
       case SERVICE_ACTION_IN:
@@ -2478,7 +2471,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
             rdc16.last_block_no = cpu_to_be64(ha->hdr[t].size-1);
             rdc16.block_length  = cpu_to_be32(SECTOR_SIZE);
             gdth_copy_internal_data(ha, scp, (char*)&rdc16,
-                                                 sizeof(gdth_rdcap16_data), 0);
+                                                 sizeof(gdth_rdcap16_data));
         } else { 
             scp->result = DID_ABORT << 16;
         }
@@ -2848,6 +2841,7 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
 static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
 {
     register gdth_cmd_str *cmdp;
+    struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
     int cmd_index;
 
     cmdp= ha->pccb;
@@ -2856,7 +2850,7 @@ static int gdth_special_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
     if (ha->type==GDT_EISA && ha->cmd_cnt>0) 
         return 0;
 
-    gdth_copy_internal_data(ha, scp, (char *)cmdp, sizeof(gdth_cmd_str), 1);
+    *cmdp = *cmndinfo->internal_cmd_str;
     cmdp->RequestBuffer = scp;
 
     /* search free command index */
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 1434c6b..26e4e92 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -915,6 +915,7 @@ typedef struct {
     struct gdth_cmndinfo {                      /* per-command private info */
         int index;
         int internal_command;                   /* don't call scsi_done */
+        gdth_cmd_str *internal_cmd_str;         /* crier for internal messages*/
         dma_addr_t sense_paddr;                 /* sense dma-addr */
         unchar priority;
         int timeout;
-- 
1.5.3.3


