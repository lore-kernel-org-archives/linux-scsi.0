Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9DFC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJWDGz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiJWDGw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97AD1580E
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2tGUT012781;
        Sun, 23 Oct 2022 03:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=fZNfqneG0jK1/tbPpvcrmHtRanh1CuV25zs0jlbH/F0=;
 b=PFls7eN9fVDq/CDyWdqO7g/0Cy+J976U1H+V6/Ks2/qxLlkpQX7QiBUkQ9/5HptA1Xcv
 ilZtl6tksBGwi/elP117N0LYtSPWEbudqtuNJEuq6P9gxAZlRGzIPKcAltSQIfL8zUon
 TJdOjsgecP0Ieipb8qgzEao7ttBIH37iXtAhS2jd3ljXhtKLu071pu+tno1z6tzaxhtM
 TWMgp05qoHNzzGLmMz7wtDznFQl2QhSmPDsy032dTIpysCH59cwUqY8hmQwln6fP9XtJ
 K/MJsPJYs55F4sGlrDZ6lk+BrMwpKBmAwNZPqt/Kfh3TnVrr2G1cyO7/fNGeJRktnpXh kw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84ss3fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MI9mUc016664;
        Sun, 23 Oct 2022 03:04:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y90nbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IbrWxB7/woG/VLolKZPVjs5/E7HMHkaUVJfFgwEyX6ArhaIhTU6CSK4GMBzRMVfTHvc+KhXTTDxVVNvfVHcOCztjtE/iBezp6i43k9US2pxt13wtYDNl+ZBJzTs02R0+fkzVemI0PiQX0c9efS1AtH1IgH5AN51UjW+IAW68gWKQuCfiR3OHobODE5R8vKemv7pDa+uHQndjDbHeAsRC/JU3cfgLkIx+1s1KP8Y7nZG5fSBo1Nr07EFeUHudbG2xGGPGAARTW0Cgq2sSRfqCP7/g/t1IIGY/K57j4/wMTW3J5XZ2DaLbyGdwndvfjnCZO9xEFZMr/oIeng4I6qaDAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZNfqneG0jK1/tbPpvcrmHtRanh1CuV25zs0jlbH/F0=;
 b=XcNTcyzNS8npT702URsftt6K9g1D7PGgwp38S5u9h23iG8eJ9hmuZ2muXUy0IUOIREeXyu6ozi9YCOtAsFie1AkdrfuhU+MdvG8UhYNr6NFO1OJTkYeOl739f8m3EGjNkfvTf5LQUIgHrFycntmWQBsbhhVZ97w9q4vADREi7aj7zvXQY6UNGhp/hvOcj4KFdPRhrJHwj+5LNbDzU1bDI4q/zWxWehKdvJWgdFOXD8IlKhs6bubsF9g38NEilUEOTkE1w1+I6qWQu+cAxh0kQDooBywhy+KY5EhNFJcdeefoUIbRu+N+hn6rdQB9D6tKM3bEfkOt8JONZ7w/O4ZifQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZNfqneG0jK1/tbPpvcrmHtRanh1CuV25zs0jlbH/F0=;
 b=sxcNVf9aJMYQxzhYGqfboNMOPDDfY+van8/XC/gTklWuTSdUCZwtu55dlfVBTQ6b1+/hdDXkv5FZBpv17TJjzIOISZCXyPGslem/qjYm+xb0ZZFFPi5aDF+0Yc5pgXNStceYThWPny7+pTC+qYvpL8GOBOulIYXb1dWE9t4FZk0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 11/35] scsi: sd: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:39 -0500
