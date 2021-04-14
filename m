Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4491CC43462
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E2A61168
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbhDNRIk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 13:08:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229696AbhDNRIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 13:08:35 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EH2W3e163457;
        Wed, 14 Apr 2021 13:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=yOJrBkWl8dH+/WJgO7owzCsSPIUt26nTH7Ddi5dliqI=;
 b=O7aP+k4ZkqQEiJUU8ODMt+sV7toGcjXz2CjrxmT+/Gv6p64w/fkDZG1bzz4vkp912wMz
 LG1z984PPNcamnNvJU+Q2xSjz9HvHs9SmRnCGTGjoZmmVo+RAiV8RwU+EROlTN0SDZ9E
 zR1JlrQi7+ys2EXE3YEUbOepzoUFaIbDi16AGggYbH7ZQwy9tUkxeGMxFfnRNFTzJTLF
 ophOs6YMLL8AaGKHYNU3U+2da7cH/G/uIKkZWrOQ7pRQGgizBxIoYno2DbrKfCQJ0gCV
 ob1/y/X+SZBYyJGUZHo0uPtSA3lqFHjmkNFSuwDpUPZVa05shXs2OUy0B5hgtmYfBwpc qg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x0n7qrfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 13:08:10 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13EH7DDF024868;
        Wed, 14 Apr 2021 17:08:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 37u3n89ty8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 17:08:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13EH7ho035717560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 17:07:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 176E8AEBEB;
        Wed, 14 Apr 2021 17:08:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDD15AEBE1;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.18.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lWizk-002b34-Fa; Wed, 14 Apr 2021 19:08:04 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Sumangala Bannur Subraya <bsuma@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 6/6] scsi: zfcp: lift Request Queue tasklet & timer from qdio
Date:   Wed, 14 Apr 2021 19:08:04 +0200
Message-Id: <018d3ddd029f8d6ac00cf4184880288c637c4fd1.1618417667.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618417667.git.bblock@linux.ibm.com>
References: <cover.1618417667.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZyeI5weRt17XQD0mjJlc-OvbrXme1kZd
X-Proofpoint-ORIG-GUID: ZyeI5weRt17XQD0mjJlc-OvbrXme1kZd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_10:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

The qdio layer currently provides its own infrastructure to scan for
Request Queue completions & to report them to the device driver.
This comes with several drawbacks - having an async tasklet & timer
construct in qdio introduces additional lifetime complexity, and makes
it harder to integrate them with the rest of the device driver. The
timeouts are also currently hard-coded, and can't be tweaked without
affecting other qdio drivers (ie. qeth).

But due to recent enhancements to the qdio layer, zfcp can actually take
full control of the Request Queue completion processing. It merely needs
to opt-out from the qdio layer mechanisms by setting the scan_threshold
to 0, and then use qdio_inspect_queue() to scan for completions.

So re-implement the tasklet & timer mechanism in zfcp, while initially
copying the scan conditions from qdio's handle_outbound() and
qdio_outbound_tasklet(). One minor behavioural change is that
zfcp_qdio_send() will unconditionally reduce the timeout to 1 HZ, rather
than leaving it at 10 Hz if it was last armed by the tasklet. This just
makes things more consistent. Also note that we can drop a lot of the
accumulated cruft in qdio_outbound_tasklet(), as zfcp doesn't even use
PCI interrupt requests any longer.

This also slightly touches the Response Queue processing, as
qdio_get_next_buffers() will no longer implicitly scan for Request Queue
completions. So complete the migration to qdio_inspect_queue() here as
well and make the tasklet_schedule() visible.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_qdio.c | 68 ++++++++++++++++++++++++++++-------
 drivers/s390/scsi/zfcp_qdio.h |  5 +++
 2 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 23ab16d65f2a..16a332d501e7 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -20,6 +20,9 @@ static bool enable_multibuffer = true;
 module_param_named(datarouter, enable_multibuffer, bool, 0400);
 MODULE_PARM_DESC(datarouter, "Enable hardware data router support (default on)");
 
