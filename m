From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] gdth: reduce large on-stack locals
Date: Mon, 20 Dec 2004 13:22:40 -0800
Message-ID: <20041220132240.27a94b2e.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:23514 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261659AbULTVpN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Dec 2004 16:45:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, achim_leubner@adaptec.com


gdth is the fourth-highest stack user (for a single function)
in 2.6.10-rc3-bk-recent (sizes on x86-32).

Reduce stack usage in gdth driver:
reduce ioc_rescan() from 1564 to 52 bytes;
reduce ioc_hdrlist() from 1528 to 24 bytes;
reduce gdth_get_info() from 1076 to 300 bytes;

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>

diffstat:=
 drivers/scsi/gdth.c      |  194 ++++++++++++++++++++++++++---------------------
 drivers/scsi/gdth_proc.c |  145 ++++++++++++++++++-----------------
 2 files changed, 189 insertions(+), 150 deletions(-)

diff -Naurp ./drivers/scsi/gdth.c~gdth_stack ./drivers/scsi/gdth.c
--- ./drivers/scsi/gdth.c~gdth_stack	2004-10-18 14:54:37.000000000 -0700
+++ ./drivers/scsi/gdth.c	2004-12-20 10:15:32.845914072 -0800
@@ -5573,11 +5573,11 @@ static int ioc_general(void __user *arg,
  
 static int ioc_hdrlist(void __user *arg, char *cmnd)
 {
-    gdth_ioctl_rescan rsc;
-    gdth_cmd_str cmd;
+    gdth_ioctl_rescan *rsc;
+    gdth_cmd_str *cmd;
     gdth_ha_str *ha;
     unchar i;
-    int hanum;
+    int hanum, rc = -ENOMEM;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request *srp;
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
@@ -5586,23 +5586,30 @@ static int ioc_hdrlist(void __user *arg,
     Scsi_Cmnd scp;
 #endif
         
-    if (copy_from_user(&rsc, arg, sizeof(gdth_ioctl_rescan)) ||
-        rsc.ionode >= gdth_ctr_count)
-        return -EFAULT;
-    hanum = rsc.ionode;
+    rsc = kmalloc(sizeof(*rsc), GFP_KERNEL);
+    cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
+    if (!rsc || !cmd)
+	goto free_fail;
+
+    if (copy_from_user(rsc, arg, sizeof(gdth_ioctl_rescan)) ||
+        rsc->ionode >= gdth_ctr_count) {
+        rc = -EFAULT;
+	goto free_fail;
+    }
+    hanum = rsc->ionode;
     ha = HADATA(gdth_ctr_tab[hanum]);
-    memset(&cmd, 0, sizeof(gdth_cmd_str));
+    memset(cmd, 0, sizeof(gdth_cmd_str));
    
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     srp  = scsi_allocate_request(ha->sdev, GFP_KERNEL);
     if (!srp)
-        return -ENOMEM;
+        goto free_fail;
     srp->sr_cmd_len = 12;
     srp->sr_use_sg = 0;
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
     scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
     if (!scp)
-        return -ENOMEM;
+        goto free_fail;
     scp->cmd_len = 12;
     scp->use_sg = 0;
 #else
@@ -5615,32 +5622,32 @@ static int ioc_hdrlist(void __user *arg,
 
     for (i = 0; i < MAX_HDRIVES; ++i) { 
         if (!ha->hdr[i].present) {
-            rsc.hdr_list[i].bus = 0xff; 
+            rsc->hdr_list[i].bus = 0xff; 
             continue;
         } 
-        rsc.hdr_list[i].bus = ha->virt_bus;
-        rsc.hdr_list[i].target = i;
-        rsc.hdr_list[i].lun = 0;
-        rsc.hdr_list[i].cluster_type = ha->hdr[i].cluster_type;
+        rsc->hdr_list[i].bus = ha->virt_bus;
+        rsc->hdr_list[i].target = i;
+        rsc->hdr_list[i].lun = 0;
+        rsc->hdr_list[i].cluster_type = ha->hdr[i].cluster_type;
         if (ha->hdr[i].cluster_type & CLUSTER_DRIVE) { 
-            cmd.Service = CACHESERVICE;
-            cmd.OpCode = GDT_CLUST_INFO;
+            cmd->Service = CACHESERVICE;
+            cmd->OpCode = GDT_CLUST_INFO;
             if (ha->cache_feat & GDT_64BIT)
-                cmd.u.cache64.DeviceNo = i;
+                cmd->u.cache64.DeviceNo = i;
             else
-                cmd.u.cache.DeviceNo = i;
+                cmd->u.cache.DeviceNo = i;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            gdth_do_req(srp, &cmd, cmnd, 30);
+            gdth_do_req(srp, cmd, cmnd, 30);
             if (srp->sr_command->SCp.Status == S_OK)
-                rsc.hdr_list[i].cluster_type = srp->sr_command->SCp.Message;
+                rsc->hdr_list[i].cluster_type = srp->sr_command->SCp.Message;
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-            gdth_do_cmd(scp, &cmd, cmnd, 30);
+            gdth_do_cmd(scp, cmd, cmnd, 30);
             if (scp->SCp.Status == S_OK)
-                rsc.hdr_list[i].cluster_type = scp->SCp.Message;
+                rsc->hdr_list[i].cluster_type = scp->SCp.Message;
 #else
-            gdth_do_cmd(&scp, &cmd, cmnd, 30);
+            gdth_do_cmd(&scp, cmd, cmnd, 30);
             if (scp.SCp.Status == S_OK)
-                rsc.hdr_list[i].cluster_type = scp.SCp.Message;
+                rsc->hdr_list[i].cluster_type = scp.SCp.Message;
 #endif
         }
     } 
@@ -5650,18 +5657,25 @@ static int ioc_hdrlist(void __user *arg,
     scsi_release_command(scp);
 #endif       
  
-    if (copy_to_user(arg, &rsc, sizeof(gdth_ioctl_rescan)))
-        return -EFAULT;
-    return 0;
+    if (copy_to_user(arg, rsc, sizeof(gdth_ioctl_rescan)))
+        rc = -EFAULT;
+    else
+	rc = 0;
+
+free_fail:
+    kfree(rsc);
+    kfree(cmd);
+    return rc;
 }
 
 static int ioc_rescan(void __user *arg, char *cmnd)
 {
-    gdth_ioctl_rescan rsc;
-    gdth_cmd_str cmd;
+    gdth_ioctl_rescan *rsc;
+    gdth_cmd_str *cmd;
     ushort i, status, hdr_cnt;
     ulong32 info;
     int hanum, cyls, hds, secs;
+    int rc = -ENOMEM;
     ulong flags;
     gdth_ha_str *ha; 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
@@ -5671,24 +5685,31 @@ static int ioc_rescan(void __user *arg, 
 #else
     Scsi_Cmnd scp;
 #endif
-        
-    if (copy_from_user(&rsc, arg, sizeof(gdth_ioctl_rescan)) ||
-        rsc.ionode >= gdth_ctr_count)
-        return -EFAULT;
-    hanum = rsc.ionode;
+
+    rsc = kmalloc(sizeof(*rsc), GFP_KERNEL);
+    cmd = kmalloc(sizeof(*cmd), GFP_KERNEL);
+    if (!cmd || !rsc)
+	goto free_fail;
+
+    if (copy_from_user(rsc, arg, sizeof(gdth_ioctl_rescan)) ||
+        rsc->ionode >= gdth_ctr_count) {
+	rc = -EFAULT;
+	goto free_fail;
+    }
+    hanum = rsc->ionode;
     ha = HADATA(gdth_ctr_tab[hanum]);
-    memset(&cmd, 0, sizeof(gdth_cmd_str));
+    memset(cmd, 0, sizeof(gdth_cmd_str));
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     srp  = scsi_allocate_request(ha->sdev, GFP_KERNEL);
     if (!srp)
-        return -ENOMEM;
+        goto free_fail;
     srp->sr_cmd_len = 12;
     srp->sr_use_sg = 0;
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
     scp  = scsi_allocate_device(ha->sdev, 1, FALSE);
     if (!scp)
-        return -ENOMEM;
+        goto free_fail;
     scp->cmd_len = 12;
     scp->use_sg = 0;
 #else
@@ -5699,59 +5720,60 @@ static int ioc_rescan(void __user *arg, 
     scp.device = &ha->sdev;
 #endif
      
-    if (rsc.flag == 0) {
+    if (rsc->flag == 0) {
         /* old method: re-init. cache service */
-        cmd.Service = CACHESERVICE;
+        cmd->Service = CACHESERVICE;
         if (ha->cache_feat & GDT_64BIT) {
-            cmd.OpCode = GDT_X_INIT_HOST;
-            cmd.u.cache64.DeviceNo = LINUX_OS;
+            cmd->OpCode = GDT_X_INIT_HOST;
+            cmd->u.cache64.DeviceNo = LINUX_OS;
         } else {
-            cmd.OpCode = GDT_INIT;
-            cmd.u.cache.DeviceNo = LINUX_OS;
+            cmd->OpCode = GDT_INIT;
+            cmd->u.cache.DeviceNo = LINUX_OS;
         }
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(srp, &cmd, cmnd, 30);
+        gdth_do_req(srp, cmd, cmnd, 30);
         status = (ushort)srp->sr_command->SCp.Status;
         info = (ulong32)srp->sr_command->SCp.Message;
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-        gdth_do_cmd(scp, &cmd, cmnd, 30);
+        gdth_do_cmd(scp, cmd, cmnd, 30);
         status = (ushort)scp->SCp.Status;
         info = (ulong32)scp->SCp.Message;
 #else
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
+        gdth_do_cmd(&scp, cmd, cmnd, 30);
         status = (ushort)scp.SCp.Status;
         info = (ulong32)scp.SCp.Message;
 #endif
         i = 0;
         hdr_cnt = (status == S_OK ? (ushort)info : 0);
     } else {
-        i = rsc.hdr_no;
+        i = rsc->hdr_no;
         hdr_cnt = i + 1;
     }
+
     for (; i < hdr_cnt && i < MAX_HDRIVES; ++i) {
-        cmd.Service = CACHESERVICE;
-        cmd.OpCode = GDT_INFO;
+        cmd->Service = CACHESERVICE;
+        cmd->OpCode = GDT_INFO;
         if (ha->cache_feat & GDT_64BIT) 
-            cmd.u.cache64.DeviceNo = i;
+            cmd->u.cache64.DeviceNo = i;
         else 
-            cmd.u.cache.DeviceNo = i;
+            cmd->u.cache.DeviceNo = i;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(srp, &cmd, cmnd, 30);
+        gdth_do_req(srp, cmd, cmnd, 30);
         status = (ushort)srp->sr_command->SCp.Status;
         info = (ulong32)srp->sr_command->SCp.Message;
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-        gdth_do_cmd(scp, &cmd, cmnd, 30);
+        gdth_do_cmd(scp, cmd, cmnd, 30);
         status = (ushort)scp->SCp.Status;
         info = (ulong32)scp->SCp.Message;
 #else
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
+        gdth_do_cmd(&scp, cmd, cmnd, 30);
         status = (ushort)scp.SCp.Status;
         info = (ulong32)scp.SCp.Message;
 #endif
         GDTH_LOCK_HA(ha, flags);
-        rsc.hdr_list[i].bus = ha->virt_bus;
-        rsc.hdr_list[i].target = i;
-        rsc.hdr_list[i].lun = 0;
+        rsc->hdr_list[i].bus = ha->virt_bus;
+        rsc->hdr_list[i].target = i;
+        rsc->hdr_list[i].lun = 0;
         if (status != S_OK) {
             ha->hdr[i].present = FALSE;
         } else {
@@ -5773,22 +5795,22 @@ static int ioc_rescan(void __user *arg, 
         /* but we need ha->info2, not yet stored in scp->SCp */
 
         /* devtype, cluster info, R/W attribs */
-        cmd.Service = CACHESERVICE;
-        cmd.OpCode = GDT_DEVTYPE;
+        cmd->Service = CACHESERVICE;
+        cmd->OpCode = GDT_DEVTYPE;
         if (ha->cache_feat & GDT_64BIT) 
-            cmd.u.cache64.DeviceNo = i;
+            cmd->u.cache64.DeviceNo = i;
         else
-            cmd.u.cache.DeviceNo = i;
+            cmd->u.cache.DeviceNo = i;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(srp, &cmd, cmnd, 30);
+        gdth_do_req(srp, cmd, cmnd, 30);
         status = (ushort)srp->sr_command->SCp.Status;
         info = (ulong32)srp->sr_command->SCp.Message;
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-        gdth_do_cmd(scp, &cmd, cmnd, 30);
+        gdth_do_cmd(scp, cmd, cmnd, 30);
         status = (ushort)scp->SCp.Status;
         info = (ulong32)scp->SCp.Message;
 #else
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
+        gdth_do_cmd(&scp, cmd, cmnd, 30);
         status = (ushort)scp.SCp.Status;
         info = (ulong32)scp.SCp.Message;
 #endif
@@ -5796,22 +5818,22 @@ static int ioc_rescan(void __user *arg, 
         ha->hdr[i].devtype = (status == S_OK ? (ushort)info : 0);
         GDTH_UNLOCK_HA(ha, flags);
 
-        cmd.Service = CACHESERVICE;
-        cmd.OpCode = GDT_CLUST_INFO;
+        cmd->Service = CACHESERVICE;
+        cmd->OpCode = GDT_CLUST_INFO;
         if (ha->cache_feat & GDT_64BIT) 
-            cmd.u.cache64.DeviceNo = i;
+            cmd->u.cache64.DeviceNo = i;
         else
-            cmd.u.cache.DeviceNo = i;
+            cmd->u.cache.DeviceNo = i;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(srp, &cmd, cmnd, 30);
+        gdth_do_req(srp, cmd, cmnd, 30);
         status = (ushort)srp->sr_command->SCp.Status;
         info = (ulong32)srp->sr_command->SCp.Message;
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-        gdth_do_cmd(scp, &cmd, cmnd, 30);
+        gdth_do_cmd(scp, cmd, cmnd, 30);
         status = (ushort)scp->SCp.Status;
         info = (ulong32)scp->SCp.Message;
 #else
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
+        gdth_do_cmd(&scp, cmd, cmnd, 30);
         status = (ushort)scp.SCp.Status;
         info = (ulong32)scp.SCp.Message;
 #endif
@@ -5819,24 +5841,24 @@ static int ioc_rescan(void __user *arg, 
         ha->hdr[i].cluster_type = 
             ((status == S_OK && !shared_access) ? (ushort)info : 0);
         GDTH_UNLOCK_HA(ha, flags);
-        rsc.hdr_list[i].cluster_type = ha->hdr[i].cluster_type;
+        rsc->hdr_list[i].cluster_type = ha->hdr[i].cluster_type;
 
-        cmd.Service = CACHESERVICE;
-        cmd.OpCode = GDT_RW_ATTRIBS;
+        cmd->Service = CACHESERVICE;
+        cmd->OpCode = GDT_RW_ATTRIBS;
         if (ha->cache_feat & GDT_64BIT) 
-            cmd.u.cache64.DeviceNo = i;
+            cmd->u.cache64.DeviceNo = i;
         else
-            cmd.u.cache.DeviceNo = i;
+            cmd->u.cache.DeviceNo = i;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-        gdth_do_req(srp, &cmd, cmnd, 30);
+        gdth_do_req(srp, cmd, cmnd, 30);
         status = (ushort)srp->sr_command->SCp.Status;
         info = (ulong32)srp->sr_command->SCp.Message;
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-        gdth_do_cmd(scp, &cmd, cmnd, 30);
+        gdth_do_cmd(scp, cmd, cmnd, 30);
         status = (ushort)scp->SCp.Status;
         info = (ulong32)scp->SCp.Message;
 #else
-        gdth_do_cmd(&scp, &cmd, cmnd, 30);
+        gdth_do_cmd(&scp, cmd, cmnd, 30);
         status = (ushort)scp.SCp.Status;
         info = (ulong32)scp.SCp.Message;
 #endif
@@ -5850,9 +5872,15 @@ static int ioc_rescan(void __user *arg, 
     scsi_release_command(scp);
 #endif       
  
-    if (copy_to_user(arg, &rsc, sizeof(gdth_ioctl_rescan)))
-        return -EFAULT;
-    return 0;
+    if (copy_to_user(arg, rsc, sizeof(gdth_ioctl_rescan)))
+        rc = -EFAULT;
+    else
+	rc = 0;
+
+free_fail:
+    kfree(rsc);
+    kfree(cmd);
+    return rc;
 }
   
 static int gdth_ioctl(struct inode *inode, struct file *filep,
diff -Naurp ./drivers/scsi/gdth_proc.c~gdth_stack ./drivers/scsi/gdth_proc.c
--- ./drivers/scsi/gdth_proc.c~gdth_stack	2004-10-18 14:54:08.000000000 -0700
+++ ./drivers/scsi/gdth_proc.c	2004-12-20 12:51:07.614813496 -0800
@@ -243,9 +243,10 @@ static int gdth_get_info(char *buffer,ch
     int no_mdrv = 0, drv_no, is_mirr;
     ulong32 cnt;
     ulong64 paddr;
+    int rc = -ENOMEM;
 
-    gdth_cmd_str gdtcmd;
-    gdth_evt_str estr;
+    gdth_cmd_str *gdtcmd;
+    gdth_evt_str *estr;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request *scp;
     Scsi_Device *sdev; 
@@ -266,10 +267,15 @@ static int gdth_get_info(char *buffer,ch
     gdth_defcnt_str *pdef;
     gdth_cdrinfo_str *pcdi;
     gdth_hget_str *phg;
-
     char cmnd[MAX_COMMAND_SIZE];
+
+    gdtcmd = kmalloc(sizeof(*gdtcmd), GFP_KERNEL);
+    estr = kmalloc(sizeof(*estr), GFP_KERNEL);
+    if (!gdtcmd || !estr)
+	goto free_fail;
+
     memset(cmnd, 0xff, 12);
-    memset(&gdtcmd, 0, sizeof(gdth_cmd_str));
+    memset(gdtcmd, 0, sizeof(gdth_cmd_str));
 
     TRACE2(("gdth_get_info() ha %d bus %d\n",hanum,busnum));
     ha = HADATA(gdth_ctr_tab[hanum]);
@@ -278,14 +284,14 @@ static int gdth_get_info(char *buffer,ch
     sdev = scsi_get_host_dev(host);
     scp  = scsi_allocate_request(sdev, GFP_KERNEL);
     if (!scp)
-        return -ENOMEM;
+        goto free_fail;
     scp->sr_cmd_len = 12;
     scp->sr_use_sg = 0;
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
     sdev = scsi_get_host_dev(host);
     scp  = scsi_allocate_device(sdev, 1, FALSE);
     if (!scp)
-        return -ENOMEM;
+        goto free_fail;
     scp->cmd_len = 12;
     scp->use_sg = 0;
 #else
@@ -387,12 +393,12 @@ static int gdth_get_info(char *buffer,ch
             /* 2.a statistics (and retries/reassigns) */
             TRACE2(("pdr_statistics() chn %d\n",i));                
             pds = (gdth_dskstat_str *)(buf + GDTH_SCRATCH/4);
-            gdtcmd.Service = CACHESERVICE;
-            gdtcmd.OpCode = GDT_IOCTL;
-            gdtcmd.u.ioctl.p_param = paddr + GDTH_SCRATCH/4;
-            gdtcmd.u.ioctl.param_size = 3*GDTH_SCRATCH/4;
-            gdtcmd.u.ioctl.subfunc = DSK_STATISTICS | L_CTRL_PATTERN;
-            gdtcmd.u.ioctl.channel = ha->raw[i].address | INVALID_CHANNEL;
+            gdtcmd->Service = CACHESERVICE;
+            gdtcmd->OpCode = GDT_IOCTL;
+            gdtcmd->u.ioctl.p_param = paddr + GDTH_SCRATCH/4;
+            gdtcmd->u.ioctl.param_size = 3*GDTH_SCRATCH/4;
+            gdtcmd->u.ioctl.subfunc = DSK_STATISTICS | L_CTRL_PATTERN;
+            gdtcmd->u.ioctl.channel = ha->raw[i].address | INVALID_CHANNEL;
             pds->bid = ha->raw[i].local_no;
             pds->first = 0;
             pds->entries = ha->raw[i].pdev_cnt;
@@ -401,13 +407,13 @@ static int gdth_get_info(char *buffer,ch
             if (pds->entries > cnt)
                 pds->entries = cnt;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            gdth_do_req(scp, &gdtcmd, cmnd, 30);
+            gdth_do_req(scp, gdtcmd, cmnd, 30);
             if (scp->sr_command->SCp.Status != S_OK) 
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-            gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
+            gdth_do_cmd(scp, gdtcmd, cmnd, 30);
             if (scp->SCp.Status != S_OK) 
 #else
-            gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
+            gdth_do_cmd(&scp, gdtcmd, cmnd, 30);
             if (scp.SCp.Status != S_OK) 
 #endif
             { 
@@ -420,21 +426,21 @@ static int gdth_get_info(char *buffer,ch
                 TRACE2(("scsi_drv_info() chn %d dev %d\n",
                     i, ha->raw[i].id_list[j]));             
                 pdi = (gdth_diskinfo_str *)buf;
-                gdtcmd.Service = CACHESERVICE;
-                gdtcmd.OpCode = GDT_IOCTL;
-                gdtcmd.u.ioctl.p_param = paddr;
-                gdtcmd.u.ioctl.param_size = sizeof(gdth_diskinfo_str);
-                gdtcmd.u.ioctl.subfunc = SCSI_DR_INFO | L_CTRL_PATTERN;
-                gdtcmd.u.ioctl.channel = 
+                gdtcmd->Service = CACHESERVICE;
+                gdtcmd->OpCode = GDT_IOCTL;
+                gdtcmd->u.ioctl.p_param = paddr;
+                gdtcmd->u.ioctl.param_size = sizeof(gdth_diskinfo_str);
+                gdtcmd->u.ioctl.subfunc = SCSI_DR_INFO | L_CTRL_PATTERN;
+                gdtcmd->u.ioctl.channel = 
                     ha->raw[i].address | ha->raw[i].id_list[j];
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-                gdth_do_req(scp, &gdtcmd, cmnd, 30);
+                gdth_do_req(scp, gdtcmd, cmnd, 30);
                 if (scp->sr_command->SCp.Status == S_OK) 
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-                gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
+                gdth_do_cmd(scp, gdtcmd, cmnd, 30);
                 if (scp->SCp.Status == S_OK) 
 #else
-                gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
+                gdth_do_cmd(&scp, gdtcmd, cmnd, 30);
                 if (scp.SCp.Status == S_OK) 
 #endif
                 {
@@ -478,22 +484,22 @@ static int gdth_get_info(char *buffer,ch
                     TRACE2(("scsi_drv_defcnt() chn %d dev %d\n",
                             i, ha->raw[i].id_list[j]));             
                     pdef = (gdth_defcnt_str *)buf;
-                    gdtcmd.Service = CACHESERVICE;
-                    gdtcmd.OpCode = GDT_IOCTL;
-                    gdtcmd.u.ioctl.p_param = paddr;
-                    gdtcmd.u.ioctl.param_size = sizeof(gdth_defcnt_str);
-                    gdtcmd.u.ioctl.subfunc = SCSI_DEF_CNT | L_CTRL_PATTERN;
-                    gdtcmd.u.ioctl.channel = 
+                    gdtcmd->Service = CACHESERVICE;
+                    gdtcmd->OpCode = GDT_IOCTL;
+                    gdtcmd->u.ioctl.p_param = paddr;
+                    gdtcmd->u.ioctl.param_size = sizeof(gdth_defcnt_str);
+                    gdtcmd->u.ioctl.subfunc = SCSI_DEF_CNT | L_CTRL_PATTERN;
+                    gdtcmd->u.ioctl.channel = 
                         ha->raw[i].address | ha->raw[i].id_list[j];
                     pdef->sddc_type = 0x08;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-                    gdth_do_req(scp, &gdtcmd, cmnd, 30);
+                    gdth_do_req(scp, gdtcmd, cmnd, 30);
                     if (scp->sr_command->SCp.Status == S_OK) 
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-                    gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
+                    gdth_do_cmd(scp, gdtcmd, cmnd, 30);
                     if (scp->SCp.Status == S_OK) 
 #else
-                    gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
+                    gdth_do_cmd(&scp, gdtcmd, cmnd, 30);
                     if (scp.SCp.Status == S_OK) 
 #endif
                     {
@@ -536,20 +542,20 @@ static int gdth_get_info(char *buffer,ch
                 /* 3.a log. drive info */
                 TRACE2(("cache_drv_info() drive no %d\n",drv_no));
                 pcdi = (gdth_cdrinfo_str *)buf;
-                gdtcmd.Service = CACHESERVICE;
-                gdtcmd.OpCode = GDT_IOCTL;
-                gdtcmd.u.ioctl.p_param = paddr;
-                gdtcmd.u.ioctl.param_size = sizeof(gdth_cdrinfo_str);
-                gdtcmd.u.ioctl.subfunc = CACHE_DRV_INFO;
-                gdtcmd.u.ioctl.channel = drv_no;
+                gdtcmd->Service = CACHESERVICE;
+                gdtcmd->OpCode = GDT_IOCTL;
+                gdtcmd->u.ioctl.p_param = paddr;
+                gdtcmd->u.ioctl.param_size = sizeof(gdth_cdrinfo_str);
+                gdtcmd->u.ioctl.subfunc = CACHE_DRV_INFO;
+                gdtcmd->u.ioctl.channel = drv_no;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-                gdth_do_req(scp, &gdtcmd, cmnd, 30);
+                gdth_do_req(scp, gdtcmd, cmnd, 30);
                 if (scp->sr_command->SCp.Status != S_OK) 
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-                gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
+                gdth_do_cmd(scp, gdtcmd, cmnd, 30);
                 if (scp->SCp.Status != S_OK)
 #else
-                gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
+                gdth_do_cmd(&scp, gdtcmd, cmnd, 30);
                 if (scp.SCp.Status != S_OK)
 #endif
                 {
@@ -649,20 +655,20 @@ static int gdth_get_info(char *buffer,ch
             /* 4.a array drive info */
             TRACE2(("array_info() drive no %d\n",i));
             pai = (gdth_arrayinf_str *)buf;
-            gdtcmd.Service = CACHESERVICE;
-            gdtcmd.OpCode = GDT_IOCTL;
-            gdtcmd.u.ioctl.p_param = paddr;
-            gdtcmd.u.ioctl.param_size = sizeof(gdth_arrayinf_str);
-            gdtcmd.u.ioctl.subfunc = ARRAY_INFO | LA_CTRL_PATTERN;
-            gdtcmd.u.ioctl.channel = i;
+            gdtcmd->Service = CACHESERVICE;
+            gdtcmd->OpCode = GDT_IOCTL;
+            gdtcmd->u.ioctl.p_param = paddr;
+            gdtcmd->u.ioctl.param_size = sizeof(gdth_arrayinf_str);
+            gdtcmd->u.ioctl.subfunc = ARRAY_INFO | LA_CTRL_PATTERN;
+            gdtcmd->u.ioctl.channel = i;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            gdth_do_req(scp, &gdtcmd, cmnd, 30);
+            gdth_do_req(scp, gdtcmd, cmnd, 30);
             if (scp->sr_command->SCp.Status == S_OK) 
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-            gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
+            gdth_do_cmd(scp, gdtcmd, cmnd, 30);
             if (scp->SCp.Status == S_OK) 
 #else
-            gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
+            gdth_do_cmd(&scp, gdtcmd, cmnd, 30);
             if (scp.SCp.Status == S_OK) 
 #endif
             {
@@ -731,22 +737,22 @@ static int gdth_get_info(char *buffer,ch
             /* 5.a get host drive list */
             TRACE2(("host_get() drv_no %d\n",i));           
             phg = (gdth_hget_str *)buf;
-            gdtcmd.Service = CACHESERVICE;
-            gdtcmd.OpCode = GDT_IOCTL;
-            gdtcmd.u.ioctl.p_param = paddr;
-            gdtcmd.u.ioctl.param_size = sizeof(gdth_hget_str);
-            gdtcmd.u.ioctl.subfunc = HOST_GET | LA_CTRL_PATTERN;
-            gdtcmd.u.ioctl.channel = i;
+            gdtcmd->Service = CACHESERVICE;
+            gdtcmd->OpCode = GDT_IOCTL;
+            gdtcmd->u.ioctl.p_param = paddr;
+            gdtcmd->u.ioctl.param_size = sizeof(gdth_hget_str);
+            gdtcmd->u.ioctl.subfunc = HOST_GET | LA_CTRL_PATTERN;
+            gdtcmd->u.ioctl.channel = i;
             phg->entries = MAX_HDRIVES;
             phg->offset = GDTOFFSOF(gdth_hget_str, entry[0]); 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-            gdth_do_req(scp, &gdtcmd, cmnd, 30);
+            gdth_do_req(scp, gdtcmd, cmnd, 30);
             if (scp->sr_command->SCp.Status != S_OK) 
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-            gdth_do_cmd(scp, &gdtcmd, cmnd, 30);
+            gdth_do_cmd(scp, gdtcmd, cmnd, 30);
             if (scp->SCp.Status != S_OK) 
 #else
-            gdth_do_cmd(&scp, &gdtcmd, cmnd, 30);
+            gdth_do_cmd(&scp, gdtcmd, cmnd, 30);
             if (scp.SCp.Status != S_OK) 
 #endif
             {
@@ -799,14 +805,14 @@ static int gdth_get_info(char *buffer,ch
     len += size;  pos = begin + len;
 
     for (id = -1;;) {
-        id = gdth_read_event(ha, id, &estr);
-        if (estr.event_source == 0)
+        id = gdth_read_event(ha, id, estr);
+        if (estr->event_source == 0)
             break;
-        if (estr.event_data.eu.driver.ionode == hanum &&
-            estr.event_source == ES_ASYNC) { 
-            gdth_log_event(&estr.event_data, hrec);
+        if (estr->event_data.eu.driver.ionode == hanum &&
+            estr->event_source == ES_ASYNC) { 
+            gdth_log_event(&estr->event_data, hrec);
             do_gettimeofday(&tv);
-            sec = (int)(tv.tv_sec - estr.first_stamp);
+            sec = (int)(tv.tv_sec - estr->first_stamp);
             if (sec < 0) sec = 0;
             size = sprintf(buffer+len," date- %02d:%02d:%02d\t%s\n",
                            sec/3600, sec%3600/60, sec%60, hrec);
@@ -836,7 +842,12 @@ stop_output:
         len = length;
     TRACE2(("get_info() len %d pos %d begin %d offset %d length %d size %d\n",
             len,(int)pos,(int)begin,(int)offset,length,size));
-    return(len);
+    rc = len;
+
+free_fail:
+    kfree(gdtcmd);
+    kfree(estr);
+    return rc;
 }
 
 

---
