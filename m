Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE02C25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbiHLBMT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHLBMR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:12:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A259DF9E
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:12:16 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN5gF3019404;
        Fri, 12 Aug 2022 01:12:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=FeV7oMY9JK8ks9vxcUnj+7WXe7ylG0e4NK/dgxJFKuw=;
 b=CLO8WyWmv8Cc8/AyRkPkmqMJbLsXvvtim8ylVQ9fEanlUoacg+FRcDCFANjxLejrpuae
 2vHkYRA5RPvzNqbDLno2TG9Od9UNj0SNHDPW7L5cvlYnNK/Oy7E6U1P22iXFOr1wswf5
 Y1ikiBUQQBsVnlJdSvQcZngTwzVV8te8Woj6NCkNAlQ7FLKv1epA8BjFYZzXY0TRG8Sg
 NDLVouj0ESy6pSm5wInyKbe6nsxuLEuccLY0KcsJauP0/IVHhaLN83af14/9KBkvKhvJ
 GeYnZPHkUnadkhwAHHYI/PuCNMbjLb4jcwQR08X7GUPfpVc1ytaxg9fam1IjUpp6MYK3 FA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq9p373-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:12:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27BNWYfD040673;
        Fri, 12 Aug 2022 01:12:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhdk73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:12:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJDoWJMPnLoa8KmuM3YMwfB6Wiy9SGAcenyHnsBo/gQya/7FdWGYTclk418ioLpbtICvs0j2SxiJ8xK/Vsh/e25UWLVlgWHSBtaXsGx3XIQ3iot+a23yReWnQJl6LVz0fDOQ6xccHsOgkjq+V1OJT3ZifVqozbKwblBwRMMkWksr2gUyl6UQTU3ALq1JtwMl5POKzQ4H2k7uMkbOsp7obPBTb0z9mt7rsNm99bA2wSkZzbarZtmKzfdMW/Sos5PxiO5CVxwPT1vwXqIKNknxJhSdCpwNXFHGIVUFjiFpIDFmuiRhOOjCK1ppZNegh+TSyRLLZl3koofLoCND4KbYyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FeV7oMY9JK8ks9vxcUnj+7WXe7ylG0e4NK/dgxJFKuw=;
 b=A5Xg6DPwJEvoNEDwqfcHEKf+zoTWTRrrQd78JVxZUoquxx8mkxZBAyemtqBON/uM0GV0dz+0h77vfwcAv2Jwmqauy4vlhbbZaz9we0BKRstSmO2RC9RraFX+YQesm9g1NaW0/ByX/YaWRxMgkSlrzBshQ2g5k4LkcBIH1H7bAk1hfsRTn2zWtNQJUAZrce3nOAj0rcmItNBznE4PD1V/js+suj19djUPQd3ZMJ188V3qzO5jEOsA+lrb/IfM5sunidTk+x0bdUVsaoxKqei6fjJ78xuCFjtzPfBGaPSexxPAkm8e76QU9u9VdLQ9DDAS+7IsGiQwuz/vu0kVzljurg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FeV7oMY9JK8ks9vxcUnj+7WXe7ylG0e4NK/dgxJFKuw=;
 b=Db2/pqZEgg6M/8kJB9ldPMTz9n+IblNbwgJDnDyuGQbH3TtftZssmzDS/mqpfmgp4V6BiI+iA4Nxb34uKUUiNXl1BFuJkd4aQrfLxChvKmBcNuZ9vig2kqtKBTeHG4TMK+4wOPPLXt/bg1/kNKR3n4AsA4aqq1UO58qvhYKfSA0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 12 Aug
 2022 01:12:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:12:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 1/1] scsi: Fix passthrough retry counter handling
