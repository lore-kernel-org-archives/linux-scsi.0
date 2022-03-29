Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6BDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbiC2SKe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiC2SKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:10:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9592B1ADA0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:08:49 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsDHC029587;
        Tue, 29 Mar 2022 18:03:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=cg3mDLxHSNZm5z0U9jnw4HdMWMJYX3xC0x7Bpwgs0Iw=;
 b=Bdt47IoM77wN0wUIyX2xlD/6rITxa7nO3qDEI00GwEFEkv29G5vjb7hDpXHFQjo/98e5
 Tl3LidGbEQ+cNG/NOXEu7L/CbU27OdJpAC41GjtpeEnU5HjpoTEMJlzt83ufNLy567xS
 IvD2l4h0XIlaZ1DCwpmSdaIRj67EOMOxIR4CEIiv6dXalDfnXhlb6HDGa53YGE48gY6l
 cg+oCPKB0jDY9B+CNd8VRs+IG4JzGZsN6eDLZCbTS2gX4EVb0n5y4FlrXPD1NgNeiDsc
 Z4G/FshQ+gN9bFkse60ng73arO+lu5z7ckx0gMA8qhRBX0ZelDx0AJJRu9Ym184J7gzK xQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1se0fcv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJJ048570;
        Tue, 29 Mar 2022 18:03:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnAkyblm4HlUX9Q+XWV/mQNj1KwFk7TPvN5CCWrdCchI48O4mRRafmJNsND9EjnqHwbmRc0qe/eIcGwetlbEiyZVejNiDIxsGCHw3bF14JfdIYfhsXMNFOGxfdrdDbNApREHaNmVhO5l41ytx4rv/EellFQ1w2ZNgiWNEVjaGTFUnYVSLjVqNRvcQvMmQlFLtkrdFWscQkSvUQ04jmSdaCkBgXA1FueqzaunqA+DpZO94NSZT1nK0CjQk6e6Ko5+Fet8aI0lMqj1wTgIje+ZHzN723wOT+Bqtav8yYzc4qysCf2A+yyMrANUFuVYetgTn1JUMuRRHkOIgvmUTA2boA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cg3mDLxHSNZm5z0U9jnw4HdMWMJYX3xC0x7Bpwgs0Iw=;
 b=K35Gq43QvU+Z4J2bns3/CuEhDmTUF5i/fT5muVX/IbtzWcpbuWhYvO6HcqI1NoC97rTEo4KFtKw/pB4LFcLuO4gB3WWGnqtoS9iJcUWxjFbT6Jp0W1Tobn/jivsCUMGzGJYzg0HNY/iAn5nKeYAOYbs7yCmZyoNxSrqgMR4oeU8Ek5SKmtxCA+Mh/dhMdGBIO6MStu5knMDnT++GfpazUKQOsuUANGHY+nJjDcDZ7mc7usnROaCBFgULbAo575iL878uf2qhSp2xix4wsKF5I03mf2tLSv0BwOhr/qIZZgoZWnwITvy/cjfos2NntBBlLQ+B8URKn+fMvJwBaFFXBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cg3mDLxHSNZm5z0U9jnw4HdMWMJYX3xC0x7Bpwgs0Iw=;
 b=NsvFQMSLwLwErHpDw9MyhTI+3Sh2VkFbXCGOhADxHi/AkrAQbDPOefSSXJOQGvzFtnHJgTOyayw+YCE9/UaPyc/FYBFq7BtCsvo6oH8uPSvOBrgqK1+sHo0XXyYKX3ck5z5Nr4Azm9D2DeRQ8s4Kk33bOLO+xRUbNqRjDe0ie3Q=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 06/15] scsi: iscsi: Add recv workqueue helpers
