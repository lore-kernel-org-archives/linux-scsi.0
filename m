Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E85EC4707F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6802A613FA
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhEYSU3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbhEYSUW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFOmC121953;
        Tue, 25 May 2021 18:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Y+CbE9NZ8sK9IU7nKOcGd96hoF3Q7Ztdmk+4XteLU3A=;
 b=Dyt08Z3xRltULu59MxVe0/U6uzhi/oHi1N/ObTXOR1+xeWgyggOBy5uFS+ir5DiSwTe3
 SbTa13Er8ScALSQLJ3E99GO7V8ARONwiHpmbe6TpWr3FMO75KtzsYnD1P07Y1Fe2ot35
 dGbN9kK5iB78PYIEUU0xzKDkebN42f2HDE/Sq9c5FUeHI8Y9ip9yjzBLocUwJSES0/C7
 RZ2Yyn1E5fgufhJLCWGKyJbe38O7JSljNWDNxNYwEBs82Q9eMvlknlzUmT1xjK85ONiL
 qJZLy5BgXtHln7FZOPPmBymtrjT/E/jW22wgeMYZ54dQZOvVubMdWtSiboJsDGRVwb/m EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8xcv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGD0o010935;
        Tue, 25 May 2021 18:18:43 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by userp3020.oracle.com with ESMTP id 38qbqsggy9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZ+RSLeObqmqEQDf0DJUS1Il2FQvB+maC3Fcykpb9H95OmguyisXcaS+7+sAUtjtuWk4RSudNap1Pg+SCAKFG6gfg3XfRD0tU/uhWxH4fYNywuN0Fru03WSO8Fy2hNyaBA0pXBiWLQJdPOu++mFF9DuzypmryRfvb/wkIfyrC+mbbolCsMIR+THbik3T0F+BPTudxUKqxWREjvwEtdrdJSgnoX3BWwM8BoOxrAOvQI115/KFF9i0DRcmmJZRzeVsfzfW9mUJxQSamd3s3ZHADsQejvfuPMJyNegHvGJI9dQyYSVHgm4+0RNDfXN1ximIQE6POgrqXRkkyjDc+Gz0tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+CbE9NZ8sK9IU7nKOcGd96hoF3Q7Ztdmk+4XteLU3A=;
 b=DtWvqHwGD5jAzFeud/HaaIhLwn2jeZQEUADAMQoNQPHBd6CfGTISoF6g0Q1Qhw9mflFmVFwmbN1clhlzAcwtCZ7RjgAwpWKxgYQ6JncRGoeXpCGwiQth/GJFQ8ComAwDQKd+UeQaWqOTm8eMu1M+Q6qY23QjqfkITyj3fNBz9CQLz0sx+BiJdwfbiy1spchXefEySMAN6BkmCxUXLTbay3jJbXodMHGWidNdy/4fPGPhWwWfcSlgtr9Rcf8PN5jQe/bghayffbG6RdJFy5m+pb5U32F8TGWlnlkalPmwjmwrP6FvrRIBTbTRPg5Sht2lG4feB9xifQ0z26GwXRzM/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+CbE9NZ8sK9IU7nKOcGd96hoF3Q7Ztdmk+4XteLU3A=;
 b=n7ZvC7g5VluNAOy6vX049Mj1qrZFBSZ6oA52XQ1BXXOBuzl2ea8+RY6R3hAzpTDW0OHkdJyaRFlQmQ+M5duUZ89DlqvifTFXPilxMCEDQptMKS0i/eE3ll2EbZFfehTVTku48+u1ncQ+KCfFIZPYxR56NHSHzdH1d7REwH6Lfpk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3891.namprd10.prod.outlook.com (2603:10b6:a03:1b3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:40 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 11/28] scsi: iscsi: Have abort handler get ref to conn