Date:   Thu, 11 Aug 2022 20:12:06 -0500
Message-Id: <20220812011206.9157-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd16b71b-63b0-4dad-1139-08da7bffad15
X-MS-TrafficTypeDiagnostic: BYAPR10MB3270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c7JYS2ld3Cgk/PWzm14B+/pxLdO0KADjNJBpeT7IK+E4WmBTKoJqfcPPLGmKSX/X6u3wyJGxRxXZ5C+2LklKksbqulaDQHiOhXnpYMFOWM4G1xgdgfm0ibG8ZPBf5cRzkIbqdz8omfThRDv/TeqvFkXpMQqBZ9vyj/b+/TreBwfi0xgrH8fmfkrnDyKI7JertasmUft12uoNzNxFnyJ3s3dKi8873/jBIpO7oIFKl7/UtyF24f5eUfWk8V0yztlxQDCLL7ea3HjurxC3UBqEoK5SSIBjfaA/GdL2Df0PVG+NEtodtO4HoAqz2/lhdrEmo4iRAGmpEjeb4ny0JLEx85pljuY4D4hKO3rEHaU91xILNqDOD+8P69/+5D9Aw4IOY66fkC929kYdGoOEkZmqLXQeFfseiZqfQQFegB0LfpStDOhwNVxtj4adbFFODCDygrAAhNSx+ODLa/+ao5VZdpagZzfGprwOLLIkR1tlPC7Bl4MOStSkGJ+Pr0BKMdWWWgxqceYfeYjfPVX00wYkxKlXclR+Yh31/7/cmn2yw+1atcUKMGFqAYqWa2XW4kOHw/9rGQxUFbIjzUDahn+OpQD7bB+sdyI/p/11F1/oiDaTv5jN9dAZT12LrU9K3h/wV8TVkRsB2UmnZnvScG+wSONve3P2H4b+8aPyPuyVBmJ4egAv535NTVXFL037QlrV2vSubYhQI7FB34Kx93jYNrIGIZhjHQHb0UakeA3dpW2BbgAvL/T5GZyjGYWNgbVt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(366004)(396003)(39860400002)(8676002)(26005)(41300700001)(316002)(6512007)(186003)(66946007)(5660300002)(2616005)(36756003)(66556008)(66476007)(8936002)(4326008)(107886003)(6506007)(86362001)(2906002)(1076003)(6486002)(83380400001)(478600001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dIb+XSIRPqJV6z9aStM1Kxj5KkxyuC3oVgjj71b045tF5WpLyTcKpo8s6MqH?=
 =?us-ascii?Q?KovgZ5VCMWjPbFELeZFkmdYj7ZjKIXBsXpHTZ03UaZaa29jiCaWZA3/Imb19?=
 =?us-ascii?Q?077qPh7YeHbyhHiGeGlmfzUG9lb1yqIozpbLl4c3log8tRCL1nxi1ZQyiYs/?=
 =?us-ascii?Q?yguA3hGB+UpD12FCMNlDsMndQl2xtNiiAuEfjZpVX+HHBPa87GK1YeQktE/a?=
 =?us-ascii?Q?ANljQVlWC35hPMWDwBJ1VT3GjFNrNzyFcMSFK+yQjYUF4C4EIjdGuHTfuUhV?=
 =?us-ascii?Q?Rkh7gP4VZNlJITGHxZilbIVjUUzSTP+6vUK/YXHhh29N2efZggGd5a04nHNk?=
 =?us-ascii?Q?hM8/NheY2Hx1zEVDjAc58IyfuYmpTcvVulFB21ct1W498DkTALUsduq9j0H8?=
 =?us-ascii?Q?cFcH4yMJLrpo4hkmeDkTtEiheCSf/bYv+AL0onLEaZias3O2FvrjwVDppE+3?=
 =?us-ascii?Q?Nnogrj2vQsebzkH/D/H+8MDZPuimg0qizIAtJRnoIV2XSC4oGg0cXQeMWGN2?=
 =?us-ascii?Q?Z0UNwwnlodhur4Vk9fq4kf8usJPQNcl3CU6BFZjTF0OA28gsBvbACfamPtkN?=
 =?us-ascii?Q?Qwfz7j0mPgOMOqzzwIa4pondjMJ5fFdGGuZamb+FuyB7csCwu4MkqnZNY1rN?=
 =?us-ascii?Q?u6C7G/3xRevwL8Tp47dlwQJTXuDw29+hmtRfwtwNpeIF8NitQ+cyMFTk54Fk?=
 =?us-ascii?Q?fxqslzgOcjHJWwTLgNduEFwl58Ai122w+3nfZEhun79yl9NxqcOxlmZr2NHE?=
 =?us-ascii?Q?JiVlvdUKbT/lnXSXP7BvQdSo/o5WUbipOt6j1tZoGDND5Es+B2DWN459GvEr?=
 =?us-ascii?Q?gOJCc74GcLIzgEBzezcEh1EIxKMa/vKNb2hSrIzT8HgEB7xJEQIFKGSZVWs1?=
 =?us-ascii?Q?RMlNPW0sXp5ZBX4DsmxGBa6t7/s9cgCqhUc6sjlwWZdcBtKIShbuiBasPUaJ?=
 =?us-ascii?Q?np3Lq7Gbge1mmVq08w4zAQG5bqOZ6E9awsXSgpUQo8l3/j/JhuK2wNfpWGT+?=
 =?us-ascii?Q?Qi8vQsJF1MESZX0llf8G21djj2BF/zvcsvzvJmNTZ0XC2pPwoA50svD4ctMG?=
 =?us-ascii?Q?4JQ4lVomeRj4PsUDLyYPfOg4Eg5XN6/675ag2VdXKXCzALlrTqFc0jmt2cTp?=
 =?us-ascii?Q?p8hd9tRw+pavkSuCRbMSuOJJ5QqzpQiZYji5di4Rs2usUY1gH5Qdh7Jl7byk?=
 =?us-ascii?Q?ww+X8uKbim1kIcgopVg4XFa1Ir2CSjDpgZZkAgc0Bx41+ydofekXtnUAAWTO?=
 =?us-ascii?Q?mCfNiIa62N0zb2y8sQTgSxQe+3nc4ryJhkoB3RKnwz4D1I258kSW7ab3ocHb?=
 =?us-ascii?Q?siK+GLh2XbFBtBYQFfqGIsGlQbNkB9sblD6Rrd2SEZu4XzLuBO7FeXxgZi9q?=
 =?us-ascii?Q?MvRf14Zu4Ruv5qdphvvO8HvQk9zrlZMgDfynotB8ssRD4ITc5zNnKm/16JC1?=
 =?us-ascii?Q?cHBf2OhBu6kKIdx6IIjaBQCSm02NPW4u3DXPLqUkDX1rdeE631+RURTwh2J6?=
 =?us-ascii?Q?yg/1GCqReRGi1BFPr6Gk6P4YoOdcfjeSLixHZBiUBSsgx42cCoCUOe/iSANX?=
 =?us-ascii?Q?OIocaoc0YcPz9sLcRlp4RG6qwgdj2i3Gs+NI2qLch4+nboQwbv7T8Dz+lvqE?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd16b71b-63b0-4dad-1139-08da7bffad15
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:12:07.8468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4z9fWQsqRk3Plw6GuLF7ZcJYwwmBruZoSKnzE+p9vtHQdZz3bJll2mNfP+UQwowcQBsIYsTo1NdAbwQyr+bMoxzVh1k5hcGX4bqguXZK84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3270
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208120001
X-Proofpoint-ORIG-GUID: WT99qAKEkj4G9p-HSBJ85uHgiQ32mQhI
X-Proofpoint-GUID: WT99qAKEkj4G9p-HSBJ85uHgiQ32mQhI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Passthrough users will set the scsi_cmnd->allowed value and were
expecting up to $allowed retries. The problem is that before:

commit 6aded12b10e0 ("scsi: core: Remove struct scsi_request")

we used to set the retries on the scsi_request then copy them over to
scsi_cmnd->allowed in scsi_setup_scsi_cmnd. With that patch we now set
scsi_cmnd->allowed to 0 in scsi_prepare_cmd and overwrite what the
passthrough user set.

This moves the allowed initialization to after the blk_rq_is_passthrough
check so it's only done for the non-passthrough path where the ULD
init_command will normally set an allowed value it prefers.

Fixes: 6aded12b10e0 ("scsi: core: Remove struct scsi_request")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

v2:
- Remove passthrough check and just move initialization to after
existing check.

 drivers/scsi/scsi_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4dbd29ab1dcc..e29cbc13a985 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1542,7 +1542,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	scsi_init_command(sdev, cmd);
 
 	cmd->eh_eflags = 0;
-	cmd->allowed = 0;
 	cmd->prot_type = 0;
 	cmd->prot_flags = 0;
 	cmd->submitter = 0;
@@ -1593,6 +1592,8 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 			return ret;
 	}
 
+	/* usually overriden by the ULP */
+	cmd->allowed = 0;
 	memset(cmd->cmnd, 0, sizeof(cmd->cmnd));
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
-- 
2.18.2

