Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9C7C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244126AbiCHA3T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiCHA3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99A7B7E3
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:11 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227L6kZi002124;
        Tue, 8 Mar 2022 00:28:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=dkxSE8XILheD5w32F7QW8Ip6616IdJvel3Kn3kCo+6c=;
 b=Q9nocIPmdxkesaSgb6nCmk0RykMDqfiXoWhm/XvlEsAX54dnF6kyjJ2/QZzkD8lJuAmG
 /7cjilmf6wVRarm7b/MKqkkCpa8JSO25EYqqi96N9S1Ga+b6pocmSfqgaSXVO9rDn0qj
 1cs3C33IZf2Uz4RXmDIZ7Afu/NsPd94TYeFeF/+QxaRtZCDfgKJkjZC8SF8xIzKYvgk8
 dEogmdj7iXFewahWp//W2/LN9m1R8pcoLrAAc3MSSDkgKwDpDCyPaw9/PMsZC6A+r1Ld
 P+oR7eOhRPxVYJgSPwKnEuro5+f66NTb101Xz5eeyMRJiMrZb1Mu5y6gU/E0y2MQaG8E Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsdgks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AJ9D134548;
        Tue, 8 Mar 2022 00:28:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hrq-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHVszXsa8bKj/x/hui1r9kPTeLGVRfzj8rwSUsc01H0hKNonTPfA0YWfXi0scDIL7SdZinW5ffNiNYomJBsjqZeTRqToX3zijTr1J6wFY1lkDWl+LjVPGz9xcN1M0X4tebknhmBE93wXZByS5sSn2nQNrtPM5Ew6NMFuCs9uHNNqk9vGScetqImFOKZ/tik9mESQFoQIbqsQwT45EFnX8dSjiKPWsqjzHjTmqhsp/J4zqsQVs5po58CUHoWQ1jB4YVVcAJeg+lLgyYxVnp6/UftFYn1DC7yET8HTTvjwjUmSJjYyFO9ylHFO9n+1VJYr+FoauYBM+zYjvKYNT4lYpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkxSE8XILheD5w32F7QW8Ip6616IdJvel3Kn3kCo+6c=;
 b=gKQR3GloojSBKzuFd04dNXXGlH4SaejPrlsMJ5ZLVi+O0uPhOfjB/vJSUI9SK8vVtE/m+NNyp2Bs5sdvunOC+NjMPcp4pLrLMv1NHitUYCigkzFz3kMv6CIsGu5bySQ6mazH9IIyJ9isBWurmsWXLV1Ip5orBErjOG4zm1MC/tr6xe9Kzd3KDm777+gTsrBFQ06D+U/i+mZf1HuPGcrT+At66nv2Jpd2Nbm+LQGK/sFiaEob8nAYph8d+wuF0nAeF7YIELNob0jI4nOcquwS17EzFeqJuUzfPPTFg91UWu8E1KCfo30RsNieRwgj8HItFsU6ez+hEffs4CsbqsnZYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkxSE8XILheD5w32F7QW8Ip6616IdJvel3Kn3kCo+6c=;
 b=EuSxnXDKP2C3d382Z60qdQYPD+LQAcr/Yuoj4xSrGV/4uOnCsl8tPJWdo1L2QsAiwmG7DI0UKY84tw13Q/VW6WmKY7k7Lh2nuG0fkfwfGMmPpC9ZjWL2jk7oaFQD3vXGxuk9ifE+flKFNhgQznHcXnTiOHeAOxQuHz+uIXcZ1jI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4361.namprd10.prod.outlook.com (2603:10b6:5:211::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 00:27:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:27:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/12] scsi: iscsi_tcp: Use sendpage for the PDU header
