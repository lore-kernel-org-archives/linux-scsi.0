Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56143E7D0BC
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 02:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjIVCDw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 22:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjIVCDv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 22:03:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F7891
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 19:03:45 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIt3G6013699;
        Fri, 22 Sep 2023 02:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=nRu1JMZ+fYqEsFiCWMobcw+nH84M9SpdQGSSbaQnB1U=;
 b=EI8uO47x5t+bdTRmvCbIdNco7qRF85LI9uhGtCCdA01yUf4SEvhsMU4NpII6r/DZqHCl
 ctAKILimDRV2uD/BDuUIvQPWmeKF92x49yRAPstEjAkjDTj//N4vBVdrqsv3rbiRHPSY
 eK6+BvTsa6Txhvi05SwATJ82VYeOR0OUOUlRPKX8CkZ7emxJBwA3pOh4Fi3TQfLpaM3B
 SXHQOXsMKO+y664C027zY6Z/JZQu8FcZDeZ3OzL8tEsLenU7xp/DNBjp5nPZvhqkAoZ5
 WCG+5u13bSCbFL2wZYIv+SGYgJnKSKmr+IxKmA4o258ZSBaHhd5pu/z29chxf+KCMlau NQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tt1gm0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 02:03:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38M1sMWK040636;
        Fri, 22 Sep 2023 02:03:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t8u19cy2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 02:03:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgoqtULCaNS9j8blV8HvleRIq6J4NFDS6H1ifP/H8z8wyQ3P+Vt4tLpKni5H7srfUaxpY9XvaLNBKosoCd50OFUuLSQ8M9rpjTCaxAJQiWe+cT4IhhACcQtSBa+qJbTf1Wy1LTZKWn1oj1zPCJDLNjAQjRR0ItUm4oU/wPdTAo2BF7/iDPuhkKkRXB8jUtAw7TvqLFvmrfPsFWtg4Z+DJ08lDvgeDDtuCtFUmaE3UIOe4BnLzINKCMCmjphJS4MO1wvg50R1U3xviX2FWC4aRbfHd3xSNeMqkoI2JlSqoZAshcWBzC6nye9UhtXQdcXOuEV17zxEzork6iXNX5Ygww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRu1JMZ+fYqEsFiCWMobcw+nH84M9SpdQGSSbaQnB1U=;
 b=dQzNuHbZRCWz3qwC+q9q8hd7TdSrccHWchtddU5i/02oDmswjtIp/vqnFppqtTULFN9nZ88oAc/7+xwj0iRzklIt6IP+JjZhfR6aKhGoxue/G3UdtyqCw1n90bBm/rPtlW+0fWT/WF0cB1AYXIcIVKap5dia/b3jWmzG/+vWRgvBgVG7eX5WVb/5drA5rmDN/NlkSpDgnSfi4weMuZbt5fEJRQKrQsIhJWXn93AEsCbiLnG9BO+5rm7LNWaVBeTPEZID3EJby/tOgxAY6aKKGMTA2TUsvgX6FvvPJ3eXW1tx/7/dmjc30YZDyCV4zvQuf9bkgieKxqnS1YN2BOlNgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRu1JMZ+fYqEsFiCWMobcw+nH84M9SpdQGSSbaQnB1U=;
 b=N1tNnUkwmTvuvlovIvcyh71Nwc8AfvIFnQ5++Min98rs6619C/RrXwxXYkuZf1kZ2+aWA6Dpul/nLJDD121B22TCKCZeKdrJgVToz0ko5TxMt3eXUDhoc2+ws/KFDPZ2G6+wUM4oMydr1e1vJvgFUFZvmEaLuIcLshcumxHN8OA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA3PR10MB6999.namprd10.prod.outlook.com (2603:10b6:806:318::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 22 Sep
 2023 02:03:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 02:03:27 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/3] Some fixes and optimizations for hisi_sas debugfs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fs373qxl.fsf@ca-mkp.ca.oracle.com>
