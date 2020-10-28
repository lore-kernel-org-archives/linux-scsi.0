Return-Path: <SRS0=SSlb=ED=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B0BC388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 22:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6A62470E
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 22:04:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pKUy4HZN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgJ1WEx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:04:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728327AbgJ1WBK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Oct 2020 18:01:10 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SI2P6q034700;
        Wed, 28 Oct 2020 14:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=JNiX6m+j8hfc5BWwDrbqyi4olR4cLc/NmQ+QKVJWL4k=;
 b=pKUy4HZNa9rkihoWzpfppzfnsoZidLWiuyWdEYs63VYz54SsCSRndnr+Dah5N+8twZ3S
 gSEz5E7bvsC15NySVUeYDvI2dECbVHDv++3E1y7872U+jXHLBrdDZU62RUss578C3kJS
 3D/Rh31srW1kVIqihXoNmJFkEY6a8cuY9IHEck79EtzTbmB6WQI7BQkeHs8ZY99ZLLJr
 tzOkm1/pB9lums3GiwNCmwcvrqdSl9faWeRUGD13FhOSzhFb4Ou9Xqwrn0120vECY0lD
 22v5ZQGgAW0g+WJ0IQRUcxLcXd9pISY/OcZ/nZxHOvFldAptFotJFEzt1X+HDw63c3on uQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34f97ubkt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 14:30:58 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09SIUCba004495;
        Wed, 28 Oct 2020 18:30:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 34dwh0hcgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 18:30:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09SIUroZ30736662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 18:30:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A7FB4C05C;
        Wed, 28 Oct 2020 18:30:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F9364C044;
        Wed, 28 Oct 2020 18:30:53 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.181])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 28 Oct 2020 18:30:53 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kXqDk-002prv-Ir; Wed, 28 Oct 2020 19:30:52 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 1/5] zfcp: lift Input Queue tasklet from qdio
Date:   Wed, 28 Oct 2020 19:30:48 +0100
Message-Id: <94a765211c48b74a7b91c5e60b158de01db98d43.1603908167.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603908167.git.bblock@linux.ibm.com>
References: <cover.1603908167.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_08:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 suspectscore=2 impostorscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

Shift the IRQ tasklet processing from the qdio layer into zfcp.
This will allow for a good amount of cleanups in qdio, and provides
future opportunity to improve the IRQ processing inside zfcp.

We continue to use the qdio layer's internal tasklet/timer mechanism
(ie. scan_threshold etc) to check for Request Queue completions.
Initially we planned to check for such completions after inspecting
the Response Queue - this should typically work, but there's a
theoretical race where the device only presents the Request Queue
completions _after_ all Response Queue processing has finished.
If the Request Queue is then also _completely_ full, we could send no
further IOs and thus get no interrupt that would trigger an inspection
of the Request Queue.
So for now stick to the old model, where we can trust that such a race
would be recovered by qdio's internal timer.

Code-flow wise, this establishes two levels of control:
1. the qdio layer will only deliver IRQs to the device driver if the
   QDIO_IRQ_DISABLED flag is cleared. zfcp manages this through
   qdio_start_irq() / qdio_stop_irq(). The initial state is DISABLED,
   and zfcp_qdio_open() schedules zfcp's IRQ tasklet once during startup
   to explicitly enable IRQ delivery.
2. the zfcp tasklet is initialized with tasklet_disable(), and only gets
   enabled once we open the qdio device.
   When closing the qdio device, we must disable the tasklet _before_
   disabling IRQ delivery (otherwise a concurrently running tasklet
   could re-enable IRQ delivery after we disabled it).

   A final tasklet_kill() during teardown ensures that no lingering
   tasklet_schedule() is still accessing the tasklet structure.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_qdio.c | 39 +++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_qdio.h |  2 ++
 2 files changed, 41 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index a8a514074084..9fc045ddf66d 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -131,6 +131,33 @@ static void zfcp_qdio_int_resp(struct ccw_device *cdev, unsigned int qdio_err,
 		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdires2");
 }
 
