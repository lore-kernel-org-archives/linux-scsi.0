From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug: illegal blocking memory allocation
Date: Thu, 04 Jan 2007 00:38:22 -0500
Message-ID: <459C92CE.4090709@torque.net>
References: <20070103134907.GV11203@kernel.dk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020606080607050409020207"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39212 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbXADFid (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2007 00:38:33 -0500
In-Reply-To: <20070103134907.GV11203@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020606080607050409020207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> Hi Doug,
> 
> resp_inquiry() does a GFP_KERNEL memory allocation, but it's not allowed
> to from the queuecommand context. There's no good way to return this
> error, so I used DID_ERROR which is used from similar paths. That
> doesn't seem quite right though, it would be better to return an error
> indicating a later retry would be more appropriate.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 30ee3d7..0c80ed3 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -954,7 +954,9 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
>  	int alloc_len, n, ret;
>  
>  	alloc_len = (cmd[3] << 8) + cmd[4];
> -	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_KERNEL);
> +	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
> +	if (!arr)
> +		return DID_ERROR << 16;
>  	if (devip->wlun)
>  		pq_pdt = 0x1e;	/* present, wlun */
>  	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
> 

Jens,
I had to read that twice. I'm always happy to convert a
GFP_KERNEL to a GFP_ATOMIC (as I'm sure it started as a
GFP_ATOMIC). There are a couple more that may be in
queuecommand context.

Taking up your point about retries and seeing that the
scsi_debug driver has a SAS flavour, I'm inclined towards
a "aborted command, initiator response timeout" [Bh,4Bh,6]
CHECK CONDITION. There is a group of transport injected
error messages in SAS (see sas2r07.pdf section 10.2.3)
that pop up from time to time. Due to conjestion in
connection-switched SAS expanders these error messages
should be interpreted as "try again" depending on the
topology. The patch below adds a "aborted_command" bit
in opts that will cause every nth command to be aborted
(with an ack/nak timeout).

Note that SAS has an optional "transport layer retries"
state machine to lessen the incidence of "aborted commands".
Evidently SAS tape drives use the facility.

Doug Gilbert

--------------020606080607050409020207
Content-Type: text/plain;
 name="sdebug_lk2620rc3abo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug_lk2620rc3abo"

--- linux/drivers/scsi/scsi_debug.c	2006-11-30 10:00:01.000000000 -0500
+++ linux/drivers/scsi/scsi_debug.c2620rc3abo	2007-01-04 00:19:49.000000000 -0500
@@ -51,10 +51,10 @@
 #include "scsi_logging.h"
 #include "scsi_debug.h"
 
-#define SCSI_DEBUG_VERSION "1.80"
-static const char * scsi_debug_version_date = "20061018";
+#define SCSI_DEBUG_VERSION "1.81"
+static const char * scsi_debug_version_date = "20070104";
 
-/* Additional Sense Code (ASC) used */
+/* Additional Sense Code (ASC) */
 #define NO_ADDITIONAL_SENSE 0x0
 #define LOGICAL_UNIT_NOT_READY 0x4
 #define UNRECOVERED_READ_ERR 0x11
@@ -65,9 +65,14 @@
 #define INVALID_FIELD_IN_PARAM_LIST 0x26
 #define POWERON_RESET 0x29
 #define SAVING_PARAMS_UNSUP 0x39
+#define TRANSPORT_PROBLEM 0x4b
 #define THRESHOLD_EXCEEDED 0x5d
 #define LOW_POWER_COND_ON 0x5e
 
+/* Additional Sense Code Qualifier (ASCQ) */
+#define ACK_NAK_TO 0x3
+#define INIT_RESPONSE_TO 0x6
+
 #define SDEBUG_TAGGED_QUEUING 0 /* 0 | MSG_SIMPLE_TAG | MSG_ORDERED_TAG */
 
 /* Default values for driver parameters */
@@ -95,15 +100,20 @@
 #define SCSI_DEBUG_OPT_MEDIUM_ERR   2
 #define SCSI_DEBUG_OPT_TIMEOUT   4
 #define SCSI_DEBUG_OPT_RECOVERED_ERR   8
