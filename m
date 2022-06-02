Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFE5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 02:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbiFBCh0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 22:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbiFBChZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 22:37:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F6F219E
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2022 19:37:23 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251NXmqx020229;
        Thu, 2 Jun 2022 02:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=awQpiubhwH5G6g2NvTdtNBtx47p4z+IYg/KAqDPsgic=;
 b=FoHMGKZFm2IsZpEVbRD3oJX47xBCuTmCl3UbJCv+LENlVFbVmkvhKf+c9z6M/D+hLnhE
 UeymFlJkGNq+8AYKTnvu4LbicrcTw4SkmlS4gkalLKsdiKVdRZFMYzSGY++0Qv1nFUoZ
 ExLXREhYcAkM2l09CzeTEoAZNFZNqT0rn9gaYD3zblKM2xGgaqCMPxKZEYPXB97vuL8L
 yCfkVzioRV+TV7q8VJP/96kMB1YizjZfZuqIAkr6eqMYchg+Um3UeqKKYSuWl93nNQPU
 FJ2BqjC+NHOVUq7T4pSSzHkhr92nRvHi1G0HN74zU7lpIg7Yojir9zH5Gaq+ykGRmNHu Gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc7ks0ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 02:37:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2522FVtN020069;
        Thu, 2 Jun 2022 02:37:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8k10p0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 02:37:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0luIy3mO8s4fc39K7AZ4qIOKMUNHS1wevN3V4u9nbexkYBsBKhQNfj2svTCrBHHDRQu1g0wQN3JreA8rB0ij2YuLs0B9zIWikkmhMiTyssd/pbERIJLY0tI0UqJ6M6OIJebzxRLArz+UOQj2omSLro+Elx9z25XxDnbfhJ+aFSZflEJAyfLDnGpRWWlqGlSzq2oanxVtz9oKXjrqV3pZFny4lKpVe4wL013LDc/BWWZJAyK6AsX2yGBpnu+i/Rxl0FYweusx04Mx9ywEH4Hb6CIwOnRSPIW5QVJVFc9/j74irCVeyJ9herwupMpmIVgsoGpBk1TR0ahDEkihUW0Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awQpiubhwH5G6g2NvTdtNBtx47p4z+IYg/KAqDPsgic=;
 b=YrvAtr1dGpd3ZTeC1P0H4aT+YKl2YLi3ocpiyq02BAXr1+LYOt3aS103TKU0lxfE88yakKWx8KBq7WtTEp5C6rfAMz1/sNZazB4gpcVIzvphn4I0SEDOLzeEB60TI2Z2VfhMTFxh9WFc6fQD8hHhPrP+Rl4vBeey/hi/pjfs98atggZ0mvBQ02voiGCDIauKVIl1oNUqWGF/seb8gsyL0Ale4lMWkawyK3aPrItI6QCYn8/ld0gOoT38ZxWM+0a7dsW48Trxr8GnBcr0UjgSU6UooBbTGN3zuDsG4kkzgm7+uccGnyADw4+BO+pGVLaDwNPBEOZ3hjof5n+GPKGMUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awQpiubhwH5G6g2NvTdtNBtx47p4z+IYg/KAqDPsgic=;
 b=EtzC0WIKS6vNGsYmKwjKNYRVGmF13GwoL6axfW8IPmhis1CwEAS9cUEZeUBHY1XXuPQuSNX25rcMQbwG44/gYJdJZ6aEZAaG/d0wnrelExBprC//YoXU9+SxYWidNnVW3ANzbM/VKNPgT4c8eltZyRZ5DUtYEuPkFoJp7kwjZZY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR10MB1850.namprd10.prod.outlook.com (2603:10b6:3:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 02:37:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 02:37:16 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH v3 0/2] sd_zbc fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee076bso.fsf@ca-mkp.ca.oracle.com>
