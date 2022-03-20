Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 072F8C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244518AbiCTAqL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244495AbiCTAps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107FD241A18
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JDj6ae017423;
        Sun, 20 Mar 2022 00:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fZN8rMdRfLaEMoDHY7wUXItpggmMdJxykza4sbnXIE4=;
 b=dBbeWkMPbqa/X2g0m0Kn4GYGZfCQ6YoCJyejHfrIxPjrUmuQSkwF+Q8xkFh0Zk4bBPwM
 +Qc+5o5wq00GznCiAHi8bQ/Ri6godxFJ7E0Zhn1Z8h0+C8Xc5BpxtUKeKImoOsRU0nla
 cy44+h5FtMGmU2zw/UGDSsM+kZhKqRmWX4oOLUjEyRiitG1XbMs633OMiHnG2k5zz5c4
 tRxDNGunGKr/lcfob9nOtxl31aWpRpNzQgnJ4n/ZdkphdDUeE862+Cp6jgLCi1bgOyn/
 DXpRbH77Zj0V2aB0wzFrrp5LT2qMjqp8Qo014Lpug9LyLvPqULrgjcI1SPVfAiqwKSGf uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcgw8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0gu5t077988;
        Sun, 20 Mar 2022 00:44:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3020.oracle.com with ESMTP id 3ew6yysr8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akkUMIfRIfuOLYxw/zKR6PvCHMDYmUpXF+jeMlaOhrukBESvJAqHwExltzp3Usdz1lxgvPo0vvZ0vKHiK97M93iTCfbHm7Xh44IeKvYtanYLF0UoWLTEyZLjn9x1sMn0rpolNehZeOyAOkbDyo+BEEu09mI3Y/84kP1FdzQL/R11TbB2ymowrret+ifw8UJiOZIunFYVm61+R+HhhEMGqRaW8OU9ekCxKzH8yw/OChblEGthM/wSi3lLL4VpiMlVxe5eVk/9vHeTW5Kd/XhFpvrTyMlhLRwlxHNdWWlM8at8uLYPfchQeoyVXVNcxjn9mekyLI0DDBJ2Bb5i1WTGyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZN8rMdRfLaEMoDHY7wUXItpggmMdJxykza4sbnXIE4=;
 b=d1fwUrXjdzP6D3pPlUTan3hbyBJF+FUlGcyGr5xzXfS98l4GkxWGNqfI/ZaCu9AMu3s3mKfTC7W2xIxR/DfbVB/mv29f4h6Ceg1+MHKg5WXVnwq2T1BLrwQwLmnsVMSnDsxmrKRfnjI2sekO+U3r30cKeefAL3EdFYUK3PAj+Tu8BEZV6LLVKVnDuuEfWLGU2ol3yznmsKJsSaWVj3rWEHZZ9khGI9BzM2EKbiqKVKTW+UoaX6VSwTxWP8tBVpeht0aY1zS+xme3iVa41+kGt5FbLbhtVtQHBT2L+CdHs0SKCriWiJi/VFvhMn1W6nP3lrg7gfhUFCjct5Iu95PC2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZN8rMdRfLaEMoDHY7wUXItpggmMdJxykza4sbnXIE4=;
 b=Oi++1YSvSy4xjtGIPMSzO3shp8FGSAdDfCiuQok4o8oia0muMPzhQKmPH8+MQ8vemny8h4OLicZjmzRofK/JsucRzR675A5wW9+lpJswOCsHBq2aomSbhY3e4NpE+UO/XB/FxMnIBWVfLf2yO8fwmuYt4BNKWcfPF7ZcfXInUcs=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:18 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 11/12] scsi: libiscsi: improve conn_send_pdu API
