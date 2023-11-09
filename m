Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2384AC4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Nov 2023 02:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjKICsM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Nov 2023 21:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjKICsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2023 21:48:11 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542DD1BFF
        for <linux-scsi@vger.kernel.org>; Wed,  8 Nov 2023 18:48:09 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A91iVEH018586;
        Thu, 9 Nov 2023 02:47:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=3oEwAIsSrPXNlFgpxjYL+qAenBpb7oFkrPWRVqjgAAo=;
 b=BzT4bG0RyOKB1T1SdHvBmyiNhlzM0fnS7KwZbfh+r1ryrMmKXxAtTvCqF91LRVGwmGbG
 zxjtndhY/CWmzyfwz37wy4F+q5qwJQBylAo3gjfOBMLpdfndbamOa1t3bXvR+jC+wJcd
 8mB9Qc5+5Czx7J4QKJbIyuVnsMREj073BXqWEA9v3mrNmzuhbbsmFZi2Tj+C4lOM3OOX
 0M9JueItSKQFZCtNYCYtLm8I6j16xm2Xd44Pq3z0GpumtOc6zgYxGhR1SUX0p8jT8nvu
 JPILT//19234bSN6sj5Oipow/oI4Qc+Lrt2J8f59s3dm11OK7b/V9Cm1C8dmb0RjP4kJ ZQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w23k0ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Nov 2023 02:47:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A92YUlR024207;
        Thu, 9 Nov 2023 02:47:56 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w260wuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Nov 2023 02:47:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtEq/kq+1tQXj8J5dqlJMxVyFoU5UMCFbBcN1lsAln0CUkz50XCKYvkC7Tgix2BRqDBtWLj+ljIAmR8JARzNPbBV5neiCMNrJ2ukDHTnbLURNzEBhK3XmsWGyjr3efriT3QyU3oMIVsEK6AOmF89ZT/TxM/S4eRJgOaiMPOkDY+31gyW1DDwXCFzMKJ3+WFyxkUh8Xo7WzfBPngQ3o8JhcnM4eSBPrTtYQkLLeamSz52+NWTo+jPPox8ktCqCSGm3loUKnmTVDdwT1RJLcTrd6QxzjBjPJDrla9HRal6oxGo2QJeFK9hQ1lLR7bFQGSz+lJb1mMTc0f7WkKTOQ4X7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3oEwAIsSrPXNlFgpxjYL+qAenBpb7oFkrPWRVqjgAAo=;
 b=Sak5D/vJKlgZ/efzW62uOU4YQgr1lWA8FHOwRAiXraqe939PBMtp4MvYYAqKE910jbkuuY9A4TFcJtR/glBPwdo0/YsVk6ygugkMrrXAR8BB4bRWJOv8GsjXzGzB/AjXKGtNzwA0BuhTpUNb8o3ptyM3vab10nDIj2nDnL8H9CdIkVJlB5HL5e3oN39EVfbLi7Jk9xDK/gCXhBXm5WZrtX01CVouIXGStyvBmHh3ZuzwgWF5gd/ACD3QXUtzNTDBF9v4R6xpU/fJ/ZcY4MbesltxQdC+Jl6/luA0H2RLXflobkX6zLZPIu8wo7aJLbEZhkPci1PqDi5/V73gnntJJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3oEwAIsSrPXNlFgpxjYL+qAenBpb7oFkrPWRVqjgAAo=;
 b=Un+3VIkQFvubeRZHRRGxiEtjP6/Oy6Jo4oAsdmzzWDGfRHLffMp8Mz4prv01uo4SJou+QwkOHig0hgsNW9+rPFI1SuNongy9HFUKXOEzGa/ITYOC6cYh+piZue4CMQoR6IUZqzdXnRaeaGlL/e4KD7ZNiS98uOs5LoaAjCRphLg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5179.namprd10.prod.outlook.com (2603:10b6:610:c7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Thu, 9 Nov
 2023 02:47:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::abe0:e274:435c:5660%4]) with mapi id 15.20.6977.018; Thu, 9 Nov 2023
 02:47:55 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     mwilck@suse.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH 1/1] scsi: sd: Fix sshdr use in sd_suspend_common
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zfzn4p8a.fsf@ca-mkp.ca.oracle.com>
References: <20231106231304.5694-1-michael.christie@oracle.com>
        <20231106231304.5694-2-michael.christie@oracle.com>
