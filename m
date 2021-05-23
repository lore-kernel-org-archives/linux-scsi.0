Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EE2C47082
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 873AF6117A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhEWR7t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38942 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhEWR7o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHw8Zt156619;
        Sun, 23 May 2021 17:58:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=/20VdN96OGP9PforO94u6WY2E6ORWpDvXUX2rKfJpaI=;
 b=sh2s/Q2WbA83K8l/qpalS/Z1quCfFnkDYusKsFeQhUqcIdZ8uAoW6DBDBvrQc//sGj9+
 cVmATSHJJivn8vHJV8qFaLwly6Tes2mQVDo/f9QmZ285a1VmF0Uym+ErD5VLWhSruD8x
 +CJUNbT08oI0EQHYEToc51RcDrt7nMUekp+1mD2PQSoVuOkgSfj82Qh9RcBrdaDm+/IV
 vnwmf2ptMaYf+QmvsmhnHdZPKlweMw9glwX2H4k3Ap1oif6JJUx4dD4I9fbHVc4moo20
 PwvVRM5Z8uYfr+0EnFm8xdFi4MTWLyzMwKwsqpr8jUmc2CNpbMaSBNPJSvdGSYip/4Ll rA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38pswn9fqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHu15T119800;
        Sun, 23 May 2021 17:58:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 38qbqqjg7e-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyDpr5HJKO5CcM1ag/jpDE5LccAakv8acrZY0jT0HlrG7afWSoiAxw5mWaLoSFGbOoualm60AfUDk2R9uERZwUmwHQfTVzgJ11YVjqmh/c3sakS5ecBmhVPLFPNtJNO9G2Uj/PClWqBtDXqn9/FNiIpaaiXehnqDLhMgk1VlwNkKAM2VkinAnWnSSnGJXvw+WE0R3Uead/i7RHNvM5dIRDXJie/pfTFBZp8oZ3dj82vpUmzh1Z5BQ36ECSkdoK4LhCX+U5rXIC/Ezwc2L02D2ZrbW7htdonKM9XLnCzH0ygQy/J5GdoX6e+F9Nqna5KNMGsPdfm1O9vljB1mgaC9JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/20VdN96OGP9PforO94u6WY2E6ORWpDvXUX2rKfJpaI=;
 b=Ec3v8zfVqFB6N8KSwMGWiBXthpytxKjssx3XECioLQ3q7dzFPcoXAB7d97cZnHukSoeBh3w07QEFgzhUR9lUyvbilO0DNaaG/WrJ4qrBrq0j9Wf7AjAzZVZ54XTUd9eUA1avXNLQo/7jYW9GfVGi7SE3GVT3JHcCFXTBNQOnD0p4ql6lpPJbNZQdciiJKyvqAkNLnIOvliSntf7nkMjuTnH3STviumuhyw8SaEbXOXAsAAX8lHrgIpTFqiSLSXsJ7Vxd0G6t/apusBj2inPNQKykPuNGm/TYdQ6yPn/aprMJ9GbNo2sQuuIsyIVTRyj7b600voi511wyvW+9eyaN+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/20VdN96OGP9PforO94u6WY2E6ORWpDvXUX2rKfJpaI=;
 b=yrVOD8Q+CFlxP9OUVi6zU2q+lu8lBb8xQ8V2hIKWsIE29R4U0XaWVBeOP4LhVldL/V8+tlItVRHMXgB3vkr/em2D7Q4tGskYAKcnjjqs1DdO9B80UNNhCTwJK0/Cr0xJ2JVh4GLSkSaANPG8z9Q/ACHSWmqfAXrPBiqJG4zoNj8=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:58:05 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 15/28] scsi: iscsi: Fix completion check during abort races
