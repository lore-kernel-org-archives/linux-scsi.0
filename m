Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F232C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 17:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350100AbiAaRQU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:16:20 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24120 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349672AbiAaRQT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 12:16:19 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VFwpHW006220;
        Mon, 31 Jan 2022 17:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=vzkRUYOCH31Ew19FbVreNoHq17aNh0j6yyjzLTt2Zrg=;
 b=RmXDRqFINHrk25gWOh3oDC1I8dk7jp5ST7tKt7k70FLrLTBR0PvY5994aht3GYzfEPgR
 A9Jcgbcupx9KUw7H1illK+bKDFW8GdVpkR9JHZp1w0nKA91BUzDeCUAEaKGtN5sTOcJv
 rlqGCieMnti//ln4ZTHjsLJmXup7/D4qFTZMkRjY5/V6c2gAlOHSh0M/qOu4bzgGnJhB
 eyzghFou6j06BbfSEPLaNnjsYQN9+kWf9Nog0lAo83qH+7Sz4GyJxF0CEt53ha5J/AKG
 jkT27GWpD5VZcXYOATrpaRbWtIPHofBgLa2WKisfITuE2LxICQlo8SNJX8mdjXcHeS7V ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9w8cuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 17:16:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VHFcOi192674;
        Mon, 31 Jan 2022 17:16:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by aserp3030.oracle.com with ESMTP id 3dvumdw5va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 17:16:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1tOc7buXpZJy2ZxYEPibKg/3bKn7PhyOfP4n8okEQt/twe5NJJFQcSuBiX12loDA+j/q/A9C52ypCN5xVteSZhsOJrjX1tumSDoSrJj25ODv+aBYas0TltlPwW4Bq4zOysel8r1bOl17nAHOWPxiO98f4vusobhrWfnx/fjII+UF2R4/qJz3XiL6m/vvaLBQ0SPqd9EP1rUaGf4IFFiJ53aYmQS6fHjVAMksxUsTt1RHPNX3YO0dOyjIahkhbGpydk7FCX9qf4dpMdANxO02TCwileJCSn2WGPAStFJL4YG2lZzrWDtEcl7pWdW1ao7cN2lKV3XEeWQENpMQJdzpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzkRUYOCH31Ew19FbVreNoHq17aNh0j6yyjzLTt2Zrg=;
 b=WVr6KEonqJbNb3JOjdpFa3SOERYrEqb9W2FqDcybOgPLvaI0UE+R+KNGMTikRrTIL94eVxCE/XQZ/GBFOY0paCY/dUMKR2AFplIpZ1gIf6kCYl45FYp3vOu/CHx+XgA2wrsecSd2Ha6YP09ITrhphKfQdKx5FwAyMaD9v7Ynj+4bjIsXjeGEy/5yQ96A3sjaPthshnW7b6L8HfvucJyqMAZjO87/5ksP1BCtdYETPZU1sOesKfU+KfUTryXMo1Fxi/9quIeaWbmiSw258NLmOgxsSqR0EmDXiuPi1LzKTkgQuGLQ9gjWfW/8AmP4N3iRx2rv3ycy5L2DaEP4JsNCaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzkRUYOCH31Ew19FbVreNoHq17aNh0j6yyjzLTt2Zrg=;
 b=oGU5YJ5keHJJ/sMt2c0C/RVLvTbTqjGCr/viacnG+nbNNp2ryn/QicuPHIzzOOjCFKeJuWEp9TXvaLhgY1bqkW5tYUc/2j2TBvgEuwryr54ApgK9IUS9r3XkSXTU7phTzj/lYCRTnfTGS0N+o3efMiv+MZbNzyrxatlFNLX3+LI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN8PR10MB3681.namprd10.prod.outlook.com (2603:10b6:408:bd::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 17:16:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3%9]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 17:16:12 +0000