+#define SCSI_DEBUG_OPT_TRANSPORT_ERR   16
 /* When "every_nth" > 0 then modulo "every_nth" commands:
  *   - a no response is simulated if SCSI_DEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
  *     commands if SCSI_DEBUG_OPT_RECOVERED_ERR is set.
+ *   - a TRANSPORT_ERROR is simulated on successful read and write
+ *     commands if SCSI_DEBUG_OPT_TRANSPORT_ERR is set.
  *
  * When "every_nth" < 0 then after "- every_nth" commands:
  *   - a no response is simulated if SCSI_DEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
  *     commands if SCSI_DEBUG_OPT_RECOVERED_ERR is set.
+ *   - a TRANSPORT_ERROR is simulated on successful read and write
+ *     commands if SCSI_DEBUG_OPT_TRANSPORT_ERR is set.
  * This will continue until some other action occurs (e.g. the user
  * writing a new value (other than -1 or 1) to every_nth via sysfs).
  */
@@ -315,6 +325,7 @@
 	int target = SCpnt->device->id;
 	struct sdebug_dev_info * devip = NULL;
 	int inj_recovered = 0;
+	int inj_transport = 0;
 	int delay_override = 0;
 
 	if (done == NULL)
@@ -352,6 +363,8 @@
 			return 0; /* ignore command causing timeout */
 		else if (SCSI_DEBUG_OPT_RECOVERED_ERR & scsi_debug_opts)
 			inj_recovered = 1; /* to reads and writes below */
+		else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & scsi_debug_opts)
+			inj_transport = 1; /* to reads and writes below */
         }
 
 	if (devip->wlun) {
@@ -468,7 +481,11 @@
 			mk_sense_buffer(devip, RECOVERED_ERROR,
 					THRESHOLD_EXCEEDED, 0);
 			errsts = check_condition_result;
-		}
+		} else if (inj_transport && (0 == errsts)) {
+                        mk_sense_buffer(devip, ABORTED_COMMAND,
+                                        TRANSPORT_PROBLEM, ACK_NAK_TO);
+                        errsts = check_condition_result;
+                }
 		break;
 	case REPORT_LUNS:	/* mandatory, ignore unit attention */
 		delay_override = 1;
@@ -531,6 +548,9 @@
 		delay_override = 1;
 		errsts = check_readiness(SCpnt, 0, devip);
 		break;
+	case WRITE_BUFFER:
+		errsts = check_readiness(SCpnt, 1, devip);
+		break;
 	default:
 		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
 			printk(KERN_INFO "scsi_debug: Opcode: 0x%x not "
@@ -954,7 +974,12 @@
 	int alloc_len, n, ret;
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
-	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_KERNEL);
+	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
+	if (NULL == arr) {
+		mk_sense_buffer(devip, ABORTED_COMMAND, TRANSPORT_PROBLEM,
+			       	INIT_RESPONSE_TO);
+		return check_condition_result;
+	}
 	if (devip->wlun)
 		pq_pdt = 0x1e;	/* present, wlun */
 	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
@@ -1217,7 +1242,12 @@
 	alen = ((cmd[6] << 24) + (cmd[7] << 16) + (cmd[8] << 8)
 		+ cmd[9]);
 
-	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_KERNEL);
+	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_ATOMIC);
+	if (NULL == arr) {
+		mk_sense_buffer(devip, ABORTED_COMMAND, TRANSPORT_PROBLEM,
+			       	INIT_RESPONSE_TO);
+		return check_condition_result;
+	}
 	/*
 	 * EVPD page 0x88 states we have two ports, one
 	 * real and a fake port with no device connected.
@@ -2044,7 +2074,7 @@
 		}
 	}
 	if (NULL == open_devip) { /* try and make a new one */
-		open_devip = kzalloc(sizeof(*open_devip),GFP_KERNEL);
+		open_devip = kzalloc(sizeof(*open_devip),GFP_ATOMIC);
 		if (NULL == open_devip) {
 			printk(KERN_ERR "%s: out of memory at line %d\n",
 				__FUNCTION__, __LINE__);
@@ -2388,7 +2418,7 @@
 MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
 MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
-MODULE_PARM_DESC(opts, "1->noise, 2->medium_error, 4->... (def=0)");
+MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err... (def=0)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=5[SPC-3])");
 MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
@@ -2943,7 +2973,6 @@
         struct list_head *lh, *lh_sf;
 
         sdbg_host = kzalloc(sizeof(*sdbg_host),GFP_KERNEL);
-
         if (NULL == sdbg_host) {
                 printk(KERN_ERR "%s: out of memory at line %d\n",
                        __FUNCTION__, __LINE__);

--------------020606080607050409020207--
