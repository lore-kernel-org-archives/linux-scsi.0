Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600D5C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiJCRyS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiJCRyI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565443A496
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:53:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOEr2015527;
        Mon, 3 Oct 2022 17:53:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=oWH6Wj7AJa/BibEuHkZ3TnIznxYEqgep14KQZJ+v3x8=;
 b=dZvbpw/UvThYmJhf7IRJh32K64EyeG1LGpwVgNBTRT25M7KKVDUb0C+QwYW2YmVNEbrT
 bwKLxDv1A/O50DeLiWjWGNi2poi54cpVgEmP0jyv3SSMSoI1lUI8Xl7tu1M+YbeFL8Y4
 +z3XQ55cSDr9CYlgEIl2PSguj6cilBnY0vAMI8nDoGal9wdI0vaF2nrI7hvRS7rMK3sE
 jfj175OrwnlrUu+FwD5DWFv9mFOyitDv8Xsx6ia/SKFiGa7J+NoIkXVX7Oe2NUYPw3gW
 pcshVP9Ul+sO/ul296nSUbKG6XH7elGNFg2/lb7Ka14wp8yhTXGO9Hlk3agDvph3kKZq iQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2mbkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xn015519;
        Mon, 3 Oct 2022 17:53:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F316HMY3rVOZZJuufmcDQmjcG+qR/qLkAmPCKkS7tO2Ps+njCKd2bux+zTJCiJJI0jh5mzPiO2Qe2F7eqCziSvvNJC+RAMWan5MjKCPhY7UPk4VTLR4hkqKA14wvcTNFULJXYBD22wtVnY16m+n721eA4/us9sf5JHy5NxmY42Ei7Vwu1YH4qHij20jyEYMNKHWZLBJJMEeCJ0kE9dR5NWAYmE5T0QFfT3KCtSaVKJLRS+lzl29y1twOaX40c35IkpnVM63/JiOOZqlXl9+rKx+EsPv4BXkdvZHOP1dOD5LJ6xpwpmxZPBmsX8qvsDEs2HM7Oej8eI35VNq+f3jW+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWH6Wj7AJa/BibEuHkZ3TnIznxYEqgep14KQZJ+v3x8=;
 b=gR4EJeuvBBCnl32HpAAcINWBI5FgjbL6+p/G7+NkT4LbBciiEbgmle7TGd0YZGGaQm7qpFRq14m2Y7RXemk5+N3pLXjTLKGoOVhKUlKmo4WA/M45qWTuKhywr2clsdATyaHIJRTMatEQGuA7Q+jIz2hSexzvGcjObglE/apfM789C6bgxYVI4XHdcw73juDUpCMmq2r70Q4leMqVmqxUXRl5LoYpeIBX3CaYKpXUupwBxVOSo9gQUW8LtucgWtipfGHMZou5I/Y4+a8iit26KzOqnrFbrKCltfy9czoHnou2sUV2gXhvIgTgNFW4FWYIjcrUJRwKsvnGtahLOot2/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWH6Wj7AJa/BibEuHkZ3TnIznxYEqgep14KQZJ+v3x8=;
 b=Hzpfgn90kEGuH5H4MY89ufv31afkZJ4BkkE1EnJSsBSZvXEcKr5Ndz1yp4HOJZYAVzS/t97XAywm56NNPT2mrOT7jNE6KpQr9QPbgYOsnwjmZv6nbEEWBswtvo4vOTz1k06gwr+Go/m+MHpB8yV5qbJ0/cD0FA2hGK3Vs3swCZg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 11/35] scsi: sd: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:52:57 -0500
