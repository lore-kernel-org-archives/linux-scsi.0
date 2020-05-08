Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E250FC38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E48218AC
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgEHRXy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:23:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727934AbgEHRXv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:23:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048H4F8g149939;
        Fri, 8 May 2020 13:23:46 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30vtw5umas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 13:23:46 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 048H57K0000345;
        Fri, 8 May 2020 17:23:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 30s0g5dnem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 17:23:44 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 048HNfTB53411908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 May 2020 17:23:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EBED42049;
        Fri,  8 May 2020 17:23:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2315942045;
        Fri,  8 May 2020 17:23:41 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.54.185])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 May 2020 17:23:41 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jX6iq-002wry-8Q; Fri, 08 May 2020 19:23:40 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 8/8] zfcp: move allocation of the shost object to after xconf- and xport-data
Date:   Fri,  8 May 2020 19:23:35 +0200
Message-Id: <030dd6da318bbb529f0b5268ec65cebcd20fc0a3.1588956679.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588956679.git.bblock@linux.ibm.com>
References: <cover.1588956679.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_15:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=2 adultscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080142
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

At the moment we allocate and register the Scsi_Host object
corresponding to a zfcp adapter (FCP device) very early in the life
cycle of the adapter - even before we fully discover and initialize the
underlying firmware/hardware. This had the advantage that we could
already use the Scsi_Host object, and fill in all its information during
said discover and initialize.

