Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55E3C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJCR7I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJCR56 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CEA1F9F4
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:57:07 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOJni006375;
        Mon, 3 Oct 2022 17:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5AI+pzfkeFlpLrmQ46clNzkXWsL/x0YYvdRawOO34PE=;
 b=ScGrEwRnEhysYVeH8OHYiL/s1R6VRz776H6pl5EVmHvO8yKOqRarX0evU5YJj8C0NrPH
 HLKeLshcqlRzIxNn/neqzU8opkbWjyeldth8qGdt9/nKuCM7D9U20jMABT5oC8jfxZg4
 2SjNtOd+V8NqcFcYuU/SqLukFz/bXgHF664FgSbqvdSZlkX6VbW/BZw+X63ml0IVBm4b
 uwk3+rRF+BCgrox6NIwNQs8yXmyCLw0LeF4JUryFskMQRHmOkRvIVhaSPLog1OKgcsXr
 /czH4c5v2+rJgyz7kktL7gjkPs9vKj80hhjgkslEd0YintwFyODJbilPGYd5fYsAvTwx Gw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn48wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:55:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hp55Q014859;
        Mon, 3 Oct 2022 17:54:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03ysrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMEZqCMO7QjuEcrjqBoEz0qAYZJtB34Zy1J7pkw8XqaRARuGgmDXy/mTa5HNDL6qJeworeb5U9XsMwl6CwyQWYZ7Aksj4Ah5YoqdCqaMfqtlz8NR6HlBH0kAoGVCnmJ64OaKbXcQydY0CzrKh33h6dBB8ZWfXe/t4UsH+Q47nXY1aQDIkaLWN8tvM/hVOnI7trDrIMAg78ZicCv9aUn2mBh39tzLxYI4V391CRw5RyoMSQMgp3dhA9lvSe1EAH5r9nrQGXggvDNtOK48aL9Fw57rkRS/9cuRqghetwCuSSZjvjcX27z7t98ZpQMgEtDTppDTyLVsCtwBY+3b6GPWIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5AI+pzfkeFlpLrmQ46clNzkXWsL/x0YYvdRawOO34PE=;
 b=KWHul7HhMP/GsCHbJn1kJR0W66E5Hb/RGevT4mcLidIpKgQ5s9wKuBSNogQUlbQQCEtCr8KA32PCCP1SxMEXJiSWJQxONmaElxcJNAN3yHqTJLuMsuoaj4bFsWFzqE3YH8Vn4qDqVqXmM1xbIJoGsZeivm/LSJbegr07Oi3sFgDWHui4mP4AxY0GuZEBfGlq61VCmDikEeVqWRhAqmjQnD2rHvQir9wC+MTVyamai4kTNOKHuKVLLg3ZKCdb+0moAoCCYaoX/5nHcKqCs8OAhtj0OxKPMh5Bz6CNEDHhDBW1xefhJW9xDF7YzR9WHtRY17WaRjcP3HEyxJrFDjviXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AI+pzfkeFlpLrmQ46clNzkXWsL/x0YYvdRawOO34PE=;
 b=IWPVKzEOrzsppxlP/gHlou3G5dX6vsoYEu3T6WmU1iqFc5Q2dYll+XJmrmCNMlRwNbT3H3eAVqLGjoU87RlD/1faLnca6xL0nSCuNHRm/OvaJNSRq6G4F2UIEFeKWl4yiFHH3y24Mnw9nhASdcDiweXUxnXjzdRfPRM38XohPYQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY8PR10MB6683.namprd10.prod.outlook.com (2603:10b6:930:92::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.26; Mon, 3 Oct 2022 17:54:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 35/35] scsi: cxlflash: Have scsi-ml retry read_cap16 errors
