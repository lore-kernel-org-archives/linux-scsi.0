Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FDAC433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7109223A56
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 20:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbhANUct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 15:32:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728099AbhANUcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Jan 2021 15:32:47 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10EKVm5A108803;
        Thu, 14 Jan 2021 15:32:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=isxwZPqQSQ5/Q/W06H/NV4P1fDoItP4mLe1+8ylQYm8=;
 b=JsZtVrfkDPfVQ9tjroKcCSKskQx7GIgCz2e9/eHXwAnCclvrtaz3u6HpwVQ+YHt812EL
 Hgq0uASKXN79vl1AcxU3Kpdo5jZSA8XMhfc6iTF+JLcRsOwSBxcZ2bPnff0NvimTDiCF
 s7QnH3ZELi0SbEDI/WtKf9Ij6JM82Ge0FEheRPZieseZIZwslNjg3+QvXeHtP4OWlCTJ
 Q9wdvElA2MmRYdIryKqTFKyM1YPSMluRdMEhGsw2oGP6svUstGe9PPj10J4gWUWv1L+S
 OKgI1te0fpuvdrsebL+JmmsWB7ZKvsz8JMXAX50pERPk/twjO+IdLSOL4TuWa3FXJDJl qQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 362veg9148-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 15:32:00 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10EKSBGG007089;
        Thu, 14 Jan 2021 20:31:59 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 35y449sr12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 20:31:59 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10EKVvDE25887034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jan 2021 20:31:57 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB48E6E050;
        Thu, 14 Jan 2021 20:31:57 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 600EA6E052;
        Thu, 14 Jan 2021 20:31:57 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jan 2021 20:31:57 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v5 18/21] ibmvfc: send Cancel MAD down each hw scsi channel
Date:   Thu, 14 Jan 2021 14:31:45 -0600
Message-Id: <20210114203148.246656-19-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210114203148.246656-1-tyreld@linux.ibm.com>
References: <20210114203148.246656-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_07:2021-01-14,2021-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 adultscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101140115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In general the client needs to send Cancel MADs and task management
commands down the same channel as the command(s) intended to cancel or
abort. The client assigns cancel keys per LUN and thus must send a
Cancel down each channel commands were submitted for that LUN. Further,
the client then must wait for those cancel completions prior to
submitting a LUN RESET or ABORT TASK SET.

Add a cancel rsp iu syncronization field to the ibmvfc_queue struct such
that the cancel routine can sync the cancel response to each queue that
requires a cancel command. Build a list of each cancel event sent and
wait for the completion of each submitted cancel.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 109 +++++++++++++++++++++++++++++----
 drivers/scsi/ibmvscsi/ibmvfc.h |   3 +
 2 files changed, 100 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index b0b0212344f3..5ca8fcafd1d5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2418,18 +2418,82 @@ static struct ibmvfc_event *ibmvfc_init_tmf(struct ibmvfc_queue *queue,
 	return evt;
 }
 
