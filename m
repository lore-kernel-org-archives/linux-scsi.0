From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] [SCSI] ipr: Fix stack overflow in ipr_format_resource_path
Date: Wed, 2 Jun 2010 21:16:58 +1000
Message-ID: <20100602111658.GH28295@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:33055 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757391Ab0FBLT3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2010 07:19:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com, wayneb@linux.vnet.ibm.com, betabandido@gmail.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org


Victor reported an oops during boot with 2.6.34 on a POWER6 JS22:

https://bugzilla.kernel.org/show_bug.cgi?id=16089

Checking ipr microcode levels
Unable to handle kernel paging request for instruction fetch
Faulting instruction address: 0x322d30312d31302c
...
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA pSeries
last sysfs file:
/sys/devices/pci0000:00/0000:00:01.0/host0/target0:255:255/0:255:255:255/resource_path
Modules linked in:
NIP: 322d30312d31302c LR: 322d30312d31302d CTR: c000000000375bec
REGS: c0000003d360f8f0 TRAP: 0400   Not tainted  (2.6.34-vjj)
MSR: 8000000040009432 <EE,ME,IR,DR>  CR: 28002484  XER: 20000020
TASK = c0000003d587d010[5163] 'iprupdate' THREAD: c0000003d360c000 CPU: 7
GPR00: 322d30312d31302d c0000003d360fb70 c000000000ad07c0 00000000000185a0 
GPR04: 0000000000000001 c0000003d360fb10 04000affffffffff c0000000006a6700 
GPR08: c000000000823383 0000000000000000 0000000000000020 0000000000000000 
GPR12: 000000000000f032 c00000000f622e00 00000000000000ed 0000000000000000 
GPR16: 00000000100b8808 0000000010020000 0000000010020000 0000000010010000 
GPR20: 0000000010010000 0000000000000001 0000000000001000 000000001045eef8 
GPR24: c0000003d360fdf8 302d31342d31302d 43302d30302d3030 2d30332d44352d34 
GPR28: 422d33382d30302d 30302d30302d3030 2d30302d30302d30 302d30302d30302d 
NIP [322d30312d31302c] 0x322d30312d31302c
LR [322d30312d31302d] 0x322d30312d31302d

A stack overflow. It turns out ipr_format_resource_path writes to a
passed in buffer using sprintf which is dangerous and in this case looks
to be the cause of the overflow.

