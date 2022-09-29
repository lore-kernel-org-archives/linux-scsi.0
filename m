Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F0EC04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiI2Cyj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234530AbiI2Cyg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:54:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536EB2BFA
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiSpv020738;
        Thu, 29 Sep 2022 02:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Y2nXRbyZHFIomcFhaehA/yfxymAfJdFssTx2zwAbOnk=;
 b=H8BRxCH5GtxwPHLVjgeKPSJsi9n8hcTUYNpTmX3Du1KGkQNqP1gt/d7H2VwKx+GTCVXn
 XAMmGhldhYvM/Uim43iBpB9h9Zw/7Byc24cicv8O4d87+BvrZjBcNM3d89rQbKfvfZ9E
 6TsIxp27ddF0g2uDlos0WHocEXrMtJaLMQUOyJpCyc2mo/JNX4uN0SG/JU0xL2/hyon7
 SWm+ROeP7idFOjRGEB98RqjN8sKPoboHJ/ZpBJrdyLmP1vv8Ra1kq1wZb5TyFB2pnd0f
 IYszhLzjNcEdtXdSDGSkKi48MOI+SGXPlnrIhXaDFhuxkIJMMsyObZcZq8fUPfSIwBlg Qw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13kgar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SM1cec039455;
        Thu, 29 Sep 2022 02:54:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcqb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQ9sJ4/ozp+upyP3VR10/U+TPsMwCAkcshPrWqlK+buGgdsek2rqQkRNPDqCQlIOuFmTjJ8z1yi4S5u+BZvwn/+njg/bHulDk+H0dbsE2c+/Zl/Wg+YA0ojtp0MCCI5Ac2HLR7tVdJq9Z7NJftcOzr8UGLyDB5XVCb3EHUXWkeqg6A31ewr5jF4XaH4LcX8nTvXjsXafPlzCY1DLLqf0UH9wZcaPN50/QJx7Q5CcqB9PnApRQfQaj2y/5FUKQnhLtHKJOOEnV1P6Kj+ebeosLxuplP4Wp0791n/5pkz0A5yZK4EVCCQDWls4IPKa+urFDcdMWNY4IM++HuNuiu+1Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y2nXRbyZHFIomcFhaehA/yfxymAfJdFssTx2zwAbOnk=;
 b=Gneao15KcSVIIkSAvevUIZkrSLX0VTSuG/oDhDixmZB8XBXTsKBVSNHKzecWI5CuBr+6g1xP4kW4/32vE2v94RJddjfMtN3yGlRr/mCbIuTV4AffuO3V+lM0MeFgSHRROqD5HwBN+w4uStCUTa2ZPaz9pOUI8QJJDJR4C+ho8zmgEbZvnlkNeBHU6Xt056IVToWOjvUX/ar5JwtYogLIKjNGtCkj+ZV3josQIj+zIBl8gtmD6eCC9kkFkMHVBwoTjpFY+XwWNTxXHBegLb0VZVqzfQ4XI51Lbhlp34QxQxrUCTrT6rnKA1eMA+o8oaIt2y8oEYG/g92oCoDrYCn9iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2nXRbyZHFIomcFhaehA/yfxymAfJdFssTx2zwAbOnk=;
 b=XgODTWWaJRyLjEjMRS8xVcrzICe15bTkPF8UTr1cLaOA+ZLHCeg0szmDNMvJMSVrcAUTE3uF3bp/EvitN3fU498Rr/Z61woMOVOOZw9cGrSIK7B2GBbVRGhEAE2FuClo/iI74xOCB8b5nHqMfFSPn5cbsZhXkMLZSE51b15J5mc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 06/35] hwmon: drivetemp: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:38 -0500
