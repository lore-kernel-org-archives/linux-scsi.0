Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8566DC54E76
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Jan 2023 02:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjAECWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Jan 2023 21:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjAECWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2023 21:22:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC524435C;
        Wed,  4 Jan 2023 18:22:07 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304MEP5W018510;
        Thu, 5 Jan 2023 02:21:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=g6TG/4G2hQxg9uxS7qw7xjY+BmMhqQNZJ7Svj3xBOCo=;
 b=y/yhFSDK4eTxVWMZ2WoaIEjrL/0k5txa4sMAoQtLhmnNdusy4jQMD7AGzqz7f1hHiWHF
 VdwnQflDd6Gs6Eu/hkoP7O/Cgrqvgn9AdyFH04kvTa+NRazUP8HXaGo9scL3H9B03te9
 XqtfQ1TOe1KN1O2AiBUuH9WRTyX690SccpUCCuAygIW8mz6dfxeChit3TKwMmZJbn5JW
 nYWgXJFBcjjjieskZ7zgNyMtuPMJtuHGS41/6QRwu7TziO5oY9RJzCuUkMdC/MdO66+5
 Viqp0FjvPqPdpTm6c8V/xrDQi3+CywTAxbPAG1A79/oHtRLRAUARJb+ZGQxHO/21nh2C Rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtbp0yyfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Jan 2023 02:21:46 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3051MT9G031238;
        Thu, 5 Jan 2023 02:21:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mwg37a1r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Jan 2023 02:21:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPvVL04XTdM4xhb8xCU+MrJLJ4akKGBOz2LD4Uuu52V59Tq5j0lCHi3jFPaBZWR2z8/VbVNw8sydxl18aStCA6IJK9gql1kFZD9dRWRQ6q5fHXmMIfcDYlgzuyzLKDIoZQIx+5+JEnIh8qY0EMR1orEs/T5IThUZpYMaq0l4Mp8+sI6rRAlNkKfuDozYEdobVzLE1CWaVj8BTsN/j2gLkvfQ1yswlelbpMYTSpV4ZgglAChYOO2MEF0XA/3pB38WT2nq7dTFfuZo5FS6jXZtQIkblI89iWLHRXxxPC9mqDBYzHqpxYnku8gIxU9O+xt+5cx8qTXGcTfGBOcq6hFbYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6TG/4G2hQxg9uxS7qw7xjY+BmMhqQNZJ7Svj3xBOCo=;
 b=CLxoBliY5FQLR4n8MfP/HLtgmEYjTWCgFuZbTDSohy9z5egs7Rcp4vECbOq4U7PG4ACD8dwIlgCq9249EHRoddWdIjmMWXYVh34L3/qN0FP0F2yrJFmkQZpQOcQ8xvJg4NZoz4DZ5vTUrfAG8elEQZt59cu867cN6C2SpHF+yt0clFq0DOng4s+w5+XZi8npMIUMawQqvKVYy6+O3vDbWh0mgWDWewz0YQjrHysKVU1C1HNHPGzB5MpddPcoqJOxn3XJ/HPPmFtx+Mlp61gd1KwN0FUIMpq36cWBQ7nWkJKKnvoA8ixC1RRTpm8BC6Dcul9AGafAzxRhuKVNOrsbtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6TG/4G2hQxg9uxS7qw7xjY+BmMhqQNZJ7Svj3xBOCo=;
 b=WsyKdPX1t9lhdjdlSj05/uAySqe3neJX/gzPVnKixAngOi3a2A/+f+F/4eF41VCzkpkJlpYhvqYbpIIsV/dBkNF5ET4hd0RNUUGcMXs0EsOHRa6ZO+ycjRJzZinZgHAFu2AUL14du7VMeZ+iiLui7l5B2hjPzqj41uPeTmRsM2o=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB6543.namprd10.prod.outlook.com (2603:10b6:806:2bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 02:21:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22%2]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 02:21:39 +0000
