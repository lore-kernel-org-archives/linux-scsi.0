Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20BFC54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiI2C5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiI2C50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:57:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA09F125798
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:57:20 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1TT90018659;
        Thu, 29 Sep 2022 02:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=+e9bJFssgi6lrawWAgSMW4DaCjba/rx08W5jLa+YOMg=;
 b=Pcb9p8PcdWynPPY9Lk4n0gSmobMVuPlFSpmt9lYCdLYYU05gnDMvEf3FZq5E7X+IGcA4
 YgwIUQRFKylDnytfpm1pZsg3q/xxNCL677C2eyuTYFcsbpnM4xDPjWDE/B/wRHRMn/Na
 rcx+iWmoE09/BIdZpl5C2MwgKYQTjj+sRylSaqbRUTGbRIN+ELfLCRbnFdB5olStmE1e
 rDKXhpLohUjWGmEmw/QICPz8YFiBwAR+/4qajTs+4L53cu6GrY+xMyUa42Hob74Jmggw
 eT+AlPk+dD243aisl8tPMGfU/4vA1XxLw3aLkczAbKNxMTQQQXT4GQNR4hMkjDaMVBnC 7A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstet3uew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:55:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T2kQji002299;
        Thu, 29 Sep 2022 02:55:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps6v7q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:55:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANtVhZwmoAc3CVbVmbdw1STPb4vQOYrq8P0zPnhNPXaCbWb3y6MUUpgzUwzWfDZIoCvoZ5+W+y19LmeHCVNVAhtJWTpBunfAs7Ji9zCflO48WiG0VomJCpLLaJ5yM5Z2nOFeI05JsB2PrPo/58EXCsKFzem2uAVDcerXvdIwo0Qx4iLpLqGdUdu/QuxEX8Aq8AgxSG61t4igC8FaJLRTY+BP2OhySW/O4RKvVY4E3eiZA4MRCcHOTUeVkKDizAeVtJIu4Q8EfQ33oupHtZ+hymfYmQAMFSWMTHqc1UqYKPGi2vUlWbju6tXZsg0ifs6l4cAyZNM6rdWJ2uJpaL9wOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+e9bJFssgi6lrawWAgSMW4DaCjba/rx08W5jLa+YOMg=;
 b=UMSw0IymzFujbbq7QA+Yvp6/jJWaPz992/QIqQHI+dxQbM+lDGB7+w/3S0nfK1HPIC/s557v5Sw97DrnJ1QRjhbYDCK1x1FVQG6MWfnSo3uNnxgacai4XAutArtisuelWlGyUrVIkR3cp2DEd+nh9Y/KqeaKNi5AYOJdlzWJYWmbcFeitBst873F6rdkjRQbFmQCkDSzkgC3PEJ0lmAgs+/IgvUQ+OQ3qpLFQzUZKc/4NPhG2AatJr3fPdaLzp+H0nH84AbzPKjBk22y+XCLlI4gHiWBHqsEeBYUOcDuQTLxkaTmQk8UDfE4SE7h0H3L3+RXg3K2804KQUP34MR1rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+e9bJFssgi6lrawWAgSMW4DaCjba/rx08W5jLa+YOMg=;
 b=arU/pY5fHVZR9lh/5hSRonnQHWGeQFPi/9OGH+kH6SBuIBEiuy4dXKh7bn8r2izxRPjNobVci54hKo/5pBizhYznbAYmo9sm2fgtoioArXYqNWyjAGc2EXYucUi+YXlrduoDFLVelfAj0GicW2R33fHMArex1YfXWE1h9zk7ffY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4346.namprd10.prod.outlook.com (2603:10b6:5:223::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.26; Thu, 29 Sep 2022 02:55:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:55:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 34/35] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Wed, 28 Sep 2022 21:54:06 -0500
