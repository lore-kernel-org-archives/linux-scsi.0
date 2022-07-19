Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C473DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 02:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbiGSCjl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 22:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiGSCjk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 22:39:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC772528F
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 19:39:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IKn7Gg023357;
        Tue, 19 Jul 2022 02:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=/DtyBxQIudnVwaX4Y2QIjRb13DwOMd4clTAYMCBIa90=;
 b=dEynFYtOA7Uv8hrCUngsTSx36Wypxcfi096xQxPe+FPRmPcHTSJvP/pCGvXdS3NoHJtl
 F535MR9kRYjfnshyxdmvEqBvil80Eg6EzIasyueX86azXRw1mcE4ZCotL58SqH9m2Ev+
 GAPqH6Dkclx1ubxaIOstB3RL+qKzV/vjaNdXMxkXlkdHerWafSUbxCyaYKp5FE02k1HD
 16r8PbVwRetEHV/g0AVgT52JMPmdVCSGdVKXo13CW+DVrDMBeeB0DxXbi+2gCv7LwNOM
 iwN1pFyLCkoW8qvIEk+72NNRMUQLwRZ7fw6kbup8b9wBSQmCesNJ9Z0lEtFd+3/JTCdv yg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvtcwuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 02:39:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26J1UXGK007895;
        Tue, 19 Jul 2022 02:39:26 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1em458t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 02:39:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdzbabKS89yPuLQ6Y+F7in7344fQuGKYOXvb7DXvIUi8s/ENMm/E5WWgBRrEmUecFHuZeXRvX4NJB6TKG624D/SYw7OGgvkXan6yXUQCT8aJ23HjOE4t/nj8ItiVTKooa6x8e9ZJA2P7AyAHp2yEXyXdRvtuzscughC5+0bbKIQ7ZYiRBGEywmMfEGokpSaf8jHKUM69Xe8NFuBz5eFfcDlOZ0mP7Ygr3Dq0KRWSb4CQ+LQ1MaiBl2Ige5VjxPXRvA7BBZa3Ltnfx94dRZ9xSh0xFvEUFAQmLbX71zvmmi1saLauDd3EUvqB8WbZDGOWeLu62P5uZWcphS6MeAzHrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DtyBxQIudnVwaX4Y2QIjRb13DwOMd4clTAYMCBIa90=;
 b=gSsjjSn8jswqY3tBFOf6CzR5eEPoniEwsAP2L/C9YttvR34UJDgeckn4hVFmQc2LaZrGkoHG8+rH5b9PFViGedMTn7JtErN9IGuLbcLtslvsu6IJw8dXQkqTEWANnynmDdMjHqz8+dO5x4Xa34GwJkKAMBdYH4255ukB1S3EnpK5G8rTL533xtTYHJ5nIn/gFjyyi/A5+XSHc6aahiVokvB5Uk44rscEtAVN7fyi1PpRTeSMd3hPnYqf7mVkb/sDR1shZ5IYZTOMnwaJxNUIZTFjeJkA6sPKlwL4nT98siAtnBsXDJlVqpjchCdSNQotxzV/G+IPF8l41+KO+lEU5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DtyBxQIudnVwaX4Y2QIjRb13DwOMd4clTAYMCBIa90=;
 b=DKV1lbQLHQB6NhY6axQy7ctQefrQWbJp03wAbglJm2ROQR2EsSWYcNL9HZSG3G3KTq8K0W0l/0aUVuQ4R/kZnvluEBB45E46cW+7MbZmoHe8kUcm5g4Hl+eu4EwEhksZRSgDViRKGsr29A7vmtTzijvqGqiz8Iu7gGmSZpDG1O4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5206.namprd10.prod.outlook.com (2603:10b6:408:127::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Tue, 19 Jul
 2022 02:39:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 02:39:24 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2 1/1] mpi3mr: Fix compilation errors observed on i386
 arch
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135exrfle.fsf@ca-mkp.ca.oracle.com>
References: <20220718095351.15868-1-sreekanth.reddy@broadcom.com>
        <20220718095351.15868-2-sreekanth.reddy@broadcom.com>
