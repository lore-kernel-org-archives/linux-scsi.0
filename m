Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AADC6FD1C
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Mar 2023 00:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCYAv1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 20:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCYAv0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 20:51:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBA415172
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 17:51:24 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32P0nfCC031857;
        Sat, 25 Mar 2023 00:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=mMUTNe9Wby6bO2w7kq1xY3YkXBfXtle710gn/iYDsRg=;
 b=bY2PC4BIKH8p716X53FjwM/Pcri403ZkXoc+dmQV5jOvsZyrJcEXNPMWs3ruvHDS/Q27
 XP/hoIYnUaQYvqO0yF+SBCvg+R15/lIQaybWI3S/lxydK4S2PbZ0L3BgSiDa0pOW+1Dx
 KHxEheqo879YsbM4rgSCcpyBSjszJbsQ+O0UHNcUj8c3G583nhfZTtVL1Zz14tJ6xPIq
 Zkh97Vf0SRjElPauJjBltyFuV3W+rPLpIOzdS8FGZsxGnoGKNur9Pw2h84splvc2zTHM
 IA7umcLVt8OzfuG6vUWSKdFErRy/mTwIzrIAMblVWcycuO9RLP7iEgHiBVKAEOmlpM7a Ng== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phprfr01m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Mar 2023 00:51:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32P0MA4U009062;
        Sat, 25 Mar 2023 00:51:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pgy00dkbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Mar 2023 00:51:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1YnI7/OmOUo7qDkD6Qf9bc2WfwTGadrpsG1j8wV0X4G2Exo2D9ums2YMDeqlCJDB3wd+gY+8urUhBI1IpbpBk0vqJJpIyOgHQ73m3roNjK4a/UJTDATZAixgtLabsCzRGGcIR2ftpMtrrAZ9n4DTwjUR4nZWD8cIdPEKolBVEe++FkNlkJtHBtHgqygoekX5aY5JQBfc4TWYrTYWBpnWtsUwv2BkH0GScjFaZ4Z7ReTYEWm/85Wh/7JAEMEh4oo4jlmmQpUD2YzuYS/Usd/k6CiyDeN72MyqSEAXLMmgrgpbfczAFEZXkawCW5gd0iorGKRkUv9awMjkV8KqMXHhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMUTNe9Wby6bO2w7kq1xY3YkXBfXtle710gn/iYDsRg=;
 b=lbq7QGm+NOSSlBF7OAYfrp2dQImi0i+yzU41koiwBRP/XBj2Q5+GmJkQBWQAC8DNEqmFGZahiwbyfKo56xfMHkVEOybCgidVolnsNRcnFvrfIYhoAkgxBq8yo6OiNFGhFoo0KqYvtWMtaM8cUWA+luK6BRfB6eAgSGxtKZAwNK2w/H1zfjzLIz12gmD1fOSfWUCrcnWM3Oh9BTO0eV3utgr1kwOGFdcZvZ7evDha8eHOrakLpuNun4owS5//8tp2iJFp+/RRTk7q2jBTZ4SWqGB+h6NDgs+DcpChrDm1N+MGkuv/phYPjPRCLEclJIKft2MoKOnXsP7LQ/jr2YGQQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMUTNe9Wby6bO2w7kq1xY3YkXBfXtle710gn/iYDsRg=;
 b=X1OBUS7PmrCffpbJAjBJvjGbrxK+0U2m90Vb0FUe2HE+YVpvOPGlWYWx6ss6zOnVeENbiAvPu3gc1SjTSh2NkjUZVvkgjL2x3h0U72rkp88alEFpNvYxLZ7mZXLL3hLxDLyIzuQn3vOtRNEraip0pbLnr7hI+NCzHJKEsz+2/tI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5065.namprd10.prod.outlook.com (2603:10b6:610:c5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 00:51:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 00:51:20 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] mpt3sas: Remove logging BIOS version in the kernel log
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rflirlv.fsf@ca-mkp.ca.oracle.com>
References: <20230322092713.6961-1-ranjan.kumar@broadcom.com>
Date:   Fri, 24 Mar 2023 20:51:13 -0400
In-Reply-To: <20230322092713.6961-1-ranjan.kumar@broadcom.com> (Ranjan Kumar's
        message of "Wed, 22 Mar 2023 14:57:13 +0530")
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0074.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5065:EE_
X-MS-Office365-Filtering-Correlation-Id: 062ee785-ee30-444c-ae62-08db2ccb0c36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JTJLHWgKpgHjH5OTa8EeuBpWS2cJSfHVf2mFvPv1mO7Dm4f82nKA3x2c/Qea2RKV+yugEonlWqJxIIKplNgMNw+lRRcLuOuvB56k/SQrqlutVkZejjxsWHrKe7yfGdAWHNABSFVOsozOPIjHUH8/Fb1ZbmPou4kfsNmoJE7AHT7R4Hkdkjymi/KbPWnHAn3uj58hrqSC3wbVx170Zn0niOUep3F2UYVZPaipyEb4cbWlG0ZcWcb6BWcUBx3J+UlEwdZmKUoskENzaADBKqHfyGa31ytqUjmiOs4bNT5jccpHAFMmQGoBPem0QqV0esWF7ZxHr15pS24WCz3taCgzT9rSIcebr4sV+FrLQmRdf0wbWGnI2gAYDAaZmyFvuhjmfP4jKCzUNDFWpr51q660TqKNVWuXySwHIJKGJRzXI7bLNhd7ddYywpUyaKE9VD38htvV/GwhBHhpTPf8NCQ+dUjw1zpk7evzLNw2sbWripoLyq/pMHQW+0a+2tkLKsbas0oLo3ilAewnvxmCeb5lquDf8RqEHZM1/Mkdb2vmsLFPBlia0uaf3pc61WjFJlylyB0nhCaA7d21wNlE4S01dOYE7LxQNj+ec1hN4mVMUVk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199021)(5660300002)(6512007)(6506007)(8936002)(478600001)(558084003)(316002)(6666004)(26005)(38100700002)(86362001)(186003)(66946007)(4326008)(6916009)(8676002)(66476007)(66556008)(41300700001)(36916002)(2906002)(6486002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2JgbLNq3/hiQUj1sbcE+rputIKqyKMnST9VzUzsKycxVO7sgru3xctX+p+2m?=
 =?us-ascii?Q?RS5CMtHvZmFJpNLdPds/zrN/gWR8EqVPd1z4JOD2ZZbKOT6KD92rZRhsClPs?=
 =?us-ascii?Q?EvJsqok0thY6bUe3ARgTcBLygmQ8Wh9Mzc1Qb6hO4g6Erd4orkxyBriXLGrT?=
 =?us-ascii?Q?xzYNwvkBWDMx2jLCj9DnMdZennVrwTOBFBz322YXDlaXXQ1wofFllOSO0/67?=
 =?us-ascii?Q?yU/JaYDRf7o/+oiDhx73Wo+1U7iku6/2c1YBNVvumdI4m0epHkL7D6JQ9hMM?=
 =?us-ascii?Q?R5t7KVBrTnqLYYxrz5ZVH7X0jG7nO/vgXPgeYesKUu/CU9RLmKi7d1JtZVZd?=
 =?us-ascii?Q?307ORbrSRIPV3hgHSrHBi70SmysGWrMQOq+AWvSylYX9VaCDEX8VpkkbMmoh?=
 =?us-ascii?Q?3LU2PO/xY3tXA0cLLRhQNxqgsN2mzinIYlf4ISGk+ERxaiSBUwr030iB4G4G?=
 =?us-ascii?Q?eoXEJ+8jDHU0r7uWZlVuuchrcpIgrStJ0kNZrFGoNCQMvfZrdvSBp2y4pmbC?=
 =?us-ascii?Q?QD9lDeZBEQp4JLMD7KOZqFRyJ5O64MNi2mhQ8b40YU6zkl1wcT+1+1mbG2rm?=
 =?us-ascii?Q?EymraSn4tt6opSDXuEuYIyDgEzo6bXsZbdq1QYt6jHEWr+qyVpW14NCoGnWq?=
 =?us-ascii?Q?kKUiOeTBkuTbZleNI7GEJ6gk6d8k1a5d/sfPbMAGJFsRveIwVD9DgiijvaSR?=
 =?us-ascii?Q?NlWbYCictdxN761Hq/SU8UaUQcB14HNaDpoZ1CJDQ5ViHgbggRbU6up6/rbe?=
 =?us-ascii?Q?8zXp/5tdr2t+gddxvfDKSk1LexDu8FuIMyFJI/OTg2JVDkIfOOfyX9fXacgd?=
 =?us-ascii?Q?Xo3LtK7Jg9H8odTziZ5A+wEnM0d/YS22yLDOm5O52TNHHubnWiJ3nm6tz8FA?=
 =?us-ascii?Q?wgljRqQiPmwMb+j+YugBwt6KEDTQfj3W6sN0vlvpltrJZsyXJZalujHAZYHM?=
 =?us-ascii?Q?jBpkIR1Uxv40vN1qweVYtGCIH7l3J7mWF47vLMHdl9+uo29nm133juXEf/tj?=
 =?us-ascii?Q?DOB5T/t57C5amRp4xFu+VniELBnWQrIpXXLvKaY5lj+geYJdhuTnQfyPL58K?=
 =?us-ascii?Q?zXmR25Cuay08df9JBChb3K0ITC4JMuwFlj6mYLHHYQU213AZIWob9zl5YMv1?=
 =?us-ascii?Q?X2uyQQO+rpO7/np0bbeeL2qMQ9BhJWtIws8K8XGXbfCzabRbfHLtgnuQ4KBt?=
 =?us-ascii?Q?JzZ1hKMmGT1+cD4mpx4OdcQ6YNdz++3CZpiB3Z1e85DDPunXkYpm67DZm9Ns?=
 =?us-ascii?Q?OIh9XcEUlG1ojqk8gMk9sBVbQF3v6DHpExnPSBM7WZTU+WCFThnTEKHm2shR?=
 =?us-ascii?Q?J4d7w12XmDq+MFGVjtazqWp8wm+3ZvOnAs0KCBlTqEgBDTo4hN6I994iccCu?=
 =?us-ascii?Q?frHRT3wielTzwSVlfiq0MDlhY5jLDXWxUnBNsWV1aUQ74R6TXXw+YaLgK3bZ?=
 =?us-ascii?Q?6t6GM6U5SoYseibAD4nkibs+LVj819s6jHEKpa0KRBZ5GmgSDlBUrPpdGB7a?=
 =?us-ascii?Q?7CUhfDUEr+h/4IBKfu3XUdP/GsYCX6Ke3MyEJJck5D0CMlSrjK7zXndqTF10?=
 =?us-ascii?Q?XKbpmybywixJ8EWn1Jc01EEW4NwpaWjKsVxvCXSY2N5S0x33mqTuksx7in3J?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yNJpWZnDNP4NyCrGy2ELbt8fbTmStSZakGUk3ESOlUGZ4FlniGu8I9vQRruvceNNY8QXeOIyOq1HAzbORxIdOWY6OJTBQBLK0aTOYjQUfaANMZjarimOfXtPdPG62h0qVHmwbMy86bXVVzNglRpbwXai5z39t/iMDSxHnOl4AphXq4c/aq9ekOvUk2m2OrDfqnz9MSCt+dilAI9IssfdDzwIFifuzX+uWxXPskpjRNpIbuBFWBb3kegH7DVHlKzUQm9nw7G7u3qQB/i/XwpfILltGd3GZ69acriZv7iPtM+zLaiVH73xjFrpgF00+IWhWijBZkt6G7jHvSgoGu2M4dt9ksVmfcTZKDSlVTBa50viCwfkopPxewL0iXuyO5/pxOg2NeFUA2ru/WzbBNquxPGw4u2Nt3tosHQ9LY/YnkOri+Fz8NrT2KHrirYo+T1NR+z5tGCf930PiWjJVtPfAoNWN9dj+vDJQyWzwW0evse280AUXklUmx4NF9s85KjOrTyYJpu1ULWa0kBK03OG76EUk7rqPUe/Gf9MyecX2I+7Q0VuIYRp28Jg2YN7XXkCm1VqUfY6+C5qhivB1mDRPhMmRxMP7l36N6cFj4yu3AZ1pEi7p3qf4wlekM0ZCXAx2hkqCzmcjSoem8X2+tkHnes/zPOpcfTqFzrNyHFOQx7qixcwCO9AVhSaQe4OZt6Y7iYufp/EXZarBNoIkbyH5eIldVyJeydIc4j2PpV4G/RgkX4FjLu5KiaDPfOVjrIFnfTWA0Zz2DQ2owbV1Y8/j0MZyXz+msKDos4xnS+15YI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 062ee785-ee30-444c-ae62-08db2ccb0c36
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 00:51:20.0137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L742lYxkuBiY/UAMcDZWC1iRImrQmMwB7OB3X68OgHWefowuvdDz9lgrCCpBDlxpuCGLcGpSp5J30g77wEp2l3cHA7JyYLbuIK3KHwMfOqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5065
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=828
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303250004
X-Proofpoint-GUID: AnwkIHbjxzMagsbQTjFe5Tmj1C1Htkj4
X-Proofpoint-ORIG-GUID: AnwkIHbjxzMagsbQTjFe5Tmj1C1Htkj4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Ranjan!

> It is done to avoid ambiguity between BIOS and UEFI version.
> Management tools can be used for getting proper version information

Not everyone uses management tools. Why not print the UEFI version as
well?

-- 
Martin K. Petersen	Oracle Linux Engineering
