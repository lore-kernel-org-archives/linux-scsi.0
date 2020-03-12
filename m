Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A924C1975A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 18:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 692492067C
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 18:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgCLSPg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 14:15:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34714 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726328AbgCLSPf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 14:15:35 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CIEd9r101855
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 14:15:34 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yqt6jr1b7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 14:15:34 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 12 Mar 2020 17:45:22 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 17:45:20 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CHjIc740173752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:45:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E5F552057;
        Thu, 12 Mar 2020 17:45:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2AF2452054;
        Thu, 12 Mar 2020 17:45:18 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 03/10] zfcp: wire previously driver-specific sysfs attributes also to fc_host
Date:   Thu, 12 Mar 2020 18:44:58 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312174505.51294-1-maier@linux.ibm.com>
References: <20200312174505.51294-1-maier@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031217-0016-0000-0000-000002F00E8D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031217-0017-0000-0000-000033537E0B
Message-Id: <20200312174505.51294-4-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_12:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 malwarescore=0 spamscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120093
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Manufacturer, HBA model, firmware version, and hardware version.
Use the same value format as for the driver-specific attributes.
Keep the driver-specific attributes for stable user space sysfs API.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c  | 11 +++++++++++
 drivers/s390/scsi/zfcp_scsi.c |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 0289b09120f3..31ecbc160482 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -502,6 +502,8 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 	if (req->data)
 		memcpy(req->data, bottom, sizeof(*bottom));
 
+	snprintf(fc_host_manufacturer(shost), FC_SERIAL_NUMBER_SIZE, "%s",
+		 "IBM");
 	fc_host_port_name(shost) = be64_to_cpu(nsp->fl_wwpn);
 	fc_host_node_name(shost) = be64_to_cpu(nsp->fl_wwnn);
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
@@ -525,6 +527,8 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 		zfcp_fsf_convert_portspeed(bottom->fc_link_speed);
 
 	adapter->hydra_version = bottom->adapter_type;
+	snprintf(fc_host_model(shost), FC_SYMBOLIC_NAME_SIZE, "0x%04x",
+		 bottom->adapter_type);
 
 	switch (bottom->fc_topology) {
 	case FSF_TOPO_P2P:
@@ -569,6 +573,8 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
+	snprintf(fc_host_firmware_version(shost), FC_VERSION_STRING_SIZE,
+		 "0x%08x", bottom->lic_version);
 	adapter->fsf_lic_version = bottom->lic_version;
 	adapter->adapter_features = bottom->adapter_features;
 	adapter->connection_features = bottom->connection_features;
@@ -609,6 +615,8 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 		adapter->hydra_version = 0;
+		snprintf(fc_host_model(shost), FC_SYMBOLIC_NAME_SIZE, "0x%04x",
+			 0);
 
 		/* avoids adapter shutdown to be able to recognize
 		 * events such as LINK UP */
@@ -626,6 +634,9 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 
 	if (adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT) {
 		adapter->hardware_version = bottom->hardware_version;
+		snprintf(fc_host_hardware_version(shost),
+			 FC_VERSION_STRING_SIZE,
+			 "0x%08x", bottom->hardware_version);
 		memcpy(fc_host_serial_number(shost), bottom->serial_number,
 		       min(FC_SERIAL_NUMBER_SIZE, 17));
 		EBCASC(fc_host_serial_number(shost),
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index cb7efe8b2753..13d873f806e4 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -856,6 +856,10 @@ struct fc_function_template zfcp_transport_functions = {
 	.show_host_supported_speeds = 1,
 	.show_host_maxframe_size = 1,
 	.show_host_serial_number = 1,
+	.show_host_manufacturer = 1,
+	.show_host_model = 1,
+	.show_host_hardware_version = 1,
+	.show_host_firmware_version = 1,
 	.get_fc_host_stats = zfcp_scsi_get_fc_host_stats,
 	.reset_fc_host_stats = zfcp_scsi_reset_fc_host_stats,
 	.set_rport_dev_loss_tmo = zfcp_scsi_set_rport_dev_loss_tmo,
-- 
2.17.1

