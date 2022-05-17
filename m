Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB95AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiEQWZx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiEQWZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A6452E56
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:15 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKYLpD029125;
        Tue, 17 May 2022 22:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=OOpU95j513/xmh5ldZxVMaUwQztUYGtfyOuLzQG0DVQ=;
 b=CzcS3ZZcS445U8kZaaXoJk8BUekfNaBTA2yF2qi1Qz10ul7HCCnCkiG4EnQLXmPpJanp
 1k3Zi8/JdQtRsG/IB9TnsVqJ/9qV4Bfm6msf1JGDnz4UsVGavaqd3Z1A0CEAI5ryPDfC
 DVfNMAekDRCE3VVjVvvqHlpVVQdn5XKmSJtH7wWWMc9NZThZbgqb3IlWrLjDrtAx8CUs
 jntERZUPJKtiSPRuy/M/84tIVMkAZGrU94GJShzzMGqbBlPBwCoLdGxL8wJAS2+q8x6S
 7baJ+7b8+Kz60ze7WUfTWjAUFoOshus51yRob6J3q7O3SYGUXfp3+CLUcLqamfr9MWNE Dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310qrmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMLgi2031743;
        Tue, 17 May 2022 22:25:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cppmnb-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hyy4o0aw81cdrQiO+7/3hBCnxY8rtxarfvBDrNQRfJtWjpwnwNVG4NjyTwYT9d6upJSymOI7CvZSFcL/wwKG3X4AjYqH0ZBOkXBeFbviDXCnZvKwFF+bgISJU7WHl7JtXfWQ8or9zwwssLRe7oi2lk3sN6miGcrGi2hNApDweBoKvF5wwonwldp4wpGA42glziVW28GBbxNtHxRO9hn7P5tt7DMkyf1r7hfJkbRHlI6VQAmwFV7RSsXQKFDkjFiTx0aQyHn1R0ySvaI75YaL4uk1xlkiT8XI5YCAzJiCRHjjISDDer2JcjsCX+h5ppUkEJDTYP/iqGGyrJgofW+RtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOpU95j513/xmh5ldZxVMaUwQztUYGtfyOuLzQG0DVQ=;
 b=FpyRabprSFTfqodWufwYTEU87g8WsgpZHVlRaYk1+ZYRcZK3dsH5O4p/zUwauVTXibaLc3v1WjR8x9lRwkhykPEAyMjbUw0YOXlDOPKS2W7MzZVMR5Ize2xOUcjpnRP386QYr+vHkoreqJodiOGK8DVoxRPCAsVUe8hCsGsdIjfNq8WUhJnm9NnxoFCNz67AkFGcO2jhnJatZ4j5RSz5F9eTkqXJkVYJuZQfprjte8eTziqNXwtn5PUPuI5wPwPJjJ8cJdzuq3znZ/pLRJiIRMVSy9q1VdZ8QRAw/In4UomVw2VQHwpQBWfmvsllS2duzL+9h+56oW5Og/OSNrMHiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOpU95j513/xmh5ldZxVMaUwQztUYGtfyOuLzQG0DVQ=;
 b=O6aH8ZlvZXL8q5kWzbjWRsDiUiBy7RnXI3gr2PBOEaKtYDGp2HrJPGNR4Q22lAtQi7gGXctci1hXZov3imSt8bw5RZqv45mZYXza2lgANmv24vUnjpER0r1mlwOwoKs64aGKZrwswlRVUrQpAmMUOpcpN0PGPIStgNCaVTw30Lw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:24:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:24:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH 05/13] scsi: iscsi: Rename iscsi_conn_queue_work