To:     Zhe Wang <zhe.wang1@unisoc.com>
Cc:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <robh+dt@kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <orsonzhai@gmail.com>, <yuelin.tang@unisoc.com>,
        <zhenxiong.lai@unisoc.com>, <zhang.lyra@gmail.com>,
        <zhewang116@gmail.com>
Subject: Re: [PATCH v4 0/2] Add support for Unisoc UFS host controller
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wn61202j.fsf@ca-mkp.ca.oracle.com>
References: <20221209124121.20306-1-zhe.wang1@unisoc.com>
Date:   Wed, 04 Jan 2023 21:21:36 -0500
In-Reply-To: <20221209124121.20306-1-zhe.wang1@unisoc.com> (Zhe Wang's message
        of "Fri, 9 Dec 2022 20:41:19 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0038.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 36dbd1ff-4f47-4395-5b35-08daeec3938f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9DCwF0RDMmCQCLlK9bq5kTiGNT7URN4ETCwa4s5iufV6O7UHnGhhCmDndk6JzioHJ6fFirWV7+0xKH+RrSI+7eg9/Fu4pLnHTflPxDByo2mfHtpa89N3XKFVOb/QCXjT0d+xDddIFpiCNRNNYGrcrOXYjM3FKNT0cYABICt8sAnq9+eqtH+jztKPzcJF1RPCJ/D99GB1tP5kT4Tj87Seb0fS+wbTzJVRjo+zdpO8xBF4gHF7vdbe26Yi7Y0rTjz0pkFJb+K8rs3ScznPfJ7GsADpkUhED/cAX214dH7aGMoTWJr2S2Ar0YFWQovxsruXXNYiy0GV7W9D3dDjn8vM4U70VRI9l/F241tCRoBPL/h6zPUM1Bt22y3x0bwzmO53LW0firLm4L9AavbpmIXRgOviIhQqqEKXRPmKzXSQ3dLPlobotbm85K5xG0WiNJRGhG9REofgZX7Qwdb11vWcAEArldme9co3eiEWTRKaBynBvT8kjfhpas872yRNNM8Hqo3u2Bc06Qqo2RsFRA/XQJqf6Spc/fQ6vRFEnS+DFdaOng+YE3JXRHshWS41jhwXXfFqkxf3RC9U3GuqG2MWt5oRYFM+MwzIYCa9HrPBjERJtFLs0b4SQesrcniowo9me842tnnVIwM520SCeCEQ6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(346002)(39860400002)(451199015)(558084003)(8936002)(38100700002)(41300700001)(5660300002)(2906002)(7416002)(86362001)(54906003)(6916009)(66946007)(6486002)(36916002)(6666004)(6506007)(4326008)(66556008)(66476007)(478600001)(6512007)(186003)(316002)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qwN3byEFKzwXF0CoSFylDzk5KQyWwXE/I3nPoWd93ErEx02FW87BUG4gwuD+?=
 =?us-ascii?Q?WOJEpcD3Q7kqBIiCz4S4adCJcbQ8bHKlQ7y4dxv9JACse7jQfhnYqs+pWehs?=
 =?us-ascii?Q?SZ515dut7xI0W8Z82ujpEgqnJdgdAWMIYEmt8k7kFNWeq9xTddzWTNEmn+Xp?=
 =?us-ascii?Q?RzfDKxK6/w6kdJ6QI7PQezkSWFXww48mvaaPEX4XEu1kPTJRDfqc9pXXwlp8?=
 =?us-ascii?Q?L7VJsakHricISKRDH/8srpE5M0icTkISHz6zD7E3OHYrlVQTPXS3edWPBj8n?=
 =?us-ascii?Q?iCOIxLLZf6FO9RzuX3VCfUTanVol7FfT92sD/j2He8705XRMqSO/qAr3O2z1?=
 =?us-ascii?Q?4icGiDiG/dHFx/vWnMhY1B4k5x3eh2H5MqwH+VH/WB5jsnZmpWsWV2/UVeF/?=
 =?us-ascii?Q?ro7PFFzzmue2ShEoTLZRaL4DQCCjOrscjBa/kZ3OrbcekNPViFt9CRg8TveT?=
 =?us-ascii?Q?q1t5QOSKwD8toVlyEhhNszZTPEhj9MdsWMgU8NPAyZGZwhFR6w5L6jvYSziu?=
 =?us-ascii?Q?FqS5QCIFVxSSYugnJ0y7pWws5jvoUVRnqxeI6Sgpgn7abj/JH+Mu+VW+6Sq2?=
 =?us-ascii?Q?qKHOjg3B11mo1bi/c8usFlMJvyNtkut67rfoc+Mt10Y+QbsqQSJ6GsuEMYP1?=
 =?us-ascii?Q?OlIvRyKfHdh1VSDCaOTShwLr9vloSfRVzim/toDNT6KcVxiESs/PSbGtmEmz?=
 =?us-ascii?Q?Bl7pIijB1Knutz/25Oj09+x33oi1ZXzTRGVDk/8LHqHPY/wuhmTAEslDwwMk?=
 =?us-ascii?Q?9ByXWXIeikBZHhlF+EPM2yXhZmgqIPmI1XKpRmsVd1puQjcajBO1TBvMcyb5?=
 =?us-ascii?Q?oU4eFM/Y8N6q+8DdYzkfLjBS5oaV5QBvwl4BHadv2GFQWDnq9splsJ9nUrmT?=
 =?us-ascii?Q?SBz4DGJ/I9m8xoUatdMTBJEeRH2Sw9SOvICi9TbJXmZOvyGbNTaGeYKJkPj5?=
 =?us-ascii?Q?ykLEK5LVJLjB0nNf/ppt81y7VGxue0/esVVUe8Is2PTvBOmFv//HAMZiXnNe?=
 =?us-ascii?Q?fM6iOKV9lB0B3KSYKFOdUulDTcMZ1IqiWx7aOkSA3wRMfoMgGl1NFYod8K/6?=
 =?us-ascii?Q?0QiSlM5HsVnzmfu+hw73AG8zc07agwPQiSLcfAqT/B6vKCMjoHW9+kGZM7KA?=
 =?us-ascii?Q?YlXXLQFXZTCC3voTCVB4mUQn/oFY1ieEXPwM0eX+8GhvkQrzIMCypIfjjO1B?=
 =?us-ascii?Q?OXF7z1yaNx0NebHAAQ3iURHinyw3fN4W0uLYtp1QaBUx1a4+P8cBKU0BnNSX?=
 =?us-ascii?Q?zhxq8Ocuz5ZvoAB95XvAx+kGieT+tXcslQadGe4TcNvDPjrf+mlEjJSpwaIo?=
 =?us-ascii?Q?HZdomC0Ni9PxI5MPqQYCYxijsv/m1vLTbzyWO8kvaqHrv/G9nFlau9jTswZN?=
 =?us-ascii?Q?y9GsRLaFSXTOI42Za1bnHNwNzothrt8X0XsLwDL5yKObXBiRKe9vl1I7QuHz?=
 =?us-ascii?Q?fOnPiEEhvuv0/14CUhg/olXSbDq9CegvdpB5c1nmTbfBBpDeClIDPal9EYsr?=
 =?us-ascii?Q?MlYjNxgfaFDQPt8TtM8zvHOqGBiwV7C6m4VUIIhuiQavYi40Mu1dmplo4060?=
 =?us-ascii?Q?1WvRpZY254xd3REdgiEIlFlCT1gtFDJFKFnxOZ6cnPRhiZ4F3NuthHZXBX5m?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?vVGg54VUCwiNHFm+jZQjOrWxKg5Tukw4yiYOsJsDMtPf3GGdiE+RHLJ3aOz2?=
 =?us-ascii?Q?pfy9wQGj6J5xJSwJGeTtpjpaMN9HdnMLJEI/VIQbJAJAEhJwog9TIwZ1ccWa?=
 =?us-ascii?Q?76+140zw49Cx0rtRiPWheCquWa/Lduez46rfm2PYwldu8OZgIcvjTskrwoZK?=
 =?us-ascii?Q?LoyMv0SVrdZ63L63+aYUV+4wgXPPbO2PRCBbWBaQu7uQA9wdGyITEijQ5wwV?=
 =?us-ascii?Q?mfbCy4zXpOE8ToGSGnESfx8FTjQx7t6hxEE/PZw0Ck965jPIhMwDURcevlpu?=
 =?us-ascii?Q?LZpZbKlLFoJzeIq4k7ul641mOmwxnkKH6dPinP4mYw8bxFp1j6B43ztknDQZ?=
 =?us-ascii?Q?JLaqwuFbkC/ZDQW2VUqjTY695M23KFzAmPREkSIaogT6quOrzXaw5A+2UyhP?=
 =?us-ascii?Q?PSmK4zYQqDdEOLbpvWxYiB9k8E5bvDAxxYR3xEStCWbhLXFCD18PjTpXUsAr?=
 =?us-ascii?Q?74lb6ZyFLc+OGtXg2358rSlsDeZCKoH2cqwCPHzaLgBNXJq8rIiCLgvmGTig?=
 =?us-ascii?Q?0RG/SJ2JGFRM1pDLP3PmMN2unZ4vI23aSeNW29zj7LwutbReKUAtj+oSNkVH?=
 =?us-ascii?Q?n0M9IKVJIZXrYxyLuNTTMiByBfSM7rnsjqSxGb1BWubEfZr25vQrI8pFPTQy?=
 =?us-ascii?Q?7M2WEu6VztPhCXdcxfZk8Kio4NdFeRsJKtBvLRLoDlWcSKomHEmVYknX8fcW?=
 =?us-ascii?Q?UJPdkj9yf7do3ZsKEPMd3Ag3pt4y7ihvFZI3Az8IuoqhU+UkGhwiSOIgYNBb?=
 =?us-ascii?Q?pfoabFyJGfOtch03VI+SDAU25Ylyb8rFbyskgBISTPzcYrqNbdczb7hYcvl8?=
 =?us-ascii?Q?Zq7IzQSHebXYzEZv9PIHT2ymqny2wjohjoo0SkHs/UKhZ3EES3keE6zYvTWS?=
 =?us-ascii?Q?pLEnXA3A5XPltBDp06C/x5xOSxWYV2RV8I/P8qmPGKzz2PfqOffTSEq4aZmr?=
 =?us-ascii?Q?8dNvq3grQ8EJQv1ITVix4NjW0YWF0WShrNdE6QRPkqrd4hKeK1YNxe0A7dCZ?=
 =?us-ascii?Q?By+Db+rNsXdAddV/LYifx/WZJE4JsJRc0BT5VtStH0LW9Uf1jZTbgA/LT0Cx?=
 =?us-ascii?Q?JBJLJoAqsR1HJN7KqLcPN/vzMONC+p6Q/26WR7OE6yVns6F9bgI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36dbd1ff-4f47-4395-5b35-08daeec3938f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 02:21:38.9431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zr/bOMPPQV1PYCvOwWdDWBx1XIV84OJkGKgp+X1kP62MRh4EWw6/lBjpbjq0UKxpTs5PHpz6C+8wxwvC86JfBCE3t27OgM42Ose0FicF1vI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6543
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=943
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050017
X-Proofpoint-GUID: xxPQY5Rfq8OU4U0LeKV6PI5t49EAlXOI
X-Proofpoint-ORIG-GUID: xxPQY5Rfq8OU4U0LeKV6PI5t49EAlXOI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zhe,

> Zhe Wang (2):
>   dt-bindings: ufs: Add document for Unisoc UFS host controller
>   scsi: ufs-unisoc: Add support for Unisoc UFS host controller

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
