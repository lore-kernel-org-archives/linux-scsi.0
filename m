Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02FDC433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7055764E92
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBGErZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 23:47:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhBGErY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 23:47:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174j8EH174809;
        Sun, 7 Feb 2021 04:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Ug42sge7obdQ9l3QP/YnwoHy2xUqve80OzhxVRG6CFc=;
 b=ttAqb8RonumMmWCIH2gZ5sEgM8a/jC54wmWEwWpHzZyw8/s9hjxJz4GuQh6LJWDMrqnW
 YNaBh1fC6WaCzMfOkY3cnUJfoa+67MH0anV6Mnryx3wf63F9ccNwCxBEsBjFijLsnArs
 +tCy2N1f8uPzIL2ElbJIBMcvny4udKQk7huyz4irSPsc8+K0xPeJLg8AfL8xhAWeLfhL
 h3ZGcjOA93BeoT+MlxNLhZensurdjGx7wSuigWsLc/noXijJdDQ09ZI9Vu/Y8/5ozIG1
 K3rKpPfLRNy3BuIdvf53DABVPk47L5pOgPulvTO6XsDy2v02L46H32+mEz0rQceWhIwx aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36hk2k9b75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174ixmg004585;
        Sun, 7 Feb 2021 04:46:26 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2057.outbound.protection.outlook.com [104.47.38.57])
        by userp3030.oracle.com with ESMTP id 36j51tcnyt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPOPJnkScFGTdH471ddWhRIT0dPo80obQi3/4tCTJP6ltnS5yu2EEekkpFEfwhMbdN8i8h5VpECqR2+ao89NMoAneGpsepVSRBz8jTTRwWv19YOn0pEIhGH4guuWWhGr0jLQFME+YCKv10A+axtouDaVKIexLh8Mkyb0LFEhOES1W6OWBOiWSQ/MJ6OzElGsAGPBD+GBEEsqAI3iR/qMcxZFXA3Rf/T21VqDikj7qDx+pprED443XfA5wPkNtkgVCE3plqhrnL44miTqf4b8QzFDGPyfoTbI5zJhmECEFL2up8NHouRzZ9RjrLAg2qLs7Z1oRtNv4NnVcFoy72GHXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ug42sge7obdQ9l3QP/YnwoHy2xUqve80OzhxVRG6CFc=;
 b=QfvaybnhItlPEYlHPfeodk9/Crpn62srfD9sQm/atvdZ+tjiXnJyTt8NnjH4aorEjnK7+L/AlgBT0RA0cFYnbTGXD4ZeXW4tWGFLFtMa0932fGvpHEm1n5OgmanN463A6h4p/G8Mez76Uss3GttUOKafXKuf6fr9WPzPan/9BtfKtQL3fJbcUXpMDRzuKxWPdDiIqCRDqinBsSlsuQim8QdlGgEMiBI2LPwnGx22mjMrqYTIwz//jw9zgcZNt7XuOvR+2SBtwNtetcMwztfeBziEE0jxA2qN/VDuPBZNuDK7m/DSc+3rN1fgEcEbc5cecoIlrthdYhKuO8CwUMLijg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ug42sge7obdQ9l3QP/YnwoHy2xUqve80OzhxVRG6CFc=;
 b=KXVwk0AaZibWpKWoK8kIa2Vljt9a1PCjNFk36kXkzaYqZJBrMGMqp3HnCrICRGd68bzf2E20cSxwFnAcwYkalNIPyXsL+yZhXe/lT1InEzeklXR3a+6T44IeDYK0+K84M5ytWL7qki/vd7DloZ4LZFdOnC8xTwgvGSkuSUuVXiY=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3429.namprd10.prod.outlook.com (2603:10b6:a03:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sun, 7 Feb
 2021 04:46:22 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 04:46:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/9] libiscsi: fix iscsi_prep_scsi_cmd_pdu error handling