-/**
- * ibmvfc_cancel_all - Cancel all outstanding commands to the device
- * @sdev:	scsi device to cancel commands
- * @type:	type of error recovery being performed
- *
- * This sends a cancel to the VIOS for the specified device. This does
- * NOT send any abort to the actual device. That must be done separately.
- *
- * Returns:
- *	0 on success / other on failure
- **/
-static int ibmvfc_cancel_all(struct scsi_device *sdev, int type)
+static int ibmvfc_cancel_all_mq(struct scsi_device *sdev, int type)
+{
+	struct ibmvfc_host *vhost = shost_priv(sdev->host);
+	struct ibmvfc_event *evt, *found_evt, *temp;
+	struct ibmvfc_queue *queues = vhost->scsi_scrqs.scrqs;
+	unsigned long flags;
+	int num_hwq, i;
+	int fail = 0;
+	LIST_HEAD(cancelq);
+	u16 status;
+
+	ENTER;
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	num_hwq = vhost->scsi_scrqs.active_queues;
+	for (i = 0; i < num_hwq; i++) {
+		spin_lock(queues[i].q_lock);
+		spin_lock(&queues[i].l_lock);
+		found_evt = NULL;
+		list_for_each_entry(evt, &queues[i].sent, queue_list) {
+			if (evt->cmnd && evt->cmnd->device == sdev) {
+				found_evt = evt;
+				break;
+			}
+		}
+		spin_unlock(&queues[i].l_lock);
+
+		if (found_evt && vhost->logged_in) {
+			evt = ibmvfc_init_tmf(&queues[i], sdev, type);
+			evt->sync_iu = &queues[i].cancel_rsp;
+			ibmvfc_send_event(evt, vhost, default_timeout);
+			list_add_tail(&evt->cancel, &cancelq);
+		}
+
+		spin_unlock(queues[i].q_lock);
+	}
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
+	if (list_empty(&cancelq)) {
+		if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
+			sdev_printk(KERN_INFO, sdev, "No events found to cancel\n");
+		return 0;
+	}
+
+	sdev_printk(KERN_INFO, sdev, "Cancelling outstanding commands.\n");
+
+	list_for_each_entry_safe(evt, temp, &cancelq, cancel) {
+		wait_for_completion(&evt->comp);
+		status = be16_to_cpu(evt->queue->cancel_rsp.mad_common.status);
+		list_del(&evt->cancel);
+		ibmvfc_free_event(evt);
+
+		if (status != IBMVFC_MAD_SUCCESS) {
+			sdev_printk(KERN_WARNING, sdev, "Cancel failed with rc=%x\n", status);
+			switch (status) {
+			case IBMVFC_MAD_DRIVER_FAILED:
+			case IBMVFC_MAD_CRQ_ERROR:
+			/* Host adapter most likely going through reset, return success to
+			 * the caller will wait for the command being cancelled to get returned
+			 */
+				break;
+			default:
+				fail = 1;
+				break;
+			}
+		}
+	}
+
+	if (fail)
+		return -EIO;
+
+	sdev_printk(KERN_INFO, sdev, "Successfully cancelled outstanding commands\n");
+	LEAVE;
+	return 0;
+}
+
+static int ibmvfc_cancel_all_sq(struct scsi_device *sdev, int type)
 {
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	struct ibmvfc_event *evt, *found_evt;
@@ -2498,6 +2562,27 @@ static int ibmvfc_cancel_all(struct scsi_device *sdev, int type)
 	return 0;
 }
 
+/**
+ * ibmvfc_cancel_all - Cancel all outstanding commands to the device
+ * @sdev:	scsi device to cancel commands
+ * @type:	type of error recovery being performed
+ *
+ * This sends a cancel to the VIOS for the specified device. This does
+ * NOT send any abort to the actual device. That must be done separately.
+ *
+ * Returns:
+ *	0 on success / other on failure
+ **/
+static int ibmvfc_cancel_all(struct scsi_device *sdev, int type)
+{
+	struct ibmvfc_host *vhost = shost_priv(sdev->host);
+
+	if (vhost->mq_enabled && vhost->using_channels)
+		return ibmvfc_cancel_all_mq(sdev, type);
+	else
+		return ibmvfc_cancel_all_sq(sdev, type);
+}
+
 /**
  * ibmvfc_match_key - Match function for specified cancel key
  * @evt:	ibmvfc event struct
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 2dbce7071409..c3bb83c9d8a6 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -737,6 +737,7 @@ struct ibmvfc_target {
 /* a unit of work for the hosting partition */
 struct ibmvfc_event {
 	struct list_head queue_list;
+	struct list_head cancel;
 	struct ibmvfc_host *vhost;
 	struct ibmvfc_queue *queue;
 	struct ibmvfc_target *tgt;
@@ -790,6 +791,8 @@ struct ibmvfc_queue {
 	struct list_head free;
 	spinlock_t l_lock;
 
+	union ibmvfc_iu cancel_rsp;
+
 	/* Sub-CRQ fields */
 	struct ibmvfc_host *vhost;
 	unsigned long cookie;
-- 
2.27.0

