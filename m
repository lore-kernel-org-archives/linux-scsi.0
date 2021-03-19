Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0FFC433C1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 20:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1768C6197B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 20:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhCSUvO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 16:51:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229912AbhCSUul (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Mar 2021 16:50:41 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JKX5Hw107235;
        Fri, 19 Mar 2021 16:50:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5nc+PQngE6lzm5zp/Hxo1++AIj63sWSpfvhPQP6Ke4w=;
 b=UM1ZDOvpdgRglxow24e4CbSdc/UCSKaJHrw/BUDHFRqLoaR8+CRSKDr0EW1BuK6X0dRY
 lCb0WE3dgmMtWn4oBV6yqlpd6uNZK2p52rlBuVVAgIIWMSTTDSo9n+AqOUpbYeWLtd2V
 3M9mHMat6FUJPTfENcBSY8IBxOjZ4wsllceoFEgjJ8N3x3F0o5kNx2aIGoNterWtAmy0
 2pV1CUgxT98I1dIpo6QhZVfc719EfcWvazMmrQFSbWsHKn8xcmRXnXbcb8gXmTItM+tH
 r8qSYUuMHXcVL/Unh/mgc10uw6rY8E56Ze8uPNF5YKB8ruebif8ppYcJ5gcVDWsFhZF3 ng== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c7m762ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 16:50:34 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JKlDpp005276;
        Fri, 19 Mar 2021 20:50:33 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 37a3gdbtu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 20:50:33 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JKoWtb14483870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 20:50:32 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E32FF6E054;
        Fri, 19 Mar 2021 20:50:31 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 972F36E04C;
        Fri, 19 Mar 2021 20:50:31 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 20:50:31 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 2/2] ibmvfc: make ibmvfc_wait_for_ops MQ aware
Date:   Fri, 19 Mar 2021 14:50:29 -0600
Message-Id: <20210319205029.312969-3-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210319205029.312969-1-tyreld@linux.ibm.com>
References: <20210319205029.312969-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_10:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During MQ enablement of the ibmvfc driver ibmvfc_wait_for_ops() was
missed. This function is responsible for waiting on commands to complete
that match a certain criteria such as LUN or cancel key. The
implementation as is only scans the CRQ for events ignoring any
sub-queues and as a result will exit successfully without doing
anything when operating in MQ channelized mode.

Check the mq and channel use flags to determine which queues are
applicable, and scan each queue accordingly. Note in MQ mode scsi
commands are only issued down sub-queues and the CRQ is only used for
driver specific management commands. As such the CRQ events are ignored
when operating in MQ mode with channels.

Fixes: 9000cb998bcf ("scsi: ibmvfc: Enable MQ and set reasonable defaults")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 51 ++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 5414b465a92f..61831f2fdb30 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2403,41 +2403,58 @@ static int ibmvfc_wait_for_ops(struct ibmvfc_host *vhost, void *device,
 {
 	struct ibmvfc_event *evt;
 	DECLARE_COMPLETION_ONSTACK(comp);
-	int wait, i;
+	int wait, i, q_index, q_size;
 	unsigned long flags;
 	signed long timeout = IBMVFC_ABORT_WAIT_TIMEOUT * HZ;
+	struct ibmvfc_queue *queues;
 
 	ENTER;
+	if (vhost->mq_enabled && vhost->using_channels) {
+		queues = vhost->scsi_scrqs.scrqs;
+		q_size = vhost->scsi_scrqs.active_queues;
+	} else {
+		queues = &vhost->crq;
+		q_size = 1;
+	}
+
 	do {
 		wait = 0;
-		spin_lock_irqsave(&vhost->crq.l_lock, flags);
-		for (i = 0; i < vhost->crq.evt_pool.size; i++) {
-			evt = &vhost->crq.evt_pool.events[i];
-			if (!ibmvfc_event_is_free(evt)) {
-				if (match(evt, device)) {
-					evt->eh_comp = &comp;
-					wait++;
+		spin_lock_irqsave(vhost->host->host_lock, flags);
+		for (q_index = 0; q_index < q_size; q_index++) {
+			spin_lock(&queues[q_index].l_lock);
+			for (i = 0; i < queues[q_index].evt_pool.size; i++) {
+				evt = &queues[q_index].evt_pool.events[i];
+				if (!ibmvfc_event_is_free(evt)) {
+					if (match(evt, device)) {
+						evt->eh_comp = &comp;
+						wait++;
+					}
 				}
 			}
+			spin_unlock(&queues[q_index].l_lock);
 		}
-		spin_unlock_irqrestore(&vhost->crq.l_lock, flags);
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 		if (wait) {
 			timeout = wait_for_completion_timeout(&comp, timeout);
 
 			if (!timeout) {
 				wait = 0;
-				spin_lock_irqsave(&vhost->crq.l_lock, flags);
-				for (i = 0; i < vhost->crq.evt_pool.size; i++) {
-					evt = &vhost->crq.evt_pool.events[i];
-					if (!ibmvfc_event_is_free(evt)) {
-						if (match(evt, device)) {
-							evt->eh_comp = NULL;
-							wait++;
+				spin_lock_irqsave(vhost->host->host_lock, flags);
+				for (q_index = 0; q_index < q_size; q_index++) {
+					spin_lock(&queues[q_index].l_lock);
+					for (i = 0; i < queues[q_index].evt_pool.size; i++) {
+						evt = &queues[q_index].evt_pool.events[i];
+						if (!ibmvfc_event_is_free(evt)) {
+							if (match(evt, device)) {
+								evt->eh_comp = NULL;
+								wait++;
+							}
 						}
 					}
+					spin_unlock(&queues[q_index].l_lock);
 				}
-				spin_unlock_irqrestore(&vhost->crq.l_lock, flags);
+				spin_unlock_irqrestore(vhost->host->host_lock, flags);
 				if (wait)
 					dev_err(vhost->dev, "Timed out waiting for aborted commands\n");
 				LEAVE;
-- 
2.27.0

