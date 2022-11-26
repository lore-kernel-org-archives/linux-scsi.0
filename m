Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7684C43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 00:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiKZAbk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiKZAbi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 19:31:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2730023BF7
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 16:31:38 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ0EEM5021347;
        Sat, 26 Nov 2022 00:31:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=dwKki7DWzm/ff72kGvMSes+H8aBTvf/hXrOa7rpLHJo=;
 b=F/pCnqvzJub6DD/uCPIaBqrPwS35tFS3UGdOB4RyRsvtlSaTyKDscwQslxnLOxLoqjbN
 6TrKK+b87VsRs61QuD5P58sFcBHJrLlBq2u9xkOTGzwE6hws2eN4R4P1vWMT3y54QVbe
 cr9PicAWiD3POGVxF+w2eGNaJlxcLUHvQWMQPYSeyCbhnyXJInyIsLvFsOfSpGEdW0Hk
 K/YUHTuKaszuQKNXDVdu5BfNTOSeNE+92D/NbB1jkMV4GGacN1v/wPv/5TdvZU6YPsqW
 BvXKB4Tfj/ra0ZMF7WtmX8m7702+o4Oso9pRUKkZy7ixOOybqYcoGa+QwPoSlljsjGxw Tw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m2jqm23u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:31:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APKVTG1011266;
        Sat, 26 Nov 2022 00:31:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkgwf6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:31:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ds8/LGM+KOIu8PTrE/+TlTeeL3+uqu0wNSxNRGTf2yANTazRZA9i2u1VTQ7rhZhTvlLUYwJTzBVMgakwGLvvoM4Y4GsLIjKtJyVWYGr5op1ERRTO4ZpKQPENfQwopPNGHCUE92MkAqNMJ3oX3LUbBW/QN7kc/r/a2P7eRX1NIGcQButOJCIKEI3zSnAu5SAzxUKKmyf4djfFJ9zOn1e4Q0XbuRBhrAAnZYMun+9VFIOVsQjrgUVKctftu91PWcnOWAC6iAe6i8cKcIfMJP60BBjgK8ZjU6sWX60BexZE6YAfHH44Xtt34ecUqcIzvZOKdSpJnwahADX/7JoRC18Lhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwKki7DWzm/ff72kGvMSes+H8aBTvf/hXrOa7rpLHJo=;
 b=UZjiw2hKweuWE/mhIBVIL3VpSxF4x2797JQokLMbHOfVs5kbsOW0Ig16hKiGnDmg43JO7cylHmMDU0epXak6g5OLK/Zm+SnzZuGMQ3DlZTBShDYlAu/NYVXS5r6LYCs7EONO9WMyxnKN5yAEHQeYmK2QxHeC/65CMD+ZkZJ4rV8uL2nRTj7ctkOY8usUrFnX9EVlQMBYpuY+sOF8RmZpAt8vX2CqiYaR+SDUXI5H/m8DCRVX1Csa657ITEQEx+G0RDijk/aFDknKosqFGmR4QJxicgOgDW+VDc9N12a/b5XCHjWHluxmZr/7yqfbLBE8ZIhvmD9wTmjSwks7j6GOfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwKki7DWzm/ff72kGvMSes+H8aBTvf/hXrOa7rpLHJo=;
 b=TODEPOywdnzTaGihmqIpB9U7SwOD3SP9WT3w0w6f8UzlKRqJu//HSdcg3T7drIq+6YnOr56q4yZ0gW6c9q3qEtqXe+CRhHaNhJ15OQIEYurhKAjEPCxZEf8jIzqH7rCU1fHUD6od1hFxIY+04qx58QsXH/pdJc/udCVjFXlVzCI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6116.namprd10.prod.outlook.com (2603:10b6:208:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 26 Nov
 2022 00:31:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 00:31:21 +0000
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     <kartilak@cisco.com>, <sebaddel@cisco.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <JBottomley@Odin.com>, <nmusini@cisco.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: snic: Fix possible UAF in snic_tgt_create
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fse6pne8.fsf@ca-mkp.ca.oracle.com>
References: <20221117035100.2944812-1-cuigaosheng1@huawei.com>
Date:   Fri, 25 Nov 2022 19:31:18 -0500
In-Reply-To: <20221117035100.2944812-1-cuigaosheng1@huawei.com> (Gaosheng
        Cui's message of "Thu, 17 Nov 2022 11:51:00 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 993a54c4-22b4-4acb-52ca-08dacf458a8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6hzU2i19PRjK+H5usDjnspwm0TpQL3loEVyEnrRuTVmno08s3BGsLG4i/cDzKc4ekXF8yF0+Y1DWF9qXpcRpMZ6eO2Y7m0JyTEeOkKFJy8OCd2yXTRHsb2d7Ccc4Xa7Z2gIWUeaz7tIzvxCd+fV/iNEqhPTG7kafWxbhMTz4eLgpGcmFi716wefHa02YPPrw0/ooysDg/itEy3Bt0z9pqgmab2H9xamtdIuYTAiOgCuzuQtDyWWwhzcgwuRSXIcQMeW9EdS3anU7OVrIBj+nUCxzfYGiGOksk2dhNDqZkDyAIHzx0+KomAw4iNVZSzzPx9j8GXZJ/CcaGZaCAagxL64PdlNFHBTR7M60u7Vp+r3Xe7zirz6tx8XYNr7aw8+sET24s3GzNohqBYAdtfriSbkIgXJ6WIPykXEzoELCNSnTM5G8Jb9yuggr8BsHUZKwW0ELzQRWdan+iLD9ylqEuCUDdeOS3vyH7xU0qiDotOEi3NQzYpquOqf67xYXtYbun7hAAPtAXgoNwJF0JVwGAklLDahX+X6O0WeQ+5UW7P1YUpCZg/p6kssNv7TedX/AdcrqJmdfejs/vTgjb7vcqUhqYrgqJU11tbfJyjbVDQbohfqz5PclmbHNtvd2cW43vitqNZPVyVXgfC6o6rvmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199015)(8676002)(83380400001)(2906002)(86362001)(558084003)(66946007)(66556008)(41300700001)(66476007)(54906003)(38100700002)(6512007)(8936002)(5660300002)(4326008)(26005)(6916009)(6506007)(6666004)(316002)(6486002)(186003)(478600001)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VlNRCRnBP9ezF7zURhS2W5TtYz3R1ztl2v9gWORDIgKOvlmOxXvJe52u1UJa?=
 =?us-ascii?Q?k91pFLwXBwCS3U09Wjm8PNn0LSI4Bj3uKN2BD5BNsQwWLuNM/RAdI/uciB7I?=
 =?us-ascii?Q?nAiUYfm39xadFt0D/W1k8P1RsiUEtE3za87hnaV3qfBy43aQHfzlcFPr+WDv?=
 =?us-ascii?Q?OQ1E0d5A/BOBt+a26VbALe6wGmGorz6eUYK633JnRjsVsFzaEPNDsuJSmrD8?=
 =?us-ascii?Q?MhQ5j5j7h92D+7m/e5EkAfNFWggbF/4mKyv/z+oyxHzQjeWOORhIXBftQc6O?=
 =?us-ascii?Q?rd6G6FRNbR9GxsDf6WOJHz5Uvs3kJY3IQoX4il3t//KxeBAh1vrTpBt7SFMR?=
 =?us-ascii?Q?HWQZ1HZhO/Qh29pjeFVI4laEEj9nv3rI77IPK3QKv6O0stmoSI7rPGZAtivi?=
 =?us-ascii?Q?k82nqx5X4JOhx64Wfmpv9Owi84tF9rmRbtG0nBPRrjcW2malOrB7+2LivgHv?=
 =?us-ascii?Q?w9Dwekd0RFqLFyAbFwzo+iUWmgAmau96t1R+oO9NQUREifrMJqT6Qk/TAG6Y?=
 =?us-ascii?Q?B5NAEd5etPfESSxYiYJKe65sO/SonUcG1AJ9+j1ISYjBj7rj7C9n5ekLChLL?=
 =?us-ascii?Q?6ZUkApT4lF4L6hhlznDdsnr4lQ3CD0NUhEd95gL8Ohh/SYQcNzErCW3c668C?=
 =?us-ascii?Q?WYaJsrXJVzjiX5VUjIA0uKuEbqDrVhera6LL1psEyxfT4A2h0cL1dR/XJwL7?=
 =?us-ascii?Q?kQbPHbNy2+3w2L1K2Wt2vYX55Po1XDhCoFt+zu0MYkaKtpzsLz9AGh0DFGxl?=
 =?us-ascii?Q?6reB7bLvFtDO9aepH5UnPwdmHyrsKklh6Xw/d5fl6VlFt41hQz7pmeQe2lh0?=
 =?us-ascii?Q?YHvy0+uw/AZY865nde74q5nNnTP8gEf4RaHsqYrPquQTnsaUqCZNujyC+ErJ?=
 =?us-ascii?Q?f3JyequhSYDRsXMB2dlrr1JWVE7Ru0k3ZZQP2RV3S4Ch6xw6CKzzh16JhpRz?=
 =?us-ascii?Q?8OYFGsd717/c4/EZlbeOUGsR1pHxFedVPxow7sGzYwbEeS2YQqf3WIArq9O7?=
 =?us-ascii?Q?oeymPpUrlqkDX5t8aMeSF02gK2OSflf1II7HKl+lpb1UYmgJ/d6Ss2ij7Q1E?=
 =?us-ascii?Q?MGnENApPUYuUv6DCgGPaTJ2Ar4oln48GpNxvpDqXpmnSeMYsdkv2yqZ2RWBc?=
 =?us-ascii?Q?3qnzgzsDEWzHLXxwjSfnRbjLQ/pdO8gHvFcuU3keDp8N84hNEoeteA9Mp5i8?=
 =?us-ascii?Q?K9RDOpLTq9SSKUV+0pWBaQr9vTSKtIJoD8IghnUD7Xqn51J4j44rzCKErsAW?=
 =?us-ascii?Q?lNrn8h9bA1kHM7yKUEb6y80iWPYkKicawM7fYCgcLmpYXATENScKFPv4oxTv?=
 =?us-ascii?Q?PZ6not4ptu5i0LQxfa72IrNG2Y8yxTeC6Jxr+Km1KRBworn9yBdcXLQjxxmO?=
 =?us-ascii?Q?oOPz9tuiqW8czWu2+f0LQxKv/XEraMtDMrMIFH3PvNyVkcQXjyXFuTuujEiJ?=
 =?us-ascii?Q?bUgfE6wYX1zIx5yxnCytQsTWn69uVOKIi7B2mlQmXlCyTZEwJlzqcFsb/C1c?=
 =?us-ascii?Q?dlXUAM2DiDzNox039f26ZXPwhZjFkjgtzsQyhQ09mrasbdkCRDMrNiBa9B4D?=
 =?us-ascii?Q?MPSG7KtC4uDqP+0Ih0sGtg7/IRkhbz/XjKdYKoiPR+8JU7MAaiWvlOFY7rXJ?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?BduGNrpi/+twgS381wKXHbt09fGH7C62w2vWyeer4PpCfUa5hnyJb5nyjZdy?=
 =?us-ascii?Q?9igBA8QI9KyTSsAP7tCzEvzr6ELIcKj+VhmVJNwNbmWPtmx41Inkk7OhLZuR?=
 =?us-ascii?Q?TQPlP9f4nRm87g69lF/3oYEi9xwlPaCCwJgIT30SbxLQoar3yHTWTmmWPbJV?=
 =?us-ascii?Q?PBzXag9qVaplSon/gnZGrHLgmTdrtWEi8ubryeLJNj/jLaERzj+lSdDj7gSj?=
 =?us-ascii?Q?e9hKRO++ITsm395kn/IYN6CnFKUdNWBlBp1yKefBkxqAm+G4Fb0o0sHAJGpm?=
 =?us-ascii?Q?Vb6r6NLZ44ofbDyw/YsxoyFD52A8XA1O2nuIwT1vawjvd93t/jCdmyYIB2r8?=
 =?us-ascii?Q?DSztnqKZP24YIiHbqefYqZwIihfQHqwln2ELZhdYLamTNRoCJItJNRh7HSh4?=
 =?us-ascii?Q?1VEEkVvb80Lr/yiMLXK4hj/PCRGG2kGku9nPibxI3+061y7kW6EVONpO5B6U?=
 =?us-ascii?Q?DPvDowvSAuH21c+itEC2wIBlPyedQInBatJBGrnx7ifikiFTFNL1En6s3RWP?=
 =?us-ascii?Q?6jfl484jtQ2/t7cG3FdgjxMa3W6AuQFuFZSFymPfCNOC6Sfu22z5JSQ7MloM?=
 =?us-ascii?Q?1jUpxS9i4riOmXN05XI3bMDuwAtyuIRZYGJVXNOtaIZnAsy1zr8T2vD+U1e7?=
 =?us-ascii?Q?bCp/HkoG+YJu4HZJLqftOD92fdQ+GiDJZn1OIO2fyN38Kgvd25BEXx9zdre0?=
 =?us-ascii?Q?20dULvyQUZdc5zQ+RAQNlNY10ZNXtjts/pZoxhIJnDjV+XWWiKAdk1xJS/ZO?=
 =?us-ascii?Q?JXHp+mCtcCWgqn3yebPBW/Cc7VcF54ogc0hcSTowF3BAv9puUomSD/M6kLBp?=
 =?us-ascii?Q?qw8TbFUi4gWdXA3P5r0UY6D7i6/BgDxI9q46QvwdsR27oq3qauxbn3hdW8yj?=
 =?us-ascii?Q?89LhyrNgBS709tpU2ETGYg77+p79XXHuBH8UcokSrFgMifXD4lABYumnl/dr?=
 =?us-ascii?Q?XslIT4nKeuw6m8LZDKVeFw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 993a54c4-22b4-4acb-52ca-08dacf458a8c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 00:31:21.2523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/fYyzYBLG9Uk06iwj1DtT5pooHk2jKPr/C5Bjgm9sfsekF+UtM25m9PW709nIalP+PXFUrmtrLJkyXnHyzZP+php7XsqWUg9aPgEWIVaYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_12,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=739 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211260001
X-Proofpoint-GUID: X58SaTsJ2JcziF4Yd1-fkakEVwwCKn1j
X-Proofpoint-ORIG-GUID: X58SaTsJ2JcziF4Yd1-fkakEVwwCKn1j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gaosheng,

> Smatch report warning as follows:
>
> drivers/scsi/snic/snic_disc.c:307 snic_tgt_create() warn:
>   '&tgt->list' not removed from list

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
