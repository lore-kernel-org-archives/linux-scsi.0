Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721B5C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJWDHD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiJWDGe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87241642C6
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2tC30015615;
        Sun, 23 Oct 2022 03:04:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=+ShUH1Cm9IjgWLwMtUP3eOv3O3dA79ysgx5YeWTHX1Q=;
 b=i6/JFblXs3Nyz92c2WZ845QopB+yUoneH28dOR/sTHIcqW8n8ftjDNqyESMxSMSjPij1
 K+hE94gpjkCCvzKAMJ5Abc0fg0/lVmtk45F07CGbAQfy+TlWg+fBdrU6+v85uzV34/wM
 IgFUMzYacA/6+7GQf4yNF/LU3ZR8NP2cwh/+N4GQQUVbOSPSs4iNoeZXWf9ran28KEY8
 hpUwB/3PLtqWGbsbqW9XwBqcx8eTh/OlNlP9vpgUf97ulO7W5axL2Ez+8gwlCKeyptW/
 EXe+YF0TVADB5gr7CS0cLEsI07ddAxNttKQxPcRQSj11fPtbSoqJgkYv7kAJVzNj5Ow/ hA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2s4py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MI9mUd016664;
        Sun, 23 Oct 2022 03:04:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y90nbc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/iUwFk+lcVrVyDQ24p8aLdy+WfYrgo5Lc+Dc4sS84ub32baFTR7MBot554ARJ0Q7C3/Qu9fdm7BhYBOdcUqZrsw7s3CwEXiw/N6yGGknJiYk95+E4UbqDTLmUTCic92BoVI3yVgqOqDOagX0ZWkYowLDHSuC3KUKsjCzQtZyvWBAuTt6CkjNyZ7XCVinJ831m8XRXgfoLPld2S2/WIwmi6/mGz3JBTpCAhKxrCHzoI1V4Mo+fUcyggydTL5f1Uu/c2SEvLLUxlaZOh3A7ZhocLYiHAxxhiLWJoM+qEZV1NPfpd+68Jp6BXG1slTFoQrCxdkXTVItbaEPGIRzC5mXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ShUH1Cm9IjgWLwMtUP3eOv3O3dA79ysgx5YeWTHX1Q=;
 b=RPMUEWO8w8kMcZas9Umt9llISaqr0a6voGjy2kpOByF8dkeWyL8zlwZ89ket7RiLvZpPlzNFVMr1kQADq1+DADkRhhJRU9cBSCW5atSq85l0NU8uWUG1RC+Woja33rRHV4zln6jARr8ogftj9xcoK8+pStQoKt56EYGE7hZ7qVn9Uh1dxErOi05vpuh5p7YvAFjCVe6jqxBi+HZr54JjcHEpAZLvhZOBxT/LBd0prsGKvL5oEdIrRkfkdKyHqL8uU6esU2dVFYulaKS7CpPkpGQ5FUOg8WFEgZq5mx6gZd+ZGukMCIkvzDAM8dyANOFZXQX5nH7pbRR6sG4RarTEqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ShUH1Cm9IjgWLwMtUP3eOv3O3dA79ysgx5YeWTHX1Q=;
 b=XMHjEBVzhpozRtQjAGAKNoVzZICjJnM+OLrE/yA3MQpWpv+Y6KMZKeFfXoXMX5Yk0yVAjSH27pG4jG5kM9gX9Lt7dGxDffCRNiwhWbx64+hj4aVG07E5UwXspIXqS5uUeLQlVPagJDUDzvABUJrasidz1FOZDTUpE7jveLJLZSA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 12/35] scsi: zbc: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:40 -0500
