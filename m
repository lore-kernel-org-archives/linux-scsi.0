Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0B7C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiESAgN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiESAgE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:36:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCEE2191
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIlnP007800;
        Thu, 19 May 2022 00:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=OOpU95j513/xmh5ldZxVMaUwQztUYGtfyOuLzQG0DVQ=;
 b=W+BjEI2WE4XO70HYip2KRX/+1jDiON6iMjdqx5/7vFWZmsd/wtTwSBoI0ydeURwZVRsg
 Eam+DX1FvfwC9ZWPsXaEYBrryi0ouS+LCt48kGv0q6bEr70mrx2fpiZIwdxspjE9l9vE
 KBBYtVnoAybcoR7a3QAg5FLE3wBu5fIZzY5OUzFdqVpZ3mgemCTLrgejWObOcgL0hg+e
 pwl0GLiWqHBpM+9NRN2lz/OaEK6SlHFn7bQ6+tBOK0bpcuEiPq/DzRLlMt5EMhJZvb4C
 mOAPtJLwmQMau0Msw8YhVuW8kqNc/Zstr1wMOmuiesW0a++1hic4sS1Zqzph5Gv0Avoq /w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucajj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4VA015306;
        Thu, 19 May 2022 00:35:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eU/5hJ9GgNFmtjFTo5PB99kgkHiALlbWdJAPR+A3vwbyCP3MP1FANc+P7MjkfpJbFkuXHLDr5LoNfjiaCNyuh358v9HsIHm0yJWqnxfylSq+vQqDFkv/Tf4yjVZp3Y1vs1XnGv+8u7XtMF/MUBNAlSpxI1TUkwP3EuCLYvXcTtoFOLzf5Rx5piL1w+LytxKqUOaSzRy4VkYQitD8EybD62xzsTcRsABlGrAGJCFfCZ3WJiID140Io/if6BRwCpnVMw8WFW+F5DcAhUFtkwi5wsJB1IHHIAZrRlCREqBlVV0j9tuaMHgXZMb0Ye1DXP9ohkQsntSbqJRlOqfc2l5Dgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOpU95j513/xmh5ldZxVMaUwQztUYGtfyOuLzQG0DVQ=;
 b=mqlSbptHofQ63IeJ4Kb9SpFLK+feRMkKA5KdXLHMEUkjGgIWjR5maZpeS2hqHHsW6By07YWESlN2FMgBc1YpOAELer9AgQFagdMf+Yq53XdkIaSRUAjDApngODI403QFhogiNlIfAv5AYb3j8iwyG7rlOIdeCM9BAJLO2W+pZvhlhM/+DkSv/a4Z3GsenQoMksmC+eumq9Pnt7fl2F2DHPXTh2GXAgFTjHbYILkuvgXUyyKUoas1WyQlYzDI2EqptkBjdkRc4X76xqe3ks5IY1JFqGNlXdRpJ2xMT3vHMJLCODGSDqWNOdibBpOPxZ9gIzxIf792j8mqpPwN19QF+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOpU95j513/xmh5ldZxVMaUwQztUYGtfyOuLzQG0DVQ=;
 b=Fvi1BjRthxt60OoNpKHWZ9tbEMNtVzc8U/vBDF/Fie3KKoRLFLEtITVPcdbAVamW5B7whjoJxONUW0sDAsI4ekD+r8hhL0cqlfYR9L998lm2KNd8erKn2cOYCm11nQ8YWEWYK6iUcD/GYnKudeKp3fenhIb7KyeEXa9d62FkcfQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH V2 05/13] scsi: iscsi: Rename iscsi_conn_queue_work
