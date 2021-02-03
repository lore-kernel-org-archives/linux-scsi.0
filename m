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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624F3C43381
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3664A64DF8
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhBCBfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 20:35:17 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50444 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbhBCBfJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 20:35:09 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131XXTV192551;
        Wed, 3 Feb 2021 01:34:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Ug42sge7obdQ9l3QP/YnwoHy2xUqve80OzhxVRG6CFc=;
 b=a2EqsGmWFdYYi3+1J8isb9Q7h4RxWjboCb1uh32HVFOhq1ytS7r101kfdju6D8TGiWCJ
 OC3LhNDmnCftIomFTJXMyG59ZfXKleEiWOZqMspcJQOOR+ynQh8HUwAtY8u8EKlP7D5u
 JhvKp7PXcBs0RNYanj+Ul2MtWYuZbBq2QpG3f1os8rLeXj6+A9pbE0oioUMgoBMmPi8l
 povqxR1eqvXrlK6goLYewrua4O6IeS3tvMnHliM+ahejQHEFEPH8XIuLPgau8W7OQqHU
 b7d3vyrpb2nGc2rMZ+4sOxMhlcLny0iC/hddqYHXjWioeEZGcb2ugctSJQHdnitTmTDi qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36cvyawtyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131OxjH139717;
        Wed, 3 Feb 2021 01:34:08 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2058.outbound.protection.outlook.com [104.47.44.58])
        by aserp3020.oracle.com with ESMTP id 36dhc05qfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ns5Lm9h5G2kmBHrHkSyjtCs9Pj1lXchCEqUv4j0WCgZZa61dmhC+L2E2mO2Wmc8mG41ImIvgYK0EyCNFb0qbY9VWqK63/kVGkKwIpHUxkznODjHpdsUTPqgz5rWL+Ym2fqfvQ7+4MyUELKIvbOjoB8X3pn+qfDg43oZoesOKVcTe/8fOjMtGQWT7kJCOQSeP3V+wc2dmdAfdpvH8cImXXfnJC2Y7Est4YXLXAqs/qxtDtCIIrzyIsa+rjTURuWl3R9h4vIe0LCD6br32c73HYsoudQqPTe6x6PEMPLyTEqZw/Pmb0YiwgxFf7+QhlLp5k+Go8p1iiMBQdDIu654Sug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ug42sge7obdQ9l3QP/YnwoHy2xUqve80OzhxVRG6CFc=;
 b=Udg+ixl8+5YFBZLa9lnbeo633Ln+SbWehrUYV+DUSYlvj1nui9WSWzmByaUomb3Xqd7l1bNuQSYotiWx3f1E8xPZZDWVEInMoYD0sz0KwAqbwd7jDNW8GduxYK7YH64+Rry+foDAvO+DYZU7voYQ2vt53ggKyy1Ba8oxXeU1UxMsT82JLKtYDA/jKlP/P205Jy1kPo3HEf1R8aYFMZ+/rF6E15DEU0GeD97jmHzfQ0G903CN+Hhpot/4ROzvyApR4LeBP/3zXSSm9Z15kcHDx8aqKYmRuGypxnjUo4/MtpBJoZ2dwXUSItnOtRUUY4XGDruQX6GlkfzoI7N0ZP1gUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ug42sge7obdQ9l3QP/YnwoHy2xUqve80OzhxVRG6CFc=;
 b=xc6xT047KTzpduq3ePuF1NruAU8zzY/zT5iQd2vukYjYvZOUyVITEQaTWT2s2gsiZ3YNKuWBGqPG79KbFqXIrC0NF6DQnmr0ViYu7k0YeUoPFGDGbGL0WGi8ywTRo7RccuRwYwggaiKacOtQ8Na9Bz0qMcIv+2PpsFD55Uv07LE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 01:34:06 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 01:34:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/9] libiscsi: fix iscsi_prep_scsi_cmd_pdu error handling
