From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] ALUA support for scsi_debug
Date: Wed, 18 Oct 2006 16:18:19 -0400
Message-ID: <45368C0B.7070802@torque.net>
References: <20061018145018.GC25084@pentland.suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080703060506060602040709"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57779 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422813AbWJRUQu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 16:16:50 -0400
In-Reply-To: <20061018145018.GC25084@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------080703060506060602040709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hannes Reinecke wrote:
> Hi all,
> 
> I've hacked up scsi_debug to support REPORT TARGET PORT GROUPS.
> In combination with vpd_use_hostno=0 it'll now support multipathing
> nicely.
> Doug, there is reference to port_a and port_b in the VPD page support.
> However, port_b appearently is just a fake entry with no (virtual)
> device backing.
> We could eg use the 'channel' value to refer the relative port number,
> so that host & channel act as a fan-out for multipathing.
> 
> James, please apply.

Not quite yet ...

Hannes,
Here is my counter patch for you to consider.
I suspect my machine was running into stack
problems so I moved some arrays onto the heap.

You will see some other small changes if you
compare the two patches. My patch is against
lk 2.6.19-rc2

Doug Gilbert

--------------080703060506060602040709
Content-Type: text/x-patch;
 name="sdebug_2619rc2alua2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug_2619rc2alua2.diff"

--- linux/include/scsi/scsi.h	2006-10-18 15:35:44.000000000 -0400
+++ linux/include/scsi/scsi.h2619rc2alua	2006-10-18 15:36:26.000000000 -0400
@@ -97,6 +97,7 @@
 #define PERSISTENT_RESERVE_IN 0x5e
 #define PERSISTENT_RESERVE_OUT 0x5f
 #define REPORT_LUNS           0xa0
+#define MAINTENANCE_IN        0xa3
 #define MOVE_MEDIUM           0xa5
 #define EXCHANGE_MEDIUM       0xa6
 #define READ_12               0xa8
@@ -114,6 +115,8 @@
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
+/* values for maintenance in */
+#define MI_REPORT_TARGET_PGS  0x0a
 
 /* Values for T10/04-262r7 */
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
--- linux/drivers/scsi/scsi_debug.c	2006-10-07 10:26:01.000000000 -0400
+++ linux/drivers/scsi/scsi_debug.c2619rc2alua2	2006-10-18 14:55:19.000000000 -0400
@@ -52,7 +52,7 @@
 #include "scsi_debug.h"
 
 #define SCSI_DEBUG_VERSION "1.80"
-static const char * scsi_debug_version_date = "20060914";
+static const char * scsi_debug_version_date = "20061018";
 
 /* Additional Sense Code (ASC) used */
 #define NO_ADDITIONAL_SENSE 0x0
@@ -254,6 +254,8 @@
 			 struct sdebug_dev_info * devip);
 static int resp_start_stop(struct scsi_cmnd * scp,
 			   struct sdebug_dev_info * devip);
+static int resp_report_tgtpgs(struct scsi_cmnd * scp,
+			      struct sdebug_dev_info * devip);
 static int resp_readcap(struct scsi_cmnd * SCpnt,
 			struct sdebug_dev_info * devip);
 static int resp_readcap16(struct scsi_cmnd * SCpnt,
@@ -287,9 +289,9 @@
 static void __init init_all_queued(void);
 static void stop_all_queued(void);
 static int stop_queued_cmnd(struct scsi_cmnd * cmnd);
-static int inquiry_evpd_83(unsigned char * arr, int target_dev_id,
-			   int dev_id_num, const char * dev_id_str,
-			   int dev_id_str_len);
+static int inquiry_evpd_83(unsigned char * arr, int target_port_id,
+			   int target_dev_id, int dev_id_num,
+			   const char * dev_id_str, int dev_id_str_len);
 static int inquiry_evpd_88(unsigned char * arr, int target_dev_id);
 static int do_create_driverfs_files(void);
 static void do_remove_driverfs_files(void);
@@ -422,6 +424,15 @@
 		}
 		errsts = resp_readcap16(SCpnt, devip);
 		break;
