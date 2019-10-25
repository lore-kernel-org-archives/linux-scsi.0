Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BA4CA9EBF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F7DD2070B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505147AbfJYQNG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502446AbfJYQNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:01 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG9RCm178606
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:00 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vv205wspt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:12:59 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:57 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCsKv36372550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35EBBA4057;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22E1CA4040;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cr-000746-Ry; Fri, 25 Oct 2019 18:12:53 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 01/11] zfcp: signal incomplete or error for sync exchange config/port data
Date:   Fri, 25 Oct 2019 18:12:43 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571934247.git.bblock@linux.ibm.com>
References: <cover.1571934247.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-0008-0000-0000-0000032795E7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-0009-0000-0000-00004A46CDE5
Message-Id: <e14f0702fa2b00a4d1f37c7981a13f2dd1ea2c83.1572018130.git.bblock@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adds a new FSF-Request status flag (ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE)
that signal that the data received using Exchange Config Data or
Exchange Port Data was incomplete. This new flags is set in the
respective handlers during the response path.

With this patch, only the synchronous FSF-functions for each command got
support for the new flag, otherwise it is transparent.

Together with this new flag and already existing status flags the
synchronous FSF-functions are extended to now detect whether the
received data is complete, incomplete or completely invalid (this
includes cases where a command ran into a timeout). This is now signaled
back to the caller, where previously only failures on the request path
would result in a bad return-code.

For complete data the return-code remains 0. For incomplete data a new
return-code -EAGAIN is added to the function-interface. For completely
invalid data the already existing return-code -EIO is reused - formerly
this was used to signal failures on the request path.

Existing callers of the FSF-functions are adjusted so that they
behave as before for return-code 0 and -EAGAIN, to not change the
user-interface. As -EIO existed all along, it was already exposed to the
user - and needed handling - and will now also be exposed in this new
special case.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h   |  1 +
 drivers/s390/scsi/zfcp_fsf.c   | 46 ++++++++++++++++++++++++++++++----
 drivers/s390/scsi/zfcp_scsi.c  |  4 +--
 drivers/s390/scsi/zfcp_sysfs.c |  4 +--
 4 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 87d2f47a6990..f5acdb67442e 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -86,6 +86,7 @@
 #define ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED       0x00000080
 #define ZFCP_STATUS_FSFREQ_TMFUNCFAILED         0x00000200
 #define ZFCP_STATUS_FSFREQ_DISMISSED            0x00001000
+#define ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE	0x00020000
 
 /************************* STRUCTURE DEFINITIONS *****************************/
 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index cf63916814cc..d8f0e446fe13 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -585,6 +585,8 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 				&adapter->status);
 		break;
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
+		req->status |= ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE;
+
 		fc_host_node_name(shost) = 0;
 		fc_host_port_name(shost) = 0;
 		fc_host_port_id(shost) = 0;
@@ -663,6 +665,8 @@ static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *req)
 		zfcp_fsf_exchange_port_evaluate(req);
 		break;
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
+		req->status |= ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE;
+
 		zfcp_fsf_exchange_port_evaluate(req);
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
@@ -1278,6 +1282,19 @@ int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 	return retval;
 }
 
