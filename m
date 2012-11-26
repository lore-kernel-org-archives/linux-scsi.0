From: wenxiong@linux.vnet.ibm.com
Subject: [PATCH 3/7] ipr: Resource path error logging cleanup
Date: Mon, 26 Nov 2012 09:55:37 -0600
Message-ID: <20121126155632.208150588@linux.vnet.ibm.com>
References: <20121126155534.352187900@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [32.97.110.65] ([32.97.110.65]:42146 "HELO
	jupiter1-lp2.austin.ibm.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754378Ab2KZQGi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:38 -0500
Content-Disposition: inline; filename=resource_path_error_clean
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, klebers@linux.vnet.ibm.com, brking@linux.vnet.ibm.com

The resource path as displayed by the ipr driver is the
location string identifying a location on the SAS fabric.
This patch adds the SCSI host number such that error logs
can be more easily correlated in multiple adapter configurations.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   78 ++++++++++++++++++++++++++++++++++++-----------------
 drivers/scsi/ipr.h |    5 ++-
 2 files changed, 56 insertions(+), 27 deletions(-)

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2012-11-14 23:07:25.986404583 -0600
+++ b/drivers/scsi/ipr.h	2012-11-14 23:11:26.756404525 -0600
@@ -409,7 +409,7 @@ struct ipr_config_table_entry64 {
 	__be64 dev_id;
 	__be64 lun;
 	__be64 lun_wwn[2];
-#define IPR_MAX_RES_PATH_LENGTH		24
+#define IPR_MAX_RES_PATH_LENGTH		48
 	__be64 res_path;
 	struct ipr_std_inq_data std_inq_data;
 	u8 reserved2[4];
@@ -1722,7 +1722,8 @@ struct ipr_ucode_image_header {
 	if (ipr_is_device(hostrcb)) {					\
 		if ((hostrcb)->ioa_cfg->sis64) {			\
 			printk(KERN_ERR IPR_NAME ": %s: " fmt, 		\
-				ipr_format_res_path(hostrcb->hcam.u.error64.fd_res_path, \
+				ipr_format_res_path(hostrcb->ioa_cfg,	\
+					hostrcb->hcam.u.error64.fd_res_path, \
 					hostrcb->rp_buffer,		\
 					sizeof(hostrcb->rp_buffer)),	\
 				__VA_ARGS__);				\
Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2012-11-14 23:09:49.484214019 -0600
+++ b/drivers/scsi/ipr.c	2012-11-14 23:28:24.724214331 -0600
@@ -1166,14 +1166,15 @@ static int ipr_is_same_device(struct ipr
 }
 
 /**
- * ipr_format_res_path - Format the resource path for printing.
+ * __ipr_format_res_path - Format the resource path for printing.
  * @res_path:	resource path
  * @buf:	buffer
+ * @len:	length of buffer provided
  *
  * Return value:
  * 	pointer to buffer
  **/
-static char *ipr_format_res_path(u8 *res_path, char *buffer, int len)
+static char *__ipr_format_res_path(u8 *res_path, char *buffer, int len)
 {
 	int i;
 	char *p = buffer;
@@ -1187,6 +1188,27 @@ static char *ipr_format_res_path(u8 *res
 }
 
 /**
+ * ipr_format_res_path - Format the resource path for printing.
+ * @ioa_cfg:	ioa config struct
+ * @res_path:	resource path
+ * @buf:	buffer
+ * @len:	length of buffer provided
+ *
+ * Return value:
+ *	pointer to buffer
+ **/
+static char *ipr_format_res_path(struct ipr_ioa_cfg *ioa_cfg,
+				 u8 *res_path, char *buffer, int len)
+{
+	char *p = buffer;
+
+	*p = '\0';
+	p += snprintf(p, buffer + len - p, "%d/", ioa_cfg->host->host_no);
+	__ipr_format_res_path(res_path, p, len - (buffer - p));
+	return buffer;
+}
+
+/**
  * ipr_update_res_entry - Update the resource entry.
  * @res:	resource entry struct
  * @cfgtew:	config table entry wrapper struct
@@ -1226,8 +1248,8 @@ static void ipr_update_res_entry(struct 
 
 		if (res->sdev && new_path)
 			sdev_printk(KERN_INFO, res->sdev, "Resource path: %s\n",
-				    ipr_format_res_path(res->res_path, buffer,
-							sizeof(buffer)));
+				    ipr_format_res_path(res->ioa_cfg,
+					res->res_path, buffer, sizeof(buffer)));
 	} else {
 		res->flags = cfgtew->u.cfgte->flags;
 		if (res->flags & IPR_IS_IOA_RESOURCE)
@@ -1613,8 +1635,8 @@ static void ipr_log_sis64_config_error(s
 		ipr_err_separator;
 
 		ipr_err("Device %d : %s", i + 1,
-			 ipr_format_res_path(dev_entry->res_path, buffer,
-					     sizeof(buffer)));
+			__ipr_format_res_path(dev_entry->res_path,
+					      buffer, sizeof(buffer)));
 		ipr_log_ext_vpd(&dev_entry->vpd);
 
 		ipr_err("-----New Device Information-----\n");
@@ -1960,14 +1982,16 @@ static void ipr_log64_fabric_path(struct
 
 			ipr_hcam_err(hostrcb, "%s %s: Resource Path=%s\n",
 				     path_active_desc[i].desc, path_state_desc[j].desc,
-				     ipr_format_res_path(fabric->res_path, buffer,
-							 sizeof(buffer)));
+				     ipr_format_res_path(hostrcb->ioa_cfg,
+						fabric->res_path,
+						buffer, sizeof(buffer)));
 			return;
 		}
 	}
 
 	ipr_err("Path state=%02X Resource Path=%s\n", path_state,
-		ipr_format_res_path(fabric->res_path, buffer, sizeof(buffer)));
+		ipr_format_res_path(hostrcb->ioa_cfg, fabric->res_path,
+				    buffer, sizeof(buffer)));
 }
 
 static const struct {
@@ -2108,18 +2132,20 @@ static void ipr_log64_path_elem(struct i
 
 			ipr_hcam_err(hostrcb, "%s %s: Resource Path=%s, Link rate=%s, WWN=%08X%08X\n",
 				     path_status_desc[j].desc, path_type_desc[i].desc,
-				     ipr_format_res_path(cfg->res_path, buffer,
-							 sizeof(buffer)),
-				     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
-				     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
+				     ipr_format_res_path(hostrcb->ioa_cfg,
+					cfg->res_path, buffer, sizeof(buffer)),
+					link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
+					be32_to_cpu(cfg->wwid[0]),
+					be32_to_cpu(cfg->wwid[1]));
 			return;
 		}
 	}
 	ipr_hcam_err(hostrcb, "Path element=%02X: Resource Path=%s, Link rate=%s "
 		     "WWN=%08X%08X\n", cfg->type_status,
-		     ipr_format_res_path(cfg->res_path, buffer, sizeof(buffer)),
-		     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
-		     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
+		     ipr_format_res_path(hostrcb->ioa_cfg,
+			cfg->res_path, buffer, sizeof(buffer)),
+			link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
+			be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
 }
 
 /**
@@ -2182,7 +2208,8 @@ static void ipr_log_sis64_array_error(st
 
 	ipr_err("RAID %s Array Configuration: %s\n",
 		error->protection_level,
-		ipr_format_res_path(error->last_res_path, buffer, sizeof(buffer)));
+		ipr_format_res_path(ioa_cfg, error->last_res_path,
+			buffer, sizeof(buffer)));
 
 	ipr_err_separator;
 
@@ -2203,11 +2230,12 @@ static void ipr_log_sis64_array_error(st
 		ipr_err("Array Member %d:\n", i);
 		ipr_log_ext_vpd(&array_entry->vpd);
 		ipr_err("Current Location: %s\n",
-			 ipr_format_res_path(array_entry->res_path, buffer,
-					     sizeof(buffer)));
+			 ipr_format_res_path(ioa_cfg, array_entry->res_path,
+				buffer, sizeof(buffer)));
 		ipr_err("Expected Location: %s\n",
-			 ipr_format_res_path(array_entry->expected_res_path,
-					     buffer, sizeof(buffer)));
+			 ipr_format_res_path(ioa_cfg,
+				array_entry->expected_res_path,
+				buffer, sizeof(buffer)));
 
 		ipr_err_separator;
 	}
@@ -4227,8 +4255,8 @@ static ssize_t ipr_show_resource_path(st
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 	if (res && ioa_cfg->sis64)
 		len = snprintf(buf, PAGE_SIZE, "%s\n",
-			       ipr_format_res_path(res->res_path, buffer,
-						   sizeof(buffer)));
+			       __ipr_format_res_path(res->res_path, buffer,
+						     sizeof(buffer)));
 	else if (res)
 		len = snprintf(buf, PAGE_SIZE, "%d:%d:%d:%d\n", ioa_cfg->host->host_no,
 			       res->bus, res->target, res->lun);
@@ -4556,8 +4584,8 @@ static int ipr_slave_configure(struct sc
 			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 		if (ioa_cfg->sis64)
 			sdev_printk(KERN_INFO, sdev, "Resource path: %s\n",
-				    ipr_format_res_path(res->res_path, buffer,
-							sizeof(buffer)));
+				    ipr_format_res_path(ioa_cfg,
+				res->res_path, buffer, sizeof(buffer)));
 		return 0;
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);

-- 