+	case MAINTENANCE_IN:
+		if (MI_REPORT_TARGET_PGS != cmd[1]) {
+			mk_sense_buffer(devip, ILLEGAL_REQUEST,
+					INVALID_OPCODE, 0);
+			errsts = check_condition_result;
+			break;
+		}
+		errsts = resp_report_tgtpgs(SCpnt, devip);
+		break;
 	case READ_16:
 	case READ_12:
 	case READ_10:
@@ -665,8 +676,9 @@
 static const char * inq_product_id = "scsi_debug      ";
 static const char * inq_product_rev = "0004";
 
-static int inquiry_evpd_83(unsigned char * arr, int target_dev_id,
-			   int dev_id_num, const char * dev_id_str,
+static int inquiry_evpd_83(unsigned char * arr, int target_port_id,
+			   int target_dev_id, int dev_id_num,
+			   const char * dev_id_str,
 			   int dev_id_str_len)
 {
 	int num, port_a;
@@ -720,6 +732,15 @@
 	arr[num++] = (port_a >> 16) & 0xff;
 	arr[num++] = (port_a >> 8) & 0xff;
 	arr[num++] = port_a & 0xff;
+	/* NAA-5, Target port group identifier */
+	arr[num++] = 0x61;	/* proto=sas, binary */
+	arr[num++] = 0x95;	/* piv=1, target port group id */
+	arr[num++] = 0x0;
+	arr[num++] = 0x4;
+	arr[num++] = 0;
+	arr[num++] = 0;
+	arr[num++] = (target_port_id >> 8) & 0xff;
+	arr[num++] = target_port_id & 0xff;
 	/* NAA-5, Target device identifier */
 	arr[num++] = 0x61;	/* proto=sas, binary */
 	arr[num++] = 0xa3;	/* piv=1, target device, naa */
@@ -928,12 +949,12 @@
 			struct sdebug_dev_info * devip)
 {
 	unsigned char pq_pdt;
-	unsigned char arr[SDEBUG_MAX_INQ_ARR_SZ];
+	unsigned char * arr;
 	unsigned char *cmd = (unsigned char *)scp->cmnd;
-	int alloc_len, n;
+	int alloc_len, n, ret;
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
-	memset(arr, 0, SDEBUG_MAX_INQ_ARR_SZ);
+	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_KERNEL);
 	if (devip->wlun)
 		pq_pdt = 0x1e;	/* present, wlun */
 	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
@@ -944,12 +965,14 @@
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
 			       	0);
+		kfree(arr);
 		return check_condition_result;
 	} else if (0x1 & cmd[1]) {  /* EVPD bit set */
-		int lu_id_num, target_dev_id, len;
+		int lu_id_num, target_port_id, target_dev_id, len;
 		char lu_id_str[6];
 		int host_no = devip->sdbg_host->shost->host_no;
 		
+		target_port_id = (host_no + 1);
 		if (0 == scsi_debug_vpd_use_hostno)
 			host_no = 0;
 		lu_id_num = devip->wlun ? -1 : (((host_no + 1) * 2000) +
@@ -977,8 +1000,9 @@
 			memcpy(&arr[4], lu_id_str, len);
 		} else if (0x83 == cmd[2]) { /* device identification */
 			arr[1] = cmd[2];	/*sanity */
-			arr[3] = inquiry_evpd_83(&arr[4], target_dev_id,
-						 lu_id_num, lu_id_str, len);
+			arr[3] = inquiry_evpd_83(&arr[4], target_port_id,
+						 target_dev_id, lu_id_num,
+						 lu_id_str, len);
 		} else if (0x84 == cmd[2]) { /* Software interface ident. */
 			arr[1] = cmd[2];	/*sanity */
 			arr[3] = inquiry_evpd_84(&arr[4]);
@@ -1012,17 +1036,22 @@
 			/* Illegal request, invalid field in cdb */
 			mk_sense_buffer(devip, ILLEGAL_REQUEST,
 					INVALID_FIELD_IN_CDB, 0);
+			kfree(arr);
 			return check_condition_result;
 		}
 		len = min(((arr[2] << 8) + arr[3]) + 4, alloc_len);
-		return fill_from_dev_buffer(scp, arr,
+		ret = fill_from_dev_buffer(scp, arr,
 			    min(len, SDEBUG_MAX_INQ_ARR_SZ));
+		kfree(arr);
+		return ret;
 	}
 	/* drops through here for a standard inquiry */
 	arr[1] = DEV_REMOVEABLE(target) ? 0x80 : 0;	/* Removable disk */
 	arr[2] = scsi_debug_scsi_level;
 	arr[3] = 2;    /* response_data_format==2 */
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
+	if (0 == scsi_debug_vpd_use_hostno)
+		arr[5] = 0x10; /* claim: implicit TGPS */
 	arr[6] = 0x10; /* claim: MultiP */
 	/* arr[6] |= 0x40; ... claim: EncServ (enclosure services) */
 	arr[7] = 0xa; /* claim: LINKED + CMDQUE */
@@ -1039,8 +1068,10 @@
 		arr[n++] = 0x3; arr[n++] = 0x60; /* SSC-2 no version */
 	}
 	arr[n++] = 0xc; arr[n++] = 0xf;  /* SAS-1.1 rev 10 */