Date:   Tue, 29 Mar 2022 13:03:17 -0500
Message-Id: <20220329180326.5586-7-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6962af4c-cd90-41a1-e0d1-08da11ae72e5
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB35849274BF7A81823184A03DF11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: laPJqNBlNG5oztSt+34GBdVWh/vXudMviPUeOseIE/bY8m+2UrTy4sM7wHkswFEOqsPnB4idfVGoF/HXOE6F59FXRjkSFwJx8H5229ezd7dwzpBGTLg0Z+wv+MDza23zsY5BXpCp2PYLWc2o//72eJhvj6fOFLd7su6u79FLDDiRlMM9Wze5TztgAaKfjKqHxUdNxnVrCtM8Rb+sz+KXIzz3ulScVuRap4Yyy7v/1U+A9r/nRJCTVE0/nts7TkUEjwCDp7c5dcsIjTS3moPh/mv9CMC+Nf5Dbkn/v2Ofwm7L1kH5r9PRlO8wBvTbC+O/LS0dT33mhJ5XO81pNIW0HjHDbmx1fFJBr6CQf9OmVe12Sy4qs24Dm5zJMVzOHDy4c29LzrkUaLe3YN3T+J0D6uflhuyHCdw9M5bgxxUsdCpDKd6hyH/IZYhQTt8caPLEP9w3gaMltzxFGYyJySqisJ93t7r9+VHn0RcRsxHCzA9IAHI9vPTsmBvIxtUeC5p9malLHlG3/wZ8JgDifD/SLFpU5wzN3diig8lbX/nqX1+we9BQ/qZZ9UjoPCzt8Fa7LZBeCLxR++8BuzHI0539seVzu7JDfkmvg3J3m03/pfiGkz6oFjII85JKvKyqByQvIEsTBs6U2D4qXogZo9+dmWR1A0SnJlHlBDoh7KUGfXNxZD+IHbyw0XUHRlfGJtWvrN+10Ss3tJR0Pq24pD9qfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qwd4AysxffVWnk5aJRAaJiRaJg8uj8/EZcooFseBTSU7nkvEWbXo1JKhjSTy?=
 =?us-ascii?Q?vgarhCnJTdlpnTm6I9rMyyGHVW/D1lUCWz0Qn5eE4cYVy/Qscc0nQsqLkDa8?=
 =?us-ascii?Q?9BTWLBNrITpdN7FJfOTAbfO5FT8UEfaZ+7TInsn4n76j20AF0cZdJZrsGxnv?=
 =?us-ascii?Q?GX6+fLATPFPZwn1zxdRiG1k7UZFFYReSLT74TKcGYll3eFQGchWLGYYx3dlL?=
 =?us-ascii?Q?QlPJB1ueqgSOMaBYci4nD0zdinD2LQ2OO2KCiTLmsstEO+b7W+bq3aeDE/zE?=
 =?us-ascii?Q?xsVoQu5VMdC1q71CykCoaqcSoM+vdyXvVRZntm2fUOVni//2SoUsNuI8JQq6?=
 =?us-ascii?Q?mGNw4jJrufeGk2cq9UnK1W3Eyi4WZLhh+OFuNT5qXqDFU8O0KfgLDf/A9xQw?=
 =?us-ascii?Q?t2no8zXlW4OUcaVf0k2D/ie6Q8nz2IW24WFQ0S5msl5T658ofDjmxtwfGtik?=
 =?us-ascii?Q?0gPTt+jQdQsapWai1QNl8ay++NecEBl56qyBnE2SgCxuNrwEPS3RSg6TWjEv?=
 =?us-ascii?Q?BZ57Equ0qzwzPCGRzBVlL3z5oACYIEEZHwnV1Quy1lEkuDKKvdmg0wXw/+Ny?=
 =?us-ascii?Q?7VUbR80WYZ1H8CuCVr9K2IzYszDs5dKnanPaku02fr4/145BvCGI/QUfbrqg?=
 =?us-ascii?Q?zkjpuz9GmI8i4GGJOoi17QTOrhybX5zlt0UIu7k7hkD2citD5Ba7GtP9LerO?=
 =?us-ascii?Q?cFOo2x1jU0CqLGKGc4D2NHuXv//r405RRE03RUhfTwVhIRebiDJD3ZjIDbOr?=
 =?us-ascii?Q?DiC+16jyfrf4St7NNS+5O5mNUITc9VjUa3S2RnxXvPGGl3x0H+/1chC2xGeI?=
 =?us-ascii?Q?oOd4WkimAEHFq8kjLXgY3Bsv51hlwEQVzyyQnjVK14U/xX9Yz1JnK4cR5Hgm?=
 =?us-ascii?Q?gp/Kc/citP1ttM5E+kUDRiTBqANt40HWWiPOjO/PCxoB5doUEImvhPhCkGo3?=
 =?us-ascii?Q?9LmW0sqAMLI+DFLK5SlgYyPNeFxa9Ow3vxAPxiUBVzkUJ4wGLt730k3FSgEe?=
 =?us-ascii?Q?PrlHDwcY1bly3MYKdcw2/5sFZV8EXUnJMvkK15mFHMgT/K7kflXD54AZZxC1?=
 =?us-ascii?Q?nB2oc6oPJ20A4+/IMDzhH5fqpep0XijwUuMZld5h/M8Y/uC4BQQQwujclSxZ?=
 =?us-ascii?Q?Ro7D3dFZ8HJEUCgzBTMwX9Ek6zkPCU6IIHzrLcjfwL/m0oipB8D72QKkDgfq?=
 =?us-ascii?Q?AGuY8+qbnPGjVvVIBw0SwBJHT21AyZCCzIEbr9czcDoMEOjtEyNkJkdCQtjp?=
 =?us-ascii?Q?TXxK3JNN9Iz+s6HdybCiD5UzxHpkwBAs7+wSTHARQ8S2/0QS1guA7/69W0ah?=
 =?us-ascii?Q?yRMhTxIk6yp2aldKy7nrxPduzvjhPOsUZp9/lhmlnm4Q8LR3sFGNfOnlhHwj?=
 =?us-ascii?Q?GbD1bnaSZN6fi3KmuP+130br1AYGtnB+W68xaID6ooL/wm7dOFNHOIXDeaJ3?=
 =?us-ascii?Q?C/RjrjdA2hpPFaOva8wvB0rFrxZqv+LvSMkd3U+D/5DnM1ZdNXyavXDwxJOh?=
 =?us-ascii?Q?RprrpCNRxV/tLhwTKP/SHZFW90X7Ojg92jMRdBnYoQ3Se688dxI2Zgg3JUds?=
 =?us-ascii?Q?/vHZo7715XpmOm0f2AgaId0wJlj7y8fWpLh5a5wxmiklWGJvo7u1ng8lq2w1?=
 =?us-ascii?Q?1AwVuSe4c2zOzYPj43taGcZtLxUTmh1x2rwD7+0k/N6+IlffC1baNYTY+4mb?=
 =?us-ascii?Q?OK5FXuuV4YjUodoiJgugBgDRsNzzWoLW5Uxxs4+b70NNjN+V6QN0wdPfzslc?=
 =?us-ascii?Q?6CZ22mRh8Tf3xTuG8P7GNxr7/gYBm64=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6962af4c-cd90-41a1-e0d1-08da11ae72e5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:37.7402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cf4lu9uh4LpRte+fT7g6I8IdrMVFaSjUSIHLpXu8EG8vNtoM0dGZ5AubYGEBGVLmI0m8LxPzAKFeL7mQM9iY8QevAiI0Mq3Wi8+PZNR1Mvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-ORIG-GUID: 22263bw7QVwpFJULUYTh4wAehu6d0d1u
