Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E004C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238128AbiCHA3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiCHA3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F54125E9B
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:10 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227L49J6010008;
        Tue, 8 Mar 2022 00:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=i3xIIMn4Yqf3FEI1YcW1laUcT1gaR6iT6BiDU3xdIc8=;
 b=LPUQIZTdKJPmyuXwTyV9XNV69r7PFg6gRkiGXchpayhoUF0PuCOjLLnUSqxYBH7jOD2v
 TzlFITPWS88KnldglVsq/H9AHrpWiR1mrJjlU2EP6feED0yixZRhSx7O0h4NQp8uudRY
 jsuPNeya33yWhRvmO/ttPCDgez6s5VVO2Nq/pgYvicXo01dp5QoZ0gb8bFqMf6As4fN2
 b+Q1dQbKIvs61xB8OAnK5S7oy5HrPOimMPWTRldTp224dUK7zclKQYfoVF3na9vNhGCZ
 V0borp6/NV2l5Ixw/GTeZwc4Q5Sel55W2N13eKQHlP5FSMCiYNNlbWd1R85bpddA9HA5 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0dtwjmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AJ98134548;
        Tue, 8 Mar 2022 00:28:02 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hrq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dl2MG2rIQAuNHc7146ik5ur7GNunzUdENjnJ0joOu+VOf7HYUU1m5fUbDu/94qDsTEt0ap31x29fuzM9MqrzRuE76T3/R6Wx1jukzme78FzkLW+sb5n+A9a5XS6Ga2nBXlBa9RVGqpBmfisBlC+BD19cL/Bu1HW/vgizM1DdzteFoYThstTTh+wSpk4xPyfBKstLj5FkwL3thC2Ml5DTVIEeeXkAp1ivvMNuza5jc8hC/ypSjFGPT48naue59gG8O1y5kofD2sMHIir4WALTX0RCPdBGp7YeltkaewEmoCVo+oQey+r6vmE00AjPd98S5tSsmuDgHAuXt9bUFTEEGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3xIIMn4Yqf3FEI1YcW1laUcT1gaR6iT6BiDU3xdIc8=;
 b=OC9e2Vvc/hl0mB1zSYDgd3VC7PRGm6Pd5FnWTSyBDASsPaLIFMR4sm2prrVFivrMVf4UtRzZpiMvffaJ6ik+T9heqetcmWTGld0+j0s5xHxqQshTvwUCp9prC+X/ForIIRCVGYOVFWoAA7aGCgNEBJZhUvjh94GawilpyQp26NDjuTa22QZ7QsThxUhHFf66ZieAL+LzlF9qwpav3RyF0zecVGchd2jIm2W4mqUqEQilfLv8Hr4c+EQ1rgYHg8h31jnvTkqymUxG7wB5MLFivycF/YpSOXpJpwVoWXJEbglP+Od6+xciSG38Hq4a1aUQ9XorofyZDzsjASlDvA2iQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3xIIMn4Yqf3FEI1YcW1laUcT1gaR6iT6BiDU3xdIc8=;
 b=jFNipJmv79YmkbGUeywih9AHv4EGdq8loZmMjxdGyQZclF/RQtpdOTHyJksVjsfHnQWFVF5ZwtgeEivq7FvWxhK9vM4mg4K2vYVYyRyzKGhB+bInWi0jL4QziAVTcTCBhYSSqvo3FeFXZ1EBX4CftKjlBAU92lNYMfWF9bMZQW0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4361.namprd10.prod.outlook.com (2603:10b6:5:211::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 00:27:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:27:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/12] scsi: iscsi: Rename iscsi_conn_queue_work
