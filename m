Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97033C47081
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78BC2610A6
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhEWR7u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35850 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbhEWR7p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHw8w6121544;
        Sun, 23 May 2021 17:58:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=9h7gHNgi8SnQElk/vdcfQq7Xg2mk3YwiJEPbRRDKf3I=;
 b=tyMQlyANlS5gn953a1tcJHAy0OIQUdiKh0YoTAPHxFRoc8zCMRx/A8998WZwh0dmbgS6
 lpWsXX+JBRR4CiaL/NIGJend/Eq+mrX/DIj+4WEJVIih/xKClQifl/jUKt1CDHlWFoqE
 pLvsmgPqkRnbeNPUYbmqNqWD4JOTM2msxVejwlZOa2IOMf4H0XdQ9Yfx15nU1oVPlbuC
 SDi5W0fiGakeyIokMowzbuPoT47lLSEjLfMUFs/24pvwpQIPe3XXYN6usUOdyFxdtKKX
 u4kEi3SLriwalh8Q3iNGP+a8B6NNPuw+dbqg+8b8hOMDMbWJW1g4dNymeM8b3MCOBcZh zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkp1erw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHu15U119800;
        Sun, 23 May 2021 17:58:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 38qbqqjg7e-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=la1WrRE0ZCOr+TNazGeXBLmMEOuGUB78yYUGWEbuAYve82p6qZL1y0gM3RUNlkf7xxMOESt4UirZI+I6sltBAs1WE6cQnFQe7ZARz4n7sPOsUcVbTfvaI7iAjKVqhSfiPJMSAKUP+UBkqCv7kuNYmJYsGjq0eHftJ8yDhZR+xg5iT1/tDEqECALW4HJLob18Jc32sa+K8hFBOAjP20lVTE1CI2xyD9PeCK20sylADvUpGl92YhK09lNsidlPkr7/7HI4hK/Gi7+rz2wCUzRiw0Oie2WFEKeIynoW88JRo6goqRfOgz0Kss3e0I5tKoJ0q+nTl8IqN94hGJvITulM8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9h7gHNgi8SnQElk/vdcfQq7Xg2mk3YwiJEPbRRDKf3I=;
 b=bgVXftjmxksRIa6yonMP0p7BGWHk7ROINZFjj9ZhZTFx86etRf7cla23MtXtXz6DAdsbbGrNmcS40UTE8Rqm/HRQTfMDxIEOQqHYml3W1XKNVCc/pThoxBAdmCJvv7DNTXy7wDjKWb6ETe9uwrvS2+zeu9GrOEpN+FVYRLP8CdY23HjUsFY4NLhJ/RpPdtUFx/do1x8IQ8qxakiAxNeYlX+2x2UkAxQpQ6UaYeDHusYtM5CS2lr9IJcvxK4xttIAs2HQm7DGyQmqDjEBBak29KZDL1aMCYwQCJ5Cuq8V5AHkjO4UXy1mKidUqy20uz1kd4NURoePJkM1BlZWnv1utw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9h7gHNgi8SnQElk/vdcfQq7Xg2mk3YwiJEPbRRDKf3I=;
 b=FyiPclF6UySdptYq7pXbnu7iduvP4Bi4YIqlEETO0UCyZ6mCBvhjdJ3NuVVbE6JaYHvOh+nAMUAo/yzChLLTyYG9ND+HrgYYWZfqHTIvLygpWosgwl5T1vxpqo6DhU73fJraaxszTE/G7QEoFRHo0No2L2e9c4RZrbA84uZ7Dzw=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:58:06 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 16/28] scsi: iscsi: Flush block work before unblock
