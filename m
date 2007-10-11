From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] [RFC] Correct REPORT TARGET PORT GROUPS
Date: Thu, 11 Oct 2007 17:15:00 +0200
Message-ID: <470E3DF4.4070402@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030109020600030002080008"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbXJKPPD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 11:15:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030109020600030002080008
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi Doug,

as we now have an ALUA hardware handler it's about time to update
the scsi_debug driver so we can actually play with it.

So I've modified the REPORT TARGET GROUPS command to do a full
inventory of all ports instead of just reporting fake values
(which IMO was a violation of the spec anyway).

But now the interface for generating VPD page 0x83 really
becomes cluttered; I'd rather passing just 'devip' and
let the function figure out everything else.

Next step will be implementing SET TARGET PORT GROUPS.
And correct VPD page 0x88 to correct the updated valued.
But weren't there some SAS intrinsics which required two
ports to be reported here?

Comments?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------030109020600030002080008
Content-Type: text/plain;
 name="scsi-debug-fixup-rtpg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-debug-fixup-rtpg"

tree c3e6bbe480ea83b7e28a8d21539fa70869bff4c3
parent b1ba4fa61f649d322224693d87840d0c5664f489
author Hannes Reinecke <hare@suse.de> 1192115239 +0200
committer Hannes Reinecke <hare@suse.de> 1192115239 +0200

scsi-debug: Correct REPORT TARGET PORT GROUPS

REPORT TARGET PORT GROUPS should actually report all port groups
in the system, not the faked ones. So we have to do a full report
here.
Also store the alua-state in the host, we'll be needing it
for SET TARGET PORT GROUPS.

Signed-off-by: Hannes Reinecke <hare@suse.de>
ccf47482f6ee476276d080f5727cc17c5b3907a7
 drivers/scsi/scsi_debug.c |  102 +++++++++++++++++++++------------------------
 1 files changed, 47 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4947dfe..6d067cc 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -182,6 +182,7 @@ struct sdebug_host_info {
 	struct Scsi_Host *shost;
 	struct device dev;
 	struct list_head dev_info_list;
+	int alua_state;
 };
 
 #define to_sdebug_host(d)	\
@@ -296,7 +297,7 @@ static void __init sdebug_build_parts(unsigned char * ramp);
 static void __init init_all_queued(void);
 static void stop_all_queued(void);
 static int stop_queued_cmnd(struct scsi_cmnd * cmnd);
-static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
+static int inquiry_evpd_83(unsigned char * arr, int port_group_id, int rel_port_id,
 			   int target_dev_id, int dev_id_num,
 			   const char * dev_id_str, int dev_id_str_len);
 static int inquiry_evpd_88(unsigned char * arr, int target_dev_id);
@@ -694,7 +695,7 @@ static const char * inq_product_id = "scsi_debug      ";
 static const char * inq_product_rev = "0004";
 
 static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
-			   int target_dev_id, int dev_id_num,
+			   int rel_port_id, int target_dev_id, int dev_id_num,
 			   const char * dev_id_str,
 			   int dev_id_str_len)
 {
@@ -733,8 +734,8 @@ static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
 		arr[num++] = 0x4;	/* length */
 		arr[num++] = 0x0;	/* reserved */
 		arr[num++] = 0x0;	/* reserved */
-		arr[num++] = 0x0;
-		arr[num++] = 0x1;	/* relative port A */
+		arr[num++] = (rel_port_id >> 8) & 0xff;
+		arr[num++] = (rel_port_id) & 0xff;
 	}
 	/* NAA-5, Target port identifier */
 	arr[num++] = 0x61;	/* proto=sas, binary */
