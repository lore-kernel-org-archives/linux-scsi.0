Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5ADC3DA7D
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbiL2TEi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiL2TE3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:04:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D771408A
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:04:28 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIx6Rk012472;
        Thu, 29 Dec 2022 19:02:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=REIguuBRZqH0yEqM5RkwJAsUBscBGAoRYxxKBR1+QEw=;
 b=Lk1Gs9TBQv6njWsDD9yrTj69p5j/mz+Arb0+t1SD+xctMvyTIRFqAmBrkfEg6qkfWjQg
 /OuzH6xSgs81UOicw22ulnDO/Q+pW4cIXvQzone053xRA1dlM7aT8LJTuCTJaI4W4h5d
 2q+lSOIWpgT1XL/b01gbdo9dUu41S07ThsD19AS81hmIoyGq0aPIb404Aa+VVpsKDlNn
 MG4Puxi8j1mQBQ99EGFGoIgI9xHGilZwU5A+WXCIbzD8Ij7qzdiHXc+YD5EWsWILjk2L
 gBOpDOFnZG0hcgeT9Zf0Me54gnCOipkkqASrpRx73dhP4x5VxzGNYA2TSNrex8rIgM4N iA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnsyt76kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTHZJ3Q018981;
        Thu, 29 Dec 2022 19:02:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqve10ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxUG1Qt4sDiaQ8ohM2WFlLaYmVaHMQAO9IDerzURFpoDxDMJXIkZ2SFFeXPXLBtrszuEKOIABuXYSZXBcHeEJvVTCVX8aeRP03PV/Y5LDDFzhBSJOi7R/FDmzUPlcvFwECnYmmGu7SEsbP6Oxz0BHU58hPECtd+ZDDpu3wjEpLZkhy2HFozxlC9tD4NYEe1BJxzGHk2DDlcmjgqjhM/2sxQlFZCqwElLPb41iZzmy2nI+5YQ3VaeSEmB+LyLOcAe4jJIABV9OFx6F8IWsNUB/QcAAZAlEVNhANa9Z/YkgWJaXkSoDhf9cJm4uZJjb0Qg6w75wr8lj/VbWYcm5orJqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=REIguuBRZqH0yEqM5RkwJAsUBscBGAoRYxxKBR1+QEw=;
 b=WqQUUu0EF1e4IGgqewxRR5U6Ej+4704251ITA53Eu9xJn2Udg4MwYrIC5mAqgOwQ1578CDyZhN7IUu5S9xAcxjwmUkIZtNI1zSorGodJOKArZf9MnXqTVZKNqCAPQNBdeVheaYWgSnofIPPomelpDIT2HB6wmtovxpZc5SKg7Xgim1XqdbBBsBD72/bPP3x/qL8jyUDIBZh5piwt8vliDFG7blN1llZ2sPtc8S5LifF9pUBCU14v5B8UN6DupjHJhtwV7WUh3HtXBfTBRdptKKTiMHrXYuCEADCv4E1a7uXYa8a/2P3Sg5iE1bCg+nL1DPL0MI6Fw2Vj/qop9MV9Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REIguuBRZqH0yEqM5RkwJAsUBscBGAoRYxxKBR1+QEw=;
 b=CbzK8nPz/7XTTVOa27MmvOrJPylXPQbyxoFnggVkzuk3JM6WUbUpfVsZRhV0jVXIkJ1CFa9YDfJ7al9UJ8uI6X58+4aDW40sNRBV+ovjTd3CuDzXJhAqVEVr6FupccplZJkshVMnuOagSteLmDt4tpZxOf5wwODYHNgldAedu10=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 12/15] scsi: virtio_scsi: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:51 -0600