Message-Id: <20221003175321.8040-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0029.namprd16.prod.outlook.com
 (2603:10b6:610:50::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 9693fadc-b678-4fb7-7e99-08daa5683461
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JnRm06dlrkaNs32GkOteAUc+X8VBstfZnkZEIumL7A/beArigsJ+5c5Ol3vB78rHKL1A+6pr5Wo3ADEj9ottWxnkmrBJtQXYvk7eiI5h64CHJwFavdjndvnkBFgFBxbHeBgpnh8B1HFVMUtK5Ig2UdtV4rWG4JCVgXEBdnoJmBfA2lqSp/O51gUPj0p3rz0M0Ne9Hc1YLuDS1KVR775bYLzyT5QfLV6gBEGOBmAbhG71nNXB71GcAgXL7N1HdbDFRYp/xjOQwG3kOzb1ev6vbiuo/6FaHdjqSi3gMDMzX0RJNXB61TD6xW9+ts0AEnhhBsKIgZp/Zcpy9EjBSD+pN5KvU8FWHINKbisKkrWo/5/iRr4NstbGb9I0Wy77Q8r7tQWPb9hTGAAFdPCmG5par8gf5mh4Yaud3FvptjDuz9SIs4S4H8NrbrZ95YazMyc3tQb25y+AGGoZqgmxC6uWXh2PrWeE42x9frhF8xTpXXsBP4zqizKQUGmGIVvpYGSIpk/JKm2v34gZcA6y8KV2ufwjmad5tMdgObTQJKG8o/O2R52q6M7DruzNO/Mnki4JxnImxtDJSOZamjuBYODZsXqMaK1JWGWG74TVhbWxxrKUB1M5i1TioZGJdKaZ1L2ApSLq8FOou+E4kYQPxNxUoajVZTFtuZbPa79nb7P8JxRfU+dzSoWTmSaSiRpX064fpOu8dGqEShcKyQogkjWSvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wP1JA/z13hMWuwCOW6ioyp50HvU9PI0GozIsxeshsmR5cDTEYz9ORRBqztbl?=
 =?us-ascii?Q?2rTs20okWaT7ZO4t6QuMly+0V4TcZkmNalJ4OUlAqAvdpw+BUB3ys81GZjir?=
 =?us-ascii?Q?wpR6uvFNQlIDwhOdMIXUCTV0HMlTf9R9OgVVKiG3EEidfyrWd8nogTqxP41Q?=
 =?us-ascii?Q?0Bb3AuYVPgCpMkUhy85F6IjdxBTmUWHyA1kXpmKcOz8rSWt+OknVhIXEmp33?=
 =?us-ascii?Q?xQv4XcmjEzwcqlHGmTP5ZPd3DvXo8aRRc8BVGNBkh3951kD9POmM1VL+E3wz?=
 =?us-ascii?Q?chLuJvZdMoRcOIBCjhuz4GJlYrWVQwn/YmDTWo8GNGGZF0ptNEKlzVvv2iWL?=
 =?us-ascii?Q?D6KmeJ5uo/L9t52aJIQ+CDnl9xCMX+7MC5uTQxw7kRInS5eQmN/SuJJL1GPk?=
 =?us-ascii?Q?grSGYoEBOVP4xvqcSnuo3yo6jF3Fnd0rKIolDh1QBkkLvRarPSL9+ha+c9fy?=
 =?us-ascii?Q?MD1eqx9RByK0/Rs0tLrMiQP1zvtcfwBNy2XfBsL+M8y8LGdfkkQGctuog5/A?=
 =?us-ascii?Q?yaQIR1gZLRM17bzqb9Yuuk6a8eUSGybJGGFNWXjrs/bMRgbn3ZtgUOA9rh0s?=
 =?us-ascii?Q?7WXh80ejejxSZGmr00HBlgZGUhhbp6KQsvfqTkxNQupj11zkPRJpgX85c2d5?=
 =?us-ascii?Q?cV5sjtYC2qCjv57rGxgmFt0nX4wQy/uDEjOUAM/ufN3f5UNwSv6u8RDDRBOx?=
 =?us-ascii?Q?Jt9yBMjaaus6ZiT69u8eT56CxzzJUIFD3a0wUBtCH5be5duup7pL9PeODIqD?=
 =?us-ascii?Q?soiP4PwJROHrciUV4rAnTQwWOKKbVkj1FbF1yT0GXr7tr7TX+zQFydEI7XOW?=
 =?us-ascii?Q?sULfwtq+7DJBQ9cyYtK3/OegEoRQ8qTbUmRf0+EAa6mmAjm7N9+UnETruzHh?=
 =?us-ascii?Q?uEUO7GVHf7nJq3wd52YcxBcC5yYF9ry9svGIXSSNm21jwORPFtiuvtN5+JOk?=
 =?us-ascii?Q?Yh3aneEeGRdDVpOeeVxBeF+BWgpyh9x9yfPoVYkUlU8mb19DTN2OPN2DKTUm?=
 =?us-ascii?Q?CN3DYK+Hvt2F4i15zGTZTlMRnPziUuJ7PyFpm9/T5Quf/HNq21YIWFJOldD5?=
 =?us-ascii?Q?qdRb3seLm7Y2nF5hlUgb0DsWuoVIW23M1dETP8YBPVsHfnkV1+GEFrULwOMH?=
 =?us-ascii?Q?filQFFWKnLLiJm2D4ASryvl0RrjxpwwfznWCPQ7Yxb1pjleRE6iCFAnWB/Hw?=
 =?us-ascii?Q?pGo1LVZGGvp7kaXTTMN44/W8gFfeM/CbCNmpBXAMhM5wB4jjdo3VrIXheVpF?=
 =?us-ascii?Q?h0IqRrbDBQwEO03ziJ/Lr68XQpQz/N8Z3zbzG7HaPHM/TIpO1eb06AhPHnWn?=
 =?us-ascii?Q?l2rh8/hKKZPHUF3x3j0Oth6S7L4AoFGkJlsVdFx/OajqIXzAHa4aIuXbs5z2?=
 =?us-ascii?Q?tFmG2ONbfULqymSKdjaQ2f55azAoecV5v2mr36knZQ1W7HoMsXiG0KBIj0b1?=
 =?us-ascii?Q?FuJBUmnwqQ4ZC6w/wteXmix/6QPD5ndw+zR+hIUh8dmGY1+JP/xg60Ob0tSq?=
 =?us-ascii?Q?sKMZT31jZ7aIQr2paoXgoR1tjXaMMURgzrewAjvBmHFm/9Nx5R8F4qBFvx2+?=
 =?us-ascii?Q?q7Hg3IIEKr/voyqAR0lWBZajT/MbYTEPu2OGjIkSuLrNrkq4DXB6hqmi1X2T?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9693fadc-b678-4fb7-7e99-08daa5683461
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:40.1739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hHHisdbcDInE0PgZ2Zl/UsDVvnkPLNDLGt/Ay8nUyTwa+RyZJ0QpDqNDmpANfZoNWWqIDMwsNozCINyL+mr7tX8d3fKk9iQ3i4jWLrM06nU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: ytNQ6Tyke-W1r4bhumyeJj91e6XWfCa8
X-Proofpoint-ORIG-GUID: ytNQ6Tyke-W1r4bhumyeJj91e6XWfCa8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 102 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 76 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eb76ba055021..37eafa968116 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -671,9 +671,16 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	put_unaligned_be16(spsp, &cdb[2]);
 	put_unaligned_be32(len, &cdb[6]);
 
-	ret = scsi_execute(sdev, cdb, send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
-		buffer, len, NULL, NULL, SD_TIMEOUT, sdkp->max_retries, 0,
-		RQF_PM, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = send ?
+					DMA_TO_DEVICE : DMA_FROM_DEVICE,
+				.buf = buffer,
+				.buf_len = len,
+				.timeout = SD_TIMEOUT,
+				.retries = sdkp->max_retries,
+				.req_flags = RQF_PM }));
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
@@ -1594,8 +1601,14 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
-				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
+		res = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = sdkp->max_retries,
+					.req_flags = RQF_PM }));
 		if (res == 0)
 			break;
 	}