To:     Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix double completion for SATA devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1iltzbzcn.fsf@ca-mkp.ca.oracle.com>
References: <20220124082255.86223-1-Ajish.Koshy@microchip.com>
Date:   Mon, 31 Jan 2022 12:16:09 -0500
In-Reply-To: <20220124082255.86223-1-Ajish.Koshy@microchip.com> (Ajish Koshy's
        message of "Mon, 24 Jan 2022 13:52:55 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea7fa1bd-e307-456d-5057-08d9e4dd6120
X-MS-TrafficTypeDiagnostic: BN8PR10MB3681:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB36818F64984B0C275835FB858E259@BN8PR10MB3681.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nv8q4x8vpwV4dtefReOaRTMnjdkGWvxdZ6z9YK/s5eIIs23T/Zszeb0YYqTOylS2n60k6dWxplt0ichPqqZHmPYDEwcKqhmaklIOZI0o5mOdvTIVLVRyDADpB4FwLcMbOhV8XN8/KONrJyN9xMGNqRMgG0ax+rvJT4J49eWSayoRN0T/RKADWF/LROCRa89txEkgp/Eci9lqbXcZEtrsFIXl+fs3BnSyCvfeGDvM3b10k/0mGhLQzE6mjXpm6V7aG1ezvHW7bNj/23MqzvxlW1UwqELdEAPV0l8vsCKdJrYTin2VlMKQBvkMwkf4GQyuWHqoBRNaTlUI88I5RDVv6zysVgNNuI0afD7GkU0BzqEC/wWtCzQfY3YXXEXryt6GpOTVyE1tPiQ/7D+BsPf71XchuEoM4EsJQmwr08oxoqfVaMPvIrxU1TK1KJgBKMzloyMK1ljmzsanvMapPvLbQdYsse8L4ze3uukX7xJaoUYtPU7iheY+/AJDmm5ht60f3NbatEp+bUqQgHij8bDlBFtPMMVTToE6ove5sK4riLKz0pL1/5AJZOwHVLM8CTrqukIJtSEbdK/sJFcM4QZakFrXDMVTbmL84OA9KY4bZ7jCVXOtF4e27/l+3klQIR0ovqtZdpaAB24fT2VyjXCl4O3taIZ9J77CJoH6VNgP/pm+yZUMjE/a57O5pAILGz2RfwCiAyeRNQnzt3QvV6rM6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8936002)(6916009)(26005)(8676002)(508600001)(6486002)(54906003)(86362001)(558084003)(186003)(66476007)(66946007)(66556008)(5660300002)(38350700002)(38100700002)(6506007)(6512007)(52116002)(36916002)(316002)(6666004)(2906002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uGEQLU655m/6KRhLJm91lib0qZvtv/XkP1bIwufKo2ULef5WqD2hAD0vV4a+?=
 =?us-ascii?Q?pFggUKFyvyFelNQlEZ+3DCxDV9qlWzqxdTER+jWLRxxOvQRuX490yPWmDRME?=
 =?us-ascii?Q?QUS2Q9tSiPFfGPdW6xpI+9vcB++nm1sWBbPa6kuQ0fiNaohfltMapNVbgkvo?=
 =?us-ascii?Q?L2tDnxI0aW4zTrk8C5FhFB+XVmf/5UBHAajx3qYunmjeTbayUuKGf+W8X+Vf?=
 =?us-ascii?Q?YEsPjjWV563viwBM9iE7PSJ/QVUXjNLM8c8q0ONARLYJNcFuwYug3HhXkD/Q?=
 =?us-ascii?Q?Si6nsGmhEuto9gcrZ4xFAeIAxNj4e1q6ZX0BPz9peBwg6ou0r8HIly/T00VV?=
 =?us-ascii?Q?B6N/GLm42NBIpA7RQKCnuiXTmnagALOVG7RKB6m2S2VFZqpbt4BR0R8zribf?=
 =?us-ascii?Q?bGu6XTsgv8ftW4fsCiR+OHeceUrdV3WeUYU/KuenkJRS2u1bZqsFlD2FZ6rK?=
 =?us-ascii?Q?q/MVvolgCU7QRtVsg5L0/9o7c6KkEuXTON4nxlKNuWSl0x2/6ehEWfkVkeOe?=
 =?us-ascii?Q?tUWvSW6h+6lz4/37QjY407VOYU1d58HvWCkCAq9mmsfC/JuMOOlTETH74ZRB?=
 =?us-ascii?Q?Nain8z5NGPWeJN3IyregFMdZZ3fOGQVAraxZq3fOol6H+qvd41dnNpV7ygtz?=
 =?us-ascii?Q?4iK66U1NnPW11syaFUD3B9AyXGBv9TCCxWTfjm2bDw12oowZqsCkQMlCphQu?=
 =?us-ascii?Q?fLSzCrE9qyuG4ivT5gF3j832wBdrma317vCohhKsd2K35XCBwMtKCBATFTHC?=
 =?us-ascii?Q?SAezfUQc8BbaTknInMHOpLtIIi/pNAnBHQHvM4XNd/EBuan+as3vgPG8Nund?=
 =?us-ascii?Q?imSyIYTsVYwsuTK1zAeJTLOTEoVlqAXTeJiJR8Q6j7a8VBmMZipRlj8M+5Xa?=
 =?us-ascii?Q?yYvaRa1H+pAhkP+Bk/NUyVSiQEVb/DvwiXoIonCvRXGoY9L1qS+UUG/YWJrj?=
 =?us-ascii?Q?WLwOOey09brBtrlDCq9ZFogibV9g0Wi2l0TvrnQlV0HK3v9ob0ZFkhcxaLnr?=
 =?us-ascii?Q?Vh79BDJJvPw6EaFkJiea22+GZ9uZikex4Pl9caBubyCdP0Zfghq/nZQ68w5G?=
 =?us-ascii?Q?vIv1euk4SpN1PAF2Xvwu+UGG/FxObWzCZ0HKwdugExPViSy4jbG8YdfVBOxd?=
 =?us-ascii?Q?lZmUtY42kuFSk57c0N9QGg0rvyLxoyZcY6h3oJhFrUpG2YJw0766TsT4bJth?=
 =?us-ascii?Q?0SX+OPYFgGWfYAJI798LuVN9q1o4+o6KW66jodP29NKavzvv4yCtjWKbcEMw?=
 =?us-ascii?Q?aNG8RUxrPjVmBYjzoSpj8hUqVo2vQ2Yte3ii/yyj5efZqmnZsWesJVIxqKty?=
 =?us-ascii?Q?79qx2wbNHduijFXXSHz6gglsoNerr6gKjY64vBAfOuu5/PEhSQKkq96e8EMf?=
 =?us-ascii?Q?5cOXKYtXyHz6VdTIuRHusMCzFfz3bfbvZCgYrW0Bp7iB/nfE+ofPPwthIXPo?=
 =?us-ascii?Q?gHSsiXNZVk1BSbyFJtkEOqpHpZrO+GMNgZLwjfkhDrv0tT87mBCAzST1FbaF?=
 =?us-ascii?Q?VdqqGyLTRQ/4YrFC9kryugsljgq4GyBpwNOFlAZVoqVv9KQn95dtD2wSnwG3?=
 =?us-ascii?Q?BdreWAJBfGnmtXxYdMCJgE8ak+Jr8kfizI2NPexxYuMV3ro9/bq1TFUO+XIe?=
 =?us-ascii?Q?R6y6il6GtccJePTVvdnjZ7IHV8vsKx3memXFFKTD5mNxFTzNdZVmzUQmqApe?=
 =?us-ascii?Q?KuOH0g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7fa1bd-e307-456d-5057-08d9e4dd6120
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 17:16:11.9767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K9zeG2U5aIB7e1EBaJRBEBLCP7pfO/x2Xff1r/JURpOOOgaT/vCJ5o+GE3DWy2fL+B9RbHVxkWkYS1NpVz6VgSWazbpDLGEPljU+onQz7Lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3681
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=836 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310113
X-Proofpoint-ORIG-GUID: tqnV3ccU5i7I_oEYkj9ZHfDyP-nKfv7y
X-Proofpoint-GUID: tqnV3ccU5i7I_oEYkj9ZHfDyP-nKfv7y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ajish,

> For SATA devices, correct the double completion issue.

Applied to 5.17/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
