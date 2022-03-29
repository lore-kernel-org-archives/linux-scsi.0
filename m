Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DDBFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbiC2SHZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240414AbiC2SHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:07:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626E5B189E
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:05:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsKZT022190;
        Tue, 29 Mar 2022 18:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=WYfCC13MYd7QUwbyVlWNiC65FQBeucz6JPSge6nANr0=;
 b=GaB+Qec6r4jyMnt4gvBovHW9v5lWwrvEoBiRtIKctsy0GIExiIjxdd0CTCwOzDJ5yWvz
 OwdfB2FJZf9XvcNEUh3RGK8fZOWQJ9yR9HcaR0t4KB/opVasrR+ESh/83Gtx9IOyIVIB
 p2iaUvC5e8nDVMM5pMJn18ty4XUAZAXOxwm5rm2SVKNyJgZ2095Ncz9AbbPYARgyySrZ
 Go09L5sVIyxlOyD94z7yHuBcBtBEsZhFS9V85Ax1UywGJIycK+ltYOYLXDfQyu223fqY
 OBLWa4hVxvu+t2XDqlRJeWa4O5UptFA5S46wqdTAEiPjeets2b07Rn/mlxWGQy1hC0wm Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tqb78tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THuk6W127683;
        Tue, 29 Mar 2022 18:03:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by aserp3020.oracle.com with ESMTP id 3f1tmymau4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhwVZL+20uuS7Huaie8/VaHAR2tkyFxapqiER4dk7j0jeHGzvwsa2tc8gPbChqLIh+PAqjfZ/eA8tReAUHWXqxA5vV6WiimUS7z8ryMpugnYKAtmY9RQC72GrWNavDPv6qwocqOECp1CojisAkTSVJbSRJvGliB0bCv7vKqyAu7gc0pKvoY7olE4w+6SqJK3GEN2abE3Niot0XguQbfulMeWIHQ/KnopBHYbPqEel+OhmnQnQi0wV+LM/UPdl9P1CO6xDiRMfemaZeD8fRhqV1vpRicEHBbTACAS0InoR4+5WnHZ2uo1z2CPHeeM3PvodsnmfAM4YISE+tiAYnvrIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WYfCC13MYd7QUwbyVlWNiC65FQBeucz6JPSge6nANr0=;
 b=EdfNUrRW4lZvezXhimc/iPJTS+kf9iYQBUoCeXffFJqj/V9mfrWcZReApHCXHaQdI6Zokkr9nIedu0V2FTIt2mRzrEKZfgji1UKQHOITUIY8PlIui36eDcq9DWXJW55nf6cw5bXOBFmp8GQ5/fsi0gzZe9M8k22cM4Y+9fvProKiEIzE4TNr3HO1/99UfB7QiEwNotvI667a6y82NgyfdHH3fKgmP8bEb+LlIzT7wevNbt+C7Q91wz7FpG9wmnQnNFBr+JWX0pAAbf+sAOu+cCGwUkvAPOsXB87XHlZELfgwVr6WXjEl4dFV+AmaLIUrkzv0QY29+niD4dI51q4Bmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYfCC13MYd7QUwbyVlWNiC65FQBeucz6JPSge6nANr0=;
 b=Run825l7Q6C84NkES3gmz63ejAlPIU/pbCewo5cMF4jfSnpJezg0TbiWFbPsfK/nSOqx2HGKRiu56IY2kaXnO2l2rM38fC0XgK7NVYm/A+Le6Q4yc+x+v8peV20jQzxmnqMhkKIpA37y8qDSpZ2kYGZunCiSd9N+ZUJ2G/nuw6Y=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 14/15] scsi: libiscsi: improve conn_send_pdu API