Date:   Mon,  7 Mar 2022 18:27:41 -0600
Message-Id: <20220308002747.122682-7-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: f21d4f09-267d-4678-9167-08da009a7f28
X-MS-TrafficTypeDiagnostic: DM6PR10MB4361:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB43612552ABDCA3F1C10E0E8DF1099@DM6PR10MB4361.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZE6KJius+x7Ajk/q6RtoyJRAaWKUBEliJUMDCQ2LDIN9tjFuRP4v88o/9ztgYGmEelCEEqHqjI86sUpw8nLY4OmLoq7HSG9TkIxkL4JaEu/m9VMyCg8JgKmsLbiURGR8F+jliIC2PPtH/Rz4+DvJzTY4gmTnB6Etner8SwBOxpAt4XTPePCcsOKbtV4DpYP1SIN52wFhiSTHp6MHlJeWw9povIrg2cdCt4AxqVLhYj2/aDRPO5yZJSPvBdRgwe3y9E0wp0BscJeuV0tlGP3+k1S1sV5QDppNiqIfR3PwztY76rM3dU9e11Lzvrazek0u0yFPHDANr0ylAYgzKP1/1SBNJqtEy9xI8kZVtTWm37DLFPejwun/akMf634QEzkIzU9yvWog2ETMEbLYWF1iQ98NJ6fXTrvR6rJ/IKcm2zNrRBaJSMjgPDq+MeDjQ15BOCQ71RzhqzYgeE130f+dVolkXlU3mXstzU0F6cFvcOSmMsc6xjFimaNlObtl8SzbZ+DAHYeQd2Cj5eQdHDruPDnmp9O4hDFj7Uk1+WQaUv3p3VpwHhTuKCJTDWx9xZYtWC/rn4WO0jktKU5TbfkItu53v12WBoM4phiiC0kik1BkTfdjeu/IjrsTo34amWXbyfoIKlDJOucgCF1BoQ8+EQViWw/7PMvQBLR2mgJh0f2EPUWhITSu6Y3bzRyy6EKECe6HxeXQfwWcK4xzxpgPTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(508600001)(6666004)(107886003)(1076003)(186003)(52116002)(86362001)(6486002)(6512007)(83380400001)(6506007)(2616005)(8936002)(5660300002)(38100700002)(66946007)(8676002)(4326008)(66556008)(66476007)(36756003)(2906002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uXHrtQCNaIOn9Ol3mO4dfgkQ4E7tVhf4ORS7iYj1r+hPtQr96iXs9/fmE9xe?=
 =?us-ascii?Q?oz4DFDNOjbVqpSdjrVrnBMULGsAzPHSwKUV2FXj3c4PGcsXYcFEQPJJPte0t?=
 =?us-ascii?Q?gwFJjHzZ+Aj91RFBCBkHB0WqDzE8fKe/uhdv3HKtxuqNCv+oaWVjJKC77apc?=
 =?us-ascii?Q?8isAT1JSMXbrvIEOODoPp5EMH1DHdjH7n4FqJxhSYzNpEUmM1j62ez8BrhA/?=
 =?us-ascii?Q?RTP43DQ8T73ir+Xf83Er8t4kaWEKNt3zEaWzW6WXAHM79ZLxBhc8FRHKXx9L?=
 =?us-ascii?Q?rzivAwW0/BUZhQzg9EmTxT28hYZdmCbVAkvbIG5F8z/054wRljIKJXrr8yb5?=
 =?us-ascii?Q?NFanvIFuPGF4xHjjLFnbMzgg4gUZBTXjYFIi7JFVit97NN8aMIVHqLOrM6ND?=
 =?us-ascii?Q?imGDjSh5lOts2NpKJSUL/vZf5WfNNpdEfD7HnIxp5hmvkUKy692utxkxFD6g?=
 =?us-ascii?Q?3Q3J8jfXU8lL4e/bfwTx8/wXe6oRLIi/HFutiAKKqE8M2j63Kj8EmzeB9xqa?=
 =?us-ascii?Q?djbDTN4l72m/SETKh+ixh0CHhq+FC9XFyjk5yA7350VhVbKXiTMPHpDV9Ysg?=
 =?us-ascii?Q?plQpJV6zboh5eDy2F6S98ywItdM25iON5Qw/7HN43Ge9xEpiWIFMrOR1yJpH?=
 =?us-ascii?Q?Q7fQi0xVzOT2QxK+DBY3tkg2hN+lXiqFrLh3GRqdlsUvLI7Vriy39BeXOY0v?=
 =?us-ascii?Q?HCm/WHyByixkZz4Hi6hlEkHFK1IiX30HiGIx+gfs3cmRKWR95cEHvORVdm9H?=
 =?us-ascii?Q?yu66kNRxLAht70I8dGU1CDRi/JXJlbT2VthVfw2xixKi13RW+PxmiHZYnC/+?=
 =?us-ascii?Q?MpeJgZdiFJm1yrp7lxcAtMuKv8/0s8Tnq6XKXhx4wiWLSZ2YdG196VvwPskD?=
 =?us-ascii?Q?lgGeJAdi/ytZQ7uBMEkysKbYiMZ/HLt1+QWbKy0y/2a0QmXs2G5PbSTxIcPq?=
 =?us-ascii?Q?KmWz7wzZHVZIEQG76uhNf/2vpmM/6QTVnM8ENo18gSIDgvOytQXSHRRYpk7+?=
 =?us-ascii?Q?6QEZut7hS11zvrDDBf4nduEXMTxACvrSX2V2Z6Eyb87P758dKrR6GC0qXO3C?=
 =?us-ascii?Q?1VA6ZXVqR3R4mEb9Ec+lITzOTr0WbTVz/6li3PWWp6959LETnHUQ3eAFEnBC?=
 =?us-ascii?Q?9DY4dLSFEk8gI1Z4IuEJFRF73H6jmr1lcIzC8czNVvgSIPYMvOmu32ly81Id?=
 =?us-ascii?Q?yXaF63Ju74rbuMXP3p4CWmLWpAENw7+P7mFb0YVho2TSjP/sT2swLw6DQtIU?=
 =?us-ascii?Q?hevgkTtrgprZ4WoMCqcVtQOfXo3J86LqYh2Bw3QNq7hXMrKpEGorHg0YauAb?=
 =?us-ascii?Q?9Cxy1QydqLuFB9hJkaAKJkezvOQLPIPwD38sUbhXuccNaJqalwdkLy7772ZE?=
 =?us-ascii?Q?1sgpWkNAeHQlAN5jBK4W81GtFo0bOfQcHN+kgnIEzlvGVLPBe/+3M5qOmx1F?=
 =?us-ascii?Q?B924qn0xnMudSqHyvjpOJxqUjvSD1DSLAcWCXJHUD8kTQJ3e7MFp06GnOj1j?=
 =?us-ascii?Q?cfGd5UhDGM8hl104eXMLWXurdcqNZ3/PmPktKoCaHhyIGUlM3GomRy9+NUAM?=
 =?us-ascii?Q?lQVE/edPkG9+nIUBzx5Eoz61ApudYbPbdH1MKbof5GMIW67eYSbgYPpt1WMT?=
 =?us-ascii?Q?0ZItwpPEDGqxGSV148E9YsXx9oJg0WCcv5sOz8Vem5FuQFOK1lwimafACzXu?=
 =?us-ascii?Q?8VAPrg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f21d4f09-267d-4678-9167-08da009a7f28
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:27:58.5768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UCeEZ18U3IFPQLOCRaB1dvRLY8HwOYgnio4CQCk5kdm9pselF2lQ6WCykBKTmBW7n6RbPyXQE2qsWVSHqd7l3JYnVdkWSkWFS/uJF/VsqbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4361
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-GUID: w2pwl-pPiQCv4t4217gYz6eN1XflRk_W
X-Proofpoint-ORIG-GUID: w2pwl-pPiQCv4t4217gYz6eN1XflRk_W
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has us use zero copy the PDU header.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 261599938fc9..3bdefc4b6b17 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -306,7 +306,7 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 		copy = segment->size - offset;
 
 		if (segment->total_copied + segment->size < segment->total_size)
-			flags |= MSG_MORE;
+			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 
 		/* Use sendpage if we can; else fall back to sendmsg */
 		if (!segment->data) {
@@ -315,13 +315,27 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 			r = tcp_sw_conn->sendpage(sk, sg_page(sg), offset,
 						  copy, flags);
 		} else {
-			struct msghdr msg = { .msg_flags = flags };
-			struct kvec iov = {
-				.iov_base = segment->data + offset,
-				.iov_len = copy
-			};
-
-			r = kernel_sendmsg(sk, &msg, &iov, 1, copy);
+			void *data = segment->data + offset;
+
+			/*
+			 * Make sure it's ok to send the header using zero
+			 * copy. The case where the sg page can't be zero
+			 * copied will also go down the sendmsg path.
+			 */
+			if (sendpage_ok(data)) {
+				r = tcp_sw_conn->sendpage(sk,
+						virt_to_page(data),
+						offset_in_page(data), copy,
+						flags);
+			} else {
+				struct msghdr msg = { .msg_flags = flags };
+				struct kvec iov = {
+					.iov_base = data,
+					.iov_len = copy,
+				};
+
+				r = kernel_sendmsg(sk, &msg, &iov, 1, copy);
+			}
 		}
 
 		if (r < 0) {
-- 
2.25.1