Date:   Tue, 25 May 2021 13:18:04 -0500
Message-Id: <20210525181821.7617-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f80b55b-fa88-4725-5eb7-08d91fa985eb
X-MS-TrafficTypeDiagnostic: BY5PR10MB3891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3891555628E95EC4A4A39FD5F1259@BY5PR10MB3891.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0x88jL7DLvPfgpWD9WRgMd1TtKOWeJjm3FgySy8SMmAoVPpmBxJurf5ko+12kbJp3Zm28CXGwASqiZ4cwD64kxke6dtWMl88+b4v+e0qe7L1cRalODUDSffmqKlZvYeT6wM74eaLqp9CT0YQpDzznl8V/fV0RZeEmDLF1f4Av6H4Yc08RTf0+kegHC57ChlJ8AyCybWm2FuXV2HTdpPD/ITIdULbZdYxoaLsrcSHTLnoKRuiM8lOkBmZd0l44X9WLGs/irA1HaHVI4VS8s0l/XiD9ZgUZV4CiNhlkpbxyvYZd1rxAoTvXNNJf2jDuKWje4ijVE+i1egL9k7WRNX2Fsosz+wtp+tpsvpmvf5w3m/Sez+EopsNaFmI3x4YhQFbs/b+x6oC3cM9nA/SlTYahbnuoh5Wo6J95csrpZ/fnQfYa6G7YFWuBUatUYFsLFCBicWo1F/lGIuj2XGkzza6qkjtch4eNmb5ZQnfL9xTy2wUWuB/jtMyGyHiCBw39zHAy8Sn+Yrnl/QFLl8XMF5VmSfDpNZjnYI4FTW+UgQ70Wpan5f9y35kXZPBAGlbD19oHHJNfVaeiab1lzQ4Iy5l09z/fepb77ZlFhCkgMgKNri/y9I3v7QNbBA0fj4KPXhrSO9+sOvWz8ws1XrQkhf9CYkzGChqZb+Ey28ajnOjtQTLH75TkxYn8U9xwlniDD3R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39860400002)(346002)(36756003)(83380400001)(6506007)(66556008)(186003)(16526019)(6666004)(52116002)(8676002)(66946007)(8936002)(4326008)(26005)(66476007)(478600001)(38100700002)(5660300002)(1076003)(956004)(86362001)(6486002)(2616005)(316002)(107886003)(38350700002)(2906002)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8QTG0Ts63xjdkDYRheL1Gj38BNspSK9uFeSKlm2HPeRSyz42Q2cqFvYUeT8o?=
 =?us-ascii?Q?ILTPGj669pcyubXBT3oBE2TB2SO/JRiI3z557PDA2EGd+AJR7io7RGu7+JW2?=
 =?us-ascii?Q?oHOh6DgjxAgM5/e5zTaqY+C9xpYqWgGno8reXiEtuFctrTf+3ttQ/wtnwy93?=
 =?us-ascii?Q?5I6zEyzS/YQf/T94EQQ0PnGGiYsrJ5NS1+lZRopnMpj8y2riL1O3fyY6KQk/?=
 =?us-ascii?Q?j6LHC+Cw/KyOvHooGrKW+AWLGNapUHsVYo2sWPD4h2QvQMKkPLT5kJ+gOFAX?=
 =?us-ascii?Q?wkG2MNAUkutxH3Xi1oxEJR/xMrhKNhXnEyte8FWy8PzCO/NGb6E9ahqIT5Av?=
 =?us-ascii?Q?TXS0kGPx5OzdbMBcL5NFu87joKFcAjqX+JLLAyRhE9s8wC8Z+mjED52O794i?=
 =?us-ascii?Q?LZj7K9wyF6elsep4G6lQY9mgv1eTAnKtuOVmPFF9uukMfQ17l7pToV3yGPq9?=
 =?us-ascii?Q?fuD6z0YIoS4Pk9X8hyQsUyyOWOazNlrDHkiP11D5CnrlnRNbfpErs0PgNmc/?=
 =?us-ascii?Q?2haKpgssMaZkmq3H+5ls2VUnNYjhsNVluCqsNVe0c6qP7nmZpDjGTF12DOeT?=
 =?us-ascii?Q?MlO50Mg243qim2uiJslHm1rCX8lDBSQ49m9Rm8oSdO5Ee7+yFUxT/IHChkhT?=
 =?us-ascii?Q?t/EwuGe4lzPsbEyYWEWZ5zrUHPA5ZfVPHWGvnv5kfkqWrfKL0+oOJM/tC8Nn?=
 =?us-ascii?Q?SG8tFuOhd/xMRW8R1YFbmFqxuHntmSg4ffEAxvg/RWHaY9l55CDDXiKbUHah?=
 =?us-ascii?Q?RVfkZAK3WndVfP7Yv9MYAVnhGgz21c6GxIYPdtA38STTMIPLEu7tb0wRGUca?=
 =?us-ascii?Q?espiQMo88ra2cQsc8MxW1uaLQ4W1KwGb4l6fIRtgqoz3UW+tnzjG3muG+lzi?=
 =?us-ascii?Q?ELvcJHIcVE0M3yLMgIm52KWIFfTraxGpO1HSa1fAEKnhykkaM02w4aSCTYQV?=
 =?us-ascii?Q?iTzsyVBgDy3/QfNeIpcEbkgE5g/aqT9eyjv3TSeqHs3CYaOQP3hiEyQPPgVv?=
 =?us-ascii?Q?i2blrol3JxVk1xkHNuAjm8Ac/JvvIqYMZLln077WZNigykqmkwqh8TSb7M28?=
 =?us-ascii?Q?OtfM7EvDz8UPJsNR5YNIS3or2MGn3rXbEn/YZg85I+JXFpvOXCOaJyPh2ItX?=
 =?us-ascii?Q?u33g4145P8EUPDZ0l1UwWp1GM9bgGeLxXqirlZkFwy4nUgsz7Cq0CuyEvUwP?=
 =?us-ascii?Q?J/p+MdGSgyuDMx+tWcMtBn06jSTTTXIVikLaSwP5V9P2yhJdQpnMJFnjkdga?=
 =?us-ascii?Q?vYC2cArntoBnm+ZtCsKAflMHMfMZV64qb37VENl0MPlqXC1m5UErzMmhdle0?=
 =?us-ascii?Q?seMOtsdVdqf8HnIztld6MHQu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f80b55b-fa88-4725-5eb7-08d91fa985eb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:40.7794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7k2AuUQMifkjcE0WI6WZDq1wSj2iRnfkchIN8lgPC1S5DZw4GWdqaxsuzZvru06GDMSwBIvI+7kO+h/7tiFw1NxbHwLK84t7WSg/fVfEsiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3891
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-GUID: tN4dpw0ckhDL951Ymg84XPULTcMr5gY_
X-Proofpoint-ORIG-GUID: tN4dpw0ckhDL951Ymg84XPULTcMr5gY_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi-ml is aborting a task when we are tearing down the conn we could
free the conn while the abort thread is accessing the conn. This has the
abort handler get a ref to the conn so it won't be freed from under it.

Note: this is not needed for device/target reset because we are holding
the eh_mutex when accessing the conn.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ab39d7f65bbb..6ca3d35a3d11 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2285,6 +2285,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 
 	conn = session->leadconn;
+	iscsi_get_conn(conn->cls_conn);
 	conn->eh_abort_cnt++;
 	age = session->age;
 
@@ -2295,9 +2296,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
 
 		spin_unlock(&session->back_lock);
-		spin_unlock_bh(&session->frwd_lock);
-		mutex_unlock(&session->eh_mutex);
-		return SUCCESS;
+		goto success;
 	}
 	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
 	__iscsi_get_task(task);
@@ -2364,6 +2363,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "abort success [sc %p itt 0x%x]\n",
 		     sc, task->itt);
 	iscsi_put_task(task);
+	iscsi_put_conn(conn->cls_conn);
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 
@@ -2373,6 +2373,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
 		     task ? task->itt : 0);
 	iscsi_put_task(task);
+	iscsi_put_conn(conn->cls_conn);
 	mutex_unlock(&session->eh_mutex);
 	return FAILED;
 }
-- 
2.25.1

