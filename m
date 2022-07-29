Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E42C19F2A
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 16:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiG2QZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 12:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiG2QZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 12:25:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949AD18E3D;
        Fri, 29 Jul 2022 09:25:49 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TFp5MM015438;
        Fri, 29 Jul 2022 16:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=RGSF0zWMIA2ncoPI8yG+vnJuEHc8ftjIFB+Fp0+vjMo=;
 b=IpNLN9ph3TE+nnTWJzS9/JDMX35FyvIYKWdgHOo5f3YTcYbrZMf++uEDxGOcZbkkGiWv
 XjmEnABC9B7HTCTp1yI7wE9eLIVVq95cooodGgDHHBJSMFfFui5SHzQWbGhbNlPtmpvK
 qcw6xdpUGsoh0NOCYNFfU9OK+RVUz01ejd1Nk4kJUcJfU83GEUUb5XY7U2aIbNuBQ/j/
 Fd7u45RW2cgXyaZ3s56Ug9SgEZY0ehP388U5gdddOqles3X8Qa1+9zJEbfP3nhwzN26+
 yJIJBZcgjhY+w8Z20Vc1f3kiFyCLaxlkFvCzJfjJeU8U8fzvQEOqm9kwF2JXi0q++4LC SA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmjj9h11t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 16:25:38 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26TG5Mi0016950;
        Fri, 29 Jul 2022 16:25:36 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3hh6euphmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 16:25:36 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26TGNRMh30736702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 16:23:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 127A94C046;
        Fri, 29 Jul 2022 16:25:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B97CE4C040;
        Fri, 29 Jul 2022 16:25:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Jul 2022 16:25:32 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH] zfcp: fix missing auto port scan and thus missing target ports
Date:   Fri, 29 Jul 2022 18:25:29 +0200
Message-Id: <20220729162529.1620730-1-maier@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PIY-AhHIB2lg6MM_0oeZ-P8KTgn6tjvh
X-Proofpoint-GUID: PIY-AhHIB2lg6MM_0oeZ-P8KTgn6tjvh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_17,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207290072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Case (1):
The only waiter on wka_port->completion_wq is zfcp_fc_wka_port_get() trying
to open a WKA port. As such it should only be woken up by WKA port *open*
responses, not by WKA port close responses.

Case (2):
A close WKA port response coming in just after having sent a new open WKA
port request and before blocking for the open response with wait_event() in
zfcp_fc_wka_port_get() erroneously renders the wait_event a NOP because the
close handler overwrites wka_port->status. Hence the wait_event condition
is erroneously true and it does not enter blocking state.

With non-negligible probability, the following time space sequence happens
depending on timing without this fix:

user process        ERP thread zfcp work queue tasklet system work queue
============        ========== =============== ======= =================
$ echo 1 > online
zfcp_ccw_set_online
zfcp_ccw_activate
zfcp_erp_adapter_reopen
msleep scan backoff zfcp_erp_strategy
|                   ...
|                   zfcp_erp_action_cleanup
|                   ...
|                   queue delayed scan_work
|                   queue ns_up_work
|                              ns_up_work:
|                              zfcp_fc_wka_port_get
|                               open wka request
|                                              open response
|                              GSPN FC-GS
|                              RSPN FC-GS [NPIV-only]
|                              zfcp_fc_wka_port_put
|                               (--wka->refcount==0)
|                               sched delayed wka->work
|
~~~Case (1)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
zfcp_erp_wait
flush scan_work
|                                                      wka->work:
|                                                      wka->status=CLOSING
|                                                      close wka request
|                              scan_work:
|                              zfcp_fc_wka_port_get
|                               (wka->status==CLOSING)
|                               wka->status=OPENING
|                               open wka request
|                               wait_event
|                               |              close response
|                               |              wka->status=OFFLINE
|                               |              wake_up /*WRONG*/
~~~Case (2)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|                                                      wka->work:
|                                                      wka->status=CLOSING
|                                                      close wka request
zfcp_erp_wait
flush scan_work
|                              scan_work:
|                              zfcp_fc_wka_port_get
|                               (wka->status==CLOSING)
|                               wka->status=OPENING
|                               open wka request
|                                              close response
|                                              wka->status=OFFLINE
|                                              wake_up /*WRONG&NOP*/
|                               wait_event /*NOP*/
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|                               (wka->status!=ONLINE)
|                               return -EIO
|                              return early
                                               open response
                                               wka->status=ONLINE
                                               wake_up /*NOP*/

So we erroneously end up with no automatic port scan. This is a big problem
when it happens during boot. The timing is influenced by v3.19 commit
18f87a67e6d6 ("zfcp: auto port scan resiliency").

