Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9274CC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Dec 2022 21:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiL3VY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Dec 2022 16:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3VY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Dec 2022 16:24:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FC2BE00
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2022 13:24:25 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BUL6wAp005510;
        Fri, 30 Dec 2022 21:24:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ZeZK3A49mABCF6KmEi0NBdLRD7jAhwSXruUG3Wk/oN4=;
 b=I5ZzZ88/F2xhoy+Xgi2ueXXv+YyegPNgR/YhIPb8gUC+PnJHCUfZdzoWmrAtvzcd2ynu
 g+CCYM38vg4/y4Fqfw4UaBBWk1xDtWPLtNkl66xCZ8wNBA6ri+Jx6H/7pAE+O0OFBozI
 gHSE+OFQBy70wQSQxQzVUw8bttexZ/jad+81ICiRBIsmY90dQuDlAFqOpYnUm+Jt26MR
 uHX+E0J6mC6NvTtnHNI/NlXBfATpAypsHFIV1JR6o/StdiweHDPP2IbnzZakn3q33IVZ
 bcFj7sRyy2B6V6z8+o1spOqlXeR+275XP6L2S6pp65770oLC3Sk21xk5y4Vbe5ywxof5 GQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnrbb8nhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Dec 2022 21:24:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BUJce92020832;
        Fri, 30 Dec 2022 21:24:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv86k44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Dec 2022 21:24:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdNefd9p67Ly6c3Y6pr5MUqwI/XZKHZutRr3xZo3pRwwGnIu9Gj+ZZkr6CurlTVGbJz+9rEmuQogGILy7pvGqvsgWhpa0T0J4L8VmNh6SK2LYFSD7U6DJbSz5ITFYEbWvKoEYqwy5V0jZn629to8Jw804NLHmA3wC8E5mcPdMDIMvg/3riO2QuWW8e/0di4NGmsnKzEdor2W3RYkh0t/M9yZ6IidcXKU/Jvt7arY5NsBGEb/uf/swD8iyCEKX+MDIeX5UejDHv+/9pjTJmE6pPRYjhkGX4uPXdhDQpwbm/TnUUx+iRKla8eU5Qy34dCId+O6ylf7QMYGO7RfCisBig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZeZK3A49mABCF6KmEi0NBdLRD7jAhwSXruUG3Wk/oN4=;
 b=VIf0ovkrUfuhp9BBvVrqo/kbW80nCQo0TQqSMEyQC8fm1yi0O8PFDdC5vLLmtjzWmA/FSZ4ENPd6JpkpePplNAwyQ2smiIePkelwZH1kmijkSwhjsklI8g78UaCmbcRnc6DBfEvApa09tfqLdm/Xxu1TfjQMOSkcvcwnjFv+3h4GjmKYVLYE2xsn+7/SZyi2ctOGbeK6fBG+ZOQiO/3FhYLR0T6DKIdkWPlFuuKbm+jKvapMPOtDfFek1to/UvhO9jeK06nP6oV/abDEVRCilOEHQNErGYC7Z4+N/+Xwa+Nwv/mgZND4RNFlyqCQfx/bt6tod9wLxXfCleCjAe9qVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZeZK3A49mABCF6KmEi0NBdLRD7jAhwSXruUG3Wk/oN4=;
 b=gR7DlTLqcnxlXNUDY77oNwglnf0xTA1MA2pcWNMorhvHWnUC5avTuM3xFC5MrOU2QjVQmDKBC9331tYBqzsHO15hZEMiVVCKsdfo5nkaiSJykyp8XHNZuuOf4I/PcI7aUOtIIIXCvexgqiL32tpdxh2yU2ZE/Z9hpHaNQYB70OY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB5631.namprd10.prod.outlook.com (2603:10b6:a03:3e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Fri, 30 Dec
 2022 21:24:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22%2]) with mapi id 15.20.5944.018; Fri, 30 Dec 2022
 21:24:19 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 0/3] Prepare for upstreaming Pixel 6 and 7 UFS support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y1qo4mbu.fsf@ca-mkp.ca.oracle.com>
