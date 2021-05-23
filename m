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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E747EC47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE3BD610A6
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhEWR70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:26 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46476 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhEWR70 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHvqrJ164810;
        Sun, 23 May 2021 17:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=36nlTOlTLMTxpspKVCPpHxZS/J4B44QEijTKxwhPzsU=;
 b=U4Ms3F+NznRH8s95gcyCajkkQ3c/mBkQCWr6DlQUUTyliqaLvK/mTLORmFiD/21A2YPs
 Q8P8qf8Qov+i0h5Y0joYV0BiN8NAVrxlzztlAAm/qUzdnJszaA4DLZCa975YNyjJgDZy
 D/8RVyVZqrsZv9VHe81GyGghe2ElDD9Orv6yOAta9/pAk3Lfx/enI3neZ4XibsDk3cIu
 aXSFm6Idb/bOzesmoMjpWvWQCjKkDXAQoSHW98uLgRKIWxJbkbCJyA3Rp+SqBZuTFU0c
 T6Nyaox87ndt0TvRJoPqZWRQK3AFOgKx0G38k4m99kYzy5KayjdfYuSvBgKpCUg3gWEC 1g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38pqfc9ja4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHtqYo081804;
        Sun, 23 May 2021 17:57:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3030.oracle.com with ESMTP id 38pr0ah1fa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXHwaACLsHr7nWtn9lKHobUrQI9RK5woPTzTj3Hq0Wqjn7ffOVmvfe2IbSmC+s3tf9sIQ4h/oUi2Dz7VI/PDmWIAsroeQraQaT4SlGkb8u4yV4UcFMgUA/XOzd0/TUMJnjGb16jKAsLWE0iUbLpiqcr3/x5WNKJLcoH9dRpt+rj52NLc7fF83K3q3PVa1GD/OFVsXIN9+006XRbD+ULTgjM2X87xWh/5vYBnMVyUlyb8C8VkUe2GtVx/jekepRLPF5BPEIhD/3TixsFnSLP8zIWCYjEmQp/jGNTeD83+FIzYPv0oQHDcGhIcZIEvc9OqKzCZFpjphvU68htKbXWsQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36nlTOlTLMTxpspKVCPpHxZS/J4B44QEijTKxwhPzsU=;
 b=gExurHjPAaW1qg8Mvw1tRNfRDaCGhjRf62ERBxsC6jOmLdBOGU17L6GBnaXIovDxltsaOUMPo8PzxGaUvjNHmBoQIpYtK3+xRQPorgTiznjUD2RbJVrUg8CpuIWtkPLCOmIEMFEGNFd6WjMMwygYJ/rOX/+TQ5yWzOnZzLOfzbH6/XVgCTVxhgY8Jc0SH91nn5il/R+7GB4XVLhFNeJ3Gmztne0R8Dk978raVLRJFX0i3nsM3BQo6mhMoIoCt3i6Z9brVze5FeIjHoKV51yf505B/r3M6N7C02IDFDM/q1v9A539zg1whMYWL3t2mSOfItOiKtQyFm9WWGCUiSAmDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36nlTOlTLMTxpspKVCPpHxZS/J4B44QEijTKxwhPzsU=;
 b=RYUyAia9122ju9gq4ZrRKnesMeRYrUEb7oZIrGk0YEo2fVrkVOWkflrB9gfB0CIlIUYb/gUN0/+hCl0wFoyjA0OGRqAjbR8SCrhsWvkS+yJo9Pfiqt3rF7pT1NGXU0rMhNjfYZo19jAaOFPW6wXR1s1Tf69m/N2EAo1fRz765kE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:57:50 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:57:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/28] scsi: iscsi: Add task completion helper
