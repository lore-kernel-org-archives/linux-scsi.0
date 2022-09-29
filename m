Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A65BC04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbiI2C5F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbiI2C5A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:57:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB9111F122
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:56:54 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1TQV1004288;
        Thu, 29 Sep 2022 02:54:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=P47QewVp9LKx7wE4piOR6tYKPWFGqi25KE0IY3Eg02o=;
 b=SrGYeziBIovHtGTid9tDq41yzbmLko9PmoMFPylAQBTm/GEj1/8M4VKe8FEFi8fpqlJ2
 4NAhuuRYBqfSVmMhsd7MQcw5N8DIdEJ5Xqxibib9L5U8EkOtGkel0CscpK9uFyYqYPZM
 qs0LKO9TzblVdeCWqrek+DqpRnro4z4ty9XdyVornCgBGfz/BtJPMvhyfLi08I20vkUM
 /eYquSxK6xHZwdItGd5CCXsWk75WNiwd3FeixkiKli2v4Bk8YcQumedm/8Xwngns8FCo
 UqRwAWGFZUwYFBWSpaBEzjS7/uKAxsAsfhoTXGy0XtQAfapf6AGrukMNsDg5djfwph2Y WQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssubkhj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T2PEWu037062;
        Thu, 29 Sep 2022 02:54:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpvfv4tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yt/zU70zHCeARcyUENJOe5Nl2ZEwB/jn4PW793/cz1sYWpP0RtgWw+wRcv4gSbesH7AMbp/MmuHV4qVoxlJlw4ccQXAxCGnAzw59pGys36LNTGA+tjDz9rxXL3jNrgjMYsiqjCwVCHacVA2if7KivXy07qMsaUV7Hd7tCy3+fBywzzkjD90udgPBOdhoRO0fvGubwTgu/IZIUENVW8CM/mxLxKMJ+m7WJoAXX8bQdfy0WqD9lrTzmHCYuDfXEqc2OJnKC9LRu2AE560eqlff1abw3y6cHeDoIrbgugremvP02YH1xws+w9lahdgG73cAQ+ov6792TCJM25PUrZvFAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P47QewVp9LKx7wE4piOR6tYKPWFGqi25KE0IY3Eg02o=;
 b=C4NT7scEKQzAd3H/bIWdvrXhWAyvG0cB3ULu6ogWnQwGYATs6FhfMBDHsku3/QBpnaGL87LsOB85X0P2KfVkmtKF1cq3T+85gxVvbDZ2ZHc9uoJxEXJSTHO7vA9FUY+w8wRt96Yfb5s+ohrC6K9Vxaily8VonuUWJ80D5OlqRwguJItYNu3G+yl4EnfGm/0NHi9vEV48yge6cbQwyzOVw30SK4oDWnGdGziOSEbrrylXa+OsGb+WVoXGatjLVcFjd5E/Qep/LQ3A/0FFCvVlRePE/tuUDxvwymlaidPWOtkKnD1/RbRaI8mxD2k1zPzSaRFZ/QXMEvPS5leG6ZksgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P47QewVp9LKx7wE4piOR6tYKPWFGqi25KE0IY3Eg02o=;
 b=IEvjAyRP7MkQD5bmDNsoGQFrq++woB+E9nRTwlEB5tjljRXNPGlInUhObU35tsCT18Z8i5X4LPXv6WxceL1kvM+LV2JudpCb2OWHhqVo/0bPnxEWhHfKDiYiXNZH5jrzDycVSvhn4Z313ynSqKI5W6MRkFWCt+MIgCSV22x5wP8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 18/35] scsi: cxlflash: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:50 -0500
