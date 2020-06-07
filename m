Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B547C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45FF72074B
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gv60k6KX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgFGUga (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:36:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51752 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgFGUg1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:36:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KWwRd125872;
        Sun, 7 Jun 2020 20:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=KwoTsfgOUMIi5XiK8kIBzQmJPWHr/NkgR3rgi97wIEw=;
 b=gv60k6KXBg0PGopHhQCo1ni5YxB1KYwsmVz3In6YyflX160lLXy9sGuFN2hQdBv7Yf/8
 di97y63iAsNUON03zoLjjbcIVjgobLLBOl7MKPTdkvJ/U6lxSYWEltLWqX9FcGv4CHqo
 70TMGhFXlfqiT3ZwHJ/AWFuU7rxQyKQyEWtzARrwDgGqUBM1xcNn4RgAhieiKiUurikr
 xNGfsnlkwaxwptZubWbHikX4MFY+eNcOmDV6luQdibjc5SoiUdh9QPlkdDIHaXETeQvw
 F4p/eWuGFn190uAsJSIKVge5WWTIoOfLgR7TfLoQQbYyqAgvDCEyJT+hb7dvVMRPWpAF zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31g3smkxfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:36:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KRjLn075744;
        Sun, 7 Jun 2020 20:36:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 31gmqk8a5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:11 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 057KaB2R022720;
        Sun, 7 Jun 2020 20:36:11 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:11 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 03/17] target: add helper to parse acl and transport name
Date:   Sun,  7 Jun 2020 15:35:50 -0500
Message-Id: <1591562164-9766-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=2 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=2
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006070161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The drivers that emulate the initiator port id (loop, scsi vhost, xen scsiback)
do almost the extact same parsing when making their I_T_nexus. This adds a
helper that parses out the acl name and port name from the user buffer, so
these types of drivers drop prefixes like "naa." when they need to for the
SCSI SPC4 TransportID SAS address, but then keep it for the LIO ACL name.

The next patches will then convert those drivers.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/target/target_core_fabric_lib.c | 73 +++++++++++++++++++++++++++++++++
 include/target/target_core_fabric.h     |  2 +
 2 files changed, 75 insertions(+)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index e89b3d8..81ed7d5 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -423,6 +423,79 @@ const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
 	return buf + offset;
 }
 
+/**
+ * target_parse_emulated_name - parse TransportID and acl name from user buffer
+ * @proto_id: SCSI protocol identifier
+ * @user_buf: buffer with emualted name to extract acl and TransportID from
+ * @acl_name: buffer to store se_node_acl name in
+ * @max_name_len: len of acl_name buffer
+ * @tpt_id_name: Pointer to the TransportID name will be stored here.
+ */
+int target_parse_emulated_name(u8 proto_id, const char *user_buf,
+			       unsigned char *acl_name, int max_name_len,
+			       unsigned char **tpt_id_name)
+{
+	int user_len = strlen(user_buf);
+	char *proto_prefix, *name_start;
+
+	if (user_len >= max_name_len) {
+		pr_err("Emulated name: %s, exceeds max: %d\n", user_buf,
+		       max_name_len);
+		return -EINVAL;
+	}
+
+	switch (proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		proto_prefix = "naa.";
+		break;
+	case SCSI_PROTOCOL_FCP:
+		proto_prefix = "fc.";
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		proto_prefix = "iqn.";
+		break;
+	default:
+		pr_err("Unsupported proto_id: 0x%02x\n", proto_id);
+		return -EINVAL;
+	}
+
+	name_start = strstr(user_buf, proto_prefix);
+	if (!name_start) {
+		pr_err("Invalid emulated name %s. Must start with %s\n",
+		       user_buf, proto_prefix);
+		return -EINVAL;
+	}
+
+	switch (proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		sprintf(acl_name, name_start);
+		break;
+	case SCSI_PROTOCOL_FCP:
+		sprintf(acl_name, &name_start[3]); /* Skip over "fc." */
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		sprintf(acl_name, name_start);
+		break;
+	}
+
+	if (acl_name[user_len - 1] == '\n')
+		acl_name[user_len - 1] = '\0';
+
+	if (proto_id == SCSI_PROTOCOL_SAS) {
+		/*
+		 * target_setup_session will want the naa. prefix to match
+		 * the ACL name, but the t10 transport id only wants the
+		 * address.
+		 */
+		*tpt_id_name = acl_name + 4;
+	} else {
+		*tpt_id_name = acl_name;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(target_parse_emulated_name);
+
 struct t10_transport_id *target_create_transport_id(u8 proto, const char *name,
 						    const char *session_id)
 {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index af1dd81..0113e1c 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -125,6 +125,8 @@ struct target_core_fabric_ops {
 int target_depend_item(struct config_item *item);
 void target_undepend_item(struct config_item *item);
 
+int target_parse_emulated_name(u8, const char *, unsigned char *, int,
+			       unsigned char **);
 struct t10_transport_id *target_create_transport_id(u8, const char *,
 						    const char *);
 void target_free_transport_id(struct t10_transport_id *);
-- 
1.8.3.1