The following patch passes in the length of the buffer and uses snprintf,
which fixes the fail for me. It doesn't fix the other issue, which is
why the loop in ipr_format_resource_path didn't terminate in the first place.
That can be fixed in a follow up patch.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/drivers/scsi/ipr.c
===================================================================
--- linux.trees.git.orig/drivers/scsi/ipr.c	2010-05-31 08:51:20.000000000 +1000
+++ linux.trees.git/drivers/scsi/ipr.c	2010-06-02 21:15:41.000000000 +1000
@@ -1132,17 +1132,20 @@ static int ipr_is_same_device(struct ipr
  * ipr_format_resource_path - Format the resource path for printing.
  * @res_path:	resource path
  * @buf:	buffer
+ * @len:	length of the buffer
  *
  * Return value:
  * 	pointer to buffer
  **/
-static char *ipr_format_resource_path(u8 *res_path, char *buffer)
+static char *ipr_format_resource_path(u8 *res_path, char *buffer,
+				      unsigned int len)
 {
 	int i;
+	char *p = buffer;
 
-	sprintf(buffer, "%02X", res_path[0]);
+	p += snprintf(p, buffer + len - p, "%02X", res_path[0]);
 	for (i=1; res_path[i] != 0xff; i++)
-		sprintf(buffer, "%s-%02X", buffer, res_path[i]);
+		p += snprintf(p, buffer + len - p, "-%02X", res_path[i]);
 
 	return buffer;
 }
@@ -1187,7 +1190,8 @@ static void ipr_update_res_entry(struct 
 
 		if (res->sdev && new_path)
 			sdev_printk(KERN_INFO, res->sdev, "Resource path: %s\n",
-				    ipr_format_resource_path(&res->res_path[0], &buffer[0]));
+				    ipr_format_resource_path(&res->res_path[0],
+				    &buffer[0], sizeof(buffer)));
 	} else {
 		res->flags = cfgtew->u.cfgte->flags;
 		if (res->flags & IPR_IS_IOA_RESOURCE)
@@ -1573,7 +1577,8 @@ static void ipr_log_sis64_config_error(s
 		ipr_err_separator;
 
 		ipr_err("Device %d : %s", i + 1,
-			 ipr_format_resource_path(&dev_entry->res_path[0], &buffer[0]));
+			 ipr_format_resource_path(&dev_entry->res_path[0],
+			 &buffer[0], sizeof(buffer)));
 		ipr_log_ext_vpd(&dev_entry->vpd);
 
 		ipr_err("-----New Device Information-----\n");
@@ -1919,13 +1924,15 @@ static void ipr_log64_fabric_path(struct
 
 			ipr_hcam_err(hostrcb, "%s %s: Resource Path=%s\n",
 				     path_active_desc[i].desc, path_state_desc[j].desc,
-				     ipr_format_resource_path(&fabric->res_path[0], &buffer[0]));
+				     ipr_format_resource_path(&fabric->res_path[0],
+				     &buffer[0], sizeof(buffer)));
 			return;
 		}
 	}
 
 	ipr_err("Path state=%02X Resource Path=%s\n", path_state,
-		ipr_format_resource_path(&fabric->res_path[0], &buffer[0]));
+		ipr_format_resource_path(&fabric->res_path[0], &buffer[0],
+		sizeof(buffer)));
 }
 
 static const struct {
@@ -2066,7 +2073,9 @@ static void ipr_log64_path_elem(struct i
 
 			ipr_hcam_err(hostrcb, "%s %s: Resource Path=%s, Link rate=%s, WWN=%08X%08X\n",
 				     path_status_desc[j].desc, path_type_desc[i].desc,
-				     ipr_format_resource_path(&cfg->res_path[0], &buffer[0]),
+				     ipr_format_resource_path(&cfg->res_path[0],
+							      &buffer[0],
+							      sizeof(buffer)),
 				     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
 				     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
 			return;
@@ -2074,7 +2083,8 @@ static void ipr_log64_path_elem(struct i
 	}
 	ipr_hcam_err(hostrcb, "Path element=%02X: Resource Path=%s, Link rate=%s "
 		     "WWN=%08X%08X\n", cfg->type_status,
-		     ipr_format_resource_path(&cfg->res_path[0], &buffer[0]),
+		     ipr_format_resource_path(&cfg->res_path[0], &buffer[0],
+		     sizeof(buffer)),
 		     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
 		     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
 }
@@ -2139,7 +2149,8 @@ static void ipr_log_sis64_array_error(st
 
 	ipr_err("RAID %s Array Configuration: %s\n",
 		error->protection_level,
-		ipr_format_resource_path(&error->last_res_path[0], &buffer[0]));
+		ipr_format_resource_path(&error->last_res_path[0], &buffer[0],
+					 sizeof(buffer)));
 
 	ipr_err_separator;
 
@@ -2160,9 +2171,12 @@ static void ipr_log_sis64_array_error(st
 		ipr_err("Array Member %d:\n", i);
 		ipr_log_ext_vpd(&array_entry->vpd);
 		ipr_err("Current Location: %s",
-			 ipr_format_resource_path(&array_entry->res_path[0], &buffer[0]));
+			 ipr_format_resource_path(&array_entry->res_path[0],
+						  &buffer[0],
+						  sizeof(buffer)));
 		ipr_err("Expected Location: %s",
-			 ipr_format_resource_path(&array_entry->expected_res_path[0], &buffer[0]));
+			 ipr_format_resource_path(&array_entry->expected_res_path[0],
+						  &buffer[0], sizeof(buffer)));
 
 		ipr_err_separator;
 	}
@@ -4099,7 +4113,9 @@ static ssize_t ipr_show_resource_path(st
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 	if (res)
 		len = snprintf(buf, PAGE_SIZE, "%s\n",
-			       ipr_format_resource_path(&res->res_path[0], &buffer[0]));
+			       ipr_format_resource_path(&res->res_path[0],
+							&buffer[0],
+							sizeof(buffer)));
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
@@ -4351,7 +4367,9 @@ static int ipr_slave_configure(struct sc
 			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 		if (ioa_cfg->sis64)
 			sdev_printk(KERN_INFO, sdev, "Resource path: %s\n",
-			            ipr_format_resource_path(&res->res_path[0], &buffer[0]));
+			            ipr_format_resource_path(&res->res_path[0],
+							     &buffer[0],
+							     sizeof(buffer)));
 		return 0;
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
Index: linux.trees.git/drivers/scsi/ipr.h
===================================================================
--- linux.trees.git.orig/drivers/scsi/ipr.h	2010-05-31 08:51:20.000000000 +1000
+++ linux.trees.git/drivers/scsi/ipr.h	2010-06-02 21:15:41.000000000 +1000
@@ -1685,7 +1685,8 @@ struct ipr_ucode_image_header {
 		if ((hostrcb)->ioa_cfg->sis64) {			\
 			printk(KERN_ERR IPR_NAME ": %s: " fmt, 		\
 				ipr_format_resource_path(&hostrcb->hcam.u.error64.fd_res_path[0], \
-					&hostrcb->rp_buffer[0]),	\
+					&hostrcb->rp_buffer[0],		\
+					sizeof(hostrcb->rp_buffer)),	\
 				__VA_ARGS__);				\
 		} else {						\
 			ipr_ra_err((hostrcb)->ioa_cfg,			\