Message-Id: <20220929025407.119804-35-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0019.namprd18.prod.outlook.com
 (2603:10b6:610:4f::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DM6PR10MB4346:EE_
X-MS-Office365-Filtering-Correlation-Id: bbf8b5cf-ba7f-41f9-e75a-08daa1c6020b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KtM9DJXUUb9Vijdr3U67PRqD/y289veQ+5Br8LvHTsBK6Rbh83Pedh1qFoA68bdKdkqqSU5bk/nm0FlZQgBlKQz8cebljqBWd8+bPugN34iv+F/SW9xfsP2Tz7FDErwy0kgMoJbxtmTvdwi5RUkgQHm0IJcjNpVUv5Yp2bu6CScLqF0hligfWzxLjIXsmjry5tfCtuAi1xJOyOHTXYO7cxEA9FS/XSvl1QBuIUfuhg8s5lPbCUVh4ASeDOxJHWZuGKgjzBePeQxkAV6iGomsOPAzdPNnpaLbj8GepOrQwLaOWG9Z+JAQqPdGKRCIHA9OyTsD1YngSj+y523M7Dxrzu0YE5Jq+1o791cmFEIPcNvEgWcme6mLHca5+e+LPCMFXWB9X+q9yQ2Wxy7jmgeWz/ixmvo07pFvgoWgMDoIBFhPn6mAK3uCntWaSD+8vEfCwaXj1aSt9NB5dU8Rd7BjLhXaBdHFdT4DgDDNi8mOHQUAWvva8aiUXkOSGT2grOV3o+3vWjzttgDqHADLjw2heVVAcFkd3SETLDL2FpBvZgPskaCnu7us0TWutF3x3DtwKPrTZvV/DPLFnPxjSzEdffy6zUm3P+0VzULVegrelGbuJLqrmDctKPtj8IiutNUnvbt48hwaZAGI3gh3TkKUlrY9YcS9aFLHQaXZ8RtteLZTV1LnjCvbyVxFsNyqzj3qqs0VIkkr/1AbzH5XvGREww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199015)(6486002)(41300700001)(2616005)(186003)(83380400001)(36756003)(1076003)(38100700002)(86362001)(66946007)(107886003)(8676002)(478600001)(6512007)(6506007)(316002)(26005)(8936002)(66476007)(66556008)(5660300002)(4326008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wmwa1VylW6cOJRNQB0eNVh6Z1XT2bvpdsknG5m4y/ZEKc6MscffxeQ8glRrx?=
 =?us-ascii?Q?yfjqK9d8J78XCUSy4sK0mFVaZP7uGIvcpdnRBJxqyDDT9bKrL39JwfX+DhL+?=
 =?us-ascii?Q?CfRLWKshLMEiV1atKj0/5WgDrusyGjEUPsoO5sTSk/rqA5q/xbbzrGDCD92Y?=
 =?us-ascii?Q?2zX8irqyuRDBkd6Kq2p17pe0XlF9QBiSG27h4pm1b0WTSNVB9zivfvdFDE6Q?=
 =?us-ascii?Q?nUbZ7aMPbdecOG098qr2bw0kSmaG2EdqLnWyQxCd+bB1oC9ixAVK8kMWUbS+?=
 =?us-ascii?Q?ORD6gPQs1Be/9DM3ocbna/mFNc7cxK7K+Tm/4tX2rcGnaVWJ007mrq6NmoXn?=
 =?us-ascii?Q?aC6xj2W9oMZeUDkF1qELOx7Wuc9RB27TMSBcWn/yoWZ+Pr0/g0qW+CranTrF?=
 =?us-ascii?Q?pSX3XlDaPFRmzxXeD7bDZ+f/Ba/HqiM9GQZq/Am6xXLLP/J7sCNIr7/Ie55H?=
 =?us-ascii?Q?HhHENQXKfTYPQpPkfg5EuFpvoLmsK+JILOnBn7lZYMMy5ugLkC/lEaTLD/SS?=
 =?us-ascii?Q?cA0WZBfdxgIozGn1LUAQMtZLLIPdaUFaP5GHTgTMr0zkdmbN9hN+eBgBd4GM?=
 =?us-ascii?Q?k/sh6oJCARtwcuvXJxIyLTFYPckJwzwDIBeUfzke5n6ugi+i7gQqmYuLwrl1?=
 =?us-ascii?Q?F9TK8Cw/lKdB0B+K6jh4ACeXUJuq8yRkToT6MrKd0s1oBn3zyhjqZqYNlfd5?=
 =?us-ascii?Q?FjmDdEjVusBMBMeTuEEsjqb3B17rDUnShB9F86QuZSp9viweKtOLWzKv90j5?=
 =?us-ascii?Q?s2WYs8OSxHMUvPhJ//fG2Eq1Q1jMR5vjqyRKf/aX8FSvizvsTrfR8Tu87ZCZ?=
 =?us-ascii?Q?RRcXszwpGT68il1veXOmByh4IWqWo2T7rL+eO3IcMjWMZ6guVVhh2o+SxxYA?=
 =?us-ascii?Q?OaapF89hBKnLS/gL8mhG5cu4SdtxBLN68Q/sTh9NJM7HClDLOGMuTx7MZ2p2?=
 =?us-ascii?Q?qOMR/5zYDHQJYIuL4tKhHt3q/Agfq1rZtsZxOBjkQ5ibGqVlDfDIDma4yzee?=
 =?us-ascii?Q?020icCkPQauyJdJBihhKwn9pC0zvzjsXqpkic+Pc6fbubYaF4NTfLiWI6t6D?=
 =?us-ascii?Q?NB5p6N4h8bbcr1hLyl8LZsj3pxcf4FVGFZc+wXaJvm9SI2yYLD7/Y+7sI+1C?=
 =?us-ascii?Q?jFQRd6yat/9YfuBlwHFxHCmBMNDvGIuTBaOSyMpNoy1eZboDsErWX9+Yj1R8?=
 =?us-ascii?Q?l3YouoZazxHbnVgk141APELatVEKrQk9ljdXnw+aXlVn6oQngw+jCaRY8PyY?=
 =?us-ascii?Q?6TGHOqrjJZtKF+qHUixFU2vLJoYt3aeHRRhj4W+pzQw0PYiWB6ujsLk0WA46?=
 =?us-ascii?Q?HbUVklZdzkDT/3bspNieiR+f3xMYzyw6QHolX9iUmaaAFSa/dplFEctvKd3z?=
 =?us-ascii?Q?gKZnMZRbWDf6EM1RAzPcGqvsbIMYyxpwqitM+DStZ6m/zHv2L25zEdhkJ3Yz?=
 =?us-ascii?Q?UlM2eYkoqbqn3TL4x3P2SCO2/9ROkcjh4sX7ccSWsedbWGSa6bK0USgedasu?=
 =?us-ascii?Q?qv4KC1KozaMrPAWIPwMeaBQNhmtUY0332f9v6gZYLvtgZdCs0+UmJcpyVWUQ?=
 =?us-ascii?Q?g7udfLNQZaMmLARYDTAxQaV/P0SU6YESv0gUliYUAZj00Nw9HlcdlCDiCzZ1?=
 =?us-ascii?Q?1w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf8b5cf-ba7f-41f9-e75a-08daa1c6020b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:55:03.7215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oG1SXrZJjyMfLRM4L2tKeKhe0tPXyXmzRRREwA5CniMglKVKog8ULjOfvDcu45P+GDLHsZeNawXgN8J/sk8RobRaQAAhARBNEyz6p1Hx6Wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-GUID: 9vWZKhg68kWI47neroAbHu3k3bxUfJXn
X-Proofpoint-ORIG-GUID: 9vWZKhg68kWI47neroAbHu3k3bxUfJXn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has get_sectorsize have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sr.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e3171f040fe1..8e21ad83e938 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -727,30 +727,31 @@ static void get_sectorsize(struct scsi_cd *cd)
 {
 	unsigned char cmd[10];
 	unsigned char buffer[8];
-	int the_result, retries = 3;
+	int the_result;
 	int sector_size;
 	struct request_queue *queue;
+	struct scsi_failure failures[] = {
+		{
+			.result = SCMD_FAILURE_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset((void *) &cmd[1], 0, 9);
-		memset(buffer, 0, sizeof(buffer));
-
-		/* Do the command and wait.. */
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = cd->device,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = sizeof(buffer),
-						.timeout = SR_TIMEOUT,
-						.retries = MAX_RETRIES }));
-
-		retries--;
-
-	} while (the_result && retries);
-
+	cmd[0] = READ_CAPACITY;
+	memset((void *) &cmd[1], 0, 9);
+	memset(buffer, 0, sizeof(buffer));
 
+	/* Do the command and wait.. */
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = cd->device,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = sizeof(buffer),
+					.timeout = SR_TIMEOUT,
+					.retries = MAX_RETRIES,
+					.failures = failures }));
 	if (the_result) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
-- 
2.25.1