References: <20221208234358.252031-1-bvanassche@acm.org>
Date:   Fri, 30 Dec 2022 16:24:16 -0500
In-Reply-To: <20221208234358.252031-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 8 Dec 2022 15:43:55 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0205.namprd05.prod.outlook.com
 (2603:10b6:a03:330::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB5631:EE_
X-MS-Office365-Filtering-Correlation-Id: fd1194aa-085d-4b07-d2cf-08daeaac368c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TphqHwcoLnlVLGrn1YPeymnQfARI4bKxYqSZ76i1b9zrCJdFL5lkXX6xduD0KOBy+cdK2hsJ+N37RcfmczKcTJ8X7WPDVnR+Pu0XrYDp748k4g2MNNOhBKZfNOEcl3AOEYyN/FARl+3G6hwytfcEay3nHcGJSt34Vzi2hexHY/2dL1sq77UMng44+I8Ng8fwteFEDFRc3sieR49Q1OrApLntCx8FnADRgGJnrpW2ypYsMG7W0EEWTZaXvFHUJRtLG/osmCetZ+dH1gxIES2Z4TzSsMDhNTCLYoxGaPQlWHqs5IXcoIg07cnvX/rq1AmmxGDw8STPZ7+yHs04XuoOqpISkHVgb9eJDg2Jwaxd9SuFin39KVwi4XVxKRJMbU6FCygVjCS1PgovsG8qc5/QULhV00bUE+6WfVqrsI0l0LdZ3CuIQObCGw8ZBsGOGZz+RW5LjBNmlCrdm14MaMtsljwEPSkDtgvqSceCJs016Z26WVsJFNPfJvQ01ROUCT446QmOV4pyB5uTXEhXlkwf9tcZ+M/LRhZB61J8VMXenxrTUg63UxDyIwBgR9/DHI3HZO+97Y2ndcpKCUC/8GMVPH66U2Lt+zm+DCuK4bzBISkO6ZUiGyOO4Pz0qDsv5tg+uUshu2aCzQn6VkbIzd1E53HVoVxIylyzSEm0oJw5A9ZGAbJtPdpAU2ePfaXC9sXY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199015)(83380400001)(86362001)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(66946007)(6506007)(6666004)(478600001)(8676002)(186003)(26005)(316002)(6512007)(4326008)(36916002)(66556008)(6486002)(66476007)(6916009)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/9uDc+a91MWCmIBaZMX/UarEl+w1Y6iTfnMRnBq478Ok9/BYfABY2u9LA8/R?=
 =?us-ascii?Q?BdYvkHs4Jg8NJ/CHExGvKyxuuX3qeNWNdm6rVyBX0c6Idyj8eJZ4+Kki8T93?=
 =?us-ascii?Q?/tWGyeDFQJMhqr4UJzWvy0FaccT2qLdxB/4mWGOkA5XIXcUmIiYMX1IBZBEg?=
 =?us-ascii?Q?Od04VHmjG0u9Q9Qi3rnictbJBzG7cqxlO0XkgIEJFu6Yq0AMDuiRXAshOLEb?=
 =?us-ascii?Q?jTrZCPJYe50rXtsfOFlyZmLFN9G37nG1mIP/hT05o2Cgc5u5x+x6nknNBBPl?=
 =?us-ascii?Q?GIoYHW1OtfPQK0GYl7+L84nBoqVgCLcMk9EjmF/9aWanBNqrbcMEZkkwJOZ2?=
 =?us-ascii?Q?/qiUuY4vsdRu0l6JvcC4oQWIVI2K4yoKoDg9h8U2gwyUnwlPpjBaSXievUar?=
 =?us-ascii?Q?Dc+kkskYnvRZ5E30dpC1pSzAqObelVRkoxhMQ/9G7oPIiwqIjBDSPZXhCFMf?=
 =?us-ascii?Q?CAJWk1Mqrf065SzllEnS9Kbpyj0BO4V3cAherH0lz9mus0xGAefaeMs+XgMI?=
 =?us-ascii?Q?WUImRY+8YYMnXMcS0cP4z40uMlZRPwYyT/PqjwM+zTDNs2w4nWOw15eJZB7V?=
 =?us-ascii?Q?52zXUIM65lHNCJPk8MFfTvRbfyy7FxOjBlGYnTknvtOzRK8YJsk8934WdqMf?=
 =?us-ascii?Q?6s7/ZEcB6DE+M3P3B5HTlJsQgzHfk7I1fr6oZVNdqrfgoc8h732pZEeFLpdI?=
 =?us-ascii?Q?S3FtvnX+XXz/y0GT+ytIVdpf+ycDMkL6dg7ZgUiOazKzJdNqkdep1PV6GDUd?=
 =?us-ascii?Q?tMb/LIHBXgp+PWYmzev9Krl5ftcEQShswq2uWL1/NBGZrXhAYB05cflv2vLP?=
 =?us-ascii?Q?ZUURlxPtwIKTM5yrJlYjQsFMYpFigRa0AyPCVL7S8ICWQB7LRZWWomZryVdr?=
 =?us-ascii?Q?jTIexANgtaQuLmDJO28xKOw/d3DfdunWrGiODVZZqkNqXW1HYzqh/SOtP0Lc?=
 =?us-ascii?Q?aT66c2cS+6APpPKqtp3mm2UpKvcEopwNPnPfwmBmkWJoLUjf6k0Fk5zGLbQy?=
 =?us-ascii?Q?KgAFmGQOltYonhPUlx/iBXBXm/MzZ9zlEL/VIjkaCZtN415BxpZO8A++2pUT?=
 =?us-ascii?Q?wxiX1e1RCOt1QL9Z7kpZB2skssWWITcZ1SwVq59DKc2PLl0z0mF04wpthXYj?=
 =?us-ascii?Q?CDocMxs/u5P6EQgMrBQaj2YlXqXGy0bveQaGOeff1A6fBsFekMCxc7DcICGv?=
 =?us-ascii?Q?tQAhDXybfdnaNVEaL0LFZ+9WEs2QQ87QTsXIosK6dzdIaCdsHJyafEDlNZzX?=
 =?us-ascii?Q?5pmLxxA9Sr9ZvrZ04lbUJJjI/BV/Ff6LVxQKg+87mse4+pMdNleL2plyoNZ1?=
 =?us-ascii?Q?qdXGqNZJ6GVxvuVvwE0NjtNTrhDTYGEG4ftfiRNXvQFd1Zsnr8Ky8NhNrbzQ?=
 =?us-ascii?Q?qsylsGDAoZ6QBEAX/zJNl/Jxgls7jlUbNC/Qen4G1rDcBbtrAKQO+svoDnBZ?=
 =?us-ascii?Q?4PXJhN0m4CXtF57MCgl5nlANp2OX4uF4JEOcRQflT0J4tZhwLVxrpqCdItVM?=
 =?us-ascii?Q?u/DgbKKDw9ymOvhhfVXDjFxNAYzxxtYoG09cyV3Z4hW6l4S2zJAuV3KsyqLq?=
 =?us-ascii?Q?luDMEZ0W4whQP+aPYE+xAgwX2NI29FQTUnQjxRH5JrWXR7O688e8IjglNur5?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd1194aa-085d-4b07-d2cf-08daeaac368c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2022 21:24:19.8394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+GjVX/Cj7wEzd/tVTpg3CVTCiMg3xT6t1ErFg54d3k6gYbT1NRLEKNJlC2S3ZUwtJ3axpKLy6YmeUCFcWc/ZbrqHnLIdG+ZviYWTqm2r1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-30_15,2022-12-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=631 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212300191
X-Proofpoint-GUID: 1UD7YGGb90WY2hgcdfY1tkrmBQA-kPpU
X-Proofpoint-ORIG-GUID: 1UD7YGGb90WY2hgcdfY1tkrmBQA-kPpU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The patches in this series are a first step towards integrating
> support in the upstream kernel for the UFS controller in the Pixel 6
> and 7. Please consider these patches for the next merge window.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