Date:   Sat, 19 Mar 2022 19:44:01 -0500
Message-Id: <20220320004402.6707-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 486fa01f-35b8-4a8e-dd1c-08da0a0ac3e0
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB39928C25550A5B7D1D40585EF1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1sRtou9PVqetDbPWOPY7tANY4oiMPagI6jxmB80U2AU6qoRE5g3lCvPl+gyuVWXWdwqc62CfBpGOiu3a5bR+lVzYMeSkB0n5jdtXkL4dJWBnHnbydEysG+6+efVvLj2CwV83e3aImS4wjo60kZqptOi5AVggONzbofqG4EqZZ11+mtLgZV3lPvY/gPw9K5YRmfwEZm06wB5qbdD0JG28NQZNxrbk6LyA43Uj9LPg7aWJnEITnRqO/gRkqNMkh9GBWk5XRgbwSFOXgwwopahnhkv/JoisJXJ7/IL+l9lM6/uBq3q+R1tFZ1sE9o/DDqi5rWUQ3/uR5lOHrgZ85WBwfKHFaInpYxvidclnXqx/Q8w8Dvl2eyFrcysQEQWKwt7rTYL5nenUKQofshhtlHJGNFl7z633FWgm1jDuUj2fwID5XhtigcPbWP2DVgLlB1aJNR/7kWNQ3Dsp33cQLZTX5XvRzLrnEOYM7vbUGSFLjSI5hvGmUSyN3snn7RwGP0L8L6yNAl9nPZgqW4P84C33szHgd4nsUf8zgTweuwK2ubF5TjmT9uOdPdG2CgYLHv80gfJIV/0LjrutayQW0eM6MGPicJOb+HSMdBD0AyvgI1uA8GYQM3x+WFvjNG0GSrQS1PSTntq7Xhh+QV7Ztibnaow8uAMItRKmxccJcL7N3Gfsa/laxP10pz2fu839TTFY0tIye5Z4jzxrqzmQ852QBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(107886003)(36756003)(26005)(186003)(1076003)(2616005)(8936002)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0tgmru4nH82lHbj9izavQ2ysCX2Yc0cVrwvf0ecXg3tDadnW5hNer9BtzWh1?=
 =?us-ascii?Q?sZcXpKOBT1NP+NlTPLSCg1JepG6ctAJiVSgsOWXqK7GRC0XW3LBreDfbXfrv?=
 =?us-ascii?Q?VErCsVHpmcn6UQeJLpQbC63GUM7zL0gRXrQPO2BPX0Va/SEg++5k18+j4gMQ?=
 =?us-ascii?Q?WtxTHK+zqhL5x1luK4JBABKjxI4+oPMGXltIaR6dWb7vVIBdB2PbmdlYYyaj?=
 =?us-ascii?Q?xXYs6HHMVb6i6W8OReRxI5qAlvPwCynlt9Dq7/jJl/kfS5+BRPcGGgXvq008?=
 =?us-ascii?Q?Ih3B/xKKtB0BEZCpcGLNgGpMWLQ8N14HcWgZhA3JOYCVA7UVyhL7RLMY+DwV?=
 =?us-ascii?Q?rP6WV1uxRM015gFC82JuUv0wamisWTs2YLFYu+yccr+JSiuFxKhMpLNvNA3V?=
 =?us-ascii?Q?Z1xGskE2oiBEnPsF1I/A+Uqdt+YaPFlwq9e3udQETh5c8OVtn7+PiDrxLa6/?=
 =?us-ascii?Q?WiAbQgmn9SVkM8XSTc0qwOqzQenGpv2O6t2lCV7O0ll+BhQclGsaYA1bUvCO?=
 =?us-ascii?Q?DIyrffiZhdjwqp1fCrBAxF4X9jAjtsrdGHoAagtr4mKhyHV0I0ht5ENl9rYp?=
 =?us-ascii?Q?GE9wgTTc9/fs7Y4bYTF5tNADmVDdb1TdrXaWhSDZhMrYoo+4Q+oPhsljdS+y?=
 =?us-ascii?Q?TaHzGEOQTiuLbGC2XHwLNntRahMQgDxOZ7Ct4E3UN/lll6PyKCAx2FSWjSJK?=
 =?us-ascii?Q?z01/zAgAlv1cxQrv8UqacgebI0RRmFVClcJL4A72+JB1YmBWsDg3v4c35I00?=
 =?us-ascii?Q?dLPXd45j8zehI+jEOGdmb6sz9b+VR4IVdwbyH1jQoDaJzy9IC0upB+8EjG34?=
 =?us-ascii?Q?hZn8qggZV438RtocQsl7JeIVGGAZVTjWjuLrd5l7e5jqkHuYUDu/Npm2c+Sc?=
 =?us-ascii?Q?Eg8ftPhKArxmCBMDcgeOKnOLvqVBMDLP4PHGCv93Mcl3u+I+Rek39olK/iLO?=
 =?us-ascii?Q?h++jhcNMbXUSqddnkeRKhMbw6GSdOHv/o7Rlh3HhaJuIdFGmTPo7bF8cEuY2?=
 =?us-ascii?Q?MhHnwd6Y1OkLjkR6tlz1x+2E1Ng57oxQmuHYbDr/DaPJXKXLaK1jTmu2ZkSe?=
 =?us-ascii?Q?5Po5vvbG3cYLQXn0axdEu7I+RPKRTiilq2A/USj8XWSwJDsdMuAusgaXp3US?=
 =?us-ascii?Q?QBjrF4IURb35RJQC4wLw+dQTIaGaJbUNdjvdA9G3jWc4Fn8UCLqtJIa7CIeD?=
 =?us-ascii?Q?m5bZ1tJ2XKUgvkbgtkAluMFrQp+4IOJH1s7hUQbdoU6lTiyBoz4VZEphlbFu?=
 =?us-ascii?Q?b39kxxmKlAsL61XoVPkxgJm/IhznhruvhRX3wjFSxo7lnLx9TErnv0pEGurX?=
 =?us-ascii?Q?zelvbHzf4iipCOqDMh29nMb8HsGDm34Nmqbw0JcsbXQZDDtt2xWFBN6Sks+L?=
 =?us-ascii?Q?q6SEHmpOwO0mQuWSvFdrT1CuH5wDm3qTS0yrwa1GWXC9sIBZYIwCVQ2Yv5tN?=
 =?us-ascii?Q?b82Y5dnHuTglTHZ+YQuMDPNo2I1L/O0KUP7BAaHbpbKTd4DreksTdA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 486fa01f-35b8-4a8e-dd1c-08da0a0ac3e0
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:18.2653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CgX47Fw2PNnYz1CrU7J8uO3C5SZCdHeBaGO8OoQ6aSP+LwK06wXLrhV1Fes307N4hDFgan1ajDFD3D4+lVzB6D5RtyZNS+QvI+OKUly5P0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-GUID: e6PhcIYqHenIBCEi8racgsWLQAb00kZ-
X-Proofpoint-ORIG-GUID: e6PhcIYqHenIBCEi8racgsWLQAb00kZ-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The conn_send_pdu API is evil in that it returns a pointer to a
iscsi_task, but that task might have been freed already so you can't
touch it. This patch splits the task allocation and transmission, so
functions like iscsi_send_nopout can access the task before its sent and
do whatever book keeping is needed before it's sent.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 85 ++++++++++++++++++++++++++++++-----------
 include/scsi/libiscsi.h |  3 --
 2 files changed, 62 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index cde389225059..a165d4d10cea 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -695,12 +695,18 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	return 0;
 }
 