+
+/**
+ * zfcp_fsf_exchange_config_data_sync() - Request information about FCP channel.
+ * @qdio: pointer to the QDIO-Queue to use for sending the command.
+ * @data: pointer to the QTCB-Bottom for storing the result of the command,
+ *	  might be %NULL.
+ *
+ * Returns:
+ * * 0		- Exchange Config Data was successful, @data is complete
+ * * -EIO	- Exchange Config Data was not successful, @data is invalid
+ * * -EAGAIN	- @data contains incomplete data
+ * * -ENOMEM	- Some memory allocation failed along the way
+ */
 int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *qdio,
 				       struct fsf_qtcb_bottom_config *data)
 {
@@ -1309,9 +1326,16 @@ int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *qdio,
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 	spin_unlock_irq(&qdio->req_q_lock);
+
 	if (!retval) {
 		/* NOTE: ONLY TOUCH SYNC req AGAIN ON req->completion. */
 		wait_for_completion(&req->completion);
+
+		if (req->status &
+		    (ZFCP_STATUS_FSFREQ_ERROR | ZFCP_STATUS_FSFREQ_DISMISSED))
+			retval = -EIO;
+		else if (req->status & ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE)
+			retval = -EAGAIN;
 	}
 
 	zfcp_fsf_req_free(req);
@@ -1369,10 +1393,17 @@ int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
 }
 
 /**
- * zfcp_fsf_exchange_port_data_sync - request information about local port
- * @qdio: pointer to struct zfcp_qdio
- * @data: pointer to struct fsf_qtcb_bottom_port
- * Returns: 0 on success, error otherwise
+ * zfcp_fsf_exchange_port_data_sync() - Request information about local port.
+ * @qdio: pointer to the QDIO-Queue to use for sending the command.
+ * @data: pointer to the QTCB-Bottom for storing the result of the command,
+ *	  might be %NULL.
+ *
+ * Returns:
+ * * 0		- Exchange Port Data was successful, @data is complete
+ * * -EIO	- Exchange Port Data was not successful, @data is invalid
+ * * -EAGAIN	- @data contains incomplete data
+ * * -ENOMEM	- Some memory allocation failed along the way
+ * * -EOPNOTSUPP	- This operation is not supported
  */
 int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *qdio,
 				     struct fsf_qtcb_bottom_port *data)
@@ -1408,10 +1439,15 @@ int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *qdio,
 	if (!retval) {
 		/* NOTE: ONLY TOUCH SYNC req AGAIN ON req->completion. */
 		wait_for_completion(&req->completion);
+
+		if (req->status &
+		    (ZFCP_STATUS_FSFREQ_ERROR | ZFCP_STATUS_FSFREQ_DISMISSED))
+			retval = -EIO;
+		else if (req->status & ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE)
+			retval = -EAGAIN;
 	}
 
 	zfcp_fsf_req_free(req);
-
 	return retval;
 
 out_unlock:
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index e9ded2befa0d..3910d529c15a 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -605,7 +605,7 @@ zfcp_scsi_get_fc_host_stats(struct Scsi_Host *host)
 		return NULL;
 
 	ret = zfcp_fsf_exchange_port_data_sync(adapter->qdio, data);
-	if (ret) {
+	if (ret != 0 && ret != -EAGAIN) {
 		kfree(data);
 		return NULL;
 	}
@@ -634,7 +634,7 @@ static void zfcp_scsi_reset_fc_host_stats(struct Scsi_Host *shost)
 		return;
 
 	ret = zfcp_fsf_exchange_port_data_sync(adapter->qdio, data);
-	if (ret)
+	if (ret != 0 && ret != -EAGAIN)
 		kfree(data);
 	else {
 		adapter->stats_reset = jiffies/HZ;
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index af197e2b3e69..90d851d49410 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -577,7 +577,7 @@ static ssize_t zfcp_sysfs_adapter_util_show(struct device *dev,
 		return -ENOMEM;
 
 	retval = zfcp_fsf_exchange_port_data_sync(adapter->qdio, qtcb_port);
-	if (!retval)
+	if (retval == 0 || retval == -EAGAIN)
 		retval = sprintf(buf, "%u %u %u\n", qtcb_port->cp_util,
 				 qtcb_port->cb_util, qtcb_port->a_util);
 	kfree(qtcb_port);
@@ -603,7 +603,7 @@ static int zfcp_sysfs_adapter_ex_config(struct device *dev,
 		return -ENOMEM;
 
 	retval = zfcp_fsf_exchange_config_data_sync(adapter->qdio, qtcb_config);
-	if (!retval)
+	if (retval == 0 || retval == -EAGAIN)
 		*stat_inf = qtcb_config->stat_info;
 
 	kfree(qtcb_config);
-- 
2.21.0