Date:   Tue, 17 May 2022 17:24:40 -0500
Message-Id: <20220517222448.25612-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517222448.25612-1-michael.christie@oracle.com>
References: <20220517222448.25612-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c532fdc7-ea0f-4cf3-a961-08da38541345
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5517CB3A3294D4AAE7A65C7DF1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V986Tr9USjo4IvHq9AYz3QumrsbQrPLYQSQlgr1Wno80bgrYskCUKq32ZinwLpinIiYtkZMR9Xs4LOIszi2Q4lKnwhJ4kXo0V/Kf32QQLnsvWP/aKWtoDHvMngdj+SHQ9ztwLtQtZ0qj4smA65knpgmaiZMVH5t+U7z/EZ8hbJHNKhPdhJTBH2gmg0pbI79r/BMLfd/5Hy8w8/bkqpC0S4MIqWQY1l/pON3OXbLMwPeFanMRvioHx3XPwrB4bZZ83GoWnqGH9ddOBFFtyoytVc2qF3v4ZOVK8euv5rMA/iuuL4KlSntFBERlWQ8azrhY34aYJJlHTNYKDb4yqI7vkG5eDfbo8bGAquOpXEKvn+8YjgOUWX4WB/EQbywovhzLv6B+FRvysAop2icwTkRZ+Es4BupxVMicTLoGWCb1d8j9ku0XXoZcVOC45fErboGVofwCzSB3d8E1JS67lun53DtEgQV13dtKqed5/IDaXJUTNqf6kKw8VSWcLSzStrSgIn/Lz82Ge6ywWTih+ym2SwfARro5iYzFKpXvxEsayS5aXoAR3A8nhA1mS5JGHLydTFb51DutC42vOCyg/zuo0YFV77ndXS5O4u1P4ztYMgBhBwwQ/Auv7WuYubF5SioUtFHmlT1nJbGUafr+ZTryPx2LnUYnrCPihNmRUryyak+S/DdXzZC6l9gL5yLhvLIDTYH+qwJx0A62FMEsaB720A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(54906003)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pdC9pwyDGMnIRcv9qlxyjPoApmBAoPzTkZ5/RRWK1gOUmbqnUcrQznR31/4g?=
 =?us-ascii?Q?8I2Sd4Av64/C7iQ9WnVXW2oqn7j8PSE8uFiCeuxJ1AJp2ftroIR7x6/B+B8D?=
 =?us-ascii?Q?WJ8VXH7u/XQo8BlKUNMN88LAog369QWSNJGEc0M0OZnXzxQX0hrCjt2ofZ3f?=
 =?us-ascii?Q?VLRyAvHomk8NWogOv/ZlGz6KJjsJ/XwspBOIODSqyuRPmrwQhf4wD/tUdu5p?=
 =?us-ascii?Q?sukPixrxKgg2NWcv3rCGt4xdEOwlZtX1OqrTA6t+aDQr/2kfXbFuhH+wYd9/?=
 =?us-ascii?Q?NgWRqzAzxa+sGgqB7dpT4QLQ4mQYRnPcJHnIgwGTk7UpKs6Nv/7wAIQZKXge?=
 =?us-ascii?Q?OVsCce+WN9MHBzZIaCpy070cfVJuWzoCJae89grzg2dzKZJ3ejbKBs8DQdY4?=
 =?us-ascii?Q?sY6UxXGehLBeAynaJGxvcRh0HezRJHV1XBxFm9XpiNaItNl/S1FUz07B2xxz?=
 =?us-ascii?Q?9umuS6zmi/bEqccZEsIp76C18YWOX5NOBchjaSJcq/uwh1BsgghaYxhPesES?=
 =?us-ascii?Q?/fMJ6bmazPqJN4f3g1UaIla++UJrgKAgsjAknG9RymgI5lVKPPqX9z5/5RjT?=
 =?us-ascii?Q?MUdPqb/3/3L7M6zwKeDEdy/NJs5Pk3PQFBCvyCtkiydhDIHqVR1vpWDyc5oz?=
 =?us-ascii?Q?I7/Bqwsd0B2ZyWH4zvB5OkzVNpN7IFwQlYSFonkQCIjIE9bWg5wpRTewW7uM?=
 =?us-ascii?Q?IWlw/YQ/F/AKUvOOpIePa0kbemUMNP73+6we23ObWH56bqPd4q+SalXBEbfz?=
 =?us-ascii?Q?KN/SH6uJyi2jvDcj6WhAd3ApmVal0ICcCAZePMXUrXbUW+beVPgszaqfmT16?=
 =?us-ascii?Q?tJxk1jDdTgOtSA6dGPoLbFx0Tzxlxmoc4fDvz87Gbuy/Ea4l+JDO8D5Fu0Ge?=
 =?us-ascii?Q?23e05WBnHZI/zAObm3TSnH4PxWslCzGM1DuE3BmVJChoVHN7Cn/EPEctY/qz?=
 =?us-ascii?Q?qtLgPUlUYTiq4sratddAxBTE8lf9ILAGn5tEUqVea+WpwlQa+/cqTifYr4QL?=
 =?us-ascii?Q?R3ct640c8eCuqEV+/ALO3HBJ+w92rjijppbJ/JTvwCX13f04EybZbFBAZbK5?=
 =?us-ascii?Q?s/SK2uFEnWJHqS8HLWphvVsi9Vvu7RLlJdGrP6T2oiSsZRvMuoGQ1ZxbIiGc?=
 =?us-ascii?Q?j+utUXEX3cfIyJ5oqB0l0uB/v83aXFE3FI+U5e8oblCzWiwVa37pVPjE6i2u?=
 =?us-ascii?Q?UUfx77oSGBk7S/F/wkIZ9fFJVhgbfOYVp2ozjfISeqSJAmTc74KSfKPm3Y6K?=
 =?us-ascii?Q?5u9QY7i7XdT7xqS99IjBxtW056uH0ui7Ry/5PHlt5NEfWhodaq6vsBOajebT?=
 =?us-ascii?Q?npbOYNPQLJ1TqD3bY+3bZfiU8L6XwF7TkrvruaDtZr8gFqqVV6at7Z8ANyPH?=
 =?us-ascii?Q?KPRFWdEMynMBLhbWsK3/AiCtwJ5V+JLW+w+oTSVB/kGuRw1TeX2hNyS24gLL?=
 =?us-ascii?Q?fDYbrFXwOPCqCee3+4o1WRBSIM4PlKYtrJpw9YeTvI8fcEm7PVyU3QbqyjaI?=
 =?us-ascii?Q?pA/mtgRmeWC/9rAgXCDJOJogGtDiQbYvZ1GYX8kIoI0kQWH9ARcDQvKNCHKA?=
 =?us-ascii?Q?0xDf5T+5/JxkCBImK1aiSLzwn2WraEfllGKXFjViUJnoGzIOm6jfBKJLpzwG?=
 =?us-ascii?Q?BlpAtahCljqD00QqFxXj9Zf3I4pfLqWiymEQ5J2a+EXYi7UxieFdoLKt5Kh+?=
 =?us-ascii?Q?TV/UKosmPx6BwKgg7uW8toY666rL0xO7w77JVfwo6iR0OlbqVitBflJxZLga?=
 =?us-ascii?Q?pB4bfw0URfYXRu8o+V7BrqB4wC7bUU8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c532fdc7-ea0f-4cf3-a961-08da38541345
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:24:57.9805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FrYrloQPNb+5spUH9pTHPkEanNpedjzwLzDNmKoyt4x5I19XNh528FkWj3NBedCSSer2hO5EGqLjKeFHPXDE0ns/PiLxIKi3wE9S2DQso6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170129
X-Proofpoint-ORIG-GUID: YToFj1dsKVIGRCMxtXsBnMVpK6aSFDdm
X-Proofpoint-GUID: YToFj1dsKVIGRCMxtXsBnMVpK6aSFDdm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename iscsi_conn_queue_work to iscsi_conn_queue_xmit to reflect it
handles queueing of xmits only.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |  2 +-
 drivers/scsi/iscsi_tcp.c      |  2 +-
 drivers/scsi/libiscsi.c       | 12 ++++++------
 include/scsi/libiscsi.h       |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 32abdf0fa9aa..af281e271f88 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1455,7 +1455,7 @@ void cxgbi_conn_tx_open(struct cxgbi_sock *csk)
 	if (conn) {
 		log_debug(1 << CXGBI_DBG_SOCK,
 			"csk 0x%p, cid %d.\n", csk, conn->id);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 }
 EXPORT_SYMBOL_GPL(cxgbi_conn_tx_open);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 52c6f70d60ec..da1dc345b873 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -205,7 +205,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
 	old_write_space(sk);
 
 	ISCSI_SW_TCP_DBG(conn, "iscsi_write_space\n");
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 }
 
 static void iscsi_sw_tcp_conn_set_callbacks(struct iscsi_conn *conn)
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3ddb701cd29c..1bd772d9b804 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -83,7 +83,7 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
 				"%s " dbg_fmt, __func__, ##arg);	\
 	} while (0);
 
-inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
+inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
 {
 	struct Scsi_Host *shost = conn->session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
@@ -91,7 +91,7 @@ inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
 	if (ihost->workq)
 		queue_work(ihost->workq, &conn->xmitwork);
 }
-EXPORT_SYMBOL_GPL(iscsi_conn_queue_work);
+EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
 
 static void __iscsi_update_cmdsn(struct iscsi_session *session,
 				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
@@ -765,7 +765,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			goto free_task;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 
 	return task;
@@ -1513,7 +1513,7 @@ void iscsi_requeue_task(struct iscsi_task *task)
 		 */
 		iscsi_put_task(task);
 	}
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
@@ -1782,7 +1782,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		}
 	} else {
 		list_add_tail(&task->running, &conn->cmdqueue);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 
 	session->queued_cmdsn++;
@@ -1963,7 +1963,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
 	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 }
 
 /*
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 471422641ab3..cd1049393733 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -453,7 +453,7 @@ extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 				     enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
-extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
+extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
2.25.1