Date:   Sun, 23 May 2021 12:57:26 -0500
Message-Id: <20210523175739.360324-16-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f3b0289-559a-4221-f4c3-08d91e1450a9
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB40043AE8D9D2AA91FB430BA1F1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P/TmowlLkTE4LLFKoD/B9/812FGeUTcbNPvrMlfqTBsJ6qXQL7wGx5TLvkTKT7KFVhkUVLVGlLYhhU94A+C21xNE2/37bS9/E22NuvyrLtcY6zASq78fVRuphzIP0tVWcip3FSZ4O4pxoy4FRBSsAY2vOHaa1R0B4MscndKZyIClOBFT+HDkEZEpehj67BeXqhWE4mGFIZHnnC/XNO2wJv8WXiCapSRz5Rw2gSkfySb93ggNsGPojx79Ywu0MaQIaFWkFQge73R6jIk7aaGWnUyPX29XNMixJ5scXBbFZinfHTQlW3EpaDZ1Ud8DetFxcn1ZQM4WN8HMMHVJQdIiWBjujbUNhr/19HIGX6M+56Z+tC6U5vsMVrn9zcwaKN3K1dB0lxvzfFc9RjYt1OBRLoqzSBbogUDaD1H9IlPcANneOgCgluME0F8mWUD/05uHP1g80i8Dp1ZNGlSmKhsfqW/1izZglQxRNih0vOtnVXl12d/tFTsJiAG+myEPhRfsQ62Q/e1YtGxtKtMJqYWf2Y3P9DIJg/u52n8WFtxAKaSJ617iQNeH7edGD2VqNEgtjUKgwxIeRH1GNytrEGqOYiPVWzSeOEEW6RxP2mNLbMaLwtnJpv3zH7V+ZcMCQ8xms004nBRnXV+ncKIuRYx1FjBRSiAzQAKqxRXwTxDVLW62F9yZhpf7ThvYJFXTKmKa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(4744005)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qFuEmfRQe/rm1mXwoKBTeYM7h5ww+Exk1iqEZWpparVM4EjjMh6aKklf5jLJ?=
 =?us-ascii?Q?6yd22cDQePbp8EximHezlzPAOXwpXKbllQ5VSbKFWmPgfinID1dMkp3yc+ZK?=
 =?us-ascii?Q?d/JDdtNhk+rERrKKnhBItpLYfmR3oPOon0ZVKgyoqI0f4bGpeANMLDGJOfVF?=
 =?us-ascii?Q?dlEq+xv05bzj+86qeOPIEy71uKMoLu8s+0aJ4EaXzGBKmok8C/clOQyNMnLA?=
 =?us-ascii?Q?ghVqEAu46TlecZOOxnazBAg/AVYFKoMK3sHdrCEMps7fcqZ6ZEemyS0NpKYi?=
 =?us-ascii?Q?jjMeTu5MYeXhIq42Lb0ZO9eA9rs+fz5pMkj1Izx0g6jtPEZSceQNkg3eaA5K?=
 =?us-ascii?Q?XtRt7oo/d1lnv3uSsuIQI4z1PDprKDukcYGsXzw6lapzolxxV634x2m0sMH6?=
 =?us-ascii?Q?G3s1SH2s0pdoZiR49XDdoH8NPi7/OCN06EUuPYf28x5LUa/zeQ6ZuO8RgL8k?=
 =?us-ascii?Q?2dotY++7+/GDuI5XF2Oy7b6pubkKSQC/hbZt7bLRpuJ0nfnykGaxiF6f9Jva?=
 =?us-ascii?Q?WpjhtrWlIr/sJ9OkYXVuEASJvlKcuj9w1HRyj2cPqSL2i79lrRoMEMDdR6Kl?=
 =?us-ascii?Q?BYklaC+oMzzuxO7R7k5eAhCQmUgLZlNkpVDW+zURb+lCK22JSa15haZTaVJg?=
 =?us-ascii?Q?0D9yH+zllSlHM3X8ARfqWeiyG3f0xlB9uRUI2/a2gt7ZQPjD8PVvCZTbHHLF?=
 =?us-ascii?Q?YW5OXpLcBPY8YBzNEK8YO1MwUhKVx6EZ24ujxXyh9eb9cxOa3qAgF9MbJ88U?=
 =?us-ascii?Q?/t9p1/jz9DI8WwTVg8OKHGwMx7RTPh0GUAsOVpkCU+fW6ozBPClRR9MKxqCK?=
 =?us-ascii?Q?cCqOzfmm0h7MEL/9WZEQwDNlbhtqN+L3dkUfi2X/qFN89BaUvnDfAJLtJP09?=
 =?us-ascii?Q?fC+QoRO/O3ebCJEwLw+uFD9MhdpZcQyPz3+AjgEZjeMmXnRmTqRIM9anFmGQ?=
 =?us-ascii?Q?LEyWWfM3KD2jPPCtZYXxSadksRWq7Pkl4ZwvMGEuXCUBGKkDiea2PL+C1+hr?=
 =?us-ascii?Q?0Ccy+nFU4oPHpSZEp49pBLEA0tdINHCdZzxunWpKHumpSPFtmoTBadXEbkaF?=
 =?us-ascii?Q?zXvxwZozJOk0/BCcihhAYOpTuzZgXFvcMco0t+UCc5f/MZ0Mpn398e+Vjc7G?=
 =?us-ascii?Q?9YJBSqLTGAVi5Vz+l9tMQ6zHp5UL7iWPAogB63QsxOmKmBr/2p9J8e15OVcs?=
 =?us-ascii?Q?ck8T+WCZITrmY6bq0CRpsXHCf80W5Hiy1UlaT6IFB1/R5fXd9rT3yaDd/e2J?=
 =?us-ascii?Q?fksyBJYvV2xiC1CREGxuNUOKyR+q6p3OyCPnvo8LTru2IGMiyK+cHMx20CS2?=
 =?us-ascii?Q?qHpKIXh10jWa8jF90KtKIsb3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3b0289-559a-4221-f4c3-08d91e1450a9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:05.3219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 05KvSkVvCmhs/wooHFAgWCohmkiVuU41Jugu/lC5rzF07x6jFVwbakIdXzhfYaXgzrfasXg2BbT6c+X6WsTBAhhEHJrYApeH54ShB2rdBOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-GUID: DeF5iz9vTSiqubwFeXUyALl5bpEEm1ZN
X-Proofpoint-ORIG-GUID: DeF5iz9vTSiqubwFeXUyALl5bpEEm1ZN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a ref to the task being aborted, so SCp.ptr will never be NULL. We
need to use iscsi_task_is_completed to check for the completed state.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 94abb093098d..8222db4f8fef 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2338,7 +2338,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
 		goto failed_unlocked;
 	case TMF_NOT_FOUND:
-		if (!sc->SCp.ptr) {
+		if (iscsi_task_is_completed(task)) {
 			session->tmf_state = TMF_INITIAL;
 			memset(hdr, 0, sizeof(*hdr));
 			/* task completed before tmf abort response */
-- 
2.25.1

