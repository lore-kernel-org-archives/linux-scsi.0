Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2AAC10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B954B206B1
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgCLRvJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 13:51:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgCLRvJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 13:51:09 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CHnndt029410
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:51:08 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yqss885p7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:51:05 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 12 Mar 2020 17:45:21 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 17:45:18 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CHjHWi49217762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:45:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1148B52050;
        Thu, 12 Mar 2020 17:45:17 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C16FB52051;
        Thu, 12 Mar 2020 17:45:16 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 02/10] zfcp: expose fabric name as common fc_host sysfs attribute
Date:   Thu, 12 Mar 2020 18:44:57 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312174505.51294-1-maier@linux.ibm.com>
References: <20200312174505.51294-1-maier@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031217-0012-0000-0000-000003900BFD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031217-0013-0000-0000-000021CCDE91
Message-Id: <20200312174505.51294-3-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_12:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120091
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

FICON Express8S or older, as well as card features newer than
FICON Express16S+ have no certain firmware level requirement.

FICON Express16S or FICON Express16S+ have the following
minimum firmware level requirements to show a proper fabric name value:
 z13 machine
  FICON Express16S  , MCL P08424.005 , LIC version 0x00000721
 z14 machine
  FICON Express16S  , MCL P42611.008 , LIC version 0x10200069
  FICON Express16S+ , MCL P42625.010 , LIC version 0x10300147
Otherwise, the read value is not the fabric name.
Each FCP channel of these card features might need one SAN fabric re-login
after concurrent microcode update, in order to show the proper fabric name.
Possible ways to trigger a SAN fabric re-login are one of:
Pull fibres between FCP channel port and SAN switch port on either side
and re-plug, disable SAN switch port adjacent to FCP channel port and
re-enable switch port, or at Service Element toggle off all CHPIDs of
FCP channel over all LPARs and toggle CHPIDs on again.
Zfcp operating subchannels (FCP devices) on such FCP channel recovers
a fabric re-login.

Initialize fabric name for any topology and have it an invalid WWPN
0x0 for anything but fabric topology.
Otherwise for e.g. point-to-point topology one could see the initial
-1 from fc_host_setup() and after a link unplug our fabric name would
turn to 0x0 (with subsequent commit ("zfcp: fix fc_host attributes
that should be unknown on local link down)) and stay 0x0 on link replug.
I did not initialize to 0x0 somewhere even earlier in the code path
such that it would not flap from real to 0x0 to real on e.g. an exchange
config data with fabric topology.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c  | 5 +++++
 drivers/s390/scsi/zfcp_scsi.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 223a805f0b0b..0289b09120f3 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -532,8 +532,10 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 		adapter->peer_wwpn = be64_to_cpu(plogi->fl_wwpn);
 		adapter->peer_wwnn = be64_to_cpu(plogi->fl_wwnn);
 		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
+		fc_host_fabric_name(shost) = 0;
 		break;
 	case FSF_TOPO_FABRIC:
+		fc_host_fabric_name(shost) = be64_to_cpu(plogi->fl_wwnn);
 		if (bottom->connection_features & FSF_FEATURE_NPIV_MODE)
 			fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
 		else
@@ -541,8 +543,10 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 		break;
 	case FSF_TOPO_AL:
 		fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
+		fc_host_fabric_name(shost) = 0;
 		/* fall through */
 	default:
+		fc_host_fabric_name(shost) = 0;
 		dev_err(&adapter->ccw_device->dev,
 			"Unknown or unsupported arbitrated loop "
 			"fibre channel topology detected\n");
@@ -601,6 +605,7 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 		fc_host_node_name(shost) = 0;
 		fc_host_port_name(shost) = 0;
 		fc_host_port_id(shost) = 0;
+		fc_host_fabric_name(shost) = 0;
 		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 		adapter->hydra_version = 0;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 3910d529c15a..cb7efe8b2753 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -871,5 +871,6 @@ struct fc_function_template zfcp_transport_functions = {
 	.show_host_symbolic_name = 1,
 	.show_host_speed = 1,
 	.show_host_port_id = 1,
+	.show_host_fabric_name = 1,
 	.dd_bsg_size = sizeof(struct zfcp_fsf_ct_els),
 };
-- 
2.17.1

