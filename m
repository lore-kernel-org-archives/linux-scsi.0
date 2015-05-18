From: Laurence Oberman <loberman@redhat.com>
Subject: Re: Resend: [PATCH ] qla2xxx  Add SCSI command jammer/discard
 capabilty to the qla2xxx target module - revision3
Date: Mon, 18 May 2015 08:50:20 -0400 (EDT)
Message-ID: <1759072002.315724.1431953420120.JavaMail.zimbra@redhat.com>
References: <1069288785.13490592.1425785175883.JavaMail.zimbra@redhat.com> <54FC03FA.6000005@sandisk.com> <629323685.13531146.1425829095558.JavaMail.zimbra@redhat.com> <5EE87F5E6631894E80EB1A63198F964D042063ED@SACMBXIP03.sdcorp.global.sandisk.com> <470996009.15920557.1426212837794.JavaMail.zimbra@redhat.com> <1031303023.4832565.1427726187331.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:32787 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbbERMu4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2015 08:50:56 -0400
In-Reply-To: <1031303023.4832565.1427726187331.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, Quinn Tran <quinn.tran@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Laurence Oberman <oberman.l@gmail.com>

Quinn Tran

Any interest in getting this pulled in.
Revision3 has been in use at customers and in our lab for some time now with no issues.

Revision3
Moved the discard to the __qlt_do_work code to prevent the memory leak, this cleans up the allocations.
I will look at seeing how best this can be done for the other transports, or in the core but for me the most useful case has been F/C.
I wanted to get feedback so far, and suggest that we should start with this as the initial jamming patch as its the least risky change for now.
I did test this and ran the same set of tests I normally use this error injection for and it looks good.


Patch notes
-----------
I use target LIO for all my storage array test targets and customer problem resolution here at Red Hat.
This patch resulted from a requirement to mimic behaviour of an expensive hardware jammer for a customer.
I have used this for some time with good success to simulate and reproduce latency and slow drain fabric issues and
for testing and validating error handling behaviour in the Emulex, Qlogic and other F/C drivers.
While the jammer is enabled SCSI commands are discarded for the selected host and this allows all the multipath error recovery and other
LLD driver error recovery and timeout code to be debugged and tested.

Works by checking new parameter jam_host if its >= 0 and matches vha->host_no , jamming is enabled when jam_host >=0
If parameter set to -1 (default) no jamming is enabled.
I decided to share the patch, in the hope it may be useful for others but I do understand this is a special use case.

Tested by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>

diff -Nurp a/Documentation/scsi/qla2xxx.txt b/Documentation/scsi/qla2xxx.txt
--- a/Documentation/scsi/qla2xxx.txt	1969-12-31 19:00:00.000000000 -0500
+++ b/Documentation/scsi/qla2xxx.txt	2015-03-12 21:42:49.828788582 -0400
@@ -0,0 +1,34 @@
+qla2xxx target mode parameters
+------------------------------
+parm:           qlini_mode:Determines when initiator mode will be enabled. Possible values: "exclusive" - initiator mode will be enabled on load, disabled on enabling target mode and then on disabling target mode enabled back; "disabled" - initiator mode will never be enabled; "enabled" (default) - initiator mode will always stay enabled. (charp)
+
+Enables qla2xxx target mode by setting to disabled on module load
+
+There is now a new module parameter added to the qla2xxx module
+parm:           jam_host:Host to jam >=0 Enable jammer (int)
+
+Use this parameter to control the discarding of SCSI commands to a selected host.
+This may be useful for testing error handling and simulating slow drain and other
+fabric issues.
+
+Any value >=0 that matches a fc_host # will discard the commands for that host.
+Reset back to -1 to stop the jamming.
+
+Enable host 6 to be jammed
+echo 6 > /sys/module/qla2xxx/parameters/jam_host
+
+Disable jamming on host 6
+echo -1 > /sys/module/qla2xxx/parameters/jam_host
+
+Usage example script:
+
+#!/bin/bash
+sleep_time=120  ### Time to jam for
+echo 6 >  /sys/module/qla2xxx/parameters/jam_host
+host=`cat /sys/module/qla2xxx/parameters/jam_host`
+echo "We start to discard commands on SCSI host $host"
+logger "Jammer started"
+sleep $sleep_time
+echo -1 >  /sys/module/qla2xxx/parameters/jam_host
+echo "We stopped the jammer"
+logger "Jammer stopped"

diff -Nurp a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
--- a/drivers/scsi/qla2xxx/qla_target.c	2015-03-12 21:44:04.691314527 -0400
+++ b/drivers/scsi/qla2xxx/qla_target.c	2015-03-12 21:52:27.551557133 -0400
@@ -59,6 +59,11 @@ MODULE_PARM_DESC(qlini_mode,
 
 int ql2x_ini_mode = QLA2XXX_INI_MODE_EXCLUSIVE;
 
+int jam_host = -1;
+module_param(jam_host, int, 0644);
+MODULE_PARM_DESC(jam_host, "Host to jam >=0 Enable jammer");
+
+
 static int temp_sam_status = SAM_STAT_BUSY;
 
 /*
@@ -3264,6 +3269,11 @@ static void __qlt_do_work(struct qla_tgt
 	cmd->cmd_flags |= BIT_1;
 	if (tgt->tgt_stop)
 		goto out_term;
+	/*
+	* If jam_host >=0, goto out_term discarding command for matching host
+	*/
+	if (unlikely(vha->host_no == jam_host))
+		goto out_term;
 
 	cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
 	cmd->tag = atio->u.isp24.exchange_addr;


Laurence Oberman
Red Hat Global Support Service
SEG Team