Date:   Tue, 29 Mar 2022 13:03:25 -0500
Message-Id: <20220329180326.5586-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c67fa7c-7c27-41b4-fe1d-08da11ae756b
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB35848C06BC828B57D1D34DADF11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z6DNMQ1PbD08mnpL3/K210ecS6h2DnyLuk+ADvK/04bOyx/fwzI/zgQpsaX2pG7bze4h0dWpFl5fPbboN5okSUV1eNV4kNGRiYgvOh58hgybpARVEs5oe2BDHIqA7FFsWSZZCLknhZXV2+k20JDXVyrbNZjs/Mv5Mh/rCbkg6niiBDEScbFk1WVuNil1eZFCo/YlN05bnjZjtVIGIYMqdaoh8QbdYybI/lnaZR06UYzUOdzf8D8L21eWeC/a+KX8/zfyY0Tzq+PGnVJbNM59L/1IZHCwRfm6W1RBRDChHm/zDiRDBgBh20Br9G5yr7/+wKvOv5RMTDfCmoQTNTwjx7u4VL64HcT6sC0+xPkY+fL8JnQNR9PWUe2A7tNQBZKYJz4kgmieTMlQFTrq+wCVxqfusUEPUP3CQPRKR3k9gKkvMYRHadctomYnGg7BSf0iBDpoQ9a0edWCVorry4yc3vaOmKynITwf1yM2MCNV+mUsno0GOkoysDP22GNRD3+dWS/+z2CapT0SKi2SdBP9oD3indC+SPtYgtWEYru3xLindoHLtGYk8YXBEZ/Bt4jmFzVRzRIQyusixphg1daAaqD4lSmM9dwEmQ7i0f7GQzj9OoueTVM9y5o06zy0RGwFd4gPDhzpE/ZxnxBuisSairT4+MyQU+aop4v2MJBGdUS3u07TfZTvsKhovar/WgM+R26C/bkmRZxFElzgZwaxCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rD7T6AnoXXMP+CsCe2+Nbo7x8zWdUzF0Tw1VH/npvuo2f36wyq/+XVjqtRIB?=
 =?us-ascii?Q?DvI+wltHKLjs1dJiHLVzMSvOjxkM0RPqnT45FAaHMeWnFa+rIV3VvkoLNls/?=
 =?us-ascii?Q?zChj9h+XLVdAZNosy7P48EMIeuDUbtyqnehdnKoVEgCiwHUlKtSGHeTHluUN?=
 =?us-ascii?Q?d7pI/lp/WAEdOT6UN6J+KfLbmzIekeZ+cqzIjN1Q9lBw96bei4wsGxG47QZx?=
 =?us-ascii?Q?c1dnIQd1KrAuq8F5/SiSJFUKDTx0Rup5FnR4TtYXLNnmDaDFVToWnaF8/fD3?=
 =?us-ascii?Q?RcndTE5YvQ//gk7TanGf+NzbhWX3raU44UOTVdpIcn3miNP7Hwy5I/ywSj6H?=
 =?us-ascii?Q?BVq1Q49IZcqmFCh+rFAj5hNOI/GLj/ycLpQM2wlNXQP7Il8+xxMLIplhGhMh?=
 =?us-ascii?Q?qrRi3xhgtkDZAdL5rKnw5BPE5oi3+7PtQccZWePdqVMyWhDSFM+8JvPhdEQW?=
 =?us-ascii?Q?ahE8ULT8OpojT1aOfyBjXD38YgF11LmU4V6QsqGxvJJgFflDbUb1WKRPT5Ea?=
 =?us-ascii?Q?/6VT8wwPzYRfO93Vzyz+E6BRaj7u6lWl/2l99KDmfQ8xfzXcpM4dewHAsUS7?=
 =?us-ascii?Q?Q9C8O9cANyy3wLjDJBtaOBjJ/gi1s2rdMkt4YarQto8LhFGicx9dRLnYqO21?=
 =?us-ascii?Q?/uJ52UgYnsFvkpVJr4ykWDefwbpZ+XG/jf9cZ87c6MNk9Xs++wq36cP1fVB4?=
 =?us-ascii?Q?xzby3LPA+v6H/XJUzLRn0jnCKpvoJBBq29mIaPQgPl2GkvtIr99MqRXrW1D0?=
 =?us-ascii?Q?UDUTocRxTkPf7gJR8SuZw5B8ThIzGRhF0xDP3GceyqrJrAN3WyHB8Amdu+34?=
 =?us-ascii?Q?ws6c51nu4gqgU1ut+iP9AgBTiuq0VhpzQq03hg9NchviYQRBtODGMF56TXnV?=
 =?us-ascii?Q?VcOYQx9AHUmPUAkSAGbQUBnfsT5r9wpaIrEMDaiJa1ne+xV9N7oGRlMJNLJB?=
 =?us-ascii?Q?k7KlRbH12Moxy9enudp2hHGZkrIvoel97v+Q/BrysSskfNMS2G/8Ar7BLn2L?=
 =?us-ascii?Q?+PwAu0rw+g8q4ARgFn/bwLX1MztWwfrUwSxib63Mddfdo353Vg1dPJnHpZJt?=
 =?us-ascii?Q?wfkIrVwnVNjUggPR8xfPw+3TcQPmEOu4I7eyjVewOk+aNoJ3j6Nh4Iqy07TR?=
 =?us-ascii?Q?vARjuQPBtC/oRMaIj8Ycfwcs35x3UBOBY7T6Nl2j+Q1a8tMyku/10sbwGgxJ?=
 =?us-ascii?Q?nbdVaj9/b+fafw9Z9T7jsQdenMY9DhN13lL2mTMMsk3GMMdlB6E3EVVKxfro?=
 =?us-ascii?Q?ydBnTW5Z3GZiI4IZRhr0yX8rL9MNuT5S3Xfdf8XQASKJdV4HeoWR5gATfaDB?=
 =?us-ascii?Q?Ve4c7TjCq8+w+b+ZiccErQFO3xZEzMHak21ANsZnE6CBkIomL6fcpSPovX9R?=
 =?us-ascii?Q?/eaBZziP1ZqLopUouT20zADKwRdZonutxnQAVzjpk+I65PfWOht2UlIypI2P?=
 =?us-ascii?Q?gAtu1P7PEP81c3wiHBINl0DacYiOq633OIY3aQDn/i4HQEde3u1VwaoqNjd5?=
 =?us-ascii?Q?1BYiwbZfmtU9qn6DQqh/0v6P4Sg/1N0QF6VWb04fsMOD1o69W79anlajFNdA?=
 =?us-ascii?Q?abXruJ7Rp2LewXHJyCBBsWO2Qi0HV3tbIrc+JlKaWlcteee+B331fevg0kjv?=
 =?us-ascii?Q?JfuFbB2+m7LoGBQGwNm4xBih4tArse+ogzGqATVDOX0ScGw8cnFfNKp/aRx6?=
 =?us-ascii?Q?V55is/FJrpb2lVB3fFjL8gVgSbvL7S+iL/+61PIPF55dldyaux3VMyujAX+B?=
 =?us-ascii?Q?TbwrLPe14JLjUt4BMxHv+G0LiJblUtc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c67fa7c-7c27-41b4-fe1d-08da11ae756b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:42.0058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: //ijW3YuqeSkRonOxZjSEPjaodl6LnsZNaYPZgqXSLeQ+nrYM8XIWyEHS22nDlb6w6YNe79oWKOmZgXjM18CLruky/ttHpowh7xepqem0OI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-GUID: dap4-9ZdcFccSzZoD-m-JKav_QZmUGTn
X-Proofpoint-ORIG-GUID: dap4-9ZdcFccSzZoD-m-JKav_QZmUGTn
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
index eede1f88a407..5380216f7c05 100644
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
@@ -781,28 +787,57 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
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
@@ -813,7 +848,7 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 	int err = 0;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
+	if (__iscsi_conn_send_pdu(conn, hdr, data, data_size))
 		err = -EPERM;
 	spin_unlock_bh(&session->frwd_lock);
 	return err;
@@ -986,7 +1021,6 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	if (!rhdr) {
 		if (READ_ONCE(conn->ping_task))
 			return -EINVAL;
-		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
 	}
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
@@ -1000,10 +1034,18 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
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
@@ -1870,11 +1912,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
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
index 97eb793f4c55..46e026153292 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -135,9 +135,6 @@ struct iscsi_task {
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

