Return-Path: <SRS0=SSlb=ED=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4EAC56201
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 21:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A51EE24859
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 21:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sVzeVD51"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgJ1VdB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:33:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbgJ1Vc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Oct 2020 17:32:56 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SI25qA123705;
        Wed, 28 Oct 2020 14:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=TQtuFv4i4lEPirDbebLwB2JvxgOWERtBtKQF8MOx+2M=;
 b=sVzeVD510ul6oUUaSTdXXy1l1KKC0D8Wb8P7Wpx09ALIHHbLzxR2CEpRGl76wxUnQkKQ
 ttXkVM9SHb8RiYEi3h26pO+fz4R+JsC64HkYK7yBXCD5Cah4Nve53aU9Zpu4KzkGWbXf
 jfTlqhihG90eIQhrDyDo3oUV5ro8MXJZ8oUC8rLeGzpoiNoSlEJD9BDWFNaBgcGXFaMo
 +K9pMsnJsZpim1YZ9wHsaAYG05Kg4JPBGdnSy3CZ6o28Se4sk4ZGksbL9Q+0389nC26E
 SSDM9qHHHXqScHynf/TtukVuUCYNk5I5c3wMzlJ46L9La7e4dm11prLqy7pkgDwtlgKu 9Q== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34esjm5x41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 14:30:59 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09SITIYG020422;
        Wed, 28 Oct 2020 18:30:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 34ejqe8rw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 18:30:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09SIUsm931981874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 18:30:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB4CC4C05C;
        Wed, 28 Oct 2020 18:30:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD9C74C05E;
        Wed, 28 Oct 2020 18:30:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.181])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 28 Oct 2020 18:30:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kXqDl-002ps6-Mk; Wed, 28 Oct 2020 19:30:53 +0100
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
Subject: [PATCH 5/5] zfcp: handle event-lost notification for Version Change events
Date:   Wed, 28 Oct 2020 19:30:52 +0100
Message-Id: <297c7be2944c3714863fcd22d531d910312d29f0.1603908167.git.bblock@linux.ibm.com>
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

As recovery for a lost Version Change event, trigger an
Exchange Config Data cmd to retrieve the current FW version.

Doing so requires process context (as eg. zfcp_qdio_sbal_get()
might need to sleep), so defer from tasklet context into a work
item.

Suggested-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c | 11 +++++++++++
 drivers/s390/scsi/zfcp_def.h |  1 +
 drivers/s390/scsi/zfcp_fsf.c |  3 +++
 drivers/s390/scsi/zfcp_fsf.h |  1 +
 4 files changed, 16 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 18b713a616de..768873dd55b8 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -292,6 +292,14 @@ static void _zfcp_status_read_scheduler(struct work_struct *work)
 					     stat_work));
 }
 
+static void zfcp_version_change_lost_work(struct work_struct *work)
+{
+	struct zfcp_adapter *adapter = container_of(work, struct zfcp_adapter,
+						    version_change_lost_work);
+
+	zfcp_fsf_exchange_config_data_sync(adapter->qdio, NULL);
+}
+
 static void zfcp_print_sl(struct seq_file *m, struct service_level *sl)
 {
 	struct zfcp_adapter *adapter =
@@ -353,6 +361,8 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
 	INIT_DELAYED_WORK(&adapter->scan_work, zfcp_fc_scan_ports);
 	INIT_WORK(&adapter->ns_up_work, zfcp_fc_sym_name_update);
+	INIT_WORK(&adapter->version_change_lost_work,
+		  zfcp_version_change_lost_work);
 
 	adapter->next_port_scan = jiffies;
 
@@ -429,6 +439,7 @@ void zfcp_adapter_unregister(struct zfcp_adapter *adapter)
 	cancel_delayed_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
 	cancel_work_sync(&adapter->ns_up_work);
+	cancel_work_sync(&adapter->version_change_lost_work);
 	zfcp_destroy_adapter_work_queue(adapter);
 
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index da8a5ceb615c..f656d74a5f94 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -201,6 +201,7 @@ struct zfcp_adapter {
 	struct zfcp_fc_events events;
 	unsigned long		next_port_scan;
 	struct zfcp_diag_adapter	*diagnostics;
+	struct work_struct	version_change_lost_work;
 };
 
 struct zfcp_port {
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index afa95e04eceb..7593a9667b3e 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -309,6 +309,9 @@ static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
 	case FSF_STATUS_READ_NOTIFICATION_LOST:
 		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_INCOMING_ELS)
 			zfcp_fc_conditional_port_scan(adapter);
+		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_VERSION_CHANGE)
+			queue_work(adapter->work_queue,
+				   &adapter->version_change_lost_work);
 		break;
 	case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
 		adapter->adapter_features = sr_buf->payload.word[0];
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 26ad7a0c5ce3..5e6b601af980 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -143,6 +143,7 @@
 
 /* status subtypes for unsolicited status notification lost */
 #define FSF_STATUS_READ_SUB_INCOMING_ELS	0x00000001
+#define FSF_STATUS_READ_SUB_VERSION_CHANGE	0x00000100
 
 /* status subtypes for version change */
 #define FSF_STATUS_READ_SUB_LIC_CHANGE		0x00000001
-- 
2.26.2

