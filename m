Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C893EC636D3
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Feb 2023 23:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjBHX5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 18:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjBHX5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 18:57:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22541E1E4
        for <linux-scsi@vger.kernel.org>; Wed,  8 Feb 2023 15:57:16 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318Kx1cn002584;
        Wed, 8 Feb 2023 23:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Y6ZF5gJxRqXT9IDZIDIinp7eX0jlpDTTe7gEh+cxvF4=;
 b=CtpExUtRkPK1wl19CmSdAvGsXhsNX2ELIm5LbUncyhCJCXLLAur+wTiGNvaMr2aVkE13
 FCBqxU/ci191j5NSvUzVPoRJ43LTWk2ytrij9MvXt0pgWxtwFxTHtA7a10Ow1sUmhl2A
 3c3g7HYEEJKmqhMqEreVSKQxmtx0xv1P8OgaQbZp2rM2UCFM31FciHaB0nr7D3xSZZUs
 LbMTSaHXzIC8/duyL41zJKo51XAfRFZk0AAqHVhWZubp4/cVSO9Xx/iogscP5cpHwK8b
 VrZx1hbvwxZ2aWsuyHOlqJlItxXJbC0Fs0ZyY4x4igY2kYvNTxYuOZ+SgIggGmqaCAE3 7g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy19nxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 23:57:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 318NRxfk028353;
        Wed, 8 Feb 2023 23:57:10 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtegdtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 23:57:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STGd2YwuNzgbbaKxXTuyvXYg2eKQTXEw16InWdhSrgj7c3Uss469zgR3JV9Y8f8YVwkxU2ypap3pwLNohfI3gtteLncekhXPtOLU40sKElrNvYhh6nB9STUetEkZJfiIZqMxlHB4RCKZ5R0g2agbhEiSCnXAH3XKrOnvr3RcGmmojj77XGfnWdDBxfGGhP0NQ1GOolAfpb0WZGViku2PUSTu49QgeTipbn0hMSFyPg0eQtdkWy6th9W7ppKrhL4pv7tvY6yob+g/y3+/uyDQmGRRzXim4d4wOpj9HT7sNG17xysFEN3O094MMUVf/S+1p8bzsv/DmNQAGvJa7MXpVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6ZF5gJxRqXT9IDZIDIinp7eX0jlpDTTe7gEh+cxvF4=;
 b=PNlq0ZVbAiuWc1HwoCNCXReOfxFO9YTx821x4q5VU32qKOVYEEvXOujDo2XY/uRGCNgoDjnPGyQqAAo3l+Kvf2UCM17Jya+Vod31sXjhjDfYE11dWWgXnREI42pMEi3j5/APFrCJzZT8rzznGdgEgsabaTj9ZN6pGFm4Q4OlY95GDi4mNj7j3ggYg/q6tHNghONyEVS/e8/ESGnWmlnTb59m0yUH6THiNmmFmpHh/H/Xly61EDvW7iJSsAE8TGyG5Yc1eoSdchr++h1Y+xMqZ6UFC6Eh/A8ewVDS+sXKkUHzksPRSVmGN+b9PX1NFzS+8pgEGd/DS4yeMY/gOgxQHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6ZF5gJxRqXT9IDZIDIinp7eX0jlpDTTe7gEh+cxvF4=;
 b=nwDynoM3h+bhzqu1uZXvLEZjVhsyFrKwS2wgN6sF0SzcsTZtaAsPGO6Gyc/Dc+bg5VPGAOhBxT8dnMLpKDEBT3KxoubSma3f530Rkwu2vzuExfgYS88w73B/XHvgEEiixWOax/gAjKHCBEOm438YOK0RspexuXSdkF96PE7cOpU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB6833.namprd10.prod.outlook.com (2603:10b6:610:150::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.11; Wed, 8 Feb
 2023 23:57:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%4]) with mapi id 15.20.6086.018; Wed, 8 Feb 2023
 23:57:07 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: Re: [PATCH] scsi: ufs: Fix kernel-doc syntax
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7q3yam0.fsf@ca-mkp.ca.oracle.com>
References: <20230202220155.561115-1-bvanassche@acm.org>
Date:   Wed, 08 Feb 2023 18:57:04 -0500
In-Reply-To: <20230202220155.561115-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 2 Feb 2023 14:01:42 -0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0027.prod.exchangelabs.com (2603:10b6:5:296::32)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB6833:EE_
X-MS-Office365-Filtering-Correlation-Id: cc3b9725-3d0d-4002-1a19-08db0a302f0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y1iex7pNsNwVgg54ZlBfip78P9CGALgAT5nbCMXMohgVS5ypn7o+24px+uhKeqiVSYEf3THVTzpFytzvGGllHQzqtulXWWn2Cu2+hmR+2BsLglnwxq+zmrCtTKpHvRIi6q1LTHn/TEX8+7IL1Eptko5xDBwJmoSjnQ0dfYps+4BvRCr4H+F7/5jXGk0iJL4jqe8tK6IU+z0dLBf2acl9kU8eaRRteimPRn1KRxj5diiFB/+FUyC7WQBDFnJaE0BSzmDG2Wj2NmXMDwDXJhjuqyMx5GoQihv55LdDKIPZK/xgJRvWJVDhNaZ8o0WfKDpJJbO3qlouirOq0IP4S7GZMKAOIbx2uZTct4RzM5ju+bMyeNQLfFnkmcCahnED34u6s8D/KqKrEQnVfrh53HiOsEJ6RpWLPp1ph9idTY8w/av/kL74F0/TVgRo2OFCuDDYTgpphAGioIqUlDA8XC2dEacPe8Q+OZqhZ3+QPACApKywOoDb6RZjstEgyCMQs15NkzzEJMzviOJZ2btq4ljootOUzpS1GTzy+pVAfHmm2OVuN8Y1eH0liI2rMJAcIEg+gqYOY02rE1G80cnlC2O6stmbZHWdR8xnOR5GXSkrm+A9Z8kE9e1OoA5ee//xUsPJ2pQ7U5amoqVy77HI2C8MvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199018)(478600001)(6486002)(41300700001)(83380400001)(86362001)(8936002)(2906002)(38100700002)(4744005)(6666004)(66946007)(6916009)(66476007)(8676002)(66556008)(4326008)(6506007)(186003)(6512007)(26005)(5660300002)(54906003)(316002)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ClaVAy4FnpVyqQUxdFgDGtouGgnfhIhJScVhv1gfPAXKLk8/6fOfsaZARVF4?=
 =?us-ascii?Q?5SAVXk1sPy0khchDDdMuN0uv8lbmAgz96rGZpjrsSICfxiFchFuR0Fqnc5NJ?=
 =?us-ascii?Q?njyDFEAmgbxGOTZd+jIvSQZAsBHEIGmHITwB5lVd7O9YS1FDgmeVPtGLTywH?=
 =?us-ascii?Q?XMhkbxMwxgcvHNyxyVJCqmOmJwn2QVE/wL1rNxL1NWaoqJxzKmS7ezik2ga3?=
 =?us-ascii?Q?1iMG2Pwxmsm11Ww1Ln5YEdyXAPVJswVS4RE+gKPS1LGNXRJR8Lp6fGwI7KW5?=
 =?us-ascii?Q?bi/bNbcUCVT+k4X0/zDm8qj8Gp1TcCU3iMZM/Y/cXkgz+dzOrDzUTdKzgPX1?=
 =?us-ascii?Q?zR+FQ5pSo6exPOSaOfSAXzAxEyYTQut0EcCVcDlORTEAFTmqeHA1dsz8A4Cn?=
 =?us-ascii?Q?xrM+QGQn6ugzYmZxE9OKP2llcvPqVNhbsvy77cpNZJS3fdgBW8lPjDhFctNz?=
 =?us-ascii?Q?XE2hypC2x4xWwVg1KFzDXhDHiDrnkUPhWOnAHNS11hbXfYtlS5zmkswc0oNw?=
 =?us-ascii?Q?B5dmNcGvPdflFgBMxHtEs/EjCZZkRD+FP6LfjRG+iFA3Uh8baMBNq9zoNf9T?=
 =?us-ascii?Q?8ognES/+Bn94yZnsOwaiM6GqnsY45y5OaAm6A4ddvboYu2OvoJz/+FeMSumD?=
 =?us-ascii?Q?wEYaJAUKuTveCBU3e5245FkJO/P4rUUh+A8Tml5c3F0y9S+POXH6oL83HH9s?=
 =?us-ascii?Q?sZLYx0h7KHScYP4RnzZpx5vk9PLW55Gpt1duIBxuMpCrCF1vci64Ybiuv8+H?=
 =?us-ascii?Q?ASe/5L32LDj/DhSSvoYJmbMc2hCgRyRRMmn1wZe/n+BFIgj1W9g2DlCPmg6j?=
 =?us-ascii?Q?Nv/ENidVWRoB45eKHb7ZB+qIZN/Q/0fNBQ2zGTNskBUtqMF3KpzRbj8PKEUM?=
 =?us-ascii?Q?RedFaaCCtNltzO8tVPBAWBVIhuz6OWXmnR4gjLkU9fSyR2ya/hCBIfL3BUtQ?=
 =?us-ascii?Q?Qj74kkpxtJvmFJSOVsLmAmBuFQRlhJRhD9gvGEZBYxVVNEJ0j0KOsIlR+dj0?=
 =?us-ascii?Q?HjYCIhPLiSKAwA7xCP1zbzawYg0iGS+oj9ypmahV7Pv96DiAIc5Qp/vgD3j3?=
 =?us-ascii?Q?lmCrM8UjgRkHFlYLrR2JpS37DqWf8IF3N8LWJHmMaZ/1GQw5c424E2fT3K70?=
 =?us-ascii?Q?0+4LZm768HKCpNV3OyMieDlXAjyk7S89qGjHBfoUkJ1TweM7JsI89HkXSoQd?=
 =?us-ascii?Q?U+EvqubhVefB9hlO+VmtLfeLMhUXJpBp1H5m3EPiuaAxP+wh8EvK6V+IztZG?=
 =?us-ascii?Q?K4+stAB4qIG7CY6D2Xd3ZCAJaHo1lvYjsvnBoYs6I70orZ2JbonMql7cAATh?=
 =?us-ascii?Q?FleIJgOOL4Ukqf3SLpGDstL3Lw8VVyNLMMPdnDhRI6wEtIXmwsyfCDwoKPtY?=
 =?us-ascii?Q?ay3S9FbWV1Uk5PoYMQ1ZR0H3K4NCVnwczpiobjiOk7JXsPpSalcAP633kBTy?=
 =?us-ascii?Q?RiHcgORDbOVz1jWBdI5FRf0UsyXG1e7RafXeGRIZPSVDWWBZrxDU5gh4exf8?=
 =?us-ascii?Q?48/GnaghrxEfFwfYlDe28Lv6fR9e8CJAhVkIN4jwFp72zk2tda9SmWNw2bTW?=
 =?us-ascii?Q?gmyr7DEREHMwsm7+UWrzjqthFxBgH0qearlNt9/K7cGFDTIUelLyHci7ELSt?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SgGc8Ce9QWbAZZr4QCv+yUJBL5EfQng/B7Xv5WydQPjbZVf3VF67dJq8xrRt6u17eQj7f88pxfcQYLXRjghw4v8CXwH91+fGNncJPmdtdTv33q+dXbFT3gQgxt8vJMsLde/T+W3bJE1lgW9BtG2+FTLv5G/LiBO+hViYYCvyu8xwZTZJW1lVC5GkT6Q1T1gLnUDUbE3JOzhBlUhyEW/E+TYJ6nMXMMpR+uq8rXNahDVPTkIrg/WLJYU7JigeYTcWiYKzr2xbRU1GTdirSCtm5DlekuCUG7/+1VrXn3aJBkaKdW+MknKtKWraHtDi5XsCCWdDOqfne2kSjNlwKbjWPJ2xxyFf4x7+0SeY27liwyW7tdo5D9mwul8h1CI+8aS+Hb9f+VvKcQd3gIXXYwqBswwYpS75wXIOTK04wp4BMzOrMiSvh1ASQjuXxMZ+W9+2jBL+av0IVY9C8Xsgj7Vrmf2S4ULydpxzk7NTda4jIg6NYp7c9wGsYVkjpsTLGK+JmizBdTNlBzMkvnwp+X+zAM9aP/O+pZaxwUI1zOd6mBEvIC4kvNUMcD8n4Ch7vRnLO5ujUN6jkTyOJCnjc/sde81KPuJtLwOKx5Wvm9P1qSnj152E21+JaxuRQjIYTgJdyR02HHfoPtOgLG38aSqQjJlAawYqooL4MWxuZHb+4TC6FMlb5tg87wTabxJyB/PVeegKFhbmdcZ5tjl8GwrxRydysXo5lchz8W+aU4o9hpE3S9RBgS4h233IoKOuUmX2hsqMhTasEAmxrU0UFaSPuZQohkZg78XW7sJTAwgyo0szyo6yb2XRvmHhsG6lNb5MXqN8PAXLnN+8rHZl9JgJnEvoLtkoJmxGtcMisVR+JHa+YY17vt7Rb3c5wYTtLPqwO6+UTo1TwRO5mT2swsuVLJP/zD2igYwWa8QojqK4Y8k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3b9725-3d0d-4002-1a19-08db0a302f0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 23:57:06.9429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aayvckv+pcRDE70rXqZipOoAQz3jXXkS56eudz160/LiC2G1J+Sx+LxJtDzFrWpVtxuuc8afmIybUkc0ObPYn6Fp2u4NDVqVALOrTQDE6jE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_10,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=946 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302080202
X-Proofpoint-GUID: -uQ_uHO3IlpFz16kCAc2BYIXAUkSf9EP
X-Proofpoint-ORIG-GUID: -uQ_uHO3IlpFz16kCAc2BYIXAUkSf9EP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Fix the following kernel-doc warnings:
>
> drivers/ufs/core/ufs-mcq.c:87: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_config_mac'
> drivers/ufs/core/ufs-mcq.c:87: warning: Function parameter or member 'max_active_cmds' not described in 'ufshcd_mcq_config_mac'
> drivers/ufs/core/ufs-mcq.c:107: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_req_to_hwq'
> drivers/ufs/core/ufs-mcq.c:107: warning: Function parameter or member 'req' not described in 'ufshcd_mcq_req_to_hwq'
> drivers/ufs/core/ufs-mcq.c:128: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_decide_queue_depth'

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