Date:   Mon,  7 Mar 2022 18:27:37 -0600
Message-Id: <20220308002747.122682-3-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: c90b5157-9663-47f8-6184-08da009a7e35
X-MS-TrafficTypeDiagnostic: DM6PR10MB4361:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4361BD9EF9F9B3C78D6C613DF1099@DM6PR10MB4361.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qDN7COfC3qvtSA5TweaTTiGABdX895hFMhOS2VaYY3DDWG0DeeaCywtKAEqhu6jXkMYWy+Mc+cw03qUe0Sdyv2m+4ad5vpkKy/RnYH4iDa/TBel/GFQOzp3NCzQvAOnn6iemwRxzPrIq2eL/BwC6XPUJNk4vYGnkSkdgcKPi6UyTu3qt+KSW1G/hT+I+KOMHsc4ZnKJtqKQDpGrJhnwvqohuqeJDqhdS5kUjT/WDQ4f7W6OkKjpnunFks6V0O7CLofDHd9cyhZ5Ih8vAtbwxtd8DiHBNCj6bXHKS0isdoRNkNa8ABDbcBJzD/lNO3leLvZrCquPjP6Bf0P8CWPhSHwi9NJWXDrG6wsCx8wBjMe3amwNf4crHgNXspEaBM93qenUbojgYWZnTtRAI86rJWkqPK79GBiTMtJGLMkXKOppAEk7bmJPKLJH1FikEc6qWLr7z7qQ4zDh4m9KMpdsbPFPTiUsRnJ60p87qnu2Elxrjd0JUZoCpvZZvss2KBqvJehlnn0oGDLPxPl5Aa1I5LUbf808Shi5+mKEQad3v2PU7segkciAt++AJLCya9v4wzKC4inJka4mf/ORVR5pYUkc2816wiAhFC8gZZdvbg0GHEqgpP/Cr+w+ELBMq9rlb8oYcVSgIO8g64ZwOzUdEm6p305EWDfijteFkcWpdHSO5XBnJQjtmJwulVxQ57+2a6y9gN0TRiYjbcaOQAd9Vqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(508600001)(6666004)(107886003)(1076003)(186003)(52116002)(86362001)(6486002)(6512007)(83380400001)(6506007)(2616005)(8936002)(5660300002)(38100700002)(66946007)(8676002)(4326008)(66556008)(66476007)(36756003)(2906002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eEwf3DmqiyUN1bSkBF9hbnC7vP8kkZcqpC+uWZS02FCGqCZMkM9vnd6pTrk9?=
 =?us-ascii?Q?Shqcs7tdyZRss1WzkLc05HCvNY+zo+Qc3sli9OyY8NfRZKt+8F9uTbY7rKGQ?=
 =?us-ascii?Q?OWhMx63BestuQxxMvQlB88xIQ/LAVSaGsDxzC/V4Pm8d4bkjvWdaQIC1N+8x?=
 =?us-ascii?Q?IUuicjYrByg8jinYbJTyw3UnAC13AAEKhogO/Y5EyJPPdi8BBojDSZSupjWX?=
 =?us-ascii?Q?Pg4gOYnef+iuUCA+PLjzowTfLKLUAGChyD7ADxxYekj9zDx26q23ucL125uT?=
 =?us-ascii?Q?teuhCnuWejurcClo70GtD4okCRihBL7TQgmM6UGJLaMcLuznwlfQaHmg/UTo?=
 =?us-ascii?Q?tFmUXqfLMq6/W9IqD5u/07+9vQqXm+uLCWVV8+8NwpEjCs7jD20SHJNusNOg?=
 =?us-ascii?Q?AAsilvC2/DC/KeVODworL9aN1Q+Pna8w3JCK+gw+ZK56XZPXejjy6TRzavzt?=
 =?us-ascii?Q?wYBRZS6Z3BuwktJcU8p0OEStRTT4xsY8VwO4efNBXQ+BRiXc/4jGwlEuFfud?=
 =?us-ascii?Q?xQAZMJAL4MZ5SFaV2vOplpriaftZuAp/wIa6l6NSPNXsaPPv8+szjl8IHBQY?=
 =?us-ascii?Q?0WRJ9J2uetWO/TWGfZKIedpGYxryn28fsOlxeC3kaZC2NJ4QExMR7U8+4528?=
 =?us-ascii?Q?SIvK+hq4t4/b9jcx0iu6nEA25njLnYySw6EKkv4PMN+n/Ob+gBOPMazNWDMe?=
 =?us-ascii?Q?+j1/sJS9urMmfyVLFCf4pNIKTpNn+jStbx0/Kv+Qf9jsrTG1rBwBHEvdQ6Cd?=
 =?us-ascii?Q?b4m+JZguoEf1kzLO6yw5oEAGjAiKyjPPtkUGyyFmOJh8vorrt609oyUaKA8X?=
 =?us-ascii?Q?G9fc1yPas1ax7jSUkrUEkFpcbXpmyB+2v0HxM9se8LbWgqzoULCE7jF5KePJ?=
 =?us-ascii?Q?67vNo2UjdxjGsz4XOqmw2qmGUeB50ZTdWpn2QaErtu59VFj011AhfokYmcNt?=
 =?us-ascii?Q?L86QgH3K3pvrmn1y7hfJB5zuLmEGDeqCWf1wDA7RlvgbI1C9YBzLNG2X3cFB?=
 =?us-ascii?Q?k6E6rBjGQSCFbTCQWeB4ryM+vc0B4Z2TTVoO1Qx/O3VwXDC1g6LmqS4Ol3v/?=
 =?us-ascii?Q?0PHGAoOHgzDgsPqAPKvwvLX74AkX74cygrpRAebMjeA/WvVGJ/6t3EP9ntGF?=
 =?us-ascii?Q?ALuvA2X4CdKtarWbVvdPojqII8eiMOAcNjdvixQxp6pE2Q7XKbinpgmidbtB?=
 =?us-ascii?Q?Er9rjoRQQFuUSeVk7lTng+s+2iOutIXFlurFDBOAwHWPCACOZ0mNoZNeI2ok?=
 =?us-ascii?Q?mdNDfkj56jccCXyErvywabcPm00QpIKCVcHfWyPwRAWQmMSlsF9QzBlaMhMp?=
 =?us-ascii?Q?1UVJID7tsDnRVLRNpO41hRsp/IXxzRDEvWDFVOZ6rVyWwFIgTLr9u2D+IylL?=
 =?us-ascii?Q?BP8XGhAkD39G07X0KbWPuXSeFnbZK2+mN1oMPMoLQ9bETDDBagSMuLNON7cr?=
 =?us-ascii?Q?hK4fiIrKRDsaawBFWHMOBJJw5kEM1X+iH6K5+RaifLed/zWPcHuwTXLDrLDN?=
 =?us-ascii?Q?KaPerTDXiB/nYIv4j3pDxEZp2oWI2LwX+7feRcztTto1B1psml4nmME9VCGV?=
 =?us-ascii?Q?0OWrfD58D+JVlLF+di01QQjSgY7HGsKRioOw/YAOczj0t2yhnbWnxDcfHFOf?=
 =?us-ascii?Q?PnCZgiDYnzzhs8mNTYLQhPhTnhYJn/Z1PGB/yW+1dkb3ZwesyUFexapFPTm1?=
 =?us-ascii?Q?BslI+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c90b5157-9663-47f8-6184-08da009a7e35
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:27:56.9831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4EQ4oEpS42W/y88xdT6soDorutitvQpmFagxNEEFiSy78EvWvSQxGcCpgXmf7d2zIvokpzJ3yfVdSsN1mjfoiQy2lA/Oh+UdzWBseOufEGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4361
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-ORIG-GUID: 2G8iIU4K2qLMWsMbWVTkQV7M_66CQOoY
X-Proofpoint-GUID: 2G8iIU4K2qLMWsMbWVTkQV7M_66CQOoY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename iscsi_conn_queue_work to iscsi_conn_queue_xmit to reflect it
handles queueing of xmits only.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |  2 +-
 drivers/scsi/iscsi_tcp.c      |  2 +-
 drivers/scsi/libiscsi.c       | 12 ++++++------
 include/scsi/libiscsi.h       |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 4365d52c6430..411b0d386fad 100644
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
index 1bc37593c88f..f274a86d2ec0 100644
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
index 14f5737429cf..fa44445dc75f 100644
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
@@ -764,7 +764,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			goto free_task;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 
 	return task;
@@ -1512,7 +1512,7 @@ void iscsi_requeue_task(struct iscsi_task *task)
 		 */
 		iscsi_put_task(task);
 	}
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
@@ -1781,7 +1781,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		}
 	} else {
 		list_add_tail(&task->running, &conn->cmdqueue);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 
 	session->queued_cmdsn++;
@@ -1962,7 +1962,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
 	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 }
 
 /*
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 10a9b89b7448..b567ea4700e5 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -441,7 +441,7 @@ extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 				     enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
-extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
+extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
2.25.1