X-Proofpoint-GUID: 22263bw7QVwpFJULUYTh4wAehu6d0d1u
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helpers to allow the drivers to run their recv paths from libiscsi's
workqueue.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 29 +++++++++++++++++++++++++++--
 include/scsi/libiscsi.h |  4 ++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f86cad75a68d..3701f8d7f87e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -93,6 +93,16 @@ inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
 
+inline void iscsi_conn_queue_recv(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	if (ihost->workq && !test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))
+		queue_work(ihost->workq, &conn->recvwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_queue_recv);
+
 static void __iscsi_update_cmdsn(struct iscsi_session *session,
 				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
 {
@@ -1943,7 +1953,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
 
 /**
  * iscsi_suspend_tx - suspend iscsi_data_xmit
- * @conn: iscsi conn tp stop processing IO on.
+ * @conn: iscsi conn to stop processing IO on.
  *
  * This function sets the suspend bit to prevent iscsi_data_xmit
  * from sending new IO, and if work is queued on the xmit thread
@@ -1956,7 +1966,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 
 	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
-		flush_workqueue(ihost->workq);
+		flush_work(&conn->xmitwork);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
@@ -1966,6 +1976,21 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
 	iscsi_conn_queue_xmit(conn);
 }
 
+/**
+ * iscsi_suspend_rx - Prevent recvwork from running again.
+ * @conn: iscsi conn to stop.
+ */
+void iscsi_suspend_rx(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
+	if (ihost->workq)
+		flush_work(&conn->recvwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_suspend_rx);
+
 /*
  * We want to make sure a ping is in flight. It has timed out.
  * And we are not busy processing a pdu that is making
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 91672c89a794..09bac9e3efaa 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -213,6 +213,8 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
+	/* recv */
+	struct work_struct	recvwork;
 	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
@@ -452,8 +454,10 @@ extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 				     enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
+extern void iscsi_suspend_rx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
 extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
+extern void iscsi_conn_queue_recv(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
2.25.1

