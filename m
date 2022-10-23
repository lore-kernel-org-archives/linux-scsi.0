Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9907EC3A59D
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiJWDJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiJWDIj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:08:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B9274364
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:35 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKuvtj031538;
        Sun, 23 Oct 2022 03:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=o0iv5aU9sogEU4zAFMlzIPkB2hoejsOJcTx6+TJ7MP4=;
 b=PC64lEbDHvKa4P2dHhrWQkB6zfgQuCoT3dOxCnckWFBkFK352O56eN7mKMSGtkrAJCb1
 m8FvpSVzhJoux+Y/RjU+PqTAmkTYlaZmAlaI8mltzaC1qb+ZRb44+VmqGUE4P05fXcZc
 Gyz02ZZMwPApeFFgBD85jYw2FCjMmJMEnXCZ1U1WgZ2S4EfUyKeN5ehDiYJx8d/rTxiq
 Q3DgRI2WbDGzhflh8BX1J6Cfj+Bf3vYSr7jHvyd4U6JBipG/cYZkP8vu7NSjwTVcujRh
 9gLSSdpeD+WbAcVDSSXpew5DJzcATWCQn2Wj2Gwrdu1diwt1NDI0jJ6MXkmdkH10xzy9 0A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8db95ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:28 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MJW0fa032103;
        Sun, 23 Oct 2022 03:05:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30aud-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:05:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLtB3u0rxu2oZcQaCBCKkc2PVk7PxFpPZFEzUaYCAFz4Yser2/tCrNct6F0dM/eykND3c0wPOCGKDvg8risDdqv91nHHSiLQzI7DCoiohIHOYzMRG6fz+7B5FOzksZACkiBwJC1hA46KbvybLH2+NxHB+AsyEBNU3/nyIKgpCWFTfdNkEh1ZDiUvgdIbHHOrMfBs0IFn3sK20siiRuQSx0g4GGR8jtjqnHJLJtWoq48Y4GUeZr19wzquzQtMniIrjFRHHEZBSPIcqxXKYSMtB/NpcbWGoz3+GeduwPqoPYZm0oo488nC5wTh4X9eCV1P/PkPTegua4YfknX3YRFHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0iv5aU9sogEU4zAFMlzIPkB2hoejsOJcTx6+TJ7MP4=;
 b=BpT+9VqSEoeC/FEbn4+1NmBXGs7tDCcZ/HIZ++x+VEOsgh6J9OaZdzWWVDGrNsLGSKs1Jrae8nWhAqD8CTNoUtV2NTt13Wia8zcfP4qJJAUJM4GYhgbdyd/0PyPHtmdJYBjbWOTOUvQ7TcIRo7xIOuQu0wo6KYvK/IZ1Wk5u3zAnYTABkClygn0lXTnjv83KTZGzzF+63F4AlrLTbbJZz3Q/llDS81bIWlwf/z+vVH2JbGFh9TRyrGWFa9xho8g4Ed2uPG+K/9DkJC929ppVegEHaUicYnALN+N1s1c96VP73PUmCRyje6rU2LLcJXsdIhIpPHXxP+lxuOUIKABqKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0iv5aU9sogEU4zAFMlzIPkB2hoejsOJcTx6+TJ7MP4=;
 b=kB42Bz38Gy5T/SIqx1c4BfSszQ1oHc/GeYhEonxBQp8Fa14GUcfmqvJtvx4ZdLAQGi9GZ/enUeJg0Sf9Sukl5UfS3IQjfERVDA6wvhrJ4L2epT4EmlxBTkjzown0SetV3qJf55NS+KvlzBi8FsA6ZEqzuvYbjGFvbqIKxz6XXys=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:05:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:05:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 31/35] scsi: sd: Have sd_pr_command retry UAs