Message-Id: <20221023030403.33845-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0026.namprd16.prod.outlook.com
 (2603:10b6:610:50::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: b11f1532-51f4-4922-09d0-08dab4a349b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DVG16J8tFYd7w/Wu8UOK74TUgMUr2MToA6g8nqbGnjwVyiMDtsTmkIOtqMuK1QdoFqVmD5AEWHSFmjFWVm7YE9oT4jkcCFhJqtAgOpbhpflWYaPOP8aOVSEnnOxC1wNCz8mxOF7pvsgOulbZWsX0xI9ogSJ5wSpm3T8i4zYKmBwOCVem/rxC1BrBzt4lEfjndv2VD2c6OLDyKFmdW7kKYd5IhB21YQ95Tt3e8xjHYOeaWSihGYJXk8Ex2sj3URTkz5vkadBvjGXXpudvpGyAPQZWXmdYRvV8DvCaYgrFBT9qiQDq4XQBzQc5KJS1/6bqIcsa/Qv7AlnGncWx9EK5LOwjCLDtarWfwzzX6E8MK+chxxDHPmMNBLBME0JBZC84JpU89krJ84ADYZVByBthaVFB0g2F/wFmIuH4Nm9ymbWxqxnYKS4Er0x1RmELu79VHa4j+/wzJXD2s5DicbDoBn5E6IJIsQhoORreXY5QGpEbznT//mnXMTQJgIWF48SKsWZb6Wk+OOGz+Tb2l78gia9vzoOBND/SpFEEkPymcryHP5dZGEI4InfMrpmJTKQnFEcwuteTiFIzgweruFNJj2OCHA1ugqUrcH2QhmZ1OxxKX1A0L9bLSa1hWhcmtZrmtLXRoDnRpz5WQFLZlaRgyeFUPVpN0bYWfsh1icjwMmp8cX8D7MdD/oncu/TRTpnftgOQbNLbSBX8ycXe5iYlbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3AKcIPv2ioOUq27mcsilZ7DdvKC7zudV3RBGQnWrx8q29UPb4FGJZcwhMG9j?=
 =?us-ascii?Q?XpCT7oX0QSdjZtuywPAs6RNaG+CitrMykWYpN4FeB6y9FKANsSqaZTiRLzjz?=
 =?us-ascii?Q?Kmqauif/Do8QcrDjWhG3Mcr89Ti9D6csnr5CXk5gX/JqgdD7IeySHpy93YmT?=
 =?us-ascii?Q?4dJpu8OTrdzHJkQzEAZznxOWtwck68RQi2KrFvq4R1TMo+AACr5Q8rp5zX/M?=
 =?us-ascii?Q?HrmWDeG3SMh5/Fw6tflc1XbpSThZKciQe+XbtNqdkZVJYnj1bjLNkNChaej3?=
 =?us-ascii?Q?4QwAhOj+soGuZnncoiZiTZYUI+DVq7lMIxCvoJR4uv6IjvCUU9/c+bJXaVad?=
 =?us-ascii?Q?OXeDKLkqGdrwoFyyGxAvk5rNLQrGZZr+GXfLiGl0cJW8NMHnkbRPXnJeXlky?=
 =?us-ascii?Q?ItbHncgjDmbxWNS+lZp6NPDQy7mM46+D3jyZ8v4iCLx2WFKgobZxN558gPNH?=
 =?us-ascii?Q?Fa7UO0yUumGHsIywojYyvg2XNzrQ1jqtBoupJGgV78RVvJVT047SgYc/GG7o?=
 =?us-ascii?Q?ZkN8Ucxoi/cLnOuf4U127N/U6AT8ALryB14i75SC3k7rTMkwAfyKafYYQeKT?=
 =?us-ascii?Q?1YIREHbaUkjwrfUwLM25PN8bBCYmbqMBIyyB2xVb0aEMp2/+tKwBYU4q77RM?=
 =?us-ascii?Q?2gp0qj8Slkfj/PI8jQYK4yGYiWyDCffHUFMUPlaPjy+LOZ30M1jz5AEkbp2+?=
 =?us-ascii?Q?nBmm/nf0IQVQc4QTlgpyVWdHylRH3qzBzlg1H/RlysgEkmsANJRfLdq5MFNg?=
 =?us-ascii?Q?qU+Fq/1nfo8MH/KOMCpap+zYyB1ROfhbvxO7gW5J4UX/Fro3rkK1iZhq5Lfv?=
 =?us-ascii?Q?idlcI6IqTvSMHDhO5qKBcaKS55UN1+hnIKkoQVzvG2UTu3vm83Oh6KOJRssK?=
 =?us-ascii?Q?4U8SOTNoBFN18qBW6cY7A0jXLAc0T0CzrsSJqsMSq+00nH+sMIctEfU7Zan+?=
 =?us-ascii?Q?Z0xaVfjtAea+69JPmqmsZNaw/Wf3wSnB/DRhAJCfJ2ELt4VIhthP7rVs+vYZ?=
 =?us-ascii?Q?gfb1RPcKOqmhZGXKAFrFApIo1fLHRF2Sba6xGlpwLDwIy5XVwHjOyvlzzlJ2?=
 =?us-ascii?Q?T7b6SfphE+YUfhxdpXL1N/il25I0f0DT1ebODLaHG0srLS7KAjh81/5/ohqL?=
 =?us-ascii?Q?JNas2v8SPxSOICm3I+1GFaHsJwsb4sV+kbjru8y031FJwcO/Cw46R4oaAXqM?=
 =?us-ascii?Q?P5S+psnasA641G5f9dQmlTSEqBXZ9zJTQd4CoCbbsrAwdy0T5Lb0wZ3I5rfK?=
 =?us-ascii?Q?RB/rXE2wA8ralpeqOgTSpRPfg8lMJANKHv3le2UgUTdT0pVbju72lPQVPXIg?=
 =?us-ascii?Q?NgbZFtdh/JCL2nojpl4QGRizkDAeg2Jmcp2ZcPsHQFkXpxlsf6I+u/iPxBWx?=
 =?us-ascii?Q?j2x2MoDEtDwrThG2bWihfWJAMdoSCxn6J9L7ArODNApU9a/k30JFCXVGq8kz?=
 =?us-ascii?Q?JSRbdJZtg+ovfrnhdPOzvPYfwZafNJKsD7INZZMjpRSwYxlF13PlpEBuSWA8?=
 =?us-ascii?Q?OQYGZ1TsUsHGAm5buARpOMrYkgWZTs4/4mMqTHo3o7+GXZQE5Sg/B8+gzYek?=
 =?us-ascii?Q?wUlTu9a8rsgnIshTFuhqcU/P5s5w4nTP+lM0pRjOlFDcEAt1H7K1igUpWLK5?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b11f1532-51f4-4922-09d0-08dab4a349b5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:23.6866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OeE7dn466zzQutTHJuISKh1m2twM/xlCqBWsNO5Qs+bNa2rhrKzt0SqMKxIeryHZDHkOKJbhgLbS9C74NY2Hek3+52UEnQD/52x9ZAgfNwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: WYj60w45q3QD1zuheve35DaXcYpi3__j
X-Proofpoint-GUID: WYj60w45q3QD1zuheve35DaXcYpi3__j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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