+/**
+ * iscsi_alloc_mgmt_task - allocate and setup a mgmt task.
+ * @conn: iscsi conn that the task will be sent on.
+ * @hdr: iscsi pdu that will be sent.
+ * @data: buffer for data segment if needed.
+ * @data_size: length of data in bytes.
+ */
 static struct iscsi_task *
-__iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+iscsi_alloc_mgmt_task(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		      char *data, uint32_t data_size)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_host *ihost = shost_priv(session->host);
 	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	struct iscsi_task *task;
 	itt_t itt;
@@ -780,28 +786,57 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 						   task->conn->session->age);
 	}
 
-	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
-		WRITE_ONCE(conn->ping_task, task);
+	return task;
+
+free_task:
+	iscsi_put_task(task);
+	return NULL;
+}
+
+/**
+ * iscsi_send_mgmt_task - Send task created with iscsi_alloc_mgmt_task.
+ * @task: iscsi task to send.
+ *
+ * On failure this returns a non-zero error code, and the driver must free
+ * the task with iscsi_put_task;
+ */
+static int iscsi_send_mgmt_task(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+	struct iscsi_session *session = conn->session;
+	struct iscsi_host *ihost = shost_priv(conn->session->host);
+	int rc = 0;
 
 	if (!ihost->workq) {
-		if (iscsi_prep_mgmt_task(conn, task))
-			goto free_task;
+		rc = iscsi_prep_mgmt_task(conn, task);
+		if (rc)
+			return rc;
 
-		if (session->tt->xmit_task(task))
-			goto free_task;
+		rc = session->tt->xmit_task(task);
+		if (rc)
+			return rc;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
 		iscsi_conn_queue_xmit(conn);
 	}
 
-	return task;
+	return 0;
+}
 
-free_task:
-	/* regular RX path uses back_lock */
-	spin_lock(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock(&session->back_lock);
-	return NULL;
+static int __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+				 char *data, uint32_t data_size)
+{
+	struct iscsi_task *task;
+	int rc;
+
+	task = iscsi_alloc_mgmt_task(conn, hdr, data, data_size);
+	if (!task)
+		return -ENOMEM;
+
+	rc = iscsi_send_mgmt_task(task);
+	if (rc)
+		iscsi_put_task(task);
+	return rc;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -812,7 +847,7 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 	int err = 0;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
+	if (__iscsi_conn_send_pdu(conn, hdr, data, data_size))
 		err = -EPERM;
 	spin_unlock_bh(&session->frwd_lock);
 	return err;
@@ -985,7 +1020,6 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	if (!rhdr) {
 		if (READ_ONCE(conn->ping_task))
 			return -EINVAL;
-		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
 	}
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
@@ -999,10 +1033,18 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	} else
 		hdr.ttt = RESERVED_ITT;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!task) {
+	task = iscsi_alloc_mgmt_task(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
+	if (!task)
+		return -ENOMEM;
+
+	if (!rhdr)
+		WRITE_ONCE(conn->ping_task, task);
+
+	if (iscsi_send_mgmt_task(task)) {
 		if (!rhdr)
 			WRITE_ONCE(conn->ping_task, NULL);
+		iscsi_put_task(task);
+
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 		return -EIO;
 	} else if (!rhdr) {
@@ -1869,11 +1911,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	__must_hold(&session->frwd_lock)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_task *task;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
-				      NULL, 0);
-	if (!task) {
+	if (__iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0)) {
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 9032a214104c..412722f44747 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -134,9 +134,6 @@ struct iscsi_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
-/* invalid scsi_task pointer */
-#define	INVALID_SCSI_TASK	(struct iscsi_task *)-1l
-
 static inline int iscsi_task_has_unsol_data(struct iscsi_task *task)
 {
 	return task->unsol_r2t.data_length > task->unsol_r2t.sent;
-- 
2.25.1

