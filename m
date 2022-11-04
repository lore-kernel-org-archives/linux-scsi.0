Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC65C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiKDXZm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKDXZF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:25:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9685FF9
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:25:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KhqoD032430;
        Fri, 4 Nov 2022 23:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=89V0qRUOzhqQ8z7alxDt1RFC9kTsIE3HKelb/jO2wwo=;
 b=kVs9xVE/cHAwRCxkzP7lXQZakxqZVUicnXAS/CZDrAgVcLSss1DkgP23bOzhKwCtnvlA
 eDBA71ee14DdxoZJanktqv7M5KKwGTZ2EOvHMjVcnCSQCuFnrb3Y3dUO0ONt+acmqCm2
 fYmpMIdjSw7+j5noMjVBk3FEK8YOBNXFBexm9CbErt2D7OG3x/h4L8RydkzSrb4tSnv+
 L+glGxd/8vkqN4B9niCsu+jwKtgtZU43yxGmKrbORYnDU9/W3Y091QtWbcFnkzzaGjE9
 YKYAB5oZPRj4iqxEUZSA7yAeJMRg3pcgGFTua1WH7u4XCx+CrYpip1oRF9HcVskPlfz5 VA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgty398bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4JYZRN029604;
        Fri, 4 Nov 2022 23:22:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr9a9r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmHkOrVMLjYY09d+gl54jaCjq3YJ3a6wjwXlWeAO4NNLfmnIuV5+gU6ohif8ZaqWFw5AD7WGANIYBXSTZtB6JqQUb+mvRTJ0ApdP0t0C7yEU+uk3QHvZIy9fmhTYMZYYjInK1I1OBW1CveGLSnydb90KbAHjl7f/upVW5miyXtJI0DoNPeBxh6ex69b5THhIwwoWwbN7fjl4l+/fPceA0H0L0txtIKKii/3Uq5eN8IkTaJBsVBmwaq1+x5ql9izussMcCbqK0UMIua9CfgRA255M8feunZNP+rx+/kZzHiWO5Y0xDAW9L8vXRB/LWFeE2gsTjpVYfY0XXxW8b8K3Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89V0qRUOzhqQ8z7alxDt1RFC9kTsIE3HKelb/jO2wwo=;
 b=WnTzRA7Nu2IUDv64IvLiCa6zUaug1ph/CugtiW6xgEFEyv1KS3l/8tuyOiTa32NRT+8ziw9kpn+9lBqPGwFrD7ax9ybuv/NQBNz1/SurvY0cVkBaX00rlAkxkmp7jwUAdwjUZdMoa7eli/LUR7f5fL8Ts5k1Ifl2nwFsni0L1yqsjinORy0wiVpjLU5oRMNNcnSPBL+PYaJ1MGFfFKIhxlSRvHM4QXNHz8FwbAhXjCz1cjb/P/PjJn8s1dxXx33LgaDq9ZGxli62ZtxZCG7dZ97lxuK4a1zk9iKywVNUS+X5u6NLljSEgiGVCmttn1xhoI5BsqtPzSotdMlBhAxURw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89V0qRUOzhqQ8z7alxDt1RFC9kTsIE3HKelb/jO2wwo=;
 b=H5te9ht3MUhyctRFH0w61WT3LSo0E+yheAgUyD02QA2jx059q68ZJmaW56RXxllEw8m/6Sa+yR/BaxAc/VwOAslI5krK9IRkpHSWT3Jiiev0fNEl4SQXYHiyDfHn3aoEn0DyZmZh/amT7O33JSGULg8ig1jcfSK/EEqddvjtVbw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:22:51 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 33/35] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Fri,  4 Nov 2022 18:19:25 -0500
