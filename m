From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 23/34] scsi proc_ops: convert drivers/scsi/gdth.c
Date: Wed, 22 Feb 2012 22:46:14 +0300
Message-ID: <1329939985-26793-23-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2BVTrP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:15 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:14 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/gdth.c      |    2 +-
 drivers/scsi/gdth.h      |    6 --
 drivers/scsi/gdth_proc.c |  215 ++++++++++++++++------------------------------
 drivers/scsi/gdth_proc.h |    2 -
 4 files changed, 76 insertions(+), 149 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3242bca..fa3a1e3 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4683,7 +4683,7 @@ static struct scsi_host_template gdth_template = {
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
         .slave_configure        = gdth_slave_configure,
         .bios_param             = gdth_bios_param,
-        .proc_info              = gdth_proc_info,
+        .proc_ops               = &gdth_proc_ops,
 	.eh_timed_out		= gdth_timed_out,
         .proc_name              = "gdth",
         .can_queue              = GDTH_MAXCMDS,
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index d3e4d7c..b8e1302 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -1012,10 +1012,4 @@ typedef struct {
 typedef struct {
     unsigned long       b[10];                          /* 32/64 bit compiler ! */
 } __attribute__((packed)) gdth_stackframe;
-
-
-/* function prototyping */
-
-int gdth_proc_info(struct Scsi_Host *, char *,char **,off_t,int,int);
-
 #endif
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 6527543..e6ad478 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -3,22 +3,9 @@
  */
 
 #include <linux/completion.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 
-int gdth_proc_info(struct Scsi_Host *host, char *buffer,char **start,off_t offset,int length,   
-                   int inout)
-{
-    gdth_ha_str *ha = shost_priv(host);
-
-    TRACE2(("gdth_proc_info() length %d offs %d inout %d\n",
-            length,(int)offset,inout));
-
-    if (inout)
-        return(gdth_set_info(buffer,length,host,ha));
-    else
-        return(gdth_get_info(buffer,start,offset,length,host,ha));
-}
-
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
                          gdth_ha_str *ha)
 {
@@ -149,12 +136,11 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
     return(-EINVAL);
 }
 
-static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
-                         struct Scsi_Host *host, gdth_ha_str *ha)
+static int gdth_proc_show(struct seq_file *m, void *v)
 {
-    int size = 0,len = 0;
+    struct Scsi_Host *host = m->private;
+    gdth_ha_str *ha = shost_priv(host);
     int hlen;
-    off_t begin = 0,pos = 0;
     int id, i, j, k, sec, flag;
     int no_mdrv = 0, drv_no, is_mirr;
     u32 cnt;
@@ -189,8 +175,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
     /* request is i.e. "cat /proc/scsi/gdth/0" */ 
     /* format: %-15s\t%-10s\t%-15s\t%s */
     /* driver parameters */
-    size = sprintf(buffer+len,"Driver Parameters:\n");
-    len += size;  pos = begin + len;
+    seq_printf(m, "Driver Parameters:\n");
     if (reserve_list[0] == 0xff)
         strcpy(hrec, "--");
     else {
@@ -201,23 +186,19 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
             hlen += snprintf(hrec + hlen , 161 - hlen, ",%d", reserve_list[i]);
         }
     }