+#define ZFCP_QDIO_REQUEST_RESCAN_MSECS	(MSEC_PER_SEC * 10)
+#define ZFCP_QDIO_REQUEST_SCAN_MSECS	MSEC_PER_SEC
+
 static void zfcp_qdio_handler_error(struct zfcp_qdio *qdio, char *dbftag,
 				    unsigned int qdio_err)
 {
@@ -70,15 +73,41 @@ static void zfcp_qdio_int_req(struct ccw_device *cdev, unsigned int qdio_err,
 		zfcp_qdio_handler_error(qdio, "qdireq1", qdio_err);
 		return;
 	}
+}
 
-	/* cleanup all SBALs being program-owned now */
-	zfcp_qdio_zero_sbals(qdio->req_q, idx, count);
+static void zfcp_qdio_request_tasklet(struct tasklet_struct *tasklet)
+{
+	struct zfcp_qdio *qdio = from_tasklet(qdio, tasklet, request_tasklet);
+	struct ccw_device *cdev = qdio->adapter->ccw_device;
+	unsigned int start, error;
+	int completed;
 
-	spin_lock_irq(&qdio->stat_lock);
-	zfcp_qdio_account(qdio);
-	spin_unlock_irq(&qdio->stat_lock);
-	atomic_add(count, &qdio->req_q_free);
-	wake_up(&qdio->req_q_wq);
+	completed = qdio_inspect_queue(cdev, 0, false, &start, &error);
+	if (completed > 0) {
+		if (error) {
+			zfcp_qdio_handler_error(qdio, "qdreqt1", error);
+		} else {
+			/* cleanup all SBALs being program-owned now */
+			zfcp_qdio_zero_sbals(qdio->req_q, start, completed);
+
+			spin_lock_irq(&qdio->stat_lock);
+			zfcp_qdio_account(qdio);
+			spin_unlock_irq(&qdio->stat_lock);
+			atomic_add(completed, &qdio->req_q_free);
+			wake_up(&qdio->req_q_wq);
+		}
+	}
+
+	if (atomic_read(&qdio->req_q_free) < QDIO_MAX_BUFFERS_PER_Q)
+		timer_reduce(&qdio->request_timer,
+			     jiffies + msecs_to_jiffies(ZFCP_QDIO_REQUEST_RESCAN_MSECS));
+}
+
+static void zfcp_qdio_request_timer(struct timer_list *timer)
+{
+	struct zfcp_qdio *qdio = from_timer(qdio, timer, request_timer);
+
+	tasklet_schedule(&qdio->request_tasklet);
 }
 
 static void zfcp_qdio_int_resp(struct ccw_device *cdev, unsigned int qdio_err,
@@ -139,8 +168,11 @@ static void zfcp_qdio_irq_tasklet(struct tasklet_struct *tasklet)
 	unsigned int start, error;
 	int completed;
 
-	/* Check the Response Queue, and kick off the Request Queue tasklet: */
-	completed = qdio_get_next_buffers(cdev, 0, &start, &error);
+	if (atomic_read(&qdio->req_q_free) < QDIO_MAX_BUFFERS_PER_Q)
+		tasklet_schedule(&qdio->request_tasklet);
+
+	/* Check the Response Queue: */
+	completed = qdio_inspect_queue(cdev, 0, true, &start, &error);
 	if (completed < 0)
 		return;
 	if (completed > 0)
@@ -286,7 +318,7 @@ int zfcp_qdio_send(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 
 	/*
 	 * This should actually be a spin_lock_bh(stat_lock), to protect against
-	 * zfcp_qdio_int_req() in tasklet context.
+	 * Request Queue completion processing in tasklet context.
 	 * But we can't do so (and are safe), as we always get called with IRQs
 	 * disabled by spin_lock_irq[save](req_q_lock).
 	 */
@@ -308,6 +340,12 @@ int zfcp_qdio_send(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 		return retval;
 	}
 
+	if (atomic_read(&qdio->req_q_free) <= 2 * ZFCP_QDIO_MAX_SBALS_PER_REQ)
+		tasklet_schedule(&qdio->request_tasklet);
+	else
+		timer_reduce(&qdio->request_timer,
+			     jiffies + msecs_to_jiffies(ZFCP_QDIO_REQUEST_SCAN_MSECS));
+
 	/* account for transferred buffers */
 	qdio->req_q_idx += sbal_number;
 	qdio->req_q_idx %= QDIO_MAX_BUFFERS_PER_Q;
@@ -368,6 +406,8 @@ void zfcp_qdio_close(struct zfcp_qdio *qdio)
 	wake_up(&qdio->req_q_wq);
 
 	tasklet_disable(&qdio->irq_tasklet);
+	tasklet_disable(&qdio->request_tasklet);
+	del_timer_sync(&qdio->request_timer);
 	qdio_stop_irq(adapter->ccw_device);
 	qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR);
 
@@ -428,8 +468,6 @@ int zfcp_qdio_open(struct zfcp_qdio *qdio)
 	init_data.int_parm = (unsigned long) qdio;
 	init_data.input_sbal_addr_array = input_sbals;
 	init_data.output_sbal_addr_array = output_sbals;
-	init_data.scan_threshold =
-		QDIO_MAX_BUFFERS_PER_Q - ZFCP_QDIO_MAX_SBALS_PER_REQ * 2;
 
 	if (qdio_establish(cdev, &init_data))
 		goto failed_establish;
@@ -471,6 +509,8 @@ int zfcp_qdio_open(struct zfcp_qdio *qdio)
 	atomic_set(&qdio->req_q_free, QDIO_MAX_BUFFERS_PER_Q);
 	atomic_or(ZFCP_STATUS_ADAPTER_QDIOUP, &qdio->adapter->status);
 
+	/* Enable processing for Request Queue completions: */
+	tasklet_enable(&qdio->request_tasklet);
 	/* Enable processing for QDIO interrupts: */
 	tasklet_enable(&qdio->irq_tasklet);
 	/* This results in a qdio_start_irq(): */
@@ -494,6 +534,7 @@ void zfcp_qdio_destroy(struct zfcp_qdio *qdio)
 		return;
 
 	tasklet_kill(&qdio->irq_tasklet);
+	tasklet_kill(&qdio->request_tasklet);
 
 	if (qdio->adapter->ccw_device)
 		qdio_free(qdio->adapter->ccw_device);
@@ -520,8 +561,11 @@ int zfcp_qdio_setup(struct zfcp_adapter *adapter)
 
 	spin_lock_init(&qdio->req_q_lock);
 	spin_lock_init(&qdio->stat_lock);
+	timer_setup(&qdio->request_timer, zfcp_qdio_request_timer, 0);
 	tasklet_setup(&qdio->irq_tasklet, zfcp_qdio_irq_tasklet);
+	tasklet_setup(&qdio->request_tasklet, zfcp_qdio_request_tasklet);
 	tasklet_disable(&qdio->irq_tasklet);
+	tasklet_disable(&qdio->request_tasklet);
 
 	adapter->qdio = qdio;
 	return 0;
diff --git a/drivers/s390/scsi/zfcp_qdio.h b/drivers/s390/scsi/zfcp_qdio.h
index 9c1f310db155..390706867df3 100644
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -30,6 +30,9 @@
  * @req_q_util: used for accounting
  * @req_q_full: queue full incidents
  * @req_q_wq: used to wait for SBAL availability
+ * @irq_tasklet: used for QDIO interrupt processing
+ * @request_tasklet: used for Request Queue completion processing
+ * @request_timer: used to trigger the Request Queue completion processing
  * @adapter: adapter used in conjunction with this qdio structure
  * @max_sbale_per_sbal: qdio limit per sbal
  * @max_sbale_per_req: qdio limit per request
@@ -46,6 +49,8 @@ struct zfcp_qdio {
 	atomic_t		req_q_full;
 	wait_queue_head_t	req_q_wq;
 	struct tasklet_struct	irq_tasklet;
+	struct tasklet_struct	request_tasklet;
+	struct timer_list	request_timer;
 	struct zfcp_adapter	*adapter;
 	u16			max_sbale_per_sbal;
 	u16			max_sbale_per_req;
-- 
2.30.2