References: <1694571327-78697-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Thu, 21 Sep 2023 22:03:25 -0400
In-Reply-To: <1694571327-78697-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Wed, 13 Sep 2023 10:15:24 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:806:f2::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA3PR10MB6999:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aa4355d-72ed-45f5-af7d-08dbbb101c46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HvZoFEqhwA3hZViuEvl/wyI90pLhxC958Twp61ruWWoioCqVHQ/RXQreABihdgRLzoqT0mzvpM6rPL48YrU0Fr28r4aCS3HGu62lBAGCUEMUTGizDEfy+JAVvYhDKFwZuGxT1M+8E6YLo0QQAFyb8iFLmNFwoyQVqt6nt8ua/inYBieHVOtRR7EP7QilTb/NOYyNhLhQbmB70ms/v1iAPISz0s02unHYl4I59axRU/s44PMBj60gg0Njz1cO2V1hGlQlW5I77yZAEjboRM3y8TesfRWxOEr/OQkEQN+0nexhUJ464ZdMmFZeiDkMcc5KIdUVOS5FHj8CS/eHUvE2gWTwVON6I9HAS6tDCba5451TMvFQvtc/br7s212stNDBgpgCL2Xo28E9FDyVtaUweSurIEeJ/8qjJ5TysU5t2vrtB6MZFce7bKcVB0oq1luQ+xBxwWj43lh9dgZMUjC/2TCF2CrdYTTMbmzb8QI0CEnofEy8zvnctDTYH33WStcLVE1mYs6qoQpScZft8+6bJ7QFTcYkhnDKLW6mLsMIr4QrjrG8J6Wwt3k3mlwKIYEY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(376002)(136003)(366004)(1800799009)(186009)(451199024)(6506007)(36916002)(6486002)(66946007)(8676002)(2906002)(8936002)(478600001)(26005)(41300700001)(6512007)(66476007)(54906003)(66556008)(6916009)(316002)(38100700002)(558084003)(86362001)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q9Qnf31m33dEAjboLsNaZIZmJLIQdwVPRE0gyeCAgsMu003NOWDXGT+7INQE?=
 =?us-ascii?Q?qe9giogxqR/HgrZHRrfRrZLuhbLPBp7xeuzO9CuhcIdfXKLXBzIDOYxUcav9?=
 =?us-ascii?Q?ltc3U2woIlZ+I1F6+dluYi89hNlxGW67f1MbkHUS0hwQjH4hn1MuYUgrZ9ms?=
 =?us-ascii?Q?H4fr5fJ14HY2TyJPYzyJF09yrmBW3CgPueocSIx7vwlneEXl8XesYANWoair?=
 =?us-ascii?Q?gUq9hd9O7r8vBOo0+GsiLXfzYTHukO1v4aAsiBn09WqL0dOS5JpV+eDohK1S?=
 =?us-ascii?Q?CbaSQVAeCUCbDSziKxn79I9tVBZa2jY/sryZKuUNUQNx99MEIYFr6rBp3U4l?=
 =?us-ascii?Q?IhqUYQ1EV/u3pdbLyZ3Tm2AheKP87yEgSYr4KqDq7opQtFcOofhuSccwCYHX?=
 =?us-ascii?Q?/5gksv1MgjaiEOgyvZLa793J5FFbQXFA34nBEIixzjK4ABYHIVkvJ0dmboYV?=
 =?us-ascii?Q?bUdgdtoOU9P29ZkPsLM+j4mtQiWjalZ/2KgCiLptnnBy4sEuTP5sCzDZopeY?=
 =?us-ascii?Q?gJHVXQjpP0wYWfTSYVqTMeJ+jIPCEo+Q14kWayo202UH4zC6enxAEBUcaFWT?=
 =?us-ascii?Q?lxXPo+ArcEO0X590fe0r8OWhBboEDYkRgBlOGuWwxHNHkl0rGGLML22y11ub?=
 =?us-ascii?Q?PZyKIwp+pu0UCagWVEwYWi8+XdhbrE5xdEvTItgBIitTvQqbsze//YFrNjir?=
 =?us-ascii?Q?Xakvgw8E+DQlZyxPpzfZ3C8JVXmkWt16VFwc79OjEgvQHTrPxtQ+IROxRuBD?=
 =?us-ascii?Q?YpHlTWCBRuIvmtt/eC53WRMrltwVk/x+UZ8r6PX8JVYMUmQ9EFISP9LSLLaq?=
 =?us-ascii?Q?eNfAQ1ERLTHm6CVT97gFSSenhG6+8oVwu4ucblKuM8pSZ3uOqZqHLxprj3Gs?=
 =?us-ascii?Q?n6E3MftFCd1th7KYsmvkOdVUOTjz+lBuhfMeykqnhhY6/9coJAJiScmJs2qa?=
 =?us-ascii?Q?qT7EUF2efPukuXiByx+TMob18iHQhx+l1FKPvU/AtTW/dbNKP5zh7AKaEZsN?=
 =?us-ascii?Q?ckml+pzt/QiCgr/f2IYXQR7fa9PBsGyNT1teFEn++qmE5ddgAXhbQU+xN5Md?=
 =?us-ascii?Q?Aho0X+hZyDiNXT2SQj5tvXuZf/wOrNTixd1LEF9IFJrYHaPQO24r8wl7j5T4?=
 =?us-ascii?Q?Sc5Z6Ju2OdO4Klw8sEiqCA0Q0HgloBeFLvjJfKmvMCJ5bKygnYTR3CLcVvhc?=
 =?us-ascii?Q?2FsHl4LJsToMnAZOhnoZOUxh7zfEu6vCTbOZY6YVBPbXP3qIN/jBgsRWC3Xr?=
 =?us-ascii?Q?Ec5L0gRCfCNH5SXnAwkQZlQr2zt8yRxCgS04S/GM5HwbGHNLiGYQFoVrCsv+?=
 =?us-ascii?Q?s5EezMM2R+OtNkhWuutG/hDORtAdOfIliovqlNMZytnf/Wa0Gq/l0pqobe9P?=
 =?us-ascii?Q?v7bglFdtRkxpEHAHpo+hmfgGRNQpDX6sUUKiHKF5bKjc1OhZyWWj2aAsH1fB?=
 =?us-ascii?Q?Enx+SbTktwbamN0HTeI2zx5wqpnsupAcxMkbYI6lbsH/1T8t2vHAKyh2LEMR?=
 =?us-ascii?Q?P/j9+valRtBj31vpz+VY5YIpYsO5+Z0Q4M/fVoL3BHlx0mrVddTgt9TROjXZ?=
 =?us-ascii?Q?ew1MujmfCMeJ14n3A+ZK4gBAnML5s2CjlykfSHW7tiX/Kba5EeX2fbCNK8B6?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DrXh/dYsEMXQtuMh5pZd/9mG+i8JDM+hQGu7qc9+h1mq3qHf/LrzrvcimAm/QsRYMvIRFiPeb+46GKXyXm8CNTBzUnW4gMgpN1evp5OyKMY7GEwhmcEYSnN1Z5G2fk/PK57aZTWLqE7N+4+5c0LEdH0BjkeM+JHWxfaKmL+79GYDom/q1/R3fw5gT+g/BTmsgPR8Dg9OGkk3cXebTpKwDJPMWFItPpXk/+O4BMtPgpzHEBonnNlV5feVtooHQgdDkQQgVblVrTkAXILRlMimLa5OMhENKSVzKIcJ86k68uHmQ/tmHBOODKtbmj8XSip13Ynq3aNxz3oEx8JEXWuHSvb4BwAx5cel/lWYhdZ+yDAs3Pq1HD5YO4g/M6vrPOsttcvEXeGYh0X5MJb/VKIlqiaVvDCijhlVeNzXVR+vG55pFbrTKee2zjK3/azjNVW3QLj8G7dh3eNTj3RKcAdluqdleARsMLz6R2wMdKWpMmQtz9mM4JfuI/Aa1MbHR4n2ZF20Adgp9HYGhTSe99hqBzxqfWaTzKh6rZ/5lR3Mz7XX/9MCiChOSDd5aDIfT4QPxBaNU9qF9ycGk4g9w79ashF9lMwmUVcYIIUd234DVnldJCDlNvxDpK09dj4uELXC+jjebnk+rlA05mEDrrAvn5Hri8OeOBX3c4dKz2dOKRUyTmI5YRHCU1cbjEO/12PCD0lnxFdDaHliUP5t3XOfTK8bROVnU0x31ALvuHveLPO/+2FhyHlSaPEMVc6TUxs1R/+HTAv0U5tNDtPhiOTihfYfzX26WBbpNiwC+LrXiUhUMSBx7ahey1Hdcnj1CETHNeyLZgY5jW96feBEC2gomKBJ4QXjz2J2KRnNR4O49QyVdn63m9pgU4DacGqOaDfx
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa4355d-72ed-45f5-af7d-08dbbb101c46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 02:03:27.2985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXWQPyZG6H20H9AioQQeBt3AeRqmbBpo2GPY2y6DXsQN742a9MwDOSnE/nD4qKTZwbgiGaNh1B9dclfFVQvvYz72w8m1J2DRgUIJyeodyhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6999
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=719 phishscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220017
X-Proofpoint-GUID: w8YjEr8PTHCeXINojnIRYi56mc2BIjhQ
X-Proofpoint-ORIG-GUID: w8YjEr8PTHCeXINojnIRYi56mc2BIjhQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


chenxiang,

> The patchset includes:
> - Fix NULL pointer issue when removing debugfs;
> - Directly calling register snapshot instead of workqueue;
> - Allocate debugfs memory during triggering debugfs dump;

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
