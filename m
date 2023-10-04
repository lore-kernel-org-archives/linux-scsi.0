Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF592E936E7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243933AbjJDVCo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243989AbjJDVCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:02:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFDBEB
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:02:38 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FIwZj014504;
        Wed, 4 Oct 2023 21:00:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Bvd9OZQXP4ZTfBe+ZucwdWwUHzLu51vzP7zdoAxaO8c=;
 b=UUPQYnUZH9Lawh7LRpcH3H1nJlrQLCyGo4c2mBj9nokRU3kA28lO5bkJVOdU931VP/Hq
 nBSrocyLcRbGCeAR67w8Leswt4hJIYlbZMjREFDSUsT1CUCaoWm3nOwVu3rNQzcunJIW
 EnC0sl2jFTQ8KMKyxE4gSgGk3Nh3y4CD6+wdiRjVcMe11dNA+LCI5fkbYcTbmJhFOWOG
 upoNyYPV+fL9XMnU4NpLcxqAz3+eSgvpK5WY6HeP5pV+Vnb+soeCxpElkecej2cbRlX+
 Xy3wmG9x/z4ZZudPTFQYeGtq1DQVBmwuR4Sgu+RBHT78zEoFnsXTI5VPESCqmEkozG5x FA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea9283m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394K2gw3005824;
        Wed, 4 Oct 2023 21:00:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4869j4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqstWbxYob1Oae6OjQGMeSLdm999NoSrVeKiPx4JrOZ6AEacWrX80Zs2U9EYvx6ZfKRSiBLI+aac2r/qCgjj+eI9BwCR7hFEz5hceR6R8PMlKsYsaIrSJfEeJ/pMSdop4kdRUXTJ/7RKZ/CuzcpZs++m3Hyu1eZQgJVtVvEfI8nJqLO8oEcV1NaLHx287DRWG2gckm6YfGIo04buyT86/Hi9VYeA6/ByItmtmubDVXIadzBYDqZxnQ/l05W2vjs0JbGsZRtyTWW+n0ZJL++HyUhii2ouddtr7JDlZVFrokFxBegLZucE/39NJoX7P6vFRDJ286equ6AntI7ANMa7jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bvd9OZQXP4ZTfBe+ZucwdWwUHzLu51vzP7zdoAxaO8c=;
 b=hyHqZ/cMNzRS2dPN724zDylBvzTf4BbSI2WhZLNXVYw8JG8/zrgSU/bZG7rMSCoZZx5NpEefnTMhAQkJfxncMsy952DztDmuYl5f3kxmH/6ktlzr+cecwRleGTmVciuAa8qY7uHRiOzv+ClR5qGbMlbuVW9D3x5D+rr3bhiXG1LKvqZg1dx4RpjT0aLqOMhEIc+3KSPQkRbKfc0SY6tL468vrfXtmxAkSr4B71vVdMx/otxdwfPIAW3aQqfljJgn0dPLRhs0Ino4/Auetmyx2yeySXYGdJYwNIJr2EUaViDLqRo+rObEIGvL4phMikZEEWIQoX8tdXh3TYJa9OIXxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bvd9OZQXP4ZTfBe+ZucwdWwUHzLu51vzP7zdoAxaO8c=;
 b=blTDZdv8WytMAn+w9Tl891J8WH5Tuq+4PvhwGQpGz1dvABUx5RI0F4PsaJGdTlhftu7i37wfp729RlGbJ7WIuU/UTIABMTGIgGuHoy6rXQ3h5/IUOxkaI71rd+w27iwnuutcLEaXEQgDlIfUYDBH81G+5QYU2NTEeg3fYPUU+QQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7413.namprd10.prod.outlook.com (2603:10b6:610:154::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 4 Oct
 2023 21:00:24 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 04/12] scsi: rdac: Fix send_mode_select retry handling