Due to
commit 737eb78e82d5 ("block: Delay default elevator initialization")
(first released in v5.4), we noticed a regression that would prevent us
from using any storage volume if zfcp is configured with support for DIF
or DIX (zfcp.dif=1 || zfcp.dix=1). Doing so would result in an illegal
memory access as soon as the first request is sent with such an
configuration. As example for a crash resulting from this:

  scsi host0: scsi_eh_0: sleeping
  scsi host0: zfcp
  qdio: 0.0.1900 ZFCP on SC 4bd using AI:1 QEBSM:0 PRI:1 TDD:1 SIGA: W AP
  scsi 0:0:0:0: scsi scan: INQUIRY pass 1 length 36
  Unable to handle kernel pointer dereference in virtual kernel address space
  Failing address: 0000000000000000 TEID: 0000000000000483
  Fault in home space mode while using kernel ASCE.
  AS:0000000035c7c007 R3:00000001effcc007 S:00000001effd1000 P:000000000000003d
  Oops: 0004 ilc:3 [#1] PREEMPT SMP DEBUG_PAGEALLOC
  Modules linked in: ...
  CPU: 1 PID: 783 Comm: kworker/u760:5 Kdump: loaded Not tainted 5.6.0-rc2-bb-next+ #1
  Hardware name: ...
  Workqueue: scsi_wq_0 fc_scsi_scan_rport [scsi_transport_fc]
  Krnl PSW : 0704e00180000000 000003ff801fcdae (scsi_queue_rq+0x436/0x740 [scsi_mod])
             R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
  Krnl GPRS: 0fffffffffffffff 0000000000000000 0000000187150120 0000000000000000
             000003ff80223d20 000000000000018e 000000018adc6400 0000000187711000
             000003e0062337e8 00000001ae719000 0000000187711000 0000000187150000
             00000001ab808100 0000000187150120 000003ff801fcd74 000003e0062336a0
  Krnl Code: 000003ff801fcd9e: e310a35c0012        lt      %r1,860(%r10)
             000003ff801fcda4: a7840010           brc     8,000003ff801fcdc4
            #000003ff801fcda8: e310b2900004       lg      %r1,656(%r11)
            >000003ff801fcdae: d71710001000       xc      0(24,%r1),0(%r1)
             000003ff801fcdb4: e310b2900004       lg      %r1,656(%r11)
             000003ff801fcdba: 41201018           la      %r2,24(%r1)
             000003ff801fcdbe: e32010000024       stg     %r2,0(%r1)
             000003ff801fcdc4: b904002b           lgr     %r2,%r11
  Call Trace:
   [<000003ff801fcdae>] scsi_queue_rq+0x436/0x740 [scsi_mod]
  ([<000003ff801fcd74>] scsi_queue_rq+0x3fc/0x740 [scsi_mod])
   [<00000000349c9970>] blk_mq_dispatch_rq_list+0x390/0x680
   [<00000000349d1596>] blk_mq_sched_dispatch_requests+0x196/0x1a8
   [<00000000349c7a04>] __blk_mq_run_hw_queue+0x144/0x160
   [<00000000349c7ab6>] __blk_mq_delay_run_hw_queue+0x96/0x228
   [<00000000349c7d5a>] blk_mq_run_hw_queue+0xd2/0xe0
   [<00000000349d194a>] blk_mq_sched_insert_request+0x192/0x1d8
   [<00000000349c17b8>] blk_execute_rq_nowait+0x80/0x90
   [<00000000349c1856>] blk_execute_rq+0x6e/0xb0
   [<000003ff801f8ac2>] __scsi_execute+0xe2/0x1f0 [scsi_mod]
   [<000003ff801fef98>] scsi_probe_and_add_lun+0x358/0x840 [scsi_mod]
   [<000003ff8020001c>] __scsi_scan_target+0xc4/0x228 [scsi_mod]
   [<000003ff80200254>] scsi_scan_target+0xd4/0x100 [scsi_mod]
   [<000003ff802d8b96>] fc_scsi_scan_rport+0x96/0xc0 [scsi_transport_fc]
   [<0000000034245ce8>] process_one_work+0x458/0x7d0
   [<00000000342462a2>] worker_thread+0x242/0x448
   [<0000000034250994>] kthread+0x15c/0x170
   [<0000000034e1979c>] ret_from_fork+0x30/0x38
  INFO: lockdep is turned off.
  Last Breaking-Event-Address:
   [<000003ff801fbc36>] scsi_add_cmd_to_list+0x9e/0xa8 [scsi_mod]
  Kernel panic - not syncing: Fatal exception: panic_on_oops

While this issue is exposed by the commit named above, this is only by
accident. The real issue exists for longer already - basically since it's
possible to use blk-mq via scsi-mq, and blk-mq pre-allocates all
requests for a tag-set during initialization of the same. For a given
Scsi_Host object this is done when adding the object to the midlayer
(`scsi_add_host()` and such). In `scsi_mq_setup_tags()` the midlayer
calculates how much memory is required for a single scsi_cmnd, and its
additional data, which also might include space for additional
protection data - depending on whether the Scsi_Host has any form of
protection capabilities (`scsi_host_get_prot()`).

The problem is now thus, because zfcp does this step before we actually
know whether the firmware/hardware has these capabilities, we don't set
any protection capabilities in the Scsi_Host object. And so, no space is
allocated for additional protection data for requests in the Scsi_Host
tag-set.

Once we go through discover and initialize the FCP device
firmware/hardware fully (this is done via the firmware commands
"Exchange Config Data" and "Exchange Port Data") we find out whether it
actually supports DIF and DIX, and we set the corresponding capabilities
in the Scsi_Host object (in `zfcp_scsi_set_prot()`). Now the Scsi_Host
potentially has protection capabilities, but the already allocated
requests in the tag-set don't have any space allocated for that.

When we then trigger target scanning or add scsi_devices manually, the
midlayer will use requests from that tag-set, and before sending most
requests, it will also call `scsi_mq_prep_fn()`. To prepare the
scsi_cmnd this function will check again whether the used Scsi_Host has
any protection capabilities - and now it potentially has - and if so, it
will try to initialize the assumed to be preallocated structures and
thus it causes the crash, like shown above.

Before delaying the default elevator initialization with the commit
named above, we always would also allocate an elevator for any
scsi_device before ever sending any requests - in contrast to now, where
we do it after device-probing. That elevator in turn would have its own
tag-set, and that is initialized after we went through discovery and
initialization of the underlying firmware/hardware. So requests from
that tag-set can be allocated properly, and if used - unless the user
changes/disabled the default elevator - this would hide the underlying
issue.

To fix this for any configuration - with or without an elevator - we
move the allocation and registration of the Scsi_Host object for a given
FCP device to after the first complete discovery and initialization of
the underlying firmware/hardware. By doing that we can make all basic
properties of the Scsi_Host known to the midlayer by the time we call
`scsi_add_host()`, including whether we have any protection
capabilities.

To do that we have to delay all the accesses that we would have done in
the past during discovery and initialization, and do them instead once
we are finished with it. The previous patches ramp up to this by fencing
and factoring out all these accesses, and make it possible to re-do them
later on. In addition we make also use of the diagnostic buffers we
recently added with
commit 92953c6e0aa7 ("scsi: zfcp: signal incomplete or error for sync exchange config/port data")
commit 7e418833e689 ("scsi: zfcp: diagnostics buffer caching and use for exchange port data")
commit 088210233e6f ("scsi: zfcp: add diagnostics buffer for exchange config data")
(first released in v5.5), because these already cache all the
information we need for that "re-do operation" - the information cached
are always updated during xconf or xport data, so it won't be stale.

In addition to the move and re-do, this patch also updates the
function-documentation of `zfcp_scsi_adapter_register()` and changes how
it reports if a Scsi_Host object already exists. In that case future
recovery-operations can skip this step completely and behave much like
they would do in the past - zfcp does not release a once allocated
Scsi_Host object unless the corresponding FCP device is deconstructed
completely.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |  5 ++-
 drivers/s390/scsi/zfcp_diag.h |  6 ++--
 drivers/s390/scsi/zfcp_erp.c  | 58 +++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_ext.h  |  1 +
 drivers/s390/scsi/zfcp_fsf.c  |  2 +-
 drivers/s390/scsi/zfcp_scsi.c | 40 ++++++++++++++++++------
 6 files changed, 96 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 09ec846fe01d..18b713a616de 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -4,7 +4,7 @@
  *
  * Module interface and handling of zfcp data structures.
  *
- * Copyright IBM Corp. 2002, 2018
+ * Copyright IBM Corp. 2002, 2020
  */
 
 /*
@@ -415,8 +415,7 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 
 	adapter->stat_read_buf_num = FSF_STATUS_READS_RECOM;
 
-	if (!zfcp_scsi_adapter_register(adapter))
-		return adapter;
+	return adapter;
 
 failed:
 	zfcp_adapter_unregister(adapter);
diff --git a/drivers/s390/scsi/zfcp_diag.h b/drivers/s390/scsi/zfcp_diag.h
index b9c93d15f67c..3852367f15f6 100644
--- a/drivers/s390/scsi/zfcp_diag.h
+++ b/drivers/s390/scsi/zfcp_diag.h
@@ -4,7 +4,7 @@
  *
  * Definitions for handling diagnostics in the the zfcp device driver.
  *
- * Copyright IBM Corp. 2018
+ * Copyright IBM Corp. 2018, 2020
  */
 
 #ifndef ZFCP_DIAG_H
@@ -56,11 +56,11 @@ struct zfcp_diag_adapter {
 
 	unsigned long	max_age;
 
-	struct {
+	struct zfcp_diag_adapter_port_data {
 		struct zfcp_diag_header		header;
 		struct fsf_qtcb_bottom_port	data;
 	} port_data;
-	struct {
+	struct zfcp_diag_adapter_config_data {
 		struct zfcp_diag_header		header;
 		struct fsf_qtcb_bottom_config	data;
 	} config_data;
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 283bcb985655..db320dab1fee 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -14,6 +14,7 @@
 #include <linux/bug.h>
 #include "zfcp_ext.h"
 #include "zfcp_reqlist.h"
+#include "zfcp_diag.h"
 
 #define ZFCP_MAX_ERPS                   3
 
@@ -804,6 +805,59 @@ static enum zfcp_erp_act_result zfcp_erp_adapter_strategy_open_fsf_xport(
 	return ZFCP_ERP_SUCCEEDED;
 }
 
+static enum zfcp_erp_act_result
+zfcp_erp_adapter_strategy_alloc_shost(struct zfcp_adapter *const adapter)
+{
+	struct zfcp_diag_adapter_config_data *const config_data =
+		&adapter->diagnostics->config_data;
+	struct zfcp_diag_adapter_port_data *const port_data =
+		&adapter->diagnostics->port_data;
+	unsigned long flags;
+	int rc;
+
+	rc = zfcp_scsi_adapter_register(adapter);
+	if (rc == -EEXIST)
+		return ZFCP_ERP_SUCCEEDED;
+	else if (rc)
+		return ZFCP_ERP_FAILED;
+
+	/*
+	 * We allocated the shost for the first time. Before it was NULL,
+	 * and so we deferred all updates in the xconf- and xport-data
+	 * handlers. We need to make up for that now, and make all the updates
+	 * that would have been done before.
+	 *
+	 * We can be sure that xconf- and xport-data succeeded, because
+	 * otherwise this function is not called. But they might have been
+	 * incomplete.
+	 */
+
+	spin_lock_irqsave(&config_data->header.access_lock, flags);
+	zfcp_scsi_shost_update_config_data(adapter, &config_data->data,
+					   !!config_data->header.incomplete);
+	spin_unlock_irqrestore(&config_data->header.access_lock, flags);
+
+	if (adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT) {
+		spin_lock_irqsave(&port_data->header.access_lock, flags);
+		zfcp_scsi_shost_update_port_data(adapter, &port_data->data);
+		spin_unlock_irqrestore(&port_data->header.access_lock, flags);
+	}
+
+	/*
+	 * There is a remote possibility that the 'Exchange Port Data' request
+	 * reports a different connectivity status than 'Exchange Config Data'.
+	 * But any change to the connectivity status of the local optic that
+	 * happens after the initial xconf request is expected to be reported
+	 * to us, as soon as we post Status Read Buffers to the FCP channel
+	 * firmware after this function. So any resulting inconsistency will
+	 * only be momentary.
+	 */
+	if (config_data->header.incomplete)
+		zfcp_fsf_fc_host_link_down(adapter);
+
+	return ZFCP_ERP_SUCCEEDED;
+}
+
 static enum zfcp_erp_act_result zfcp_erp_adapter_strategy_open_fsf(
 	struct zfcp_erp_action *act)
 {
@@ -813,6 +867,10 @@ static enum zfcp_erp_act_result zfcp_erp_adapter_strategy_open_fsf(
 	if (zfcp_erp_adapter_strategy_open_fsf_xport(act) == ZFCP_ERP_FAILED)
 		return ZFCP_ERP_FAILED;
 
+	if (zfcp_erp_adapter_strategy_alloc_shost(act->adapter) ==
+	    ZFCP_ERP_FAILED)
+		return ZFCP_ERP_FAILED;
+
 	zfcp_erp_adapter_strategy_open_ptp_port(act->adapter);
 
 	if (mempool_resize(act->adapter->pool.sr_data,
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 5dc9bdc5803f..3ef5d74331c3 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -135,6 +135,7 @@ extern int zfcp_fsf_send_els(struct zfcp_adapter *, u32,
 			     struct zfcp_fsf_ct_els *, unsigned int);
 extern int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
+extern void zfcp_fsf_fc_host_link_down(struct zfcp_adapter *adapter);
 extern struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_device *sdev,
 						   u8 tm_flags);
 extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 8c4b690e329e..c795f22249d8 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -120,7 +120,7 @@ static void zfcp_fsf_status_read_port_closed(struct zfcp_fsf_req *req)
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
 
-static void zfcp_fsf_fc_host_link_down(struct zfcp_adapter *adapter)
+void zfcp_fsf_fc_host_link_down(struct zfcp_adapter *adapter)
 {
 	struct Scsi_Host *shost = adapter->scsi_host;
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index f98e4015a0ed..d58bf79892f2 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -451,26 +451,39 @@ static struct scsi_host_template zfcp_scsi_host_template = {
 };
 
 /**
- * zfcp_scsi_adapter_register - Register SCSI and FC host with SCSI midlayer
+ * zfcp_scsi_adapter_register() - Allocate and register SCSI and FC host with
+ *				  SCSI midlayer
  * @adapter: The zfcp adapter to register with the SCSI midlayer
+ *
+ * Allocates the SCSI host object for the given adapter, sets basic properties
+ * (such as the transport template, QDIO limits, ...), and registers it with
+ * the midlayer.
+ *
+ * During registration with the midlayer the corresponding FC host object for
+ * the referenced transport class is also implicitely allocated.
+ *
+ * Upon success adapter->scsi_host is set, and upon failure it remains NULL. If
+ * adapter->scsi_host is already set, nothing is done.
+ *
+ * Return:
+ * * 0	     - Allocation and registration was successful
+ * * -EEXIST - SCSI and FC host did already exist, nothing was done, nothing
+ *	       was changed
+ * * -EIO    - Allocation or registration failed
  */
 int zfcp_scsi_adapter_register(struct zfcp_adapter *adapter)
 {
 	struct ccw_dev_id dev_id;
 
 	if (adapter->scsi_host)
-		return 0;
+		return -EEXIST;
 
 	ccw_device_get_id(adapter->ccw_device, &dev_id);
 	/* register adapter as SCSI host with mid layer of SCSI stack */
 	adapter->scsi_host = scsi_host_alloc(&zfcp_scsi_host_template,
 					     sizeof (struct zfcp_adapter *));
-	if (!adapter->scsi_host) {
-		dev_err(&adapter->ccw_device->dev,
-			"Registering the FCP device with the "
-			"SCSI stack failed\n");
-		return -EIO;
-	}
+	if (!adapter->scsi_host)
+		goto err_out;
 
 	/* tell the SCSI stack some characteristics of this adapter */
 	adapter->scsi_host->max_id = 511;
@@ -480,14 +493,23 @@ int zfcp_scsi_adapter_register(struct zfcp_adapter *adapter)
 	adapter->scsi_host->max_cmd_len = 16; /* in struct fcp_cmnd */
 	adapter->scsi_host->transportt = zfcp_scsi_transport_template;
 
+	/* make all basic properties known at registration time */
+	zfcp_qdio_shost_update(adapter, adapter->qdio);
+	zfcp_scsi_set_prot(adapter);
+
 	adapter->scsi_host->hostdata[0] = (unsigned long) adapter;
 
 	if (scsi_add_host(adapter->scsi_host, &adapter->ccw_device->dev)) {
 		scsi_host_put(adapter->scsi_host);
-		return -EIO;
+		goto err_out;
 	}
 
 	return 0;
+err_out:
+	adapter->scsi_host = NULL;
+	dev_err(&adapter->ccw_device->dev,
+		"Registering the FCP device with the SCSI stack failed\n");
+	return -EIO;
 }
 
 /**
-- 
2.17.1

