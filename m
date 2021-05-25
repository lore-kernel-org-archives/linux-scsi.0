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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63DCC2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A58F7613FA
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhEYSUL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44030 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbhEYSUJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:09 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEwqi124481;
        Tue, 25 May 2021 18:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=36nlTOlTLMTxpspKVCPpHxZS/J4B44QEijTKxwhPzsU=;
 b=LiFo2bGoCKuq8Dh7D4ypC2Ged7sE6SbtAoeoAJ5NJ0WMgacq0HwIWZjj7ZErLJueeKfF
 cNCBOChXqB27uSDW2/2gh0/j6YQRINVbm4lgiTV9syFm5m/k+vRGPHntnLb8s2mDpbSk
 DqKjMj+POny2PLe1rGI4q39RcNVi22Ovx2crb4Butn20yHoSUJT81+opZNGsLrwVAwHS
 qAbHpije++3rDwX1FCpHfUqR5h2vNuBMPn4AB4nXH6LprHU7aFzW0skthkTxsGk7LUXW
 0+puX8GfXw1IGHejLjGryV7EkFN9mzwiEYrItkg31Lqu5dY5LYzrcJkMLHeWQoAG9uoJ BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38pqfceyr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEtmF166080;
        Tue, 25 May 2021 18:18:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 38rehaq4vh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9x1u8YNmnKjeu4BoJ8tHV+ja+lzKcU0JYfeDvc43MfifXk4YVHA3VcgyYHpjZbZLtXKF5fcS+PEGEB1HJ+4jS4J8hJMtMtwUBxLCTur/Z8uTcto0ZaJfjoCztT5LuRvx8V4vifR4ff+PYP2yDOSFXmG+Emj/+cmletVOMK/AlFAipkfMxExnxG29ry1ATg7C3tN90ivW8023po3G/MLK14lJKvPBlwvIIbKXsCCkdDuGqfy7o6AFZROY5ayXGY8Dy1Lhmp0Vc31+fUpDuDVNyPn+2kCmQB/Yh/RaBHeQaiuhBlFM7UWGiTx86mShVsN6nAqK0Hjxq5HqdHVGkLPiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36nlTOlTLMTxpspKVCPpHxZS/J4B44QEijTKxwhPzsU=;
 b=A2r4rUmPtHIwC2ARuXXLIuvpl43tUmOlB4xgntuJs6ueyKw2Shm71qrzB9mEARrfsoHvgGQ5PlrHFxPBSpzJFFaT+BOFCUgPCQOg9tCTbtMm6o/pRZZFrJwZ5zWXSaN58zZe7X4kFqm2Pd59LN8DSTAjlVLz/jRLWwhWiGTwHSozQWJG0zLfa716SU6mG7VhgFY85mEwiJFTo9hzQfVCOzmfHYDdmHvYwHf3XaBODNU7Q7QrqGV0NMkjGv6jDdoBRJel7gr9Tjy0fT4ub3m6ooup15BuWhvPVSkzx/5bQpSho8T2SIoonS2ICPVgr51XoPxabSLeLyt3atK6WTaVzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36nlTOlTLMTxpspKVCPpHxZS/J4B44QEijTKxwhPzsU=;
 b=xn/FyeRhrc/2/ypgDbSXebeq/QIvuuH/WLqaxFasqiLDT1F3WOWdunqI5ucRqvSMWmOQNA0MVAySmFDqaOOkmVWgLOA+DEle1+6x9nwkadN7Ricqu7Qf2hDmQOxIgfPpricFOZXKyuiIpUfAoO0t9HARrUMz4FoRZEq7OG8FMtw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:30 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 01/28] scsi: iscsi: Add task completion helper