Date:   Sat,  6 Feb 2021 22:46:00 -0600
Message-Id: <20210207044608.27585-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207044608.27585-1-michael.christie@oracle.com>
References: <20210207044608.27585-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:610:58::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:610:58::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sun, 7 Feb 2021 04:46:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9577cc19-617c-4cdc-b94f-08d8cb23514b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB34294C939471E643BA118927F1B09@BYAPR10MB3429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1/B0bCczo1MAmZc77eAdl33mHf6UauY/FoXtookxCzsJxY4c/zHIUjgm3j6jOSFf3sUdCHlshQXJud0g0d+k2abtjSJ99Lq/1IW2IzmKSDvy2aBX2K7riNFOTWF3KPn82TPJi5eGaB5v8S8YspFz76iTsk62Hk8AwzEUC5Fzarx02i0/nq/ZlyhJ7LAbTcoJt9QK9np6JSurWK03tVQOVioIoL9042QqZPoJTMcrGTscQvSUZT9LQp5NZKka34/gAwobe9DF/97OevgZs8ryrHER45iSamgJG6OMIsNFVcz1Dbfwxfq6L5vUEqw0a8pgiTUMYfo1yPTMJZAl7cYDD9xTYUMOPKH8XiqSMiFSL7Aa+MVeU4MYHO71Rr2ZzCrd8MqPyU24nQ0k/aR5Zs4ngLcpW2Il/GWq4ayo4FiZsL9Acm1XB6D9hfO2pIvMIYIKuWHGzjAWh+9OuAGoNp7cqyjX2WuUdzxTNjskc9X2KFNaAagrp/UjW9zfeSilAnyPwPzvgz39Pt2fOKy9FBGaWIOh8HSZWt0N+5remWmM0ZJ/N5A/9J//8A7Ft/97bYWiOhFo0mNo0dwVziUsBmgGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(1076003)(6666004)(316002)(956004)(2616005)(5660300002)(66946007)(66476007)(66556008)(6486002)(69590400011)(83380400001)(86362001)(36756003)(52116002)(107886003)(6512007)(26005)(478600001)(8676002)(2906002)(8936002)(16526019)(186003)(4326008)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vBscKfRQqTqaaVSGLMKXHb/UaFmKIFS8eIijEw7PHDNNh1D/s63EbHYtUyTC?=
 =?us-ascii?Q?N3tbOw4tQ80SxofMGBKwKuY5p464RcfxP0ULGs0lPTQ7MWEinth0GPmFRKCo?=
 =?us-ascii?Q?Tl5PiyztfFbOtTEElIgebZuIX+xxUc2X4PXGK9ka3NHpTABEIEOu0dxLSHni?=
 =?us-ascii?Q?e5+4Gv78DR6KAB+HKzGHNJBlXk8PTOSpGPvx02KY4lmpna2V/E1CL12mR0F/?=
 =?us-ascii?Q?i9cqnj59sWVfaKClLxOghmrLZWGHsSpSiXvLMwmqMly+gUsoWKZig5m/VvY3?=
 =?us-ascii?Q?YHUEHrXi1n6KyX0m1HImW1XOI7RiRSaRhZ0EGWrjmtFUKy9uuTSqT3gYlAj9?=
 =?us-ascii?Q?0DtoOFZf7bwU/E/GNGxOaZL0YCL+ePC4yBXDzGBln9/y5hIk0Vw4sGvBDqK+?=
 =?us-ascii?Q?Zr8OtQUN2QBCyNZ0DuxBWmGcVD/VFmgqx78PESS9nDs+ZXYBhkoOMvvN75T+?=
 =?us-ascii?Q?eBSFjXArJzyWL77VJpJqbGFvvsOfF1eRLA3v3vDwErW7JQJ6S32lkD1szSPa?=
 =?us-ascii?Q?8WUGwmBAJvMjgBndnWU+6n5pd5EiLSX4VryfnP+4/ekCw2OT1kq0zup4UCQW?=
 =?us-ascii?Q?D3jPRlChXwK920bYVdtvFCpMC6wUSjzzLcdl0UHWKOACHHevkcte38TvjJR9?=
 =?us-ascii?Q?Kmx4cz1B9opzoC3pueb+ZVv6nqgwqdLiCQKYpntsZyC4sdEx7oqnGxK4RYtu?=
 =?us-ascii?Q?Lm/US0ik9ye8QuMo+4atUa99krFD0Hr21gHpfXbXDgyvaKYjf6aMie59Fl47?=
 =?us-ascii?Q?qifT5AcE6r5acD8DyAWYYN8KSgCPFwAkloNUXC996TfB1vj8RA5silJnPdta?=
 =?us-ascii?Q?Ih3iTn8Hy4kdX3RhATxY0MaJR1ZqA/WqmFpNyq4LVgU7SMk1YN+H+Tx7TQWx?=
 =?us-ascii?Q?jV4xpBkbC1oNb3q+UuGxeU5pnL5+f5uEvV2B/httZ25o509+2g1PmA0cyVPC?=
 =?us-ascii?Q?0Z/4UPYPHb2orrrgdxZ1cFGRGyFTwCn3MsSsaQHhYA+7yse7A9Lw6FQVtmZ8?=
 =?us-ascii?Q?TJ3NixoSrD9ec4QqMEtJZFWyu55vpBdHtBm6A725fJ8PsNqpymDBcx9uov8y?=
 =?us-ascii?Q?rp7vebhd6+f864hR0vW+JCTvY5WUv/QkvYf8HtFJw0OBiFfcIM2u+E53QZhd?=
 =?us-ascii?Q?tRt9XlM95wTZVBjOLJT+X+Rx2d26S/cQL62uvYTTMaK0XG70FboIWPbelwOp?=
 =?us-ascii?Q?pTbPILLMFmiuoGPxoaBBP1eGTbBYPb5Y+C7hDYH/o80lokS2w4nfT67/v2/U?=
 =?us-ascii?Q?uG0ppFIC3PlStO3X1lObnlhxiEn4tVTemjFUvehGqXEVsOQWwrqsdWySHkDx?=
 =?us-ascii?Q?t1y9Bw0kACruIP2JkX8nEhn9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9577cc19-617c-4cdc-b94f-08d8cb23514b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 04:46:22.4434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4CtzaD+NOcr7iwIJDG7zjIC6fGshFBGk0yuCWE0ersQ1EUsSVyC22VlTPByNVgaJQixXVB7JpItpHHhUQbKU76myj02+bK8at0T9xY2gUqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102070033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If iscsi_prep_scsi_cmd_pdu fails we try to add it back to the
cmdqueue, but we leave it partially setup. We don't have functions
that can undo the pdu and init task setup. We only have cleanup_task
which can cleanup both parts. So this has us just fail the cmd and
go through the standard cleanup routine and then have scsi-ml retry
it like is done when it fails in the queuecommand path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4e668aafbcca..cee1dbaa1b93 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1532,14 +1532,9 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		}
 		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
 		if (rc) {
-			if (rc == -ENOMEM || rc == -EACCES) {
-				spin_lock_bh(&conn->taskqueuelock);
-				list_add_tail(&conn->task->running,
-					      &conn->cmdqueue);
-				conn->task = NULL;
-				spin_unlock_bh(&conn->taskqueuelock);
-				goto done;
-			} else
+			if (rc == -ENOMEM || rc == -EACCES)
+				fail_scsi_task(conn->task, DID_IMM_RETRY);
+			else
 				fail_scsi_task(conn->task, DID_ABORT);
 			spin_lock_bh(&conn->taskqueuelock);
 			continue;
-- 
2.25.1

