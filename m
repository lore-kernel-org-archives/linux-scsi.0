Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0253C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiJWDHI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiJWDGx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6116B15E
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:44 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MCqKm9019479;
        Sun, 23 Oct 2022 03:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=a8P7VsBo6ia2NGN2xi+jJ4Yb+k/2sWqCIymwCu5ZnsY=;
 b=WXF8jKUz1SQi3Z0/SBQ37YSiYkjsbZEfZH/nLsHkFysUeaLv5yZRAXx6cHEnMEH7/231
 b8uVM4uFvtuv+boibUNAkGm8vKexkCCqm/5gkr4qlR9HJxx9jzw5DdjxgcDdzBHoO/Q+
 HidK1P+8gmZVB/Bs0tayp5g1ZKtztCHjgWZZHITuhgxTakxNXchZjQFeQpunnnSdu3a0
 KUXvEvM9Wfbf/tgG8ktS/X9VwAmxtsAUPANFoO3AuisiLR2Vy99Xpkf9vZ3Zo06cWiSR
 C7fyV85RS0UJtAS0wsZaZxQGQfIbdXhX9h+nLUYjicunidmtbkPMRo9k8DUmRE5r3QQ0 Fg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc93918j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKK0EV002602;
        Sun, 23 Oct 2022 03:04:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8rhk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCX981OXvmY+s5zFFSQ/f5gjRRbM5w5mDmW3nvBwy4of8tgeljxs239bb6TthZxsKTMLsmhZ7oOx1NCjmvPE/EDtEbXSe0a4tkxrjxaBKRg9+5ubWzl78CIbBz/Fpo0i/Pk2soxoDZvlQsw49F7QBa749bGsn25ejhdlsLZRQokWm0pW3OKuAEMlehc2agzMZt+scQDI+xMcXhtblmxxVQN0y8mOnVeMH5qdBNGhxdVkBmHgiXXW4uHKe3g6WNvZKvF6KaiUp/v3JcZThLdR1HNZPWdeTTAOcBkmUy5sGBmfOwNfCCBQSHaO0pliCEOZFrTkWiX7C905AjM+UTkElg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8P7VsBo6ia2NGN2xi+jJ4Yb+k/2sWqCIymwCu5ZnsY=;
 b=TTbrCQQuX8M5GMmDPxL3x3QJpqRM8M7+kruV/6FBebblOhDGidQ2Ho/dMGnFr/5VmUIiEyeQoRHhFcc7RICulp3mMRQ1Szb/b+bf+a7mKKt2l7BHPwHEUZR3XmV5nJCbAZhdQaXL+yBHe4PbJ1Rxh+oxDRjlzsypyIEcs8e14CE2UCssEpZBo/pOUXdbl+TyknrsSWQh734cduXwV7FKj6sxcvQPoXC0MOVMEw0lxlBfxwB3uf6FgHms7Gx4EThLD54mZzyAvYqqR4f90zBcpuCB9aluV1lGogeATnzkPa2Lttbjgo1IctR/znEtpuYRURA4ushvix9JSoz+ap+08A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8P7VsBo6ia2NGN2xi+jJ4Yb+k/2sWqCIymwCu5ZnsY=;
 b=cP0eL+I1fKfeEjl/8+9s9ugGCOazhfEY/RKyAUxXnC34JDI4uf/8p6kmDIMkZzfmGu9OrE2y93nNOKNHC3mmjXcmmNH2WGDT9w+EiX2lGJ3t7wa/LexJ84No3+c8QiDUCwZ7Tgyx0PIjiMj30ruiyyq4o5jta7PGQEBp5nROdMo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 13/35] scsi: ses: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:41 -0500