Date:   Tue, 25 May 2021 13:17:54 -0500
Message-Id: <20210525181821.7617-2-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15958251-80c1-4f2a-bf91-08d91fa97fa4
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47670E5C5464E3146408ABD3F1259@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lc9PQT8aMTvoFusloRPpFcBYpN1LJDJJ2Sv9EpOBGIFgu25Zfv29T32cTRGMzgfLOyYUqupz1LCI06s9ukItoFHXJrT3oSy15sg15gWmcjKGNXq5EDPmpTInYNtzTkhBBGFm5P2Lz47fQdxlDHBPxHC3aRf5ftNuNAhMLANsdJe20NOKOtfw+gj9BVpksVfFAFOqatU7zO98vcUTQvhQ5K3AHqkaWuwNegTWtV5MyCNBxCYQbYcy1EUXpwNBvKVDvRcIyPPsrDcAQSennzvpwHbSNdmvdL8owZRJml5kFbMKs94/BSNmPfwd+8OuR+gEo7iJ2NW5YGhoAN16QcxKYe1rqh2cbJj04/3W2RC/XOeufQByYgpAF8bqC+oSTBLTdWEfF1O1GA1WKX9UdwMvDQn+H/R5L0VQ3NTmugvm7DcfEzuehWAoqNeR5ea4oDWUJgTLiPzUuuaEiGLFpSOa+epV6SDnc496BhFmak6ACrL3uAGRBenK0rI2G+qqmHz6nxbT5321IKf328C+QIdww0e3dSSuWDCrsa/uVjGQZln+SbJC0UGo5nC8tss7WBp9TzJMjnSNrBSBcOLjcErv2vmw8giZLNQ0czSc9fw/sfyaj6DeCYseVz7MLXmG2cj+m2UG6lrvDdKQ+MA9O1DyP98YszYCjGiR3malh9ZOnWP5aFqdY9n8ap8no4S9TZIa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(83380400001)(4744005)(6512007)(26005)(1076003)(4326008)(5660300002)(956004)(6486002)(6666004)(2616005)(38350700002)(86362001)(107886003)(36756003)(8676002)(16526019)(8936002)(66476007)(2906002)(66946007)(52116002)(6506007)(316002)(66556008)(478600001)(186003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eUb+wjYKELEuY0rs25s6pHLsXD/4ys4eqcBKoZtNNsQe5lyN8r7c2nEOqN6P?=
 =?us-ascii?Q?6S7rsyCkqjQepPAQW3JeFbbV+0ABwne3Gt6GrPYVBKeXDmVq4BA6yl0nKbw8?=
 =?us-ascii?Q?6SH8N7g9uWfzez7ZKPKuXBlcZ+8t2/vE4iPVRCjOb7o5gI4Cc9nyQY7Ucju1?=
 =?us-ascii?Q?BslqyfC+ssFEBi4S2GjX8S6ZEO8n3ehsvRFFY9uou6a+FdvNsk/3xXLqui0F?=
 =?us-ascii?Q?nOeH5tLdpQ4yCP+yexzmKVm1CJwvSPYMHyGXYuv/NeB2gLoCkZ4kJsbXMcsA?=
 =?us-ascii?Q?8Gv/qX9aBX9hP4cGbnZS1iOBim3aMWQniyWHJeHrlwkQtsYs5JSEjYldc/Gz?=
 =?us-ascii?Q?CM4Tu5IZrzMVBawQs1Ij5XXnC0WESyUDmSW0Yq9rT/JRhOYvYhi1Arg0TYRG?=
 =?us-ascii?Q?ATTxVIt1A3C682p59Wt31xi2/Dspdt4amQ5xitgCohJ6zXyKXLwODJqlV5gz?=
 =?us-ascii?Q?maZYcjekWCYbm7+ZQKOwRUO2kuxW96Z6sHBAkclHzq1zGy86avtbVFn5g/oa?=
 =?us-ascii?Q?SvlZ6sLuY2FW+VeHp80yA6Jm4W66H2BI4+Mk/wK8JBEd0NA+aruAvE04X2a1?=
 =?us-ascii?Q?G6Go+KTjuSeIjwLgWH9RkjM0XNoutvacDIfXuAcOTHAo8y4sdqDEcdStKLyy?=
 =?us-ascii?Q?+HHKaFtBGYk5zK5mcgqw+eLbNuwnE4JMcGPg0yW/xrf5RLy+LnCq7UQqL36A?=
 =?us-ascii?Q?+9Immex04G4jfeIQXRqrhZsi3QnYoYAEKRIm2yT/AKDIn3MvGviRZLexJpyS?=
 =?us-ascii?Q?P8Uv1cLU+wYcaDzSKc2PrsBykUc2CkWYfINQ0bfUTFI6D7XJKUdCQXE9zrAM?=
 =?us-ascii?Q?BFc7+FYWUIzVqk8LwBm+0tvcGUgzpT35M10YDb0D9QJwiFbfzrx1Rnd8JU9c?=
 =?us-ascii?Q?Le73vUe6iKe9oy26kWJbN51v2VvPuMqt1/qOw/fis97Puz49INHARVo8wQ2r?=
 =?us-ascii?Q?vG168UVieOP8n+MCBemt42AadOw9bj+JGHBsPaBKTl+a1C6jyQTPxc01EQjF?=
 =?us-ascii?Q?JvFtzIDvZ8kISjuCaVfUTbj9ml2yLHm6lIEeazYYD6dJm2/c0Wh6MnQRmPB3?=
 =?us-ascii?Q?tSg/Pf2UXfMh9Ok4Ea/oIQTsFMjRR3C1JFOWJrGP4OaG+GLs3bMIZ5LDAIXC?=
 =?us-ascii?Q?DtMGP1O7kbJcbE2zA+pIPjEzUzuLjrquD6HAl31RqBHfsX7/fEQp0Fy0phhe?=
 =?us-ascii?Q?GMrJDBZ/VdP57tbkPgGthGZ7QBQPOak/OjcSqAscDHnNYhR9wS/OmXqsxF6f?=
 =?us-ascii?Q?7XU5r5cvQzh3RpJkoYkGzxeqRBJP4IVJTI8f6unMohpfhJcWJvWmYIl1h9gd?=
 =?us-ascii?Q?unXI24vDvrITqwapfdQRv7Vs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15958251-80c1-4f2a-bf91-08d91fa97fa4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:30.2932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16mPC+xqkUbIaRuzju2LXXwHemSazoOOq0/uj2ilOAnQpQqmm/6He0E8ZFslpu8I4/845X/djaF4zfGGUzrdpgu395wuYREdYXULW30cBsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: Y6UMOMO9qak2MBFQUXnsCqUw77JMsZ5i
X-Proofpoint-GUID: Y6UMOMO9qak2MBFQUXnsCqUw77JMsZ5i
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper to detect if a cmd has completed but not yet freed.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/scsi/libiscsi.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 02f966e9358f..8c6d358a8abc 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -145,6 +145,13 @@ static inline void* iscsi_next_hdr(struct iscsi_task *task)
 	return (void*)task->hdr + task->hdr_len;
 }
 
+static inline bool iscsi_task_is_completed(struct iscsi_task *task)
+{
+	return task->state == ISCSI_TASK_COMPLETED ||
+	       task->state == ISCSI_TASK_ABRT_TMF ||
+	       task->state == ISCSI_TASK_ABRT_SESS_RECOV;
+}
+
 /* Connection's states */
 enum {
 	ISCSI_CONN_INITIAL_STAGE,
-- 
2.25.1

