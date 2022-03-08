Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCBB7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244099AbiCHA3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbiCHA3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CE92715B
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:11 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227L8Mej009301;
        Tue, 8 Mar 2022 00:28:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=goRruGcVkEQo+F/UncRqU/pNkHQwTtve9jYrMqMS1Pg=;
 b=jeGRwwfqf3cOc6N88WBZ9KFCPHq4QWfes/QCNosjNWCiBPAVyuABT9ajI7z9LF5ARZ7F
 MH2GmQr3rBZtBbZK/Kcjl9M3Y4jIP+4zcBaHhDbMoILEIboCHAZRtINskk6AebJzHCuo
 aaTcjV+GZj7BJaClSmQxuA8bYrUaC81CkJqs8JD2j9Xm2JXrZFyvFJfVhEwGaYssOr2I
 ki7NLH0QZqv9P5pWEzZaVBM7xoxcYW16Ckf4FO+4Gtkrobg+dAFRC8uYfL/kuRw38d7i
 dC3FG/lNZakCLoEgg09lNRnJRCJCdyHFRP6QaFA4DRFHK1fVqEi3C4phVF0F8iPIFFbS XA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cdf4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AKl2134578;
        Tue, 8 Mar 2022 00:28:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hs1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBorKfGmy8fc6yDlPvoTvrSfOtrQcgDN/9QOO9yXmLNdMrgn/xkOgAfVyTUjqDaqErSOL7QC8fkqb51RXmm67KdZ5eEmlcYRJPThYu+uvBqKhbJNaKAR+n8czfIrw1B/FaVsyC26vn9bbMK3ANhaPy606yr7vRN/lFxgx9yCkFGtu26Ij7ZgHiaADJoCVJduI5KN3LGMmdPovMDbY7N2+gd2O4pxaYw5+sXuFWAsLtK5mxZiaGEsNS8kwTf/AFe0TD2de8jadyMXAZ42bCZa+qYOV4gviHihvF/S8fqiPk+sn0PD1NkKENVQU0dVTwN4jHtzx4nI8h+eD1YNWAHVzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goRruGcVkEQo+F/UncRqU/pNkHQwTtve9jYrMqMS1Pg=;
 b=a9Dd+/JKARdEwvaLSQTovERrrcG+sUxWfrCOHgJHjkQr4JM/yRJmBE+AufYeZqh+WoDf7Ktd/mHJ63qcxz50untwK5IX/QCFJOh9TxDy8rQJLfRW4NiXveq+O2mzg16HppQ/j1BQ4RARjpBoP0zDKey4AJu4V/NRzEiW4uPgMe5KouA26FDtV/jLtiKbYt15yP2uVLUVrEW/iRjirJ29Fi3zrSfQhLuk43lXA0FRClT8U7aaD68gNHdgDx82ni4TRPv4hfd+xs7JPuIijiX/1r/kO2Vz2JfOIqI1hpKyEOpqOVcYS7hMpPdDWkMXhPHo5pr82mb68dOsaqVFztAkQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=goRruGcVkEQo+F/UncRqU/pNkHQwTtve9jYrMqMS1Pg=;
 b=D9WoXnc+x6iYTcUSrVGojMGTPDZzm2p+x1N1f6YgMtJ7olRDQNJceEoUEc28MDskLDuo2ndzcN2uDmaCDll8cW+wKGonhadhtH/kbZHF8b3S9ZMptn9jhYmzIxhWNd/Lbt8rmhngiShtkqKb0a1idl8DFB1Ws9LXiheqlYLpwuw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2809.namprd10.prod.outlook.com (2603:10b6:5:63::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:28:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:28:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/12] scsi: libiscsi: improve conn_send_pdu API
