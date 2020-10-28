Return-Path: <SRS0=SSlb=ED=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840A9C56201
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 21:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B0A421582
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 21:42:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SiY/Foik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgJ1Vml (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:42:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55030 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726226AbgJ1Vm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Oct 2020 17:42:28 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SI22qW067465;
        Wed, 28 Oct 2020 14:31:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=35ID2PYetT0GEOaJ//qciD06Z9tv3Q+Cmcip8WaWe44=;
 b=SiY/FoikhA1hRwgkkQaUz63NTnIzSCl/VOSNy97BvwErQZ2yEiXhYuLvuapvoR1TqWaG
 r34nEBd/m1U6LE3UXBpKR7NUwI2QG4cfPhyjsAjrEsgET9ucj0R4/sRn4bWQZzgP3iy/
 Ir6Z6mAIy6mcWtwyltBe4HcoYuYQudIhhT+5LJnR9HiYdz8r/37ZxgWjVUAPFagr9htO
 5y6l6uon2cF/he7SVNJajc3d2JuKyhaswGTNPBLRUGB2ev8YGbxqpGu+TE33JAv5me/k
 cy1nF6x364d9HByLjqsXB/Vok67vYWN8YD85EkaW4hXKSeTX+H0rpkQjo1ISwWFkZZDx oQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34d97hwtc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 14:31:01 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09SIRbWW010761;
        Wed, 28 Oct 2020 18:30:57 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 34f7s3r6cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 18:30:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09SIUseN30146858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 18:30:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72C81AE076;
        Wed, 28 Oct 2020 18:30:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 684A6AE056;
        Wed, 28 Oct 2020 18:30:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.181])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 28 Oct 2020 18:30:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kXqDl-002ps3-Di; Wed, 28 Oct 2020 19:30:53 +0100
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
Subject: [PATCH 4/5] zfcp: process Version Change events
Date:   Wed, 28 Oct 2020 19:30:51 +0100
Message-Id: <d2c7bc57c6cf1b65eabbf7a5d0e3927b9f65647f.1603908167.git.bblock@linux.ibm.com>
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=2 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010280116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

Handle notifications for a concurrent change of the FCP Channel
firmware.
Update the relevant user-visible fields to provide accurate data.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 16 ++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.h | 10 ++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 6cb963a06777..afa95e04eceb 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -242,6 +242,19 @@ static void zfcp_fsf_status_read_link_down(struct zfcp_fsf_req *req)
 	}
 }
 
+static void
+zfcp_fsf_status_read_version_change(struct zfcp_adapter *adapter,
+				    struct fsf_status_read_buffer *sr_buf)
+{
+	if (sr_buf->status_subtype == FSF_STATUS_READ_SUB_LIC_CHANGE) {
+		u32 version = sr_buf->payload.version_change.current_version;
+
+		WRITE_ONCE(adapter->fsf_lic_version, version);
+		snprintf(fc_host_firmware_version(adapter->scsi_host),
+			 FC_VERSION_STRING_SIZE, "%#08x", version);
+	}
+}
+
 static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
@@ -300,6 +313,9 @@ static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
 	case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
 		adapter->adapter_features = sr_buf->payload.word[0];
 		break;
+	case FSF_STATUS_READ_VERSION_CHANGE:
+		zfcp_fsf_status_read_version_change(adapter, sr_buf);
+		break;
 	}
 
 	mempool_free(virt_to_page(sr_buf), adapter->pool.sr_data);
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 09d73d0061ef..26ad7a0c5ce3 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -134,6 +134,7 @@
 #define FSF_STATUS_READ_LINK_UP          	0x00000006
 #define FSF_STATUS_READ_NOTIFICATION_LOST	0x00000009
 #define FSF_STATUS_READ_FEATURE_UPDATE_ALERT	0x0000000C
+#define FSF_STATUS_READ_VERSION_CHANGE		0x0000000D
 
 /* status subtypes for link down */
 #define FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK	0x00000000
@@ -143,6 +144,9 @@
 /* status subtypes for unsolicited status notification lost */
 #define FSF_STATUS_READ_SUB_INCOMING_ELS	0x00000001
 
+/* status subtypes for version change */
+#define FSF_STATUS_READ_SUB_LIC_CHANGE		0x00000001
+
 /* topologie that is detected by the adapter */
 #define FSF_TOPO_P2P				0x00000001
 #define FSF_TOPO_FABRIC				0x00000002
@@ -226,6 +230,11 @@ struct fsf_link_down_info {
 	u8 vendor_specific_code;
 } __attribute__ ((packed));
 
+struct fsf_version_change {
+	u32 current_version;
+	u32 previous_version;
+} __packed;
+
 struct fsf_status_read_buffer {
 	u32 status_type;
 	u32 status_subtype;
@@ -242,6 +251,7 @@ struct fsf_status_read_buffer {
 		u32 word[FSF_STATUS_READ_PAYLOAD_SIZE/sizeof(u32)];
 		struct fsf_link_down_info link_down_info;
 		struct fsf_bit_error_payload bit_error;
+		struct fsf_version_change version_change;
 	} payload;
 } __attribute__ ((packed));
 
-- 
2.26.2