Date:   Sun, 23 May 2021 12:57:27 -0500
Message-Id: <20210523175739.360324-17-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c45e5462-1b7b-4f27-6685-08d91e14515a
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4004C2E459DC0626472DAC84F1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lRn2w0joTtVtgDZ54xLsDb/13GxsVaox4euleSdZ0OYFYbudvKL0C0V2w/5se2Ysb2sJBGi6AbeWqnWDD1FfnpcP31pq6EwwyYM0ElVqmHxho/8P1l7ECBo4lPC6bBLKXEJwRxfjnWp+eGMLEHXbCorRea2tDjuLJUs0Bpx2pnpsBwj4+lCtPRJoews//BBqU5cXT9MWdd8bqL6Be9uKTmG2OmaPHiu59PTkDbZ5URuJ8v0nfxGFTh9eBo09teSXopRg8H1QGgk5O3Y3bw90XF1wpWuoIb+vV9Z/RYJc0cSemdnrFbFOA7F5/uctAUhfUN5X8reMKFrNBrsHxktpsU89El9AY0dREIUl65ge12DhJvgAkLkYg2BOKFqe6c3iHMjiQcCc7BikIXLW+vhS9WbGxZotCKmRZFzI1oU9HmancVaoe/PdNx/tNRrg20mJDlhls7fJWN+4RrfbufjlCjxgqRTtzMeLF2GTxqUGc+xoHwm8qATiYC+itNqYaIBxgwnD6TQz6dFQi9wSMYNCQur5msIiRW7RIBhMJzWWOu3aEsNFCM9lOlFNIGidfbyv4710dzKxBnyf6Wu80edNrFCIrs6AInt+YEM6tSO9m17i4NYq6ytoNJp/m5wAxtAJYbxJpE/dYKuQMQrHLpc4JGUDukRwXYh3dbfa1+s/2O24nJkiDgO8GLDHiUb+Jljq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zbTiqwO8htfM515i4RXBV9+qp8MT/S6ydZVx4C7E2yADRSw7ZRPCGcWOoPIT?=
 =?us-ascii?Q?YlO6daE6VfRRLEhuKkL3kajSnAvY9yNPTh34p5TTqpCGp2cE4xg8euYS8myU?=
 =?us-ascii?Q?so4fEh6dbDvcs3IeymXsQReBjQZX/OfvlqLR4MMBZksNSk/37ZqWfdbG8NXO?=
 =?us-ascii?Q?yCXhD/C9g/bd7FPfwefekQ9sEV9AHOkPUwow/C+xyZYG9LDVAoFwvWpKTM8V?=
 =?us-ascii?Q?kqgKzNZhC12PUyk2KG+6AEIE0oS3hIwhBewvoi0UINesPVilFJJi3EPuINFJ?=
 =?us-ascii?Q?84IweYYQyhyDo1PCIJoBH06yuAgzdXein9ay+H9oU8OCE56zyq7kHvQ8U6kO?=
 =?us-ascii?Q?MyruZkkZqrKkDYvj9SL7ssS3rhqKT9eDVSWi9MCh3wHvzNTpV1YwYcLQ3B4y?=
 =?us-ascii?Q?lKdTo5+6HUf8bHbMw5L772hRZExIfcqHc9/k8pNBx63T2pw7g2jjAU5tT1z5?=
 =?us-ascii?Q?A0cEqkHabzWRPBVi6hyW/+6NzIlqxC9ppJaMSDA3fd24aoGA1lm2BCHCNZwd?=
 =?us-ascii?Q?CA7UQraTMiVm0tLg6HmnzX+5DBsq9XrMeC41r241/uk/PgBWp9+Z9XULmfbb?=
 =?us-ascii?Q?Oa3mzglP3uXlitLHEPy08rPu2h944PiZyplyYLjk98N86ZQpfDH9r5FD8F/h?=
 =?us-ascii?Q?IXteDxJeFVyAqNKpt2KE/WkTCuAg6Qh2bts8ENFo04M+ph26TeA3Jf0Bu+5d?=
 =?us-ascii?Q?susTg9etn2odli9Oy/dvcrUp8L1QQiJVJraRiOIgTRXMgU8+dsKHueWSOboG?=
 =?us-ascii?Q?l/vdg0VtdotHFWaeS65rzCXBeSxaVqobnrwkmuk/mDMYvl3Rzxyu0s4AaV7T?=
 =?us-ascii?Q?LWDs7PBkqqdlDpsGakBMZUderEPrBq7J65nTqK5lOFMs31AS7KSri30dHpx6?=
 =?us-ascii?Q?Da7oA/JV2yoRJ+kilivtvKSlyDDcIq5OuOXVbXS+1gCa1ZUaMbhAjRyJ5boj?=
 =?us-ascii?Q?Kwzo6r7KCIPWmKZko0ycUpNxz+Lm1lzkd6Gx2dGeEEvaUeFWypNfUVw7Gldo?=
 =?us-ascii?Q?gEk5+eWFbHnzNOoyeEcNAn6JhqXxUuvne66nmlI+KOStdMYJOfyG2ao3slXJ?=
 =?us-ascii?Q?mTWj/Kcsg+44feHqQmeqKUnB3MwzSDwjvtkR9MpjeD4N70oRyd04UcW9aszX?=
 =?us-ascii?Q?57cKkkvaBKcKTzV+4+R72lVSB8LTKqr0kgSQTyKZSoysHPKyureap5e3llEg?=
 =?us-ascii?Q?B2QZaiLkCEI0KONzTWL4YBQz0MJQQPB3WwCmivcKc6v3VTmupy/UH1cKffDp?=
 =?us-ascii?Q?gcA4CsOZcu8nch5Qae/Hl1GeU3k8+4+FPV/3WfasJmYCHS8b89VEBuoNbdf4?=
 =?us-ascii?Q?ilO+dj6ad5I9BuGzswMn1awg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c45e5462-1b7b-4f27-6685-08d91e14515a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:06.4822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: saeAY9JSGxXNRcHkndGRt6RWye89fPUcs4fLPuu9jl/5UJI2CR71gxxiFNfJz/8BrkKe0sqh4+ugMp//x/98Y0G1N1+NI8dr7hYc1IGphyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-GUID: hfMf_I8vvyMk_ti_BaRWjVZAhX9gc9O7
X-Proofpoint-ORIG-GUID: hfMf_I8vvyMk_ti_BaRWjVZAhX9gc9O7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We set the max_active iSCSI EH works to 1, so all work is going to execute
in order by default. However, userspace can now override this in sysfs. If
max_active > 1, we can end up with the block_work on CPU1 and
iscsi_unblock_session running the unblock_work on CPU2 and the session
and target/device state will end up out of sync with each other.

This adds a flush of the block_work in iscsi_unblock_session.

Fixes: 1d726aa6ef57 ("scsi: iscsi: Optimize work queue flush use")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 909134b9c313..b07105ae7c91 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1969,6 +1969,8 @@ static void __iscsi_unblock_session(struct work_struct *work)
  */
 void iscsi_unblock_session(struct iscsi_cls_session *session)
 {
+	flush_work(&session->block_work);
+
 	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
 	/*
 	 * Blocking the session can be done from any context so we only
-- 
2.25.1