-	return fill_from_dev_buffer(scp, arr,
+	ret = fill_from_dev_buffer(scp, arr,
 			    min(alloc_len, SDEBUG_LONG_INQ_SZ));
+	kfree(arr);
+	return ret;
 }
 
 static int resp_requests(struct scsi_cmnd * scp,
@@ -1171,6 +1202,73 @@
 				    min(alloc_len, SDEBUG_READCAP16_ARR_SZ));
 }
 
+#define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
+
+static int resp_report_tgtpgs(struct scsi_cmnd * scp,
+			      struct sdebug_dev_info * devip)
+{
+	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char * arr;
+	int n, ret, alloc_len, rlen, target_port_id, target_dev_id, port_a;
+
+	alloc_len = ((cmd[6] << 24) + (cmd[7] << 16) + (cmd[8] << 8)
+		     + cmd[9]);
+	if (alloc_len < 4 + 11) {
+		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+			       	0);
+		return check_condition_result;
+	}
+	
+	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_KERNEL);
+	n = 4;
+	/*
+	 * Each host has it's own target port group.
+	 * The asymmetric access state is cycled according to the host_id.
+	 */
+
+	/* Construct target port group descriptors */
+	target_dev_id = ((devip->sdbg_host->shost->host_no + 1) * 2000) +
+			(devip->target * 1000) - 3;
+	port_a = target_dev_id + 1;
+	target_port_id = devip->sdbg_host->shost->host_no + 1;
+	/* We can only support ALUA if the hostno is ignored */
+	if (0 == scsi_debug_vpd_use_hostno) {
+		arr[n++] = target_port_id % 4; /* Asymm access state */
+		arr[n++] = 0x0F; /* claim: all states are supported */
+	} else {
+		arr[n++] = 0x0; /* Optimal path */
+		arr[n++] = 0x08; /* We only have optimal paths */
+	}
+	arr[n++] = (target_port_id >> 8) & 0xff;
+	arr[n++] = target_port_id & 0xff;
+	arr[n++] = 0;   /* Reserved */
+	arr[n++] = 0;   /* Status code */
+	arr[n++] = 0;   /* Vendor unique */
+	arr[n++] = 0x1; /* count. Why not scsi_debug_num_tgts? */
+	arr[n++] = 0;   /* Reserved */
+	arr[n++] = 0;   /* Reserved */
+	arr[n++] = (port_a >> 8) & 0xff;
+	arr[n++] = port_a & 0xff;
+
+	rlen = n - 4;
+	arr[0] = (rlen >> 24) & 0xff;
+	arr[1] = (rlen >> 16) & 0xff;
+	arr[2] = (rlen >> 8) & 0xff;
+	arr[3] = rlen & 0xff;
+
+	if (alloc_len < n) {
+		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+			       	0);
+		kfree(arr);
+		return check_condition_result;
+	}
+	
+	ret = fill_from_dev_buffer(scp, arr,
+				   min(n, SDEBUG_MAX_TGTPGS_ARR_SZ));
+	kfree(arr);
+	return ret;
+}
+
 /* <<Following mode page info copied from ST318451LW>> */
 
 static int resp_err_recov_pg(unsigned char * p, int pcontrol, int target)

--------------080703060506060602040709--