Message-Id: <20221023030403.33845-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0030.namprd16.prod.outlook.com
 (2603:10b6:610:50::40) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 52e77ba7-3349-49d0-c1bc-08dab4a34b9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wI49RarGB+0YaPkAXLxR0tsuKXsfS4KY8DWkZqyzRsmyv91XDwpVULaf1pi83HTo6Wz1z1m3crNH6S08bvv2KZd5RN9sT36qlHyCTdW1nWz3yigx8H7a6jfhaD5SNeieFonA9tcPSumrdwBkoAqcfv0JAf2YkO6KZCUZHUFJSdQgdx6Us4PEeZRkAIIqp5qiN2w71cWMg8a/HLW2Eeki3n4NeEAG5nTYz32LjzmH5QLRJ5WwQhrdEs3TCwxk4vcZdqqJUO7bZ/2m6TBYUR76vuHcQdWNDDFV43PDNPwcin5I0ULpoC27YrD67d8CAxlZF34pSI1h07sD+TbU63NIIJ/aAAY5gpdZ47AZ33SvejBZB3h0DFfa2iq3ju8if2jhuZ8IaQxF0ZnSRSTTcNjClRJPlfN7vOxeWmwiz6uD36tIfsTx7jC6V6GrWCvv//vbxO1hG1CHsoOmKa9REfSnuBmGEDgZ0E+OqWRB5+valXVgkrA7DmUS1YGsR3R0VT5vx4bYpWt4lVnXu1dY9c0prDhfQ0EIGai0BFvcgt500gQc349xDdI4x94qRqEXD50fnBXutPIoxYVmc7BKqeSOWDJaJpQUI3V34PAZdx+tOIAu0isww4CMiLerqVXTasafY201Ai4cobesKsZbluR+UNNu01RFel1QlL7dLBBNfiDe8oTrHtOEZ7RGs3zGUWTq70oGoKRYjNJne2262t7BOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VTQNYYiOyoixiw8JcXaP6ANwgegrkpVoQcaKdaTJfLZQDTURiu+AtrjH/4Jd?=
 =?us-ascii?Q?Ky8GB+SQxZD+joObS+AdEgYefpdzcM2N/BUkbmrryVXM1FkzcX/IcKUaFwKO?=
 =?us-ascii?Q?95a0NyUPBJtZmX0hLpLTEAT2hjjvbm/nU5eGnUB2cqvACGZmSEYnE7zW5coM?=
 =?us-ascii?Q?WRxoPNkRtrvIN0+PDuMXOfRFZRLTgdQv4bV2CRPN9eyib4Mzpd4rMuuLGrAb?=
 =?us-ascii?Q?tpCMlKKa/HUBT3CRWctVHfpMTSE6QBm5h9vrEJ2zagahXuNW6ujB5wQuLP8j?=
 =?us-ascii?Q?/+qWOtXDAt8WyQysXSaXz58eVukTP1qbfCkE4dYuB3UVKhBcMZbQxEBh639a?=
 =?us-ascii?Q?0QFOWxUReaz2T9Q3muVqMBLKM0tuoeELFAX1bMISE2efmK20pHZmaIx9uXqD?=
 =?us-ascii?Q?qKOL2dqo5AmjvKyIPuDaKSDywuKGqLX7t7vh5cBB6Nm6NCfCagMrlIJHjCay?=
 =?us-ascii?Q?dEoPfqiol4rzjvng1tGSwmZ21MLLjQSQOfXHr5UUu3Tb+2HYxj3Grtuaxz4u?=
 =?us-ascii?Q?tNkjDVTtTrl5jFrbC3F5q50A7cuIDZRG/WGyHaUPblAPCImku3Al/wXnakN1?=
 =?us-ascii?Q?tE6KjWdLphj4y7e7A05LyPs3aURB6WUE6tjXEL7K0eZURJGr3Nlw9q0WINLF?=
 =?us-ascii?Q?YEofg5+qFlLFn8OBhwKUztCKsxN5fsDNDe15eP7GT76Cro8MvKR4Dj+Ohlsr?=
 =?us-ascii?Q?R+dORumm/rImVlrBHzKeuYz5cCGIRJln4EtNyVwbl8woITxZSExkwxFTeEni?=
 =?us-ascii?Q?ZZA3qiAB0mGPAfCqXsvWG4w3Os/eqNSYoH0zeu2ocOGv5ojzFW5/3Rf2TGVf?=
 =?us-ascii?Q?mF7lc9Dzf8UtD/MFhkHbYgEZ3jZqiRIFEOgr3jTFlE5JU45zDPM3nfpLkOX/?=
 =?us-ascii?Q?+LCFYzmbWHUaMu4Wo32KlUhNtne3UDtQ0b8mtzDOl7kPuGXXiI9J2ljqDQ2e?=
 =?us-ascii?Q?4DLwteovkdzwx3SEw/lsjonqOJA/oqeyXCM2P2laxgU+JiVn2vUYVo/l3FSl?=
 =?us-ascii?Q?SJA4opurTR+Mx2KCKJ2WUw6D1GC+SF4CSCiy3pWQc4vZF3iWcmX6hpZlY1m2?=
 =?us-ascii?Q?cZkQ0QuKqM/OllwBfKv20liHaIcBnUU06jdYDoBfvN24YpoWQ+PQsi9GePL/?=
 =?us-ascii?Q?c569zgaSVS6sHgQMyk9Ww9JvkaDdzhZ2ZiewBnbKhVsE24Vb8MfZ7EVNSwPX?=
 =?us-ascii?Q?XJxoZc2KmvIZrwJ8qOtgSDYDE9piFrrWfP9JcMxmhI5WrH0MhyTn+guFsZ2f?=
 =?us-ascii?Q?4HxxCMa4HgS33rAsEcGo4k7vquc2SOtd6xmjAqdPIMDIZyHUFiOM5BS99+Yi?=
 =?us-ascii?Q?twmaSu/HSrNlS1hFfPJXfpyi9xl/yvzXaIpN3lsK15cw0TodWlsogg/g7tzG?=
 =?us-ascii?Q?fRhE6RUQJzSp3BvG7xUblIi5AbQZBu7ZWuDl+vigDLeAeLtEwHU3H76M7w0v?=
 =?us-ascii?Q?vENmgzUEFbpZSSJfmOsOvLHZpD+7tEBTlg84LuO8Ng92Aq+nSeUemg8ZyWoD?=
 =?us-ascii?Q?avfWrh54zRVVfVcsZcY4g6b1oVGIcimxGTMusn3h5NbVED+S0gUFY21SkEaG?=
 =?us-ascii?Q?6l+/K+5SxPWS2t4Krhe6XbFcmfD0mDKXvTrnx/wTBFWLjUWnZc9ok7RWne5F?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e77ba7-3349-49d0-c1bc-08dab4a34b9d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:26.8426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XgFo5plk7lvRNIWIusnNSaG9nAwr2UDqBLcu6K2C0NSyW3sA/X89e5M+POolIYfqaMPdV8GJWP8mBSK9/tF8l1g6fxTkXldAwawM5UJ0EbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: 0iTEGQlT0Rv1hPDbz_YoaevOldQY9Nil
X-Proofpoint-ORIG-GUID: 0iTEGQlT0Rv1hPDbz_YoaevOldQY9Nil
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ses.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..c90722aa552c 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -91,8 +91,15 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	struct scsi_sense_hdr sshdr;
 
 	do {
-		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				       &sshdr, SES_TIMEOUT, 1, NULL);
+		ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = bufflen,
+					.sshdr = &sshdr,
+					.timeout = SES_TIMEOUT,
+					.retries = 1 }));
 	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
@@ -132,8 +139,15 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	unsigned int retries = SES_RETRIES;
 
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-					  &sshdr, SES_TIMEOUT, 1, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = DMA_TO_DEVICE,
+						.buf = buf,
+						.buf_len = bufflen,
+						.sshdr = &sshdr,
+						.timeout = SES_TIMEOUT,
+						.retries = 1 }));
 	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-- 
2.25.1