Date:   Mon,  3 Oct 2022 12:53:21 -0500
Message-Id: <20221003175321.8040-36-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0028.namprd16.prod.outlook.com
 (2603:10b6:610:50::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY8PR10MB6683:EE_
X-MS-Office365-Filtering-Correlation-Id: d1ea01aa-07e9-4eeb-bdf6-08daa5684fb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZFJMTJBULjh2gwrDZOmd9ryUEEnYDFKUGKsRfXMuC4s/bLyShs5De3vbGmndGA3U+ukY9CQqZ2nZKswbQL2QjnVBC6ObsUwV84Gk8woIDifDqgDBjplPbgYdxzJuNT0XS9aGBjDdDagZSS1ZhiE27RbiA4hz6FMysU+HBL66ZJNLYKhrpMRK0mKHt7GuDt4oyhAvAXJiH0p2yTi7PO6oLleUUBnA557jGRKQmXnaLs1TwTxbPeJNzRGyDBKIamLy9mvlzGPRjJe06ZxRnSw21Vab0HEMAX57iyOybOEOuzdmnebwTDwcYOnZIcdBnvNvZ/O5Y+Ik0VseDCXoLd+bbwCZ8TBttHnqFlPyag8w/JciwICygAzfr3QUairoRKqlGWl65W+1c8CP/pKGnQlFdnS1RfkJ4LEauQE3368QxpUa8ISUmiXXxU4DBtfeocrqYFDBtOjJFriRPA1JWYkuzLG816+591dHkah9P5gmUejiwqumcotuxA66OL6WUSLHXFM3+aHwi6SSajL8RxiRoehSh7tgre+8YZT11pqbMDPRAm7L222/18T4xmVxTDdblA5lXKevDGCfrnryo5RvP2uiZSjzttySw85uaCkeA69JteSuY/dBem5xM6y5aNCn+rjHcNshh6ALAqXSbq3pm6z3bdGxAaxtQxxkkb0m5nKpw44RlX1Clf+K0WyPZIQTb3kkJduYK9n9Jt+XmAW0+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(66476007)(316002)(66946007)(66556008)(86362001)(8676002)(4326008)(26005)(6486002)(6512007)(6666004)(107886003)(41300700001)(6506007)(8936002)(83380400001)(2906002)(478600001)(5660300002)(186003)(1076003)(36756003)(38100700002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aqXe2VIFCHy/Qfy2Qtn3er24iInpYBhRr9Q9xljY6O13EZpnMfhawCNaimOn?=
 =?us-ascii?Q?M+jevuSds9cAtPnrcR5Wd/FcpVK8oibr3r2qb/kMRhBihqJQqWD+GkZ2VSeG?=
 =?us-ascii?Q?ocmKPx3MjFd9UfcscW4HfKrvioog558FRexxvMpRQxViQuPblDKPLI6ZG2cF?=
 =?us-ascii?Q?az932y/inkkIFdpfcrJn7hAPJXaV0J3RSH2Ltm6EkZnr68QqllNPtYXNz8RH?=
 =?us-ascii?Q?6hNMw7WbHVeruAP0LnGuIfUYtPTmenjZ4oxWKLeYX7j+1PPAI81sRqqOVkIH?=
 =?us-ascii?Q?xYzQ/h4nh7Xqju/x5ZFfw3YYQ/7kCkJtxqTVamv5+0vnwPtf1DF1oZZEcYB5?=
 =?us-ascii?Q?Ub8Q4VAWXtXpUCYXsPzlnaKvvuCuKsuZ31dX+XdzT/3fuNVJLMp+4qIOYW4Z?=
 =?us-ascii?Q?su0SQOI6NJGphj18TVXOZZo+KpGqBR8sMuNU7Bh6Pv+Rf0IgWl6T96yLfCV3?=
 =?us-ascii?Q?0iOXsDVavQAx2yeB/eUoGnvy5eabsRCR8snV7QsQDksauqOVcoz3Z5ArDnQv?=
 =?us-ascii?Q?8/PxF42/kMR0ruWbz/aBMSi6Ytnyyw4IO205EWdXJ+K15c4wh8HMV79sD+R/?=
 =?us-ascii?Q?0hOgpTtLVOmAr7SBalK2TrkPR17WtvS+tQzE8s84vpelGTDKhk7eGQ93idCZ?=
 =?us-ascii?Q?EOB5bNkQB8ePLvGdl4fKMWvEbjVXbnZ9GqlUxz2h7I0T84NQDXzHKvhVgnVk?=
 =?us-ascii?Q?opA7f1ViQfhBJFHIphFeynUxPiBd/vSkZrxxa7ImoORC2Oy/OO7Zb4b6T4yi?=
 =?us-ascii?Q?LTwk44XPMlPZ/bo+xMRyLQqAUaC65j65fdfs8/uH2ZRWr5hhnGWYsX5pxo3E?=
 =?us-ascii?Q?Be94hKtvgIbbBz0Jb7vBj+FoLIAcIx204rgpmFCbA0U29eU5EQyeoVfi3zlf?=
 =?us-ascii?Q?wqd3T/y/BKMwE8QDhakQpQmrr/3wYB6RlmmJHeeYEeKwm5LChOcR/WJMaCnZ?=
 =?us-ascii?Q?93G87sR40qPxjbCdgY115VJ6OwHjXChuU71HgnWDhMScUX8POZaACk74SNhr?=
 =?us-ascii?Q?F9g2ySa7BIPLCLgpgQ7dWWcqLFrIrrwYyahx90duBKs7ohkri+ZqOfxzuuBb?=
 =?us-ascii?Q?KPk88r8BoIDwQB5+u7HSldt2uqPR959dZi5+0KZovYy5CdAJy0lrhCaHtU3r?=
 =?us-ascii?Q?+8iF3aS+mFT+A38m0vP8cZhBONpyp1kXPY3TXNa+pgK8eulYjrPUeVPVj/72?=
 =?us-ascii?Q?/BD8TN5PQ4GCqrcsDPKYjMDG+1Qrge/BfndkmVq/C4PlUsH3S4ByrgS4d0Ae?=
 =?us-ascii?Q?7uPKOJSSCvdRXicr8ozgFm7as/UTOEX9Od6SYkKmGZKZLxkRQCRX5Tv3FUPT?=
 =?us-ascii?Q?758xYWCRJvPjX+nf4i8D51siIhwVCHyC8sxwF9vuy1N+d6wAxMfRsVynbUv5?=
 =?us-ascii?Q?5XrfTYkcqcI93nYG2iYgEJNKJWFeuYco8PP3Pxz5dZrztf5xPvVOFIxUKRzs?=
 =?us-ascii?Q?pCCnw2MIeX02zuicpcgcQLia+a7may1C8wkNXd6b24uUX8mvf/Wpgg3t0EkQ?=
 =?us-ascii?Q?ft6+TP5F5cBEbsZFMggNz+DWkfqRG+30hvMLTUtuFtUp2dqzi0x/zOTB6qQz?=
 =?us-ascii?Q?MUanSoMqjNsMaAqx54WBLmAU0f3X2rkSU5jm336IJF0J6tKGERuccz6FLplE?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ea01aa-07e9-4eeb-bdf6-08daa5684fb1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:25.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sgASnb5pDZ/JKRwlpbfjX22RKmaYeXeGxzCodvcv1xE3ofcxrdj9oOa87/S+0IkU7u1mozzrKnQQ+qCjBbjdt0A7br5Dn4MVJqM39m9h/74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6683
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210030108
X-Proofpoint-GUID: VKvxyubwJT1C-eeKmevxBRdRtrsNZBXq
X-Proofpoint-ORIG-GUID: VKvxyubwJT1C-eeKmevxBRdRtrsNZBXq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_cap16 have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/cxlflash/superpipe.c | 46 ++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 724e52f0b58c..8627c825d031 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -337,10 +337,32 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	u8 *scsi_cmd = NULL;
 	int rc = 0;
 	int result = 0;
-	int retry_cnt = 0;
 	u32 to = CMD_TIMEOUT * HZ;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x2A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3F,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
 	scsi_cmd = kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
 	if (unlikely(!cmd_buf || !scsi_cmd)) {
@@ -352,8 +374,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	scsi_cmd[1] = SAI_READ_CAPACITY_16;	/* service action */
 	put_unaligned_be32(CMD_BUFSIZE, &scsi_cmd[10]);
 
-	dev_dbg(dev, "%s: %ssending cmd(%02x)\n", __func__,
-		retry_cnt ? "re" : "", scsi_cmd[0]);
+	dev_dbg(dev, "%s: sending cmd(%02x)\n", __func__, scsi_cmd[0]);
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
@@ -365,7 +386,8 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 					.buf_len = CMD_BUFSIZE,
 					.sshdr = &sshdr,
 					.timeout = to,
-					.retries = CMD_RETRIES }));
+					.retries = CMD_RETRIES,
+					.failures = failures }));
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
@@ -383,20 +405,6 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 			case NOT_READY:
 				result &= ~SAM_STAT_CHECK_CONDITION;
 				break;
-			case UNIT_ATTENTION:
-				switch (sshdr.asc) {
-				case 0x29: /* Power on Reset or Device Reset */
-					fallthrough;
-				case 0x2A: /* Device capacity changed */
-				case 0x3F: /* Report LUNs changed */
-					/* Retry the command once more */
-					if (retry_cnt++ < 1) {
-						kfree(cmd_buf);
-						kfree(scsi_cmd);
-						goto retry;
-					}
-				}
-				break;
 			default:
 				break;
 			}
-- 
2.25.1

