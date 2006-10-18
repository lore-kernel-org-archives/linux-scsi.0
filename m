From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] ALUA support for scsi_debug
Date: Wed, 18 Oct 2006 16:50:18 +0200
Message-ID: <20061018145018.GC25084@pentland.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:42975 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1161055AbWJROuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 10:50:19 -0400
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 5E19011DC4
	for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 16:50:18 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi all,

I've hacked up scsi_debug to support REPORT TARGET PORT GROUPS.
In combination with vpd_use_hostno=0 it'll now support multipathing
nicely.
Doug, there is reference to port_a and port_b in the VPD page support.
However, port_b appearently is just a fake entry with no (virtual)
device backing.
We could eg use the 'channel' value to refer the relative port number,
so that host & channel act as a fan-out for multipathing.

James, please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra�e 5				+49 911 74053 688
90409 N�rnberg				http://www.suse.de

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=scsi_debug_alua_support

scsi_debug: support REPORT TARGET PORT GROUPS

This patch adds support for REPORT TARGET PORT GROUPS. This is used
eg for the multipathing priority callout to determine the path
priority.
With this patch multipath-tools can use the existing mpath_prio_alua
callout to exercise the path priority grouping.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9c0f358..e8c72ea 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -254,6 +254,8 @@ static int resp_requests(struct scsi_cmn
 			 struct sdebug_dev_info * devip);
 static int resp_start_stop(struct scsi_cmnd * scp,
 			   struct sdebug_dev_info * devip);
+static int resp_report_tgtpgs(struct scsi_cmnd * scp,
+			      struct sdebug_dev_info * devip);
 static int resp_readcap(struct scsi_cmnd * SCpnt,
 			struct sdebug_dev_info * devip);
 static int resp_readcap16(struct scsi_cmnd * SCpnt,
@@ -287,9 +289,9 @@ static void __init sdebug_build_parts(un
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
@@ -422,6 +424,15 @@ int scsi_debug_queuecommand(struct scsi_
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
@@ -665,8 +676,9 @@ static const char * inq_vendor_id = "Lin
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
@@ -707,7 +719,7 @@ static int inquiry_evpd_83(unsigned char
 		arr[num++] = 0x0;
 		arr[num++] = 0x1;	/* relative port A */
 	}
-	/* NAA-5, Target port identifier */
+	/* NAA-5, Relative Target port identifier */
 	arr[num++] = 0x61;	/* proto=sas, binary */
 	arr[num++] = 0x93;	/* piv=1, target port, naa */
 	arr[num++] = 0x0;
@@ -720,6 +732,15 @@ static int inquiry_evpd_83(unsigned char
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
@@ -946,10 +967,11 @@ static int resp_inquiry(struct scsi_cmnd
 			       	0);
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
@@ -977,8 +999,9 @@ static int resp_inquiry(struct scsi_cmnd
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
@@ -1023,6 +1046,8 @@ static int resp_inquiry(struct scsi_cmnd
 	arr[2] = scsi_debug_scsi_level;
 	arr[3] = 2;    /* response_data_format==2 */
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
+	if (0 == scsi_debug_vpd_use_hostno)
+		arr[5] = 0x10; /* claim: implicit TGPS */
 	arr[6] = 0x10; /* claim: MultiP */
 	/* arr[6] |= 0x40; ... claim: EncServ (enclosure services) */
 	arr[7] = 0xa; /* claim: LINKED + CMDQUE */
@@ -1171,6 +1196,69 @@ static int resp_readcap16(struct scsi_cm
 				    min(alloc_len, SDEBUG_READCAP16_ARR_SZ));
 }
 
+#define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
+
+static int resp_report_tgtpgs(struct scsi_cmnd * scp,
+			      struct sdebug_dev_info * devip)
+{
+	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char arr[SDEBUG_MAX_TGTPGS_ARR_SZ];
+	int n, alloc_len, target_port_id, target_dev_id, port_a;
+
+	alloc_len = ((cmd[6] << 24) + (cmd[7] << 16) + (cmd[8] << 8)
+		     + cmd[9]);
+	if (alloc_len < 4 + 11) {
+		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+			       	0);
+		return check_condition_result;
+	}
+	
+	memset(arr, 0, SDEBUG_MAX_TGTPGS_ARR_SZ);
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
+	arr[0] = (n >> 24) & 0xff;
+	arr[1] = (n >> 16) & 0xff;
+	arr[2] = (n >> 8) & 0xff;
+	arr[3] = n & 0xff;
+
+	if (alloc_len < n) {
+		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+			       	0);
+		return check_condition_result;
+	}
+	
+	return fill_from_dev_buffer(scp, arr,
+				    min(n, SDEBUG_MAX_TGTPGS_ARR_SZ));
+}
+
 /* <<Following mode page info copied from ST318451LW>> */
 
 static int resp_err_recov_pg(unsigned char * p, int pcontrol, int target)
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 84a6d5f..8a3f0bd 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -97,6 +97,7 @@ #define MODE_SENSE_10         0x5a
 #define PERSISTENT_RESERVE_IN 0x5e
 #define PERSISTENT_RESERVE_OUT 0x5f
 #define REPORT_LUNS           0xa0
+#define MAINTENANCE_IN        0xa3
 #define MOVE_MEDIUM           0xa5
 #define EXCHANGE_MEDIUM       0xa6
 #define READ_12               0xa8
@@ -114,6 +115,8 @@ #define VERIFY_16	      0x8f
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
+/* values for maintenance in */
+#define MI_REPORT_TARGET_PGS  0x0a
 
 /* Values for T10/04-262r7 */
 #define	ATA_16		      0x85	/* 16-byte pass-thru */

--pf9I7BMVVzbSWLtt--
