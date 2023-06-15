Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2388DEB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 01:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbjFOBwt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 21:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjFOBws (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 21:52:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65437E69
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 18:52:47 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJuCKW018203;
        Thu, 15 Jun 2023 01:52:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=sbzx/BnPG+Tsfa8EqYZGbv/zisevCUspq/FJI4ecKpM=;
 b=qbRNCvG0ieVc5eFgCk15i3d4pKLxQ5INa9QSLQhky6tGZSGAKazipHkBTSxqodYyTOk9
 X56wJ6p+zaySSVG7f6dZR37aEpGK/fEIsKKj9mmleYJ8eQ+9q3nR3nJwCT3o0vxjRv9q
 ckNVndPq9ufiTTiOQ9q+KJsJpOFpfnaiz0lVdvTlwYIQrtyiEF+4jUeTspiLAwviDioz
 F/4eoc2xEEIUxuget/4cweKC3BwQXUVTH+rL85DK/XMORrYk8j6DkcTZ2AQ7BaEkeBud
 QaD6Mk01GgNUwStk7Ph8jF2beRyVanOSsoTKR0y536LEMZHAtYVISHC8blSivxE3dJpC XQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h7d8w3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 01:52:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35F1cZmV008272;
        Thu, 15 Jun 2023 01:52:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmckhe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 01:52:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvCNDPLtH1igQDELfEmYV73bB08HfX4Z9DeQ4wgzGGYbqjegGmpL5ul03iknaLkbkcIEkro+UXvXbLlmTsO25X2XucFCjAPQJ26ncjmDamEyerK7BDi1kWXHbzVnEyf36DUfy5ANsHPDxTHF2omO/iZnu4iXrZxdPke81mVhB6yC1UdHI+65sUDWg26q9SXTqKCHocbJbSc0yWsMROa+4XE2DMf8j2OSK+kxNs1fMTpSa7havd1ztuSnsz/5MQIhYATH1J7vVtdzj1wArv4zqzm/cQwcrBu5pf4d6B6hlFK3WyC6XOD9PpoHI8Ue6Pb/4t5IuinVgR5DQNMIU/+JPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sbzx/BnPG+Tsfa8EqYZGbv/zisevCUspq/FJI4ecKpM=;
 b=eHiF6xqUygc1AmHSZGmVlORu83j54QFNzBR/ACfkFR0SxW5B225ZTla8+JTl0UUKzezSZAM+0Edye2HVVh0dkyHyJSYOG8B4G6KEu/T30xlLy/xOZbD0RtBDZRNszqcJNZ9vYeF4wIXrsf08Cujrko3uJhmNximPgctJ0a8Iv06DMosaIvWilwKOwlW8J6hd2W9DzU3Nfx4s3Br9/+pOiyZwl/7BAKC8VjKtlVGSBNxklaAFXcgPoDzO4p2mgstzK+ALUB/FlidRwWrX4ZOpJ9Vx43T82lnRIyuCx8pZtfDRUmY7fXTOuIHrC6WAqGN6y9lw1tLHbFadPARvWGRubw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sbzx/BnPG+Tsfa8EqYZGbv/zisevCUspq/FJI4ecKpM=;
 b=WRpg78cOyq7J/6VRxgWvz+bwJAGJMD9DfF0gqF93/UiwnAcuEAZY3ssRIU02H6ovrquV0NlLXNcX9t8wUP79+ldUJNpyTeN4tGqQe/oTZMRKzhWUAusHzg5JzBH2jesK/nynMRdIZS0YwGd+OD5etphVg2e9h+vXOsoTaoXM1Pk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6027.namprd10.prod.outlook.com (2603:10b6:208:389::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Thu, 15 Jun
 2023 01:52:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%7]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 01:52:39 +0000
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: use PAGE_SECTORS_SHIFT
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y1klv6e9.fsf@ca-mkp.ca.oracle.com>
References: <20230613-sd_zbc-page_sectors-v1-1-363460a4413d@wdc.com>
Date:   Wed, 14 Jun 2023 21:52:37 -0400
In-Reply-To: <20230613-sd_zbc-page_sectors-v1-1-363460a4413d@wdc.com>
        (Johannes Thumshirn's message of "Tue, 13 Jun 2023 05:31:45 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: 79ce287b-b541-4e95-2814-08db6d433335
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mEIoha2rh+dlIWO8xhAVpvgyb/wZk6ViBd57VRwwryMf34B6hlgnLSnpljfU8NsmUHT4ZO4DCRXvdIHIg67uKECQqyKl9I0uamdFj4U1PlWgTaT3qEKP9MY3pieU2OwusR1oGYk3jOXlexr2aYLZLaeqm/adR6YrwDmyenVFxN1NHcAEeyB7XW5qiAa6dekPdYk5CsmZod4ytTNap6t3O83zED67xXDZTATAQX1a1QOZ0l+DZW1Fm5To2GjQuD6ZcKCq7eNMfXBoZh29RNZ8nzCqdf08PPXIxAz7rGAdKtToQorNDO3f1DPAxJ9ySVIj/VLiaHRqz1DfQI+3lxCpuYZPYS6O0IZoGo3pRmku5OuCfkCnrkJcWCV1kDqZ0OaS+oeiprff261dJBv6ZOdbOCi0mY7PUeuBlWtMiWWPwdafjkxXmonGCfqB9yaWG+loW5juyLvrE1kQGzuozPu6DLvFA3ii+Pc1S/9He2n8d6dp552iySEDBFEuYvKtM2r4HTXIyhQHN+UFQ7bKeJaCluLqj3WWfJVlF82eDOgEWi79d2CFeViUANbGwpkcLCMw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199021)(5660300002)(4326008)(558084003)(6506007)(6512007)(66556008)(66476007)(26005)(186003)(8936002)(86362001)(478600001)(8676002)(36916002)(54906003)(2906002)(6916009)(316002)(66946007)(38100700002)(6486002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4GHCFpp501jGzrQ5HXxcWek3QYx6mviZaa1OcD96XWDfJ6a8KnAN67iLsmyK?=
 =?us-ascii?Q?zruAfb3d0LsIJoAi62vXzX7kDlXme+wILzWOK7iyeYUvxKSoqS8LClKES4FC?=
 =?us-ascii?Q?4vWNUkBxv3cAoO0vE0iZNvmNDFRUZZYzOGhQuC+yK478jORKhD0ghZLGbs2C?=
 =?us-ascii?Q?LfsxMLmtIJJE7Rabld9S9r0SbSveSPqF+qFroxZ81z6CFk40W1nYAjjBDDwE?=
 =?us-ascii?Q?rxYRednorHxZLnZJBYxg4/tzIWZQKxQRkreeHl4B5iibJFVSDNBXMS0DxyWy?=
 =?us-ascii?Q?O1nyAQUsM5YJVba6qdJnrc9ZCL2A7OrrIEkVvdzt17XYKvfb1xtJ67i9jVRC?=
 =?us-ascii?Q?fibFiOW7K4TSBiBAHYk63DW218LsTzjIBBoW7sgH1n+no6TbKsiEHpIG0CJj?=
 =?us-ascii?Q?8PtWJevsoTdf5r7FVF3+T8Kdn83/xds3fjRuZ9L5BYRvawgfyANBHyZ0xtvJ?=
 =?us-ascii?Q?tGFBUDx+QOY30UFOv8MWadBnQ1bs6YrIt8nCaqzOQGCvlQos1Ky3rLeIENbP?=
 =?us-ascii?Q?aHarY1g08Pnd0iUfbvb2aaWJqI254C4iQg3RbyUiruS/O8OUo9eUYJAHg1do?=
 =?us-ascii?Q?itXXf5EgMzMnQv9faDXusVVuiE3bANIVsM2FKRFrHlVQNhjVcpxYrM7n0tZL?=
 =?us-ascii?Q?7EaEr5/58hGquD6zLkd9UqinKapeakFOF26oFXz9jPPLp8Lwt9N3g429KpI/?=
 =?us-ascii?Q?dZcRqxK+dWRWF2AWEPtjYXJkTPHVbo89vMz6fxxt5RfzTO5MPtUfAJKxHt3G?=
 =?us-ascii?Q?4Gmq4I0hjocS7qC8BHIqOvzfcCYxretsunZKU7O6fOV0PnGQX4p8JJdFSX5T?=
 =?us-ascii?Q?oMcIF3Q2Eh79uKM3AaAN9/KwCVmEuKoJ+W8hRik3ZuQ97mC4kFa7BWx2An1o?=
 =?us-ascii?Q?+YstlzayMMsBK9lm0cfygbiLA1KhTwzWyr/foGnfLwJf5GhQ3tr5fiI+g1gC?=
 =?us-ascii?Q?cpLkCeLFLu4xKEWUKjOVIOqZ4uwavIv275MzdDObcSaipLVStK53dYmLr/gV?=
 =?us-ascii?Q?00xOFo3loN5sVZpAh1oGPRu6uUIM2cvwWARBpz9yPObXF/JfJM1+SUfeRlGG?=
 =?us-ascii?Q?H3EI5QilqNH51OR+849Bcjs+byg1wCxdj7TijLiJBGgUz0yTVvZ46EV67gxJ?=
 =?us-ascii?Q?2nFqbQsJrGXGMRtQt7+6H61UwMJih13Z0w5adIwDaownFwsb1kuQzDQ9S2QP?=
 =?us-ascii?Q?Y4AB+l8iZLecDsqGfzwDrgn7Xpm0xaVjgEKoNMTboNoKIsCjVAzq8flPp5Xb?=
 =?us-ascii?Q?fzS34rH+v2cdNq7k5FSGf8fMK19h6xwEfhEJlj9V+jXxOvj35o18Ux5/ep0+?=
 =?us-ascii?Q?r5+wjUQ9aTXmCp8QkU1XN7lwfD69b4Lx9nwI3SI/SiKDOsX2pDvV7IUlsaEW?=
 =?us-ascii?Q?vTS9HsZdMWCgb5QZTETKEXCDg5y4AdLOPg8yBWkAnG0EWp0THJCn0TvTLIEw?=
 =?us-ascii?Q?Q6v1YNO6epXyDGyueDWV8QCoLom6TAVbL7KZN9ducRQkNLsePdPwwciEAUns?=
 =?us-ascii?Q?hBW/L1AYIso/zRqIbZcpv6PPpTPxU/Bx+lL/bWlbpmTZ/IjBwaa74vDx7YqV?=
 =?us-ascii?Q?CPB/Xd+MkgPbFnOTuK9Vu6DDx8BnoOuYE5M3XnANoUK66OaxvRmeiVhGTxzD?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wogxTWMiUJ1uCyNi/lqvWmTPyzn2tQYDkBZ0XUvRT+gzzjpiE1Roxis+Xzg/mC+Tuk1FcOIG4lWRBBd//InH1OxPxt3RuR11Jg5E1nJiLh37ZemCQ/NLfpnXRbaAAb2auhuwaCftjd8soLSPZSXiYOVjrAXFKtuUvNFC7O67yfvm561dCktYX5HZhz82fSyHZlnL7QAclfOetiFx8tQ0i2fcrq72ToGhhaBPBodWYhmXTkL9g1kfQbVcQx84I9gvDVOOKcjRySKJeta1wgFHS5B6CwoNNWtDKhXqV9L2oWAXhavULPqt1lOvnpsJvqA7E6jvPE8Q3TlyNXDkcOOZjEFPv6tc0QQ2TEjPjAVpL9C3Czm/IeoPGPB4/nsPu/mCCPoAtrWh8OjfiQLoqlYqsqeJ3RRILToAu4DpjSpiXy43+xj84qCrCngzE91OzoiIxK/NR+P/IdrKB95eft0nFktbBNu8qCf4RrzplSPwfTzs/xkkZlVkjo9Vv3Wkpbe9okdPktLaS9/btsoQGg2KbsxPJRhm7ry/6dtYLb73Q2XPFjNm1Ve5PVMoIN47tzZV43XxJlLOfFa8EZT3TPuCfkXsts/pfa+xdZXuXbpcAe2xSE1AY6hR95OXaV+Jg+z3e4yPwlFmATMWTwFphiW0eLcNlC/MrkTPmNzB+2FR1fdsqXT/qW7PL2IC+Vtoko+ntK1SE6EemdafBDiNxrpY9d6jpfQyowPInyxZtKS6EKQXoBGlM5U2nXfnqUaXJyxNZk9+eUjz/Je7PjMEg9ScDM8JdeLEyTpHVYelEhmUYzR3sL+WI5vq20y4hYse5XQZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ce287b-b541-4e95-2814-08db6d433335
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 01:52:39.3594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4IS+9Lrr/dc4JcvAeL7Az4x0xcdwocz1V3TMdUkal2u6tWqKz2tVho7swlEj9NnaLUlzBkfplgkjKeFD57qneR9/vEpiApnnS6yiFVVvUgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6027
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=696 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150014
X-Proofpoint-ORIG-GUID: 3VKDeYff7wpY3A5JOgLoEDx7h7GTnRBz
X-Proofpoint-GUID: 3VKDeYff7wpY3A5JOgLoEDx7h7GTnRBz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johannes,

> Use PAGE_SECTORS_SHIFT instead of open-coding it.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