Date:   Wed, 18 May 2022 19:35:10 -0500
Message-Id: <20220519003518.34187-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cdd3973-7d55-42b4-686f-08da392f78c8
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3020D82F833794C52682A090F1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u5EMr3Tt3ZiWMM3nlq1jlDYNwwXg7RsDyzCeUBSnick9CHGyBJzjuTimMNZ7CQbKXyJjtbj0gNgs1PFIJp34/ANOvJLMM3kAsb7jo1ZNUK0Rc+26ezDuJoxbMQ+Glw30ExTm0Xl+8L/csvnOcAHypVxz/1F4+msrYntCAxoXqc0aVaGdVHF1s2BmXjBeVDFCptUg/H8xcO9xkkckRX4dn3VmKE94mJlcxfz1yfAbpKp5os7u+HLfcCa1busIQqgaVAInAo5i2N1KXF8aJQuwlbQw2rWxNwBy+28ueSnesEHqmJZAhJRgDwtjicBYedd9tId9b/apIOm2gIYDYiCSdt9Mxhq57614BSQlktXt5K8tTXVk9757UbMUSse9+E9l8B10elBsMwj7Ws4EkQQfYe0arDc53IgQhDP/HzxiyjtDSuh7YsnglcT4VVA6GhaU+2i1xjkB88+pSnJ146H6IdeixagMCERyhsL3XDJcwWb4fA8sRq2VhtZUWkYPSvuVqTvi23lLSweKFvaw8A9Abbo3UDCXK06lbqMWPvBgdqvDDwVLIECS9btvEBLZDB1NiFAwuqcNPMAOcB3kEFvJg8ctZTXEq3fye3QTjKSBdJG9cb6S23rvMBFDNkXrfYvY2qooexfPgyrGle9ko/huLkIWqaehu6P5XoeVbJU8Td8sCfJ6+FTY1aC2PLIoDkPhNfpNtjV5z2Ge1FDQVP3cMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(54906003)(186003)(66556008)(1076003)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A+TQD9OgCcHGNv3A/FWzhwmrjXVfRm2mFi+osN4ZsFsjcRaRS5w7SMAnJpfN?=
 =?us-ascii?Q?Qf1XIKv3uen5y+ORQe3IBDkTk1h1KbEcxi4vCC1h70LM81b2BKiAUsyA7IRE?=
 =?us-ascii?Q?eRPl4bLNCNC7XN0ovk580ANDS5YHS4791xevsdZhPk8ncYCZMi3U7tj14ZLB?=
 =?us-ascii?Q?QKgnpZQilb0KcidFKZT3Ax7XmsvVRHp4DPCQBbQLHdXqdAgws3UsRd5X+idH?=
 =?us-ascii?Q?/wTYZARJ6WbHX+UG57MzwAu/r2NQLgp1C3wtHzOuH2erdtVAHvaiqV0pW5wn?=
 =?us-ascii?Q?kNjarGlhrFY2dxBkGRw9xlSoKoklJo65mIH66rjOeFw7wRfHPMZGu+BJzoJb?=
 =?us-ascii?Q?snXhOKlvTKztvzLxaNHId1SRbmfy1tyhmxozMazYSMICjvfYisVKAOEqlHKS?=
 =?us-ascii?Q?3txcPc3f4NHCqQsssVFucMCmrfUqSpqe7TT4eOk1Fd5pFZ9XaLQPm0Jb3gSm?=
 =?us-ascii?Q?t8AyVAbbCXSO7u3txrBkPwPlBrQPbOUXpR295MlpdcPtsJOGVHsTEvh+fQYd?=
 =?us-ascii?Q?pyy0W2Idv+Mqx8uJplg94k+bY+adjnPaExFqqOlu/Mh9XCsvVmD3mCbAzw15?=
 =?us-ascii?Q?FNeuFnMGZOvl+JJnHsW3p6f/y01E7plmr8apN1MBX1YTTfYtkv20R5Rkc6lR?=
 =?us-ascii?Q?60MQB0MpYwuCEKinzXKCghOpUT6QpANI5fcDxz3fGEHdGBEOhMcdSTrkMyG1?=
 =?us-ascii?Q?l1KZVTifK/rPMYyyP7BQU+2AC3pwcKbG8euyX2KovsSqarBPbgg+IvfbYgsc?=
 =?us-ascii?Q?jQ6qTAscdrKssv7f9UdD/OO6RehmwJFAK8gX+pDnPyEqxqzNLGy7ZFVOli6n?=
 =?us-ascii?Q?e9JQyqo3e2ivo8XYQ/qIS81cNaV8VplhXZGZWaXgYvwJrgAJh0GKaqrLPZxv?=
 =?us-ascii?Q?Nc1LggHNnZJWp2wz7DcoA5BEvLDlFtRgagf1Zj7r37bVMk5yROGa622yBFAk?=
 =?us-ascii?Q?aHgmdU8ZmreceowFZHRbv0DqVSc5ZViO48uDILdaFqZyF7q0OUYCK5Gr38bw?=
 =?us-ascii?Q?6jTlizz+cegRxgwB1WWjpaGsxtdAvk2w15NtwITU2ITXRg5Nhv7MTPK7qj0N?=
 =?us-ascii?Q?38YdJ5V8PgNHyRDcNG9USr8qG5ipB/FbWNmNjlNBhU848zh7aqFtX6noShpn?=
 =?us-ascii?Q?b1NsPxk8xlqzIfUF/t78qQBVGAR6fd+iqM2DRd9HwfwxxJ+9dE7LP5rZMrUJ?=
 =?us-ascii?Q?mhyOBVwGjbSsjJN5hwJIsix7cYAEOs4HCmeyV6nSfDw+qprq9dgYHN5CRk7/?=
 =?us-ascii?Q?tE6h4Om8q4MMzsH1/ih+YD/ZNX6kA1s+B6/iNSj8IFUpLNmPZ/E6hfxBxp5v?=
 =?us-ascii?Q?n6QHGVqifQIMhfKNAiqYwNk8T3GsW2GOk6BokkcNPnLK/+NiP9yxYiUDcp66?=
 =?us-ascii?Q?6F7jfSIuiGxlruVKyL7buJ2GpjXlq1gVp3ydUDGKI93za/eXfdRvRpXuEOFV?=
 =?us-ascii?Q?3VQ1BRKVijWDKKUY4ldsM8TTQYr4PUXpFdlZeY1MWy0bF8PUk6jVN6Pd5Flq?=
 =?us-ascii?Q?tUWNrIfHEsRdwdBAxKLcvgSJW9yBwXnEevqEtJK+odI9oRL7RLicQZbfOzIr?=
 =?us-ascii?Q?dlrL/t/C2XYVVznbjy+hnKR6BIoAjr2LXgIyzUyE7sgvW06av1a5iQkcTCqb?=
 =?us-ascii?Q?flfMvkbJLB5/p6L168usJA53YwWEQ5lwHHsHBJgBVgvxGY+v4JFy7gEVYKHP?=
 =?us-ascii?Q?FnGXiRBrtIR0BD/MEaZl/8HF9+QttBKXkJrx+pkD759oyd8+Td/0CKoV/RxL?=
 =?us-ascii?Q?BeCxvPIJxZSnF1I2Z+/sArvKCgDFhbA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cdd3973-7d55-42b4-686f-08da392f78c8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:28.0398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0oLVcJYszqQG27C96RDYv8UxF3dL/VfZIdUrXB4DOHIIPYcwJQZ+P/Cd5iYzFbYgYALpkBCk5oLxZx7Z2P8Pun2sQI0EKJTWoN4F5vIpDU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: LP-6l83pOXAhtwy926H8KcwdxM4c0pVB
X-Proofpoint-ORIG-GUID: LP-6l83pOXAhtwy926H8KcwdxM4c0pVB
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