Date:   Tue,  2 Feb 2021 19:33:48 -0600
Message-Id: <20210203013356.11177-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203013356.11177-1-michael.christie@oracle.com>
References: <20210203013356.11177-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:610:4e::22) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:610:4e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 01:34:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3e18d69-1bf8-483f-57f4-08d8c7e3cbaa
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB53203016BC4E90C24CE5DF3EF1B49@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mo0ClNKaWxvZsEueAPENIsiDzLX+AMc2BI9rvOAYScvPlEzUEYoyhvghuKIIGBF8WIUCHk+NQbmKgAdZq9soV3TJbmyRGvcjLLSv3uID1kmm0mLn+SjdhZrVUtjUS2jnb/jQw3JsfylxxHlPhYwAYFa/PymyjPiYFm2bqEGtFf1JVBkdb6zdomGpQqHxka/Fx76oA+a5ji0w3ofVLhTA5AgpWXBPBRH0+jDQBgi7S5UGIaKQLsolPXbMw2GSx+BWaS5FouwESgM+7DQkQChCyrDQoUFGxt6s7tZ5bkj3w9+mDpcwPlIgsiN6OENq+EyLOQbXfUQKG631nRYeq+cmORalQx/PDNurHePugo7SHbcSiMLZ2udlGFyeCjlK0E13fxJ8MeJqmoefSSodw+jhyISVwlWHtV2IlTBco31VgtiisLfMCCdrU+NyFhWNLGPNOnGszyRF2gmYsPC8+AG/Yu0VoGv6ySZpURQ9XLH835JdXXEGufN7t27Z8b6qCQupIAjXF0pE/wi12yrDL7q3URzIdlQ6IPfkrp9tS87OTHRt21JT94OTuvsGK8xApbat+5418PPhXg/xQRqRyLOGZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(316002)(6666004)(69590400007)(956004)(2616005)(2906002)(478600001)(86362001)(107886003)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?36pylN/ZKqeD3J0at4f8G4x0dK4biDMZtwNRghXBTuwlo946qX3r+SR9XsRf?=
 =?us-ascii?Q?rmP4N10b+OY3jUidtvW9zcwxG6kq32ukBATMAg0rbsiAlqtyL6uDfwYDEI73?=
 =?us-ascii?Q?FBhQygMHbyyCG1kmCnJafzFLdvQmTGNXegz5pvKJrGQdPl/kIgW27WGEneLT?=
 =?us-ascii?Q?iT1nuQ2br5WTykH0bPwb6Mj1vPvGuC9/tBIpxgzy5/EgikeiU27R0jAfaDrs?=
 =?us-ascii?Q?IdF2C8Q4vQlLJjLnUMx189oydBUXg8reYiy8W5vObhDXYQVlOLsEzbEcOk9G?=
 =?us-ascii?Q?Zq4ZOzJuDdTIhp1WH2KfDJZGKsNtdKoE1EsDidhx1H0c1/B7ZfUQoHTeaX+p?=
 =?us-ascii?Q?4vJGGxZS4CcuH+xE9qjj8Hh9ShzcudMJKeVSRHzOm+5qqgPNNJMC6fXyzZCd?=
 =?us-ascii?Q?+C5swPgh29qd7dOEigN5Vk2GjQFm32qOofmgxkf1BHCuMCJZqZDzjm+sZZq7?=
 =?us-ascii?Q?yKh0QsiU1ahulgg3klNAW66Pr0ouU4L8Udji6F3RaaAygO0uTTk5l+dWkoKd?=
 =?us-ascii?Q?35kMgaDrCquTjPR7+V51L7sOCQaYcCTcai/nyI9jRyIdOcBwuM681rrzzPbw?=
 =?us-ascii?Q?y9oxYBUhIlIh/3p3W5wx+nMrMZ/8EbMII0xd90Dab8hlNQ6msS7O7w5zVRK+?=
 =?us-ascii?Q?sBtqsaZqEqJ5AbcMDJmWqlzzayhRn/3sovb84BMTD657aPKa/dIWB9ZF9QxQ?=
 =?us-ascii?Q?GzishE9TIzUPOuBbUNz0b0SqznYc6If4hEMGn7d6EabuWWjMjw82Qa2MhLEi?=
 =?us-ascii?Q?h7B9PXcS6zCvt+7ig+McnMCuWoXIwJh2fzHgFLUtQlX6WbepJhJXhV/ybiey?=
 =?us-ascii?Q?N12zymkm+lDbOFn7tcFoQiIw5OrM1Cp3UGMDKdWl1TUD5qXjaB5cHe2Q+c1t?=
 =?us-ascii?Q?L80uPJFqkiNA5lRmrLj/L0oFt5zZxw+7l+1zys7hjRjy4yD7ERI3qwI1UJMB?=
 =?us-ascii?Q?DCeNRbL/sdEoV1bbhC+cQW1fXbIuGp8OWQXRB0Gx+ITnzhzi2b1IDR7DIhA+?=
 =?us-ascii?Q?tUh/jpi3EmvvIXLvPnLEUPmC0MaOw2OV4abJHW7p2RhFruaPut2J8aSxnNcL?=
 =?us-ascii?Q?3mAO2q3g?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e18d69-1bf8-483f-57f4-08d8c7e3cbaa
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:34:06.4595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQX569ghkFhStEGAQZgl39NTie7E5gs07H96fqPzNtVL8OsJedCvz6S6Ki+W6abgeR5fEwBpLveNyjjLK7oKKg1iyUqV4UgA3CMlAWJTy5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030005
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