Date:   Mon,  7 Mar 2022 18:27:46 -0600
Message-Id: <20220308002747.122682-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308002747.122682-1-michael.christie@oracle.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e106d56-96d0-4ea5-3398-08da009a806f
X-MS-TrafficTypeDiagnostic: DM6PR10MB2809:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB28096D711119978F001C67F5F1099@DM6PR10MB2809.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8fRis3KBh9bEpa2mnFCLLjjnp6/JlpAyTBR2v49H/Dq5lgqwBE9sTe8s6WIoCfT+yAVFIyLn0iC6UFft0nBN3DzXZyubHY8LYewmG1QS430bnbkN4VA33kdlrfb1gVTVXEiODLAXzJ1d4esMlXkDRwDvGTREKOAcYpXT1LTDpaGPClZ60p/4hbaGU3CLiKfiP8R8EV6mshqsDs3LibhXn+viNSAiWtTeMXnmCjuOvIYkgmqw9m8Nj/mwuqSN4Tna7Bhs7hK+uwNWDxtQkhxUinGfyWIGsbtFwPjiKvlC//2m3XCr4ZswNYB+85apQ4km8oDm54HGGnCR3V4MuYN9XZLcYQge79wD2PLM0/+i/5eILRIQMwGuXtRwZC+5YZY0LQb2aQDlwFv1E1mytMm+z7h8hi9F3ban2d57ELMibAyFMSGgiZevtlieb+zvkWoyW+yFet4US0DfZcm0KjADIetpEtYROKfrng1wdMB+UaiXJVb3GAQsY3nP40+EJKpkzwQQTmPRK046yKzNkt+1Y/u6oy5PSOzVbSxXs3HQa3FSVgzIS5z0Ul1l65jZKv9H/ghC8Rb19JzENIfKmqNc6oH3Pc/lI/61oZK5ou5jq7qOgJjS9o40BFvjwsEVzlJt+NiszI7/UB8bw0HZ0c6VbEX0QnVAqJvfjkLfiw4pcXmCrM0vdh21Z3X5U7zfdQlCdlXjLLY8JJJRHovaMNlsUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66946007)(38100700002)(66476007)(38350700002)(2906002)(66556008)(4326008)(8936002)(5660300002)(6486002)(86362001)(316002)(508600001)(52116002)(6506007)(186003)(26005)(36756003)(83380400001)(6512007)(6666004)(1076003)(2616005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rFGj7PGIYRP/R2Hz2wCyMsBJZe0rty1X+cuWtbiLCtFGcpNOKf2mlg0KTzAv?=
 =?us-ascii?Q?Zp1WgWL7iGZjPqOwTbfA46kUH2aevoe1F9j5MSPL8/XPhm6itXPiMoK6qJi2?=
 =?us-ascii?Q?Er7a9nZOnNWLD0MrdDnbAISENPjhlzEMvEIhbDDAn65B2Dr9TaY7//wSGc0j?=
 =?us-ascii?Q?Pm9sYTKSbcWYfpL6qfk1tX47xIra+/3CtaAwk0Jb0qiJikiEwgGEfP30qZmM?=
 =?us-ascii?Q?Vk/V0hV/MOyeIfYI22ujEb60wm+rt9TPcHcEUlWMUtjhKSqzARtyuHIpcXVL?=
 =?us-ascii?Q?UmDUYchgIfJ9VuM95ASZZvPfyB/eF7NjhGqlQ2BpR3BrEreEw1+sFhh1uKtY?=
 =?us-ascii?Q?osg4dkUtrPp3S+8UBEYdh0vGIkWySp1MsvceMwAPJw+qNjVzIpvLWh20E/QH?=
 =?us-ascii?Q?UupciDcig5L9jl3nsnn6fRxT/BIh0FXwtUxLeu0ejYmWCpP+fg83Lw40uRCQ?=
 =?us-ascii?Q?32rO/QPu4Zrh+IPULLfGlJChkpidORVs6GG+1J96e79N/roJQq4+q0Dc07ZZ?=
 =?us-ascii?Q?gWvH6OCeV+WQ0Xm5T1/hPAmtkfOgh3aS0T3YaAXmdiBtcTiQSnuL3r2cPuIM?=
 =?us-ascii?Q?OkxmODr/xO6QDYsZHaG0h2L1f+kEn0LCxP2SZ0LyXL4f5kHQb3DtLKsaLzQB?=
 =?us-ascii?Q?cHN6nrI8LO/vMwZSq3Zl4OR9VX53GQo16b4ucBsadtkYcA4Jw9uXDNEDimt1?=
 =?us-ascii?Q?ZsbbDMzngCa9DnRULobwG7ywIq4vGQWZfE2T/M1XflyCYUa/yaNzD90t24g7?=
 =?us-ascii?Q?a/jhVWL04RaO6QZ2wLdfuIMD5KPHEDtWNsDnz5KnVU4abBAM10YpT2o5m7nr?=
 =?us-ascii?Q?BLN4Ma7NNbTfOPim5c/tVAp8NROPEqBqDMyr6GCDF3/EOfuQeo4n6l8ccfQq?=
 =?us-ascii?Q?PXCFgxp1RfsJ/NDJDYlAhD1XPMSn8QnVzPo0f3sCcabNicMtgMINjWSencVN?=
 =?us-ascii?Q?mx5ctoixY4VBdLn7JV6bDLcrot42KbBU5/o193Tg3syfrQpH1hAQDeQ2g+lD?=
 =?us-ascii?Q?WHYzfM+Cr0t6GcqLt9vFpafI4FWU/i2lTVUv/adhjaBvk+NSOqivx4bY/kAj?=
 =?us-ascii?Q?MKZLb9DSXYHG60MrLJe9LLrdrsBoyIJwZ01rXspsIjfdrnBJg9FvffV7fVrg?=
 =?us-ascii?Q?WJYUH9241UrLuMbmFHgWB3TrIPmAHBxtRQz6eqd15/t4OYScoE4Lhq9Btyje?=
 =?us-ascii?Q?18dQFuFhFaLDsmkBDA4F3Cbn1cJVkE3I1+a6Wo92Jpm0Bcj98lNSbHerTWY9?=
 =?us-ascii?Q?CmhjRzRVx7D1sbPIlYTtqd445RpqJf9yG1yRsBvuvTUeSAeyKBhw7LBXKOkZ?=
 =?us-ascii?Q?7+EkjB0HZYWv7PXd4OEVfaWb/6vPSi/zr23awfUSGK5i+jVSblz/Zib8HCMb?=
 =?us-ascii?Q?sYzVYJ8vP1pCuVwnOVjB8ev/6NBcjXju+bSXZI+fqqBgBy549ZInNv0lZpOY?=
 =?us-ascii?Q?aSCqtxJrpVxKlYgMtQ2UbxNx3BGcd1sDjwv8Q8yHGOEgi6Nl84DABe7r1Ynv?=
 =?us-ascii?Q?xPFvv0uymKvr0EuvhhaQqykx7uDke8SyetPuE9ro4q8RpS8rbqjcuXImNsrd?=
 =?us-ascii?Q?0wq3b5j/gGpN92EHXlfu1iJXMCwL5SAgPKuRtxLgND831aIRhOYe16K0TsNx?=
 =?us-ascii?Q?Gs2QwwK33xXEVgfwohd0yqRHhTmorcQW+3TnSviRnpXS5g50ta3aDsatAYsv?=
 =?us-ascii?Q?Uv54Qg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e106d56-96d0-4ea5-3398-08da009a806f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:28:00.7487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nap4mQ6Z055pPBLMs7aIzwwQrw07m+hzlVBDdbp0tSfXMZRiOTyhfiVgB6w0P4XQWWfmXZoesgML7BqVYAbgciadD1ud6oi1g2SP9c/20zY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2809
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-ORIG-GUID: PbYkpdQ8xEzFjcrnNj2j4ADk4dhfGJRx
X-Proofpoint-GUID: PbYkpdQ8xEzFjcrnNj2j4ADk4dhfGJRx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The conn_send_pdu API is evil in that it returns a pointer to a
iscsi_task, but that task might have been freed already so you can't
touch it. This patch splits the task allocation and transmission, so
functions like iscsi_send_nopout can access the task before its sent and
do whatever book keeping is needed before it's sent.

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