Message-Id: <20221229190154.7467-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0016.namprd20.prod.outlook.com
 (2603:10b6:610:58::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 595e8edf-2a34-4cda-90db-08dae9cf3421
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nFUHFEC4gSjZjd3nTXSy03jFjtkfpp93an1EKO64Zxa4jgoOCU1Bu5W87X89S87Fl8j+FzwN2HoZyfo6qmxZ6AWpifM3zbUVLOWxP/BRr31IRtcOz8U1OZzcT3VXg3vEaJAByrXtunO2WNvYkrLPEj4YK8QJGTwRW9+5NNiVrgmTCeQ/UUWhZU41ldE8ODs2xLQYW42SjA4i1/VEVKw26IAiCikorB/Z0XRS2Y8GHBhCWQmOEjOvr6o9dcOi3tS63SWhJb8mryN2DE9Paod+LnZljKRsO9hWO7UFWOIJFSYxo9CLyRz04SQOh+a5vdT0f9Z3JpQ6FgDaL925loY6mUT8B9ybSwZgVS8kGtD4c8fjRzrcfyfjdsE5+biOgoERlocLNsrqtk3Kbt9+DlwZ+8AUoLM2didIZiXKhc5C40RpxmCq8tDroXsF5zBONK4K4DVGMmvzqxmiPlerpgLciris9Eb0zcpkut8LbvzkOwpsV5tQSvwtj/pEtqkRmm9+kOJyYsYDzgsN6ZKPklOFhi4gR+rxX+D62dTAioDPYNwrk+Lw6PDXn953xQNhgcDiTBH6NNLLdTWwVEk1Iu6uvEZ2fks4Y0LoEwRf7/hsv2yX//v9gDQG0OVD3PZElhnismCGXbcyNGxRYppYPaeflg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(4744005)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cmdUbQcw79WiDSk60ADEJW3NBSX3GqZWJNZBad4Hi1Dim/Kttkw8FogyDGIb?=
 =?us-ascii?Q?USWG1RTAuyJF0whUfZAfg23/DsBe/ei4C1CmKbBYAnogVshVCiGmy76r2epS?=
 =?us-ascii?Q?sQzrJdWNGeAEWoOMTSlP5JKV/K6yQ2/ZVQlIyt+WlY1E7aq3w6L+qN0irhEn?=
 =?us-ascii?Q?iwk+lFNLW2egh+gKhDjm2t1Bk1MAj5f6eApfPer8XOEvHvAdmXlVYdZkad1t?=
 =?us-ascii?Q?XS4b3YxljjU7IFngTe2px15L35foZUmaaND46xM2AhV9+PeqELftYAs08L1/?=
 =?us-ascii?Q?rc9rANsU52kyfKhL7vaobdxcsP6hzUUFfbjBFeHtOhHnJIrYjab8ikkl5r4A?=
 =?us-ascii?Q?8sQCMwZXW9MfXTXYpyjHzQI/TGagiPOHauFs4JO1TGfY/63uN1xm4POwc6wY?=
 =?us-ascii?Q?ixxY8kT7Cxi4PoSZmCCev1XlYChTxtLGgyWzAZfq02mSRGiOl++Rba5dexp4?=
 =?us-ascii?Q?zBQDgsT9AJ/c60HHABUVyNp8oebgYRa3Jwj7eoL/Uu5qHIxCHvQl2kgOYTsI?=
 =?us-ascii?Q?40hAujo7DkMbuqmcZkSym1BX8YO2kYU+9do/WuXWSWq9QXJE2VmYIB8GzNFW?=
 =?us-ascii?Q?NdC2SwNNWIU3fkx9OGlBQpvRvZgVOwA7DnuqpE453frkmukd1VSw8kEX4okh?=
 =?us-ascii?Q?zi4v2mZVGnsqOWCFgZmTR6VTk8WmEftWynDNLxAIbS7+ipkEcQf/JzR/yjnE?=
 =?us-ascii?Q?JnECdG1lKitkApB7FoTVhvhA/z3ZZjucbfnt4FGS383m3QjrJXjHWfR7U2uB?=
 =?us-ascii?Q?326RPzVtmUMNoQi2tE+5bXTdQeHtOwr6TioZ203hi+LCFw37VuVSRkiYxv+v?=
 =?us-ascii?Q?5Mc+6tYPO27j5yn+ghNtBJzc/1tiUMe2shE0mAFgODGQseCkM1s/BB8GI1oD?=
 =?us-ascii?Q?r6NdE3JF4YET9mdZvuzWRYu4NZZ6UQQrmYNJXEHE303aSPAtV3yFdr5NYj1g?=
 =?us-ascii?Q?shsESzb72NnPAMI64e+G+DfeYsYvkPb7CqQVtYqVQdJ89EzEuy7jUB8JWR7I?=
 =?us-ascii?Q?4jVq9VGVrHhC2NUwR6BezCaqyC8vRBmS39ZWNsyxd7z7xB1NrO9Kx22iBVWC?=
 =?us-ascii?Q?Mct5AF1VBGvviPmV1JdwIzaQx9vXNphXD4SASEr3fOaEIEjvhq07CNylpKL/?=
 =?us-ascii?Q?YIf1TZNZPlN3ALWJgKciX88QafTnv+v13xqdenyT/yl4oUa/FzolIbGE1478?=
 =?us-ascii?Q?y6YWqQWWN0o9YGyCylDdJSZxe10fxJvROKQuqCnWBGcyhV4qvs7d8aqhz54F?=
 =?us-ascii?Q?1k3VHH5WMdorNa7Zg+u498eo3xm3sQ8jo0vjot3pvXHrPYjaDayQbklTZze+?=
 =?us-ascii?Q?/7LPYq3fzsko72RrKQcn95k3FkwlKYmXEX+aAtmeVhDpnFsVOa1cMgs0yOXG?=
 =?us-ascii?Q?xTPvLwCXajfI/hE7dbiU202zVhN0ozfFSq+q+6pWSKu0xDIWaeE6KK5onkRR?=
 =?us-ascii?Q?Kvz0s8hvG2qL/P++6FxsfTJUF6uhg6dh2SpLsOpUHrNFftdIeF1C8IfD3ebn?=
 =?us-ascii?Q?47S1kFc91/hzfIEvHg9ceCtAECmfGQNq2hN9SQIv6/DIqSuVvfvdZmzcBM0U?=
 =?us-ascii?Q?aQa5yYh4RG6FGE32rfl/GREOP/xHUmfCudnLLnCP4ORVPmVKwZVHAiiRwios?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 595e8edf-2a34-4cda-90db-08dae9cf3421
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:16.9713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CY1PLeicX+xjTzl8iPfuo3y2Q6VnXu7NgXDVByb3feeAmNWVjLk3KaGJt42DVoBAuETSqJJv+0gNdkDlNTsYS6z+eR+GhsccX7tG4aeIhlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290157
X-Proofpoint-GUID: zvzXI-3KJoQLtvKlz2eAh3VCyhJwd7K3
X-Proofpoint-ORIG-GUID: zvzXI-3KJoQLtvKlz2eAh3VCyhJwd7K3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert virtio_scsi to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index d07d24c06b54..b221c3c99320 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -347,8 +347,8 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		memset(inq_result, 0, inq_result_len);
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, inquiry_len, NULL,
+		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
+					  inq_result, inquiry_len,
 					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
 
 		if (result == 0 && inq_result[0] >> 5) {
-- 
2.25.1

