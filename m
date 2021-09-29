Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71743C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F796613CE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241936AbhI2Dlp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:41:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55462 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239755AbhI2Dlo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 23:41:44 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T29Ix7027595;
        Wed, 29 Sep 2021 03:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=VtsAmn/r62nNgsDTEvRN2PU2efGKdhLCZmtj6GpUZSA=;
 b=fZqgxqcVgkERwYB6oqZOkt3yH4FTq4cLtfdQPaZXVY251WI+oRuNtI3VfNN5yKGfKSv9
 USScHWKP1QP+YBmDgRzBkHeQqt04O7htri2B7JDN7QaYxBm7NxAwk6KsA5xTPLUYIOLu
 1DQ1rtksbqVOn2Bm9C+OftuGfoVOeaVbJghdSAe3dQdXnNEiBaiSxF4rOyxsoSvvPqEq
 2vJs32Rqu2LYNkMIoUwL4T3oifwxBQtPQUP/eUCpAA8Blj5Q4G+WafoLSE8QITbdmuGZ
 buJ4e66tlZASDOQe89NjeSGTGwvOwgK8ygvfqgpTW8GkFgS0/sUHmFQ9FKiX3XtrPwK5 bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbhvc4b5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:40:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T3Yu93068830;
        Wed, 29 Sep 2021 03:40:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3030.oracle.com with ESMTP id 3bc4k8ng8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:40:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRNDOskBxCrMnxSuieRyCoDJnepBFnTwk4rf9SexSGFz2Lwora3x25dBIXAf53eUAlv+UG9k48v0M166ZL+BCSJRny+z4uqosTdjFxKjggR9VKNT0iYqDEb6fNLhMGAKayr8I2hD0ai3hK3KtRe5jHY3G9JeGxhoLoZJ+nprTgjdBpw/F5hY5v256DUWHK7tH9QR7Kh2T65JsLhiu9rm/v+fI8+PBYg+2iGyzF8z/PtpMfwjUCXT0XchL3QmYdFrFLOd6ZDEhXLve2hgz0Ag3awNYLRk7ukaKbeZ8vsTgynnOW5zFUga4x18m11hUtRBZmdgOTNA+0uHdzNTj4boXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VtsAmn/r62nNgsDTEvRN2PU2efGKdhLCZmtj6GpUZSA=;
 b=V8SJv5nEfdQLMYOEBi7f4Pde2UPuqLrdXkx9g+oEqC7QZSxg06aotgmZ4ReUgcyfKpwA+7gf7cYv7zdDsXYe0vzTvlF/FfwdlbHs4AI8N4qdvfSGc3P4ko4OkNtldh6lC1kszHPzb/Uab5fu2KS59VSbSZROEjNjmLm3/7fI18cFQJ8GJGLKUwhe17PIDXC94+yMOO+GjrdmKfdDVlFIl+CpMy+9kOyvTcuV278fEGxkhJbEI3/bw79OubNsxizQ6dFhGsDYeqfmn0cwWjyWWFKKXHBkFoxuXcgAY9cfxKoHyfqUguUJnzFnH2GJFrrPZdl3/krHkBw3V8M6QN6RAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtsAmn/r62nNgsDTEvRN2PU2efGKdhLCZmtj6GpUZSA=;
 b=Gd0Tfy7LLmayzsT8vDf1Xa6d7AKz2bukUAhaqadajZXY4bJc8munrmTIVCSea3vJuECEHl1tgmhInBYhyGnXdO7r7uzjUtFHLTN5FR8jcArzpn2F8swwYbE1j3hIxTZaCkEUG0pTCSt0oth5IyWEG7YL6fU9FebdeCkyH3BKNcY=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 03:39:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 03:39:58 +0000
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     james.smart@broadcom.com, ram.vegesna@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: switch from 'pci_' to 'dma_' API
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnn0dp8c.fsf@ca-mkp.ca.oracle.com>
References: <3899b1ed4abac581c30845d82f33ec6df8b38976.1629633207.git.christophe.jaillet@wanadoo.fr>
Date:   Tue, 28 Sep 2021 23:39:55 -0400
In-Reply-To: <3899b1ed4abac581c30845d82f33ec6df8b38976.1629633207.git.christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sun, 22 Aug 2021 13:55:33 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0195.namprd13.prod.outlook.com
 (2603:10b6:208:2be::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by BL1PR13CA0195.namprd13.prod.outlook.com (2603:10b6:208:2be::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Wed, 29 Sep 2021 03:39:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 703b3ea9-bc0a-48aa-9e45-08d982facf82
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB455247AB8FCBDAC17284FB3D8EA99@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +BcSfQJ2mc6KQrae92qxe68a3OcAaBem7HJU8XOZ/fg9LjQOsGXAZY8h6UkOEAxWD8jsmgjolmPeqWmv+JdepX+uaYP4xotyuvZzIOLIYuysjnhmd9uxod1mxmgtOS60ArTWR3elk18mJ9gZR99RKdvKwKMQhcyxaH67CJ8rVmZuZfi6APhD8vIQzVB1oybA+ov0sUCWZXiEPay0gymUjD5gLNzmfbPFpc2cDxOrTCCeZB0O0gD+sOLL+J/DYRNQromWwB8IndvCxuiYIOvc5QRvJ4zZ/d+G10isNwQM3HWn8LiUGbZboknWCL4e1NgyTDsd1VENeDMO/uaPynTSra9yn5IH7/99WyBsJxlWZDrljWncYOBK8fazaAHbMbkNFAWIbi2PfEIQAEA3544jNHC9HsbOF1O0/mgt7ug5zleuSgr06qVDXaXBH+JLRsOscDcbsymGKElhsofFQcYUjC/y3CHWJWOlWQaW+JgtyGx9rbkqjCnc6pkqTXOTjodf/kWM8Jy9zUeYAS01U0wxAKarBnsSCdBQNwUK/ZxYIkVB4PaGK6eZv3Y2cu/riQTW5T+nrJ53p5aDMeDJ7SW29PUG17Qtcu/z4hmml2VjKjWZGZlno7WNBGAmnEQky8f74JmqtXHKfvEK5it2DbeyEUdI1re3YZAuzc78LJsod7uLtsYuDkFn1mlKCJqTp3Z2Ic9xf7K3n/tVzJCzlSOBTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(38100700002)(8936002)(5660300002)(8676002)(956004)(508600001)(4326008)(86362001)(2906002)(38350700002)(316002)(66556008)(66476007)(55016002)(558084003)(36916002)(6916009)(186003)(6666004)(52116002)(7696005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6eHmG2+r8u93sCL7pyQFidYAG9hpk8cMdCAWosv1R+zt0Hw4JBCH5Jnx4n+V?=
 =?us-ascii?Q?FdSlizJ/G3l2KPHaLBXBV2w6dxKuG2stOa2oo/wKvojKZetY6RWyS2Ft/BgQ?=
 =?us-ascii?Q?kkRtxss85eDOmivsSMxl79VcMtCGCgnhPizEpaKzE9mEKTmHpPZKS0Ecq127?=
 =?us-ascii?Q?18dLL5Tud5qwM6vQ31IHMlDUdNCvRtDRbiRhiHb8UALI9Tg+tP1Hkg3PIszw?=
 =?us-ascii?Q?OAo2o0XGCVxqxeupjDF95T+p37cJdw/GTK0LNPRCv6G9vy/0leZ68X93jGHQ?=
 =?us-ascii?Q?K9gPW2D/H3B8yL2gnWiMrcdCB68NLIHLVgJtJez0rhV31aaUhABI8wQH8tLh?=
 =?us-ascii?Q?zYj2PaIIGNcFaPY7LYLZlJPut8ot2J/7rJrDMf6PDv9KcJ6fQeMdr0RWiUhA?=
 =?us-ascii?Q?mMefbImAhycMY6be4nKv3ol8k/0UBySsr0Eod1OXCdyy83oxmP1Ihnm58an1?=
 =?us-ascii?Q?Wt9MDDs8/hg+/oTs/rS8v6hWI0MD5EgYbMef0af+pgk5grWKoV+ba0/FLHdT?=
 =?us-ascii?Q?e0iRnTyB2YfR8itNHfJVZvJJCvdazGzQ017o2HbOZIPzn74Pd8mMnfT//x49?=
 =?us-ascii?Q?vu6uLjPu0d7rTvOKVRnhWseI8JrhE3+ztH1V08HuvmRK1wcP3q04vzekZX0m?=
 =?us-ascii?Q?u21wA+qkJRWkWZGI92k1lbF7wqKUllG07mg518nnuucwSYtx7UcheBqT11Zg?=
 =?us-ascii?Q?bH56gf9leWsCDFq2esiTgCPxhIZmgZ+VJ5FPqoGrjR7opCbxsQxiIaGLPXm4?=
 =?us-ascii?Q?m+XPH2KNJXK0Lo55Mlvu4pcq42ZaQdpIfH7DSz7lbCbN+ikyde0mDVbYA+sM?=
 =?us-ascii?Q?qXGPBsPbpUEskF/uizvss+DN8rsoPTxAXV5W4lWN44o8YXCdEHC7TeQGXY2f?=
 =?us-ascii?Q?XGGlDSOZU5O3ZsZAA43DbdzmJySFNej4X9pTZ5yG0VhqXIk+yhuDp/WFgHAm?=
 =?us-ascii?Q?jxfaZByJHa+lfVlpBAl3j1ELJ/NZPDtRFAzR6O6kcON81n6ey7EnuYLW6IEi?=
 =?us-ascii?Q?HFxw3w4EUjhbEQarTy78tuDfETRNlVkQFiimL5Dt1v3oKxEpBqzc/FkE1dS0?=
 =?us-ascii?Q?6/bMYGbbww4BmmPUG5iZJdHSvvOn4t2TikVn6AqI9gF/JuYM9duL7l4QX+dz?=
 =?us-ascii?Q?PCU6fXWki6vKMxEXUkJP4SDuB7otZCpq1h+Niov8OcLPP5xGeKdU2uOO31yM?=
 =?us-ascii?Q?XKxEdJywjakNEqszdFWflajcYBL08qUpVOSFl1bZsdlCBFhIM1CqYZOCD7WF?=
 =?us-ascii?Q?r5JM5MdmxCZjuHq+Cjv2CW/nHUrJuQnWNm1tA984BQiT/6TB7Z20FS4aRUI9?=
 =?us-ascii?Q?TRF76ZbK39jw3LMSnvKcgiul?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 703b3ea9-bc0a-48aa-9e45-08d982facf82
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 03:39:58.5281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: teatlzWkghR0zKhbXJeUJpQmhV5wSYJb6hB6t8QocudRsRsa3qnuCNwc4W+9UhXPwIYy2MVDTGIb/qeRpYQNdRGVH0gOViwPBAoDt3inmzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=853 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290020
X-Proofpoint-ORIG-GUID: 5xzam_WBWam3zmHgqtp9ZWP_YCvHdhia
X-Proofpoint-GUID: 5xzam_WBWam3zmHgqtp9ZWP_YCvHdhia
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christophe,

> The wrappers in include/linux/pci-dma-compat.h should go away.
>
> The patch has been generated with the coccinelle script below.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