Fix it by fully mutually excluding zfcp_fc_wka_port_get() and
zfcp_fc_wka_port_offline(). For that to work, we make the latter block
until we got the response for a close WKA port. In order not to penalize
the system workqueue, we move wka_port->work to our own adapter workqueue.
Note that before v2.6.30 commit 828bc1212a68 ("[SCSI] zfcp: Set WKA-port to
offline on adapter deactivation"), zfcp did block in
zfcp_fc_wka_port_offline() as well, but with a different condition.

While at it, make non-functional cleanups to improve code reading in
zfcp_fc_wka_port_get(). If we cannot send the WKA port open request, don't
rely on the subsequent wait_event condition to immediately let this case
pass without blocking. Also don't want to rely on the additional condition
handling the refcount to be skipped just to finally return with -EIO.

Fixes: 5ab944f97e09 ("[SCSI] zfcp: attach and release SAN nameserver port on demand")
Cc: <stable@vger.kernel.org> #v2.6.28+
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.c  | 29 ++++++++++++++++++++---------
 drivers/s390/scsi/zfcp_fc.h  |  6 ++++--
 drivers/s390/scsi/zfcp_fsf.c |  4 ++--
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 511bf8e0a436..b61acbb09be3 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -145,27 +145,33 @@ void zfcp_fc_enqueue_event(struct zfcp_adapter *adapter,
 
 static int zfcp_fc_wka_port_get(struct zfcp_fc_wka_port *wka_port)
 {
+	int ret = -EIO;
+
 	if (mutex_lock_interruptible(&wka_port->mutex))
 		return -ERESTARTSYS;
 
 	if (wka_port->status == ZFCP_FC_WKA_PORT_OFFLINE ||
 	    wka_port->status == ZFCP_FC_WKA_PORT_CLOSING) {
 		wka_port->status = ZFCP_FC_WKA_PORT_OPENING;
-		if (zfcp_fsf_open_wka_port(wka_port))
+		if (zfcp_fsf_open_wka_port(wka_port)) {
+			/* could not even send request, nothing to wait for */
 			wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
+			goto out;
+		}
 	}
 
-	mutex_unlock(&wka_port->mutex);
-
-	wait_event(wka_port->completion_wq,
+	wait_event(wka_port->opened,
 		   wka_port->status == ZFCP_FC_WKA_PORT_ONLINE ||
 		   wka_port->status == ZFCP_FC_WKA_PORT_OFFLINE);
 
 	if (wka_port->status == ZFCP_FC_WKA_PORT_ONLINE) {
 		atomic_inc(&wka_port->refcount);
-		return 0;
+		ret = 0;
+		goto out;
 	}
-	return -EIO;
+out:
+	mutex_unlock(&wka_port->mutex);
+	return ret;
 }
 
 static void zfcp_fc_wka_port_offline(struct work_struct *work)
@@ -181,9 +187,12 @@ static void zfcp_fc_wka_port_offline(struct work_struct *work)
 
 	wka_port->status = ZFCP_FC_WKA_PORT_CLOSING;
 	if (zfcp_fsf_close_wka_port(wka_port)) {
+		/* could not even send request, nothing to wait for */
 		wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
-		wake_up(&wka_port->completion_wq);
+		goto out;
 	}
+	wait_event(wka_port->closed,
+		   wka_port->status == ZFCP_FC_WKA_PORT_OFFLINE);
 out:
 	mutex_unlock(&wka_port->mutex);
 }
@@ -193,13 +202,15 @@ static void zfcp_fc_wka_port_put(struct zfcp_fc_wka_port *wka_port)
 	if (atomic_dec_return(&wka_port->refcount) != 0)
 		return;
 	/* wait 10 milliseconds, other reqs might pop in */
-	schedule_delayed_work(&wka_port->work, HZ / 100);
+	queue_delayed_work(wka_port->adapter->work_queue, &wka_port->work,
+			   msecs_to_jiffies(10));
 }
 
 static void zfcp_fc_wka_port_init(struct zfcp_fc_wka_port *wka_port, u32 d_id,
 				  struct zfcp_adapter *adapter)
 {
-	init_waitqueue_head(&wka_port->completion_wq);
+	init_waitqueue_head(&wka_port->opened);
+	init_waitqueue_head(&wka_port->closed);
 
 	wka_port->adapter = adapter;
 	wka_port->d_id = d_id;
diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
index 8aaf409ce9cb..97755407ce1b 100644
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -185,7 +185,8 @@ enum zfcp_fc_wka_status {
 /**
  * struct zfcp_fc_wka_port - representation of well-known-address (WKA) FC port
  * @adapter: Pointer to adapter structure this WKA port belongs to
- * @completion_wq: Wait for completion of open/close command
+ * @opened: Wait for completion of open command
+ * @closed: Wait for completion of close command
  * @status: Current status of WKA port
  * @refcount: Reference count to keep port open as long as it is in use
  * @d_id: FC destination id or well-known-address
@@ -195,7 +196,8 @@ enum zfcp_fc_wka_status {
  */
 struct zfcp_fc_wka_port {
 	struct zfcp_adapter	*adapter;
-	wait_queue_head_t	completion_wq;
+	wait_queue_head_t	opened;
+	wait_queue_head_t	closed;
 	enum zfcp_fc_wka_status	status;
 	atomic_t		refcount;
 	u32			d_id;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 4f1e4385ce58..19223b075568 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1907,7 +1907,7 @@ static void zfcp_fsf_open_wka_port_handler(struct zfcp_fsf_req *req)
 		wka_port->status = ZFCP_FC_WKA_PORT_ONLINE;
 	}
 out:
-	wake_up(&wka_port->completion_wq);
+	wake_up(&wka_port->opened);
 }
 
 /**
@@ -1966,7 +1966,7 @@ static void zfcp_fsf_close_wka_port_handler(struct zfcp_fsf_req *req)
 	}
 
 	wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
-	wake_up(&wka_port->completion_wq);
+	wake_up(&wka_port->closed);
 }
 
 /**

base-commit: 71b25693b22ebb9391b27f011d3f4bf9762e24f9
-- 
2.34.1