-    size = sprintf(buffer+len,
+    seq_printf(m,
                    " reserve_mode: \t%d         \treserve_list:  \t%s\n",
                    reserve_mode, hrec);
-    len += size;  pos = begin + len;
-    size = sprintf(buffer+len,
+    seq_printf(m,
                    " max_ids:      \t%-3d       \thdr_channel:   \t%d\n",
                    max_ids, hdr_channel);
-    len += size;  pos = begin + len;
 
     /* controller information */
-    size = sprintf(buffer+len,"\nDisk Array Controller Information:\n");
-    len += size;  pos = begin + len;
+    seq_printf(m, "\nDisk Array Controller Information:\n");
     strcpy(hrec, ha->binfo.type_string);
-    size = sprintf(buffer+len,
+    seq_printf(m,
                    " Number:       \t%d         \tName:          \t%s\n",
                    ha->hanum, hrec);
-    len += size;  pos = begin + len;
 
     if (ha->more_proc)
         sprintf(hrec, "%d.%02d.%02d-%c%03X", 
@@ -230,40 +211,28 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
         sprintf(hrec, "%d.%02d", (u8)(ha->cpar.version>>8),
                 (u8)(ha->cpar.version));
 
-    size = sprintf(buffer+len,
+    seq_printf(m,
                    " Driver Ver.:  \t%-10s\tFirmware Ver.: \t%s\n",
                    GDTH_VERSION_STR, hrec);
-    len += size;  pos = begin + len;
  
     if (ha->more_proc) {
         /* more information: 1. about controller */
-        size = sprintf(buffer+len,
+        seq_printf(m,
                        " Serial No.:   \t0x%8X\tCache RAM size:\t%d KB\n",
                        ha->binfo.ser_no, ha->binfo.memsize / 1024);
-        len += size;  pos = begin + len;
     }
 
 #ifdef GDTH_DMA_STATISTICS
     /* controller statistics */
-    size = sprintf(buffer+len,"\nController Statistics:\n");
-    len += size;  pos = begin + len;
-    size = sprintf(buffer+len,
+    seq_printf(m, "\nController Statistics:\n");
+    seq_printf(m,
                    " 32-bit DMA buffer:\t%lu\t64-bit DMA buffer:\t%lu\n",
                    ha->dma32_cnt, ha->dma64_cnt);
-    len += size;  pos = begin + len;
 #endif
 
-    if (pos < offset) {
-        len = 0;
-        begin = pos;
-    }
-    if (pos > offset + length)
-        goto stop_output;
-
     if (ha->more_proc) {
         /* more information: 2. about physical devices */
-        size = sprintf(buffer+len,"\nPhysical Devices:");
-        len += size;  pos = begin + len;
+        seq_printf(m, "\nPhysical Devices:");
         flag = FALSE;
             
         buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
@@ -309,21 +278,19 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     strncpy(hrec+8,pdi->product,16);
                     strncpy(hrec+24,pdi->revision,4);
                     hrec[28] = 0;
-                    size = sprintf(buffer+len,
+                    seq_printf(m,
                                    "\n Chn/ID/LUN:   \t%c/%02d/%d    \tName:          \t%s\n",
                                    'A'+i,pdi->target_id,pdi->lun,hrec);
-                    len += size;  pos = begin + len;
                     flag = TRUE;
                     pdi->no_ldrive &= 0xffff;
                     if (pdi->no_ldrive == 0xffff)
                         strcpy(hrec,"--");
                     else
                         sprintf(hrec,"%d",pdi->no_ldrive);
-                    size = sprintf(buffer+len,
+                    seq_printf(m,
                                    " Capacity [MB]:\t%-6d    \tTo Log. Drive: \t%s\n",
                                    pdi->blkcnt/(1024*1024/pdi->blksize),
                                    hrec);
-                    len += size;  pos = begin + len;
                 } else {
                     pdi->devtype = 0xff;
                 }
@@ -333,11 +300,10 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     for (k = 0; k < pds->count; ++k) {
                         if (pds->list[k].tid == pdi->target_id &&
                             pds->list[k].lun == pdi->lun) {
-                            size = sprintf(buffer+len,
+                            seq_printf(m,
                                            " Retries:      \t%-6d    \tReassigns:     \t%d\n",
                                            pds->list[k].retries,
                                            pds->list[k].reassigns);
-                            len += size;  pos = begin + len;
                             break;
                         }
                     }
@@ -355,32 +321,21 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     pdef->sddc_type = 0x08;
 
                     if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
-                        size = sprintf(buffer+len,
+                        seq_printf(m,
                                        " Grown Defects:\t%d\n",
                                        pdef->sddc_cnt);
-                        len += size;  pos = begin + len;
                     }
                 }
-                if (pos < offset) {
-                    len = 0;
-                    begin = pos;
-                }
-		if (pos > offset + length) {
-		    gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
-                    goto stop_output;
-		}
             }
         }
         gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
 
         if (!flag) {
-            size = sprintf(buffer+len, "\n --\n");
-            len += size;  pos = begin + len;
+            seq_printf(m, "\n --\n");
         }
 
         /* 3. about logical drives */
-        size = sprintf(buffer+len,"\nLogical Drives:");
-        len += size;  pos = begin + len;
+        seq_printf(m, "\nLogical Drives:");
         flag = FALSE;
 
         buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
@@ -418,10 +373,9 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                 }
                     
                 if (drv_no == i) {
-                    size = sprintf(buffer+len,
+                    seq_printf(m,
                                    "\n Number:       \t%-2d        \tStatus:        \t%s\n",
                                    drv_no, hrec);
-                    len += size;  pos = begin + len;
                     flag = TRUE;
                     no_mdrv = pcdi->cd_ldcnt;
                     if (no_mdrv > 1 || pcdi->ld_slave != -1) {
@@ -436,61 +390,39 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     } else {
                         strcpy(hrec, "???");
                     }
-                    size = sprintf(buffer+len,
+                    seq_printf(m,
                                    " Capacity [MB]:\t%-6d    \tType:          \t%s\n",
                                    pcdi->ld_blkcnt/(1024*1024/pcdi->ld_blksize),
                                    hrec);
-                    len += size;  pos = begin + len;
                 } else {
-                    size = sprintf(buffer+len,
+                    seq_printf(m,
                                    " Slave Number: \t%-2d        \tStatus:        \t%s\n",
                                    drv_no & 0x7fff, hrec);
-                    len += size;  pos = begin + len;
                 }
                 drv_no = pcdi->ld_slave;
-                if (pos < offset) {
-                    len = 0;
-                    begin = pos;
-                }
-		if (pos > offset + length) {
-		    gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
-                    goto stop_output;
-		}
             } while (drv_no != -1);
              
             if (is_mirr) {
-                size = sprintf(buffer+len,
+                seq_printf(m,
                                " Missing Drv.: \t%-2d        \tInvalid Drv.:  \t%d\n",
                                no_mdrv - j - k, k);
-                len += size;  pos = begin + len;
             }
               
             if (!ha->hdr[i].is_arraydrv)
                 strcpy(hrec, "--");
             else
                 sprintf(hrec, "%d", ha->hdr[i].master_no);
-            size = sprintf(buffer+len,
+            seq_printf(m,
                            " To Array Drv.:\t%s\n", hrec);
-            len += size;  pos = begin + len;
-            if (pos < offset) {
-                len = 0;
-                begin = pos;
-            }
-	    if (pos > offset + length) {
-		gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
-                goto stop_output;
-	    }
         }       
         gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
         
         if (!flag) {
-            size = sprintf(buffer+len, "\n --\n");
-            len += size;  pos = begin + len;
+            seq_printf(m, "\n --\n");
         }   
 
         /* 4. about array drives */
-        size = sprintf(buffer+len,"\nArray Drives:");
-        len += size;  pos = begin + len;
+        seq_printf(m, "\nArray Drives:");
         flag = FALSE;
 
         buf = gdth_ioctl_alloc(ha, GDTH_SCRATCH, FALSE, &paddr);
@@ -525,10 +457,9 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     strcat(hrec, "/expand");
                 else if (pai->ai_ext_state & 0x1)
                     strcat(hrec, "/patch");
-                size = sprintf(buffer+len,
+                seq_printf(m,
                                "\n Number:       \t%-2d        \tStatus:        \t%s\n",
                                i,hrec);
-                len += size;  pos = begin + len;
                 flag = TRUE;
 
                 if (pai->ai_type == 0)
@@ -539,31 +470,20 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                     strcpy(hrec, "RAID-5");
                 else 
                     strcpy(hrec, "RAID-10");
-                size = sprintf(buffer+len,
+                seq_printf(m,
                                " Capacity [MB]:\t%-6d    \tType:          \t%s\n",
                                pai->ai_size/(1024*1024/pai->ai_secsize),
                                hrec);
-                len += size;  pos = begin + len;
-                if (pos < offset) {
-                    len = 0;
-                    begin = pos;
-                }
-		if (pos > offset + length) {
-		    gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
-                    goto stop_output;
-		}
             }
         }
         gdth_ioctl_free(ha, GDTH_SCRATCH, buf, paddr);
         
         if (!flag) {
-            size = sprintf(buffer+len, "\n --\n");
-            len += size;  pos = begin + len;
+            seq_printf(m, "\n --\n");
         }
 
         /* 5. about host drives */
-        size = sprintf(buffer+len,"\nHost Drives:");
-        len += size;  pos = begin + len;
+        seq_printf(m, "\nHost Drives:");
         flag = FALSE;
 
         buf = gdth_ioctl_alloc(ha, sizeof(gdth_hget_str), FALSE, &paddr);
@@ -605,33 +525,23 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
             if (!(ha->hdr[i].present))
                 continue;
               
-            size = sprintf(buffer+len,
+            seq_printf(m,
                            "\n Number:       \t%-2d        \tArr/Log. Drive:\t%d\n",
                            i, ha->hdr[i].ldr_no);
-            len += size;  pos = begin + len;
             flag = TRUE;
 
-            size = sprintf(buffer+len,
+            seq_printf(m,
                            " Capacity [MB]:\t%-6d    \tStart Sector:  \t%d\n",
                            (u32)(ha->hdr[i].size/2048), ha->hdr[i].start_sec);
-            len += size;  pos = begin + len;
-            if (pos < offset) {
-                len = 0;
-                begin = pos;
-            }
-            if (pos > offset + length)
-                goto stop_output;
         }
         
         if (!flag) {
-            size = sprintf(buffer+len, "\n --\n");
-            len += size;  pos = begin + len;
+            seq_printf(m, "\n --\n");
         }
     }
 
     /* controller events */
-    size = sprintf(buffer+len,"\nController Events:\n");
-    len += size;  pos = begin + len;
+    seq_printf(m, "\nController Events:\n");
 
     for (id = -1;;) {
         id = gdth_read_event(ha, id, estr);
@@ -643,28 +553,15 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
             do_gettimeofday(&tv);
             sec = (int)(tv.tv_sec - estr->first_stamp);
             if (sec < 0) sec = 0;
-            size = sprintf(buffer+len," date- %02d:%02d:%02d\t%s\n",
+            seq_printf(m, " date- %02d:%02d:%02d\t%s\n",
                            sec/3600, sec%3600/60, sec%60, hrec);
-            len += size;  pos = begin + len;
-            if (pos < offset) {
-                len = 0;
-                begin = pos;
-            }
-            if (pos > offset + length)
-                goto stop_output;
         }
         if (id == -1)
             break;
     }
 
+    rc = 0;
 stop_output:
-    *start = buffer +(offset-begin);
-    len -= (offset-begin);
-    if (len > length)
-        len = length;
-    TRACE2(("get_info() len %d pos %d begin %d offset %d length %d size %d\n",
-            len,(int)pos,(int)begin,(int)offset,length,size));
-    rc = len;
 
 free_fail:
     kfree(gdtcmd);
@@ -758,3 +655,41 @@ static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
+
+static int gdth_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, gdth_proc_show, PDE(inode)->data);
+}
+
+static ssize_t gdth_proc_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
+{
+	struct Scsi_Host *host = PDE(file->f_path.dentry->d_inode)->data;
+	gdth_ha_str *ha = shost_priv(host);
+	char *cmd;
+	size_t len;
+	int rv;
+
+	cmd = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+	len = min_t(size_t, count, PAGE_SIZE - 1);
+	if (copy_from_user(cmd, buf, len)) {
+		kfree(cmd);
+		return -ENOMEM;
+	}
+	cmd[len] = '\0';
+
+	rv = gdth_set_info(cmd, len, host, ha);
+	kfree(cmd);
+	if (rv < 0)
+		return rv;
+	return count;
+}
+
+static const struct file_operations gdth_proc_ops = {
+	.open		= gdth_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= gdth_proc_write,
+};
diff --git a/drivers/scsi/gdth_proc.h b/drivers/scsi/gdth_proc.h
index dab15f5..7914dcf 100644
--- a/drivers/scsi/gdth_proc.h
+++ b/drivers/scsi/gdth_proc.h
@@ -10,8 +10,6 @@ int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
 
 static int gdth_set_info(char *buffer,int length,struct Scsi_Host *host,
                          gdth_ha_str *ha);
-static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
-                         struct Scsi_Host *host, gdth_ha_str *ha);
 
 static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
                              int length, gdth_ha_str *ha);
-- 
1.7.3.4

