From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/3] gdth: consolidate __gdth_execute && gdth_execute
Date: Thu, 01 May 2008 17:02:43 +0300
Message-ID: <4819CD83.6050708__21521.0636648864$1209650637$gmane$org@panasas.com>
References: <4819C9DB.60104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:9812 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbYEAODA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 10:03:00 -0400
In-Reply-To: <4819C9DB.60104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>


ioctl into gdth's char device would allocate an host-device at file-open
and would cache that device until the removal of the host, not at file
close. On the other hand a /proc access to gdth, and also flush() call at
host removal, would allocate a new device on every call and destroy it. Even
if one was allocated by file-open.

All this optimization is just a mess. But my primary concern is the construction
of the device just before destruction at flush(), looks extra pointless to me.

So allocate an host-device for every host, and remove it at host removal.
Now the existence of __gdth_execute is pointless and is removed. Also
gdth_execute can operate directly on gdth_ha_str.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c      |   45 +++++++++++++++------------------------------
 drivers/scsi/gdth_proc.c |   16 ++++++++--------
 drivers/scsi/gdth_proc.h |    2 +-
 3 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index c6d6e7c..35ad3bf 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -439,10 +439,9 @@ static void gdth_scsi_done(struct scsi_cmnd *scp)
 		scp->scsi_done(scp);
 }
 
-int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
+int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
                    int timeout, u32 *info)
 {
-    gdth_ha_str *ha = shost_priv(sdev->host);
     Scsi_Cmnd *scp;
     struct gdth_cmndinfo cmndinfo;
     DECLARE_COMPLETION_ONSTACK(wait);
@@ -458,7 +457,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
 	return -ENOMEM;
     }
 
-    scp->device = sdev;
+    scp->device = ha->sdev;
     memset(&cmndinfo, 0, sizeof(cmndinfo));
 
     /* use request field to save the ptr. to completion struct. */
@@ -470,7 +469,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     cmndinfo.internal_cmd_str = gdtcmd;
     cmndinfo.internal_command = 1;
 
-    TRACE(("__gdth_execute() cmd 0x%x\n", scp->cmnd[0]));
+    TRACE(("gdth_execute() cmd 0x%x\n", scp->cmnd[0]));
     __gdth_queuecommand(ha, scp, &cmndinfo);
 
     wait_for_completion(&wait);
@@ -483,16 +482,6 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     return rval;
 }
 
-int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
-                 int timeout, u32 *info)
-{
-    struct scsi_device *sdev = scsi_get_host_dev(shost);
-    int rval = __gdth_execute(sdev, gdtcmd, cmnd, timeout, info);
-
-    scsi_free_host_dev(sdev);
-    return rval;
-}
-
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs)
 {
     *cyls = size /HEADS/SECS;
@@ -3997,13 +3986,6 @@ static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
 
 static int gdth_open(struct inode *inode, struct file *filep)
 {
-    gdth_ha_str *ha;
-
-    list_for_each_entry(ha, &gdth_instances, list) {
-        if (!ha->sdev)
-            ha->sdev = scsi_get_host_dev(ha->shost);
-    }
-
     TRACE(("gdth_open()\n"));
     return 0;
 }
@@ -4109,7 +4091,7 @@ static int ioc_resetdrv(void __user *arg, char *cmnd)
     else
         cmd.u.cache.DeviceNo = res.number;
 
-    rval = __gdth_execute(ha->sdev, &cmd, cmnd, 30, NULL);
+    rval = gdth_execute(ha, &cmd, cmnd, 30, NULL);
     if (rval < 0)
         return rval;
     res.status = rval;
@@ -4217,7 +4199,7 @@ static int ioc_general(void __user *arg, char *cmnd)
         }
     }
 
-    rval = __gdth_execute(ha->sdev, &gen.command, cmnd, gen.timeout, &gen.info);
+    rval = gdth_execute(ha, &gen.command, cmnd, gen.timeout, &gen.info);
     if (rval < 0)
         return rval;
     gen.status = rval;
@@ -4273,7 +4255,7 @@ static int ioc_hdrlist(void __user *arg, char *cmnd)
                 cmd->u.cache64.DeviceNo = i;
             else
                 cmd->u.cache.DeviceNo = i;
-            if (__gdth_execute(ha->sdev, cmd, cmnd, 30, &cluster_type) == S_OK)
+            if (gdth_execute(ha, cmd, cmnd, 30, &cluster_type) == S_OK)
                 rsc->hdr_list[i].cluster_type = cluster_type;
         }
     } 
@@ -4323,7 +4305,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
             cmd->u.cache.DeviceNo = LINUX_OS;
         }
 