Date:   Wed,  4 Oct 2023 16:00:05 -0500
Message-Id: <20231004210013.5601-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0172.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::27) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 390c2905-4206-4697-c93f-08dbc51cedc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sm6ccKXemx1l1Tx50ODg20lIodNEPlbRBPTHQpnUFxgJ9mnDOGy6G4vLUW6KhkI22lCkg73x1CH+r+vV9IOowvqVWU9MvdKFH8BEg33KzqhmvLdLAHkvDEBibTli5W5lS44PX43RSh5jPUu8AySHB3BIKQNgqXQxVircMw2NC3gcRDXnDUKBXczT+GWOfTd0AEcP/8Sxs1qvbhcOrMqSq2cSBjdhjI11YKk7n89+vqWzZYgKThfGBD8rV+0UoApORkSFi1UhUUMIcoAa5unjThDA3asch4/v6fP4E6yP2JgiDsZoCOuqPhqwIe75tz/RQ+t/jQCBNoRH2/5BGy740/pCtWFYCjGSf5VuIoWKFzERCS7s6LY6uDJqerf57CFvGHahUqKDhpMoG9aiXkDHNKXfhuLvhk58PCuH09xKPBsZEGSC2kqaJ0Oi0wKO2ZIRYF2f2mNczngQLVC8gV4CYKln2zoTsNOP7te1upxH+iJlHwqRyFLvSEczE5OpEDYKV1+IuQtBdqcIz8rusKCv+y+nNdU8fhBXaWFEremP+7e7K0YsgektAWvBoe4FBBHx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(346002)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(6666004)(83380400001)(6486002)(6506007)(38100700002)(6512007)(2616005)(26005)(107886003)(1076003)(478600001)(86362001)(66476007)(316002)(66556008)(2906002)(66946007)(41300700001)(5660300002)(8936002)(36756003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/v8uarNv+2SQO/Q6BaYutIprW818rwlnxcMfrSimMzq5BXQcsYn//ytLc+lS?=
 =?us-ascii?Q?Zr0pQl59KoHKVNB18TIMvj+G+6+sc8u7gVKsH/tUXBlSc6MSIsgGll1GCeFQ?=
 =?us-ascii?Q?tiyb+SSP+G+l2sExtMFM3vVPopSJftqAmqT3JzMHeByoyq/7E2go0982J0Fx?=
 =?us-ascii?Q?HwV4N9OZGJMvDIGakp1o6NtLCLugTiuwq7zJpMitw5wxRHXMu/pExTbJb3ml?=
 =?us-ascii?Q?f4WcuEh+iKRM2zs4YYcPJdMcdumFY0H1se9wEY2aCXuUHBml372qbABK53l3?=
 =?us-ascii?Q?46gLguSa51tJ8d0LXS/YX+71QMSE2el95xtgDrwTBjRazqB4iUJvTr/uzIim?=
 =?us-ascii?Q?1yOZaVeIQ6aFu04WK4ued4wb7hase3CpmoSm+rFpTao6urJORuKABzqyc3QC?=
 =?us-ascii?Q?xgTlSbnvK9J+zFRuBd3isuL0IVp5DEHs5twXazDVh3hThDCD3p021iqv1ywP?=
 =?us-ascii?Q?eGrd6ZV8I6msVO/xVSYvepSnt6fov7RPsENhs96dSeS/nXCgcseuMApQKy4q?=
 =?us-ascii?Q?i4war+L5Ld7eYrpWDgP2PuNdfHFtosSaFZiUBkbbFsWJilJG9jfq3gVWGBlj?=
 =?us-ascii?Q?y8ZFnD/+w5zULXzbAiKZFfwKaShGSMvIQ2hk6KU6c7WPokt62f4fJToQq/eR?=
 =?us-ascii?Q?pD8lJ1vx71ewXxaoQwIhmWZW/O94QVCED5aKfP0KPYUhIUPlOFW1W1uM8/y4?=
 =?us-ascii?Q?zqcXWl2mU45TSYktsKdUrXfxdLrPu6AFPtu8e/PxenIEyGjSbJiU5IpO4Iht?=
 =?us-ascii?Q?KDoKmSqOuLjTaj9Zqo6aFgFafBQbAZq9mKblQiitavWE5M6kiPwfWkOBkC+7?=
 =?us-ascii?Q?5NUJUXxSmKAxVnRfemiUhkQziDHuOSy1tjM1S9TopN/K9LMtTyqUZ13FwjQB?=
 =?us-ascii?Q?fn3NmbKiieG9m+YSj7idwvb9VpHgmlItpEfmqi54YeWDp6oSLcnwUY8xecNW?=
 =?us-ascii?Q?eAoJ8Dvf/KW02HJDYIswKz0uXGy1h4hTAs/m/9avbVLmwPZTF0e9s/ld5gA2?=
 =?us-ascii?Q?vDfa9FdoSC18VMm2V7Lt4r+GWOdY8ywa19yyFGZ0Vd7uPNqcMYjiJTHIedG6?=
 =?us-ascii?Q?uXuJqr/O+PU4Fp7KqSjW5xaLnvtvrZpkiceNagx3Cl6a+dNVBh6EKgm5G+0N?=
 =?us-ascii?Q?OAvL6Ekvhgdke0T7kzvBUN87WlT9Mq+KLVhHnfMZcEawZ3m9m2PJTq3Rart7?=
 =?us-ascii?Q?ambQl9ykB2Pcm2A3gByPvNsrlLbEHkAUn0O9kT+KJGz/Vajs2dBtUMD74VLQ?=
 =?us-ascii?Q?vDXGdPSh5m3xGSpQzbdvLSOmmY9l3M+8+pDqocZTYR2KTEn47Qz4/7340c7G?=
 =?us-ascii?Q?JvD3vxX/aW9uusnTmwPpWlCH6qJUeTYGjZO7hc4unRcYiQR+oYSUMPOaXcW0?=
 =?us-ascii?Q?HnIGHJaWreJcZ/6T4oqTRVJC56AIYntSLIn4ATNwh3WQqyl9+9foEfqZFhoK?=
 =?us-ascii?Q?kyIYVMTZmrINQalFX2dWw3qA5Jt5ZoM7cCvWSu5HZu5eBoHiKzD11+SoUkLU?=
 =?us-ascii?Q?SKqaLfh96xoeY5dkNrQO2JipVUHAWp6XWjmQt7A2/DSfk0mo4fqXbmOn87pC?=
 =?us-ascii?Q?5vlQooFatSkyNlfX+cVcd3GXlqeSj2uXYYRrIdGTUvC3TUMFj7SBhDoZCkl3?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HK/yH8MVhEsljPMVmPwA7L38aZ+l8rzOZenOaybCLMzXo0ESp6nBQLMLamBf+XO2Jzg8ObQnng5lS2ZtFGCT4ltanO4KEuMguGX2lvTNRGn25yM8Fva9nSEUceaJQHMJoUAx23oGLGxeGw2EcIPtRuHbaE2h7STuKv2joeqWnGMV549n2i2Ra6u2C6pSfJ0pUYxfk3/gTvaeYwBk+8qS8LtgjzY1/UsnTA0uvLrk9TE1gYu+94xXMjw4fm9QFYGY1oc2A93MBtPFBc0oWHXJ3BTq6PloVpwsohpBbmyhcOWu7nw6dsOf6pk8VkoxYZnGP1e4yrWFzl+YE+8rl2tS3q6Dhtae7d94Q5eUNFen+HzzmWLM8symfQXhasZkfVQbdG6v2HNtcT3YsXNf98fjPy0u+JwkfeFQXYWIVU6Toy2AStcJJ/HGxKDYmfgODjzH5QiQe00oA9K///ovK2AVmT0j0S142KVj0tdVYfNvD3OnGr2P42sY3kSD8ULunV74hX4yG1EdLLRUv6Ax6ld6FdCKB5/wh9ihk765/t99817tJUboFhIKkr1H6+W/+7Yti60OCwEkEZK7fjMoly7cfe/ebKQ2dfMmWbfAYGNpjw3T5OfTQlYTbuup9p9ZzhKTMsFXDihWqLQ6d68WK2AVd+j8ja2ian/pONAWGlkzGBnTGfB8q9cXDR0a93y6XqtEMjyiIjjQfHrexDUcUlP7PROdTBpLSKDi8/ChQMkMlBY+8+wAhgTUyEQPEd07MB1s0BQ8f2IAG3N+hmj15MLFKoFrT34upIAplsD3yh9vuKtU9E/jKgbVLrKyQQyG5k3hUP8i6ZCzBUGAagqpT5y0LCcCE3jLoeTEZXVJKmCKJmSyg4WRyP/9NwDW6fEBzhes
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 390c2905-4206-4697-c93f-08dbc51cedc3
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:24.3149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQlori2m5vBMNQ5jztiNjtPGqgA1s5FppsKemPc4JM20VEx/0cakAzYU2bQpNAo8gEUJX3kDnj6ihjFhqm7XjIHlPgLJKdN+E6zgnJTijPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-GUID: up91wf5HeCiWzx9OxZuSVRJYj7IdLZ8R
X-Proofpoint-ORIG-GUID: up91wf5HeCiWzx9OxZuSVRJYj7IdLZ8R
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If send_mode_select retries scsi_execute_cmd it will leave err set to
SCSI_DH_RETRY/SCSI_DH_IMM_RETRY. If on the retry, the command is
successful, then SCSI_DH_RETRY/SCSI_DH_IMM_RETRY will be returned to
the scsi_dh activation caller. On the retry, we will then detect the
previous MODE SELECT had worked, and so we will return success.

This patch has us return the correct return value, so we can avoid the
extra scsi_dh activation call and to avoid failures if the caller had
hit its activation retry limit and does not end up retrying.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c5538645057a..b65586d6649c 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -530,7 +530,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err, retry_cnt = RDAC_RETRY_COUNT;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -558,20 +558,20 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
-			     RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+	if (!scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+		h->state = RDAC_STATE_ACTIVE;
+		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
+				"MODE_SELECT completed",
+				(char *) h->ctlr->array_name, h->ctlr->index);
+		err = SCSI_DH_OK;
+	} else {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
 		if (err == SCSI_DH_IMM_RETRY)
 			goto retry;
 	}
-	if (err == SCSI_DH_OK) {
-		h->state = RDAC_STATE_ACTIVE;
-		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-				"MODE_SELECT completed",
-				(char *) h->ctlr->array_name, h->ctlr->index);
-	}
 
 	list_for_each_entry_safe(qdata, tmp, &list, entry) {
 		list_del(&qdata->entry);
-- 
2.34.1

