From: Laurence Oberman <loberman@redhat.com>
Subject: tcm_qla2xxx Add SCSI command jammer/discard capabilty to the
 tcm_qla2xxx module - revision3
Date: Tue, 29 Mar 2016 10:42:38 -0400 (EDT)
Message-ID: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com>
References: <1094927874.25583811.1459257571936.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:49292 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbcC2Omm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2016 10:42:42 -0400
In-Reply-To: <1094927874.25583811.1459257571936.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

Hello Bart,

I have been using this jammer functionality to continue testing the SCSI F/C drivers and recovery for over a year now.
Any chance you would agree to ack this so I can get it in now.
I last posted to the list last March and it was not picked up.

I did look into moving this to upper layers but I find I use it primarily for fiber channel target testing.
Attempting to add this functionality to upper layers led to complexities and this is very solid.

This Patch diff against 4.5

I use target LIO for all my storage array test targets and customer problem resolution here at Red Hat.
This patch resulted from a requirement to mimic behavior of an expensive hardware jammer for a customer.
I have used this for some time with good success to simulate and reproduce latency and slow drain fabric issues and
for testing and validating error handling behavior
 in the Emulex, Qlogic and other F/C drivers.

Works by checking new parameter jam_host if its >= 0 and matches vha->host_no , jamming is enabled when jam_host >=0
If parameter set to -1 (default) no jamming is enabled. 

Tested by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>

diff -Nurp linux-4.5.orig/Documentation/scsi/tcm_qla2xxx.txt linux-4.5/Documentation/scsi/tcm_qla2xxx.txt
--- linux-4.5.orig/Documentation/scsi/tcm_qla2xxx.txt	1969-12-31 19:00:00.000000000 -0500
+++ linux-4.5/Documentation/scsi/tcm_qla2xxx.txt	2016-03-29 10:08:57.455761389 -0400
@@ -0,0 +1,31 @@
+tcm_qla2xxx jammer parameter usage
+----------------------------------
+There is now a new module parameter added to the tcm_qla2xx module
+parm:           jam_host:Host to jam >=0 Enable jammer (int)
+
+Use this parameter to control the discarding of SCSI commands to a selected
+host.
+This may be useful for testing error handling and simulating slow drain
+and other fabric issues.
+
+Any value >=0 that matches a fc_host # will discard the commands for that host.
+Reset back to -1 to stop the jamming.
+
+Enable host 6 to be jammed
+echo 6 > /sys/module/tcm_qla2xxx/parameters/jam_host
+
+Disable jamming on host 6
+echo -1 > /sys/module/tcm_qla2xxx/parameters/jam_host
+
+Usage example script:
+
+#!/bin/bash
+sleep_time=120  ### Time to jam for
+echo 6 >  /sys/module/tcm_qla2xxx/parameters/jam_host
+host=`cat /sys/module/tcm_qla2xxx/parameters/jam_host`
+echo "We start to discard commands on SCSI host $host"
+logger "Jammer started"
+sleep $sleep_time
+echo -1 >  /sys/module/tcm_qla2xxx/parameters/jam_host
+echo "We stopped the jammer"
+logger "Jammer stopped"
diff -Nurp linux-4.5.orig/drivers/scsi/qla2xxx/tcm_qla2xxx.c linux-4.5/drivers/scsi/qla2xxx/tcm_qla2xxx.c
--- linux-4.5.orig/drivers/scsi/qla2xxx/tcm_qla2xxx.c	2016-03-14 00:28:54.000000000 -0400
+++ linux-4.5/drivers/scsi/qla2xxx/tcm_qla2xxx.c	2016-03-29 10:10:09.677298099 -0400
@@ -48,6 +48,10 @@
 #include "qla_target.h"
 #include "tcm_qla2xxx.h"
 
+int jam_host = -1;
+module_param(jam_host, int, 0644);
+MODULE_PARM_DESC(jam_host, "Host to jam >=0 Enable jammer");
+
 static struct workqueue_struct *tcm_qla2xxx_free_wq;
 static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
 
@@ -477,6 +481,11 @@ static int tcm_qla2xxx_handle_cmd(scsi_q
 		return -EINVAL;
 	}
 
+	if (unlikely(vha->host_no == jam_host)) {
+		/* return, and dont run target_submit_cmd,discarding command */
+		return 0;
+	}
+
 	cmd->vha->tgt_counters.qla_core_sbt_cmd++;
 	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
 				cmd->unpacked_lun, data_length, fcp_task_attr,
@@ -1967,6 +1976,7 @@ static void tcm_qla2xxx_deregister_confi
 static int __init tcm_qla2xxx_init(void)
 {
 	int ret;
+	jam_host = -1;
 
 	ret = tcm_qla2xxx_register_configfs();
 	if (ret < 0)


Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