Date:   Sun, 23 May 2021 12:57:12 -0500
Message-Id: <20210523175739.360324-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:57:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94c72055-68dc-46ca-73f8-08d91e144769
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4004DFFEAD3839EA64A3B987F1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u3lwq6OX5VC0uE6sLlQy5ORPp4590LQ082xRCk9ke7jHp0CTi2C55nrju2dUT51X+AGi73iFBzEe+Ey/PVmEH1igEaOAQuBx1Zn9U7QZE8dUdXnWgOJ1umLdzNU1lPnwSEX2wI9mJjxIJ400gLcbQqlaSDLvNlb4WwSc+aff8iqU7zcDxfsPJtdnH1DBVMx0YKGeheVqaQ+rJLJBRAYqdV3OaW/n/OvLX6PQBguXf+pAB7Gjn0obrKeqDIg/tMQKIyM98Kz5lZ7rngATa+6U1g5ksTaA0bef04Kkl3nDH68bYksOYJe0MmXxFw72ysBCz+36kMyaeszAF+JDIU15oxqD4pbFg0s2pQC0eEHSx+ny2miQDH5YUnCLUHrjYzVeadI0UukMKjhxpxNQJACEafEwAUwb+rIGKI6b54aLe5rr7TnMTqIzBFnHNYgpHt551Q1DZiXQnTTCbqimgmza+N4DqrsD7QOywedrBzQ7sgiGWI0XmyzzSgVkpED4cvEjHcovm848SgiE6tAoDWaot3KDt9fZt2yAoM+hZ2Fws3gbNGSAnZAMClbDyozXBT3m5nCAkUUgLqtvjC9FwvNxXVGR5HcmUreqTR+i/KYGT6+Ckc4LgnD0V2I5lgdkumHf91gnaSPQNcvHARoDxDNs2n8b5lQem4yEn3Gklj09mhyGyF7FGwVOoicxf+bqFUXJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(4744005)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Lpfym4WOOAmA6Q/8eMkqF5rOIb8uhkM1DJSlvrwCpjqBWl88AXN8MKFZnxGg?=
 =?us-ascii?Q?WK6Lys+g9Ntid48cVH0Jd7TWPn902nFrxTJrnQGSl0SJzwqB3qRNPsgEX8vY?=
 =?us-ascii?Q?etiMZavVixAJq+1axwbqAsM9/CEMLnBCBDWxFXWZtU3wryw7OTlHXPF+WjQ8?=
 =?us-ascii?Q?xNJ3J4cx5UnqQHR4rka6iQXJn5MgjqM4QM8ZQeGv3Wt8rCllEvMYzykTsX9r?=
 =?us-ascii?Q?bH0PzP1py2n0EGtdFuVY90iVwukMFEmrdTmMs1sJg6q/iYKZ+AZLibIxpze5?=
 =?us-ascii?Q?bYPC9y6l9EnPrYcGsTEFZ6eYib/7MZH8xQCMJCOQf8iESxuyrK3iHIjiOFhb?=
 =?us-ascii?Q?DkqX477kMW5RWK3y6oE2QSepA6A7wWCmULqIkuc9LMvDCu5+/ieEW1LhlClS?=
 =?us-ascii?Q?KyUZGS4xNaK0vzY1o+rKECUYh3ssScR93JjGZj6RToMCscjL9fOsxcK457BQ?=
 =?us-ascii?Q?uFIVaFgOHECzVFKesx6P/dBKnik3ZiIwc9sTd8op8VtSmeoIHP+KToNmJgX2?=
 =?us-ascii?Q?FRBo6x68wwZYniDfNnD51Hw0UTRKiYsuH7OJIIiUzuDE/xg9q40oSxXKcCZV?=
 =?us-ascii?Q?F1OQ84JhItqC+VBCKR28sIivD4WjsmkmkcfWY7RlCux6/jxzsGP7i8lSWhGC?=
 =?us-ascii?Q?kd8/nS3aF8s1kstdknUI5ZDuU81RtBvlteIkKR6F3NrtSe+EvSf/w1JgQ9Qa?=
 =?us-ascii?Q?uNHhNCXrkAAFHQzvXB3MdFz/Uxho1+vRMm4MF/J4JwDKSixq7D1WiGr0CGdY?=
 =?us-ascii?Q?zprko1v14NarO8zFZ0qCSKRcE6YyUnbYqKgDR1/KPq++1/1q8QJgy8hNr1nE?=
 =?us-ascii?Q?tRP7hOC9pSt4AthCIkqAiL9tOfvMwWaOOkrOVjKuyStqeWJsFvN8ya6GTvaT?=
 =?us-ascii?Q?WoAA5vJXr6vQQ1K8JMWw4o8dS5i/wZ3LaBydYcdHsIezF+5IWoWRrq1x+XRS?=
 =?us-ascii?Q?fhIm1uhZKv5n6QpHuroi4SNmLo1R0TxZoHqQaMeKdGGc5ku3lzi32xFqOigA?=
 =?us-ascii?Q?PbcKg49lkB1dA8eIEU6fbWwxpk4tGYW9ah9PcOJZ0d9+3uhKH+dQRPlyaIk9?=
 =?us-ascii?Q?Y0484ceh0bhWEorr0SeWF78RMrQo/CvcL9KnJqN7SEQtXx52BLSkDd6h5J2/?=
 =?us-ascii?Q?zWl+w7w94G4IEIsNIcgPkwInVANC5mFgZ/1vgNV7EBWXKTr9hgVRDYPI9xH0?=
 =?us-ascii?Q?dgmhueMr+RwOxMG59tzGfkvPGvi/TSb8xi1d2IRGAPCemYoueLayMXX+NJ4i?=
 =?us-ascii?Q?baxCl59L1SuVwSwry07I+sHtrYBVRF+u1OcgUyFaD2iLnrmPKIqDNomFngyZ?=
 =?us-ascii?Q?Pju7Ljm0DKs4z/EvWNkIYk6w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c72055-68dc-46ca-73f8-08d91e144769
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:57:49.8456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zs1JNGbPewmQ2k2fTDbR8cdR8XnxKfQ62ypiANNGWev1ITr4E05EKaBR+laKUjmvecFRtwEQaPcqmrvWVtSctLqfc9DjQChFMOQGU23q2vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-ORIG-GUID: -bOD5wi1qd0pQk1EcJxpLnxyF20sGYNf
X-Proofpoint-GUID: -bOD5wi1qd0pQk1EcJxpLnxyF20sGYNf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
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