+static void zfcp_qdio_irq_tasklet(struct tasklet_struct *tasklet)
+{
+	struct zfcp_qdio *qdio = from_tasklet(qdio, tasklet, irq_tasklet);
+	struct ccw_device *cdev = qdio->adapter->ccw_device;
+	unsigned int start, error;
+	int completed;
+
+	/* Check the Response Queue, and kick off the Request Queue tasklet: */
+	completed = qdio_get_next_buffers(cdev, 0, &start, &error);
+	if (completed < 0)
+		return;
+	if (completed > 0)
+		zfcp_qdio_int_resp(cdev, error, 0, start, completed,
+				   (unsigned long) qdio);
+
+	if (qdio_start_irq(cdev))
+		/* More work pending: */
+		tasklet_schedule(&qdio->irq_tasklet);
+}
+
+static void zfcp_qdio_poll(struct ccw_device *cdev, unsigned long data)
+{
+	struct zfcp_qdio *qdio = (struct zfcp_qdio *) data;
+
+	tasklet_schedule(&qdio->irq_tasklet);
+}
+
 static struct qdio_buffer_element *
 zfcp_qdio_sbal_chain(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 {
@@ -332,6 +359,8 @@ void zfcp_qdio_close(struct zfcp_qdio *qdio)
 
 	wake_up(&qdio->req_q_wq);
 
+	tasklet_disable(&qdio->irq_tasklet);
+	qdio_stop_irq(adapter->ccw_device);
 	qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR);
 
 	/* cleanup used outbound sbals */
@@ -387,6 +416,7 @@ int zfcp_qdio_open(struct zfcp_qdio *qdio)
 	init_data.no_output_qs = 1;
 	init_data.input_handler = zfcp_qdio_int_resp;
 	init_data.output_handler = zfcp_qdio_int_req;
+	init_data.irq_poll = zfcp_qdio_poll;
 	init_data.int_parm = (unsigned long) qdio;
 	init_data.input_sbal_addr_array = input_sbals;
 	init_data.output_sbal_addr_array = output_sbals;
@@ -433,6 +463,11 @@ int zfcp_qdio_open(struct zfcp_qdio *qdio)
 	atomic_set(&qdio->req_q_free, QDIO_MAX_BUFFERS_PER_Q);
 	atomic_or(ZFCP_STATUS_ADAPTER_QDIOUP, &qdio->adapter->status);
 
+	/* Enable processing for QDIO interrupts: */
+	tasklet_enable(&qdio->irq_tasklet);
+	/* This results in a qdio_start_irq(): */
+	tasklet_schedule(&qdio->irq_tasklet);
+
 	zfcp_qdio_shost_update(adapter, qdio);
 
 	return 0;
@@ -450,6 +485,8 @@ void zfcp_qdio_destroy(struct zfcp_qdio *qdio)
 	if (!qdio)
 		return;
 
+	tasklet_kill(&qdio->irq_tasklet);
+
 	if (qdio->adapter->ccw_device)
 		qdio_free(qdio->adapter->ccw_device);
 
@@ -475,6 +512,8 @@ int zfcp_qdio_setup(struct zfcp_adapter *adapter)
 
 	spin_lock_init(&qdio->req_q_lock);
 	spin_lock_init(&qdio->stat_lock);
+	tasklet_setup(&qdio->irq_tasklet, zfcp_qdio_irq_tasklet);
+	tasklet_disable(&qdio->irq_tasklet);
 
 	adapter->qdio = qdio;
 	return 0;
diff --git a/drivers/s390/scsi/zfcp_qdio.h b/drivers/s390/scsi/zfcp_qdio.h
index 6b43d6b254be..9c1f310db155 100644
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -10,6 +10,7 @@
 #ifndef ZFCP_QDIO_H
 #define ZFCP_QDIO_H
 
+#include <linux/interrupt.h>
 #include <asm/qdio.h>
 
 #define ZFCP_QDIO_SBALE_LEN	PAGE_SIZE
@@ -44,6 +45,7 @@ struct zfcp_qdio {
 	u64			req_q_util;
 	atomic_t		req_q_full;
 	wait_queue_head_t	req_q_wq;
+	struct tasklet_struct	irq_tasklet;
 	struct zfcp_adapter	*adapter;
 	u16			max_sbale_per_sbal;
 	u16			max_sbale_per_req;
-- 
2.26.2