@@ -987,12 +988,13 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
 		kfree(arr);
 		return check_condition_result;
 	} else if (0x1 & cmd[1]) {  /* EVPD bit set */
-		int lu_id_num, port_group_id, target_dev_id, len;
+		int lu_id_num, port_group_id, rel_port_id, target_dev_id, len;
 		char lu_id_str[6];
 		int host_no = devip->sdbg_host->shost->host_no;
-		
+
 		port_group_id = (((host_no + 1) & 0x7f) << 8) +
 		    (devip->channel & 0x7f);
+		rel_port_id = devip->target * scsi_debug_max_luns + devip->lun;
 		if (0 == scsi_debug_vpd_use_hostno)
 			host_no = 0;
 		lu_id_num = devip->wlun ? -1 : (((host_no + 1) * 2000) +
@@ -1020,7 +1022,7 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
 			memcpy(&arr[4], lu_id_str, len);
 		} else if (0x83 == cmd[2]) { /* device identification */
 			arr[1] = cmd[2];	/*sanity */
-			arr[3] = inquiry_evpd_83(&arr[4], port_group_id,
+			arr[3] = inquiry_evpd_83(&arr[4], port_group_id, rel_port_id,
 						 target_dev_id, lu_id_num,
 						 lu_id_str, len);
 		} else if (0x84 == cmd[2]) { /* Software interface ident. */
@@ -1229,9 +1231,10 @@ static int resp_report_tgtpgs(struct scsi_cmnd * scp,
 {
 	unsigned char *cmd = (unsigned char *)scp->cmnd;
 	unsigned char * arr;
-	int host_no = devip->sdbg_host->shost->host_no;
+	struct sdebug_host_info *sdbg_host;
+	int host_no;
 	int n, ret, alen, rlen;
-	int port_group_a, port_group_b, port_a, port_b;
+	int port_group_id;
 
 	alen = ((cmd[6] << 24) + (cmd[7] << 16) + (cmd[8] << 8)
 		+ cmd[9]);
@@ -1239,52 +1242,34 @@ static int resp_report_tgtpgs(struct scsi_cmnd * scp,
 	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
-	/*
-	 * EVPD page 0x88 states we have two ports, one
-	 * real and a fake port with no device connected.
-	 * So we create two port groups with one port each
-	 * and set the group with port B to unavailable.
-	 */
-	port_a = 0x1; /* relative port A */
-	port_b = 0x2; /* relative port B */
-	port_group_a = (((host_no + 1) & 0x7f) << 8) +
-	    (devip->channel & 0x7f);
-	port_group_b = (((host_no + 1) & 0x7f) << 8) +
-	    (devip->channel & 0x7f) + 0x80;
 
-	/*
-	 * The asymmetric access state is cycled according to the host_id.
-	 */
 	n = 4;
-	if (0 == scsi_debug_vpd_use_hostno) {
-	    arr[n++] = host_no % 3; /* Asymm access state */
-	    arr[n++] = 0x0F; /* claim: all states are supported */
-	} else {
-	    arr[n++] = 0x0; /* Active/Optimized path */
-	    arr[n++] = 0x01; /* claim: only support active/optimized paths */
-	}
-	arr[n++] = (port_group_a >> 8) & 0xff;
-	arr[n++] = port_group_a & 0xff;
-	arr[n++] = 0;    /* Reserved */
-	arr[n++] = 0;    /* Status code */
-	arr[n++] = 0;    /* Vendor unique */
-	arr[n++] = 0x1;  /* One port per group */
-	arr[n++] = 0;    /* Reserved */
-	arr[n++] = 0;    /* Reserved */
-	arr[n++] = (port_a >> 8) & 0xff;
-	arr[n++] = port_a & 0xff;
-	arr[n++] = 3;    /* Port unavailable */
-	arr[n++] = 0x08; /* claim: only unavailalbe paths are supported */
-	arr[n++] = (port_group_b >> 8) & 0xff;
-	arr[n++] = port_group_b & 0xff;
-	arr[n++] = 0;    /* Reserved */
-	arr[n++] = 0;    /* Status code */
-	arr[n++] = 0;    /* Vendor unique */
-	arr[n++] = 0x1;  /* One port per group */
-	arr[n++] = 0;    /* Reserved */
-	arr[n++] = 0;    /* Reserved */
-	arr[n++] = (port_b >> 8) & 0xff;
-	arr[n++] = port_b & 0xff;
+	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+		host_no = sdbg_host->shost->host_no + 1;
+		arr[n++] = sdbg_host->alua_state & 0x0f;
+		if (0 == scsi_debug_vpd_use_hostno) {
+			arr[n++] = 0x0F; /* claim: all states are supported */
+		} else {
+			arr[n++] = 0x01; /* claim: only support active/optimized paths */
+		}
+		list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
+			int rel_port_id = devip->target * scsi_debug_max_luns + devip->lun;
+
+			if (rel_port_id == 0) {
+				port_group_id = ((host_no & 0x7f) << 8) + (devip->channel & 0x7f);
+				arr[n++] = (port_group_id >> 8) & 0xff;
+				arr[n++] = port_group_id & 0xff;
+				arr[n++] = 0; /* Reserved */
+				arr[n++] = 0; /* Status code */
+				arr[n++] = 0; /* Vendor_specific */
+				arr[n++] = scsi_debug_num_tgts * scsi_debug_max_luns;
+			}
+			arr[n++] = 0; /* Obsolete */
+			arr[n++] = 0; /* Obsolete */
+			arr[n++] = (rel_port_id >> 8) & 0xff;
+			arr[n++] = rel_port_id & 0xff;
+		}
+	}
 
 	rlen = n - 4;
 	arr[0] = (rlen >> 24) & 0xff;
@@ -3064,9 +3049,16 @@ static int sdebug_driver_probe(struct device * dev)
                 printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);
                 error = -ENODEV;
 		scsi_host_put(hpnt);
-        } else
-		scsi_scan_host(hpnt);
+	} else {
+		/*
+		 * The asymmetric access state is cycled according to the host_id.
+		 */
+		if (0 == scsi_debug_vpd_use_hostno) {
+			sdbg_host->alua_state = hpnt->host_no % 3; /* Asymm access state */
+		}
 
+		scsi_scan_host(hpnt);
+	}
 
         return error;
 }

--------------030109020600030002080008--