@@ -1720,8 +1733,15 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	put_unaligned_be64(sa_key, &data[8]);
 	data[20] = flags;
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
-			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = &data,
+					.buf_len = sizeof(data),
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries }));
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
@@ -2062,10 +2082,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
-						      DMA_NONE, NULL, 0,
-						      &sshdr, SD_TIMEOUT,
-						      sdkp->max_retries, NULL);
+			the_result = scsi_exec_req(((struct scsi_exec_args) {
+							.sdev = sdkp->device,
+							.cmd = cmd,
+							.data_dir = DMA_NONE,
+							.sshdr = &sshdr,
+							.timeout = SD_TIMEOUT,
+							.retries = sdkp->max_retries }));
 
 			/*
 			 * If the drive has indicated to us that it
@@ -2122,10 +2145,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[4] = 1;	/* Start spin cycle */
 				if (sdkp->device->start_stop_pwr_cond)
 					cmd[4] |= 1 << 4;
-				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
-						 NULL, 0, &sshdr,
-						 SD_TIMEOUT, sdkp->max_retries,
-						 NULL);
+				scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdkp->device,
+						.cmd = cmd,
+						.data_dir = DMA_NONE,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries }));
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -2272,9 +2298,15 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		cmd[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, RC16_LEN, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdp,
+						.cmd = cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = buffer,
+						.buf_len = RC16_LEN,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries }));
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -2357,9 +2389,15 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		memset(&cmd[1], 0, 9);
 		memset(buffer, 0, 8);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, 8, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdp,
+						.cmd = cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = buffer,
+						.buf_len = 8,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries }));
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -3608,8 +3646,14 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdp,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = SD_TIMEOUT,
+				.retries = sdkp->max_retries,
+				.req_flags = RQF_PM }));
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -3740,6 +3784,7 @@ static int sd_resume_runtime(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	struct scsi_device *sdp;
+	int result;
 
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
@@ -3750,9 +3795,14 @@ static int sd_resume_runtime(struct device *dev)
 		/* clear the device's sense data */
 		static const u8 cmd[10] = { REQUEST_SENSE };
 
-		if (scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL,
-				 NULL, sdp->request_queue->rq_timeout, 1, 0,
-				 RQF_PM, NULL))
+		result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.timeout = sdp->request_queue->rq_timeout,
+					.retries = 1,
+					.req_flags = RQF_PM }));
+		if (result)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Failed to clear sense data\n");
 	}
-- 
2.25.1