Date:   Mon, 18 Jul 2022 22:39:20 -0400
In-Reply-To: <20220718095351.15868-2-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Mon, 18 Jul 2022 15:23:51 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0046.namprd11.prod.outlook.com
 (2603:10b6:806:d0::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 366d29ec-a6a3-4228-e335-08da692fe49c
X-MS-TrafficTypeDiagnostic: BN0PR10MB5206:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jp/Yn7v4Djc4w7r01gHLZK8mEQ/GY9/68hiwSql70TL71OmzP0+qFWH78QFy8kl3LZRW0evn/RivY7DieqWCkpdm2lT+ECHk5BeLgr23emnlb5rsTu6BQgPYq9D1GGoyU8nxz6BCc1uGEN7SAyUTfF5fAIXiS+wckmfo3a118aCDBfe1DQqizDUnhSQcQLLxjimuBEskHtuImL5ACh3fgFWpOmjKmCiDULk/8J6uCfbmd/64keWBtbFbOmc7SydAqTLZ4vtwX2cuPr5YLhPdeDc7jTqt5bnYJpsU/2rt3rOcqZ1Hjkgmvetsc5ud+ng6McfAk0CQ1TbMxAn4+2+m7I9XsQceE3npOEOC1rKzsqoJ8sqFEbAMqGNwHAfSCMnpwYBiP/boBDOH6+eZVAJtrLdms8OVD7yZYJCtd2RihmpaEC81LTiiY74pUIxiOpYYIe1/cjZ9srF3HFzoL54PcMrm49lo7sZgCKjpN7L0Ysl1p1SqqbhHK/+7vkHycrOBWmMU/H3BNGO6RxHgjfnV7/+AdV6NXZyhp58Ba+d8wqCO06RtKlxxAG65bJxnjWM5Ayjg3DtHlBkzEp+yFLLZaOJv5MSI+Wdj16AgwrgNPchdcf8Ks2frkFhxiutsNS43z36mFbOj3AYojyPRzgE7L+NJxR23dv93XrBUKdMmWJY66h7ZnqWGHO3Y/FB+aW/v39vbn2qetdQkcYAb+LeZTGdJHj/aa9vbzLWsOeOD15mzMjpqq1G2mowBeHUXKaGCEycQfwBdIuRQdzL+cSRlPBdTGM1OLJ/AGBea7pqLNMRkj2FzlJMURNKW/045xo1qbQnZo86H/NUoDQDyokGTdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(346002)(396003)(39860400002)(5660300002)(478600001)(8936002)(66946007)(66476007)(6486002)(4326008)(8676002)(66556008)(6916009)(316002)(86362001)(6506007)(38100700002)(52116002)(2906002)(36916002)(26005)(6512007)(41300700001)(6666004)(558084003)(186003)(38350700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ppSHKSQykdM8wU4HYa/7v6rfOSTkyi/l3mQYEp53m+dlD3dEUNPhfTu93Pyi?=
 =?us-ascii?Q?W6Bn2uNnUt5qzDqYkGGAXMtMahiXAHNAoA9SD0eLbrb+qrsGT3y9gpltmhHR?=
 =?us-ascii?Q?KJWdC+lk2i28/1t+lAtYjwUyzVxVnDawV72Z4Y73tPq2tERAYutjvBMaD6Jc?=
 =?us-ascii?Q?mX10Cm5evMlFAmzMMEygglejE43HXQe5SxG9XkARG7zolkbIK3rm+KfMUWUC?=
 =?us-ascii?Q?6Me3b7tFKvCk5Wcxn5P8OU7H9PA47yiY1aZIeBVC9z9BiNWUOSclp5+idq9L?=
 =?us-ascii?Q?6mQAbfFV6us7/0FwNLrf7dNlkndMNHQqHkWNkpS5xATqhJCY3hdM2mkb6USY?=
 =?us-ascii?Q?IKPCcMxvUBZsPcFICZiqeJ3CGJifROzuBWWtrYeYh1T+71Qvu0g8GGhaAyr/?=
 =?us-ascii?Q?tBh5VQM4Qd8UQZSJBkEPvkXq3PNa4UKYew5auGFp5B4mwqoBKYw3eDC5yj28?=
 =?us-ascii?Q?vYTmDdEXOHskQBBS1Le/6LcIrA9imFh1S1ybvzvmyL50pHkUaxwamSjBAuvf?=
 =?us-ascii?Q?PnbhaCOpwCOa3u24RtFIPtudAeNhpmfkUT0orvGgGHKxoSncMhrpCeRArh3U?=
 =?us-ascii?Q?KQVbU4gi7xyTxwo0vCaEkVxtK1WM0wfwspUlptihnbdjJl3t90CvhWDDIGim?=
 =?us-ascii?Q?IRRTfXN1lnJBN2o7omSc9RRVCf5QdbCykJw5I1JcIbyVdFXVtWk2zQ99ivwc?=
 =?us-ascii?Q?I8llamT5z5abgAamYBLWmyxY80BdUjKi9y7455vYQvLttziwMT1JkNvcvFta?=
 =?us-ascii?Q?i3GnWx8jYc70ZUjjfEw0RWtd1zbcxMriTH3PqePtK/HtHl+y2ObOVv+xVBYS?=
 =?us-ascii?Q?1kF1qUJctB9viySrXGUhkaBdBJfoJS017T0QjVvNHD/y9f5bQ9d+QSagsxQA?=
 =?us-ascii?Q?hBBsooWd4wbtwmg9zjoDHHpe0/q/QHjZzC5EcO2oyi0/q4TKh+HzTHl/7hQI?=
 =?us-ascii?Q?ng1eVeEFxj7elY0fIvNObDUgnVht7DsxgSVFGXvbJeTzKY3FRgL1gryG9oWr?=
 =?us-ascii?Q?RP3lqtiGyYVrWZs4zDy62vd/1399B00UL6oorBjZGAAAm643HUcdzm1r93qN?=
 =?us-ascii?Q?EHotlIsKOg/kZoc48lraFgbyZleCbqLzSCotT+Mx5LeZ9cZYSEMuCxHHMzD9?=
 =?us-ascii?Q?x0Uh0ty08wkcXv0RXK9G91pfHe3i9Lm4c7wCvvHBXbADEx8Mf3KZFBe/HYHa?=
 =?us-ascii?Q?8u/I6cDljsP8ihUiqNsEARwp+az1yfpWGXx9jFyQ4dLyZKhczQQ5Orkcqkcm?=
 =?us-ascii?Q?+mUjtVCKsE8oPNFF9YKc87FfGyv+bq/aOb2aF5ydKxdHDKpH3fV5RDuKg98Y?=
 =?us-ascii?Q?z9j/ZpqitbcDfqG1eI2GIYP7aca5uMTvOx9S86k+3Q1+3SEh9+llxPpjEvn8?=
 =?us-ascii?Q?Xc+K0K5X0/0YeJaMHYjtXgaOOKvYPZLqwIXvIo0SFRzu1tttRpZ3hkqoXBpK?=
 =?us-ascii?Q?TtHOmQS8Gv/iTZRFoS1eYZuYXj2ftYiZwE3hMXHZQZ7AyvVpXYyS5QfrRviH?=
 =?us-ascii?Q?As6rq89hBVKtNy8YM3+Hjnx+eTG2aqE1HISykAPKrn7X3PKJiOOqsSHrnBy4?=
 =?us-ascii?Q?iS3vaAhXtVANbOZuZ8V7oZUF5jBVBekRst9wwu8yPKAlvmsPsPqFDtzWz92N?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 366d29ec-a6a3-4228-e335-08da692fe49c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 02:39:24.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QyVjFqrZIl2MwnbYO7Yo4SSuor2Hxx3QL7kRvGj4JAHChf2XYgwpRea7vVolIQmAZmSkqBYjvUgIhQJYr6lE5+0P7TbyZJd83Q85dV1ql+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5206
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=693
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190008
X-Proofpoint-GUID: T6WYbppBPoodCJ_1vgM3fqONPMTNr8DN
X-Proofpoint-ORIG-GUID: T6WYbppBPoodCJ_1vgM3fqONPMTNr8DN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Fix below compilation errors observed on i386 ARCH,

Amended 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