Message-Id: <20220929025407.119804-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:610:58::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 69525f7f-bdfd-414d-7e02-08daa1c5e8f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zwnv9h0007KjoBz3kb0cibVd5rkXXjjFEXJflq+TiYrA6wi+jX45XHhsiwlKwoE7roNObyS56ccvtwTJGccDM+dmseBfHkcJ6G8vO+/MX7eGXyYlp1saDigY0axuoZnAg13RY5n5rWEamqeGub/u/wqq4XF9aQhVl31QDAmVZuYWYRdKky6NzmqIC5LYpDmFB8hH9p7lN/mdMyQg0QGAdDTFXfKxmXecLpUXtvDEN6hoelFf+DcKqWyWqFv0XSRIbJS7JPGqW41JjgtARK1zWeCr0ZTRQ1wLzYVBAEqOKmd14Ge/X5BoYfGXGaVf/wXxG6XfLqBGWlhM9maKk4Tw180D/674r/xUx5Q4RtGljSXrbPfeGpjh0hk9Nnv9oaKX1f513KGaSGL276s0fpZplCtCCOX77C01Eq5V0rvxnw84vptgwH+S9LvEfw9vuPnRzS2pHboMUrXMtdtoIDoa43CgpPESeBJYs23UyU4zohOGtyxmXWxjwjs4TWdLzkzKQ+Ogz16MMMSggIJPqw+ZX87xywsc5kHhd8gaUgZYU78bTTwdeoO3vo/c73BgVnHU4n915K6uxFdSpUmiQz2HAg42cX1aLaOK9BA/vJuiAhpzRGqsDJMnhR4GHF3Y8LSIRr3TJqIQVygSyO+kvP9r1Jb6YyiKV7OVup5/kyf7OJg2ywECD44nPKbKrtAq1OXqQYlGWxtychu9QDebKuer+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(4744005)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NK8Pko6zsfOJb4YEbfSNU5msy5xQJl2+AL63fXm+D9hXn4xBUcpFpWQHPpO+?=
 =?us-ascii?Q?MYoF7mvPEgSddVEHGLMpnUxUBEwpROwrj2/V+oFDuBlcaI8kXJJ2S/HisbnP?=
 =?us-ascii?Q?7a/k+53C59VdB9GItpq3b7RtXxCK1juKuUmnmAXMzQXWyB9S576eBZZ79xW6?=
 =?us-ascii?Q?i+TlvAIQVaeTXsEO3ILniy+X5UfkTFtVbLSN1ucA+w0+ZjXM07dGAqUg+enp?=
 =?us-ascii?Q?X+wdEmLBs56MnlWcpphJ+Uzdv2wfHwnrUmPagAKHLnoptlPUDb1kiuhrN87j?=
 =?us-ascii?Q?3BYKQ+fnU9CxTVFugsQQaKV5EWVFxIgPPZAoB2ixlZitZaSkX6hQMLC/E7lg?=
 =?us-ascii?Q?/2mbmn6DTB9qNa/nn/5Du7DiB7DfVm1UJT13xlC6YsJsfjsZYwSBZ5q3/nQ0?=
 =?us-ascii?Q?cz0vtd5/MY1Tmn0c2iklLZHFdYW+SWzmdNAuqaLjiFkk+Ai5KjK9FhY1oPEA?=
 =?us-ascii?Q?nJWmrNG7uWCbyn3d0DYJM9jHQyA7JbN/e5omKI6p2d1MHvLf12ptAwWA5Rvv?=
 =?us-ascii?Q?hV3QY+01Dw6k2U5eFRwdIUZ3VSXHT2I+RRDIf2+zZL91oPjO/e7D2uLs8MrF?=
 =?us-ascii?Q?noi9cqRlMMhzj2voenl8c27CmhFwox1D31RPOoNTm0bTvTLg7iEDoePYVHbL?=
 =?us-ascii?Q?OX/TOM/SWHsmZisN/+P8VwXeXE8XcyDzFli8Nhsdbu1rrT09E5D/V60xUWX5?=
 =?us-ascii?Q?mP8UAw+TgIT6Rzeo7Bs6z2+JFCZJFDPpgnuPJzaK2oeBrMlIjWpAgdrUku8j?=
 =?us-ascii?Q?jJbf/rUlL6rJFWfrEVw5SQjHwA+Jn0cUk2zkrrvbv/nfuzuVzh/UO61QzW6U?=
 =?us-ascii?Q?GurBTHDimRTC7s/Sb4lKb0wfrCuDUAyQHv/AO+g+3vX84I3d6ThrfdZE/fCO?=
 =?us-ascii?Q?xAkB8eLAvonQZi/7keik31uzmV7sAysupUP+1HrLVps6S63zpDO9p8WsnwM4?=
 =?us-ascii?Q?ekzPrUJtIRtSEZgcmX710OsXOPTo/nQKqgTTfQbE8LvFlmqBbO9jm8YpUEVi?=
 =?us-ascii?Q?kT5461jWTvHJC946HnN9/j/6elE9LMYbkKITlRbVWb6HC0oIy1YYDt1voYO/?=
 =?us-ascii?Q?OyQoFibFWU3MC5wlBYFFo1LUCtxeOWtjHmG2yNpIklf5t74B4PRn1/FIURsw?=
 =?us-ascii?Q?6Ug0cf/fVWncOyE+DIXV17+qvPzMbkocQxupbTxnIcPhgTLQwo90EFCHOGfp?=
 =?us-ascii?Q?IiIkByPaCWyDrIKQS94ZFLCE2VkLXVb01pO7X2tjQgW+3Hwrtqo8WJEvI8L6?=
 =?us-ascii?Q?gj6mmkYA+ecA+uIETdpvtbnXAp0J88PS7H9Fhms897JrjNzxId3vYGYomUQ4?=
 =?us-ascii?Q?avWbtiWPzsjPh54OJbBgLhEY6pr2blYm+G5sDgs2+Lex1jlScsFbLCLgu7Si?=
 =?us-ascii?Q?NNc2OsuwE3aVBoQZWrV29XU0zj4zqukqhwKm9x47xT2iAP1wWOBjXkGl/SZe?=
 =?us-ascii?Q?FpFHUKsDxgwVyc9eHtROwFvIoPhetZLIOXdNZFoZEDDL0kizKFNcQaCjqakh?=
 =?us-ascii?Q?J7wS/stC+HMhHupa+HWyiUzkMpM2KRUsQWbSxh+TJfDXpWhZE+I2KzT0bl2O?=
 =?us-ascii?Q?yv5tM7f+JFSVPw3KJQltEL9YMuE1pXcb5hEBBYMLZqjC3kcr6bmk9T+PVRRG?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69525f7f-bdfd-414d-7e02-08daa1c5e8f5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:21.8034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XYi3+efpJ2l4t9qSBGSoJDpdw5VF+0eEqBi2+/mLFp0C00oXciqEo1Hi87JO+AZ0EykPRcJqCsvdI6mEJ9vOxdDKTzvZK7pt8qNeJodjP8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: h1cUpdjSleyL5iwC_vbRBvBOsuWAqEXu
X-Proofpoint-GUID: h1cUpdjSleyL5iwC_vbRBvBOsuWAqEXu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/hwmon/drivetemp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb..ec208cac9c7f 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -192,9 +192,14 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 	scsi_cmd[12] = lba_high;
 	scsi_cmd[14] = ata_command;
 
-	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
-				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = st->sdev,
+					.cmd = scsi_cmd,
+					.data_dir = data_dir,
+					.buf = st->smartdata,
+					.buf_len = ATA_SECT_SIZE,
+					.timeout = HZ,
+					.retries = 5 }));
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.25.1