Message-Id: <20220929025407.119804-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:610:54::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 518a311f-1e80-42a0-b9d3-08daa1c5f3f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BHwB+lxdx61u8PPcJOP9hu56t4j4aKoO69mk3RU3hukE1o2oKJPme8G8uY/Vxyr50YkSsDBQlmRJIVYriP5X/gy7QfFaLFra60eQ2zcVINkvQha8w449/tARHZpgBNTnxmYZXQpcnHuRKo5//UVJ70qsdleeeRLCTyQhrmareJZRQDG02wN4Kk9PP6K5PxqGmLF/rK2MogWgswNk9Y9smxDKpsnxFhD9uORnYqgTJeLSgmjveG2Uhs68pfqZD5QMD7Nz8d3aYL+vXC1NK2zqUPOiCKKR3GdZMa5cnFdsllT6WMjFQhUhcNVWZbL7pjBHBdS/jYjZP2zUtsH4c92BOMvXGwfhTjvxRBvXjIFoNuoBULi6hknd/o4qAKiOfQct0CkcY1Bk1ayv5yDDQq5+MV0f01RGZymXhXp4hWiW6r20/by0jQfbpHXZu9QVqdVB9vuktLXv2QGfMnNSjC5ZPYam0vqriQ5rvf2L0Lf6DCMTzIQLZXqdcHGla9hoc9aHVhdo6Tz9fvp8nD3aDmW9foR0I186K+0+yLniTdRVZGwElSViv0tiGMLXgMKoOsv55gy5su1RgmQUQSw81oXudnR2jDO5K4tclXFtJz+UGV4Rv21UV+mulwATYGbfXJAyqP/qkPMBV5GCrmu5qmU+p64dzCDP1jggtYa/SnTJpd66EzOLN+A8QdWcHOTsecUXaUVmuJ6VZGPRdETvYSfRyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uDuwIQQkY13SujYVnnrai8jndBPomP0lP6Eqa1O2fFRO8RL4Ey/EITpbRrwZ?=
 =?us-ascii?Q?cCasRg9CbcPN2FptHvEutrxC1QwIb5g+IiRCilQ8hCD0poJvGTPIcpBkleUN?=
 =?us-ascii?Q?U2F5R1DHp1y7tZv+ZDIUWY3o7nWliOvjbHg8NENmQqD4iMCzPEffArarkp50?=
 =?us-ascii?Q?g6IKY1Ud/wb5sqL6xJ+Y3UOAf3NTSJt8CJXkaNJz6aa0HOs5omLz11+UT96O?=
 =?us-ascii?Q?+I4+aBstRE1KEx6Q+h4MleXDrmQDFiAAyZxeut1AsK47LuIy+xpjYJk9wmXo?=
 =?us-ascii?Q?pdtef2KmMzdUbe3cuZnBdq7lg3eXOXBTlwDz2SWuwKfk7i+23VFU5DxEmXF6?=
 =?us-ascii?Q?IbFHzrjkzAKstbc+3wPB3e/YKtbBRWN0FFvkn49A/PV9/PLXoui7z5ucrB6k?=
 =?us-ascii?Q?trUQUDq+nIKN+IvVhf2gWIuBA9GjIIr9rqpyv4daQ9WPZk3tvjtY1OW1Fg8h?=
 =?us-ascii?Q?I1YHyE8pBv6t+eHRdLtgw0+mndXblXLZtjxg0GRAzKZNMIPohZCHwBVqwRC1?=
 =?us-ascii?Q?Og/Ol/l9UyDj2I9nhhVDt/xsyV9ScQ8FXQW2vBZC1xMH/Cew1Z2+3up0BeIA?=
 =?us-ascii?Q?9KDo0ueQofcyVX5cfY9zhI0Upd9EH4pDnWaClF1UZ4fM+qae2N9EdjkYS8hs?=
 =?us-ascii?Q?BdV52olaUppYlWzqhYBvf7J81CwyasP8y47j8HAR4543/p4+BCw6SPSit/MJ?=
 =?us-ascii?Q?MWunjFalracFlW5ccLnlU++F87TwKYexRRack+zDfqrKwIg++2r/EBH/LypX?=
 =?us-ascii?Q?9xj/fLj3dqaH07jQ6n7qumno65CBmSgeNSsDknpMBv/ASy2TZ4FObXCwbcrx?=
 =?us-ascii?Q?sP1uZ2adNGV/rfZrRLpgoLGPJ2BqxcCBgE2oWhDyhlGzcEomObX4UXvSSE50?=
 =?us-ascii?Q?tZ+jYYiqkXU9rOBJWOOZysxFW/0tM0KlaKDKOuh8M44j4TfdOCJkm+Ia8tqz?=
 =?us-ascii?Q?atkoFpLWDb22PksYO+gdwBGcJG/2P3j3ysxi7Sxhl+/qAE59f7aD89DO/zvt?=
 =?us-ascii?Q?TzAxkARvE3HHLCGPBhjfgW3DJYNe20oZJGUHJfs7dqXWORnER1mKLcNa/Tbo?=
 =?us-ascii?Q?NGrQHtbylrz3lObMkEO+Fq5YiRTK1g7wtplPR0aizJQFBhzOlSX89pcxSpcn?=
 =?us-ascii?Q?ZO5Wspkg7H+QOAHclfl/d40AGOrVQK0NN12NUFnKnCZnPNSjyiLZPI5yA6EA?=
 =?us-ascii?Q?8vIDgNMTudEnMjNC46hySaw6MD/TLbq0nUVtN1qfz1mrnSA5kUuzEDA1QG8g?=
 =?us-ascii?Q?hBkwJ2wzJ5OtjaHz2QbJWo5XOsnrPhBilQoB8/cg6tIb77m5haf3ZqFdoDLZ?=
 =?us-ascii?Q?l6EwgjUsnSqra/rM6lmBfPtRhUiBKEJu07My3vk4oH93ZGZWGl8cQyPJ2A08?=
 =?us-ascii?Q?sEHal2FpzGHgwLPQ2xN9LGY19MtIPMjZ+yVRXr+6XcO+ZmL72IaCStTRrpx0?=
 =?us-ascii?Q?S3XXv8hcePZlaT/0hstx5HE4hVZyW4kTA2viUuM4Debgmd/zL+cPkAgCk7yP?=
 =?us-ascii?Q?pkyLncITXkXt05FklwaH9mWVoG91e52m/x8sJzoD5T/2z8Pr9yqqXA1SSB0A?=
 =?us-ascii?Q?z4sknGDqKqpEkAs/om/aNiw4nW+fFzgVA4fg9450tO9wQvv8OE5vxeza9vlY?=
 =?us-ascii?Q?7g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 518a311f-1e80-42a0-b9d3-08daa1c5f3f9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:40.2236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TS8Ck4OSsPCsZ/OZth0/LhLByolV58y0aPzrfS/Njs0kcBuznTJ8peLRZGBU6aPjEeOPkzS5to/6I8Pp1Ht06UTnnEsnwige/DcsUdyzDXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-GUID: 1P5czQfVD7Gs9aHocutqwXgSNxtUNFLN