-        status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+        status = gdth_execute(ha, cmd, cmnd, 30, &info);
         i = 0;
         hdr_cnt = (status == S_OK ? (ushort)info : 0);
     } else {
@@ -4339,7 +4321,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
         else 
             cmd->u.cache.DeviceNo = i;
 
-        status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+        status = gdth_execute(ha, cmd, cmnd, 30, &info);
 
         spin_lock_irqsave(&ha->smp_lock, flags);
         rsc->hdr_list[i].bus = ha->virt_bus;
@@ -4373,7 +4355,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
         else
             cmd->u.cache.DeviceNo = i;
 
-        status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+        status = gdth_execute(ha, cmd, cmnd, 30, &info);
 
         spin_lock_irqsave(&ha->smp_lock, flags);
         ha->hdr[i].devtype = (status == S_OK ? (ushort)info : 0);
@@ -4386,7 +4368,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
         else
             cmd->u.cache.DeviceNo = i;
 
-        status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+        status = gdth_execute(ha, cmd, cmnd, 30, &info);
 
         spin_lock_irqsave(&ha->smp_lock, flags);
         ha->hdr[i].cluster_type = 
@@ -4401,7 +4383,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
         else
             cmd->u.cache.DeviceNo = i;
 
-        status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+        status = gdth_execute(ha, cmd, cmnd, 30, &info);
 
         spin_lock_irqsave(&ha->smp_lock, flags);
         ha->hdr[i].rw_attribs = (status == S_OK ? (ushort)info : 0);
@@ -4599,7 +4581,7 @@ static void gdth_flush(gdth_ha_str *ha)
             }
             TRACE2(("gdth_flush(): flush ha %d drive %d\n", ha->hanum, i));
 
-            gdth_execute(ha->shost, &gdtcmd, cmnd, 30, NULL);
+            gdth_execute(ha, &gdtcmd, cmnd, 30, NULL);
         }
     }
 }
@@ -4737,6 +4719,7 @@ static int __init gdth_isa_probe_one(ulong32 isa_bios)
 	list_add_tail(&ha->list, &gdth_instances);
 
 	scsi_scan_host(shp);
+	ha->sdev = scsi_get_host_dev(ha->shost);
 
 	return 0;
 
@@ -4867,6 +4850,7 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 	list_add_tail(&ha->list, &gdth_instances);
 
 	scsi_scan_host(shp);
+	ha->sdev = scsi_get_host_dev(ha->shost);
 
 	return 0;
 
@@ -5013,6 +4997,7 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 	pci_set_drvdata(ha->pdev, ha);
 
 	scsi_scan_host(shp);
+	ha->sdev = scsi_get_host_dev(ha->shost);
 
 	*ha_out = ha;
 
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index ce0228e..97c264a 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -84,7 +84,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
                     gdtcmd.u.cache.BlockNo = 1;
                 }
 
-                gdth_execute(host, &gdtcmd, cmnd, 30, NULL);
+                gdth_execute(ha, &gdtcmd, cmnd, 30, NULL);
             }
         }
         if (!found)
@@ -137,7 +137,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
         gdtcmd.u.ioctl.channel = INVALID_CHANNEL;
         pcpar->write_back = wb_mode==1 ? 0:1;
 
-        gdth_execute(host, &gdtcmd, cmnd, 30, NULL);
+        gdth_execute(ha, &gdtcmd, cmnd, 30, NULL);
 
         gdth_ioctl_free(ha, GDTH_SCRATCH, ha->pscratch, paddr);
         printk("Done.\n");
@@ -285,7 +285,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
             if (pds->entries > cnt)
                 pds->entries = cnt;
 
-            if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) != S_OK)
+            if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) != S_OK)
                 pds->count = 0;
 
             /* other IOCTLs must fit into area GDTH_SCRATCH/4 */
@@ -302,7 +302,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                 gdtcmd->u.ioctl.channel = 
                     ha->raw[i].address | ha->raw[i].id_list[j];
 
-                if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
+                if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) == S_OK) {
                     strncpy(hrec,pdi->vendor,8);
                     strncpy(hrec+8,pdi->product,16);
                     strncpy(hrec+24,pdi->revision,4);
@@ -352,7 +352,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                         ha->raw[i].address | ha->raw[i].id_list[j];
                     pdef->sddc_type = 0x08;
 
-                    if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
+                    if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) == S_OK) {
                         size = sprintf(buffer+len,
                                        " Grown Defects:\t%d\n",
                                        pdef->sddc_cnt);
@@ -398,7 +398,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                 gdtcmd->u.ioctl.param_size = sizeof(gdth_cdrinfo_str);
                 gdtcmd->u.ioctl.subfunc = CACHE_DRV_INFO;
                 gdtcmd->u.ioctl.channel = drv_no;
-                if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) != S_OK)
+                if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) != S_OK)
                     break;
                 pcdi->ld_dtype >>= 16;
                 j++;
@@ -500,7 +500,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
             gdtcmd->u.ioctl.param_size = sizeof(gdth_arrayinf_str);
             gdtcmd->u.ioctl.subfunc = ARRAY_INFO | LA_CTRL_PATTERN;
             gdtcmd->u.ioctl.channel = i;
-            if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
+            if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) == S_OK) {
                 if (pai->ai_state == 0)
                     strcpy(hrec, "idle");
                 else if (pai->ai_state == 2)
@@ -574,7 +574,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
             gdtcmd->u.ioctl.channel = i;
             phg->entries = MAX_HDRIVES;
             phg->offset = GDTOFFSOF(gdth_hget_str, entry[0]); 
-            if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
+            if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) == S_OK) {
                 ha->hdr[i].ldr_no = i;
                 ha->hdr[i].rw_attribs = 0;
                 ha->hdr[i].start_sec = 0;
diff --git a/drivers/scsi/gdth_proc.h b/drivers/scsi/gdth_proc.h
index 45e6fda..faf4496 100644
--- a/drivers/scsi/gdth_proc.h
+++ b/drivers/scsi/gdth_proc.h
@@ -5,7 +5,7 @@
  * $Id: gdth_proc.h,v 1.16 2004/01/14 13:09:01 achim Exp $
  */
 
-int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
+int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
                  int timeout, u32 *info);
 
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
-- 
1.5.3.3