Message-Id: <20221023030403.33845-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:610:50::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: fbf98d6e-f16a-4383-700c-08dab4a34aa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/Vl96LCPala110gYpT81VKTx5DBrcDngD7lr1eq6MLkAFl6VSIU7uDAdPkPpSXinooTko3ClHnGU6jE+ktMkwAH8hD4L7b87uiRYqpVYQs+xA05u4p9igq6f+bHOsw+VEVyKLml7UbxSTZurBi7JsN0z6IlcQYgmU1hLRaMU4FqQ9AqZVSGhjO/TXOTT5kXzCVJx1Ch4yrR7oVo7B119vbRaz9y4LqrE3OsiJtbWSzV/HumdZbFj4CkesO4KusNijPJpXj6CA8+S+aD8cb8ViiNJgZwA+K/LQxP9FyFJbaPIJn2siraQSreA0PDdfkv03/JL6KW3586kVDPHztY/t827acC8L/66/ybH18oSKmYidEIAl19OGzByRmO+v+a7hrcxkm/Q7Sg+32gnf80q2o/3gsB06LfIPHCaD/eelnQNk1JwtrAXjyrefHt3JgMLSg1A/AWJ3slyrr6UYy8fdkxcdf3Fqc/VfnUclks8TopCEOlMIsEGlYLpZ/rgDPguggZs41lUC+KKZqDHgcr5VRO8/bO8W9hE/brkYMeDIeJywzdlg9LlbNdbZdk+AN1rxqQ4Gl7AZyQk01Cs5gOBHI8ShbwZlKTTc1syJM4oo/dpmvQjQKivNBZHdvSYkqpfXYRgTx50AavFZQIt5ZyRhH1Y2lpcD7+ZYwfvczH9wqwrUbkdiqAdGau7zzzd/kJQe6MPuNDfc3l/RaQQa5U5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J9p4IESi58kd1aom3cMGg47UmCny0WzHpYFn+ylk6WKVyMzQUZGr5bnk5C5w?=
 =?us-ascii?Q?TEBEa4BRBBgPGjzkb0lVZooZ9lWHjEumdKdCnmjftnFHEHgxc3iB8WbGaBMP?=
 =?us-ascii?Q?4KP2oTmpekvvawGPMzsJ87AkggiMpaG97k6tdiVlXY2zpRHncGTTiRSDZPsN?=
 =?us-ascii?Q?rnFYc4yyrI1VbAsPZ0Dk2Kkawgd2EuV/xVUvtANw/6TjcFHou6ce0KUMQZ3V?=
 =?us-ascii?Q?7CIqRwZys3cYQdRkfPgJHldnPbBDJVBilEYF4j7tBQaSbWjFHLtBW/I+P3vV?=
 =?us-ascii?Q?9gvGezDTArPYNuGTm8M2orrWh0fwHfAE0bB5BcrRUxiIbdVo8s1kJlxr1T8t?=
 =?us-ascii?Q?2eHREG+qFFi/QRkTbGSALL0ObynVjApKhUNoFf0HhVcOxAVobTY7vIvCYuRv?=
 =?us-ascii?Q?DDXJfBz60ldTgWNvtDwLtFHQGqHIZG4nJRO6ALkRENVqUHBD3KTSLzKMbt8l?=
 =?us-ascii?Q?ZNRHlVP80oJ6Y9XaUgFpSot7gcgepD1vvmTOGzKxZ0M0q7F3avmasxFDeR11?=
 =?us-ascii?Q?nrvn2iL8ph79bXAuyxika7waQDmSmyBrb05qX7oGyF8RYRlZ4IzEWuuZlXZM?=
 =?us-ascii?Q?Jgc2wNT13xWgCMYGXqSYRA7nZyuU5Ud1uyVEBH6WDkLZ7cNjcYAWIwJRF57+?=
 =?us-ascii?Q?Cp8E2WQq+Wv2e1bk7qzduNLden6uI85fJJrdNyB8CZ6L8EPWUCq+V3E/5e0Q?=
 =?us-ascii?Q?ljzsY5fdHBbp5my3NH9xdhWKF7/+TfoA6ngK0yEP5ZAUBVWf8gMd+3VGGg5W?=
 =?us-ascii?Q?0KBq51Xlt+9PWVB7sjnX3D5VaZ6hCwL89AUS/WXvCSMSCAt6tNT2tTaqn17y?=
 =?us-ascii?Q?dUqL94M810MsO2UO88P8iKKR9kyG9b8a8Ex7UZOxvzdTGib3jl5eW+NBPB2N?=
 =?us-ascii?Q?woAZB4j8/vr+vYfpyFvYHGuDnmgggCYcSwOYroVgH8sx3mgOnzHGNlakT7pd?=
 =?us-ascii?Q?N9TUwheve77Cp1xt1NGBCDWhFIH64x1v26VSklH3+N5rW1kkAWIPg5Wg7MLE?=
 =?us-ascii?Q?5ihvi8p22JdLDRAOJgaW4V+79mvMycpGFWKvebVK83m30k1kGDXNzuIKDOfx?=
 =?us-ascii?Q?0ZTabURQ4V88cJT1r0mcVQLWo4YoA7IGSUUgulhG68YXyVEedPxOjjaS4st8?=
 =?us-ascii?Q?DK46f6W+0eiStXrOh/9m64T4luXzS+jZietKz30MipWSXyhMF3z1Baw2CEQH?=
 =?us-ascii?Q?2/oM/HceSqhZt+05PQNX0tLni5qTBHUEXOmVbrY5qA/ttkfavl0Yg7ktRgzb?=
 =?us-ascii?Q?AADxrkVih2q2vuzrOvuOvny4qTtLCdxZIqU3ZDf66HPtNy49bel+7P8PHQPW?=
 =?us-ascii?Q?jJfDkLxN2eYOCWZNt7IV9tn+TsMuESuRw5dNphOB/DThobXvI1+T42mf4HKH?=
 =?us-ascii?Q?U7BnV92LIVV6FSbBA4ZaHsrfb873P/gH22Dau2kwAfhMvdxdSab4HiKVPun2?=
 =?us-ascii?Q?CczhQNLmfn1YqcPmEAKTltt+f3EaiQvSNR3m1agxp14Om4IWNFkwWtMfOYNO?=
 =?us-ascii?Q?HSMhzkKu2eRAHYzqZOEgPJwbQPac2bUHe9oxzp4prpndKBn3EJvG1DurWB4w?=
 =?us-ascii?Q?G48HuN1DCCIjbkZQK8+xnUnBA0ROboZZDDPIubqlfrYknAcE8k29Z4iOCxql?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf98d6e-f16a-4383-700c-08dab4a34aa3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:25.2802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6eFQZYzG6Re38deaSDWlz4Ep02zT6EpUbrOovt1HT9SGelisosDWgFRvcYxoUyGbBF5Ro12WM1fnMMbFuKFGtsYL5FjWg43zuBJncw0uZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: XFNqv2g1Dn8bkbrvaO-I02R9vOBZQ8ls
X-Proofpoint-ORIG-GUID: XFNqv2g1Dn8bkbrvaO-I02R9vOBZQ8ls
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c6322..d87884a19a51 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -157,9 +157,15 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
 
-	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-				  buf, buflen, &sshdr,
-				  timeout, SD_MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = buflen,
+					.sshdr = &sshdr,
+					.timeout = timeout,
+					.retries = SD_MAX_RETRIES }));
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
-- 
2.25.1