Date:   Wed, 08 Nov 2023 21:47:52 -0500
In-Reply-To: <20231106231304.5694-2-michael.christie@oracle.com> (Mike
        Christie's message of "Mon, 6 Nov 2023 17:13:04 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0249.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5179:EE_
X-MS-Office365-Filtering-Correlation-Id: abb2d7f9-9b35-4984-66db-08dbe0ce4620
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJdbGMK2eIiifvBIddAfX8/Tig3QxtOVtn/8fuFyK5dNu0msOFC8TH1zT9CJabrpkTMOiWyy1oF+bcl5DBan74avx+TbBARrowA+P6QhqZNvKIe7AVSVRZ/N+STvMB2sOAh5J8Nn1zGqkr+NOOHNGmEAbrE9MCg9h0waVTAMJraR54rlr8bOd5GujznllkqUWFNObtmDMkzuN/kugjhah5eP3jkyHg97chSppNoCb66qRK74rkur9a43gOYK7NVdNv9NMKhcfy/DWwm6ePuOs0c7+fH4jYlJAVFvcY6Ib83l7pQMhh+qV6YZfD2BEOK4JdEFmXIoLYvmSU4v1F3aeRrAmRiO9FeKIuGr7l/CaYR+0peuOd9GhuAwjpBW/CJSzpfthUWcWvag8zi5H+9f23djg11HxSzc7c39voNJGyIMmmhqbsNFXCdg8zmH2CqlnJiz1v3L0yJEQTDd4SP5LMnEKkxRdq9RS5QHL7k/IXgGMcFpmn5dfCx4GuBRiswXMDmnwHaCFtNAuzT+R/JjyvPwJ4qMLI0sPeJgJX9Kdyw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(396003)(366004)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(6512007)(41300700001)(36916002)(6666004)(6506007)(38100700002)(86362001)(83380400001)(26005)(316002)(6636002)(66946007)(66476007)(66556008)(5660300002)(8676002)(6486002)(8936002)(2906002)(4744005)(4326008)(6862004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+mDVFbRqywxeXIXUc4aHfktYvum2gOhYNx5JZRhp5XlJI1pWe6RPgidvDE3S?=
 =?us-ascii?Q?QtdjU/0xSs42kUl1vexcAZyFv33Q4eLcuMaeWBL4DzQR3wDwxAlZtTpYZ+j8?=
 =?us-ascii?Q?RsB/HLZQh4qFfSIHAGUntmHYZ9rxMcCntdTIB7mbTGMG+ly3yYnHBTc8kSN0?=
 =?us-ascii?Q?TfC+BHQu9saELdh9c06rS2DVZ6CzEDh7XqX6t2tCG2yhNL/x0SlsPBMoHdWc?=
 =?us-ascii?Q?3pFCb+ZjvtGs3KB4aLDDtB2uxq2WS62eg2vVGrxAYG76Exv5A6/5953eltyY?=
 =?us-ascii?Q?/6NfZMR2bj192bOozep6UUGo8KOQMahGV1pqWl1jkuxfZ0OaKuYZNonrblES?=
 =?us-ascii?Q?fXbR1x6bt4dUTuLqdfnNHZHKkGywTlzrgelvYuA5XHNjS+w3UOCTTxxhJW68?=
 =?us-ascii?Q?k2aSBLa7NlFdPI0Ri9TThCRxcOosdVDejFS2TyY+b7tIV1+FjhihR9rkb38g?=
 =?us-ascii?Q?VF/TA908NFSa5lnNDCMJV9+5bRv6IDR5n6BnoCqpdUk3nEeXpDr1DbviTj9h?=
 =?us-ascii?Q?f3PfmYGzG25G6H9L0Oi3s2Dp2N8DvDrQXB3lEyW8lzNrzq17PNdv1cSpBGfd?=
 =?us-ascii?Q?sPJBJCnbxZrdy9qAStLTVf61sz5yPM0ZHNsb86x+57OfJH4rUk0DC7LnW94x?=
 =?us-ascii?Q?mkznH1op84gGdf0I/J8X29VNFrKKOPaurbGf1Ua3qOJ18fLOfyGls55vNdrx?=
 =?us-ascii?Q?LTH6S+tts2Yd/TADPPe+yz3bV88haFmd0xgfSzEU36xKlOJ+2FdItjKHjSuE?=
 =?us-ascii?Q?yXvwPvTJcIVdYmbzzlUBVuElmCgBGTyWPoUp2JF7cwvCSH/JVKGZSn1sujMM?=
 =?us-ascii?Q?AXZG81mueX3KW1+njQ3ASj0yE8hywtJ4hexOx0V+SqapMQyBTxhPVLQxSWEd?=
 =?us-ascii?Q?5Y5khC9IK6P9FON+22PC6DKnnjy1s8qoEuMiyJZpsGZh2Cl3bKhvIRetcByn?=
 =?us-ascii?Q?fGoXdpF7ca+Gvcvw6OQvQ+LUTYoD6/f3E1iX3pqmIR4aYrdI3An72Wcu84BT?=
 =?us-ascii?Q?LC9VS7zS1RMNohy8biKA9pYua3DQAEI1kaqZQfBgCXs4Iaq0qFan4chO4uRx?=
 =?us-ascii?Q?g1smTvybvbD3Qt8+7WMGjD837J5Vai48tKAKgrSYL0WRICA6RC/P8yhevb5B?=
 =?us-ascii?Q?Pk1eCKFfQKuBIDoz16oD4cpZx1Xf96FMzh0cYV1Rnt7PvwIS2KnZif5QeT4p?=
 =?us-ascii?Q?ZNsguH3wYvX7pBX0mNaXn0QF18zWIZo8sm2eTzZF47UXID14IEf0y3xuIZP4?=
 =?us-ascii?Q?e/QFRdGzRBWQganc9Y8j6HeedugQ7L5baClL5ipZqJbgXI7Clzob0LRQC9sP?=
 =?us-ascii?Q?sVHViLhGyQ2FDj1d5CpM87feSCYS4AohFT9yLWDkgoiRD3v0kBqSRa8nBkps?=
 =?us-ascii?Q?qCsyUdK129tQ9ba051rJRBeM5Z10xQAoaQUCfJPgRSRcI8xWhm+tXTKcbn8t?=
 =?us-ascii?Q?zMW8iQfan3hdoWp/d2uI0GAo4u07BH1oxbFzlBPgQogwDeSyb4/eHCdUYvcS?=
 =?us-ascii?Q?3VxUv3Qda60XlYI6Y5jIQlJVHXjNMdKpgs6HKNV92nllHs/nn+B3semetqJv?=
 =?us-ascii?Q?BbQ/6/ByTG1s9DuXyjWlH2V1L0HTbAgUWrZzalKACBsV0l0vWsO1asiex3le?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7nJMLQqV6k7/ubH004U82HTMs5yb121Hu7PPBXWhe8JqG73c8QZqXAWc5QJ5OuQiHhpyAvmLptp7eUjtdxqOmHJK4OobIzDApgBrT9FhKanYEfQyeu8LvNiWEO53gtV6aoMpW8mrx0tg3oY/U0EMC9r/DVRSE0YtJGDZ5bxdWt8bzmF0qdpuLK6QXQP0b4nQFZDgMwDypcqcR/134BVZ4FRsXS7BQDCLshpcbO8jPya+N3AvImompSC7SRDGeX2PI70NQIFu09qZObJAL9r/vSVjw3n9+0vLTzPZ3CZosJJv9IA1iI84J+zePgLbuAVzhGYgePsIhAtEb9MAFSwJjoKPQuODYAuwNCwZ9w2J61LVD3E1EjHQDUlCxNxowgx/1fLu+XlvjOdpRNwWwGs4PS+kUUVXA25h7g12/rgu7/L+Ye7ceBmiSmfRe841fU9JjWPcjE7d3Sa4IL0zPILswtFx1eZ0SJmR4cTKRx1f0PbaicQpGUvDCwasIDbPdKqHT2EfSJNUC2UA214SM4fWazatKfzj++J0PbCI8Wb8Mg+ge2+8nWQCYcO8tTrwmj2RlEFLS1Eqq6bgRqSEQAnEWBUl76AWklGKdORFcs2aPuuZJbO1MPEoryGqqBfCr19fbornLbomwew0MLG8y/+9We449Ubwjx8qJkErdBqhzzi8nBFWiWiUw9b7wrBz8iBEDRWLARNrCf8iB8XfuLhzdhyAcA7q8o2XsuMRSysgHcbZMywdB66G+es0wQ6RnoflZJtGbxQ9lHqivZ8gDvhReBsRuxABbIuWd41SAwdgfOU8Uamh845nCGTHHzZ08c9OdKfKSHQAzg6Ac+Qk83P0IALvRwu6ulxP2gx3VRT9ZSTiTyBkszsP0IX2T7tAf8zh
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abb2d7f9-9b35-4984-66db-08dbe0ce4620
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2023 02:47:54.9344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+NewwMP1DStvO7fT5ccTyvAkLBfJpgbK8kuHlIfPG2omQdUbDt6CSBOjNowccQHcmJQHXRd6r4Z/keu4bSO4wL/GEBoxLpkKb/sqqmouMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5179
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_01,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=732 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090020
X-Proofpoint-ORIG-GUID: dzwg-x6TSJwX9okirdDV5yoOH4ive-c6
X-Proofpoint-GUID: dzwg-x6TSJwX9okirdDV5yoOH4ive-c6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so
> we shouldn't access the sshdr. If it returns 0, then the cmd executed
> successfully, so there is no need to check the sshdr. sd_sync_cache
> will only access the sshdr if it's been setup because it calls
> scsi_status_is_check_condition before accessing it. However, the
> sd_sync_cache caller, sd_suspend_common, does not check.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
