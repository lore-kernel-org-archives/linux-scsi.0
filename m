Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824CDEE0212
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 23:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbjIMXbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 19:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjIMXbH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 19:31:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD237101
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 16:31:01 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DN7bYb023297;
        Wed, 13 Sep 2023 23:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VOs4Rwx6CVEUXonfo+MyRL7iSYmpntkMIpk8kbMk7NE=;
 b=oCDUVQh5qJoak46gxz2pENszM0iLrgfEaVkDZjvQopgW3Y8D9HsZ9a+qz3qdubD33FLq
 GMoXR7v2cOsaXAlVBmdHCWmSf83tx8LLFbzOYHZPaiy7nTOF38wQGNIvh9hk4apQKepj
 /2GqKypFsB4GoPr/bMJn9f3yL7/6aqRmRJpMO+/TUTVDvs3Q5C8IgwpyItGk8JUp6wWQ
 gypsaqVrolaYXbWlOcpoDVscVdpPSdFQ452T8AnIPiXVcp9W8UW8S8Rgm28Vf8b2y2zW
 nKBtKcek+Wgx0cY64WcsYB8hdaRBvjBU7GOqQg4AUn3Mj2YhLfl8xQAgTvy+TbHWY6uk YQ== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3kfgcn6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:30:58 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DMPBfQ012005;
        Wed, 13 Sep 2023 23:05:05 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3t15r2632r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 23:05:05 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DN540X27787548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 23:05:04 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B97158059;
        Wed, 13 Sep 2023 23:05:04 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91BD158053;
        Wed, 13 Sep 2023 23:05:03 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 23:05:03 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, brking@linux.ibm.com,
        james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 07/11] ibmvfc: track max and desired queue size in ibmvfc_channels
Date:   Wed, 13 Sep 2023 18:04:53 -0500
Message-Id: <20230913230457.2575849-8-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230913230457.2575849-1-tyreld@linux.ibm.com>
References: <20230913230457.2575849-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EFucLsOTZWBT9dAuIH2zVOe_2Xx-stMb
X-Proofpoint-ORIG-GUID: EFucLsOTZWBT9dAuIH2zVOe_2Xx-stMb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_17,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309130191
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add fields for desired and max number of queues to ibmvfc_channels. With
support for NVMeoF protocol coming these sorts of values should be
tracked in the protocol specific channel struct instead of the
overarching host adapter.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 13 ++++++++-----
 drivers/scsi/ibmvscsi/ibmvfc.h |  5 +++--
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index b03b68b3b1b6..443223c16f39 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1490,7 +1490,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 	max_cmds = scsi_qdepth + IBMVFC_NUM_INTERNAL_REQ;
 	if (mq_enabled)
 		max_cmds += (scsi_qdepth + IBMVFC_NUM_INTERNAL_SUBQ_REQ) *
-			vhost->client_scsi_channels;
+			vhost->scsi_scrqs.desired_queues;
 
 	memset(login_info, 0, sizeof(*login_info));
 
@@ -3578,11 +3578,12 @@ static ssize_t ibmvfc_show_scsi_channels(struct device *dev,
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
+	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	unsigned long flags = 0;
 	int len;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	len = snprintf(buf, PAGE_SIZE, "%d\n", vhost->client_scsi_channels);
+	len = snprintf(buf, PAGE_SIZE, "%d\n", scsi->desired_queues);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return len;
 }
@@ -3593,12 +3594,13 @@ static ssize_t ibmvfc_store_scsi_channels(struct device *dev,
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ibmvfc_host *vhost = shost_priv(shost);
+	struct ibmvfc_channels *scsi = &vhost->scsi_scrqs;
 	unsigned long flags = 0;
 	unsigned int channels;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	channels = simple_strtoul(buf, NULL, 10);
-	vhost->client_scsi_channels = min(channels, nr_scsi_hw_queues);
+	scsi->desired_queues = min(channels, shost->nr_hw_queues);
 	ibmvfc_hard_reset_host(vhost);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return strlen(buf);
@@ -5066,7 +5068,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
 	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
 	struct ibmvfc_channels *scrqs = &vhost->scsi_scrqs;
 	unsigned int num_channels =
-		min(vhost->client_scsi_channels, vhost->max_vios_scsi_channels);
+		min(scrqs->desired_queues, vhost->max_vios_scsi_channels);
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 	int i;
 
@@ -6290,7 +6292,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	vhost->task_set = 1;
 
 	vhost->mq_enabled = mq_enabled;
-	vhost->client_scsi_channels = min(shost->nr_hw_queues, nr_scsi_channels);
+	vhost->scsi_scrqs.desired_queues = min(shost->nr_hw_queues, nr_scsi_channels);
+	vhost->scsi_scrqs.max_queues = shost->nr_hw_queues;
 	vhost->using_channels = 0;
 	vhost->do_enquiry = 1;
 	vhost->scan_timeout = 0;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index d88a528b8cc1..79e1a3bbb2f7 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -818,6 +818,8 @@ struct ibmvfc_queue {
 struct ibmvfc_channels {
 	struct ibmvfc_queue *scrqs;
 	unsigned int active_queues;
+	unsigned int desired_queues;
+	unsigned int max_queues;
 };
 
 enum ibmvfc_host_action {
@@ -876,8 +878,7 @@ struct ibmvfc_host {
 	int log_level;
 	struct ibmvfc_discover_targets_entry *disc_buf;
 	struct mutex passthru_mutex;
-	int max_vios_scsi_channels;
-	int client_scsi_channels;
+	unsigned int max_vios_scsi_channels;
 	int task_set;
 	int init_retries;
 	int discovery_threads;
-- 
2.31.1