References: <20220601062544.905141-1-damien.lemoal@opensource.wdc.com>
Date:   Wed, 01 Jun 2022 22:37:14 -0400
In-Reply-To: <20220601062544.905141-1-damien.lemoal@opensource.wdc.com>
        (Damien Le Moal's message of "Wed, 1 Jun 2022 15:25:42 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0022.namprd11.prod.outlook.com
 (2603:10b6:806:d3::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afcdb6bb-f878-4572-9c6b-08da4440ce8a
X-MS-TrafficTypeDiagnostic: DM5PR10MB1850:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1850165CF35D8D97F43CE95C8EDE9@DM5PR10MB1850.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kBxy/Btflrl1PO1m55eC53YWfuz9wlNReyGo26am3um1G1NBj//QxQz0xLjz/R1D3NvP95ZsZilcdqmc4L5za0Ht3kJZ5SajWSo8rsCu4cIfgFxHDI1PfgeaktrQVjCxzd4bhwPNTxHIEm6acy0OwJcycyt1ImLy4TqEuBhHv5YtXUCQOf5/why1G4zdfNlxWPkEkqLxsquWjdH6GbqpJhCsddHCFkahr+pCMXOGgBrhczGQHsVRflkmCAxkPkO0iW2V9kSEI5ilQlk+c4i/gJzmnXwDGnMLwM9HA9soAZDPI6OqWf09tsMUh/VmnlXYZiEBaHGFW8YuqGSImkCUVd3rN5UUnM9mVVnXoip/8xFT4c4Uo3JcHZmaoSFORaa8nWKw4gpF18z0DnEK89i22SU5yodhxTHVMJGMlZfvsWJovS0BZ8uiU0F8e3RRicv9GiDKUipCwaRypqw3IS0VTzFDW5aNc/6EHcPlJyaMfs4mjEn2ZEguRO6SVfvhHbXZl5CDgQBCvxbP6ro1MCNREWKY7+21BvW+G4z3/JCy6RdxxGRPLFl0bY6Lm6p6I22wD06TGy8LHq/0ehnSfwAx78WACMvzZ6LMiBPyWr8gevwITA7/6hz9SxFz0tqnN/JakVmJbn+yIb3QP5ZI8CsdNf/LuLHFvZzkHwQ0lNZRRVzAAqeipgB2zZoF+FM1usa73P29U4yg7zm7HHlWxVGozQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(26005)(6506007)(36916002)(52116002)(54906003)(6916009)(316002)(86362001)(508600001)(6486002)(2906002)(66476007)(186003)(66556008)(66946007)(5660300002)(4326008)(8676002)(8936002)(4744005)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3e780y2IV3FUs1vLRFN+jErHs8eEbZLTjEhZBjQ9oV2tXtfVN7xrnhOcvjHv?=
 =?us-ascii?Q?lgfVaORPPa7xYV4Lix/avNV0y+LuEmfrm68hhPPufDXgn+b57dbgR3w/3zQD?=
 =?us-ascii?Q?KHpJdWbRnHugewbIPSsW2WI7DswqLUBSTlAp/InSoEqV6rz3xjiIcpa2hNu2?=
 =?us-ascii?Q?FcTUegYo7yjMyfdbIzHXlmw7geSTz2Pk8+0F+y8O2ptd8MOeT7OzfhFuG6Gk?=
 =?us-ascii?Q?QjIGeI7saTI+ozcoVDuxK5oglRVYXf1jvOcawfkVGkRZnlT+k+KDNnco4UtQ?=
 =?us-ascii?Q?NFyuKUq/Fi6xe3xg7dOB4SQ/yUvwVOf5WZdc6Ts2rgANHcWOw1YU2yx6DDeQ?=
 =?us-ascii?Q?IWrI//JmnGcLIoXSiXbVHonO+9gtBHoTOBU9TAGV9gNXDdhoIamxSmAqYbc2?=
 =?us-ascii?Q?yjWe8sVpR06gAKOfsrlUZoX26f+4Du+bhHtQ8d62dBkMjpss0kfhb8zaG9E4?=
 =?us-ascii?Q?CebQLzZotSBA0zSo5OPPvC8/ici4Ex0YolUD9xvt95/GYPRLchVcqIE3Cqau?=
 =?us-ascii?Q?6MijQ9TLw9kFZ8gwNT9RNQ+udKIQAiHlUUKgrj4jJjWm2h7eVTJ7LnuBVosP?=
 =?us-ascii?Q?UzLlfw13E5KpJrjIU6SseJqwhx3737NMscZgYI94ktKNokIQU6hbwz/ePtx2?=
 =?us-ascii?Q?6YTxkS3T+Z2hLA64Y93/n3pZDp99Jd80g5/NbFvh3eqcZI+j4QRJZeuakjRp?=
 =?us-ascii?Q?fefNKzW09zlYm2TijZlTYAY5OlRzcLlmejF+Do+t3ygqUakcrOhyf5v7d/8k?=
 =?us-ascii?Q?rM8pJHwKDleuuwF2+Lni8K4lofdk0lTWftT7Xrv4yr1v1Ng1IzkajYHowMdC?=
 =?us-ascii?Q?1SDThaoY2ZLKfAOTao1UxnjWUUnsFHu9cUsei22AHYB3zakGjLNUEbQs3ntq?=
 =?us-ascii?Q?NBqVI+2hTLfmBM3IMZimEJsiNtYKBzPW+mZ6dOKBX9r4jlBLsCQ9Gk3YvvzW?=
 =?us-ascii?Q?q+kttMRiAKrFDTAnzjP3PgWzTpZ8hAhyBHh+n1A16GDB/4Kn1M3rs2qPz030?=
 =?us-ascii?Q?ZhiowGBHC9au7H6APPrJghwnYXHCPE1bFFgzU37EzhYsV31nCTQXTgvdKm3l?=
 =?us-ascii?Q?3iTjlE9mHF+HVOqDk7W3bd1oxk2pYfOoxduFgyzHYmsqZmLAB8aarKWME7Sv?=
 =?us-ascii?Q?wHyckENz7wcPTgbgbwoC+fd8aC9QM61sVfXdqXMRi1V0VHPTPS4SvbHJ38Ob?=
 =?us-ascii?Q?nsmt9y91bnPfGrf9aCtnLWtjG9pTNvYQzoUK6iH6WgAY4E7dq83GABpB8A+V?=
 =?us-ascii?Q?jSunDFD+GYoRtpHEZ1FiZjsgv1PUVLHFx3NHbnbCT5tez9BkvIBaR/86rojv?=
 =?us-ascii?Q?Ql/KDDJZIjbd7LUsBq0wP9vH45/oVdGoLmTTeb2cWjyL/VsmeMFUtsRFbwHm?=
 =?us-ascii?Q?ONG2/M/q3T1UMStifkB3BShespMkZyw69yYEMCfXTcST9udQo4aBTG5+3oT4?=
 =?us-ascii?Q?FKw/zP9DvVoMBm5kWfd8tasEZz9RmJhH3Qv7DNYesaZFut1MfdjcfAoN8e6N?=
 =?us-ascii?Q?x0j1FgrfA//01yrn6tO8f2GH6atOG3B1FcJw/2rIW3sCv6DHJkJxGpVBNEJO?=
 =?us-ascii?Q?EypxgnFFv1KmjNacmmLawF44MST7p4JjEJlIgriBEor9Uvu9cIo0tciok0af?=
 =?us-ascii?Q?GXJbXMGSJhdVMLn8IOmR5pKCRaWIlvnxm6mXOj22ZqJT5VXJb2x0kCdtgXrn?=
 =?us-ascii?Q?2L86FECTkCgn0npLetEEks9CH8mZfqfP76CO7N7TSU+iClqwvDstqwZEdhsM?=
 =?us-ascii?Q?Ean/KOBOCDjWRIakZctooSAt8NO4jYw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afcdb6bb-f878-4572-9c6b-08da4440ce8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 02:37:16.2019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hEykPYa5N7D2YO2Mv5qfFtvulbL0VTBUtGF1DaS5Z4HKO0GFUOZMDYFctMD2FbWjlvt+3xCY+ulUPdc1gpZbZoBOlKnsliHH1vcsccAclns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1850
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-01_09:2022-06-01,2022-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=662 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020010
X-Proofpoint-GUID: TdC_QhW9sHgRg4KO7vqEk7QQZaiBkOHT
X-Proofpoint-ORIG-GUID: TdC_QhW9sHgRg4KO7vqEk7QQZaiBkOHT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> A couple of patches to fix 2 issues with the zbc code:
> * A potential NULL pointer dereference in sd_is_zoned(), if that
>   function is called when sdkp->device is not yet set (e.g. if an error
>   happen early in sd_probe()).
> * Make sure that sdkp zone information memory is never leaked.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