Message-Id: <20221104231927.9613-34-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:610:76::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: e0629b65-5861-44bd-aad2-08dabebb6c9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUqeNTk3IFx6CW1Fyd5pxEjPx/yCM6jIFDg6UgnATNMYc1iqKPDUcpJTMFzTRx8nZ/k7jly2nuXsqaO3H17Q1ngmyrEM4mtxcbIdJNi+g6PDvaRqaPixQMaogRyxRCgpzyu3lQqVPFSP9z3C4vCXQJPlzQc2WDjlGbKNwQ+vS57KaKzBSo99629jfVNKr1fAiYqFx7BTOa/emzgkqCuu0EaNjo8zznJlmOOZG1AI0Df4hrdVNh80V/IZl3wBRi12CSZgjHiEsTneXtUgDgA+NgdRYgzPr74XUEdfB4Q6o6EkUHNk1iVHPldvJC3mqJ43dU5CzywH9ClVDgZdtCDE8Z2z/bYIA3AQjI942oYtrnUDSJptV2PKCSpeADOrqvSZvkeDG5QD12dgNuqKRjRfXn2HigzZ+IL5x53h6prDtShu6dzUCquzP1SoiqaRHSOV9nkB85I+K+nrJ+n8qVFdXoYSxpwic9GH4fuswp6ScP3TJjjmt528l/svLqScmJap4LI24gskPUdZs65Y9+QuD+ZdsW7sLPbPC2K8nsrmIipCzfhgDwgeWYo5My7ukt8FEuZX1EGCXZrt/iR1mCNlK7+Ch6R8j042b6L8pK9+EqIMkyRyRX8fZ8jpqzkpnvtgwibp9MWLSyTK7VrddBEwzS45TE5TJ7hPVnzubXXev1V4opPto5YnoOU2+t/bHT5ea0W1mwfF4kLuuOjk8cTSEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aSof6pt9pTvmseJwmXhMgJ2cxJQCoU0AmP8kTVAg/6iGMWFP2nOM7UBW4Yyd?=
 =?us-ascii?Q?e6UPDwUwlk+aszmJwDOxezXtNk/ZwmW+WEeusHo+DBBAyHnnSfyDTat3q5/f?=
 =?us-ascii?Q?k7OBowGddzGwkZpiffeJR/0t5zIssDGQA89tglHCAwClZw2LWKMWqQ7Naqlw?=
 =?us-ascii?Q?/G2CUEhARFZATxI/McV1vr61ZFGZSOoDx3Bud6eZHu+NMJViZWtc2+XtPgRR?=
 =?us-ascii?Q?kQ+C3aSdCnHY4ENzfwaREgy6NZ63abvezwSFCaVOiPfhp+h8ZyeYWm4Uoaha?=
 =?us-ascii?Q?UQ+rR0XxbRkN1zHt6kD/7GpDmuO3bjAa3ugTqyB6X4JQ0ogToKMbvnVQG6PP?=
 =?us-ascii?Q?ZO66USShA1hB3J5GST3Gyz9cfYVTjlVCokjHJ1oa+aGex9RGpa5LeQ5XzSJr?=
 =?us-ascii?Q?aRFgzmQz8hWC0SpsnV7huT90v/spjjEpgnyZNIFaC0j4SZr5T2obV+vlpMUC?=
 =?us-ascii?Q?ivM1+OLBcW2ohxmVpEVh4E73CiUEsQB1Mrsd0usManUlrSLQmDh7nQ5cm446?=
 =?us-ascii?Q?vgC1ew6JzlsbPm6+LEpCHJwVuNvYvmuSMLVm7+8EepLZwW++yvDL5hcgjxPM?=
 =?us-ascii?Q?9tvIklphVGkmdtAaAM4GbXnHZvxcHaBBFQ0FXktyazqefuH+aOFKgrkgS+lY?=
 =?us-ascii?Q?ntCm2i3x8WbeRLOfd9TGvPcQyC/iNd4T4w2/FdqkIIW3QlEqoNfloudWshdc?=
 =?us-ascii?Q?9qzmQeCpjof/J4/YzoQzdxp7eSloiEvBavpZ9esad3m1GrlsKJtDZi+rWE0R?=
 =?us-ascii?Q?1K34l6G6Meu5TrzEvMHwk+K7oQpxjpnXrsFusPLA3cf3gErmDKzMO5DcJKbo?=
 =?us-ascii?Q?hfO1fyFTy0xrtE/DgK4TTX/Kgz7lPpWyP1CHaLQs7j+NDQ+rw2WS/Czb4uPW?=
 =?us-ascii?Q?mSt0rtiSIqOCHHVQwab68ngvvdHr4quKQLvwYu406A0COPIjmxRhLnIzfwRT?=
 =?us-ascii?Q?oSYUng5kCgxwn5DoPn1oaMnUo3cZ0kabGYZ2Tu/vvBcE8tt6LSSU4mdNV6Cj?=
 =?us-ascii?Q?qz0WBt9i7O/OoQtjStwp4nMrPqKc6gRgQPFY1tuRPqXp+r2WXUn4mxu2faI3?=
 =?us-ascii?Q?JX6DmaeoexjQVk9PeyK4ejEoh1kfaJ1R/Q1krIEbrYAeSwzQKhyjeZqicIOI?=
 =?us-ascii?Q?TYJFZ1mCscDlULOBUqMKtTQ7Wge6e/ZxTU3y3cgG/ioJbNmL1Zb2i3Sh/TQX?=
 =?us-ascii?Q?QcZpf03fTgBUb5qu7NRdxvDlCHn4X5WQ5dD9YTc9zZG6ZSWZpsOGmzY7ahEk?=
 =?us-ascii?Q?c/ragw9AoSPRCRuF5R/kfCd4PIv3vZ3fmuS/A5FxSZdfwTiHtSJ8rfCYGmtu?=
 =?us-ascii?Q?4dePR/j7/66R+i8hMC/b48F5mjBhanguoNb8ZNxkbbwvtVAtKPC0ZdOal9K5?=
 =?us-ascii?Q?8xda/aCE0KpdthxytHV4FjgUYGD8Ss44ZmGodnC3nYlFRogFYyV27hIaR7vJ?=
 =?us-ascii?Q?H2uxaYFX0MVthmCokTozHSzTXpGFhkxXXFuwi2k3fPFprIELO2cGAqv/qNAq?=
 =?us-ascii?Q?7A97iwqCdVUk6navg7vjGUPmHRk26KJi3kZwqkJd5U5t68mb3V8z0og1MGYu?=
 =?us-ascii?Q?Q6YTzfLqnJnw53PlMC9WG1QayaZtDmxja+C6uBHClqkXFLcrI5aC4Su/Qxmu?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0629b65-5861-44bd-aad2-08dabebb6c9d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:21.7874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AsRIfVLiCm72fGRQCYzIK5coxHd85Tm5TBplg02Je/7JPnQBoAmyK4lnobBZ+J4dIItk5cc/rvwWkrWP55HPNIefRscPBG3ZxDOq43O2e6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: M86z91dnsEffDZkAob6OwDMBGzkYruAM
X-Proofpoint-GUID: M86z91dnsEffDZkAob6OwDMBGzkYruAM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has get_sectorsize have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sr.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e3171f040fe1..1edc0647a15c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -725,32 +725,29 @@ static int sr_probe(struct device *dev)
 
 static void get_sectorsize(struct scsi_cd *cd)
 {
-	unsigned char cmd[10];
-	unsigned char buffer[8];
-	int the_result, retries = 3;
+	static const u8 cmd[10] = { READ_CAPACITY };
+	unsigned char buffer[8] = { };
+	int the_result;
 	int sector_size;
 	struct request_queue *queue;
+	struct scsi_failure failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
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
-
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