X-Proofpoint-ORIG-GUID: 1P5czQfVD7Gs9aHocutqwXgSNxtUNFLN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxlflash/superpipe.c | 18 ++++++++++++------
 drivers/scsi/cxlflash/vlun.c      | 11 ++++++++---
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index df0ebabbf387..724e52f0b58c 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -308,16 +308,16 @@ static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
  * @lli:	LUN destined for capacity request.
  *
  * The READ_CAP16 can take quite a while to complete. Should an EEH occur while
- * in scsi_execute(), the EEH handler will attempt to recover. As part of the
+ * in scsi_exec_req(), the EEH handler will attempt to recover. As part of the
  * recovery, the handler drains all currently running ioctls, waiting until they
  * have completed before proceeding with a reset. As this routine is used on the
  * ioctl path, this can create a condition where the EEH handler becomes stuck,
  * infinitely waiting for this ioctl thread. To avoid this behavior, temporarily
  * unmark this thread as an ioctl thread by releasing the ioctl read semaphore.
  * This will allow the EEH handler to proceed with a recovery while this thread
- * is still running. Once the scsi_execute() returns, reacquire the ioctl read
+ * is still running. Once the scsi_exec_req() returns, reacquire the ioctl read
  * semaphore and check the adapter state in case it changed while inside of
- * scsi_execute(). The state check will wait if the adapter is still being
+ * scsi_exec_req(). The state check will wait if the adapter is still being
  * recovered or return a failure if the recovery failed. In the event that the
  * adapter reset failed, simply return the failure as the ioctl would be unable
  * to continue.
@@ -357,9 +357,15 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
-	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
-			      0, 0, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = scsi_cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = cmd_buf,
+					.buf_len = CMD_BUFSIZE,
+					.sshdr = &sshdr,
+					.timeout = to,
+					.retries = CMD_RETRIES }));
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5c74dc7c2288..4fb5d91c08ba 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -450,9 +450,14 @@ static int write_same16(struct scsi_device *sdev,
 
 		/* Drop the ioctl read semahpore across lengthy call */
 		up_read(&cfg->ioctl_rwsem);
-		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, NULL, NULL, to,
-				      CMD_RETRIES, 0, 0, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_TO_DEVICE,
+						.buf = cmd_buf,
+						.buf_len = CMD_BUFSIZE,
+						.timeout = to,
+						.retries = CMD_RETRIES }));
 		down_read(&cfg->ioctl_rwsem);
 		rc = check_state(cfg);
 		if (rc) {
-- 
2.25.1