Date:   Sat, 22 Oct 2022 22:03:59 -0500
Message-Id: <20221023030403.33845-32-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:610:cc::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e80f561-b754-4e09-ad4b-08dab4a35ce1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owObU2zDyiLqVbOYoRJUw6bV5VvxjHH244j/YF2KonC4dcd5V+RpOzj8tRNRsNjpOFO94NCq4hZIzQIu8Vs0+wnWMD1nL/WBB+8r7FoxIgBckLMubqYjaQXjix90iHXkLmgpHQz7fYdDf2Xt1qQ3m+MIH+dkdRH2n/oeu4atXleCmlctSRJEoP/aAqA0sFJeOVKdMkOuqCuSkvj8eKMmBtneLOtnZ+t3ATUs7X+o2jWf2Q/fkFXqlDrgshR+vnCqErTTyiNhkfncD5egb9C4ulp0XNRTuN9Pv1HvCqoBQlXGXIQXLgbZeGHWOU0aXo/c84W5tmkkzVBL1GjVdjqied5JMbtVBTC+H+EeEP+hIMDT1efGxKqAfVL2yYBpOAgBK2RiRJQvBGLlo+6MF+ZwooKgYUdV2BVDtE1AVFbAv/1ox82gxk1vSiA2YB5r0Yq+4rh4XJgcgk6I2tmVbIzt9AwwdmhbuAv6ZnbSL6pv1PYxYFi7V51DgmxUL8W9fnrDy8Ov4ouU5S5BCJwtWclqhiX++OsZ+3SQIaADEe9IxLPOiDHGJo2z5hQuoFaqDN/jzsaCPzqtavRjIvr8lzSgpGn7tQTcS9cHylhppROGNfJSjJX4SfStPa5aoevZWnKqTgDFnl9+WFU3kbZltMvWBe4RrlXc0pxCUMbN+CAOjFxuQ20NGuBvZRw5ah20VIq5LOh2M4HbnoitOANqripDbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WRk8WAHPDEmgjwYt0iKtLWVmUtJAa6wYkcf1nT4BVHDVslG1hqBApzIYJiDE?=
 =?us-ascii?Q?zYDLkLz0kJ6+6qqC1fFTKFRoaTvIBUEWZueJi9u/MAuVnU2H/lpDMh5/irKQ?=
 =?us-ascii?Q?aizIAwd/uci4YO6dczl3Ymje6R32akbCtYBxIuPhajBw2j5TfyA9qS78EEcJ?=
 =?us-ascii?Q?eehMzT/Mrql5CH8kqf89FIG6OWpYBLpj/LGcgt8mXUSdrQWRStTCk6ZxY9Om?=
 =?us-ascii?Q?sTNZhhgP0jZh975UUy77Z38ltxzsuWgIpCMU95eHcItFTWtVxmwwjGKIbsla?=
 =?us-ascii?Q?b0gBOiPW419DLTVTPRof1/hGjRFFGZpJ/ZGuE/H+1ZkauTu4X8ht64w8+b15?=
 =?us-ascii?Q?pPgjwddfyp0pNZ6+QvwsWaDQQKTUpVl2rWindInpRL7Vl4/6htciEaEbqxu2?=
 =?us-ascii?Q?kNKL+f+gNcMRJSi+9UGhqjho0IyUaYbhj6mv8nfzGrolQOGJHwiwrxTJz3Id?=
 =?us-ascii?Q?ye+d9zh6fpyOJvxew16gz6wJuZb7GRK1J4tZcOJ4kGSJX/6Ged6uxt2JUxcI?=
 =?us-ascii?Q?tQq3GqOCzBOdvwi/Lgp/YdvEuoDn8xdORQO1F/kpdYp5PdcsqwDEVY+ho4pD?=
 =?us-ascii?Q?j1aDove8TDPNxYanDqdZ24zEk5XOSWAiQ4g81WksqMQPoW27oVTp1HJrlZXL?=
 =?us-ascii?Q?HZLSC5F/YssThMihFlg3iJpPLynfP5BHg2sF8L+0QQvyGubLUt2ogFOG/LYQ?=
 =?us-ascii?Q?j5PZ38plJaGyaXEmS5h2A5YXgYiBnEP4VOtaJBnkFxVfx8qXXGkZp0K4I7nL?=
 =?us-ascii?Q?FySizIuYHKrZP6rArJebnWlX/sU/0RpyCGjnyAoXJm4rlkZjs2XLUF7RLooY?=
 =?us-ascii?Q?4b2gZaBAeGDss10P1Fg9gCxlfSBiCizwd1oD/cKGO829MQR045TEqLIJd91S?=
 =?us-ascii?Q?IOglk0eWc6yWvLJ9iMgG6EKvfZEkn2wMOBvSXZbcX6pLpk036aCINkaDcOXu?=
 =?us-ascii?Q?cUpRjoiY3jGjoPcY2iPvq+vEx5j3fGjavVASVzWIbBEh/mcv4o6XZC2EtF9q?=
 =?us-ascii?Q?xpRRCFMK1W1j8Mkz7rFo4/EfEgk2puob/mKnjJZVPMb4ecp9BigryQEo/wxN?=
 =?us-ascii?Q?RFjmR8gXDyccybsNOwgZlcmYMmg/4dmDW9h7xgAEWPTYDY+MGEoNB1UEwh35?=
 =?us-ascii?Q?sTVqmNXFqKy7E7m2Yszcdoyr59HAQRGpPEJgSSjMyEC1xXXLkHESCSSWAYLA?=
 =?us-ascii?Q?Npyajk24kYtS3v/SHsUgUk06BnSlfcUOrLpeEqmpPoPWdIn73INdvnpDDbHf?=
 =?us-ascii?Q?1G3PnTVomo+nzWp8AhXoZu9dstwaeHwK6ZQbCvouLvjrN3wduT82qbGFOILE?=
 =?us-ascii?Q?f+5Nm25bDvLl46ZEGJ7q/3g3gaF8ptph/iDTvlxSCy7dsi+MOMqc2sQNvhre?=
 =?us-ascii?Q?PQjnYyUCkhDqZapuN2BwP9qxOqUy16ulXO8nLFegQxNUIFhBYzuBHteWGdnv?=
 =?us-ascii?Q?2mhoSrHcY2845qqxT+PvjswN2WGkg3xsgsFhDEjU89R7bt/fHXZAIgp+SIPI?=
 =?us-ascii?Q?juVSUtzZ30Fz69UCOrQrCTBIF8zxJ8A4E2EkzNIe+ux/p+QPW4ge1g9ZpCd6?=
 =?us-ascii?Q?swuZRjx6vPka7r/BhUPloEqm18kL0b9/sKwCmEGqHqnb5AFay/khxK49pTkU?=
 =?us-ascii?Q?zw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e80f561-b754-4e09-ad4b-08dab4a35ce1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:55.8871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzDjdsPw0GSjPFZmS5tEj8iYH+KnD7iM88aTToec8eqWXwt7Kiogt27mPKz+K5BHHdRlOeIW38aXiV/8Ep+jfMgYH5I9h5Qp7ru/wD5pxoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: RibLGN5arFxmr3uZAT06b2pd3_gW1Gh4
X-Proofpoint-GUID: RibLGN5arFxmr3uZAT06b2pd3_gW1Gh4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 424acbb812df..3c05ea3cf109 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1723,6 +1723,16 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	int result;
 	u8 cmd[16] = { 0, };
 	u8 data[24] = { 0, };
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	cmd[0] = PERSISTENT_RESERVE_OUT;
 	cmd[1] = sa;
@@ -1741,7 +1751,8 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 					.buf_len = sizeof(data),
 					.sshdr = &sshdr,
 					.timeout = SD_TIMEOUT,
-					.retries = sdkp->max_retries }));
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
-- 
2.25.1

